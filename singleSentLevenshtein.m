function [se_count, ie_count, de_count] = singleSentLevenshtein(hypoArray, annoArray)
    
    UP = -1;
    LEFT = 0;
    UP_LEFT = 1;

    n = length(annoArray);
    m = length(hypoArray);
    R = zeros(n+1, m+1);
    B = zeros(n+1, m+1);
    R(:, 1) = inf;
    R(1, :) = inf;
    R(1, 1) = 0;
    for x=2:n+1
        for y=2:m+1
            del = R(x-1, y)+1;
            sub = R(x-1, y-1);
            if ~strcmp(annoArray(x-1), hypoArray(y-1))
                sub = sub + 1;
            end
            ins = R(x, y-1) + 1;

            R(x, y) = min([del; sub; ins]);

            if R(x, y) == del
                B(x, y) = UP;
            elseif R(x, y) == ins
                B(x, y) = LEFT;
            else
                B(x, y) = UP_LEFT;
            end
        end
    end

    de_count = 0;
    se_count = 0;
    ie_count = 0;
    x = n+1;
    y = m+1;

    while x > 1 & y > 1
        if B(x, y) == UP
            de_count = de_count + 1;
            x = x - 1;
        elseif B(x, y) == LEFT
            ie_count = ie_count + 1;
            y = y - 1;
        else
            if ~strcmp(annoArray(x-1), hypoArray(y-1))
                se_count = se_count + 1;
            end
            x = x - 1;
            y = y - 1;
        end
    end
end