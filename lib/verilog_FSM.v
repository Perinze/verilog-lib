  /////////////////////////////////////////////////////////////////////////////////
  // Implement the state machine for the ifetch req interface
  //
  wire req_need_2uop_r;
  wire req_need_0uop_r;


  localparam ICB_STATE_WIDTH  = 2;
  // State 0: The idle state, means there is no any oustanding ifetch request
  localparam ICB_STATE_IDLE = 2'd0;
  // State 1: Issued first request and wait response
  localparam ICB_STATE_1ST  = 2'd1;
  // State 2: Wait to issue second request 
  localparam ICB_STATE_WAIT2ND  = 2'd2;
  // State 3: Issued second request and wait response
  localparam ICB_STATE_2ND  = 2'd3;
  
  wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
  wire [ICB_STATE_WIDTH-1:0] icb_state_r;
  wire icb_state_ena;
  wire [ICB_STATE_WIDTH-1:0] state_idle_nxt   ;
  wire [ICB_STATE_WIDTH-1:0] state_1st_nxt    ;
  wire [ICB_STATE_WIDTH-1:0] state_wait2nd_nxt;
  wire [ICB_STATE_WIDTH-1:0] state_2nd_nxt    ;
  wire state_idle_exit_ena     ;
  wire state_1st_exit_ena      ;
  wire state_wait2nd_exit_ena  ;
  wire state_2nd_exit_ena      ;

  // Define some common signals and reused later to save gatecounts
  wire icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );
  wire icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST    );
  wire icb_sta_is_wait2nd = (icb_state_r == ICB_STATE_WAIT2ND);
  wire icb_sta_is_2nd     = (icb_state_r == ICB_STATE_2ND    );

      // **** If the current state is idle,
          // If a new request come, next state is ICB_STATE_1ST
  assign state_idle_exit_ena = icb_sta_is_idle & ifu_req_hsked;
  assign state_idle_nxt      = ICB_STATE_1ST;

      // **** If the current state is 1st,
          // If a response come, exit this state
  wire ifu_icb_rsp2leftover;
  assign state_1st_exit_ena  = icb_sta_is_1st & (
                ifu_icb_rsp2leftover ? ifu_icb_rsp_hsked : i_ifu_rsp_hsked);
  assign state_1st_nxt     = 
                (
              // If it need two requests but the ifetch request is not ready to be 
              //   accepted, then next state is ICB_STATE_WAIT2ND
                  (req_need_2uop_r & (~ifu_icb_cmd_ready)) ?  ICB_STATE_WAIT2ND
              // If it need two requests and the ifetch request is ready to be 
              //   accepted, then next state is ICB_STATE_2ND
                  : (req_need_2uop_r & (ifu_icb_cmd_ready)) ?  ICB_STATE_2ND 
              // If it need zero or one requests and new req handshaked, then 
              //   next state is ICB_STATE_1ST
              // If it need zero or one requests and no new req handshaked, then
              //   next state is ICB_STATE_IDLE
                  :  ifu_req_hsked  ?  ICB_STATE_1ST 
                                    : ICB_STATE_IDLE 
                ) ;

      // **** If the current state is wait-2nd,
              // If the ICB CMD is ready, then next state is ICB_STATE_2ND
  assign state_wait2nd_exit_ena = icb_sta_is_wait2nd &  ifu_icb_cmd_ready;
  assign state_wait2nd_nxt      = ICB_STATE_2ND;

      // **** If the current state is 2nd,
          // If a response come, exit this state
  assign state_2nd_exit_ena     =  icb_sta_is_2nd &  i_ifu_rsp_hsked;
  assign state_2nd_nxt          = 
                (
              // If meanwhile new req handshaked, then next state is ICB_STATE_1ST
                  ifu_req_hsked  ?  ICB_STATE_1ST : 
                      // otherwise, back to IDLE
                      ICB_STATE_IDLE
                );

  // The state will only toggle when each state is meeting the condition to exit:
  assign icb_state_ena = 
            state_idle_exit_ena | state_1st_exit_ena | state_wait2nd_exit_ena | state_2nd_exit_ena;

  // The next-state is onehot mux to select different entries
  assign icb_state_nxt = 
              ({ICB_STATE_WIDTH{state_idle_exit_ena   }} & state_idle_nxt   )
            | ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    )
            | ({ICB_STATE_WIDTH{state_wait2nd_exit_ena}} & state_wait2nd_nxt)
            | ({ICB_STATE_WIDTH{state_2nd_exit_ena    }} & state_2nd_nxt    )
              ;

  sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);

