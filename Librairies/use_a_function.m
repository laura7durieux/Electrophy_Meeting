function [output]=use_a_function(input)

X = ['your input is ',num2str(input)];
disp(X)

if isstring(input)|ischar(input)
    error('Input needs to be numbers')
end
    
output = input*10;
X = ['your output will be ',num2str(output)];
disp(X)

