
`timescale 1 ns / 1 ps

	module axi_xdma_st_data_gen_yuri_master_stream_v1_0_M00_AXIS #
	(
		parameter integer C_M_AXIS_TDATA_WIDTH	= 128, // AXI-Stream  bus-width 
		parameter integer NUMBER_OF_OUTPUT_WORDS = 64 	// number of words in one axi-stream packet. '0' means packet never end.
	)
	(
		input wire  M_AXIS_ACLK,
		input wire  M_AXIS_ARESETN,
		output wire  M_AXIS_TVALID,
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		output wire  M_AXIS_TLAST,
		input wire  M_AXIS_TREADY, 
		input wire [31:0] config_reg0,
		input wire [31:0] config_reg1,
		input wire [31:0] config_reg2
	);                                              
         
    wire counter_stop = config_reg0[0];
    wire counter_down = config_reg0[1];
    
    wire [63:0] counter_step = {config_reg1, config_reg2} + 1;
    
	// Define the states of state machine                                                
                             
	localparam [1:0] IDLE = 2'b00,        // This is the initial/idle state                                                                         
	                SEND_STREAM   = 2'b10; // stream data is output through M_AXIS_TDATA   
	// State variable                                                                    
	reg [1:0] mst_exec_state;                                                            
	// Example design FIFO read pointer                                                  
	reg [31:0] read_pointer;              
	
	// AXI Stream internal signals
	
	wire  	axis_tvalid;
	//streaming data valid delayed by one clock cycle
	reg  	axis_tvalid_delay;
	//Last of the streaming data 
	wire  	axis_tlast;
	//Last of the streaming data delayed by one clock cycle
	reg  	axis_tlast_delay;
	//FIFO implementation signals
	reg [C_M_AXIS_TDATA_WIDTH-1 : 0] 	stream_data_out;
	wire  	tx_en;
	//The master has issued all the streaming data stored in FIFO
	reg  	tx_done;


	// I/O Connections assignments

	assign M_AXIS_TVALID	= axis_tvalid_delay;
	assign M_AXIS_TDATA	= stream_data_out;
	assign M_AXIS_TLAST	= axis_tlast_delay;
	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};


	// Control state machine implementation                             
	always @(posedge M_AXIS_ACLK)                                             
	begin                                        
	  if (!M_AXIS_ARESETN)
	    // Reset                                         
	    begin              
	      mst_exec_state <= IDLE;
	    end                                                                   
	  else                                                                    
	    case (mst_exec_state)          
	      IDLE:                                                                                   
	        mst_exec_state  <= SEND_STREAM; 
                                                                                                        
	      SEND_STREAM:                                                                 
	        if (tx_done)                                                      
	          begin                                  
	            mst_exec_state <= IDLE;                                       
	          end                                                             
	        else                                                              
	          begin                                                           
	            mst_exec_state <= SEND_STREAM;                                
	          end
          default: mst_exec_state  <= IDLE;                                              
	    endcase                                                               
	end

	//tvalid generation
	//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	//number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
	assign axis_tvalid = (mst_exec_state == SEND_STREAM) && (read_pointer < NUMBER_OF_OUTPUT_WORDS || NUMBER_OF_OUTPUT_WORDS == 0);

    // AXI tlast generation
	// axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1          
	// (0 to NUMBER_OF_OUTPUT_WORDS-1)                                                             
	assign axis_tlast = (read_pointer == NUMBER_OF_OUTPUT_WORDS-1);                                

                                                    
	// Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
	// to match the latency of M_AXIS_TDATA   
	always @(posedge M_AXIS_ACLK)
	begin
	  if (!M_AXIS_ARESETN)  
	    begin 
	      axis_tvalid_delay <= 1'b0;                                                               
	      axis_tlast_delay <= 1'b0;                                                                
	    end                                                                                        
	  else                                                                                         
	    begin                                                                                      
	      axis_tvalid_delay <= axis_tvalid;                                                        
	      axis_tlast_delay <= axis_tlast;                                                          
	    end                                                                                        
	end                                                                                            


	//read_pointer pointer
	always@(posedge M_AXIS_ACLK)                                               
	begin                                                                            
	  if(!M_AXIS_ARESETN)                                                            
	    begin                                      
	      read_pointer <= 0;                                                         
	      tx_done <= 1'b0;                                                           
	    end                                                                          
	  else                                                                           
	    if (read_pointer <= NUMBER_OF_OUTPUT_WORDS-1 || NUMBER_OF_OUTPUT_WORDS == 0)
	      begin                                                                      
	        if (tx_en)                                                                                                
	          begin                                                                  
	            read_pointer <= read_pointer + 1;                                    
	            tx_done <= 1'b0;                                                     
	          end                                                                    
	      end                                                                        
	    else if (read_pointer == NUMBER_OF_OUTPUT_WORDS)
          begin
             tx_done <= 1'b0;
             read_pointer <= 0;
          end
	end

	//FIFO read enable generation 
	assign tx_en = M_AXIS_TREADY && axis_tvalid;
	
    // Streaming output data
    always @( posedge M_AXIS_ACLK )                  
    begin                                            
      if(!M_AXIS_ARESETN)                            
        begin
          stream_data_out <= 1;       
        end                                          
      else if (tx_en)
        begin
          if (counter_stop) begin
            stream_data_out <= stream_data_out;
          end
          else begin
            stream_data_out <= counter_down ? (stream_data_out - counter_step): (stream_data_out + counter_step);
          end
        end
    end
    endmodule
