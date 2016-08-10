#Michael McGunagle
#Final Project
#Data Collection
#Fall Semester
#December 15, 2015
##############################################

setwd("C:/Users/Mike/Desktop/NEU/Fall 2015/Data Storage/Final")

# a simple Oauth2.0 connection with Fitbit API
#install.packages("httr") # install if not installed
#install.packages("rmongodb")
library("httr") # load package for http communication
library(mongolite)
library(RJSONIO)
library("rjson")
library(jsonlite)

require(plyr)
# set client ID - REPLACE WITH YOURS INSIDE THE QUOTES! 
clientID = "229X9R"

# construct string to put in GET request for authentication
oauthString <- 
  paste0("https://www.fitbit.com/oauth2/authorize?response_type=token",
         "&client_id=",
         clientID,
         "&redirect_uri=http%3A%2F%2Flocalhost%3A1410",
         "&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight",
         "&expires_in=604800")
# print out the generated string
print(oauthString)

# copy above URL string to browser as the address
# a page should open listing the permissions you requested
# confirm requested permissions
# the browser will say the requested page is not available (or something to that effect)
# but there will be an URL in the address field
# (the URL will start with http://localhost:1410/)
# copy and paste the returned url somewhere
# find "access_token=" in it and copy the long string after the equals sign
# add word "Bearer" in front
# save to a variable to use later
# see example bellow
Mike <- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAxNTE1NDYsInNjb3BlcyI6InJ3ZWkgcnBybyByaHIgcmxvYyBybnV0IHJzbGUgcnNldCByYWN0IHJzb2MiLCJzdWIiOiIzRDRLVlciLCJhdWQiOiIyMjlYOVIiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0NDk1NDY3NDZ9.tw35X-tI8Q4brudPmDyJsdYYceWtnPw43fyJnbtX-aM"
Erwin<- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAyMjQ4MDEsInNjb3BlcyI6InJ3ZWkgcnBybyByaHIgcmxvYyBybnV0IHJzbGUgcnNldCByYWN0IHJzb2MiLCJzdWIiOiIyODk5WEQiLCJhdWQiOiIyMjlYOVIiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0NDk2MjAwMDF9.fOkyCye7N5ybNIYY6Tp76iFfB9vTteJ3rVGADCYMSsM"
Ryan<- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAyMjQ3NTAsInNjb3BlcyI6InJ3ZWkgcnBybyByaHIgcmxvYyBybnV0IHJzbGUgcnNldCByYWN0IHJzb2MiLCJzdWIiOiIzQldXUzIiLCJhdWQiOiIyMjlYOVIiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0NDk2MTk5NTB9.ZezZgFfFD-Sp2IkoFQ9Jr6DZcN8-AAb4Xso4BL8zrmc"
Kos<- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAyODEyOTAsInNjb3BlcyI6InJ3ZWkgcnBybyByaHIgcmxvYyBybnV0IHJzbGUgcnNldCByYWN0IHJzb2MiLCJzdWIiOiIzN0JLWTQiLCJhdWQiOiIyMjlYOVIiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0NDk2NzczMjl9.8Xw0-h11rEcZkBGHJYCRkkdr7rMksBt8GTRkx8WmoMU"
Cortney<- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAzMDk0MDEsInNjb3BlcyI6InJ3ZWkgcnBybyByaHIgcm51dCByc2xlIHJzZXQgcmFjdCIsInN1YiI6IjNHRlo5TiIsImF1ZCI6IjIyOVg5UiIsImlzcyI6IkZpdGJpdCIsInR5cCI6ImFjY2Vzc190b2tlbiIsImlhdCI6MTQ0OTcwNDYwMX0.elxDzoTS8Z-F38kIfsygbVIl2T8E3whRvikRYv3dDO0"
Chris<- "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAzMTkzNjMsInNjb3BlcyI6InJwcm8gcmhyIHJudXQgcnNsZSByc2V0IHJhY3QgcnNvYyIsInN1YiI6IjM0UlYzSiIsImF1ZCI6IjIyOVg5UiIsImlzcyI6IkZpdGJpdCIsInR5cCI6ImFjY2Vzc190b2tlbiIsImlhdCI6MTQ0OTcxNDU2M30.Tg5txxFk-elvlnS-u_0-PT49wEmsqLGYABfjnBlIrMk"
Shannon<-"Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTAzMjI3ODEsInNjb3BlcyI6InJwcm8gcmhyIHJsb2Mgcm51dCByc2xlIHJzZXQgcmFjdCByc29jIiwic3ViIjoiMzg1NDhTIiwiYXVkIjoiMjI5WDlSIiwiaXNzIjoiRml0Yml0IiwidHlwIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNDQ5NzE3OTgxfQ.jZ1aQUnM7TzI_ulagIAeLGTqLv-RceCW_PyJ_1nUFU4"
Julia<-"Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTA1NzA2NTksInNjb3BlcyI6InJ3ZWkgcmhyIHJsb2Mgcm51dCByc2xlIHJzZXQgcmFjdCIsInN1YiI6IjNQREQ1UCIsImF1ZCI6IjIyOVg5UiIsImlzcyI6IkZpdGJpdCIsInR5cCI6ImFjY2Vzc190b2tlbiIsImlhdCI6MTQ0OTk2NTg1OX0.PniPFTvAOjmufqdK1FebhDjri5-sT9ivXSJ1ZT5XAok"


