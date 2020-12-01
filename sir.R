createEpidemyFrame <- function(t, S, I, R) {
    return(epidemy.data <- data.frame(time = t, susceptible = S, infected = I, removed = R))
}

evaluateNextEpidemyState <- function(epidemyFrame, t, beta, gamma, Vn, N) {
    previousState <- epidemyFrame[nrow(epidemyFrame),]
    t0 <- previousState$time
    prevS <- previousState$susceptible
    prevI <- previousState$infected
    prevR <- previousState$removed
    dS <- calcSusceptibleMinusVaccinatedGroup( prevI, prevS, beta, Vn, N )
    dI <- calcInfected( prevI, prevS, beta, gamma, N)
    dR <- calcRemoved( prevI, gamma)
    S <- calcValueWithDerivative(t, t0, prevS, dS)
    if ( S < 0 ) {
        S = 0
    }
    if ( S > N ) {
        S = N
    }
    I <- calcValueWithDerivative(t, t0, prevI, dI)
    if ( I < 0 ) {
        I = 0
    }
    if ( I > N ) {
        I = N
    }
    R <- calcValueWithDerivative(t, t0, prevR, dR)
    if ( R < 0 ) {
        R = 0
    }
    if ( R > N ) {
        R = N
    }
    newState <- data.frame( time = t, susceptible = S, infected = I, removed = R)
    epidemyFrame <- rbind(epidemyFrame, newState)
    return(epidemyFrame)
}

calcValueWithDerivative <- function(t1, t0, x0, dx) {
    return( dx * ( t1 - t0 ) + x0 )
}

calcSusceptible <- function( prevI, prevS, beta, rho, N ) {
    return( -beta * prevI * prevS / N - rho * prevS )
}

calcSusceptibleMinusVaccinatedGroup <- function( prevI, prevS, beta, vaccineGroup, N ) {
    return( calcSusceptible(prevI, prevS, beta, 0, N) - vaccineGroup )
}

calcInfected <- function( prevI, prevS, beta, gamma, N) {
    return( beta * prevS * prevI / N - gamma * prevI )
}

calcRemoved <- function( prevI, gamma ) {
    return( gamma * prevI )
}

