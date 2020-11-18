source(file="sir.R")

calcEpidemyState <- function(commonParameters, beta, gamma) {
    timeLine <- seq(0, commonParameters$prognosisHorizont,1)
    initialSusceptibleNumber <- commonParameters$numberOfpopulation - commonParameters$initialNumberOfInfected
    initialRemovedNumber <- 0
    epidemy <- createEpidemyFrame(0,
                                  initialSusceptibleNumber,
                                  commonParameters$initialNumberOfInfected,
                                  initialRemovedNumber)
    epidemy <- modelEpidemyForTimeline(timeLine, epidemy, beta, gamma, commonParameters$numberOfpopulation)
    return(epidemy)
}
