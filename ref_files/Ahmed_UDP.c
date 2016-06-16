#include "netif/xadapter.h"
#include "lwip/err.h"
#include "lwip/udp.h"

#include <stdio.h>

#include "xparameters.h"
#include "xscugic.h"
#include "evaluation_app.h"
#include "downscaler.h"
#include "FaceInfo.h"
#include "xuartps.h"
#include "counter.h"
#include "Fifo.h"

Client* current_client, *next_client;
struct pbuf *pBuffer;
FaceInfo face_info_buffer[60];
u8 face_info_index;
struct udp_pcb *udp;		//a pointer to a UDP header structure
XScuGic ScuGic;
int setup_interrupt();
void start_read_image(EvalCore* eval, u8* address, int x, int y);
//// Call back function for the incoming UDP packet
void udp_recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, ip_addr_t *addr, u16_t port);
void lwip_init();	// missing declaration in lwIP

#define SCALE_TIME 12

int image_count = 0;
u8 cam_buffer1[660 * 480];
u8 cam_buffer2[660 * 480];
u8 *cam_current_buffer;

u8* eval_current_image, *eval_next_image;

u32 last_cam_offset;
u32 cam_max_offset;

u8 downscale_buffer[660 * 480 * 4 / 5];
int ask_waiting;
EvalCore eval0, eval1, eval2;
int current_x, current_y;

u32 new_width, width;
u32 new_height, height;

int setup_interrupt();
void on_image_ready(EvalCore* eval);
void on_eval_ready(EvalCore* eval);
void downscale();

//int with_filter = 2;

u32 time;
u64 counter;
u16 imageId = 0;
int scaleTimes = SCALE_TIME;

#define IDLE 0
#define EVAL_RAM_STATE 2
#define DOWNSCALE_STATE 3

int is_scale_done;
int is_cam_done;
int is_cam_done_cleared;

void idle();
void ram_eval_state();
void downscale_state();
int state;

Fifo fifo;

void ask_client_for_image(Client* c);
u64 get_counter() {
	u64 c = Xil_In32(XPAR_COUNTER_0_BASEADDR + COUNTER_SLV_REG1_OFFSET);
	c = c << 32;
	return c |= Xil_In32(XPAR_COUNTER_0_BASEADDR);
}

