# 빅데이터 분석 프로젝트

> 2021년 3월 멀티캠퍼스 K-DIGITAL 프로젝트형 빅데이터 분석 서비스 개발 프로그램에서 진행한 **R을 이용한 빅데이터 분석 개발** 미니프로젝트입니다.

## 팀 구성(2팀)

- 팀원 : 강용, 최서영

## 프로젝트: 인스타그램 텍스트 시각화와 네이버 검색량과의 상관관계 

- 주제 선정이유:

  최근 인스타그램 게시물을 통한 광고량이 급증하고 있으며, 인플루언서, 소상공인 뿐만 아니라 많은 기업들도 인스타그램을 통해서 광고를 진행하고 있는 상황이다.

  인스타그램은 SNS APP MAU(월간 이용자 수)가 2020년도 이후 2위로 급상승 하였고 많은 게시물과 정보를 포함하고 있는 인스타그램의 실질적인 광고 효과의 신뢰도를 파악하고자 함.

- 사용 언어: R (Rstudio)

- 사용 라이브러리: serenium, rvest, ggplot2, dplyr, wordcloud, KoNLP

#### 팀 역할

- 강용: `제주도맛집` 키워드로 알아보는 데이터 수집, 전처리, 시각화, 분석

- 최서영: `제주도카페` 키워드로 알아보는 데이터 수집, 전처리, 시각화, 분석


#### 일정

- 데이터 수집: 2021-03-18 ~ 2021-03-19
- 데이터 전처리: 2021-03-18 ~ 2021-03-20
- 데이터 분석/검증: 2021-03-21 ~ 2021-03-22
- 데이터 시각화: 2021-03-22 ~ 2021-03-23
- 결과분석 ppt: 2021-03-23 ~ 2021-03-23

#### 개발 후기

- 최서영

  ```
  • 동적 웹페이지를 크롤링하는 부분에서 중간에 오류가 난 채 내버려두거나, 반복문이 끝난
  후에는 selenium 서버가 꺼져서, 일일이 데이터 수집 과정에 집중해야 하는 부분이 어려웠다.
  • 일정기간(일주일)이 지난 인스타그램 피드는 보이지 않아서 월간 검색량에 비해 짧은 데이터만
  수집할 수 있어서 아쉬웠다. 
  • 동적 웹페이지의 자료, 특히 많은 사람들이 사용하고 있는 인스타그램 데이터를 크롤링해서
  이용했다는 것이 뿌듯했다.
  ```

- 강용

  ```
  웹크롤링
  컨텐츠의 필요한 정보 반복문을 통해서 동일한 작업을 계속 수행할 경우 인스타그램에서 어느
  시점에 정보 제공을 막도록 설정하고 있어서 크롤링을 지속할 수가 없었습니다. 구글링으로 유사
  프로젝트를 검색해보았지만 인스타그램을 만개 이상으로 크롤링한 기록은 찾아보기 어려웠고
  3만개의 추출하기로한 목표설정을 달성하지 못해 아쉬웠습니다.
  데이터전처리
  수집한 데이터의 정보가 대부분 텍스트로 구성되어 있으며, 여러가지 특수문자와 외국어로 인하여
  전처리 작업이 많은 시간을 할애하게 되어서 분석을 충분히 하는데 제한이 되었습니다.
  • 분석
  마찬가지로 데이터가 텍스트로 구성되어 있어서 다각도로 분석하는게 제한이 되었습니다.
  • 총평
  이번 프로젝트로 크롤링만큼은 충분히 자신감이 생겼습니다!
  ```


#### 기타

- 발표자료 [자세히 보기](https://github.com/kdragonkorea/data-analysis-project/blob/master/ppt/%EB%AF%B8%EB%8B%88%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_2%EC%A1%B0.pdf)
- 소스(R) [자세히 보기](https://github.com/kdragonkorea/data-analysis-project/tree/master/source)
- 웹크롤링 시행착오 메모 [자세히 보기](https://github.com/kdragonkorea/data-analysis-project/blob/master/data/%EB%8D%B0%EC%9D%B4%ED%84%B0%EC%88%98%EC%A7%91.md)
