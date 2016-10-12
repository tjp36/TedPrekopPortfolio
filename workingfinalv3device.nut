device_switch <- hardware.pin1;
trip_LED <- hardware.pin2;

device_switch.configure(DIGITAL_OUT,0);


power_state <- 0;
local tweet_counter = 0;

local on_timer = null;
local off_timer = null;

function send_tweet(){
    local now = date();

    agent.send("mes", now);
}

 function turn_on(){

         on_timer = imp.wakeup(5.0, turn_on);
         power_state = 1;
         device_switch.write(power_state);


         if(trip_LED.read() == 1){
             server.log("CAT DONE DRINKING.  Shutting off fountain");
             send_tweet();
             imp.cancelwakeup(on_timer);
             start();
         }


 }


trip_LED.configure(DIGITAL_IN_PULLUP);

function start(){
    off_timer = imp.wakeup(2.0, start);
    power_state = 0;

    device_switch.write(power_state);
    if(trip_LED.read() == 0){

        server.log("LED HAS BEEN TRIPPED.  Staring fountain");
        imp.cancelwakeup(off_timer);
        turn_on();
    }

}

start();
