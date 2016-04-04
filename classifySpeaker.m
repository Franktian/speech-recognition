function guess = classifySpeaker(mfcc, gmms, M)
    % Given the mfcc data and the Gaussian model output the guess

    TLs = zeros(1, length(gmms));
    % Compute likelihood for test data
    for j=1:length(gmms)
        [TLs(j), ~] = computeLikelihood(mfcc, gmms{j}, M);
    end

    % Sort
    [~, ind] = sort(TLs, 'descend');

    % Make the guess
    guess = gmms{ind(1)}.name;
