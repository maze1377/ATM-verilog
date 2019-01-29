//'timescale 100ps/10ps
/*
    00000 -> getting card
    00001 -> getting password

    00111 -> getting transaction from user

    00010 -> show balance
    00011 -> withdraw money    -> 01011 -> get user money amoun    01111 -> ask to show balance
    00100 -> deposit money     -> 01100  -> get user money amount  01111 -> ask to show balance
    00101 -> transfer money    -> 01101 -> get user money amount       01010 -> get destenation card number   11101->savemoney  01111 -> ask to show balance
    00110 -> change password   -> 01001 -> get uset new password
    00111 -> exit -> gettign card

  */
//
module testWork ();
reg [3:0] userInput;
reg NewInput;
Atm ATM(.userInput(userInput),.NewInput(NewInput));
 initial begin
   #15
   NewInput=0;
   #15
   userInput=4'b0001;
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b0001;
   NewInput=1;
   #100
   NewInput=0;
   #15
   userInput=4'b0001;//show balance
   NewInput=1;
   #40
   NewInput=0;
   #15
   NewInput=1;//press any key to countinue!
   #15
   NewInput=0;
   #15
   userInput=4'b0010;//get money
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b1100;//amout of money your want
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b0001;//show new newBalance
   NewInput=1;
    #15
   NewInput=0;
   #15
   NewInput=1;//press any key to countinue!
   #40
   NewInput=0;
   #15
   userInput=4'b0010;//get money
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b1100;//amout of money your want
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b0000;//don't show new newBalance
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b0011;//give money
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b1100;//amout of money your want
   NewInput=1;
   #40
   NewInput=0;
   #15
   userInput=4'b0001;//show new newBalance
   NewInput=1;
   #10
   NewInput=0;
   #40
   NewInput=1;//press any key to countinue!
   #15
   NewInput=0;
   #10
   userInput=4'b0100;//go for transfer
   NewInput=1;
   #15
   NewInput=0;
   #10
   userInput=4'b0001;//amount of transfer
   NewInput=1;
   #15
   NewInput=0;
   #10
   userInput=4'b0010;//target kart
   NewInput=1;
   #15
   NewInput=0;
   #10
   NewInput=1;//taede etelat
   #100
   NewInput=0;
   #10
   userInput=4'b0000;//don't show new newBalance
   NewInput=1;
   #40
   NewInput=0;
   #5
   userInput=4'b0110;//exit from menu and get kart!
    NewInput=1;
    #10
    NewInput=0;
   end
endmodule // testWork
module testfindUser ();
reg [3:0] username ;
reg [3:0] userpass ;
wire [3:0] userbalance;
reg submitfind;
wire res;
DataBase db(.username(username),.userpass(userpass),.submitfind(submitfind),.res(res),.userbalance(userbalance));
initial begin
  submitfind=0;
  #10
  username=4'b0001;
  userpass=4'b0001;
  submitfind=1;
  #50
  $display("res have to be 1");
  submitfind=0;
  #10
  username=4'b0001;
  userpass=4'b0010;
  submitfind=1;
  #50
  $display("res have to be 0");
  submitfind=0;
end

endmodule // testfindUser
module testchangebalance ();
reg [3:0] username ;
reg [3:0] newBalance ;
reg submitBalance;
wire [3:0] userbalance;
wire res;

DataBase db(.username(username),.newBalance(newBalance),.submitBalance(submitBalance),.res(res),.userbalance(userbalance));
initial begin
  submitBalance=0;
  #30//see last user balance
  username=4'b0001;
  newBalance=4'b1001;
  submitBalance=1;
  #50
  $display("balance haveto change");
   end
endmodule // testchangebalance

module testchangepass ();
reg [3:0] username ;
reg [3:0] userpass ;
reg [3:0] newPass ;
reg submitpass;
wire res;
DataBase db(.username(username),.userpass(userpass),.newPass(newPass),.submitpass(submitpass),.res(res));
initial begin
  submitpass=0;
  #10
  username=4'b0001;
  userpass=4'b0001;
  newPass=4'b1001;
  submitpass=1;
  #50
  $display("password haveto change in db");
  username=4'b0001;
  userpass=4'b0001;//pas wrong so pass not change!!
  newPass=4'b1111;
  #50
  $display("password not change in db");
  end
