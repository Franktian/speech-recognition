trainDir    = '/u/cs401/speechdata/Training';
testDir     = '/u/cs401/speechdata/Testing';
FD          = dir([testDir '/*.mfcc']);

for i=1:length(FD)
    disp(FD(i).name);
end
