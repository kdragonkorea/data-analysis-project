library(RSelenium)
library(httr)
library(XML)
library(rvest)
# java -Dwebdriver.chrome.driver="chromedriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

# 크롬 연결/오픈
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()

# url 접속
remDr$navigate("https://www.instagram.com")
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

id <- NULL;txt <- NULL;date <- NULL;like <- NULL;reply <- NULL;reply_css <- NULL;like_css <- NULL;like_text <- NULL;video <- NULL;video_css <- NULL;index_col <- NULL;index_row <- NULL;index <- NULL;index_reply <- 1
# 최근 게시물

for (index_col in 0:3) {
  index_col <- index_col + 1
  
  for (index in 1:3){
    index_row <- paste0('div:nth-child(3) > div > div:nth-child(',index_col,') > div:nth-child(',index,')','> a > div > div._9AhH0')
    post <- remDr$findElement(using='css selector',index_row)
    post$clickElement()
    Sys.sleep(1)
  #1행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(1) > a > div > div._9AhH0
  #1행2열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(2) > a > div > div._9AhH0
  #1행3열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(3) > a > div.eLAPa > div._9AhH0
  #2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(1) > a > div.eLAPa > div._9AhH0
  #2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(2) > a > div > div._9AhH0
  #2행1열: #react-root > section > main > article > div:nth-child(3) > div > div:nth-child(2) > div:nth-child(3) > a > div.eLAPa > div._9AhH0
    
    # id
    id_css <- remDr$findElement(using='css selector','div.e1e1d > span > a')
    id_text <- id_css$getElementText()
    id <- c(id, unlist(id_text))
    Sys.sleep(1)
    
    #react-root > section > main > div > div.ltEKP > article > div.eo2As > div.EtaWk
    # txt
    txt_css <- remDr$findElement(using='css selector','div.eo2As > div.EtaWk > ul > div > li > div > div > div.C4VMK > span')
    txt_text <- txt_css$getElementText()
    txt <- c(txt, unlist(txt_text))
    Sys.sleep(1)
    
    # date
    date_css <- remDr$findElement(using='css selector','div.C4VMK > div > div > time')
    date_text <- date_css$getElementAttribute("title")
    date <- c(date, unlist(date_text))
    Sys.sleep(1)
    
    # like (비디오가 아닐 경우 '조회수' 대신에 '좋아요'를 리턴)
    like_css <- remDr$findElements(using='css selector','section.EDfFK.ygqzn > div > div')
    
    if (length(like_css) == '0'){
      cat("(no like) ")
      like_NA <- NA
      like <- c(like, unlist(like_NA))
    }else{
      cat("(is like) ")
      like_text <- sapply(like_css,function(x){x$getElementText()})
      like <- c(like, unlist(like_text))
      Sys.sleep(1)
    }
    
    # video (비디오일 경우 '좋아요' 대신에 '조회수'를 리턴)
    video_css <- remDr$findElements(using='css selector','section.EDfFK.ygqzn > div > span > span')

    if (length(video_css) == '0'){
      cat("(no video) ")
      video_NA <- NA
      video <- c(video, unlist(video_NA))
    }else{
      cat("(is video) ")
      video_text <- sapply(video_css,function(x){x$getElementText()})
      video <- c(video, unlist(video_text))
      Sys.sleep(1)
    }
    
    # reply (첫 댓글은 css selector가 (2) 부터 시작)
    repeat{
      index_reply <- index_reply + 1
      index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
      reply_css <- remDr$findElements(using='css selector',index_reply2)
      if (length(reply_css) == '0'){
        cat("(no reply) ")
        reply_NA <- NA
        reply <- c(reply, unlist(reply_NA))
        break
      }else{
        cat("(is reply) ")
        reply_text <- sapply(reply_css,function(x){x$getElementText()})
        reply <- c(reply, unlist(reply_text))
        Sys.sleep(1)
      }
    }
    # x버튼
    xbtn <- remDr$findElement(using='css selector','div.Igw0E.IwRSH.eGOV_._4EzTm.BI4qX.qJPeX.fm1AK.TxciK.yiMZG > button')
    xbtn$clickElement()
    
    df <- data.frame(id, txt, date, like, video, reply)
    print(nrow(df))
  }
}

View(df)



