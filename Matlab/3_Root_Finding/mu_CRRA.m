function mu = mu_CRRA(cons, gamma)
% Function mu_CRRA
%  marginal_utility = mu_CRRA(consumption, gamma)
%
% Purpose:
%  Compute marginal utility of CRRA-type function

mu = cons.^-gamma;

return;
