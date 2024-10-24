The goal of the project is to extract various insights out of the census-income data by using SQLite and dplyr packages and identify the benefits and limitations of both the packages.

Insights Extracted: 
Gender Count by RACE
Average Annual Wage for each race
Highest Hourly Wage (HHW) & number of people with HHW in each state, industry and occupation.
EMployment Data for Degree Holders

Conclusion: SQLite requires tables to store the data where as in the case of dplyr it is data frame, hence the amount of code required in dplyr was comparatively lesser. SQLite has the concept of nested queries but dplyr uses chaining and piping method instead. Hence, SQLite provides better readability of the code while efficient and faster way of fetching the results can be achieved using dplyr.
