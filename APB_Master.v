
module APB_Master(
	input PCLK,PRESETn,Wr_En,transEn,PREADY,LOAD_READY,store_done,
	input[1:0] Strobe,
	input[31:0] ADDR,Wr_Data,PRDATA,
    output reg[31:0] to_cpu_data,
	output reg[31:0] PADDR,
	output reg PSEL,PENABLE,PWRITE,trans_done,Pstore_done,
	output reg[31:0] PWDATA,
	output reg[1:0] PSTRB
	);

    // APB FSM States
    localparam IDLE = 2'b00,
               SETUP = 2'b01,
               ACCESS = 2'b10;

    reg[1:0] cs,ns;
    // State memory

    always @(posedge PCLK or posedge PRESETn) begin
    	if (PRESETn) begin
      cs<=IDLE;
      trans_done<=0;
      end
    	else cs<=ns;
    end


  always @(*) begin

    // PADDR = ADDR;

      case(cs) 

      IDLE: begin

  		PSEL=0;
  		PADDR=0;
  		PENABLE=0;
  		PWRITE=0;
  		PWDATA=0;
  		PSTRB=0;

  		ns=(transEn)?SETUP:IDLE;

      end

      SETUP: begin
      	 PSEL = 1;
      	 PADDR = ADDR;
          PSTRB = Strobe;
      	 if(Wr_En) begin
      		PWRITE = 1;
      		PWDATA = Wr_Data; 
          Pstore_done = store_done; 
        end  
      	ns = ACCESS;
      end

      ACCESS: begin
      	
         PENABLE = 1;
         to_cpu_data = PRDATA;
         trans_done = LOAD_READY;
         ns = (PREADY&(transEn))?SETUP:(~PREADY&(transEn))?ACCESS:IDLE;

 
      end

      default: ns=IDLE;
      endcase
  end

endmodule