Vinh Do - Risk Analysis Project

install.packages('tidyverse')
install.packages('tidymodels')
install.packages('dplyr')
install.packages('skimr')
install.packages('ggplot2')
install.packages('gapminder')
install.packages('gridExtra')
install.packages('vip')
install.packages('discrim')
install.packages('rpart.plot')
install.packages('ranger')
install.packages('themis')

## Add R libraries 
library(tidyverse)
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
## ✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
## ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
## ✔ readr   2.1.3      ✔ forcats 0.5.2 
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
library(tidymodels)
## ── Attaching packages ────────────────────────────────────── tidymodels 1.0.0 ──
## ✔ broom        1.0.1     ✔ rsample      1.1.0
## ✔ dials        1.1.0     ✔ tune         1.0.1
## ✔ infer        1.0.3     ✔ workflows    1.1.2
## ✔ modeldata    1.0.1     ✔ workflowsets 1.0.0
## ✔ parsnip      1.0.3     ✔ yardstick    1.1.0
## ✔ recipes      1.0.3     
## ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
## ✖ scales::discard() masks purrr::discard()
## ✖ dplyr::filter()   masks stats::filter()
## ✖ recipes::fixed()  masks stringr::fixed()
## ✖ dplyr::lag()      masks stats::lag()
## ✖ yardstick::spec() masks readr::spec()
## ✖ recipes::step()   masks stats::step()
## • Use suppressPackageStartupMessages() to eliminate package startup messages
library(dplyr)
library(skimr)
library(ggplot2)
library(gapminder)
library(gridExtra)
library(vip)
library(discrim)
library(rpart.plot)
library(ranger)
library(themis)

## Processing Datasets
loans_df <- read_csv("/cloud/project/Datasets/Loans.csv") %>%
  mutate(NotFullyPaid = as.factor(if_else(NotFullyPaid == 1,"Yes","No")))
loans_df  <- na.omit(loans_df )

loans_df$Purpose <- as.factor(loans_df$Purpose)
loans_df$PubRec <- as.factor(loans_df$PubRec)
loans_df$Delinq2yrs <- as.factor(loans_df$Delinq2yrs)
loans_df$InqLast6mths <- as.factor(loans_df$InqLast6mths)
loans_df <- loans_df %>% 
            mutate(Installment = replace(Installment, Installment > 0 & Installment <= 200 , ' Under $200'),
                   Installment = replace(Installment, Installment > 200 & Installment <= 400 , '$200 - $400'),
                   Installment = replace(Installment, Installment > 400 & Installment <= 600 , '$400 - $600'),
                   Installment = replace(Installment, Installment > 600 , '$600 and Above'),
                   Dti = replace(Dti,Dti <= 5 , ' Under 5'),
                   Dti = replace(Dti,Dti > 5 & Dti <= 10 , '5 - 10'),
                   Dti = replace(Dti,Dti > 10 & Dti <= 15 , '10 - 15'),
                   Dti = replace(Dti,Dti > 15 , '15 and above'))
