/*
 * main.c
 *
 *  Created on: Aug 1, 2014
 *      Author: 910560
 */

#include "video/demo.h"
#include "video/avnet_console.h"
#include "video/avnet_console_serial.h"

#include "audio/audio.h"

#include "net/net_main.h"

demo_t demo;
demo_t *pdemo;

AudioData_t* AudioPuf;

volatile int TxPerfConnMonCntr;
volatile int TcpFastTmrFlag;
volatile int TcpSlowTmrFlag;
struct netif *echo_netif;
struct udp_pcb *udp_1;
struct netif *udp_netif;

struct pbuf  *NetPuf;
int buflen;


int main()
{
	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--              AudioChip(ADAU1761)                 --\n\r");
	xil_printf("--             Getting Started Design               --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");

	Audio_init();

	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--                Gigabit-Ethernet                  --\n\r");
	xil_printf("--              Getting Started Design              --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");

	net_init(udp_1,udp_netif);
	//register the function recv_callback as the call back for incoming functions
	//this function will be called to process incoming package
	udp_recv(udp, udp_recv_callback, NULL );

	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--                    FMC-IMAGEON                   --\n\r");
	xil_printf("--               Getting Started Design             --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");


	pdemo = &demo;
	demo_init( pdemo );

	// Init reference design
	demo_init_frame_buffer(pdemo);

	// Try CAM first
	pdemo->cam_alpha = 0xFF;
	pdemo->hdmi_alpha = 0x00;
	if ( !demo_start_cam_in(pdemo) )
	{
		// Then try HDMI
		pdemo->cam_alpha = 0x00;
		pdemo->hdmi_alpha = 0xFF;
		demo_start_hdmi_in(pdemo);
	}
	demo_start_frame_buffer(pdemo);

	// Start serial console
	print_avnet_console_serial_app_header();
	start_avnet_console_serial_application();

	 buflen = sizeof(AudioPuf);

	xemacif_input(udp_netif);
	AudioPuf = malloc(sizeof(AudioData_t));
	if (!AudioPuf) {
		xil_printf("error allocating AudioPuf\r\n");
	}
	NetPuf = pbuf_alloc(PBUF_TRANSPORT, buflen, PBUF_POOL);
	if (!NetPuf) {
		xil_printf("error allocating NetPuf\r\n");
	}
	NetPuf->payload = (void *) AudioPuf;

	while (1)
	{
		read_play(AudioPuf);

//		memcpy(NetPuf->payload, AudioPuf , buflen);
		udp_send(udp_1, NetPuf);
		// needs delay before sending again  think
		if (transfer_avnet_console_serial_data()) {
			break;
		}


	}

	return 0;

//    xil_printf("\r\n\tPress 0-9 to change alpha blending of hdmi/camera layers\r\n");
//	xil_printf("\r\n\tPress ENTER to restart\r\n\r\n" );
//	c = getchar();

//	if ( c >= '0' && c <= '9' )
//	{
//		camera_alpha = (c - '0') * 28;
//		hdmi_alpha    = ('9' - c) * 28;
//	}

//	if ( c == '+' )
//	{
//		if ( pdemo->pvita_receiver->uManualTap < 31 )
//			pdemo->pvita_receiver->uManualTap++;
//		xil_printf( "\tuManualTap = %d\n\r", pdemo->pvita_receiver->uManualTap );
//	}
//	if ( c == '-' )
//	{
//		if ( pdemo->pvita_receiver->uManualTap > 0 )
//			pdemo->pvita_receiver->uManualTap--;
//		xil_printf( "\tuManualTap = %d\n\r", pdemo->pvita_receiver->uManualTap );
//	}
//}

	//return 0;
}