kal<-"activities/calories"  
BMR<-"activities/caloriesBMR"  
Steps<-"activities/steps"  
Dist<-"activities/distance"  
floors<-"activities/floors"  
elev<-"activities/elevation"  
minSed<-"activities/minutesSedentary"
minsLight<-"activities/minutesLightlyActive"  
minsFair<-"activities/minutesFairlyActive"  
minsVery<-"activities/minutesVeryActive"  
actCal<-"activities/activityCalories"
#trackers
track_cal<-"activities/tracker/calories"
track_steps<-"activities/tracker/steps" 
track_dist<-"activities/tracker/distance" 
track_floors<-"activities/tracker/floors"  
track_elev<-"activities/tracker/elevation"  
track_minsSed<-"activities/tracker/minutesSedentary"  
track_minsLight<-"activities/tracker/minutesLightlyActive"  
track_minsFair<-"activities/tracker/minutesFairlyActive"  
track_minsVery<-"activities/tracker/minutesVeryActive"  
track_actCal<-"activities/tracker/activityCalories"

Users<-c(Mike, Erwin, Ryan, Kos, Cortney, Chris, Shannon, Julia)
FitCat<-c(kal, BMR, Steps, Dist, floors, elev, minSed, minsLight, minsFair, minsVery, actCal,
          track_cal,
          track_steps, 
          track_dist, 
          track_floors,  
          track_elev,  
          track_minsSed,  
          track_minsLight,  
          track_minsFair,  
          track_minsVery,  
          track_actCal)

# use the token in the API calls like in the example below
# but replace the "getString" variable with your API call string
# you can construct the string according to instructions (for heart rate)
# https://dev.fitbit.com/docs/heart-rate/
# this is for today's heart rate data in json


# create a function and loop to look up each user's data, store it in a csv to be pulled out and merged
Cals<-function(x, act){
  User<-Users[x]
  Track <- paste("https://api.fitbit.com/1/user/-/", FitCat[act], "/date/2015-05-01/2015-12-01.json", sep = "")
    # make the request
  request <- GET(Track,
                 add_headers("Authorization"= Users[x]))
  # look at returned contents
  # options were text, parse and raw
  Info<-(content(request,  "text") )
  
  Info <- fromJSON(Info)
  Info<-as.data.frame(Info)
  #identify each user's data
  Info$User<-x
  names(Info)[1]<-"dateTime"
 #new directory created to store files for a multimerge later
  table<-paste(file="C:\\Users\\Mike\\Desktop\\NEU\\Fall 2015\\Data Storage\\Final\\data\\FitStats",act,".csv", sep = "")
 #appending tables by category
  if(x == 1){
  write.table(Info, table, row.names=F, col.names=T,  sep=",", fileEncoding = "UTF-8" )
  }
  else {
    write.table(Info, table ,append = T, row.names=F, col.names=F,  sep=",", fileEncoding = "UTF-8")
  }
  
}

for(i in 1:length(Users)){
  for (act in 1:length(FitCat)) {
    print (Cals(i,act))
  }
}
#some research on the web found that I could do a multi merge by function created by Tony Cookson
multmerge = function(mypath){
  filenames=list.files(path=mypath, full.names=TRUE)
  datalist = try(lapply(filenames, function(x){read.csv(file=x,header=T, stringsAsFactors = FALSE)}))
  try(Reduce(function(x,y) {merge(x, y, all=TRUE)}, datalist))
}

MyFit<-multmerge("C:\\Users\\Mike\\Desktop\\NEU\\Fall 2015\\Data Storage\\Final\\data\\")
names(MyFit) <- gsub("[.]", "_", names(MyFit)) 


# #Some of my permission to data expires on 12/15/2015, I am capturing it now, incase I need to reload mongo
write.table(MyFit, "MyFit2.csv", row.names=F, col.names=T,  sep=",", fileEncoding = "UTF-8" )

mongoData$drop()


mongoData<-mongo("TermProject")
str(mongoData)
mongoData$insert(MyFit)
mongoData$export(file("FitBitData2.txt"))


Query1<-mongoData$count('{"User" : "5"}' ) 
Query1
Query2<-mongoData$find('{"User" : "1","dateTime" : "2015-05-04"}' )
Query2
Query3<-mongoData$find('{"User" : "6", "activities_calories_value" : 5191}')
head(Query3)
Query4<- mongoData$find('{"activities_calories_value" : 1311}')
head(Query4)
Jul4 <- mongoData$find('{"dateTime" : "2015-07-04"}')
Jul4

