flacFiles    = '/u/cs401/speechdata/Testing/*.flac';
likFiles     = './*.lik';
testDir      = '/u/cs401/speechdata/Testing/';
FD           = dir(flacFiles);
LD           = dir(likFiles);

% Speech-to-text
output = fopen('4.1output.txt', 'w');
for i=1:length(FD)
    % Get the absolute file path
    flac = [testDir '/' 'unkn_' int2str(i) '.flac'];
    text = char(speechToText(flac));
    textArray = strsplit(lower(text));
    
    annoFile = fopen([testDir '/' 'unkn_' int2str(i) '.txt']);
    annoContent = textscan(annoFile, '%d %d %s', 'delimiter','\n');
    oriAnnosen = annoContent{3};
    annosen = char(lower(regexprep(oriAnnosen, '[^a-zA-Z ]', '')));
    annoArray = strsplit(annosen);
    word_count = length(annoArray);
    
    [se_count, ie_count, de_count]=singleSentLevenshtein(textArray, annoArray);
    
    sentSE = se_count / word_count;
    sentIE = ie_count / word_count;
    sentDE = de_count / word_count;
    
    fprintf(output, 'recognized transcript: %s\nSE = %d, IE = %d, DE = %d\n\n', text, annosen, sentSE, sentIE, sentDE);
    fclose(annoFile);
end
fclose(output);

% Text-to-speech
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
        flac = textToSpeech(annosen, 'en-US_MichaelVoice', ['trans4.2_' int2str(i) '.flac']);
    else
        % Female
        flac = textToSpeech(annosen, 'en-US_LisaVoice', ['trans4.2_' int2str(i) '.flac']);
    end
end
