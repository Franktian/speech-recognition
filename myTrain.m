% Initial parameter setup
trainDir    = '/u/cs401/speechdata/Training';
SD          = dir(trainDir);
phnStruct   = {};
hmms        = struct();
max_iter    = 5;
hmmFile      = 'Default.mat';
M           = 8;
Q           = 3;
D           = 14;

addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));

for i=1:length(SD)
    speaker = SD(i);
    % Ignore current and previous directory
    if strcmp(speaker.name, '.') || strcmp(speaker.name, '..')
        continue;
    end
    si = i - 2;

    % Read phoneme
    PF = dir(strcat(trainDir, '/', speaker.name, '/*.phn'));

    for j=1:length(PF)
        phnFile = fopen( [trainDir '/' speaker.name '/' PF(j).name], 'r');
        texts = textscan(phnFile, '%d %d %s');
        starts = texts{1};
        ends = texts{2};
        phns = texts{3};

        % Readin corresponding mfcc
        mfcc = load(strcat(trainDir, '/', speaker.name, '/', [PF(j).name(1:end-3), 'mfcc']));
        mfcc = mfcc';
        mfcc = mfcc(1:D, :);

        for p=1:length(phns)
            % phn indices are 0 based, fixed to accomedate matlab 1 based
            start = starts(p)/128 + 1;
            en = ends(p)/128 + 1;
            % Prevent index overflow
            if length(mfcc) <= en
                en = length(mfcc);
            end
            phn = char(phns(p));

            if strcmp(phn, 'h#')
                phn = 'sil';
            end

            if ~isfield(phnStruct, phn)
                phnStruct.(phn) = {};
            end

            % Append the mfcc to the corresponding phoneme
            pi = length(phnStruct.(phn)) + 1;
            phnStruct.(phn){pi} = mfcc(:, start:en);
        end
        fclose(phnFile);
    end
end

% Training Hidden Markov Models
phnNames = fieldnames(phnStruct);
for i=1:length(phnNames)
    disp(i);
    disp(hmmFile);
    phnName = phnNames{i};
    hmms.(phnName) = initHMM(phnStruct.(phnName), M, Q);
    [hmms.(phn), ~] = trainHMM(hmms.(phnName), phnStruct.(phnName), max_iter);
end

save( hmmFile, 'hmms', '-mat');
