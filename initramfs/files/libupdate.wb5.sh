#!/bin/bash

PWM_BUZZER=3

# 3 kHz, 2% volume
DUTY_CYCLE=3333
PERIOD=333333

buzzer_init() {
    echo $PWM_BUZZER > /sys/class/pwm/pwmchip0/export 2>/dev/null || true
    while [[ ! -f /sys/class/pwm/pwmchip0/pwm${PWM_BUZZER}/duty_cycle ]]; do sleep 0.1; done

    echo $DUTY_CYCLE > /sys/class/pwm/pwmchip0/pwm${PWM_BUZZER}/duty_cycle
    echo $PERIOD > /sys/class/pwm/pwmchip0/pwm${PWM_BUZZER}/period
}

buzzer_on() {
    echo 1 > /sys/class/pwm/pwmchip0/pwm${PWM_BUZZER}/enable
}

buzzer_off() {
    echo 0 > /sys/class/pwm/pwmchip0/pwm${PWM_BUZZER}/enable
}

button_init() {
    true
}

button_read() {
    memdump 0x800440c2 1 | od -t x1 -A n | dd bs=1 skip=1 count=1 2>/dev/null
}

button_up() {
    [ `button_read` == 1 ]
}

button_down() {
    [ `button_read` == 3 ]
}
