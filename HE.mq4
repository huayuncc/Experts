//+------------------------------------------------------------------+
//|                                                          mmx.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- input parameters
input int  挂单方向 = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   int v_type = 挂单方向;


   
   if (!GlobalVariableCheck("HE_PIPS")){
      Print("HE_PIPS参数不存在,请配置参数!");
      return;
   }
   
   if (!(v_type == 1 || v_type == -1)){
      Print("交易方向未设置!");
      return;
   }
   
   double v_lots = GlobalVariableGet("HE_LOTS");
  
   int v_point = GlobalVariableGet("HE_PIPS");
   int v_sl = GlobalVariableGet("HE_SL");
   int v_sl_move = GlobalVariableGet("HE_SL_MOVE");

   int v_time_begin = GlobalVariableGet("HE_TIME_BEGIN");
   int v_time_end = GlobalVariableGet("HE_TIME_END");
   int v_time_move_end = GlobalVariableGet("HE_TIME_MOVE_END");
   
   Print("HE_PIPS=",v_point);

   bool b_in, b_hold;
   int  in_ticket;
   for (int ii = 0 ; ii < OrdersTotal(); ii++)
   {
      OrderSelect(ii, SELECT_BY_POS);
      if ( v_type == 1){
         if ( OrderMagicNumber() == 1122 )
         {
            b_in = true;
            in_ticket = OrderTicket();
            if ( OrderType() == 0 ){
               b_hold = true;
            }
            break;
         }
      }else{
         if ( OrderMagicNumber() == 3344 )
         {
            b_in = true;
            in_ticket = OrderTicket();
            if ( OrderType() == 1 ){
               b_hold = true;
            }
            break;
         }      
      }   
   }
   
   bool b_result ;
   
   if ( TimeCurrent() >= v_time_begin  ){
      if ( TimeCurrent() >= v_time_end  ){
         if (b_in){  //挂单开...
            if (b_hold){   //在持单
               //===            
            }else{ 
               b_result = OrderDelete(in_ticket);
               if( !b_result ){
                  Print("在持单删除 OrderDelete failed with error #",GetLastError());          
               }                              
               return;
            }
         }
      }
   }
   
   if ( b_in )
   {
      
      if ( b_hold ){
      
         double cur_slprice;
         if (OrderStopLoss() ==0 ){
            if ( v_type == 1){
               cur_slprice = Bid - Point * v_sl_move;
            }else{
               cur_slprice = Ask + Point * v_sl_move;
            }   
         }else{
            if ( v_type == 1){
               cur_slprice = Bid - Point * v_sl_move;
               if ( cur_slprice <= OrderStopLoss()){
                  Alert("Up_PASS");
                  return;
               }
                  
            }else{
               cur_slprice = Ask + Point * v_sl_move;
               if ( cur_slprice >= OrderStopLoss()){
                  Alert("Down_PASS");
                  return;
               }
            }   
         }

         b_result = OrderModify(in_ticket,  OrderOpenPrice() , cur_slprice , 0, 0, Red);
         if( !b_result ){
            Print("在持单 OrderModify failed with error #",GetLastError());          
         }
               
      }else{
      
         if ( TimeCurrent() <= v_time_move_end  ){  //移动挂单时间停止
      
            double cur_openprice;
            double cur_sl;
            if ( v_type == 1){
               cur_openprice = Bid + Point * v_point;
               cur_sl = cur_openprice - Point * v_sl;
            }else{
               cur_openprice = Ask - Point * v_point;
               cur_sl = cur_openprice + Point * v_sl;
            }   
            
            b_result = OrderModify(in_ticket,  cur_openprice , cur_sl , 0, 0, Red);   
            if( !b_result ){
               Print("挂单 OrderModify failed with error #",GetLastError());          
            }
         
         }
         
      }
   }else{
      int v_ticket;
      Print("price>", Bid + Point * v_point);
      if ( v_type == 1){
         v_ticket=OrderSend(Symbol(), 4 , v_lots , Bid + Point * v_point ,10, 0, 0, "Up", 1122 , 0, Red );
      }else{
         v_ticket=OrderSend(Symbol(), 5 , v_lots , Ask - Point * v_point ,10, 0, 0, "Down", 3344 , 0, Red );
      }
      if(v_ticket<0) 
        { 
         Print("OrderSend failed with error #",GetLastError()); 
        } 
      else 
         Print("OrderSend placed successfully");       
      
   }
   
   //OrderSend("EURUSD",OP_SELL,Lots,Bid,3,NormalizeDouble(Ask+StopLoss*Point,Digits),NormalizeDouble(Bid-TakeProfit*Point,Digits), 
   //            "My order #2",3,D'2005.10.10 12:30',Red); 
   
   
  }
//+------------------------------------------------------------------+
