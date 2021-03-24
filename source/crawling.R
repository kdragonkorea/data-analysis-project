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

# 로그인
insta_email <- remDr$findElement(using='css selector','div:nth-child(1) > div > label')
insta_email$clickElement()
insta_email$sendKeysToElement(list('ID'))

insta_pw <- remDr$findElement(using='css selector','div:nth-child(2) > div > label')
insta_pw$clickElement()
insta_pw$sendKeysToElement(list('Password'))

login_btn <- remDr$findElement(using='css selector','div:nth-child(3) > button')
login_btn$clickElement()
Sys.sleep(2)

# 키워드 검색 (#제주도맛집)
insta_search <- remDr$findElement(using='css selector','nav > div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > input')
insta_search$clickElement()
insta_search$sendKeysToElement(list('#제주도맛집'))
Sys.sleep(2)

# 태그 클릭 (상단에서 2번째)
tag1 <- remDr$findElement(using='css selector','div._8MQSO.Cx7Bp > div > div > div.LWmhU._0aCwM > div.yPP5B > div > div._01UL2 > div > div:nth-child(2)')
tag1$clickElement()
Sys.sleep(2)

# 크롤링 시작: 게시물 우측의 다음버튼을 눌러서 다음 게시물로 이동하는 방법

id <- NULL;txt <- NULL;date <- NULL;like <- NULL;reply <- NULL;re_reply <- NULL;like_css <- NULL;like_text <- NULL;video <- NULL;video_css <- NULL;index_col <- NULL;index_row <- NULL;index <- NULL;post_1st <- NULL;i <- 0

# 첫 게시물 클릭
post_1st <- remDr$findElement(using='css selector','div:nth-child(3) > div > div:nth-child(1) > div:nth-child(1) > a > div > div._9AhH0')
post_1st$clickElement()
Sys.sleep(1)

for (i in 1:29999) {
  
  # id (R에서는 try함수가 적용이 안될 수 있다...?)
  try(id_css <- remDr$findElements(using='css selector','div.e1e1d > span > a'))
  if(length(id_css) == 0){
    Sys.sleep(10)
    id_css <- remDr$findElements(using='css selector','div.e1e1d > span > a')
    id_text_NA <- NA
    id <- c(id, unlist(id_text_NA))
  }else{
  id_css <- remDr$findElements(using='css selector','div.e1e1d > span > a')
  id_text <- sapply(id_css,function(x){x$getElementText()})
  id <- c(id, unlist(id_text))
  }
  # txt
  txt_css <- remDr$findElements(using='css selector','div.eo2As > div.EtaWk > ul > div > li > div > div > div.C4VMK > span')
  txt_text <- sapply(txt_css,function(x){x$getElementText()})
  if (length(txt_text) == 0){
    cat("(no txt) ")
    txt_NA < NA
    txt <- c(txt, unlist(txt_NA))
  }else{
    cat("(txt) ")
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
    cat("(date) ")
    cat(unlist(date_text),' ')
    date <- c(date, unlist(date_text))
  }
  
  # like (비디오가 아닐 경우 '조회수' 대신에 '좋아요'를 리턴)
  like_css <- remDr$findElements(using='css selector','section.EDfFK.ygqzn > div > div')
  
  if (length(like_css) == '0'){
    cat("(no like) ")
    like_NA <- NA
    like <- c(like, unlist(like_NA))
  }else{
    cat("(like) ")
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
    cat("(video) ")
    video_text <- sapply(video_css,function(x){x$getElementText()})
    video <- c(video, unlist(video_text))
  }
  
  # reply (첫 댓글은 css selector가 (2) 부터 시작)
  
  index_reply <- 2
  index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
  reply_css <- remDr$findElements(using='css selector',index_reply2)
  
  # reply가 없으면 NA를 담는다.
  if (length(reply_css) == '0'){
    cat("(no reply) ")
    reply_text <- NA
    reply <- c(reply, unlist(reply_text))
  }else{
    
    # reply가 있으면 상위 1개의 reply만 가져온다.
    cat("(reply) ")
    index_reply2 <- paste0('ul:nth-child(',index_reply,') > div > li > div > div.C7I1f > div.C4VMK > span')
    reply_css <- remDr$findElements(using='css selector',index_reply2)
    reply_text <- sapply(reply_css,function(x){x$getElementText()})
    reply <- c(reply, unlist(reply_text))
  }
  
  # re-reply
  repbtn <- remDr$findElements(using='css selector', 'div.eo2As > div.EtaWk > ul > ul:nth-child(2) > li > ul > li > div > button')
  remDr$executeScript("arguments[0].click();",repbtn)
  
  rereply_css <- remDr$findElements(using='css selector', 'div.eo2As > div.EtaWk > ul > ul > li > ul > div > li > div > div.C7I1f > div.C4VMK > span')
  rereply_text <- sapply(rereply_css, function(x){x$getElementText()})
  if (length(rereply_text) == 0){
    cat("(no re-reply) ")
    rereply_NA <- NA
    re_reply <- c(re_reply, unlist(rereply_NA))
  }else{
    re_reply <- c(re_reply, unlist(rereply_text[1]))
    cat("(re-reply) ")
  }
  
  # 게시물 출력 수
  i <- i + 1
  cat('출력된 게시물 :',i,'\n')
  
  # 다음버튼(우측이동)클릭
  next_btn <- remDr$findElement(using='css selector','div > a._65Bje.coreSpriteRightPaginationArrow')
  next_btn$clickElement()
  Sys.sleep(5)
  
  # 데이터프레임 저장
  제주도맛집 <- data.frame(id, txt, date, like, video, reply, re_reply)
}

# ________________________________________________________________________________________________________________

length(id)
length(txt)
length(date)
length(like)
View(제주도맛집)

write.csv(제주도맛집, "C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/제주도맛집.csv")


# 스크롤: 5초씩 500번 반복을 수행한 경우: 3 ~ 4일전 게시물 위치로 이동
# for (x in 1:700) {
#   n <- sample(5:6, 1)
#   for (y in 1:n){
#     webElem <- remDr$findElement("css selector", "body")
#     remDr$executeScript("scrollTo(0, document.body.scrollHeight)", args = list(webElem))
#   }
#   Sys.sleep(n)
#   cat(n,x,'\n')
#   x < x+1
# }
