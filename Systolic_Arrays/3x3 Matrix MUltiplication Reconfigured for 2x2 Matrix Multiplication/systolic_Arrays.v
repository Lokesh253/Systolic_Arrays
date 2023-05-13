//Baisc PE module
module PE (enable,clk,row_in,column_in,result,row_out,column_out);
    input clk;
    input enable;
    input [1:0] row_in,column_in;
    output [7:0] result;
    output [1:0] row_out,column_out;
    reg [7:0] result;
    reg [1:0] row_out,column_out;
    
    
  initial begin
  result = 8'b0;
    row_out <= row_in;
    column_out <= column_in;
    row_out <= 2'b0;
    column_out <= 2'b0;
  end
  
   always @(posedge clk ) begin
    if(enable == 0)begin
        row_out <= row_in;
        column_out <= column_in;
        result = result + (row_in * column_in);
        $display("row_in column_in result: %d %d  %d", row_in,column_in,result);
    end
  end
endmodule

//Systolic Array : connecting PEs
module systolic_Array(enable,clk,row_input0,column_input0,row_input1,column_input1,row_input2,column_input2,
c_output0,c_output1,c_output2,c_output3,c_output4,c_output5,c_output6,c_output7,c_output8);
    input clk;
    input enable;
    input [1:0] row_input0;
    input [1:0] column_input0;
    input [1:0] row_input1;
    input [1:0] column_input1;
    input [1:0] row_input2;
    input [1:0] column_input2;
    output [7:0] c_output0,c_output1,c_output2,c_output3,c_output4,c_output5,c_output6,c_output7,c_output8;
    wire [7:0] c_output0,c_output1,c_output2,c_output3,c_output4,c_output5,c_output6,c_output7,c_output8;
    
    wire [1:0] row_ou00,column_ou00,row_ou01,column_ou01,row_ou02,column_ou02,row_ou10,column_ou10,row_ou11,column_ou11,row_ou12,column_ou12,row_ou20,column_ou20,row_ou21,column_ou21,row_ou22,column_ou22;
    integer i,j;
    wire enable0;
    assign enable0 = 0;
    
    
    PE pe00 (.enable(enable0),.clk(clk),.row_in(row_input0),.column_in(column_input0),.result(c_output0),.row_out(row_ou00),.column_out(column_ou00));
    PE pe01 (.enable(enable0),.clk(clk),.row_in(row_ou00),.column_in(column_input1),.result(c_output1),.row_out(row_ou01),.column_out(column_ou01));
    PE pe02 (.enable(enable),.clk(clk),.row_in(row_ou01),.column_in(column_input2),.result(c_output2),.row_out(row_ou02),.column_out(column_ou02));
    
    PE pe10 (.enable(enable0),.clk(clk),.row_in(row_input1),.column_in(column_ou00),.result(c_output3),.row_out(row_ou10),.column_out(column_ou10));
    PE pe11 (.enable(enable0),.clk(clk),.row_in(row_ou10),.column_in(column_ou01),.result(c_output4),.row_out(row_ou11),.column_out(column_ou11));
    PE pe12 (.enable(enable),.clk(clk),.row_in(row_ou11),.column_in(column_ou02),.result(c_output5),.row_out(row_ou12),.column_out(column_ou12));
    
    PE pe20 (.enable(enable),.clk(clk),.row_in(row_input2),.column_in(column_ou10),.result(c_output6),.row_out(row_ou20),.column_out(column_ou20));
    PE pe21 (.enable(enable),.clk(clk),.row_in(row_ou20),.column_in(column_ou11),.result(c_output7),.row_out(row_ou21),.column_out(column_ou21));
    PE pe22 (.enable(enable),.clk(clk),.row_in(row_ou21),.column_in(column_ou12),.result(c_output8),.row_out(row_ou22),.column_out(column_ou22));
    
endmodule

