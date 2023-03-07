function [s,O] = readtextfile(filename,fields,skiprows,delim,comStyle)
%ReadFiles reads and extracts data as structure and cell
% I: filename,fields,skiprows,delimeter,commentstyle; O: cell + structure

openfile = fopen(filename);

field_pattern = repmat('%f ',1,fields);

s = textscan(openfile,field_pattern,'Delimiter',delim,'headerlines',skiprows,'CommentStyle',comStyle);

for t = 1:length(s)
    O.(sprintf('f%d', t)) = s{1,t};
end

fclose(openfile);
end