void reset_counter() {
	Xil_Out32(XPAR_COUNTER_0_BASEADDR, 0);
}
void printCurrentImage(u8* buffer, u32 wid, u32 hei);
/////////////////////////////////////////////////////////////////////////////////////////
///// These functions are used to print out IP address information /////
void print_ip(char *msg, struct ip_addr *ip) {
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip) , ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(struct ip_addr *ip, struct ip_addr *mask, struct ip_addr *gw) {

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
/////////////////////////////////////////////////////////////////////////////////////////

u32 increment_x_and_y() {
	if (current_y > height - 22)
		return 0;

	//current_x += 24;
	current_x += 8;
	if (current_x > width - 24) {
		current_y += 4;
		if (current_y > height - 22) {
			return 0;
		}
		current_x = 0;
	}
	return 1;
}

int main() {
	/////////////////////////////////////////////////////////////////////////////////////////
	struct netif server_netif;		//variables for network interfaces
	struct ip_addr ipaddr_s, netmask, gw;		//IP addresses storage

	/* the MAC address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	//unsigned char mac_ethernet_address[] = {0x68,0x5B,0x35,0xB7,0xCA,0x9D};

	xil_printf("version = %X\r\n", Xil_In32(XPAR_EVALUATOR_0_BASEADDR + EVAL_VERSION));

	/////////////////////////////////////////////////////////////////////////////////////////
	///// Initialize the Interrupt controller variable
	if (setup_interrupt() != XST_SUCCESS)
		xil_printf("interrupt error\r\n");

	/////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////// Initialize network interface and IP protocol //////////////

	/* Initialize IP addresses to be used: change this between boards*/
	//IP4_ADDR(&ipaddr_s, 192, 168, 2, 11);  //local ip address
	//IP4_ADDR(&ipaddr_s,  130, 149,   224, 6);  //remote ip address
	IP4_ADDR(&ipaddr_s,  130,149,224,26);
	IP4_ADDR(&netmask, 255, 255, 255, 0);
	IP4_ADDR(&gw, 130, 149, 224, 1);
	//IP4_ADDR(&gw, 192, 168, 2, 10);
	//IP4_ADDR(&gw, 130, 149, 224, 43);

	print_ip_settings(&ipaddr_s, &netmask, &gw);
	//print_ip_settings(&ipaddr_d, &netmask, &gw);

	lwip_init();	///////// initialize the light weight IP library

	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(&server_netif, &ipaddr_s, &netmask, &gw, mac_ethernet_address, XPAR_XEMACPS_0_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}

	netif_set_default(&server_netif);	// set the registered MAC interface as the default interface
	netif_set_up(&server_netif);		// specify that the network is up
	///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////Prepare UDB Protocol////////////////////////
	if (NULL == (udp = udp_new()))	//initialize the UDB header
		xil_printf("Problems initializing UDB!\n\r");

	//par1.udp = udp; // fill out the UDP pointer of the interrupt handler input argument
	//par1.ipaddr_s = &ipaddr_s;
	//par1.ipaddr_d = &ipaddr_d;

	if (ERR_OK != udp_bind(udp, &ipaddr_s, 5000))		//initialize the local binding process on port 10024
		xil_printf("Problems binding address!\n\r");

	/// we will use port 10024 for communication using UDB protocol
	/// these calls initialize the connection and binding process

	udp_recv(udp, udp_recv_callback, NULL ); //register the function recv_callback as the call back for incoming functions
											 //this function will be called to process incoming package
	///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////

	//initialize buffer for udp protocol
	pBuffer = pbuf_alloc(PBUF_RAW, sizeof(face_info_buffer), PBUF_REF);
	pBuffer->payload = &face_info_buffer;
	/////////////////////////////////////////////////////////////////////////////////////////
	cam_current_buffer = cam_buffer1;
	last_cam_offset = 100;
	is_cam_done = is_scale_done = 0;
	ask_waiting = -1;

	initialize_eval_core(&eval0, XPAR_EVALUATOR_0_BASEADDR);
	initialize_eval_core(&eval1, XPAR_EVALUATOR_1_BASEADDR);
	initialize_eval_core(&eval2, XPAR_EVALUATOR_2_BASEADDR);

	fifo_init(&fifo);

	while (1) {

		//xil_printf("%d", state);
		switch (state) {
		case EVAL_RAM_STATE:
			//ram_eval_state();
			break;
		case DOWNSCALE_STATE:
			downscale_state();
			break;
		default:
			idle();
			break;
		}

		xemacif_input(&server_netif);  // Process incoming packages if any
		// this function will call udp_recv_callback if any package received
		if (!is_cam_done) {
			if (ask_waiting > 0)
				ask_waiting--;
			else if (ask_waiting == 0) {

				if (next_client == NULL ) {
					xil_printf("next client = null\r\n");
					ask_waiting = -1;
					continue;
				}

				xil_printf("remove client port = %d\r\n", next_client->port_d);

				//	print("fifo enter\r\n");
				fifo_remove_by_address(&fifo, next_client->ipaddr_d.addr, next_client->port_d);
				//print("fifo exit\r\n");
				next_client = NULL;
				ask_client_for_image(fifo_move_to_last(&fifo));
			}
		}
		/*if(fifo.first == NULL){
		 xil_printf("no client connected\r\n");
		 }*/
	}
	///////////////////////////////////////////////////////////////////////////////

	return 0;
}
void print_fifo(Fifo* f) {
	struct FifoElement *e = f->first;
	xil_printf("[");
	while (e != NULL ) {
		xil_printf("port=%d - width=%d- height=%d || ", e->data->port_d, e->data->image_width, e->data->image_height);
		e = e->next;
	}
	xil_printf("]\r\n");
}
u32 windows_number = 0;
void idle() {
	if (is_cam_done && !is_cam_done_cleared) {
		if (current_client->image_width < 50)
			return;
		current_client = next_client;

		//reset_counter();
		//print_fifo(&fifo);
		//print("-");
		face_info_index = is_cam_done = 0;
		is_cam_done_cleared = 1;

		width = current_client->image_width;
		height = current_client->image_height;
		//xil_printf("idle: width = %d, height = %d\r\n", current_client->image_width, current_client->image_height);
		eval_current_image = cam_current_buffer;
		eval_next_image = downscale_buffer;

		scaleTimes = SCALE_TIME;

		current_y = current_x = 0;

		eval0.is_evaluation_done = eval1.is_evaluation_done = eval2.is_evaluation_done = eval0.is_finishing = eval1.is_finishing = eval2.is_finishing = 1;

		//reset_counter();
		//int scale_first = 1;
		//if (scale_first) {
		downscale();
		state = DOWNSCALE_STATE;
		/*} else {
		 is_scale_done = 1;
		 new_height = height;
		 new_width = width;
		 downscale_state();
		 /*start_read_image(&eval0, cam_current_buffer, 0, 0);

		 increment_x_and_y();
		 start_read_image(&eval1, cam_current_buffer, current_x, current_y);

		 increment_x_and_y();
		 start_read_image(&eval2, cam_current_buffer, current_x, current_y);

		 //state = EVAL_RAM_STATE;

		 }*/
		ask_client_for_image(fifo_move_to_last(&fifo));

		//reset_counter();
	}
}

void udp_recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, ip_addr_t *addr, u16_t port) {
	Client* client;
	if (p->len < 20) {
		u16* data = (u16*) p->payload;
		switch (data[0]) {
		case 1:
			//xil_printf("Client connected\r\n");
			client = fifo_find_or_create_client(&fifo, addr->addr, port);
			client->image_width = data[1];
			client->image_height = data[2];

			if (fifo.first->next == NULL ) {
				xil_printf("first client connected: %d, (%d,%d)\r\n", port, client->image_width, client->image_height);
				ask_client_for_image(client);
			}

			break;
		case 2:
			print_fifo(&fifo);
			windows_number = 0;
			fifo_remove_by_address(&fifo, addr->addr, port);

			xil_printf("stoped, state = %d, port = %d, ask_waiting = %d, current state=%d\r\n", state, port, ask_waiting, state);

			break;
		}
		pbuf_free(p);
		return;
	}

	u32 offset = *(u32*) p->payload;

	u8* ptr = cam_current_buffer + offset;
	u16 size = p->len - 4;
	memcpy(ptr, ((u8*) p->payload) + 4, size);
	pbuf_free(p);

	//Xil_DCacheFlushRange(ptr, size);
	//print("*");
	ask_waiting = 909000;
	//Xil_DCacheInvalidateRange(ptr, size);
	if (offset >= cam_max_offset)
	{

		//Xil_DCacheFlushRange(cam_current_buffer, offset + size);
		Xil_DCacheFlush();
		is_cam_done = !is_cam_done_cleared;
		xil_printf("%d Image Received\n\r",image_count++);

	}
	else if (offset < last_cam_offset) {
		cam_current_buffer = cam_current_buffer == cam_buffer1 ? cam_buffer2 : cam_buffer1;		//swap buffer
		is_cam_done_cleared = 0;
	}
	last_cam_offset = offset;
}

