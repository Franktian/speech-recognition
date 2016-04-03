% Initial parameters setup
trainDir    = '/u/cs401/speechdata/Training';
testDir     = '/u/cs401/speechdata/Testing';
FD          = dir([testDir '/*.mfcc']);
M           = 8;
epsilon     = 0.01;
max_iter    = 100;

% Load the gmm model and log likehoods
[gmms, Ls] = gmmTrain( trainDir, max_iter, epsilon, M );

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

end
