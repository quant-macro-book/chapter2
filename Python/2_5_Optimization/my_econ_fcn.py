"""
Purpose:
Collect functions:
(1) CRRA utility function
(2) marginal utlity function.
(3) Objective of two period model.
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


def obj_two_period(a, w, beta, gamma, rent):
    """
    Objective of two period model.
    :params: a: savings (choice variable).
    :params: w: wage.
    :params: beta: discount factor.
    :params: rent: interest rate.
    :return: value: life time utility level.
    """

    # utility at period 1
    if w - a > 0.0:
        util_y = CRRA(w - a, gamma)
    else:
        util_y = -1000000.0

    # utility at period 2
    util_o = beta*CRRA((1.0+rent)*a, gamma)

    # total utility: use minimization subroutine
    value = -1.0*(util_y + util_o)

    return value
