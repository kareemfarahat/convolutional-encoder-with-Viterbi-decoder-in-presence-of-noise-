%% 1. Read the text file provided to you using MATLAB and compute the approximate & 2. Calculate the entropy probabilities of the different English characters (symbols) in this text file.
clear; clc;
file_name = "Test_Text_File.txt"; % enter the file name conraining the message
message = GetMessage(file_name);
fprintf("the message is\n %s \n",message );
[entropy, probability, chars] = GetProbAndEntorpy(message); 
fprintf("the entropy of the message is\n %f \n", entropy );
fprintf("The sum of probabilities is %f \n ",sum(probability) );
for n = 1: length(probability)
fprintf("the probabilty of character %c is %f  \n", chars(n), probability(n) );
end
%% 3. Calculate the number of bits/symbols required to construct a fixed length code and calculate the efficiency of that code.
const_bits_per_symbol = GetBitsPerSymbol(chars); 
const_code_efficiency = (entropy/const_bits_per_symbol) * 100;
fprintf("the number of bits/symbols required to construct a fixed length code is %f bits/symbol \n",const_bits_per_symbol )
fprintf("The fixed length code efficiency is %f%% \n",const_code_efficiency );
%% 4. Implement in MATLAB the Huffman encoder function and encode the file characters into a stream of zeros and ones.
dictionary = GetHufmanCodes(chars ,probability);
fprintf(" The dictionary \n ")
for n = 1 : length(dictionary.code)
    disp(dictionary.symbol(n));
    disp(dictionary.code(n))
end
encoded_message = HuffmanEncode(message, dictionary);
encoded_message = char(encoded_message);
fprintf("The encoded message is \n %s \n", encoded_message );
%% channel Encoder
block_length = 5;
g_matrix_1=[1 1 1]; g_matrix_2=[1 1 0]; g_matrix_3=[1 0 1];
channel_coded_message = ConvolutionalEncoder(encoded_message,g_matrix_1,g_matrix_2,g_matrix_3,block_length);
encoded_message = double(char(encoded_message));
%% Channel Noise
encoded_signal_with_2_SNR = awgn(channel_coded_message,2, 'measured');
encoded_signal_with_5_SNR = awgn(channel_coded_message,5, 'measured');
encoded_signal_with_10_SNR = awgn(channel_coded_message,10, 'measured');
non_encoded_signal_with_2_SNR = awgn(encoded_message,2, 'measured');
non_encoded_signal_with_5_SNR = awgn(encoded_message,5, 'measured');
non_encoded_signal_with_10_SNR = awgn(encoded_message,10, 'measured');
%% Vetirbi Decode
decoded_Csignal_with_2_SNR = ViterbiDecoder(encoded_signal_with_2_SNR,g_matrix_1,g_matrix_2,g_matrix_3,block_length);
decoded_Csignal_with_5_SNR = ViterbiDecoder(encoded_signal_with_5_SNR,g_matrix_1,g_matrix_2,g_matrix_3,block_length);
decoded_Csignal_with_10_SNR = ViterbiDecoder(encoded_signal_with_10_SNR,g_matrix_1,g_matrix_2,g_matrix_3,block_length);

%%
non_encoded_signal_with_2_SNR(non_encoded_signal_with_2_SNR >= 1/2) = 1;
non_encoded_signal_with_2_SNR(non_encoded_signal_with_2_SNR < 1/2) = 0;
non_encoded_signal_with_5_SNR(non_encoded_signal_with_5_SNR >= 1/2) = 1;
non_encoded_signal_with_5_SNR(non_encoded_signal_with_5_SNR < 1/2) = 0;
non_encoded_signal_with_10_SNR(non_encoded_signal_with_10_SNR >= 1/2) = 1;
non_encoded_signal_with_10_SNR(non_encoded_signal_with_10_SNR < 1/2) = 0;
%%
decoded_Csignal_with_2_SNR = HuffmanDecode(decoded_Csignal_with_2_SNR, dictionary);
decoded_Csignal_with_2_SNR = char(decoded_Csignal_with_2_SNR);
decoded_Csignal_with_5_SNR = HuffmanDecode(decoded_Csignal_with_5_SNR, dictionary);
decoded_Csignal_with_5_SNR = char(decoded_Csignal_with_5_SNR);
decoded_Csignal_with_10_SNR = HuffmanDecode(decoded_Csignal_with_10_SNR, dictionary);
decoded_Csignal_with_10_SNR = char(decoded_Csignal_with_10_SNR);
decoded_signal_with_2_SNR = HuffmanDecode(non_encoded_signal_with_2_SNR, dictionary);
decoded_signal_with_2_SNR = char(decoded_signal_with_2_SNR);
decoded_signal_with_5_SNR = HuffmanDecode(non_encoded_signal_with_5_SNR, dictionary);
decoded_signal_with_5_SNR = char(decoded_signal_with_5_SNR);
decoded_signal_with_10_SNR = HuffmanDecode(non_encoded_signal_with_10_SNR, dictionary);
decoded_signal_with_10_SNR = char(decoded_signal_with_10_SNR);

