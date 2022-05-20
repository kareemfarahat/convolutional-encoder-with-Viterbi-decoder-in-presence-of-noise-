function decoded_message = HuffmanDecode(encoded_message, dictionary)
num_codees=length(dictionary.code);
L=length(encoded_message);
encoded_message= string(encoded_message);
charachter=1;
for i=1:L
    flag=0;
    for j=1:num_codees
        if(strcmp(encoded_message(i),dictionary.code(j)))
            decoded_message(charachter)=dictionary.symbol(j);
            charachter=charachter+1;
            flag=1;
            break;
        end
    end
    if flag==0
        if(i~=L)
            encoded_message(i+1)=strcat(encoded_message(i),encoded_message(i+1));
        else
            decoded_message(charachter)=".";
            charachter = charachter+1;
        end
    end
end
end