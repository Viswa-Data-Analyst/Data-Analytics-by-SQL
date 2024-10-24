#Installation
install.packages("dplyr")

#Package Load
library(dplyr)

#Data frame creation by Reading Input file
Income <- read.csv("census-income.data",header=FALSE)

#Adding the new field SS_ID
Income <- mutate(Income,SS_ID=c(1:nrow(census_data)))

#Renaming the columns appropriately
Income <- rename(Income, ASEX=V13,ARACE=V11,AHRSPAY=V6,AREORGN=V12,AWKSTAT=V16,
                 WKSWORK=V40,AAGE=V1,AHGA=V5,PRCITSHP=V36,PARENT=V32,GRINST=V22,
                 GRINREG=V21,ADTIND=V3,ADTOCC=V4,AMJIND=V9,AMJOCC=V10)

#Gender count for each race group
#Extracting the number of females for each race
Female_count_by_race <- Income %>%
                        select(ARACE,ASEX) %>%
                        filter(ASEX==' Female') %>%
                        group_by(ARACE,ASEX) %>%
                        tally()

#renaming of the result set columns
Female_count_by_race <- rename(Female_count_by_race,
                               RACE = ARACE,SEX=ASEX,Total=n)


#Extracting the number of males for each race
Male_count_by_race <- Income %>%
                        select(ARACE,ASEX) %>%
                        filter(ASEX==' Male') %>%
                        group_by(ARACE,ASEX) %>%
                        tally() %>%
                        rename(RACE = ARACE,SEX=ASEX,Total=n)


#Average Annual Wage for each race group
Average_annual_wage <- Income %>%
                       filter(AHRSPAY > 0) %>%
                       group_by(RACE=ARACE) %>%
                       summarise(Avg_Annual_pay=mean(AHRSPAY*40*WKSWORK))%>%
                       arrange(desc(Avg_Annual_pay))


#Three New Data Frames
#creation of new data frames
Person_df <- Income %>%
             select(SS_ID,
                    AAGE,
                    AHGA,
                    ASEX,
                    PRCITSHP,
                    PARENT,
                    GRINST,
                    GRINREG,
                    AREORGN,
                    AWKSTAT)

Job_df <- Income %>%
          select(SS_ID,
                 ADTIND,
                 ADTOCC,
                 AMJOCC,
                 AMJIND)

Pay_df <- Income %>%
                 select(SS_ID,
                        AHRSPAY,
                        WKSWORK)

#Joining the three new data frames using SS_ID
Initial_join <- inner_join(Person_df, Job_df, Pay_df, by='SS_ID')
Joined_df <- inner_join(Initial_join, Pay_df, by='SS_ID')

#Highest hourly wage
Highest_wage <- Pay_df %>%
                  filter(AHRSPAY == max(AHRSPAY)) %>%
                  select(Highest_hourly_pay = AHRSPAY)


#SS_IDs for the highest hourly wage
Highest_Pay_id <- Pay_df %>%
                  filter(AHRSPAY == max(AHRSPAY)) %>%
                  select(SS_ID) %>% .$ SS_ID

#Number of persons in each state with highest hourly wage
Highest_Wage_State <- Joined_df %>%
                      filter(SS_ID == Highest_Pay_id) %>%
                      group_by(GRINST) %>%
                      tally() %>%
                      rename(State=GRINST,Total=n)


#Extracting the number of persons in each industry with highest hourly wage
Highest_Wage_Industry <- Joined_df %>%
                         filter(SS_ID == Highest_Pay_id) %>%
                         group_by(AMJIND) %>%
                         tally() %>%
                         rename(Industry=AMJIND,Total=n)


#Extracting the number of persons in each industry with highest hourly wage
Highest_Wage_Occupation <- Joined_df %>%
                           filter(SS_ID == Highest_Pay_id) %>%
                           group_by(AMJIND) %>%
                           tally() %>%
                           rename(Industry=AMJIND,Total=n)


#Employment Data of degree holders
Employment_data <- Joined_df %>%
                  filter(AHGA %in% c(' Bachelors degree(BA AB BS)',
                                    ' Masters degree(MA MS MEng MEd MSW MBA)',
                                    ' Doctorate degree(PhD EdD)')) %>%
                  group_by(Education=AHGA,Industry=AMJIND) %>%
                  summarise(Avg_hourly_pay = mean(AHRSPAY),
                            Avg_weeks_worked = mean(WKSWORK) ) %>%
                  arrange(Education)

#Results
#Number of females for each race group
Female_count_by_race

#Number of males for each race group
Male_count_by_race

#Average Annual Wage
Average_annual_wage

#Highest hourly wage
Highest_wage

#Number of persons in each state with highest hourly wage
Highest_Wage_State

##Number of persons in each industry with highest hourly wage
Highest_Wage_Industry

#Number of persons in each occupation with highest hourly wage
Highest_Wage_Occupation

#Employment Data
Employment_data

















