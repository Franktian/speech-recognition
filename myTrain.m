% Initial parameter setup
trainDir    = '/u/cs401/speechdata/Training';
SD          = dir(trainDir);
phnStruct = {};

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
        for p=1:length(phns)
            % phn indices are 0 based, fixed to accomedate matlab 1 based
            start = starts(p)/128 + 1;
            en = ends(p)/128 + 1;
            phn = char(phns(p));

            if strcmp(phn, 'h#')
                phn = 'sil';
            end

            if ~isfield(phnStruct, phn)
                phnStruct.(phn) = {};
            end
            pi = length(phnStruct.(phn)) + 1;
            mfcc = mfcc';
            phnStruct.(phn){pi} = mfcc(:, start:end);
        end
    end
end
