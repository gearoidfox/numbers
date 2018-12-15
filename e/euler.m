% Estimate e (base of natural logarithm)
%
% Use binary search to find value of e
% such that the integral from 1 to e of 1/x is equal to 1

clear

% bracket e:
low = 1; % lower bound
high = 10; % upper bound

tol = 1e-12; % error tolerance for integral

e_est = []; % successive trial values of e
areas = []; % area under curve for trial values

err = 1; 
while abs(err) > tol
        mid = low + (high - low) / 2; % new midpoint
        e_est = [e_est; mid];
        
        auc = integral(mid); % evalute integral at midpoint
        areas = [areas; auc];
        
        % Update bounds:
        err = auc - 1 ;
        if err > 0
                high = mid;
        else
                low = mid;
        end
end
plot([e_est, areas]);
legend('e (estimate)', 'area under curve');
xlabel('iterations');
printf("Final estimate for e: %.12f\nArea under curve: %.12e\n", e_est(end), areas(end))
