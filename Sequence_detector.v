
module sequence_detector(out,x_in,clk,reset);

input x_in,clk,reset;
output reg out;

parameter S0   = 6'b000000;
parameter A1   = 6'b000001;
parameter A2   = 6'b000010;
parameter A3   = 6'b000011;
parameter A4   = 6'b000100;
parameter A5   = 6'b000101;
parameter A6   = 6'b000110;
parameter A7   = 6'b000111;
parameter A8   = 6'b001000;
parameter A9   = 6'b001001;
parameter A10  = 6'b001010;

parameter B1   = 6'b001011;
parameter B2   = 6'b001100;
parameter B3   = 6'b001101;
parameter B4   = 6'b001110;
parameter B5   = 6'b001111;
parameter B6   = 6'b010000;
parameter B7   = 6'b010001;
parameter B8   = 6'b010010;
parameter B9   = 6'b010011;
parameter B10  = 6'b010100;

parameter C2   = 6'b010101;
parameter C3   = 6'b010110;
parameter C4   = 6'b010111;
parameter C5   = 6'b011000;
parameter C6   = 6'b011001;
parameter C7   = 6'b011010;
parameter C8   = 6'b011011;
parameter C9   = 6'b011100;

parameter SD   = 6'b011101;

parameter G0   = 6'b011110;
parameter G1   = 6'b011111;
parameter G2   = 6'b100000;


reg [5:0] state;


always@(posedge clk or  posedge reset)
begin
if(reset) begin state <= S0;
end

else
begin

case(state)

S0  : state <= x_in ? B1  : A1;
A1  : state <= x_in ? B1  : A2;
A2  : state <= x_in ? B1  : A3;
A3  : state <= x_in ? B1  : A4;
A4  : state <= x_in ? A5  : A4;
A5  : state <= x_in ? B1  : A6;
A6  : state <= x_in ? A7  : C2;
A7  : state <= x_in ? A8  : B4;
A8  : state <= x_in ? B1  : A9;
A9  : state <= x_in ? A10 : C2;
A10 : state <= x_in ? B1  : SD;

B1  : state <= x_in ? B1  : B2;
B2  : state <= x_in ? B3  : C2;
B3  : state <= x_in ? B1  : B4;
B4  : state <= x_in ? B3  : B5;
B5  : state <= x_in ? C3  : B6;
B6  : state <= x_in ? B7  : A4;
B7  : state <= x_in ? B8  : B2;
B8  : state <= x_in ? B9  : B2;
B9  : state <= x_in ? B10 : B2;
B10 : state <= x_in ? SD  : B2;

C2  : state <= x_in ? C3  : A3;
C3  : state <= x_in ? C4  : B2;
C4  : state <= x_in ? B1  : C5;
C5  : state <= x_in ? C6  : C2;
C6  : state <= x_in ? B1  : C7;
C7  : state <= x_in ? C8  : B5;
C8  : state <= x_in ? C9  : B4;
C9  : state <= x_in ? B1  : SD;

SD  : state <= x_in ? G1 : G0;

G0  : state <= x_in ? G1  : G0;
G1  : state <= x_in ? G2  : G1;
G2  : state <= x_in ? S0  : G2;

default : state<= S0;

endcase
end
end
always@(state)
begin
if(state == SD)
begin 

out<=1;

end

else begin out<=0;
end

end
endmodule



module top ;

reg x_in;
reg reset = 1'b0;
reg clk = 1'b1;
wire out;


sequence_detector DUT (out,x_in,clk,reset);

always
begin
#5 clk = ~clk;
end

initial
begin
$monitor($time , "  x_in = %b , reset = %b , out = %b, clk = %b    ", x_in,reset,out  ,clk);

#2 reset = 1'b0 ; x_in = 0;

// 🔹 Sequence 1: 00001011010
#10 x_in = 0; #10 x_in = 0; #10 x_in = 0; #10 x_in = 0;
#10 x_in = 1; #10 x_in = 0; #10 x_in = 1; #10 x_in = 1;
#10 x_in = 0; #10 x_in = 1;#10 x_in = 0;

// 🔹 Gap: 3 ones (VALID)
#10 x_in = 1; #10 x_in = 1; #10 x_in = 1;

// 🔹 Sequence 2: 10100011111
#10 x_in = 1; #10 x_in = 0; #10 x_in = 1; #10 x_in = 0;
#10 x_in = 0; #10 x_in = 0; #10 x_in = 1; #10 x_in = 1;
#10 x_in = 1; #10 x_in = 1;#10 x_in = 1;

// 🔹 Gap: less than 3 ones (INVALID → should NOT detect next)
#10 x_in = 1; #10 x_in = 1;

// 🔹 Sequence 3: 10011010110 (should NOT trigger)
#10 x_in = 1; #10 x_in = 0; #10 x_in = 0; #10 x_in = 1;
#10 x_in = 1; #10 x_in = 0; #10 x_in = 1; #10 x_in = 0;
#10 x_in = 1; #10 x_in = 1;

// 🔹 Gap: proper 3 ones again
#10 x_in = 1; #10 x_in = 1; #10 x_in = 1;

// 🔹 Sequence 3 again (VALID now)
#10 x_in = 1; #10 x_in = 0; #10 x_in = 0; #10 x_in = 1;
#10 x_in = 1; #10 x_in = 0; #10 x_in = 1; #10 x_in = 0;
#10 x_in = 1; #10 x_in = 1;#10 x_in = 0;

// 🔹 Overlap test (continuous stream)
#10 x_in = 1; #10 x_in = 0; #10 x_in = 1; #10 x_in = 0;
#10 x_in = 0; #10 x_in = 0; #10 x_in = 1; #10 x_in = 1;
#10 x_in = 1; #10 x_in = 1;

#10 reset = 1; x_in = 0; 
#10 x_in = 1; #10 x_in = 0;
#10 x_in = 0; #10 x_in = 0; #10 x_in = 1; #10 x_in = 1;
#10 x_in = 1; #10 x_in = 1;

#10 $finish;
end

always @(posedge clk) begin
    if (out == 1)
        $display("Time %0t: Sequence has been detected", $time);
end
endmodule
