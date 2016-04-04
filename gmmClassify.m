% Initial parameters setup
trainDir    = '/u/cs401/speechdata/Training';
testDir     = '/u/cs401/speechdata/Testing';
FD          = dir([testDir '/*.mfcc']);
M           = 8;
epsilon     = 0.1;
max_iter    = 100;

% Load the gmm model and log likehoods
[gmms, Ls] = gmmTrain( trainDir, max_iter, epsilon, M );
% These are the correct classifications for the first 15 people(in the following order)
classifications = {'MMRP0','MPGH0','MKLW0','FSAH0','FVFB0','FJSP0','MTPF0','MRDD0','MRSO0','MKLS0','FETB0','FMEM0','FCJF0','MWAR0','MTJS0'};

correct_num = 0;

for i=1:length(FD)

    mfcc = load(strcat('/u/cs401/speechdata/Testing/', FD(i).name));

    [guess, res, ind] = classifySpeaker(mfcc, gmms, M);

    % Write top 5 predictions to file
    fi = sscanf(FD(i).name, 'unkn_%d.mfcc');
    file_name = strcat('unkn_', int2str(fi), '.lik');
    fileID = fopen(file_name, 'w');
    for j=1:5
        fprintf(fileID, '%2.4f\t%s\n', res(j), gmms{ind(j)}.name);
    end
    fclose(fileID);

    % Compute classification rate
    if fi < 16
        if strcmp(guess, classifications{fi})
            correct_num = correct_num + 1;
        end
    end
end
disp(correct_num);
