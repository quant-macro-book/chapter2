function cons = inv_mu_CRRA(mu, gamma)
% Function inv_mu_CRRA
%  [consumption] = inv_mu_CRRA( mu )
%
% 目的:
% 限界効用の逆関数を計算して消費を返す.

cons = mu^(-1/gamma);

return;
