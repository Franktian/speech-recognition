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
  
hypo = fopen(hypothesis, 'r');
hypoContent = textscan(hypo, '%d %d %s', 'delimiter','\n');
hypoSens = hypoContent{3};
annoDir = dir(annotation_dir);

for i=1:size(hypoSens)
    oriHyposen = hypoSens{i};
    hyposen = char(lower(regexprep(oriHyposen, '[^a-zA-Z ]', '')));
    hypoArray = strsplit(hyposen);
    
    annoContent = textscan(fopen([annotation_dir '/' 'unkn_' int2str(i) '.txt']), '%d %d %s', 'delimiter','\n');
    oriAnnosen = annoContent{3};
    annosen = char(lower(regexprep(oriAnnosen, '[^a-zA-Z ]', '')));
    disp(class(annosen));
    annoArray = strsplit(annosen);
    
    n = size(annoArray, 2);
    m = size(hypoArray, 2);
    R = zeros(n+1, m+1);
    B = zeros(n+1, m+1);
    R(:, 1) = inf;
    R(1, :) = inf;
    R(1, 1) = 0;
    for x=2:n+1
        for y=2:m+1
            del = R(x-1, y)+1;
            sub = R(x-1, y-1) + annoArray()
        end
    end
    
    
end
% disp(hypoSens);
