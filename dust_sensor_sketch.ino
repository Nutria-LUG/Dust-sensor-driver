#include<string.h>

byte buff[2];
int pin = 8; //DSM501A input D8
unsigned long duration;
unsigned long starttime;
unsigned long endtime;
unsigned long sampletime_ms = 30000;
unsigned long lowpulseoccupancy = 0;
float ratio = 0;
float concentration = 0;
 
int i=0;
void setup()
{
  Serial.begin(9600);
  pinMode(8,INPUT);
  starttime = millis(); 
}
void loop()
{
  duration = pulseIn(pin, LOW);
  lowpulseoccupancy += duration;
  endtime = millis();
  if ((endtime-starttime) > sampletime_ms)
  {
    ratio = (lowpulseoccupancy)/(sampletime_ms*10.0);  // Integer percentage 0=>100
    concentration = 1.1*pow(ratio,3)-3.8*pow(ratio,2)+520*ratio+0.62; // Using spec sheet curve
    Serial.print("lowpulseoccupancy:");
    Serial.print(lowpulseoccupancy/1000);
    Serial.print("ms");
    Serial.print("    ratio:");
    Serial.print(ratio);
    Serial.print("%");
    Serial.print("    DSM501A:");
    Serial.print(concentration);
    lowpulseoccupancy = 0;
    starttime = millis();
  } 
}
