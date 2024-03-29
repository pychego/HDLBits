#include"shift_led.h"
#include<stdio.h>

using namespace std;

int main()
{
    led_t led_o;
    led_t led_i = 0xE; // 1110
    const int SHIFT_TIME = 4;   
    int i;
    for(i = 0; i < SHIFT_TIME; i++){
        shift_led(&led_o, led_i);
        led_i = led_o;
        char string[25];
        itoa((unsigned int)led_o & 0xF, string, 2);
        if(i == 2)
            fprintf(stdout, "shift_out=0%s\n", string);
        else
            fprintf(stdout, "shift_out=%s\n", string);
    }
}