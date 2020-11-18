source(file="sir.R")

calcEpidemyState <- function(commonParameters, beta, gamma, restrict) {
    timeLine <- seq(0, commonParameters$prognosisHorizont,1)
    initialSusceptibleNumber <- commonParameters$numberOfpopulation - commonParameters$initialNumberOfInfected
    initialRemovedNumber <- 0
    N <- commonParameters$numberOfpopulation
    epidemy <- createEpidemyFrame(0,
                                  initialSusceptibleNumber,
                                  commonParameters$initialNumberOfInfected,
                                  initialRemovedNumber)
    Q <- calcInverseShareFromPercentage(commonParameters$quarantineContactsDecrease)
    R <- calcInverseShareFromPercentage(commonParameters$remoteContactsDecrease)
    M <- calcInverseShareFromPercentage(commonParameters$masksContactsDecrease)
    if ( restrict ) {
        for ( t in timeLine ) {
            if ( t == commonParameters$quarantineBegin ) {
                beta = beta * Q
            }
            if ( t == commonParameters$remoteBegin ) {
                beta = beta * R
            }
            if ( t == commonParameters$masksBegin ) {
                beta = beta * M
            }
            epidemy <- evaluateNextEpidemyState(epidemy, t, beta, gamma, N)
        }
    } else {
        for ( t in timeLine ) {
            epidemy <- evaluateNextEpidemyState(epidemy, t, beta, gamma, N)
        }
    }
    return(epidemy)
}

calcInverseShareFromPercentage <- function(percentage)
{
    return ( 1 - percentage / 100 )
}
