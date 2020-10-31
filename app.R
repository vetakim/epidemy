library(shiny)
source(file="sir.R")

ui <- fluidPage(
                titlePanel("SIR модель"),
                sidebarLayout(
                              sidebarPanel(
                                           sliderInput(inputId = "numberOfpopulation",
                                                       label="Численность населения",
                                                       min=2,
                                                       max=14e6,
                                                       value=1e6),
                                           sliderInput(inputId = "initialNumberOfInfected",
                                                       label="Начальное количество больных",
                                                       min=1,
                                                       max=1000,
                                                       value=3),
                                           sliderInput(inputId = "prognosisHorizont",
                                                       label="Горизонт прогноза",
                                                       min=1,
                                                       max=1000,
                                                       value=30),
                                           sliderInput(inputId = "transitFactor",
                                                       label="Коэффициент передачи",
                                                       min=0,
                                                       max=1,
                                                       value=0.5),
                                           sliderInput(inputId = "infectionPeriod",
                                                       label="Инфекционный период (дней)",
                                                       min=1,
                                                       max=60,
                                                       value=14),
                                           checkboxGroupInput(inputId = "SIRGroupChoice",
                                                              label = "Вывести на график:",
                                                              choiceNames=list("Восприимчивые", "Инфицированные", "Выбывшие"),
                                                              choiceValues = list("susceptible", "infected", "removed")),
                                           actionButton(inputId="calculate", label="Рассчитать")
                                           ),
                              mainPanel(
                                        plotOutput(outputId="distPlot")
                              )
                )
)

server <- function(input, output, session) {

    model <- eventReactive(input$calculate, {
        gamma = 1.0 / input$infectionPeriod
        beta = input$transitFactor

        timeLine <- seq(0, input$prognosisHorizont,1)
        initialSusceptibleNumber <- input$numberOfpopulation - input$initialNumberOfInfected
        initialRemovedNumber <- 0
        epidemy <- createEpidemyFrame(0,
                                      initialSusceptibleNumber,
                                      input$initialNumberOfInfected,
                                      initialRemovedNumber)
        epidemy <- modelEpidemyForTimeline(timeLine, epidemy, beta, gamma, input$numberOfpopulation)
    })

    output$distPlot <- renderPlot({
        epidemy <- model()
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
