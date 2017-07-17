library(shiny)
library(shinysense)
library(shinythemes)

fluidPage(theme = shinytheme("flatly"),
  titlePanel("Draw your (beta) prior"),
  p("On the plot below sketch the distribution you think is appropriate for your beta prior. The app will then try and figure out the beta pdf that best fits your drawing by minimizing the mean average difference between your drawing and the pdf.",
    "After drawing the app will plot your drawing next to the closest beta pdf it found along with the alpha and beta values to re-generate that pdf."),
  p(
    "This was inspired by a talk I had with Andrew Bray of Reed College at UseR!2017. It was built using ",
    a(href = "https://shiny.rstudio.com/", "shiny"),
    "and my ",
    a(href = "https://www.github.com/nstrayer/shinysense", "shinysense"),
    " package and was developed at the",
    a(href = "http://jhudatascience.org/", "Johns Hopkins Data Science Lab")
  ),
  fluidRow(
    column(6,
           h3("Draw:"),
           shinydrawrUI("user_distribution")
    ),
    column(6,
           h3("Fit Result:"),
           plotOutput("best_beta_fit"),
           downloadButton('downloadData', 'download my drawing')
    )
  ),
  hr(),
  p(
    a(href = "http://jhudatascience.org/", img(src = "jhu_logo.png", height = 40) )
    )
)