skim(loans_df)
Data summary
Name	loans_df
Number of rows	9578
Number of columns	14
_______________________	
Column type frequency:	
character	2
factor	5
numeric	7
________________________	
Group variables	None
Variable type: character
skim_variable	n_missing	complete_rate	min	max	empty	n_unique	whitespace
Installment	0	1	11	14	0	4	0
Dti	0	1	2	12	0	4	0
Variable type: factor
skim_variable	n_missing	complete_rate	ordered	n_unique	top_counts
Purpose	0	1	FALSE	7	deb: 3957, all: 2331, cre: 1262, hom: 629
InqLast6mths	0	1	FALSE	28	0: 3637, 1: 2462, 2: 1384, 3: 864
Delinq2yrs	0	1	FALSE	11	0: 8458, 1: 832, 2: 192, 3: 65
PubRec	0	1	FALSE	6	0: 9019, 1: 533, 2: 19, 3: 5
NotFullyPaid	0	1	FALSE	2	No: 8045, Yes: 1533
Variable type: numeric
skim_variable	n_missing	complete_rate	mean	sd	p0	p25	p50	p75	p100	hist
CreditPolicy	0	1	0.80	0.40	0.00	1.00	1.00	1.00	1.00	▂▁▁▁▇
IntRate	0	1	0.12	0.03	0.06	0.10	0.12	0.14	0.22	▃▇▇▂▁
LogAnnualInc	0	1	10.93	0.61	7.55	10.56	10.93	11.29	14.53	▁▂▇▁▁
Fico	0	1	710.85	37.97	612.00	682.00	707.00	737.00	827.00	▁▇▆▃▁
DaysWithCrLine	0	1	4560.77	2496.93	178.96	2820.00	4139.96	5730.00	17639.96	▇▇▂▁▁
RevolBal	0	1	16913.96	33756.19	0.00	3187.00	8596.00	18249.50	1207359.00	▇▁▁▁▁
RevolUtil	0	1	46.80	29.01	0.00	22.60	46.30	70.90	119.00	▇▇▇▆▁
loans_df
## # A tibble: 9,578 × 14
##    CreditP…¹ Purpose IntRate Insta…² LogAn…³ Dti    Fico DaysW…⁴ Revol…⁵ Revol…⁶
##        <dbl> <fct>     <dbl> <chr>     <dbl> <chr> <dbl>   <dbl>   <dbl>   <dbl>
##  1         1 debt_c…  0.119  "$600 …    11.4 "15 …   737   5640.   28854    52.1
##  2         1 credit…  0.107  "$200 …    11.1 "10 …   707   2760    33623    76.7
##  3         1 debt_c…  0.136  "$200 …    10.4 "10 …   682   4710     3511    25.6
##  4         1 debt_c…  0.101  " Unde…    11.4 "15 …   712   2700.   33667    73.2
##  5         1 credit…  0.143  " Unde…    11.3 "10 …   667   4066     4740    39.5
##  6         1 credit…  0.0788 " Unde…    11.9 "15 …   727   6120.   50807    51  
##  7         1 debt_c…  0.150  " Unde…    10.7 " Un…   667   3180.    3839    76.8
##  8         1 all_ot…  0.111  " Unde…    11.0 "10 …   722   5116    24220    68.6
##  9         1 home_i…  0.113  " Unde…    11.4 "15 …   682   3989    69909    51.1
## 10         1 debt_c…  0.122  " Unde…    10.2 "10"    707   2730.    5630    23  
## # … with 9,568 more rows, 4 more variables: InqLast6mths <fct>,
## #   Delinq2yrs <fct>, PubRec <fct>, NotFullyPaid <fct>, and abbreviated
## #   variable names ¹CreditPolicy, ²Installment, ³LogAnnualInc, ⁴DaysWithCrLine,
## #   ⁵RevolBal, ⁶RevolUtil

#Table 1
PubRecord <- loans_df %>% 
  group_by(NotFullyPaid, PubRec) %>% 
  summarise(N = n()) %>% 
  mutate(Percentage =  round(N / sum(N) * 100 , 3))
## `summarise()` has grouped output by 'NotFullyPaid'. You can override using the
## `.groups` argument.
knitr::kable(PubRecord, format = "markdown")

NotFullyPaid	PubRec	N	Percentage
Yes	0	1395	90.998
Yes	1	136	8.871
Yes	2	2	0.130
No	0	7624	94.767
No	1	397	4.935
No	2	17	0.211
No	3	5	0.062
No	4	1	0.012
No	5	1	0.012

##Table 2
dtivalue <- loans_df %>% 
  group_by( NotFullyPaid, Dti) %>% 
  summarise(N = n()) %>% 
  mutate(Percentage =  round(N / sum(N) * 100 , 3))
## `summarise()` has grouped output by 'NotFullyPaid'. You can override using the
## `.groups` argument.
knitr::kable(dtivalue, format = "markdown")
NotFullyPaid	Dti	N	Percentage
Yes	Under 5	229	14.938
Yes	10	3	0.196
Yes	10 - 15	352	22.962
Yes	15 and above	949	61.905
No	Under 5	1372	17.054
No	10	16	0.199
No	10 - 15	1919	23.853
No	15 and above	4738	58.894


