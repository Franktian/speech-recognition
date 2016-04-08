function speechToTextErrorRate(flacDir, flacPrefix, outputname)

testDir      = '/u/cs401/speechdata/Testing/';
FD           = dir(flacDir);

% Speech-to-text
output = fopen(outputname, 'w');
for i=1:30
    % Get the absolute file path
    flac = [flacDir '/' flacPrefix int2str(i) '.flac'];
    text = char(speechToText(flac));
    disp(flac);
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
    sentWER = (se_count + ie_count + de_count) / word_count;
    str_test = sprintf('%d %d %d %d', se_count, ie_count, de_count, word_count);
    disp(str_test);

    fprintf(output, 'recognized transcript: %s\nSE = %.6f, IE = %.6f, DE = %.6f, WER = %.6f\n\n', text, sentSE, sentIE, sentDE, sentWER);
    fclose(annoFile);
end
fclose(output);

end