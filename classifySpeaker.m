function [guess, res, ind] = classifySpeaker(mfcc, gmms, M)
    % Given the mfcc data and the Gaussian model output the guess

    classifications = {'MMRP0','MPGH0','MKLW0','FSAH0','FVFB0','FJSP0','MTPF0','MRDD0','MRSO0','MKLS0','FETB0','FMEM0','FCJF0','MWAR0','MTJS0'};

    TLs = zeros(1, length(gmms));
    % Compute likelihood for test data
    for j=1:length(gmms)
        % Ignore irrelevant speakers, commented out by default
%         if sum(strcmp(gmms{j}.name, classifications)) > 0
%             [TLs(j), ~] = computeLikelihood(mfcc, gmms{j}, M);
%         else
%             TLs(j) = -Inf;
%         end
        [TLs(j), ~] = computeLikelihood(mfcc, gmms{j}, M);
    end

    % Sort
    [res, ind] = sort(TLs, 'descend');

    % Make the guess
    guess = gmms{ind(1)}.name;
