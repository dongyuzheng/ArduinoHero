String output = "";
boolean allowStrum = true;

void setup()
{
  Serial.begin(9600);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
}

void loop()
{
  if (digitalRead(4)==HIGH)
  {
    output+=1;
  }
  else{
    output+=0;
  }
  if (digitalRead(5)==HIGH)
  {
    output+=2;
  }
  else{
    output+=0;
  }
  if (digitalRead(6)==HIGH)
  {
    output+=3;
  }
  else{
    output+=0;
  }
  if (digitalRead(7)==HIGH)
  {
    output+=4;
  }
  else{
    output+=0;
  }
  if (digitalRead(8)==HIGH)
  {
    output+=5;
  }
  else{
    output+=0;
  }
  if (digitalRead(9)==HIGH && allowStrum==true)
  {
    Serial.println(output);
    allowStrum=false;
  }
  else if(digitalRead(9)==LOW){
    allowStrum=true;
  }
  output="";
  delay(50);
}








