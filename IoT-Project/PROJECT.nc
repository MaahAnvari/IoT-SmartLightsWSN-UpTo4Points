 
#include "Timer.h"
#include "PROJECT.h"
#include "printf.h"	


#define CONTROLLER 	1
#define LIGHT2     	2
#define LIGHT3     	3
#define LIGHT4  	4
#define LIGHT5  	5
#define LIGHT6  	6
#define LIGHT7  	7
#define LIGHT8  	8
#define LIGHT9  	9
#define LIGHT10 	10

#define RESET0    	0
#define CROSS    	1
#define RESET1    	2
#define TRIANGLE 	3
#define RESET2    	4
#define SLASH    	5


module PROJECT @safe() {

  uses {
    interface Timer<TMilli> as Controller;
  
    interface Timer<TMilli> as Light2;
    interface Timer<TMilli> as Light3;
    interface Timer<TMilli> as Light4;
    
    interface Timer<TMilli> as Light5;
    interface Timer<TMilli> as Light6;
    interface Timer<TMilli> as Light7;
    
    interface Timer<TMilli> as Light8;
    interface Timer<TMilli> as Light9;
    interface Timer<TMilli> as Light10;
    
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Packet;
  }
}


implementation {

  message_t packet;

  bool locked;
  uint16_t counter = 1;
  uint16_t topology = 0;
  uint16_t sender_id = CONTROLLER;
  uint16_t c2 = 1;
  uint16_t c5 = 1;
  uint16_t c8 = 1;

 
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Controller.startPeriodic(100);
      call Light2.startPeriodic(100);
      call Light3.startPeriodic(101);
      call Light4.startPeriodic(102);
      call Light5.startPeriodic(103);
      call Light6.startPeriodic(104);
      call Light7.startPeriodic(105);
      call Light8.startPeriodic(106);
      call Light9.startPeriodic(107);
      call Light10.startPeriodic(108);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
  
  event void Controller.fired() {
  
  	

    if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) return;
      
      //printf("        Controller: %u,%u,%d\n", TOS_NODE_ID, CONTROLLER, topology);
		if(TOS_NODE_ID == CONTROLLER){
		
			rcm->mote = CONTROLLER;
			sender_id = CONTROLLER;
			
			  if(1){   // change topology if all the nodes recived the message
			  //c1 && c2 && c3
			  		
				//topology = topology +1;
			  }
			  
			  rcm->topology = topology;
			if(counter == 1){
		  		if (call AMSend.send(LIGHT2, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		printf("Controller Fired running topology  %u send data to the Mote %u\n", topology, LIGHT2 );
		  	}
		  	if(counter == 2){
		  		if (call AMSend.send(LIGHT5, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		printf("Controller Fired running topology  %u send data to the Mote %u\n", topology, LIGHT5);
		  	}
		  	if(counter == 3){
		  		if (call AMSend.send(LIGHT8, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;				  				  	printf("Controller Fired running topology  %u send data to the Mote %u\n", topology, LIGHT8);
		  	}
		  	
			if(counter % 3 != 0){
				counter = counter+1;
			} else  {
				counter = 1;
					
				//if(c2 == 2 && c5 == 2 && c8 == 2) {
					if (topology == SLASH) {
						topology = RESET0;
					} else	topology = topology +1;
				//}  
			}
			
			
		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		
      	}
    }
    printfflush();
  }

  event void Light2.fired() {
      	//printf("light2 fired\n");
    if (locked) return;
    else {
	    radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
        printf("        light2: %u,%u, %d\n", TOS_NODE_ID, LIGHT2, topology);
		if(TOS_NODE_ID == LIGHT2){
			rcm->mote = LIGHT2;
			rcm->topology = topology;
			rcm->sender_id = LIGHT2;
			rcm->c2 = c2;
			if(c2 == 1){
		  		if (call AMSend.send(LIGHT3, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		c2++;
		  	}
		  	if(c2 == 2){
		  		c2 = 1;
		  		if (call AMSend.send(LIGHT4, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		
		  	}
		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
    }
    printfflush();
  }

event void Light5.fired() {   
     	//printf("light5 fired\n");
    if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
    	printf("        light5: %u,%u, %d\n", TOS_NODE_ID, LIGHT5, topology);
		if(TOS_NODE_ID == LIGHT5){
			rcm->mote = LIGHT5;
			rcm->topology = topology;
			rcm->sender_id = LIGHT5;
			rcm->c5 = c5;
			if(c5 == 1){
		  		if (call AMSend.send(LIGHT6, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		c5 ++;
		  	}
		  	if(c5 == 2){
		  		if (call AMSend.send(LIGHT7, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		c5 = 1;
		  	}
		  	if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
   }
   printfflush();
}


event void Light8.fired() {   
     	//printf("light8 fired\n");
    if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
    	printf("        light8: %u,%u, %d\n", TOS_NODE_ID, LIGHT8, topology);
		if(TOS_NODE_ID == LIGHT8){
			rcm->mote = LIGHT8;
			rcm->topology = topology;
			rcm->sender_id = LIGHT8;
			rcm->c8 = c8;
			if(c8 == 1){
		  		if (call AMSend.send(LIGHT9, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		c8 ++;
		  	}
		  	if(c8 == 2){
		  		if (call AMSend.send(LIGHT10, &packet, sizeof(radio_count_msg_t)) == SUCCESS) locked = TRUE;
		  		c8 = 1;
		  	}
		  	if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		}
   }
   printfflush();
}
event void Light3.fired() {
      	//printf("light3\n");
      	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
          	//printf("        light3: %u,%u, %d\n", TOS_NODE_ID, LIGHT3, topology);
      if(TOS_NODE_ID == LIGHT3){
			//rcm->mote = LIGHT3;
			rcm->topology = topology;
			//rcm->sender_id = LIGHT3;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}

event void Light4.fired() {
  	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
      //printf("        light4: %u,%u, %d\n", TOS_NODE_ID, LIGHT4, topology);
      if(TOS_NODE_ID == LIGHT4){
			rcm->mote = LIGHT4;
			rcm->topology = topology;
			rcm->sender_id = LIGHT4;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}
event void Light6.fired() {
  //    	printf("light6\n");
      	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
      //printf("        light6: %u,%u, %d\n", TOS_NODE_ID, LIGHT6, topology);
      if(TOS_NODE_ID == LIGHT6){
			rcm->mote = LIGHT6;
			rcm->topology = topology;
			rcm->sender_id = LIGHT6;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}
event void Light7.fired() {
   	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
      //printf("        light6: %u,%u, %d\n", TOS_NODE_ID, LIGHT6, topology);
      if(TOS_NODE_ID == LIGHT6){
			rcm->mote = LIGHT6;
			rcm->topology = topology;
			rcm->sender_id = LIGHT6;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}
event void Light9.fired() {
  	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
      //printf("        light6: %u,%u, %d\n", TOS_NODE_ID, LIGHT6, topology);
      if(TOS_NODE_ID == LIGHT6){
			rcm->mote = LIGHT6;
			rcm->topology = topology;
			rcm->sender_id = LIGHT6;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}
event void Light10.fired() {
  	if (locked) return;
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
      if (rcm == NULL) 	return;
      //printf("        light6: %u,%u, %d\n", TOS_NODE_ID, LIGHT6, topology);
      if(TOS_NODE_ID == LIGHT6){
			rcm->mote = LIGHT6;
			rcm->topology = topology;
			rcm->sender_id = LIGHT6;

		  	//if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS)	locked = TRUE;
		  
		}
		}
      	printfflush();
}
/*---------------------------------------------------------------------------------------*/

event message_t* Receive.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) {
   // dbg("RadioCountToLedsC", "Received packet of length %hhu.\n", len);
    if (len != sizeof(radio_count_msg_t)) {return bufPtr;}
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)payload;
      
    printf("rcm: Mote %u, Mote topology %u,  new topology   %u\n",TOS_NODE_ID,topology, rcm->topology);
 	
 	if (rcm->mote == LIGHT2 && TOS_NODE_ID == CONTROLLER) 		c2 = rcm->c2;
 	if (rcm->mote == LIGHT5 && TOS_NODE_ID == CONTROLLER)		c5 = rcm->c5;
	if (rcm->mote == LIGHT8 && TOS_NODE_ID == CONTROLLER) 		c8 = rcm->c8;
 		
 	if (rcm->mote == CONTROLLER){
 		if( TOS_NODE_ID == LIGHT2 || TOS_NODE_ID == LIGHT5 || TOS_NODE_ID == LIGHT8)   topology = rcm->topology;
  		//printf("set topology on light --------------------- %u     %u    %u\n", topology, TOS_NODE_ID, rcm->mote); 
  		if (TOS_NODE_ID == LIGHT2){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				//call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				//call Leds.led2On();
  			}
  		}
  		if(TOS_NODE_ID == LIGHT5){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				//call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				//call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				call Leds.led2On();
  			}
  		}
  		if(TOS_NODE_ID == LIGHT8){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				//call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				//call Leds.led2On();
  			}
  		}
  	}
 	
  	if (rcm->mote == LIGHT2){
  	printf("Mote 222222222222222222222222222\n");
  		if(TOS_NODE_ID == LIGHT3){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  					//call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				//call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				call Leds.led2On();
  			}
  		}
  		if(TOS_NODE_ID == LIGHT4){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				//call Leds.led2On();
  			}
  		}
  	}
  	if (rcm->mote == LIGHT5){
  	printf("Mote 5555555555555555555\n");
  		if(TOS_NODE_ID == LIGHT6){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				call Leds.led2On();
  			}
  		}
  		if(TOS_NODE_ID == LIGHT7){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				//call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				call Leds.led2On();
  			}
  		}
  	}
  	if (rcm->mote == LIGHT8){
  	printf("Mote 8888888888888888888888\n");
  		if(TOS_NODE_ID == LIGHT9){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  					//call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				//call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  			call Leds.led2On();
  			}
  		}
  		if(TOS_NODE_ID == LIGHT10){
  			if(rcm->topology == RESET0 || rcm->topology == RESET1 || rcm->topology == RESET2){
  					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2Off();
  			}
  			if(rcm->topology == CROSS){
  				call Leds.led0On();
  			}
  			if(rcm->topology == TRIANGLE){
  				call Leds.led1On();
  			}
  			if(rcm->topology == SLASH){
  				//call Leds.led2On();
  			}
  		}
  		}
  	

	printfflush();
      
      return bufPtr;
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

}

