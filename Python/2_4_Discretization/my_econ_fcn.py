"""
Purpose:
Collect functions:
(1) CRRA utility function
(2) marginal utlity function.
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
