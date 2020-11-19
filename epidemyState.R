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
    rho <- commonParameters$vaccineRate / 100
    currentRho = 0
    qFactor <- createPulse(commonParameters$quarantineBegin, commonParameters$quarantineEnd, timeLine, Q)
    rFactor <- createPulse(commonParameters$remoteBegin, commonParameters$remoteEnd, timeLine, R)
    mFactor <- createPulse(commonParameters$masksBegin, commonParameters$masksEnd, timeLine, M)
    betaVector <- beta * qFactor * rFactor * mFactor
    if ( restrict ) {
        i <- 1
        for ( t in timeLine ) {

            if ( t == commonParameters$vaccineBegin ) {
                currentRho = rho
            }

            epidemy <- evaluateNextEpidemyState(epidemy, t, betaVector[i], gamma, currentRho, N)
            i <- i + 1
        }
    } else {
        for ( t in timeLine ) {
            epidemy <- evaluateNextEpidemyState(epidemy, t, beta, gamma, currentRho, N)
        }
    }
    return(epidemy)
}

calcInverseShareFromPercentage <- function(percentage)
{
    return ( 1 - percentage / 100 )
}

createPulse <- function(tmin, tmax, ts, amplitude)
{
    f <- array(1, dim=length(ts))
    for ( t in tmin:tmax ) {
        f[t] <- amplitude
    }
    return(f)
}

