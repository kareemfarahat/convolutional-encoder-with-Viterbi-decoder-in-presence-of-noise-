function message = GetMessage(filename)
fileID = fopen(filename,'r');
message = fscanf(fileID,'%c');
end
