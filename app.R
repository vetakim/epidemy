library(shiny)
source(file="sir.R")
source(file="epidemyState.R")

ui <- fluidPage(
                titlePanel("SIR модель"),
                plotOutput(outputId="distPlot"),
                hr(),
                fluidRow(
                         column(3,
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
                                            value=100)),
                         column(3,
                                h4("Модель I"),
                                sliderInput(inputId = "transitFactor",
                                            label="Коэффициент передачи",
                                            min=0,
                                            max=1,
                                            value=0.5),
                                sliderInput(inputId = "infectionPeriod",
                                            label="Инфекционный период (дней)",
                                            min=1,
                                            max=60,
                                            value=14)),
                         column(3,
                                h4("Модель II"),
                                sliderInput(inputId = "transitFactor2",
                                            label="Коэффициент передачи",
                                            min=0,
                                            max=1,
                                            value=0.5),
                                sliderInput(inputId = "infectionPeriod2",
                                            label="Инфекционный период (дней)",
                                            min=1,
                                            max=60,
                                            value=14),
                                sliderInput(inputId = "quarantineBegin",
                                            label="Дата ввода карантина для 80% заболевших",
                                            min=1,
                                            max=1000,
                                            value=101),
                                sliderInput(inputId = "quarantineContactsDecrease",
                                            label="Снижение частоты контактов, %",
                                            min=0,
                                            max=100,
                                            value=0),
                                sliderInput(inputId = "remoteBegin",
                                            label="Дата перевода на удаленку 30% населения",
                                            min=1,
                                            max=1000,
                                            value=101),
                                sliderInput(inputId = "remoteContactsDecrease",
                                            label="Снижение частоты контактов, %",
                                            min=0,
                                            max=100,
                                            value=0),
                                sliderInput(inputId = "masksBegin",
                                            label="Дата ввода санитарно-гигиенических мер",
                                            min=1,
                                            max=1000,
                                            value=101),
                                sliderInput(inputId = "masksContactsDecrease",
                                            label="Снижение частоты конактов, %",
                                            min=0,
                                            max=100,
                                            value=0)
                                ),

                         column(3,
                                checkboxGroupInput(inputId = "SIRGroupChoice",
                                                   label = "Вывести на график:",
                                                   choiceNames=list("Восприимчивые", "Инфицированные", "Выбывшие"),
                                                   choiceValues = list("susceptible", "infected", "removed")),
                                actionButton(inputId="calculate", label="Рассчитать")
                                ),
                         ),

)

server <- function(input, output, session) {

    model <- eventReactive(input$calculate, {
                               gammaI = 1.0 / input$infectionPeriod
                               betaI = input$transitFactor
                               gammaII = 1.0 / input$infectionPeriod2
                               betaII = input$transitFactor2
                               epidemyI <- calcEpidemyState(input, betaI, gammaI, FALSE)
                               epidemyII <- calcEpidemyState(input, betaII, gammaII, TRUE)
                               epidemies <- data.frame(first=epidemyI, second=epidemyII)
                               return(epidemies)
})

    output$distPlot <- renderPlot({
        epidemy <- model()
        t <- epidemy$first.time
        S <- epidemy$first.susceptible
        I <- epidemy$first.infected
        R <- epidemy$first.removed
        t2 <- epidemy$second.time
        S2 <- epidemy$second.susceptible
        I2 <- epidemy$second.infected
        R2 <- epidemy$second.removed
        plot(1, type="n", xlim=c(0, input$prognosisHorizont), ylim=c(0, input$numberOfpopulation))

        for ( choice in input$SIRGroupChoice ) {
            if ( choice == "susceptible" ) {
                lines(t, S, type="l", col="#fa0000", lwd=4, lty=1)
                lines(t2, S2, type="l", col="#ff7373", lwd=5, lty=3)
            }
            if ( choice == "infected" ) {
                lines(t, I, type="l", col="#ffaa00", xlab="N",ylab="Random X", main="График", lwd=4, lty=1)
                lines(t2, I2, type="l", col="#ffd073", xlab="N",ylab="Random X", main="График", lwd=5, lty=3)
            }
            if ( choice == "removed" ) {
                lines(t, R, type="l", col="#009999", xlab="N",ylab="Random X", main="График", lwd=4, lty=1)
                lines(t2, R2, type="l", col="#5ccccc", xlab="N",ylab="Random X", main="График", lwd=5, lty=3)
            }
        }
    })

}

shinyApp(ui = ui, server = server)
