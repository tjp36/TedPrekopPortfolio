#require "Twitter.class.nut:1.2.1"

const API_KEY = "5jk5GDhOMYrGYMPArX3PpCuTH";
const API_SECRET = "DB8StDONFYDhfBiwjHvSDQHjvVtY5KkOYK70IZypQi7L2kDSk7";
const AUTH_TOKEN = "704045277057953792-5qoMzGkjPZ0zj5azPPGReCrdEBl3Oce";
const TOKEN_SECRET = "A1PbN0hIPiXOTLr5CSqEh5D76oFcog5RRHr2sSdwV72Lv";
twitter <- Twitter(API_KEY, API_SECRET, AUTH_TOKEN, TOKEN_SECRET);






function mesHandler(now){
    local cur_hour = now.hour - 6;
    local cur_min = "";
    local cur_sec = "";
    local am_pm = "";

    if(cur_hour > 12){
        cur_hour = cur_hour - 12;
        am_pm = "pm";
    }
    else{
        am_pm = "am";
    }

    if(now.min < 10){
        cur_min = "0" + now.min.tostring();
    }
    else{
        cur_min = now.min.tostring();
    }

    if(now.sec < 10){
        cur_sec = "0" + now.sec.tostring();
    }
    else{
        cur_sec = now.sec.tostring();
    }

    if(cur_hour % 10 == 0){
        twitter.tweet("Ever gotten cottonmouth from catnip? #YOLO + " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 1){
        twitter.tweet("#PURRRRR. H20 Time !" + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 2){
        twitter.tweet("#MEOW. I'm thirsty! Drinking water at: " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 3){
        twitter.tweet("Who's the bestest kitty? I am! Pounding water at " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 4){
        twitter.tweet("Just ate a MOUSE!!! I deserve a drink " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 5){
        twitter.tweet("I AM A GOLDEN CAT GOD.  And a thirsty one: " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 6){
        twitter.tweet("Feline dehydrated.  Refilling: " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 7){
        twitter.tweet("#CATLIVESMATTER.  Imbibing: " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 8){
        twitter.tweet("No more toilet paws!  Go me! " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
    if(cur_hour % 10 == 9){
        twitter.tweet("Cats Rule, Dogs Drool. " + cur_hour.tostring() + ":" + cur_min + ":" + cur_sec + am_pm);
    }
}

device.on("mes", mesHandler);
