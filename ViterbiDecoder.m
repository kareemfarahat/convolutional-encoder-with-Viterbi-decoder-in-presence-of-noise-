function [decoded_message,trellis] = ViterbiDecoder(m,g1,g2,g3,blength)
message = m;
%message = str2double(message);
block_length=(blength + 2) * 3 ;
asd = length(message)/block_length;
disp(asd);
for block_number=1:length(message)/block_length % itearte over the blocks
    section = message((block_number-1)*block_length+1:block_number*block_length);
    trellis=cell(4,(blength+2)*5); %intaliez the trellis
    
    
    
    for i=1:5:(blength+2)*5     %fill in the states in the digram 
        for j=1:4
            if(j==1)
                trellis{j,i}='00';
            elseif (j==2)
                trellis{j,i}='01';
            elseif (j==3)
                trellis{j,i}='10';
            else
                trellis{j,i}='11';
            end
        end
    end
    v = -2;
    for i=1:3:block_length      % fill the Trellis 
        v = v+2;
        if(i==1)
            j=1;
        else
            j=i+v;
        end
        symbol=[num2str(section(i)>=1/2) num2str(section(i+1)>=1/2) num2str(section(i+2)>=1/2)];
        if(j==1  )%first run with S0 state only
            [first_output,first_nextstate]=state_out(0,'00',g1,g2,g3);
            [seconed_output,seconed_nextstate]=state_out(1,'00',g1,g2,g3);
            trellis{1,j+1}=[first_nextstate;seconed_nextstate];
            trellis{1,j+2}=[first_output;seconed_output];
            trellis{1,j+3}=[sum(symbol~=first_output) sum(symbol~=seconed_output)];
            trellis{1,j+4}=['0';'1'];
            trellis{2,j+3}=[inf inf];
            trellis{3,j+3}=[inf inf];
            trellis{4,j+3}=[inf inf];
        else 
            for s1=1:4 %itterate over the state of the prev
                count=0;
                infinity=inf;
                for s2=1:4 %itterate over the states of the current
                    if(~cellfun(@isempty,trellis(s2,j-4)))
                        if(strcmp(trellis{s1,j},trellis{s2,j-4}(1,:))==1)
                            [first_output,first_nextstate]=state_out(0,trellis{s1,j},g1,g2,g3);
                            [seconed_output,seconed_nextstate]=state_out(1,trellis{s1,j},g1,g2,g3);
                            trellis{s1,j+1}=[first_nextstate;seconed_nextstate];
                            trellis{s1,j+2}=[first_output;seconed_output];
                            if(trellis{s2,j-2}(1)<infinity)
                                infinity=trellis{s2,j-2}(1);
                                trellis{s1,j+3}=[sum(symbol~=first_output)+trellis{s2,j-2}(1)...
                                sum(symbol~=seconed_output)+trellis{s2,j-2}(1)];
                                trellis{s1,j+4}(1,:)=strcat(trellis{s2,j-1}(1,:),'0');
                                trellis{s1,j+4}(2,:)=strcat(trellis{s2,j-1}(1,:),'1');
                            end
                            
                            count = count + 1;
                        elseif (strcmp(trellis{s1,j},trellis{s2,j-4}(2,:))==1)
                            [first_output,first_nextstate]=state_out(0,trellis{s1,j},g1,g2,g3);
                            [seconed_output,seconed_nextstate]=state_out(1,trellis{s1,j},g1,g2,g3);
                            trellis{s1,j+1}=[first_nextstate;seconed_nextstate];
                            trellis{s1,j+2}=[first_output;seconed_output];
                            if(trellis{s2,j-2}(2)<infinity)
                                infinity=trellis{s2,j-2}(2);
                                trellis{s1,j+3}=[sum(symbol~=first_output)+trellis{s2,j-2}(2)...
                                sum(symbol~=seconed_output)+trellis{s2,j-2}(2)];
                                trellis{s1,j+4}(1,:)=strcat(trellis{s2,j-1}(2,:),'0');
                                trellis{s1,j+4}(2,:)=strcat(trellis{s2,j-1}(2,:),'1');
                            end
                            count = count+1;
                        end
                    end
                    if(count==2)
                        break;
                    end
                    if(s2==4&&count==0)
                            trellis{s1,j+3}=[inf inf];
                    end
                end
            end
        end
    end
    % find the minimum distance to decide wich path to choose
     diffrences =horzcat(trellis{1,5*(blength+2)-1},trellis{2,5*(blength+2)-1}, trellis{3,5*(blength+2)-1},trellis{4,5*(blength+2)-1});
     [~,min_index]=min(diffrences);
     if(mod(min_index,2)==0)
         sta=2;
     else
         sta=1;
     end
     decoded_unit=trellis{ceil(min_index/2),5*(blength+2)}(sta,:);
     decoded_unit=decoded_unit(1:length(decoded_unit)-2);
     decoded_str((block_number-1)*blength+1:block_number*blength)=decoded_unit;
end
decoded_message=zeros(1,length(decoded_str));
for i=1:length(decoded_message)
    decoded_message(i)=str2num(decoded_str(i));
end
decoded_message=[decoded_message  0 ];
end