void ask_client_for_image(Client* c) {
	if (c == NULL ) {
		print_fifo(&fifo);
		xil_printf("stop!!\r\n");
		ask_waiting = -1;
		return;
	}

	//xil_printf("ask c.port = %d\r\n", c->port_d);
	//xil_printf("set ask_waiting to 1909000, client port asked = %d\r\n", c->port_d);

	next_client = c;

	pBuffer->tot_len = pBuffer->len = 1;
	face_info_buffer[0].x = 0x0101;
	udp_sendto(udp, pBuffer, &c->ipaddr_d, c->port_d);

	cam_max_offset = c->image_width * c->image_height - 512 * 4;

	ask_waiting = 1909000;
}

void process_evaluator(EvalCore* eval) {
	if (!eval->is_finishing && eval->is_evaluation_done && eval->is_ram_done) {
		//subWindow_count++;

		switch_buffer(eval);

		/*if (eval == &eval0) {
		 xil_printf("%d\r\n", Xil_In32(XPAR_COUNTER_0_BASEADDR));
		 reset_counter();
		 }*/

		u32 can_read_image = increment_x_and_y();
		if (can_read_image) {

			u8* addr = eval_current_image + current_x + current_y * width;
			read_image_async(eval, addr, current_x, current_y);
		} else {
			trigger_switch_buffer_in_hardware(eval); //switch buffer
			state = DOWNSCALE_STATE;
			eval->is_finishing = 1;
		}

		evaluate_async(eval);
	}
	//return eval->is_finishing && eval->is_evaluation_done && eval->is_ram_done;
}
//u32 tmp = 0;
//int donee = 0;
void downscale_state() {
	/*if (!donee && is_scale_done && eval0.is_finishing && eval0.is_evaluation_done && eval1.is_finishing && eval1.is_evaluation_done && eval2.is_finishing && eval2.is_evaluation_done) {
		donee = 1;
		tmp += Xil_In32(XPAR_COUNTER_0_BASEADDR);
		//xil_printf("diff = %d\r\n", Xil_In32(XPAR_COUNTER_0_BASEADDR));
	}*/
	if (is_scale_done && eval0.is_finishing && eval0.is_evaluation_done && eval1.is_finishing && eval1.is_evaluation_done && eval2.is_finishing && eval2.is_evaluation_done)
	{
		//print("Enter state\r\n");
		//reset_counter();
		//donee = 0;
		is_scale_done = 0;

		if (new_width >= 22 && new_height >= 22 && scaleTimes > 1)
		{
			state = EVAL_RAM_STATE;
			scaleTimes--;
			u8* tmp = eval_current_image;
			eval_current_image = eval_next_image;
			eval_next_image = tmp;

			//xil_printf("(%d,%d) => (%d,%d)\r\n", width, height, new_width, new_height);

			width = new_width;
			height = new_height;

			//reset_counter();
			//if(height < 40)
			//print("------------------------------------------------------------------------\r\n");

			start_read_image(&eval0, eval_current_image, 0, 0);
			current_x = 0;
			current_y = 0;
			increment_x_and_y();
			start_read_image(&eval1, eval_current_image, current_x, current_y);

			increment_x_and_y();
			start_read_image(&eval2, eval_current_image, current_x, current_y);

			eval0.is_evaluation_done = eval1.is_evaluation_done = eval2.is_evaluation_done = 1;

			downscale();
		}
		else
		{

			//xil_printf("diff = %d\r\n", Xil_In32(XPAR_COUNTER_0_BASEADDR));
			//xil_printf(" window count = %d\r\n",windows_number);
			state = IDLE;
			//print("+");
			pBuffer->tot_len = pBuffer->len = sizeof(FaceInfo) * face_info_index;

			//	printCurrentImage(eval_current_image, width, height);
			//xil_printf("isub windows count %d\r\n", subWindow_count);

			//xil_printf("tmp = %d\r\n", tmp);
			//tmp = 0;
			udp_sendto(udp, pBuffer, &current_client->ipaddr_d, current_client->port_d);
			xil_printf("Sending back some results\r\n");
			//xil_printf("send end\r\n");
			//print_fifo(&fifo);

		}
	}
}

