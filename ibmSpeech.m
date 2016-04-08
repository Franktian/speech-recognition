flacFiles    = '/u/cs401/speechdata/Testing/*.flac';
testDir      = '/u/cs401/speechdata/Testing/';
FD           = dir(flacFiles);

% Speech-to-text
output = fopen('4.1output.txt', 'w');
for i=1:length(FD)
    % Get the absolute file path
    flac = [testDir '/' 'unkn_' int2str(i) '.flac'];
    text = char(speechToText(flac));
    textArray = strsplit(lower(text));
    
    annoContent = textscan(fopen([testDir '/' 'unkn_' int2str(i) '.txt']), '%d %d %s', 'delimiter','\n');
    oriAnnosen = annoContent{3};
    annosen = char(lower(regexprep(oriAnnosen, '[^a-zA-Z ]', '')));
    annoArray = strsplit(annosen);
    word_count = length(annoArray);
    
    [se_count, ie_count, de_count]=singleSentLevenshtein(textArray, annoArray);
    
    sentSE = se_count / word_count;
    sentIE = ie_count / word_count;
    sentDE = de_count / word_count;
    
    fprintf(output, 'recognized transcript: %s\nSE = %d, IE = %d, DE = %d\n\n', text, annosen, sentSE, sentIE, sentDE);

end