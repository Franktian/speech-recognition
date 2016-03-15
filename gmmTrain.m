function [gmms, mfcc] = gmmTrain( dir_train, max_iter, epsilon, M )
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
        D = size(mfcc, 2);
        gmms{speaker_i}.weights = 1/M * ones(1, M);
        gmms{speaker_i}.means = mfcc(1:M, :)';
        gmms{speaker_i}.covs = repmat(eye(D),1,1,M);
    end
