module TopModule (
    input  mode,      // 1=heating, 0=cooling
    input  too_cold,  // 1=temperature too cold
    input  too_hot,   // 1=temperature too hot
    input  fan_on,    // 1=user requests fan on
    output heater,    // 1=heater on
    output aircon,    // 1=air conditioner on
    output fan        // 1=fan on
);

    // Heater: ON when in heating mode (mode=1) AND too_cold
    // Never turn on heater in cooling mode
    assign heater = mode & too_cold;

    // Air conditioner: ON when in cooling mode (mode=0) AND too_hot
    // Never turn on aircon in heating mode
    assign aircon = ~mode & too_hot;

    // Fan: ON when heater is on, OR aircon is on, OR user requests it
    // This ensures fan runs whenever heating/cooling is active,
    // plus allows manual fan control
    assign fan = heater | aircon | fan_on;

endmodule