void on_eval_ready(EvalCore* eval) {
	/*if (eval == &eval0) {
	 xil_printf("%d\r\n", Xil_In32(XPAR_COUNTER_0_BASEADDR));
	 //reset_counter();
	 }*/

	clear_eval_ready_interrupt(eval);

	eval->is_ram_done = 1;
	process_evaluator(eval);
}

void on_image_ready(EvalCore* eval) {

	//clear interrupt
	clear_image_ready_interrupt(eval);
	//print("-");
	//face detected
	u32 detectedFace = is_face_detected(eval);
	/*if (height < 40) {
	 xil_printf("(%d,%d)=%X == %X, eval = %X, address=%X\r\n", eval->x, eval->y, detectedFace, Xil_In32(eval->base_address), eval->base_address,  eval->eval_address);
	 }*/
	windows_number++;
	//xil_printf("0x%X", detectedFace);
	if (detectedFace) {
		FaceInfo* face;
		if (detectedFace & 0x10) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x;
			face->y = eval->y;
			face_info_index++;
			//print("3");
		}
		if (detectedFace & 8) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x + 4;
			face->y = eval->y;
			face_info_index++;
			//print("2");
		}

		if (detectedFace & 4) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x;
			face->y = eval->y + 2;
			face_info_index++;
			//print("1");
		}

		if (detectedFace & 2) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x + 4;
			face->y = eval->y + 2;
			face_info_index++;
			//print("8");
		}

		if (detectedFace & 1) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x + 2;
			face->y = eval->y;
			face_info_index++;
			//print("8");
		}

		if (detectedFace & 32) {
			face = face_info_buffer + face_info_index;
			face->image_height = height;
			face->image_width = width;
			face->x = eval->x + 2;
			face->y = eval->y + 2;
			face_info_index++;
			//print("8");
		}

	}

	/*if (eval == &eval0){
	 xil_printf("%d\r\n", Xil_In32(XPAR_COUNTER_0_BASEADDR));
	 }*/
	//xil_printf("is_eval_done = 1");
	eval->is_evaluation_done = 1;
	//print("e");
	process_evaluator(eval);

}

