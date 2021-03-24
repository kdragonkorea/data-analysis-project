jbr5 <- read.csv("C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/제주도맛집_전처리.csv")
# str(jbr5)
# View(jbr5)
jbr5 <- jbr5[,2:9] # X행 제거

library(KoNLP)
library(dplyr)
library(ggplot2)
library(wordcloud2)
library(treemap)

# extractNoun -> wordcloud2
library(htmlwidgets)

# reply
#reply_word <- extractNoun(jbr5$reply)
reply_word2 <- unlist(reply_word)
reply_word2 <- Filter(function(x) {nchar(x) >= 2}, reply_word2) # 2개 이상의 단어
reply_word3 <- table(reply_word2)
reply_wordcloud <- wordcloud2(data = reply_word3, shape = 'diamond', size=0.5)
saveWidget(reply_wordcloud,"C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/reply_wordcloud.html",selfcontained = F)

# re_reply
#re_reply_word <- extractNoun(jbr5$re_reply)
re_reply_word2 <- unlist(re_reply_word)
re_reply_word2 <- Filter(function(x) {nchar(x) >= 2}, re_reply_word2)
re_reply_word3 <- table(re_reply_word2)
re_reply_wordcloud <- wordcloud2(data = re_reply_word3, shape = 'diamond', size=0.5)
saveWidget(re_reply_wordcloud,"C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/re_reply_wordcloud.html",selfcontained = F)

# txt
#txt_word <- extractNoun(jbr5$txt)
txt_word2 <- unlist(txt_word)
txt_word2 <- Filter(function(x) {nchar(x) >= 2}, txt_word2)
txt_word3 <- table(txt_word2)
txt_wordcloud <- wordcloud2(data = txt_word3, shape = 'diamond', size=0.5)
saveWidget(txt_wordcloud,"C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/txt_wordcloud.html",selfcontained = F)



# 분석 시작
# reply, re_reply, txt 빈출단어 top10 추출
# reply
reply_top10 <- head(sort(reply_word3, T),10)
reply_top10 <- data.frame(reply_top10) 
reply_top10 <- reply_top10 %>% rename(키워드 = reply_word2, 빈도수 = Freq)

# re_reply
re_reply_top10 <- head(sort(re_reply_word3, T),10)
re_reply_top10 <- data.frame(re_reply_top10) 
re_reply_top10 <- re_reply_top10 %>% rename(키워드 = re_reply_word2, 빈도수 = Freq)

# txt
txt_top10 <- head(sort(txt_word3, T),10)
txt_top10 <- data.frame(txt_top10) 
txt_top10 <- txt_top10 %>% rename(키워드 = txt_word2, 빈도수 = Freq)


# reply, re_reply, txt 데이터프레임 합치기
all_top10 <- bind_rows(txt_top10, reply_top10, re_reply_top10)
bind_cols(txt_top10, reply_top10, re_reply_top10)


# 시각화: 막대 그래프
# txt
ggplot(txt_top10,aes(빈도수, 키워드)) + 
  geom_bar(stat="identity") +
  labs(title="본문내용 단어 빈출수") + theme_light()

# reply
ggplot(reply_top10,aes(빈도수, 키워드)) + 
  geom_bar(stat="identity") +
  labs(title="댓글 단어 빈출수") + theme_light()

# re_reply
ggplot(re_reply_top10,aes(빈도수, 키워드)) + 
  geom_bar(stat="identity") +
  labs(title="대댓글 단어 빈출수") + theme_light()

# all
ggplot(all_top10,aes(빈도수, 키워드)) + 
  geom_bar(stat="identity") +
  labs(title="모든 단어 빈출수") + theme_light()

ggsave("C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/re_reply_top10.png")


# 트리맵
treemap(all_top10, vSize="빈도수", index=c("키워드"), 
        title="#제주도맛집 키워드로 검색한 단어 빈출현황")


# 일자별 게시물 수
date_table <- table(jbr5$date)
date_table2 <- sort(date_table, T)
date_table3 <- head(date_table2, 6)
date <- data.frame(date_table3) 
date <- date %>% rename(게시일자 = Var1, 게시물수 = Freq)

# 시각화: ggplot - bar
ggplot(date,aes(게시물수, 게시일자)) + 
  geom_bar(stat="identity") +
  labs(title="일자별 게시물 수") + theme_light()
ggsave("C:/Users/kangyong/Bigdata_analysis_course_20201228/8_미니프로젝트(R)/data/일별_컨텐츠수.png")


# 게시물양 TOP10 id 시각화
id_to10 <- head(sort(table(jbr5$id),T),10)
id_to10 <- data.frame(id_to10)
id_to10 <- id_to10 %>% rename(아이디 = Var1, 게시물수 = Freq)

ggplot(id_to10,aes(게시물수, 아이디)) + 
  geom_bar(stat="identity") +
  labs(title="게시물양 순위") + theme_light()

# id별 게시물수와 like수 상관비교
# id와 게시물수
id <- sort(table(jbr5$id),T)
id <- data.frame(id)
id <- id %>% rename(아이디 = Var1, 게시물수 = Freq)
#str(id)

# id와 like 
# jbr5 %>% filter(like_video > 100) %>% select(id, like_video) %>% head
id_like <- jbr5 %>% select(id, like_video)
id_like_table <- table(id_like)
id_like_df <- data.frame(id_like_table)
id_like_df <- id_like_df %>% rename(아이디 = id, 좋아요 = like_video)
str(id_like_df)

# id와 게시물수, like 합치기
id_like <- merge(id, jbr5_id_like_video)
str(id_like)

head(sort(table(jbr5_id_like_video),T), 10)

# cor(jbr5$id, jbr5$like_video) # 숫자인 경우에만 상관분석이 가능






    





