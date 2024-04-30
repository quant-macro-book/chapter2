function util = CRRA(cons, gamma)
% Function CRRA
%  utility = CRRA(consumption, gamma)
%
% Purpose:
%  Compute CRRA utility function

if gamma ~= 1
    util = cons.^(1-gamma)./(1-gamma);
else
    util = log(cons);
end

return;
