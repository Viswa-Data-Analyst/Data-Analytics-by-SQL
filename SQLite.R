#Installation
install.packages("DBI")
install.packages("RSQLite")

#Package Load
library(DBI)
library(RSQLite)

#Reading input file
datafile <- read.csv("census-income.data",header=FALSE,check.names=TRUE,
                     sep=",")

#Database Connection
censusDB <- dbConnect(SQLite(),"census_income.sqlite")

#Table Deletion if required to re-run the code
#dbExecute(censusDB, "DROP TABLE Income_old")
#dbExecute(censusDB, "DROP TABLE Income")
#dbExecute(censusDB, "DROP TABLE Person")
#dbExecute(censusDB, "DROP TABLE Pay")
#dbExecute(censusDB, "DROP TABLE Job")

#Creation of Income table
dbSendQuery(censusDB,"CREATE TABLE Income
          (AAGE INT,
            ACLSWKR TEXT,
            ADTIND TEXT,
            ADTOCC TEXT,
            AHGA TEXT,
            AHRSPAY INT,
            AHSCOL TEXT,
            AMARITL TEXT,
            AMJIND TEXT,
            AMJOCC TEXT,
            ARACE TEXT,
            AREORGN TEXT,
            ASEX TEXT,
            AUNMEM TEXT,
            AUNTYPE TEXT,
            AWKSTAT TEXT,
            CAPGAIN NUM,
            CAPLOSS NUM,
            DIVVAL NUM,
            FILESTAT TEXT,
            GRINREG TEXT,
            GRINST TEXT,
            HDFMX TEXT,
            HHDREL TEXT,
            MARSUPWT NUM,
            MIGMTR1 TEXT,
            MIGMTR3 TEXT,
            MIGMTR4 TEXT,
            MIGSAME TEXT,
            MIGSUN TEXT,
            NOEMP NUM,
            PARENT TEXT,
            PEFNTVTY TEXT,
            PEMNTVTY TEXT,
            PENATVTY TEXT,
            PRCITSHP TEXT,
            SEOTR TEXT,
            VETQVA TEXT,
            VETYN TEXT,
            WKSWORK TEXT,
            YEAR TEXT,
            TRGT TEXT)"
            )

#Writing data into Income table
dbWriteTable(censusDB,"Income",datafile,overwrite=TRUE)

#Renaming the table Income to Income_old
dbExecute(censusDB, "ALTER TABLE Income RENAME TO Income_old")

