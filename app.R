library(shiny)
source(file="sir.R")
source(file="epidemyState.R")

ui <- fluidPage(
                titlePanel("SIR модель"),
                fluidRow(
                         column(4,
                                wellPanel( style="overflow-y:scroll; max-height: 600px",
                                          fluidRow(
                                                   column(6,
                                                          sliderInput(inputId = "numberOfpopulation",
                                                                      label="Численность населения",
                                                                      min=2, max=14e6, value=1e6),
                                                          sliderInput(inputId = "initialNumberOfInfected",
                                                                      label="Начальное число больных",
                                                                      min=1, max=1000, value=3),
                                                          dateInput(inputId = "beginDate",
                                                                    label="Дата начала эпидемии",
                                                                    min='2019-11-20', value='2020-03-21'),
                                                          sliderInput(inputId = "prognosisHorizont",
                                                                      label="Горизонт прогноза, дней",
                                                                      min=1, max=1000, value=100)
                                                          ),
                                                   column(6,
                                                          checkboxGroupInput(inputId = "SIRGroupChoice",
                                                                             label = "Вывести на график:",
                                                                             choiceNames=list("Восприимчивые", "Инфицированные", "Выбывшие"),
                                                                             choiceValues = list("susceptible", "infected", "removed")),
                                                          actionButton(inputId="calculate", label="Рассчитать"),
                                                   )
                                          ),

                                          column(6,
                                                 h1("Модель I"),
                                                 sliderInput(inputId = "transitFactor",
                                                             label="Коэффициент передачи",
                                                             min=0, max=1, value=0.5),
                                                 sliderInput(inputId = "infectionPeriod",
                                                             label="Инфекционный период (дней)",
                                                             min=1, max=60, value=14),
                                                 h3("Меры контроля"),
                                                 h4("Ввод карантина для заболевших"),
                                                 dateInput(inputId = "quarantineBegin",
                                                             label="Дата ввода карантина",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "quarantineContactsDecrease",
                                                             label="Снижение доли контактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "quarantineEnd",
                                                             label="Дата снятия карантина",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Перевод на удаленную работу"),
                                                 dateInput(inputId = "remoteBegin",
                                                             label="Дата перевода",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "remoteContactsDecrease",
                                                             label="Снижение доли контактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "remoteEnd",
                                                             label="Дата снятия перевода",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Ввод санитарно-гигиенических мер"),
                                                 dateInput(inputId = "masksBegin",
                                                             label="Дата ввода мер",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "masksContactsDecrease",
                                                             label="Снижение доли конактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "masksEnd",
                                                             label="Дата снятия мер",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Вакцинация"),
                                                 dateInput(inputId = "vaccineBegin",
                                                             label="Дата начала вакцинации",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "vaccineRate",
                                                             label="Доля вакцинированных, %",
                                                             min=0, max=100, value=0)
                                                 ),

                                          column(6,
                                                 h2("Модель II"),
                                                 sliderInput(inputId = "transitFactor2",
                                                             label="Коэффициент передачи",
                                                             min=0, max=1, value=0.5),
                                                 sliderInput(inputId = "infectionPeriod2",
                                                             label="Инфекционный период (дней)",
                                                             min=1, max=60, value=14),
                                                 h3("Меры контроля"),
                                                 h4("Ввод карантина для заболевших"),
                                                 dateInput(inputId = "quarantineBegin2",
                                                             label="Дата ввода карантина",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "quarantineContactsDecrease2",
                                                             label="Снижение доли контактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "quarantineEnd2",
                                                             label="Дата снятия карантина",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Перевод на удаленную работу"),
                                                 dateInput(inputId = "remoteBegin2",
                                                             label="Дата перевода",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "remoteContactsDecrease2",
                                                             label="Снижение доли контактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "remoteEnd2",
                                                             label="Дата снятия перевода",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Ввод санитарно-гигиенических мер"),
                                                 dateInput(inputId = "masksBegin2",
                                                             label="Дата ввода мер",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "masksContactsDecrease2",
                                                             label="Снижение доли конактов, %",
                                                             min=0, max=100, value=0),
                                                 dateInput(inputId = "masksEnd2",
                                                             label="Дата снятия мер",
                                                             min='2019-11-20', value='2020-06-30'),
                                                 h4("Вакцинация"),
                                                 dateInput(inputId = "vaccineBegin2",
                                                             label="Дата начала вакцинации",
                                                             min='2019-11-20', value='2020-06-29'),
                                                 sliderInput(inputId = "vaccineRate2",
                                                             label="Доля вакцинированных, %",
                                                             min=0, max=100, value=0)
                                          )
                                )
                                ),
                         column(8,
                                plotOutput(height="600px", outputId="distPlot")
                         )
                )
)

relativeNumericDate <- function(beginDate, absoluteDate)
{
    return(as.double(absoluteDate - beginDate))
}

server <- function(input, output, session) {

    model <- eventReactive(input$calculate, {
                               begin = input$beginDate
                               gammaI = 1.0 / input$infectionPeriod
                               betaI = input$transitFactor
                               gammaII = 1.0 / input$infectionPeriod2
                               betaII = input$transitFactor2
                               restrictI = data.frame(
                                                     quarantineBegin = relativeNumericDate(begin, input$quarantineBegin),
                                                     quarantineEnd = relativeNumericDate(begin, input$quarantineEnd),
                                                     quarantineContactsDecrease = input$quarantineContactsDecrease,
                                                     remoteBegin = relativeNumericDate(begin, input$remoteBegin),
                                                     remoteEnd = relativeNumericDate(begin, input$remoteEnd),
                                                     remoteContactsDecrease = input$remoteContactsDecrease,
                                                     masksBegin = relativeNumericDate(begin, input$masksBegin),
                                                     masksEnd = relativeNumericDate(begin, input$masksEnd),
                                                     masksContactsDecrease = input$masksContactsDecrease,
                                                     vaccineBegin = relativeNumericDate(begin, input$vaccineBegin),
                                                     vaccineRate =  input$vaccineRate
                               )
                               restrictII = data.frame(
                                                     quarantineBegin = relativeNumericDate(begin, input$quarantineBegin2),
                                                     quarantineEnd = relativeNumericDate(begin, input$quarantineEnd2),
                                                     quarantineContactsDecrease = input$quarantineContactsDecrease2,
                                                     remoteBegin = relativeNumericDate(begin, input$remoteBegin2),
                                                     remoteEnd = relativeNumericDate(begin, input$remoteEnd2),
                                                     remoteContactsDecrease = input$remoteContactsDecrease2,
                                                     masksBegin = relativeNumericDate(begin, input$masksBegin2),
                                                     masksEnd = relativeNumericDate(begin, input$masksEnd2),
                                                     masksContactsDecrease = input$masksContactsDecrease2,
                                                     vaccineBegin = relativeNumericDate(begin, input$vaccineBegin2),
                                                     vaccineRate = input$vaccineRate2
                               )
                               epidemyI <- calcEpidemyState(input,  betaI, gammaI, restrictI)
                               epidemyII <- calcEpidemyState(input, betaII, gammaII, restrictII)
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
