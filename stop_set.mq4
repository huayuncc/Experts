//+------------------------------------------------------------------+
//|                                                       HE_SET.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

input double     手数 = 0.1;
input int      挂单距离点 = 100;
input int      挂单止损点 = 200;
input int      移动距离点 = 200;
input datetime  挂单时间 = "2018.8.2 18:20:55" ;
input datetime  取消挂单时间 = "2018.8.2 18:40:22" ;
input datetime  移动挂单停止时间 = "2018.8.2 18:40:33" ;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   GlobalVariableSet("HE_LOTS",手数);
   GlobalVariableSet("HE_PIPS",挂单距离点);
   GlobalVariableSet("HE_SL",挂单止损点);
   GlobalVariableSet("HE_SL_MOVE",移动距离点);
   
   GlobalVariableSet("HE_TIME_BEGIN",挂单时间);
   GlobalVariableSet("HE_TIME_END",取消挂单时间);
   GlobalVariableSet("HE_TIME_MOVE_END",移动挂单停止时间);
   
   Print("OnInit");
   
   OnTick();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   //Print ("TimeCurrent=", TimeCurrent(), getTime(TimeCurrent()));

   string str = 
            "手数: " + 手数 + "\n" +
            "挂单距离点数: " + 挂单距离点 + "\n" +
            "挂单止损点: " + 挂单止损点 + "\n" +
            "移动距离点: " + 移动距离点 + "\n" +
            "挂单时间: " + getTime(挂单时间) + "\n" +
            "取消挂单时间: " + getTime(取消挂单时间) + "\n" +
            "移动挂单停止时间: " + getTime(移动挂单停止时间) + "\n" ;

   Comment(str);
   
  }
//+------------------------------------------------------------------+

string getTime(int vt){

   return ( 
   
      TimeYear(vt) + "." + TimeMonth(vt) + "." + TimeDay(vt) + " " + TimeHour(vt) + ":" + TimeMinute(vt) + ":" + TimeSeconds(vt)
   
   );

}