#Creation of Income table with primary key column
dbSendQuery(censusDB,"CREATE TABLE Income
            (SS_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            AAGE INT,
            ACLSWKR TEXT,
            ADTIND TEXT,
            ADTOCC TEXT,
            AHGA TEXT,
            AHRSPAY INT,
            AHSCOL TEXT,
            AMARITL TEXT,
            AMJIND TEXT,
            AMJOCC TEXT,
            ARACE TEXT,
            AREORGN TEXT,
            ASEX TEXT,
            AUNMEM TEXT,
            AUNTYPE TEXT,
            AWKSTAT TEXT,
            CAPGAIN NUM,
            CAPLOSS NUM,
            DIVVAL NUM,
            FILESTAT TEXT,
            GRINREG TEXT,
            GRINST TEXT,
            HDFMX TEXT,
            HHDREL TEXT,
            MARSUPWT NUM,
            MIGMTR1 TEXT,
            MIGMTR3 TEXT,
            MIGMTR4 TEXT,
            MIGSAME TEXT,
            MIGSUN TEXT,
            NOEMP NUM,
            PARENT TEXT,
            PEFNTVTY TEXT,
            PEMNTVTY TEXT,
            PENATVTY TEXT,
            PRCITSHP TEXT,
            SEOTR TEXT,
            VETQVA TEXT,
            VETYN TEXT,
            WKSWORK NUM,
            YEAR TEXT,
            TRGT TEXT)")

#Data load from Income_old to Income
dbSendQuery(censusDB, "INSERT INTO Income
          (AAGE,
          ACLSWKR,
          ADTIND,
          ADTOCC,
          AHGA,
          AHRSPAY,
          AHSCOL,
          AMARITL,
          AMJIND,
          AMJOCC,
          ARACE,
          AREORGN,
          ASEX,
          AUNMEM,
          AUNTYPE,
          AWKSTAT,
          CAPGAIN,
          CAPLOSS,
          DIVVAL,
          FILESTAT,
          GRINREG,
          GRINST,
          HDFMX,
          HHDREL,
          MARSUPWT,
          MIGMTR1,
          MIGMTR3,
          MIGMTR4,
          MIGSAME,
          MIGSUN,
          NOEMP,
          PARENT,
          PEFNTVTY,
          PEMNTVTY,
          PENATVTY,
          PRCITSHP,
          SEOTR,
          VETQVA,
          VETYN,
          WKSWORK,
          YEAR,
          TRGT)
          SELECT V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,
          V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31,V32,V33,V34,
          V35,V36,V37,V38,V39,V40,V41,V42
          FROM Income_old")

#Female count for each race
dbGetQuery(censusDB,"SELECT
           ARACE AS 'RACE',
           COUNT(ASEX) AS 'TOTAL FEMALES'
           FROM Income
           WHERE ASEX = ' Female'
           GROUP BY ARACE")

#Male count for each race
dbGetQuery(censusDB,"SELECT
           ARACE AS 'RACE',
           COUNT(ASEX) AS 'TOTAL MALES'
           FROM Income
           WHERE ASEX = ' Male'
           GROUP BY ARACE")

#Average Annual Wage for each race
dbGetQuery(censusDB,"SELECT
           ARACE AS 'RACE',
           AVG(AHRSPAY*40*WKSWORK) AS 'Average_Annual_Income'
           FROM Income
           WHERE AHRSPAY > 0
           GROUP BY ARACE")

#Creation of Person table
dbExecute(censusDB,"CREATE TABLE Person
           (SS_ID INTEGER PRIMARY KEY,
           AAGE INT,
           AHGA TEXT,
           ASEX TEXT,
           PRCITSHP TEXT,
           PARENT TEXT,
           GRINST TEXT,
           GRINREG TEXT,
           AREORGN TEXT,
           AWKSTAT TEXT)")

#Data insert for Person table
dbExecute(censusDB, "INSERT INTO Person
          (SS_ID,
          AAGE,
          AHGA,
          ASEX,
          PRCITSHP,
          PARENT,
          GRINST,
          GRINREG,
          AREORGN,
          AWKSTAT)
          SELECT SS_ID,
                 AAGE,
                 AHGA,
                 ASEX,
                 PRCITSHP,
                 PARENT,
                 GRINST,
                 GRINREG,
                 AREORGN,
                 AWKSTAT
          FROM Income")

#Creation of Job table
dbExecute(censusDB,"CREATE TABLE Job
          (SS_ID INTEGER PRIMARY KEY,
          ADTIND TEXT,
          ADTOCC TEXT,
          AMJOCC TEXT,
          AMJIND TEXT)")

#Data insert for Job table
dbExecute(censusDB, "INSERT INTO Job
          (SS_ID,
          ADTIND,
          ADTOCC,
          AMJOCC,
          AMJIND)
          SELECT SS_ID,
                 ADTIND,
                 ADTOCC,
                 AMJOCC,
                 AMJIND
          FROM Income")


#Creation of Pay table
dbExecute(censusDB, "CREATE TABLE Pay
          (SS_ID INTEGER PRIMARY KEY,
          AHRSPAY NUM,
          WKSWORK NUM)")

#Data insert for Pay table
dbExecute(censusDB,"INSERT INTO Pay
          (SS_ID,
          AHRSPAY,
          WKSWORK)
          SELECT SS_ID,
                  AHRSPAY,
                  WKSWORK
          FROM Income")

#Highest hourly wage
dbGetQuery(censusDB, "SELECT MAX(AHRSPAY) as 'Highest hourly Wage' FROM Pay")

#Number of people in each state with highest hourly wage
dbGetQuery(censusDB, "SELECT
           Person.GRINST as State,
           COUNT(*) as Total
           FROM Person
           WHERE Person.SS_ID IN
           (SELECT SS_ID
           FROM Pay
           WHERE AHRSPAY IN
           (SELECT MAX(AHRSPAY) FROM Pay))
           GROUP BY Person.GRINST")

#Number of people in each industry with highest hourly wage
dbGetQuery(censusDB, "SELECT
           Job.AMJIND as Industry,
           COUNT(*) as Total
           FROM Job
           WHERE SS_ID IN
           (SELECT SS_ID
           FROM Pay
           WHERE AHRSPAY IN
           (SELECT MAX(AHRSPAY) FROM Pay))
           GROUP BY Job.AMJIND")

#Number of people in each occupation with highest hourly wage
dbGetQuery(censusDB, "SELECT
           Job.AMJOCC as Occupation,
           COUNT(*) as Total
           FROM Job
           WHERE SS_ID IN
           (SELECT SS_ID
           FROM Pay
           WHERE AHRSPAY IN
           (SELECT MAX(AHRSPAY) FROM Pay))
           GROUP BY Job.AMJOCC")

#Employment Data for degree holders
dbGetQuery(censusDB, "SELECT
           Person.AHGA as Education,
           Job.AMJIND as Industry,
           AVG(Pay.AHRSPAY) as 'Average hourly pay',
           AVG(Pay.WKSWORK) as 'Average weeks worked'
           FROM Person, Job, Pay
           WHERE Person.SS_ID = Job.SS_ID AND
           Person.SS_ID = Pay.SS_ID AND
           (Person.AHGA LIKE (' Bachelors degree%') OR
           Person.AHGA LIKE (' Masters degree%') OR
           Person.AHGA LIKE (' Doctorate degree%'))
           GROUP BY Job.AMJIND, Person.AHGA
           ORDER BY Person.AHGA")

dbDisconnect(censusDB)

#Database Disconnected


