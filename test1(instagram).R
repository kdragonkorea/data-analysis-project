library(RSelenium)
library(httr)
library(XML)
library(rvest)
# java -Dwebdriver.chrome.driver="chromedriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

# 크롬 연결/오픈
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()

# url 접속
remDr$navigate("https://www.instagram.com/")
Sys.sleep(2)

# insta_email,insta_pw 입력 / btn 클릭
insta_email <- remDr$findElement(using='css selector','div:nth-child(1) > div > label')
insta_email$clickElement()
insta_email$sendKeysToElement(list('kdragonkorea@gmail.com'))

insta_pw <- remDr$findElement(using='css selector','div:nth-child(2) > div > label')
insta_pw$clickElement()
insta_pw$sendKeysToElement(list('kdragontestr'))
login_btn <- remDr$findElement(using='css selector','div:nth-child(3) > button')
login_btn$clickElement()
Sys.sleep(2)

# 키워드 검색
insta_search <- remDr$findElement(using='css selector','nav > div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > input')
insta_search$clickElement()
insta_search$sendKeysToElement(list('#제주도맛집'))
Sys.sleep(2)

# 최상단 태그 클릭
tag1 <- remDr$findElement(using='css selector','div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > div.yPP5B > div > div._01UL2 > div > div:nth-child(1)')
tag1$clickElement()
Sys.sleep(2)

id <- NULL;txt <- NULL;date <- NULL;like <- NULL;reply <- NULL;reply_css <- NULL;like_css <- NULL;like_text <- NULL;video <- NULL;video_css <- NULL;
# 최근 게시물
post <- remDr$findElement(using='css selector','div:nth-child(3) > div > div:nth-child(1) > div:nth-child(6) > a > div > div._9AhH0')
post$clickElement()

#1행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(1) > a > div > div._9AhH0
#1행2열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(2) > a > div > div._9AhH0
#1행3열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(3) > a > div.eLAPa > div._9AhH0
#2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(1) > a > div.eLAPa > div._9AhH0
#2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(2) > a > div > div._9AhH0
#2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(3) > a > div.eLAPa > div._9AhH0
#3행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(3) > div:nth-child(1) > a > div > div._9AhH0
#3행2열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(3) > div:nth-child(2) > a > div.eLAPa > div._9AhH0
#3행3열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(3) > div:nth-child(3) > a > div.eLAPa > div._9AhH0

Sys.sleep(2)

# id
id_css <- remDr$findElement(using='css selector','div.e1e1d > span > a')
id_text <- id_css$getElementText()
id <- c(id, unlist(id_text))
Sys.sleep(2)

# txt
txt_css <- remDr$findElement(using='css selector','div.eo2As > div.EtaWk > ul > div > li > div > div > div.C4VMK > span')
txt_text <- txt_css$getElementText()
txt <- c(txt, unlist(txt_text))
Sys.sleep(2)

# date
date_css <- remDr$findElement(using='css selector','div.C4VMK > div > div > time')
date_text <- date_css$getElementAttribute("title")
date <- c(date, unlist(date_text))
Sys.sleep(2)

# like (비디오가 아닐 경우 '조회수' 대신에 '좋아요'를 리턴)
like_css <- remDr$findElement(using='css selector','section.EDfFK.ygqzn > div > div > a')

if (length(like_css) == '0'){
  cat("no like")
  like <- NA  
}else{
  like_css <- remDr$findElement(using='css selector','section.EDfFK.ygqzn > div > div > a')
  like_text <- like_css$getElementText()
  like <- c(like, unlist(like_text))
  print(like)
  Sys.sleep(2)
}

# video (비디오일 경우 '좋아요' 대신에 '조회수'를 리턴)
video_css <- remDr$findElement(using='css selector','section.EDfFK.ygqzn > div > span > span')

if (length(video_css) == '0'){
  cat("no video")
  video <- NA
}else{
  video_css <- remDr$findElement(using='css selector','section.EDfFK.ygqzn > div > span > span')
  video_text <- video_css$getElementText()
  video <- c(video, unlist(video_text))
  print(video)
  Sys.sleep(2)
}


# reply (첫 댓글은 css selector가 (2) 부터 시작)
reply_css <- remDr$findElement(using='css selector','ul:nth-child(2) > div > li > div > div.C7I1f > div.C4VMK > span')

if (length(reply_css) == '0'){
  cat("no reply")
  reply <- NA
}else{
  reply_css <- remDr$findElement(using='css selector','ul:nth-child(2) > div > li > div > div.C7I1f > div.C4VMK > span')
  reply_text <- reply_css$getElementText()
  reply <- c(reply, unlist(reply_text))
  Sys.sleep(2)
}

# x버튼
xbtn <- remDr$findElement(using='css selector','div.Igw0E.IwRSH.eGOV_._4EzTm.BI4qX.qJPeX.fm1AK.TxciK.yiMZG > button')
xbtn$clickElement()

df <- data.frame(id, txt, date, like, video, reply)
View(df)



