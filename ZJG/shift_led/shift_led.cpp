#include"shift_led.h"

void shift_led(led_t *led_o, led_t led_i) {
    led_t tmp_led;
    cnt32_t i; // for 循环的延时变量
    tmp_led = led_i;
    for (i = 0; i < MAX_CNT; i++) {
        if(i == SHIFT_FLAG){
            tmp_led = ((tmp_led >> 3) & 0x1) + ((tmp_led << 1) & 0xE); // 左移
            *led_o = tmp_led;
        }
    }
}
