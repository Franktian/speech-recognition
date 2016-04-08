clear;
clc;
% This line is necessary if Default.mat is not presented
% myTrain

% Initial parameter setup
testDir     = '/u/cs401/speechdata/Testing/';
phnFiles    = '/u/cs401/speechdata/Testing/*.phn';
SD          = dir(phnFiles);
phnStruct   = {};
numPhns     = 0;
correctPhns = 0;
hmmFile      = 'Default.mat';
D           = 14;
load(hmmFile);

addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));

for i=1:length(SD)
    speaker = SD(i);

    phnFile = fopen([testDir '/' speaker.name], 'r');
    texts = textscan(phnFile, '%d %d %s');
    % Reading phoneme and start & end indices
    starts = texts{1};
    ends = texts{2};
    phns = texts{3};

    mfcc = load(strcat(testDir, '/', [speaker.name(1:end-3), 'mfcc']));
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

        % Classify the test phonemes
        predict_phn = {};
        predict_phn.name = '';
        predict_phn.prob = -Inf;

        trained_phns = fieldnames(hmms);
        for t=1:length(trained_phns)
            trained_phn = char(trained_phns{t});
%             disp(trained_phn);
            prob = loglikHMM(hmms.(trained_phn), mfcc(:, start:en));
%             disp(prob);

            if prob > predict_phn.prob
                predict_phn.name = trained_phn;
                predict_phn.prob = prob;
            end
        end

        if strcmp(predict_phn.name, phn)
            correctPhns = correctPhns + 1;
        end
        numPhns = numPhns + 1;
        disp(hmmFile);
        disp(correctPhns);
        disp(numPhns);

    end
end
disp(hmmFile);
disp(correctPhns/numPhns);
