CRRA <- function(cons, gamma) {
    if (gamma != 1.0){
        util <- cons^(1-gamma)/(1-gamma)
    } else {
        util <- log(cons)
    }
    return(util)
}
