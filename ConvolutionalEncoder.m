function conv_code = ConvolutionalEncoder(input_code,g1,g2,g3,block_length)
coded_message = input_code;
K=3;
if(block_length<=length(coded_message))
    bits_to_fill=mod(length(coded_message),block_length); % get the ramaning bits number to fill the last block
    coded_message=[coded_message zeros(1, bits_to_fill)];
    for i=1:length(coded_message)/block_length % iterate over the number of blocks
            %finds the output of each branch
            block=coded_message((i-1)*block_length+1:i*block_length);
            block = str2num(block(:));
            m=Get_sample(conv(block,g1),K);
            m1=Get_sample(conv(block,g2),K);
            m2=Get_sample(conv(block,g3),K);
            L=length(m);
            m1=[m1(L) m1(1:L-1)];
            %circular shift the upsampled second output by 1
            m2=[m2(L:-1:L-1) m2(1:L-2)];
            %circular shift the upsampled third output by 2
            conv_code((i-1)*L+1:i*L)=m+m1+m2;
        
    end
    conv_code(conv_code==2)=0;
    conv_code(conv_code==3)=1;
end
end