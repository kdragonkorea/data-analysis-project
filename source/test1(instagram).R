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
insta_pw$sendKeysToElement(list('kdragontestrr'))
login_btn <- remDr$findElement(using='css selector','div:nth-child(3) > button')
login_btn$clickElement()
Sys.sleep(2)

# 키워드 검색
insta_search <- remDr$findElement(using='css selector','nav > div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > input')
insta_search$clickElement()
insta_search$sendKeysToElement(list('#제주도맛집'))
Sys.sleep(2)

# 태그 클릭 (상단에서 2번째)
tag1 <- remDr$findElement(using='css selector','div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > div.yPP5B > div > div._01UL2 > div > div:nth-child(2)')
tag1$clickElement()
Sys.sleep(2)


id <- NULL;txt <- NULL;date <- NULL;like <- NULL;reply <- NULL;reply_css <- NULL;like_css <- NULL;like_text <- NULL;video <- NULL;video_css <- NULL;index_col <- NULL;index_row <- NULL;index <- NULL;index_reply <- 2;reply_nums <- NULL
# 최근 게시물

for (index_col in 0:38) {
  index_col <- index_col + 1
  Sys.sleep(1)
  for (index in 1:3){
    index_row <- paste0('div:nth-child(',index_col,') > div:nth-child(',index,')','> a > div > div._9AhH0')
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
    
    # txt
    txt_css <- remDr$findElements(using='css selector','div.eo2As > div.EtaWk > ul > div > li > div > div > div.C4VMK > span')
    txt_text <- sapply(txt_css,function(x){x$getElementText()})
    if (length(txt_text) == 0){
      cat("(no txt) ")
      txt_NA < NA
      txt <- c(txt, unlist(txt_NA))
    }else{
      cat("(is txt) ")
      txt <- c(txt, unlist(txt_text))
    }
    
    # date
    date_css <- remDr$findElements(using='css selector','div.C4VMK > div > div > time')
    date_text <- sapply(date_css, function(x) {x$getElementAttribute("title")})
    if (length(date_text) == 0){
      cat("(no date) ")
      date_NA <- NA
      date <- c(date, unlist(date_NA))
    }else{
      cat("(is date) ")
      date <- c(date, unlist(date_text))
    }
    
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
    }
    
    # video (비디오일 경우 '좋아요' 대신에 '조회수'를 리턴)
    video_css <- remDr$findElements(using='css selector','div.eo2As > section.EDfFK.ygqzn > div > span')
    
    if (length(video_css) == '0'){
      cat("(no video) ")
      video_NA <- NA
      video <- c(video, unlist(video_NA))
    }else{
      cat("(is video) ")
      video_text <- sapply(video_css,function(x){x$getElementText()})
      video <- c(video, unlist(video_text))
    }
    
    #____________________________________________________________________________________
    
    # reply (첫 댓글은 css selector가 (2) 부터 시작)
    
    index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
    reply_css <- remDr$findElements(using='css selector',index_reply2)
    
    # reply가 없으면 NA를 담는다.
    if (length(reply_css) == '0'){
      cat("(no reply) ")
      reply_text <- NA
      reply <- c(reply, unlist(reply_text))
    }else{
      
      # reply가 있으면 상위 1개의 reply만 가져온다.
      cat("(is reply) ")
      index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
      reply_css <- remDr$findElements(using='css selector',index_reply2)
      reply_text <- sapply(reply_css,function(x){x$getElementText()})
      reply <- c(reply, unlist(reply_text))
      
      # reply가 있으면 reply 수만큼 무한반복
      # reply_nums_next <- NULL
      # reply_nums <- NULL
      # repeat{
      #   cat("(is reply) ")
      #   reply_text <- sapply(reply_css,function(x){x$getElementText()})
      #   reply_nums <- c(reply_nums, unlist(reply_text))
      #   cat(length(reply_nums))
      #   
      #   if (length(reply_nums) == length(reply_nums_next))
      #     break
      #   reply_nums -> reply_nums_next
      #   
      #   # reply_css 1씩 증가하여 다음 reply 정보를 가져온다.
      #   index_reply <- index_reply + 1
      #   index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
      #   reply_css <- remDr$findElements(using='css selector',index_reply2)
      #   
      # }
      # reply <- c(reply, unlist(reply_nums))
    }
    #____________________________________________________________________________________
    
    # x버튼
    xbtn <- remDr$findElement(using='css selector','div.Igw0E.IwRSH.eGOV_._4EzTm.BI4qX.qJPeX.fm1AK.TxciK.yiMZG > button')
    xbtn$clickElement()
    
    # 모든 데이터를 데이터프레임으로 저장
    제주도맛집 <- data.frame(id, txt, date, like, video, reply)
    print(nrow(제주도맛집))
    
    # 스크롤 다운
    # 첫 화면의 8행
    # 스크롤 이벤트 1회: 4행 추가
    # 스크롤 이벤트 2회: 4행 추가
    # 스크롤 이벤트 3회: 4행 추가
    
    if(nrow(제주도맛집) %% 5 == 0){
      scroll <- remDr$findElement("css selector", "body")
      remDr$executeScript("scrollTo(0, document.body.scrollHeight)", args = list(scroll))
      
    }
    Sys.sleep(2)
  }
}

제주도맛집 <- data.frame(id, txt, date, like, video, reply, re_reply)