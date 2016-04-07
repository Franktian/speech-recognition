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
word_count = 0;

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
    word_count = word_count + length(annoArray);
    
    [sub, ins, del]=singleSentLevenshtein(hypoArray, annoArray);
    
%     n = length(annoArray);
%     m = length(hypoArray);
%     R = zeros(n+1, m+1);
%     B = zeros(n+1, m+1);
%     R(:, 1) = inf;
%     R(1, :) = inf;
%     R(1, 1) = 0;
%     for x=2:n+1
%         for y=2:m+1
%             del = R(x-1, y)+1;
%             sub = R(x-1, y-1);
%             if ~strcmp(annoArray(x-1), hypoArray(y-1))
%                 sub = sub + 1;
%             end
%             ins = R(x, y-1) + 1;
% 
%             R(x, y) = min([del; sub; ins]);
% 
%             if R(x, y) == del
%                 B(x, y) = UP;
%             elseif R(x, y) == ins
%                 B(x, y) = LEFT;
%             else
%                 B(x, y) = UP_LEFT;
%             end
%         end
%     end
% 
%     del = 0;
%     sub = 0;
%     ins = 0;
%     x = n+1;
%     y = m+1;
% 
%     while x > 1 & y > 1
%         if B(x, y) == UP
%             del = del + 1;
%             x = x - 1;
%         elseif B(x, y) == LEFT
%             ins = ins + 1;
%             y = y - 1;
%         else
%             if ~strcmp(annoArray(x-1), hypoArray(y-1))
%                 sub = sub + 1;
%             end
%             x = x - 1;
%             y = y - 1;
%         end
%     end

    SE = SE + sub;
    DE = DE + del;
    IE = IE + ins;
end


SE = SE / word_count;
DE = DE / word_count;
IE = IE / word_count;
LEV_DIST = SE + DE + IE;

disp(SE);
disp(DE);
disp(IE);
disp(LEV_DIST);

end

