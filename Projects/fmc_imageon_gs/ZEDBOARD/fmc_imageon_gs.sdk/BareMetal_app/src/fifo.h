/*
 * fifo.h
 *
 *  Created on: Jun 16, 2016
 *      Author: CoBoL
 */

#ifndef FIFO_H_
#define FIFO_H_

int fifo_index = 0;

typedef struct {
	ip_addr_t ipaddr_d;
	u16_t port_d;
	u32 audio[2];
} Client;

struct FifoElement {
	Client* data;
	struct FifoElement* next;
};

typedef struct {
	struct FifoElement* first, *last;
} Fifo;

Client* clientArr[10];

Client* myMalloc(){
	if(fifo_index == 0)
		return malloc(sizeof(struct FifoElement));
	else{
		fifo_index--;
		return clientArr[fifo_index];
	}
}

void myFree(Client* c){
	if(fifo_index>=10){
		free(c);
	}
	else{
		clientArr[fifo_index] = c;
		fifo_index++;
	}
}

void fifo_init(Fifo* fifo) {
	//Fifo* f = malloc(sizeof(Fifo));
	fifo->first = NULL;
	fifo->last = NULL;
}

void fifo_put(Fifo* fifo, Client* c) {
	struct FifoElement* e = malloc(sizeof(struct FifoElement));
	e->data = c;
	e->next = NULL;
	if (fifo->last == NULL) {
		fifo->last = fifo->first = e;
	} else {
		fifo->last->next = e;
		fifo->last = e;
	}
}

Client* fifo_move_to_last(Fifo* fifo) {
    if (fifo->first == NULL)
        return NULL;

    struct FifoElement* tomove = fifo->first;

    if(fifo->last == fifo->first)
        return fifo->first->data;
    else if (fifo->last != NULL) {
        fifo->last->next = fifo->first;
        fifo->last = fifo->first;
        fifo->first = fifo->first->next;

        tomove->next = NULL;
    }

    return tomove->data;
}


Client* fifo_find(Fifo* fifo, u32_t addr, u16_t port) {
	struct FifoElement* e = fifo->first;
	while (e != NULL) {
		if(e->data->ipaddr_d.addr == addr && e->data->port_d == port)
			return e->data;
		e = e->next;
	}
	return NULL;
}

Client* fifo_find_or_create_client(Fifo* fifo, u32_t addr, u16_t port) {
	Client* c = fifo_find(fifo, addr, port);
	if(c == NULL){
		//xil_printf("malloc\r\n");
		c = malloc(sizeof(Client));
		c->ipaddr_d.addr = addr;
		c->port_d = port;
		fifo_put(fifo, c);
	}
	//else xil_printf("found\r\n");
	return c;
}


void fifo_remove_by_address(Fifo* fifo, u32_t addr, u16_t port){
    struct FifoElement* e = fifo->first, *last = NULL;
   // xil_printf("ref a=%X, port=%d\r\n", addr, port);
    while (e != NULL) {
    	//xil_printf("a=%X, port=%d\r\n", e->data->ipaddr_d.addr, e->data->port_d);
        if(e->data->ipaddr_d.addr == addr && e->data->port_d == port){
            if (last == NULL) {
                if(fifo->first == fifo->last)
                    fifo->first = fifo->last = NULL;
                else
                    fifo->first = fifo->first->next;
            } else {
                last->next = e->next;
                if (e->next == NULL) {
                    fifo->last = last;
                }
            }
            //xil_printf("free\r\n");
            free(e->data);
            free(e);
            return;
        }
        last = e;
        e = e->next;
    }
}

/*void fifo_remove(Fifo* fifo, Client* c) {
	struct FifoElement* e = fifo->first;
	struct FifoElement* last = NULL;
	while (e != NULL) {
		if (e->data == c) {
			if (last == NULL) {
				fifo->first = fifo->last = NULL;
			} else {
				last->next = e->next;
				if (e->next == NULL) {
					fifo->last = last;
				}
			}
			free(e);
			return;
		}
		last = e;
		e = e->next;
	}
}*/

Client* fifo_get(Fifo* fifo) {

	if (fifo->first == NULL)
		return NULL;

	Client* e = fifo->first->data;
	struct FifoElement* todelete = fifo->first;
	fifo->first = fifo->first->next;

	free(todelete);
	return e;
}

void free_fifo(Fifo* fifo) {
	while (fifo->first != NULL) {
		struct FifoElement* e = fifo->first;
		fifo->first = fifo->first->next;
		free(e);
	}
	free(fifo);
}


#endif /* FIFO_H_ */
