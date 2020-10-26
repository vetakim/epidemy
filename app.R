library(shiny)
source(file="sir.R")

ui <- fluidPage(
                titlePanel("SIR модель!"),
                sidebarLayout(
                              sidebarPanel(
                                           sliderInput(inputId = "numberOfpopulation",
                                                       label="Численность населения",
                                                       min=1,
                                                       max=1000,
                                                       value=1),
                                           sliderInput(inputId = "initialNumberOfInfected",
                                                       label="Начальное количество больных",
                                                       min=0,
                                                       max=10,
                                                       value=0),
                                           sliderInput(inputId = "prognosisHorizont",
                                                       label="Горизонт прогноза",
                                                       min=1,
                                                       max=1000,
                                                       value=30),
                                           checkboxGroupInput(inputId = "SIRGroupChoice",
                                                              label = "Вывести на график:",
                                                              choiceNames=list("Восприимчивые", "Инфицированные", "Выбывшие"),
                                                              choiceValues = list("susceptible", "infected", "removed"))
                                           ),
                              mainPanel(
                                        plotOutput(outputId="distPlot")
                              )
                )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({

    timeLine <- seq(0, input$prognosisHorizont,1)
    initialSusceptibleNumber <- input$numberOfpopulation - input$initialNumberOfInfected
    initialRemovedNumber <- 0
    epidemy <- createEpidemyFrame(0,
                                  initialSusceptibleNumber,
                                  input$initialNumberOfInfected,
                                  initialRemovedNumber)
    for ( t in timeLine ) {
      epidemy <- evaluateNextEpidemyState(epidemy, t, 0.5, 0.03, input$numberOfpopulation)
    }

    t <- epidemy$time
    S <- epidemy$susceptible
    I <- epidemy$infected
    R <- epidemy$removed

    plot(1, type="n", xlim=c(0, input$prognosisHorizont), ylim=c(0, input$numberOfpopulation))

    for ( choice in input$SIRGroupChoice ) {
      if ( choice == "susceptible" ) {
        lines(t, S, type="l", col="#fa0000", lwd=4, lty=2)
      }
      if ( choice == "infected" ) {
        lines(t, I, type="l", col="#ffaa00", xlab="N",ylab="Random X", main="График", lwd=4)
      }
      if ( choice == "removed" ) {
        lines(t, R, type="l", col="#009999", xlab="N",ylab="Random X", main="График", lwd=4, lty=3)
      }
    }

  })
}

shinyApp(ui = ui, server = server)