module Testbench;
  reg [1:0] matrix1[0:2][0:2];
  reg [1:0] matrix2[0:2][0:2];
  reg [1:0] rows[0:2][0:4];
  reg [1:0] columns[0:2][0:4];
  reg [1:0] row_in[0:2];
  reg [1:0] column_in[0:2];
  wire [7:0] c[0:8];
  reg clk;
  reg enable;
  integer i, j;
  
  // Instantiate systolic_Array module
  systolic_Array Multiply (.enable(enable),.clk(clk),.row_input0(row_in[0]),.column_input0(column_in[0]),.row_input1(row_in[1]),.column_input1(column_in[1]),.row_input2(row_in[2]),.column_input2(column_in[2]),
.c_output0(c[0]),.c_output1(c[1]),.c_output2(c[2]),.c_output3(c[3]),.c_output4(c[4]),.c_output5(c[5]),.c_output6(c[6]),.c_output7(c[7]),.c_output8(c[8]));
  
  // Assign values to matrix1 and matrix2
  initial begin
    
    //if enable 0 then works for 3*3 matrix
    //if enable 1 then works for 2*2 matrix
    enable = 0;
    matrix1[0][0] = 2'b00;
    matrix1[0][1] = 2'b01;
    matrix1[0][2] = 2'b01;
    matrix1[1][0] = 2'b11;
    matrix1[1][1] = 2'b10;
    matrix1[1][2] = 2'b11;
    matrix1[2][0] = 2'b10;
    matrix1[2][1] = 2'b10;
    matrix1[2][2] = 2'b01;
    
    matrix2[0][0] = 2'b01;
    matrix2[0][1] = 2'b00;
    matrix2[0][2] = 2'b00;
    matrix2[1][0] = 2'b00;
    matrix2[1][1] = 2'b11;
    matrix2[1][2] = 2'b10;
    matrix2[2][0] = 2'b01;
    matrix2[2][1] = 2'b01;
    matrix2[2][2] = 2'b10;

    
    for(i=0;i<3;i=i+1)begin
        for(j=0;j<5;j=j+1)begin
        rows[i][j] = 2'b0;
        columns[i][j] = 2'b0;
        end
    end
    
    for(j=0;j<3;j=j+1)begin
            rows[0][j] = matrix1[0][j];
            columns[0][j] = matrix2[j][0];
    end
    rows[1][1] = matrix1[1][0];
    rows[1][2] = matrix1[1][1];
    rows[1][3] = matrix1[1][2];
    rows[2][2] = matrix1[2][0];
    rows[2][3] = matrix1[2][1];
    rows[2][4] = matrix1[2][2];
    
    columns[1][1] = matrix2[0][1];
    columns[1][2] = matrix2[1][1];
    columns[1][3] = matrix2[2][1];
    columns[2][2] = matrix2[0][2];
    columns[2][3] = matrix2[1][2];
    columns[2][4] = matrix2[2][2];
    
    i = 0;
    for (j = 0; j < 3; j = j + 1) begin
          row_in[j] <= rows[j][i];
          column_in[j] <= columns[j][i];
    end

    clk = 0;
    i = 1;
    
    #70 $finish;

 end
 
 always #5 clk = ~clk;
 
 always @(posedge clk) begin
      if (i < 5) begin
        if(enable == 0)begin
         for (j = 0; j < 3; j = j + 1) begin
          row_in[j] <= rows[j][i];
          column_in[j] <= columns[j][i];
          rows[j][i] <= 2'b0;
          columns[j][i] <= 2'b0;
        end
        end
        else begin
         for (j = 0; j < 2; j = j + 1) begin
          row_in[j] <= rows[j][i];
          column_in[j] <= columns[j][i];
          rows[j][i] <= 2'b0;
          columns[j][i] <= 2'b0;
        end
        end
        i = i + 1;
        if(i == 5)begin
        i = i%5;
        end
      end
    end

    // Monitor the outputs
    always @(posedge clk) begin
      $monitor("\nc0 c1 c2 c3 c4 c5 c6 c7 c8:\n%d %d %d %d %d %d %d %d", c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8]);
    end

endmodule