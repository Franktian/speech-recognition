function [gmms, Ls] = gmmTrain( dir_train, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  dir_train  : a string pointing to the high-level
%                        directory containing each speaker directory
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  gmms       : a 1xN cell array. The i^th element is a structure
%                        with this structure:
%                            gmm.name    : string - the name of the speaker
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture
    gmms = {};
    Ls = zeros(1, 30);

    % Load the speech data
    SD = dir(dir_train);
    for i = 1:length(SD)
        speaker = SD(i);
        % Ignore current and previous directory
        if strcmp(speaker.name, '.') || strcmp(speaker.name, '..')
            continue;
        end
        %disp(i);
        %disp(speaker);
        speaker_i = i - 2;
        gmms{speaker_i} = struct();
        gmms{speaker_i}.name = speaker.name;

        % Get all mfcc data for the speaker
        MD = dir(strcat(dir_train, '/', speaker.name, '/*.mfcc'));
        mfcc = [];
        for j = 1:length(MD)
            mfcc = [mfcc; load(strcat(dir_train, '/', speaker.name, '/', MD(j).name))];
        end

        % Randomize the mfcc
        mfcc = mfcc(randperm(size(mfcc,1)),:);

        % Initialization
        theta = initialize_theta(mfcc, M);

        % Training
        k = 0;
        prev_L = -Inf;
        improvement = Inf;
        while k <= max_iter && improvement >= epsilon
            [L, theta, b] = em_step(mfcc, theta, M);
            improvement = L - prev_L;
            prev_L = L;
            k = k + 1;
        end
        Ls(speaker_i) = L;

        % Training completed, assign the values to GMM
        gmms{speaker_i}.weights = theta.weights;
        gmms{speaker_i}.means = theta.means;
        gmms{speaker_i}.cov = theta.cov;

    end

function theta = initialize_theta(mfcc, M)
    theta = struct();
    
    theta.weights = 1/M * ones(1, M);
    theta.means = mfcc(1:M, :)';
    theta.cov = repmat(eye(size(mfcc, 2)), 1, 1, M);

function [L, theta, b] = em_step(X, theta, M)    
    d = size(X, 2);
    t = size(X, 1);

    % Do calculations in log domain, E step
    numerator = zeros(t, M);
    for i=1:d
        numerator = numerator + (repmat(X(:,i),1,M) - repmat(theta.means(i,:),t,1)).^2 ./ squeeze(repmat(theta.cov(i,i,:),1,t,1));
    end
    numerator = -0.5 * numerator;

    covs = zeros(d, M);
    for i=1:M
        covs(:, i) = diag(theta.cov(:,:,i));
    end

    denominator = d/2 * log(2 * pi) + 1/2 * repmat(sum(log(covs), 1), t, 1);

    b = numerator - denominator;

    % Get log likelihood
    L = sum(log(theta.weights * exp(b)'), 2) / t;

    % M step
    wb = repmat(theta.weights, t, 1) .* exp(b);
    cond_probs = wb ./ repmat(sum(wb, 2), 1, M);

    % Update theta
    sum_t = sum(cond_probs, 1);
    theta.weights = sum_t / t;
    theta.means = X' * cond_probs ./ repmat(sum_t, d, 1);
    sigmas = ((X.^2)' * cond_probs ./ repmat(sum_t, d, 1)) - theta.means.^2;
    for i=1:M
        theta.cov(:,:,i) = diag(sigmas(:,i));
    end
