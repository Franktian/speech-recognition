function [SE IE DE LEV_DIST] =Levenshtein(hypothesis,annotation_dir)
% Input:
%	hypothesis: The path to file containing the the recognition hypotheses
%	annotation_dir: The path to directory containing the annotations
%			(Ex. the Testing dir containing all the *.txt files)
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

if nargin < 2
    hypothesis = '/u/cs401/speechdata/Testing/hypotheses.txt';
    annotation_dir = '/u/cs401/speechdata/Testing';
end

SE = 0;
IE = 0;
DE = 0;
LEV_DIST = 0;
total_wcount = 0;
output = fopen('3.3output.txt', 'w');

hypo = fopen(hypothesis, 'r');
hypoContent = textscan(hypo, '%d %d %s', 'delimiter','\n');
hypoSens = hypoContent{3};
annoDir = dir(annotation_dir);

for i=1:length(hypoSens)
    oriHyposen = hypoSens{i};
    
    hyposen = char(lower(regexprep(oriHyposen, '[^a-zA-Z ]', '')));
    hypoArray = strsplit(hyposen);
    
    annoContent = textscan(fopen([annotation_dir '/' 'unkn_' int2str(i) '.txt']), '%d %d %s', 'delimiter','\n');
    oriAnnosen = annoContent{3};
    annosen = char(lower(regexprep(oriAnnosen, '[^a-zA-Z ]', '')));
    annoArray = strsplit(annosen);
    
    sent_wcount = length(annoArray);
    total_wcount = total_wcount + sent_wcount;
    
    [sub, ins, del]=singleSentLevenshtein(hypoArray, annoArray);
    
    fprintf(output, 'hypothesis sentence: %s\nsentence SE = %d, sentence IE = %d, sentence DE = %d, \n\n', hyposen, sub/sent_wcount, ins/sent_wcount, del/sent_wcount);

    SE = SE + sub;
    DE = DE + del;
    IE = IE + ins;
end


SE = SE / word_count;
DE = DE / word_count;
IE = IE / word_count;
LEV_DIST = SE + DE + IE;

end

