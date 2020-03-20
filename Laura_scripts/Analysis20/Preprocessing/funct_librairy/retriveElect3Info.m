%% File specific to ELect3 (channels settings)

function [ChParams] = retriveElect3Info(Rat,Session)

[file,path] = uigetfile('*.xlsx',...
    'Select the Excel file with the channels data', ...
    'MultiSelect', 'off');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
end

[num,txt,raw] = xlsread(fullfile(path,file),'ChMatlab');

% Select the Session
ColumnsName = categorical(txt(1,:));
for i = 4:length(ColumnsName(1,:))
    if ColumnsName(1,i) == Session
        SessionData = num(:,i);
        disp(txt(1,i))
    end
end

% Rat selection on channels raw
RatData=[];
LockRat = find(num(:,1) == Rat);
for i = 1:length(LockRat(:,1))
    RatData = [RatData SessionData(LockRat(i,1),1)];
end

% Now extract structures !!
StructuresNames = categorical(txt(:,2));
Structures = [];
for i = 1:length(LockRat(:,1))
    Structures = [Structures StructuresNames(LockRat(i,1)+1,1)];
end

ChParams= struct('RatData',RatData','Structures',Structures');

end