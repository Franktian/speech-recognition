trainDir    = '/u/cs401/speechdata/Training';
testDir     = '/u/cs401/speechdata/Testing';
FD          = dir([testDir '/*.mfcc']);

for i=1:length(FD)
    disp(FD(i).name);
    mfcc = load(strcat('/u/cs401/speechdata/Testing/', FD(i).name));
    disp(mfcc);
end
