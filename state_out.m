function [out_put,next_state] = state_out(input,state,gm1,gm2,gm3)

state=[str2num(state(1)) str2num(state(2))];
reg=[input state];
out_put=[sum(gm1.*reg) sum(gm2.*reg) sum(gm3.*reg)];
out_put(out_put==2) = 0;
out_put(out_put==3) = 1;
out_put = [num2str(out_put(1)) num2str(out_put(2)) num2str(out_put(3))];
next_state=[num2str(input) num2str(state(1))];


end

