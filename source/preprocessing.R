jbr <- read.csv("C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/제주도맛집.csv")
# jbr - jeju best restaurant

# View(jbr)
# str(jbr)
# summary(jbr)

library(KoNLP)
library(dplyr)
library(ggplot2)
library(wordcloud)
library(wordcloud2)
library(tm)
library(treemap)


# read.csv를 통해 새로 만들어진 X행 제거
jbr2 <- jbr[,2:8]
#str(jbr2)

# date가 NA로 처리된 행 제거
jbr3 <- jbr2 %>% filter(!is.na(jbr2$date) == TRUE)
#str(jbr3)
jbr3 %>% filter(is.na(jbr3$id) == TRUE & is.na(jbr3$date) == TRUE)

# like: '가장 먼저 좋아요..' 를 '0'으로 변경
jbr3$like
jbr3$like <- gsub("가장 먼저 \n좋아요\n를 눌러보세요",0,jbr3$like)

# like: numeric으로 변경
jbr3$like <- gsub("좋아요 ","",jbr3$like)
jbr3$like <- gsub("개","",jbr3$like)
jbr3$like <- as.numeric(jbr3$like)
#str(jbr3$like)

# video: numeric으로 변경
jbr3$video <- gsub("조회 ","",jbr3$video)
jbr3$video <- gsub("회","",jbr3$video)
jbr3$video <- as.numeric(jbr3$video)
#str(jbr3$video)

# like와 video가 둘다 NA값이 아닌 데이터가 있는지 확인방법
# jbr %>% filter(!is.na(jbr$like) == TRUE & is.na(jbr3$date) == TRUE)
# jbr %>% filter(is.na(jbr$like) == FALSE & is.na(jbr$video) == FALSE)

# like와 video의 수를 더한 데이터열 추가(like_video)
jbr3 <- jbr3 %>% mutate(like_video = ifelse(is.na(like) == TRUE, video,like))
#str(jbr3)
#View(jbr3)

# 모든 열의 중복된 내용의 행 제거
nrow(jbr3)
nrow(unique(jbr3))
jbr4 <- unique(jbr3)
#str(jbr4)


# '특수문자', '@~' 제거
# (1) txt
txt_col <- jbr4$txt
txt_col <- gsub("<[U+A-Z0-9>]+", " ", txt_col)
txt_col <- gsub("[^#가-힣 |^#A-z |^#0-9 ]", " ", txt_col)
txt_col <- gsub("[0-9]", " ", txt_col)
txt_col <- gsub("(# )", "", txt_col)
txt_col <- gsub("#", " #", txt_col)
txt_col <- gsub("# #", "", txt_col)
# grep("[#].+[가-힣]",txt_col)
# txt_col[3020]

txt_test <- data.frame(jbr4$txt, txt_col)
#View(txt_test)

# (2) reply
reply_col <- jbr4$reply
reply_col <- gsub("<[U+A-Z0-9>]+", "", reply_col)
reply_col <- gsub("[^#가-힣 |^#A-z |^#0-9 ]", "", reply_col)
reply_col <- gsub("(# )", "", reply_col)  # '# # #' -> '#'
reply_col <- gsub("#", " #", reply_col)

reply_test <- data.frame(jbr4$reply, reply_col)
#View(reply_test)

# (3) re_reply
re_reply_col <- jbr4$re_reply
re_reply_col <- gsub("@[a-z_.0-9]+", "", re_reply_col)
re_reply_col <- gsub("[^#가-힣 |^#A-z |^#0-9 ]", "", re_reply_col)
re_reply_col <- gsub("[A-Z]", "", re_reply_col)
re_reply_col <- gsub("(# )", "", re_reply_col)
re_reply_col <- gsub("#", " #", re_reply_col)
# re_reply_col <- gsub("[[:digit:][A-Z]]", "", re_reply_col)
# re_reply_col <- gsub("[@a-z |@0-9 ]", "", re_reply_col)
# re_reply_col <- gsub("[A-Z | <+>_]", "", re_reply_col)

re_reply_test <- data.frame(jbr4$re_reply, re_reply_col)
#View(re_reply_test)


# 데이터 전처리 후 데이터프레임 jbr5
jbr5 <- data.frame(jbr4$id, txt_col, jbr4$date, jbr4$like, jbr4$video, 
                   reply_col, re_reply_col, jbr4$like_video)
jbr5 <- jbr5 %>% 
  rename(id = jbr4.id, txt = txt_col, date = jbr4.date, like = jbr4.like, 
         video = jbr4.video, reply = reply_col, re_reply = re_reply_col, 
         like_video = jbr4.like_video)


# 전처리한 모든 데이터 데이터프레임 저장
write.csv(jbr5, "C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/제주도맛집_전처리.csv")