##Table 3
Pur <- loans_df %>% 
  group_by(NotFullyPaid, Purpose) %>% 
  summarise(N = n()) %>% 
  mutate(Percentage =  round(N / sum(N) * 100 , 3))
## `summarise()` has grouped output by 'NotFullyPaid'. You can override using the
## `.groups` argument.
knitr::kable(Pur, format = "markdown")
NotFullyPaid	Purpose	N	Percentage
Yes	all_other	387	25.245
Yes	credit_card	146	9.524
Yes	debt_consolidation	603	39.335
Yes	educational	69	4.501
Yes	home_improvement	107	6.980
Yes	major_purchase	49	3.196
Yes	small_business	172	11.220
No	all_other	1944	24.164
No	credit_card	1116	13.872
No	debt_consolidation	3354	41.690
No	educational	274	3.406
No	home_improvement	522	6.489
No	major_purchase	388	4.823
No	small_business	447	5.556


##Figure 1 
Figure 1
ggplot(data = loans_df, mapping = aes(x = NotFullyPaid, fill = Purpose)) +
      geom_bar(stat = "count", position = "fill", color = "black") +
      scale_fill_manual(values  = c("palegoldenrod", "darkolivegreen3", "palegoldenrod", "palegoldenrod", "palegoldenrod", "palegoldenrod", "salmon2")) +
      coord_flip() +
      labs(title = "Fully Paid Status by Purpose of Loan", y = "Fully Paid Status", x = "Purpose of Loan") +
      theme(legend.background = element_rect(fill = "ivory2"),
        panel.background = element_rect(fill = "ivory2"),
        plot.background = element_rect(fill = "ivory2"))


##Figure 2
ggplot(data = loans_df ,mapping = aes(x = IntRate, color = NotFullyPaid, fill = NotFullyPaid)) +
  geom_density(alpha=0.3,size=1) +
  scale_x_log10() +
  scale_color_manual(values=c('darkolivegreen4','salmon3')) +
  scale_fill_manual(values  = c("darkolivegreen1" , "salmon1")) +
  labs(title = "Fully Paid Status by The Interest Rate", y = "Fully Paid Status", x = "The Insterest Rate") +
  theme(legend.background = element_rect(fill = "ivory2"),
        panel.background = element_rect(fill = "ivory2"),
        plot.background = element_rect(fill = "ivory2"))

##Figure 3
ggplot(data = loans_df ,mapping = aes(x = Fico,y = NotFullyPaid , fill = NotFullyPaid)) +
  geom_boxplot(color = "black")  +
  scale_fill_manual(values  = c("darkolivegreen3", "salmon2")) +
  coord_flip() +
  labs(title = "Box Plot of  Fully Paid Status by Fico Scores", y = "Fully Paid Status", x = "Fico Scores") +
  theme(legend.background = element_rect(fill = "ivory2"),
        panel.background = element_rect(fill = "ivory2"),
        plot.background = element_rect(fill = "ivory2"))


##Table 4
account <- loans_df %>% 
  group_by( NotFullyPaid, Installment) %>% 
  summarise(savingacct = n()) %>% 
  mutate(Percentage =  round(savingacct / sum(savingacct) * 100 , 3))
## `summarise()` has grouped output by 'NotFullyPaid'. You can override using the
## `.groups` argument.
knitr::kable(account, format = "markdown")
NotFullyPaid	Installment	savingacct	Percentage
Yes	Under $200	505	32.942
Yes	$200 - $400	533	34.768
Yes	$400 - $600	264	17.221
Yes	$600 and Above	231	15.068
No	Under $200	2904	36.097
No	$200 - $400	2895	35.985
No	$400 - $600	1326	16.482
No	$600 and Above	920	11.436

#Figure 4
ggplot(data = loans_df, mapping = aes(x = Installment, fill = NotFullyPaid)) +
      geom_bar(stat = "count", position = "fill", color = "black") +
            scale_fill_manual(values  = c( "darkolivegreen3", "salmon2")) +
      labs(title = "Fully Paid Status by Installment", y = "Fully Paid Status", x = "Installment") +
      theme(legend.background = element_rect(fill = "ivory2"),
        panel.background = element_rect(fill = "ivory2"),
        plot.background = element_rect(fill = "ivory2"))

— End of the Project —