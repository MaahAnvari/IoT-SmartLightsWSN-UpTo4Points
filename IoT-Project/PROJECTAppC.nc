
#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration PROJECTAppC {
}
implementation {
components new TimerMilliC() as Controller;
components new TimerMilliC() as Light2;
components new TimerMilliC() as Light3;
components new TimerMilliC() as Light4;
components new TimerMilliC() as Light5;
components new TimerMilliC() as Light6;
components new TimerMilliC() as Light7;
components new TimerMilliC() as Light8;
components new TimerMilliC() as Light9;
components new TimerMilliC() as Light10;
components MainC, PROJECT as App, PROJECT, LedsC;		//change this part
components new AMSenderC(AM_RADIO_COUNT_MSG);
components new AMReceiverC(AM_RADIO_COUNT_MSG);
components PrintfC;
components SerialStartC;

components ActiveMessageC;

PROJECT -> MainC.Boot;

App.Receive -> AMReceiverC;
App.AMSend -> AMSenderC;
App.AMControl -> ActiveMessageC;
PROJECT.Controller -> Controller;
PROJECT.Light2 -> Light2;
PROJECT.Light3 -> Light3;
PROJECT.Light4 -> Light4;
PROJECT.Light5 -> Light5;
PROJECT.Light6 -> Light6;
PROJECT.Light7 -> Light7;
PROJECT.Light8 -> Light8;
PROJECT.Light9 -> Light9;
PROJECT.Light10 -> Light10;
PROJECT.Leds -> LedsC;
App.Packet -> AMSenderC;
}