void on_scale_done() {
	//u32 ticks = Xil_In32(XPAR_COUNTER_0_BASEADDR);
	//xil_printf("on_scale_done size=(%d,%d)\r\n", new_width, new_height);
	//clear interrupt
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_INTERRUPT, 0);

	/*if (scaleTimes == 10) {
	 printCurrentImage(eval.next_buffer, new_width, new_height);
	 }*/
	is_scale_done = 1;
}

void downscale() {
	//reset_counter();

	new_width = width * 4 / 5;
	new_height = height * 4 / 5;
	new_width = new_width - (new_width % 4);

	if (width % 5 == 4)
		new_width += 4;

	//xil_printf("scale now (%d, %d) => (%d, %d)\r\n", width, height, new_width, new_height);

	if (new_width <= 22 || new_width <= 22 || scaleTimes <= 1) {
		is_scale_done = 1;
		//xil_printf("scale done");
		return;
	}

	//set image width
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_IMAGE_WIDTH, width);

	//set image height
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_IMAGE_HEIGHT, height);

	//set src addr
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_SRC_ADDR, (u32) eval_current_image);

	//set dst addr
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_DST_ADDR, (u32) eval_next_image);

	//start with no filter
	Xil_Out32(XPAR_DOWN_SCALE_MASTER_0_BASEADDR + DOW_CMD, 3);

	is_scale_done = 0;

	//reset_counter();
}

void start_read_image(EvalCore* eval, u8* address, int x, int y) {
	//if (x > (640 - 25) || y > (480 - 23))
	//xil_printf("read error at (%d,%d)\r\n", x, y);
	/*if(height < 40){
	 xil_printf("start read aval = %X = %X\r\n",eval->base_address, (address + x + y * width));
	 }*/
	eval->is_finishing = 0;
	set_buffer(eval, BUFFER1);
	set_image_width(eval, width);
	read_image_async(eval, address + x + y * width, x, y);
}

void printCurrentImage(u8* buffer, u32 wid, u32 hei) {
	Xil_DCacheInvalidateRange(buffer, hei * wid);

	xil_printf("\r\nResult= %dx%d\r\n", wid, hei);
	//xil_printf("unsigned char* img[] = {\r\n", stride, height);
	u8* ptr = buffer;
	int y, x;
	for (y = 0; y < hei; y++) {
		for (x = 0; x < wid; x++) {
			xil_printf("%d,", *ptr);
			ptr++;
		}
		xil_printf("\r\n");
	}
}

int setup_interrupt() {
	int Status;
	XScuGic_Config *GicConfig;

	Xil_ExceptionDisable();

	Xil_ExceptionInit();

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	GicConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(&ScuGic, GicConfig, GicConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Connect the interrupt controller interrupt handler to the hardware
	 * interrupt handling logic in the processor.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, &ScuGic);

	/*
	 * Connect the Done ISR for all 8 channels of DMA 0
	 */

	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_0_IMAGE_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_image_ready, (void*) &eval0);
	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_0_EVAL_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_eval_ready, (void*) &eval0);
	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_1_IMAGE_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_image_ready, (void*) &eval1);
	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_1_EVAL_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_eval_ready, (void*) &eval1);
	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_2_IMAGE_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_image_ready, (void*) &eval2);
	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_EVALUATOR_2_EVAL_READY_INTERRUPT_INTR, (Xil_InterruptHandler) on_eval_ready, (void*) &eval2);

	Status |= XScuGic_Connect(&ScuGic, XPAR_FABRIC_DOWN_SCALE_MASTER_0_RESIZE_DONE_INTERRUPT_INTR, (Xil_InterruptHandler) on_scale_done, (void*) 0);
	//if (Status != XST_SUCCESS)
	//return XST_FAILURE;
	/*
	 * Enable the interrupts for the device
	 */
	//XScuGic_Enable(&ScuGic, XPAR_FABRIC_CAMERA_MASTER_0_IMAGE_READY_INTR);
	//XScuGic_Enable(&ScuGic, XPAR_FABRIC_CAMERA_MASTER_0_LINE_READY_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_0_IMAGE_READY_INTERRUPT_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_0_EVAL_READY_INTERRUPT_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_1_IMAGE_READY_INTERRUPT_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_1_EVAL_READY_INTERRUPT_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_2_IMAGE_READY_INTERRUPT_INTR);
	XScuGic_Enable(&ScuGic, XPAR_FABRIC_EVALUATOR_2_EVAL_READY_INTERRUPT_INTR);

	XScuGic_Enable(&ScuGic, XPAR_FABRIC_DOWN_SCALE_MASTER_0_RESIZE_DONE_INTERRUPT_INTR);
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}
