/*
 * net_main.h
 *
 *  Created on: Jun 16, 2016
 *      Author: CoBoL
 */

#ifndef NET_MAIN_H_
#define NET_MAIN_H_

#include <stdio.h>
#include <string.h>
#include "lwip/udp.h"
#include "xparameters.h"
#include "netif/xadapter.h"
#include "platform.h"
#include "platform_config.h"
#include "lwipopts.h"
#ifndef __PPC__
#include "xil_printf.h"
#endif
#include "lwip/stats.h"

int net_init(struct udp_pcb *udp_1,struct netif *netif);
void udp_recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, ip_addr_t *addr, u16_t port);


#endif /* NET_MAIN_H_ */
