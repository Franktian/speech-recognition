% Initial parameters setup
trainDir    = '/u/cs401/speechdata/Training';
testDir     = '/u/cs401/speechdata/Testing';
FD          = dir([testDir '/*.mfcc']);
M           = 8;
epsilon     = 0.01;
max_iter    = 100;

% Load the gmm model and log likehoods
[gmms, Ls] = gmmTrain( trainDir, max_iter, epsilon, M );
% These are the correct classifications for the first 15 people
classifications = {
    'MMRP0','MPGH0','MKLW0','FSAH0','FVFB0',
    'FJSP0','MTPF0','MRDD0','MRSO0','MKLS0',
    'FETB0','FMEM0','FCJF0','MWAR0','MTJS0'};

for i=1:length(FD)
    % Load the test data
    mfcc = load(strcat('/u/cs401/speechdata/Testing/', FD(i).name));

    TLs = zeros(1, length(gmms));
    % Compute likelihood for test data
    for j=1:length(gmms)
        [TLs(j), ~] = computeLikelihood(mfcc, gmms{j}, M);
    end

    % Sort
    [res, ind] = sort(TLs, 'descend');

    % Write top five to file
    fi = sscanf(FD(i).name, 'unkn_%d.mfcc');
    file_name = strcat('unkn_', int2str(fi), '.lik');
    fileID = fopen(file_name, 'w');
    for j=1:5
        fprintf(fileID, '%2.4f\t%s\n', res(j), gmms{ind(j)}.name);
    end
    fclose(fileID);

    % Compute classification rate
    correct_num = 0;
    if fi < 16
        disp('Our guess');
        disp(gmms{ind(j)}.name);
        disp('Correct');
        disp(classifications{fi});
        if strcmp(gmms{ind(1)}.name, classifications{fi})
            correct_num = correct_num + 1;
        end
    end

end

% Classification rate
disp(correct_num/15);