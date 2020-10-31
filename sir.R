createEpidemyFrame <- function(t, S, I, R) {
    print(epidemy.data <- data.frame(time = t, susceptible = S, infected = I, removed = R))
}

modelEpidemyForTimeline <- function(timeLine, epidemyFrame, beta, gamma, N) {
    for ( t in timeLine ) {
        epidemyFrame <- evaluateNextEpidemyState(epidemyFrame, t, beta, gamma, N)
    }
    print(epidemyFrame)
}

evaluateNextEpidemyState <- function(epidemyFrame, t, beta, gamma, N) {
    previousState <- epidemyFrame[nrow(epidemyFrame),]
    t0 <- previousState$time
    prevS <- previousState$susceptible
    prevI <- previousState$infected
    prevR <- previousState$removed
    dS <- calcSusceptible( prevI, prevS, beta, N )
    dI <- calcInfected( prevI, prevS, beta, gamma, N)
    dR <- calcRemoved( prevI, gamma)
    S <- calcValueWithDerivative(t, t0, prevS, dS)
    I <- calcValueWithDerivative(t, t0, prevI, dI)
    R <- calcValueWithDerivative(t, t0, prevR, dR)
    newState <- data.frame( time = t, susceptible = S, infected = I, removed = R)
    epidemyFrame <- rbind(epidemyFrame, newState)
    print(epidemyFrame)
}

calcValueWithDerivative <- function(t1, t0, x0, dx) {
    print( dx * ( t1 - t0 ) + x0 )
}

calcSusceptible <- function( prevI, prevS, beta, N ) {
    print( -beta * prevI * prevS / N )
}

calcInfected <- function( prevI, prevS, beta, gamma, N) {
    print( beta * prevS * prevI / N - gamma * prevI )
}

calcRemoved <- function( prevI, gamma ) {
    print( gamma * prevI )
}

