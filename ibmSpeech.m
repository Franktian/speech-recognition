flacFiles    = '/u/cs401/speechdata/Testing/*.flac';
likFiles     = './*.lik';
testDir      = '/u/cs401/speechdata/Testing/';
FD           = dir(flacFiles);
LD           = dir(likFiles);

% 4.1 Speech-to-text
speechToTextErrorRate('/u/cs401/speechdata/Testing/', 'unkn_', '4.1output.txt');

% 4.2 Text-to-speech
% Assumed .lik files in the same directory as this script
for i=1:length(LD)
    % Get classification from part 2
    lik = fopen(['unkn_' int2str(i) '.lik']);
    likContent = textscan(lik, '%d %s', 'delimiter','\n');
    predicted = likContent{2}{1};
    fclose(lik);
    
    % Get the associated txt file
    annoFile = fopen([testDir '/' 'unkn_' int2str(i) '.txt']);
    annoContent = textscan(annoFile, '%d %d %s', 'delimiter','\n');
    oriAnnosen = annoContent{3};
    annosen = char(lower(regexprep(oriAnnosen, '[^a-zA-Z ]', '')));
    fclose(annoFile);
    
    if strcmp(predicted(1), 'M')
        % Male
        textToSpeech(annosen, 'en-US_MichaelVoice', ['trans4.2_' int2str(i) '.flac']);
    else
        % Female
        textToSpeech(annosen, 'en-US_LisaVoice', ['trans4.2_' int2str(i) '.flac']);
    end
end

speechToTextErrorRate('./', 'trans4.2_', '4.2output.txt');
