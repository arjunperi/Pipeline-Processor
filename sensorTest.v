module sensor(sensor, light);

input sensor;
output light;

//lights up an LED when sensor is high
and buttonPressed(light, sensor, 1'b1);

endmodule