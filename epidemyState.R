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
    Q <- calcInverseShareFromPercentage(restrict$quarantineContactsDecrease)
    R <- calcInverseShareFromPercentage(restrict$remoteContactsDecrease)
    M <- calcInverseShareFromPercentage(restrict$masksContactsDecrease)
    rho <- restrict$vaccineRate / 100
    currentRho = 0
    qFactor <- createPulse(restrict$quarantineBegin, restrict$quarantineEnd, timeLine, Q)
    rFactor <- createPulse(restrict$remoteBegin, restrict$remoteEnd, timeLine, R)
    mFactor <- createPulse(restrict$masksBegin, restrict$masksEnd, timeLine, M)
    betaVector <- beta * qFactor * rFactor * mFactor
    i <- 1
    for ( t in timeLine ) {

        if ( t == commonParameters$vaccineBegin ) {
            currentRho = rho
        }

        epidemy <- evaluateNextEpidemyState(epidemy, t, betaVector[i], gamma, currentRho, N)
        i <- i + 1
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
    tsmin = min(ts)
    tsmax = max(ts)
    for ( t in tmin:tmax ) {
        if ( t > tsmin && t < tsmax ) {
            f[t] <- amplitude
        }
    }
    return(f)
}

