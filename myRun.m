% Initial parameter setup
testDir     = '/u/cs401/speechdata/Testing/';
phnFiles    = '/u/cs401/speechdata/Testing/*.phn';
SD          = dir(phnFiles);
phnStruct   = {};

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
    
    disp(mfcc);
    
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
        phnStruct.(phn){pi} = mfcc(:, start:end);
    end
end
