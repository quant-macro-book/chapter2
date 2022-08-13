"""
Purpose: Collect the following functions.
(1) CRRA utility function
(2) marginal utlity function.
(3) Residual of two period model.
@author: Tomoaki Yamada
"""


def CRRA(cons, gamma):
    """
    CRRA utility function.
    :params: cons: consumption level.
    :params: gamma: relative risk aversion.
    :return: util: utility level.
    """

    import math

    if not gamma == 1:
        util = cons**(1-gamma)/(1-gamma)
    else:
        util = math.log(cons)

    return util


def mu_CRRA(cons, gamma):
    """
    Return marginal value of CRRA utility function.
    :params: cons: consumption.
    :params: gamma: relative risk aversion.
    :return: mu: martinal utility.
    """

    mu = cons**-gamma

    return mu


def resid_two_period(a, w, beta, gamma, rent):
    """
    Residual of the Euler equation in two period model.
    :params: a: savings (choice variable).
    :params: w: wage.
    :params: beta: discount factor.
    :params: rent: interest rate.
    :return: resid: residual of the Euler equation.
    """

    # marginal utility at period 1
    if w - a > 0.0:
        mu1 = mu_CRRA(w - a, gamma)
    else:
        # marginal utility should be large number if c is small
        # (in fact, negative...)
        mu1 = 10000.0

    # marginal utility at period 2
    mu2 = mu_CRRA((1.0+rent)*a, gamma)

    # residual
    resid = beta*(1.0+rent)*(mu2/mu1) - 1.0

    return resid
