function [L, b] = computeLikelihood(X, theta, M)
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