%% 6. Calculate the efficiency of the Huffman code.
average_codeword_length = GetAvreageCodeWord(probability, dictionary);
Huffman_code_efficiency = (entropy / average_codeword_length) * 100;
fprintf("Aerage codeword of Huffman code is %f bits/symbol \n",average_codeword_length);
fprintf("The efficiency of the Huffman code is %f %% \n", Huffman_code_efficiency)
%% BIT ERROR Rate
encoded_signal_with_2_SNR(encoded_signal_with_2_SNR >= 1/2) = 1;
encoded_signal_with_2_SNR(encoded_signal_with_2_SNR < 1/2) = 0;
encoded_signal_with_5_SNR(encoded_signal_with_5_SNR >= 1/2) = 1;
encoded_signal_with_5_SNR(encoded_signal_with_5_SNR < 1/2) = 0;
encoded_signal_with_10_SNR(encoded_signal_with_10_SNR >= 1/2) = 1;
encoded_signal_with_10_SNR(encoded_signal_with_10_SNR < 1/2) = 0;
[V_bit_error_rate_number_2, V_bit_error_rate_ratio_2] = biterr(channel_coded_message,encoded_signal_with_2_SNR);
[V_bit_error_rate_number_5, V_bit_error_rate_ratio_5] = biterr(channel_coded_message,encoded_signal_with_5_SNR);
[V_bit_error_rate_number_10, V_bit_error_rate_ratio_10] = biterr(channel_coded_message,encoded_signal_with_10_SNR);
[bit_error_rate_number_2, bit_error_rate_ratio_2] = biterr(encoded_message,non_encoded_signal_with_2_SNR);
[bit_error_rate_number_5, bit_error_rate_ratio_5] = biterr(encoded_message,non_encoded_signal_with_5_SNR);
[bit_error_rate_number_10, bit_error_rate_ratio_10] = biterr(encoded_message,non_encoded_signal_with_10_SNR);
%% write to File 
fileID = fopen( 'Recieved chanel encoded message SNR 2.txt', 'wt' );
fprintf(fileID, decoded_Csignal_with_2_SNR );
fclose(fileID);
fileID = fopen( 'Recieved chanel encoded message SNR 5.txt', 'wt' );
fprintf(fileID, decoded_Csignal_with_5_SNR );
fclose(fileID);
fileID = fopen( 'Recieved chanel encoded message SNR 10.txt', 'wt' );
fprintf(fileID, decoded_Csignal_with_10_SNR );
fclose(fileID);
fileID = fopen( 'Recieved NON chanel encoded message SNR 2.txt', 'wt' );
fprintf(fileID, decoded_signal_with_2_SNR );
fclose(fileID);
fileID = fopen( 'Recieved NON chanel encoded message SNR 5.txt', 'wt' );
fprintf(fileID, decoded_signal_with_5_SNR );
fclose(fileID);
fileID = fopen( 'Recieved NON chanel encoded message SNR 10.txt', 'wt' );
fprintf(fileID, decoded_signal_with_10_SNR );
fclose(fileID);

%% BIR Vs SNR
SNR=0:1:20;
ber_conv=zeros(1,length(SNR));
ber=zeros(1,length(SNR));
for i=1:length(SNR)
    received_conv = awgn(channel_coded_message,SNR(i),'measured');
    received = awgn(encoded_message,SNR(i),'measured');
    received(received >= 0.5) = 1;
    received(received < 0.5) = 0;
    decoded_conv =ViterbiDecoder(received_conv,g_matrix_1,g_matrix_2,g_matrix_3,block_length);
    [~,ber_conv(i)] = biterr(decoded_conv,encoded_message);
    [~,ber(i)] = biterr(received,encoded_message);
    
end
grid on
plot(SNR,ber,'-ored');
hold on
plot(SNR,ber_conv,'--*blue');
title('Comparison between the Bit Error Rates in case of using Convolutional Codes and in case of no coding')
ylabel('Bit Error rate');
xlabel('Signal-to-Noise ratio');
legend('No Coding','Convolutional Coding');

