# Build a Survey Data Dashboard with qualtRics and Shiny

Here at Urban, we use <a href="https://www.qualtrics.com/" target="blank">Qualtrics</a> to build and deploy surveys. You can get some sense of your data directly in Qualtrics, but if you want to to pull in data from other sources or do any meaningful data wrangling, <a href="https://www.qualtrics.com/support/survey-platform/reports-module/results-vs-reports/?parent=p002" target="blank">Qualtrics Results and Reports</a> aren't going to cut it. Enter qualtRics and Shiny. 

<a href="https://docs.ropensci.org/qualtRics/" target="blank">qualtRics</a> is an R package that uses the Qualtrics API to retrieve survey data and minimizes the preprocessing necessary to work with that data. <a href="https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/index.html" target="blank">Shiny</a> in as R package that makes it easy to build interactive web applications in R. You can use them together to create a Qualtrics data dashboard.

See the materials in the `demo` folder for a look under the hood of this <a href="https://fvescia.shinyapps.io/qual-dash/" target="blank">demo dashboard</a>, then use the template and instructions in the `diy` folder to build your own!