endmodule // testchangepass
module Atm (input [3:0] userInput,input NewInput);
reg [3:0] username ;
reg [3:0] usernametarget ;
reg [3:0] usernametemp ;
reg [3:0] userpass ;
reg [3:0] newPass ;
reg [3:0] newBalance ;
reg submitpass;
reg submitBalance;
reg submitfind;
wire [3:0] userbalance ;
wire res;
//
reg [3:0] amountMony ;
reg [4:0] currentState;

  initial
  begin
    submitpass=0;
    submitBalance=0;
    submitfind=0;
    $display("     Welcome to ATM");
    #7 currentState <= 5'b000000;
  end
  print displayer(.currentState(currentState),.balance(userbalance));
  DataBase db(.username(username),.userpass(userpass),.newPass(newPass),.newBalance(newBalance),.submitpass(submitpass),.submitBalance(submitBalance),.submitfind(submitfind),.userbalance(userbalance),.res(res));

  always @ ( posedge NewInput ) begin
  case (currentState)
    5'b00000 :begin
      username=userInput;
      currentState = 5'b00001;
      end
    5'b00001 :begin
      userpass=userInput;
      submitfind=1;
      #15
      if (res==1'b1) begin
         $display("ba movafaghiat vared shodid!");
          currentState = 5'b00111;
      end else begin
         $display("user ia pas ghalat ast..!!");
         currentState = 5'b00000;
      end
    end

    5'b00111 :begin
      //menu state
      case (userInput)
        4'b0001 : currentState = 5'b00010;
        4'b0010  : currentState = 5'b01011;
        4'b0011 : currentState = 5'b01100;
        4'b0100 : currentState = 5'b01101;
        4'b0101 : currentState = 5'b01001;
        4'b0110 : currentState=5'b00000;
        default : currentState = 5'b01110;
      endcase
      end

    5'b01101: begin
      amountMony=userInput;
      currentState = 5'b01010;
    end
    5'b01011 :begin
      amountMony=userInput;
      if (amountMony > userbalance) begin
        $display("your money is low!!");
      end else begin
         newBalance=userbalance-amountMony;
         submitBalance=1;
         $display("get your money!! alldone");
      end
      #10
      currentState = 5'b01111;
    end

    5'b01111 :begin
      submitpass=0;
      submitBalance=0;
      submitfind=0;
      if (userInput == 5'b0001) begin
        currentState = 5'b00010;
      end else begin
        currentState = 5'b00111;
      end
    end
    5'b01010 :begin
      usernametarget=userInput;
      currentState = 5'b11101;
      $display("target kart %d and %d money",usernametarget,amountMony);
      end
    5'b11101:begin
        if (userbalance<amountMony) begin
        $display("your money is low!!");
        currentState = 5'b00111;
        end else begin
          newBalance=userbalance-amountMony;
          submitBalance=1;
          usernametemp=username;
          #20
          submitBalance=0;
          #2
          username=usernametarget;
          submitfind=1;
          #20
          newBalance=userbalance+amountMony;
          submitBalance=1;
          #20
          submitfind=0;
          #2
          username=usernametemp;
          submitfind=1;
          #20
          submitfind=0;
          submitBalance=0;
          #2
          currentState = 5'b01111;
          $display("resid khod ra bardarid!");
        end
        end
    5'b01001:begin
      newPass=userInput;
      submitpass=1;
      #30
      submitpass=0;
      if (res==1'b1) begin
        $display("password changed.");
      end else begin
        $display("password not changed.");
      end
      currentState = 5'b00010;
      end
    5'b01100: begin
      newBalance=userbalance+userInput;
      submitBalance=1;
      #20
      if (res==1'b1) begin
        $display("pol ba movafaghiet ezafe shod!.");
      end else begin
        $display("moskele ertebat ba server!.");
      end
      currentState = 5'b01111;
      end


    5'b00111 :
      currentState = 5'b00000;
    5'b00010:
       currentState = 5'b00111;
  endcase
end

endmodule // Atm
//
module print(currentState,balance);
 input [4:0] currentState;
 input [3:0] balance;
 always @(currentState)
    begin
    if(currentState == 5'b00111)
      begin
      $display("Select a transaction");
      $display("  1.Show balance");
      $display("  2.withdraw money");
      $display("  3.deposit money");
      $display("  4.transfer money");
      $display("  5.change pass");
      $display("  6.Exit");
      end
    else if(currentState == 5'b00010)
      begin
        $display("your current balance is %d .",balance);
      end
    else if(currentState == 5'b00000)
      begin
        $display(" enter your card number!");
      end
    else if(currentState == 5'b00001)
      begin
        $display(" enter your Password!");
      end
    else if(currentState == 5'b01101)
      begin
        $display(" enter money amount!");
      end
     else if(currentState == 5'b01100)
      begin
        $display(" enter money amount!");
      end
     else if(currentState == 5'b01011)
      begin
        $display(" enter money amount!");
      end
    else if(currentState == 5'b01010)
      begin
        $display(" enter destination card number!");
      end
    else if(currentState == 5'b01111)
      begin
        $display(" do you want to show balance ?");
      end
    end

endmodule
//
module DataBase (username,userpass,newPass,newBalance,submitpass,submitBalance,submitfind,userbalance,res);
input [3:0] username ;
input [3:0] userpass ;
input [3:0] newPass ;
input [3:0] newBalance ;
input submitpass;
input submitBalance;
input submitfind;
output reg [3:0] userbalance ;
output reg res;
//local varibale
integer i;
reg [3:0] user_name [0:15];
reg [3:0] user_pass [0:15];
reg [3:0] user_balance [0:15];

initial begin
$readmemb("user_name.mem", user_name);
$readmemb("user_pass.mem", user_pass);
$readmemb("user_balance.mem", user_balance);
/*
user_name[0]=4'b0001;
user_name[1]=4'b0010;
user_name[2]=4'b0011;
user_name[3]=4'b0100;
user_name[4]=4'b0101;
user_name[5]=4'b0110;
user_name[6]=4'b0111;
user_name[7]=4'b1000;
user_name[8]=4'b1001;
user_name[9]=4'b1010;
user_name[10]=4'b1011;
user_name[11]=4'b1100;
user_name[12]=4'b1101;
user_name[13]=4'b1110;
user_name[14]=4'b1111;
user_name[15]=4'b0000;
//
user_pass[0]=4'b0001;
user_pass[1]=4'b0010;
user_pass[2]=4'b0011;
user_pass[3]=4'b0100;
user_pass[4]=4'b0101;
user_pass[5]=4'b0110;
user_pass[6]=4'b0111;
user_pass[7]=4'b1000;
user_pass[8]=4'b1001;
user_pass[9]=4'b1010;
user_pass[10]=4'b1011;
user_pass[11]=4'b1100;
user_pass[12]=4'b1101;
user_pass[13]=4'b1110;
user_pass[14]=4'b1111;
user_pass[15]=4'b0000;
//
user_balance[0]=4'b1111;
user_balance[1]=4'b1111;
user_balance[2]=4'b0100;
user_balance[3]=4'b0001;
user_balance[4]=4'b0010;
user_balance[5]=4'b0011;
user_balance[6]=4'b0100;
user_balance[7]=4'b0001;
user_balance[8]=4'b0010;
user_balance[9]=4'b0011;
user_balance[10]=4'b0100;
user_balance[11]=4'b0001;
user_balance[12]=4'b0010;
user_balance[13]=4'b0011;
user_balance[14]=4'b0100;
user_balance[15]=5'b0100;
*/
//
end

always @ (posedge submitfind ) begin
i=0;
res = 1'b0;
while (i<16) begin//static 16!!
  if (user_name[i] == username)
  begin
    userbalance = user_balance[i];
    if (user_pass[i]==userpass) begin
      res = 1'b1;
    end
  end
  i=i+1;
  end
end

always @ (posedge submitBalance ) begin
i=0;
res = 1'b0;
while (i<16) begin//static 16!!
  if (user_name[i] == username)
  begin
    user_balance[i]=newBalance;
    res = 1'b1;
  end
  i=i+1;
  end
end
always @ (posedge submitpass ) begin
i=0;
res = 1'b0;
while (i<16) begin//static 16!!
  if (user_name[i] == username)
  begin
    if (user_pass[i]==userpass) begin
    user_pass[i]=newPass;
    res = 1'b1;
    end
  end
  i=i+1;
  end
end
endmodule // DataBase
