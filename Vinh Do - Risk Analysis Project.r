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

2. Exploratory Data Analysis
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

3.3. ML Model Building Exercise
3.1 Feature engineering
set.seed(1509)

loans_split <- initial_split(loans_df,prop=0.75,strata=NotFullyPaid)
loans_training <- loans_split%>% training()
loans_test <- loans_split%>% testing()

set.seed(1509) 

loans_folds <- vfold_cv(loans_training, v = 5)
loans_recipe <- recipe(NotFullyPaid ~ ., data = loans_training) %>%
                step_YeoJohnson(all_numeric(), -all_outcomes()) %>%
                step_normalize(all_numeric(), -all_outcomes()) %>%
                step_dummy(all_nominal(), -all_outcomes()) %>% 
                step_smote(NotFullyPaid,over_ratio = 1) 
loans_recipe 
## Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         13
## 
## Operations:
## 
## Yeo-Johnson transformation on all_numeric(), -all_outcomes()
## Centering and scaling for all_numeric(), -all_outcomes()
## Dummy variables from all_nominal(), -all_outcomes()
## SMOTE based on NotFullyPaid
loans_recipe %>% 
  prep() %>% 
  bake(new_data = loans_test)
## # A tibble: 2,396 × 19
##    CreditPolicy IntRate Install…¹ LogAnn…²    Dti   Fico DaysW…³ Revol…⁴ Revol…⁵
##           <dbl>   <dbl>     <dbl>    <dbl>  <dbl>  <dbl>   <dbl>   <dbl>   <dbl>
##  1        0.493  -1.69    -1.00    1.57     0.642  0.520   0.742  1.48     0.256
##  2        0.493  -1.40     0.218   0.00810  0.442  1.40    0.873 -0.188   -0.974
##  3        0.493  -0.433    0.272  -0.305    0.106 -0.138   1.36  -0.259    0.330
##  4        0.493   0.369   -1.51   -0.654   -1.59  -1.07   -0.108 -0.733    1.31 
##  5        0.493  -1.64    -0.507   0.479    0.522  1.49    0.302  0.980   -0.704
##  6        0.493  -1.38     0.868  -0.175   -1.52   1.94    2.29  -0.231   -0.535
##  7        0.493  -1.23    -0.718   2.41    -0.329  0.137  -1.46   0.389   -0.212
##  8        0.493  -1.61    -0.735   0.942   -1.58   0.871  -0.463  0.112   -0.859
##  9        0.493  -0.724    0.0146 -1.83    -0.878 -0.428   1.16   0.0503  -0.561
## 10        0.493  -1.88    -0.746   1.59    -2.05   1.59    1.06  -0.190   -0.855
## # … with 2,386 more rows, 10 more variables: InqLast6mths <dbl>,
## #   Delinq2yrs <dbl>, PubRec <dbl>, NotFullyPaid <fct>,
## #   Purpose_credit_card <dbl>, Purpose_debt_consolidation <dbl>,
## #   Purpose_educational <dbl>, Purpose_home_improvement <dbl>,
## #   Purpose_major_purchase <dbl>, Purpose_small_business <dbl>, and abbreviated
## #   variable names ¹Installment, ²LogAnnualInc, ³DaysWithCrLine, ⁴RevolBal,
## #   ⁵RevolUtil
3.2 - Models
Logistic model
loan_logistic_model <- logistic_reg()%>%
  set_engine ('glm')%>%
  set_mode('classification')
loan_logistic_model
## Logistic Regression Model Specification (classification)
## 
## Computational engine: glm
loan_wf <- workflow()%>%
  add_model(loan_logistic_model)%>%
  add_recipe(loans_recipe)
loan_wf
## ══ Workflow ════════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: logistic_reg()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 4 Recipe Steps
## 
## • step_YeoJohnson()
## • step_normalize()
## • step_dummy()
## • step_smote()
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## Logistic Regression Model Specification (classification)
## 
## Computational engine: glm
loan_logistic_fit <- loan_wf%>%
  fit(data=loans_training)
loan_logistic_fit
## ══ Workflow [trained] ══════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: logistic_reg()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 4 Recipe Steps
## 
## • step_YeoJohnson()
## • step_normalize()
## • step_dummy()
## • step_smote()
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## 
## Call:  stats::glm(formula = ..y ~ ., family = stats::binomial, data = data)
## 
## Coefficients:
##                (Intercept)                CreditPolicy  
##                   -0.18720                     0.13177  
##                    IntRate                 Installment  
##                    0.00362                    -0.34104  
##               LogAnnualInc                         Dti  
##                    0.33199                     0.02990  
##                       Fico              DaysWithCrLine  
##                    0.40004                    -0.06439  
##                   RevolBal                   RevolUtil  
##                   -0.09714                    -0.07739  
##               InqLast6mths                  Delinq2yrs  
##                   -0.23826                     0.10461  
##                     PubRec         Purpose_credit_card  
##                   -0.04311                     0.87673  
## Purpose_debt_consolidation         Purpose_educational  
##                    0.51126                     0.28990  
##   Purpose_home_improvement      Purpose_major_purchase  
##                    0.13891                     0.68191  
##     Purpose_small_business  
##                   -0.38917  
## 
## Degrees of Freedom: 12065 Total (i.e. Null);  12047 Residual
## Null Deviance:       16730 
## Residual Deviance: 15360     AIC: 15400
loan_trained_model <- loan_logistic_fit%>%
  pull_workflow_fit()
## Warning: `pull_workflow_fit()` was deprecated in workflows 0.2.3.
## ℹ Please use `extract_fit_parsnip()` instead.
loan_trained_model
## parsnip model object
## 
## 
## Call:  stats::glm(formula = ..y ~ ., family = stats::binomial, data = data)
## 
## Coefficients:
##                (Intercept)                CreditPolicy  
##                   -0.18720                     0.13177  
##                    IntRate                 Installment  
##                    0.00362                    -0.34104  
##               LogAnnualInc                         Dti  
##                    0.33199                     0.02990  
##                       Fico              DaysWithCrLine  
##                    0.40004                    -0.06439  
##                   RevolBal                   RevolUtil  
##                   -0.09714                    -0.07739  
##               InqLast6mths                  Delinq2yrs  
##                   -0.23826                     0.10461  
##                     PubRec         Purpose_credit_card  
##                   -0.04311                     0.87673  
## Purpose_debt_consolidation         Purpose_educational  
##                    0.51126                     0.28990  
##   Purpose_home_improvement      Purpose_major_purchase  
##                    0.13891                     0.68191  
##     Purpose_small_business  
##                   -0.38917  
## 
## Degrees of Freedom: 12065 Total (i.e. Null);  12047 Residual
## Null Deviance:       16730 
## Residual Deviance: 15360     AIC: 15400
vip(loan_trained_model)
 
loans_categories <- predict(loan_logistic_fit,new_data=loans_test)
loans_categories
## # A tibble: 2,396 × 1
##    .pred_class
##    <fct>      
##  1 No         
##  2 No         
##  3 No         
##  4 Yes        
##  5 No         
##  6 No         
##  7 No         
##  8 No         
##  9 No         
## 10 No         
## # … with 2,386 more rows
loans_probabilities <- predict(loan_logistic_fit, new_data= loans_test, type='prob')
loans_probabilities
## # A tibble: 2,396 × 2
##    .pred_Yes .pred_No
##        <dbl>    <dbl>
##  1     0.133    0.867
##  2     0.236    0.764
##  3     0.457    0.543
##  4     0.517    0.483
##  5     0.331    0.669
##  6     0.397    0.603
##  7     0.157    0.843
##  8     0.170    0.830
##  9     0.488    0.512
## 10     0.163    0.837
## # … with 2,386 more rows
loans_results <- loans_test %>% select(NotFullyPaid)%>%bind_cols(loans_categories)%>% bind_cols(loans_probabilities)
loans_results
## # A tibble: 2,396 × 4
##    NotFullyPaid .pred_class .pred_Yes .pred_No
##    <fct>        <fct>           <dbl>    <dbl>
##  1 No           No              0.133    0.867
##  2 No           No              0.236    0.764
##  3 No           No              0.457    0.543
##  4 No           Yes             0.517    0.483
##  5 No           No              0.331    0.669
##  6 No           No              0.397    0.603
##  7 No           No              0.157    0.843
##  8 No           No              0.170    0.830
##  9 No           No              0.488    0.512
## 10 No           No              0.163    0.837
## # … with 2,386 more rows
conf_mat(loans_results,truth=NotFullyPaid,estimate = .pred_class)
##           Truth
## Prediction  Yes   No
##        Yes  234  738
##        No   150 1274
f1_logistics <- f_meas(loans_results,truth=NotFullyPaid, estimate=.pred_class)

roc_auc_logistics <- roc_auc(loans_results,truth=NotFullyPaid,estimate=.pred_Yes)

roc_curve(loans_results,truth=NotFullyPaid,estimate=.pred_Yes)%>% autoplot()
 
KNN model
knn_model <- nearest_neighbor(neighbors = tune()) %>%
             set_engine('kknn') %>%
             set_mode('classification')
knn_wf <- workflow() %>% 
          add_model(knn_model) %>% 
          add_recipe(loans_recipe)
knn_wf
## ══ Workflow ════════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: nearest_neighbor()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 4 Recipe Steps
## 
## • step_YeoJohnson()
## • step_normalize()
## • step_dummy()
## • step_smote()
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## K-Nearest Neighbor Model Specification (classification)
## 
## Main Arguments:
##   neighbors = tune()
## 
## Computational engine: kknn
k_grid <- tibble(neighbors=c(10,20,30,50,75,100,125,150))
knn_tuning <- knn_wf %>%
              tune_grid(resamples = loans_folds, grid = k_grid)
knn_tuning %>%
show_best('roc_auc')
## # A tibble: 5 × 7
##   neighbors .metric .estimator  mean     n std_err .config             
##       <dbl> <chr>   <chr>      <dbl> <int>   <dbl> <chr>               
## 1       150 roc_auc binary     0.623     5  0.0117 Preprocessor1_Model8
## 2       125 roc_auc binary     0.620     5  0.0117 Preprocessor1_Model7
## 3       100 roc_auc binary     0.617     5  0.0119 Preprocessor1_Model6
## 4        75 roc_auc binary     0.611     5  0.0123 Preprocessor1_Model5
## 5        50 roc_auc binary     0.603     5  0.0130 Preprocessor1_Model4
knn_tuning
## # Tuning results
## # 5-fold cross-validation 
## # A tibble: 5 × 4
##   splits              id    .metrics          .notes          
##   <list>              <chr> <list>            <list>          
## 1 <split [5745/1437]> Fold1 <tibble [16 × 5]> <tibble [0 × 3]>
## 2 <split [5745/1437]> Fold2 <tibble [16 × 5]> <tibble [0 × 3]>
## 3 <split [5746/1436]> Fold3 <tibble [16 × 5]> <tibble [0 × 3]>
## 4 <split [5746/1436]> Fold4 <tibble [16 × 5]> <tibble [0 × 3]>
## 5 <split [5746/1436]> Fold5 <tibble [16 × 5]> <tibble [0 × 3]>
best_k <- knn_tuning %>%
          select_best(metric = 'roc_auc')
best_k
## # A tibble: 1 × 2
##   neighbors .config             
##       <dbl> <chr>               
## 1       150 Preprocessor1_Model8
final_knn_wf <- knn_wf %>%
                finalize_workflow(best_k)
final_knn_wf
## ══ Workflow ════════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: nearest_neighbor()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 4 Recipe Steps
## 
## • step_YeoJohnson()
## • step_normalize()
## • step_dummy()
## • step_smote()
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## K-Nearest Neighbor Model Specification (classification)
## 
## Main Arguments:
##   neighbors = 150
## 
## Computational engine: kknn
knn_fit <- final_knn_wf %>%
           last_fit(split = loans_split)
knn_fit <-  knn_fit %>%
                collect_metrics()
knn_fit
## # A tibble: 2 × 4
##   .metric  .estimator .estimate .config             
##   <chr>    <chr>          <dbl> <chr>               
## 1 accuracy binary         0.634 Preprocessor1_Model1
## 2 roc_auc  binary         0.653 Preprocessor1_Model1
knn_fit <- final_knn_wf %>%
           last_fit(split = loans_split)
knn_predictions <- knn_fit%>%
                  collect_predictions()
knn_predictions
## # A tibble: 2,396 × 7
##    id               .pred_Yes .pred_No  .row .pred_class NotFullyPaid .config   
##    <chr>                <dbl>    <dbl> <int> <fct>       <fct>        <chr>     
##  1 train/test split     0.119    0.881     6 No          No           Preproces…
##  2 train/test split     0.371    0.629    13 No          No           Preproces…
##  3 train/test split     0.388    0.612    16 No          No           Preproces…
##  4 train/test split     0.605    0.395    17 Yes         No           Preproces…
##  5 train/test split     0.236    0.764    21 No          No           Preproces…
##  6 train/test split     0.198    0.802    22 No          No           Preproces…
##  7 train/test split     0.335    0.665    26 No          No           Preproces…
##  8 train/test split     0.134    0.866    31 No          No           Preproces…
##  9 train/test split     0.248    0.752    32 No          No           Preproces…
## 10 train/test split     0.134    0.866    33 No          No           Preproces…
## # … with 2,386 more rows
knn_predictions %>% 
  roc_curve(truth=NotFullyPaid,estimate=.pred_Yes)%>% 
  autoplot()
 
roc_auc_knn <- roc_auc(knn_predictions, truth = NotFullyPaid, .pred_Yes)
roc_auc_knn
## # A tibble: 1 × 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 roc_auc binary         0.653
f1_knn <-  f_meas(knn_predictions,truth=NotFullyPaid, estimate=.pred_class) 


conf_mat(knn_predictions,truth=NotFullyPaid,estimate=.pred_class)
##           Truth
## Prediction  Yes   No
##        Yes  224  718
##        No   160 1294
Tree decision model
tree_model <- decision_tree(cost_complexity = tune(),
                            tree_depth = tune(),
                            min_n = tune()) %>% 
              set_engine("rpart") %>% 
              set_mode('classification')
tree_workflow <- workflow() %>% 
                 add_model(tree_model) %>% 
                 add_recipe(loans_recipe)
tree_workflow
## ══ Workflow ════════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: decision_tree()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 4 Recipe Steps
## 
## • step_YeoJohnson()
## • step_normalize()
## • step_dummy()
## • step_smote()
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## Decision Tree Model Specification (classification)
## 
## Main Arguments:
##   cost_complexity = tune()
##   tree_depth = tune()
##   min_n = tune()
## 
## Computational engine: rpart
tree_grid <- grid_regular(cost_complexity(),
                                   tree_depth(),
                                   min_n(),
                                   levels = 3)
tree_grid
## # A tibble: 27 × 3
##    cost_complexity tree_depth min_n
##              <dbl>      <int> <int>
##  1    0.0000000001          1     2
##  2    0.00000316            1     2
##  3    0.1                   1     2
##  4    0.0000000001          8     2
##  5    0.00000316            8     2
##  6    0.1                   8     2
##  7    0.0000000001         15     2
##  8    0.00000316           15     2
##  9    0.1                  15     2
## 10    0.0000000001          1    21
## # … with 17 more rows
set.seed(1803)

tree_tuning <- tree_workflow %>% 
               tune_grid(resamples = loans_folds,
                         grid = tree_grid)
tree_tuning
## # Tuning results
## # 5-fold cross-validation 
## # A tibble: 5 × 4
##   splits              id    .metrics          .notes          
##   <list>              <chr> <list>            <list>          
## 1 <split [5745/1437]> Fold1 <tibble [54 × 7]> <tibble [0 × 3]>
## 2 <split [5745/1437]> Fold2 <tibble [54 × 7]> <tibble [0 × 3]>
## 3 <split [5746/1436]> Fold3 <tibble [54 × 7]> <tibble [0 × 3]>
## 4 <split [5746/1436]> Fold4 <tibble [54 × 7]> <tibble [0 × 3]>
## 5 <split [5746/1436]> Fold5 <tibble [54 × 7]> <tibble [0 × 3]>
tree_tuning %>% 
  show_best('roc_auc')
## # A tibble: 5 × 9
##   cost_complexity tree_depth min_n .metric .estima…¹  mean     n std_err .config
##             <dbl>      <int> <int> <chr>   <chr>     <dbl> <int>   <dbl> <chr>  
## 1    0.0000000001          8    21 roc_auc binary    0.592     5  0.0114 Prepro…
## 2    0.00000316            8    21 roc_auc binary    0.592     5  0.0114 Prepro…
## 3    0.0000000001          8    40 roc_auc binary    0.591     5  0.0112 Prepro…
## 4    0.00000316            8    40 roc_auc binary    0.591     5  0.0112 Prepro…
## 5    0.0000000001          8     2 roc_auc binary    0.584     5  0.0122 Prepro…
## # … with abbreviated variable name ¹.estimator
best_tree <- tree_tuning %>% 
             select_best(metric = 'roc_auc')
best_tree
## # A tibble: 1 × 4
##   cost_complexity tree_depth min_n .config              
##             <dbl>      <int> <int> <chr>                
## 1    0.0000000001          8    21 Preprocessor1_Model13
final_tree_workflow <- tree_workflow %>% 
                       finalize_workflow(best_tree)
tree_wf_fit <- final_tree_workflow %>% 
               fit(data = loans_training)
tree_fit <- tree_wf_fit %>% 
            pull_workflow_fit()
tree_fit
## parsnip model object
## 
## n= 12066 
## 
## node), split, n, loss, yval, (yprob)
##       * denotes terminal node
## 
##   1) root 12066 6033 Yes (0.50000000 0.50000000)  
##     2) IntRate>=-0.9804406 10213 4647 Yes (0.54499168 0.45500832)  
##       4) InqLast6mths>=0.1342378 4817 1734 Yes (0.64002491 0.35997509)  
##         8) InqLast6mths< 0.7133176 719    0 Yes (1.00000000 0.00000000) *
##         9) InqLast6mths>=0.7133176 4098 1734 Yes (0.57686676 0.42313324)  
##          18) InqLast6mths>=0.7135026 3111 1031 Yes (0.66859531 0.33140469)  
##            36) InqLast6mths< 1.064022 440    0 Yes (1.00000000 0.00000000) *
##            37) InqLast6mths>=1.064022 2671 1031 Yes (0.61400225 0.38599775)  
##              74) InqLast6mths>=1.065665 1999  627 Yes (0.68634317 0.31365683)  
##               148) InqLast6mths< 1.306897 190    0 Yes (1.00000000 0.00000000) *
##               149) InqLast6mths>=1.306897 1809  627 Yes (0.65339967 0.34660033)  
##                 298) InqLast6mths>=1.30852 1389  379 Yes (0.72714183 0.27285817) *
##                 299) InqLast6mths< 1.30852 420  172 No (0.40952381 0.59047619) *
##              75) InqLast6mths< 1.065665 672  268 No (0.39880952 0.60119048)  
##               150) Purpose_debt_consolidation< 0.9769242 410  199 No (0.48536585 0.51463415)  
##                 300) Purpose_debt_consolidation>=0.002685557 36    0 Yes (1.00000000 0.00000000) *
##                 301) Purpose_debt_consolidation< 0.002685557 374  163 No (0.43582888 0.56417112) *
##               151) Purpose_debt_consolidation>=0.9769242 262   69 No (0.26335878 0.73664122) *
##          19) InqLast6mths< 0.7135026 987  284 No (0.28774063 0.71225937)  
##            38) Purpose_small_business>=0.007831624 93   46 Yes (0.50537634 0.49462366)  
##              76) Purpose_small_business< 0.9643843 28    0 Yes (1.00000000 0.00000000) *
##              77) Purpose_small_business>=0.9643843 65   19 No (0.29230769 0.70769231)  
##               154) Installment>=1.306697 13    4 Yes (0.69230769 0.30769231) *
##               155) Installment< 1.306697 52   10 No (0.19230769 0.80769231) *
##            39) Purpose_small_business< 0.007831624 894  237 No (0.26510067 0.73489933)  
##              78) Purpose_home_improvement>=0.004279068 95   43 No (0.45263158 0.54736842)  
##               156) Purpose_home_improvement< 0.9981908 24    0 Yes (1.00000000 0.00000000) *
##               157) Purpose_home_improvement>=0.9981908 71   19 No (0.26760563 0.73239437) *
##              79) Purpose_home_improvement< 0.004279068 799  194 No (0.24280350 0.75719650)  
##               158) RevolUtil>=1.522396 20    9 Yes (0.55000000 0.45000000) *
##               159) RevolUtil< 1.522396 779  183 No (0.23491656 0.76508344) *
##       5) InqLast6mths< 0.1342378 5396 2483 No (0.46015567 0.53984433)  
##        10) Purpose_small_business>=0.0004497517 509  153 Yes (0.69941061 0.30058939)  
##          20) Purpose_small_business< 0.9975684 196    0 Yes (1.00000000 0.00000000) *
##          21) Purpose_small_business>=0.9975684 313  153 Yes (0.51118211 0.48881789)  
##            42) RevolUtil>=-0.01579358 173   63 Yes (0.63583815 0.36416185)  
##              84) Delinq2yrs>=-0.2629004 28    3 Yes (0.89285714 0.10714286) *
##              85) Delinq2yrs< -0.2629004 145   60 Yes (0.58620690 0.41379310)  
##               170) RevolBal>=-0.3358881 129   47 Yes (0.63565891 0.36434109)  
##                 340) Installment>=-0.5737739 115   37 Yes (0.67826087 0.32173913) *
##                 341) Installment< -0.5737739 14    4 No (0.28571429 0.71428571) *
##               171) RevolBal< -0.3358881 16    3 No (0.18750000 0.81250000) *
##            43) RevolUtil< -0.01579358 140   50 No (0.35714286 0.64285714)  
##              86) IntRate>=1.173842 50   21 Yes (0.58000000 0.42000000)  
##               172) RevolBal>=-1.257691 41   13 Yes (0.68292683 0.31707317)  
##                 344) RevolUtil< -0.5994362 24    3 Yes (0.87500000 0.12500000) *
##                 345) RevolUtil>=-0.5994362 17    7 No (0.41176471 0.58823529) *
##               173) RevolBal< -1.257691 9    1 No (0.11111111 0.88888889) *
##              87) IntRate< 1.173842 90   21 No (0.23333333 0.76666667)  
##               174) Dti>=1.064773 9    3 Yes (0.66666667 0.33333333) *
##               175) Dti< 1.064773 81   15 No (0.18518519 0.81481481) *
##        11) Purpose_small_business< 0.0004497517 4887 2127 No (0.43523634 0.56476366)  
##          22) Purpose_credit_card< 0.9967459 4355 2006 No (0.46061998 0.53938002)  
##            44) Purpose_credit_card>=0.002016567 181    0 Yes (1.00000000 0.00000000) *
##            45) Purpose_credit_card< 0.002016567 4174 1825 No (0.43723047 0.56276953)  
##              90) IntRate>=0.01866522 2608 1249 No (0.47891104 0.52108896)  
##               180) IntRate< 0.1321677 125   25 Yes (0.80000000 0.20000000)  
##                 360) DaysWithCrLine>=-1.542667 110   13 Yes (0.88181818 0.11818182) *
##                 361) DaysWithCrLine< -1.542667 15    3 No (0.20000000 0.80000000) *
##               181) IntRate>=0.1321677 2483 1149 No (0.46274668 0.53725332) *
##              91) IntRate< 0.01866522 1566  576 No (0.36781609 0.63218391)  
##               182) IntRate< 0.00234916 1365  540 No (0.39560440 0.60439560)  
##                 364) IntRate>=-0.0979689 114   26 Yes (0.77192982 0.22807018) *
##                 365) IntRate< -0.0979689 1251  452 No (0.36131095 0.63868905) *
##               183) IntRate>=0.00234916 201   36 No (0.17910448 0.82089552) *
##          23) Purpose_credit_card>=0.9967459 532  121 No (0.22744361 0.77255639)  
##            46) InqLast6mths>=-1.119349 207   67 No (0.32367150 0.67632850)  
##              92) InqLast6mths< 0.0753553 14    0 Yes (1.00000000 0.00000000) *
##              93) InqLast6mths>=0.0753553 193   53 No (0.27461140 0.72538860)  
##               186) LogAnnualInc< 0.08348885 98   38 No (0.38775510 0.61224490)  
##                 372) DaysWithCrLine>=0.2913098 29    9 Yes (0.68965517 0.31034483) *
##                 373) DaysWithCrLine< 0.2913098 69   18 No (0.26086957 0.73913043) *
##               187) LogAnnualInc>=0.08348885 95   15 No (0.15789474 0.84210526) *
##            47) InqLast6mths< -1.119349 325   54 No (0.16615385 0.83384615) *
##     3) IntRate< -0.9804406 1853  467 No (0.25202375 0.74797625)  
##       6) IntRate>=-1.639956 1208  396 No (0.32781457 0.67218543)  
##        12) Purpose_credit_card< 0.9999332 1057  386 No (0.36518448 0.63481552)  
##          24) Purpose_credit_card>=0.004602653 45    0 Yes (1.00000000 0.00000000) *
##          25) Purpose_credit_card< 0.004602653 1012  341 No (0.33695652 0.66304348)  
##            50) IntRate< -1.401334 133   54 Yes (0.59398496 0.40601504)  
##             100) IntRate>=-1.484836 33    0 Yes (1.00000000 0.00000000) *
##             101) IntRate< -1.484836 100   46 No (0.46000000 0.54000000)  
##               202) IntRate< -1.510006 55   18 Yes (0.67272727 0.32727273)  
##                 404) IntRate>=-1.611343 23    0 Yes (1.00000000 0.00000000) *
##                 405) IntRate< -1.611343 32   14 No (0.43750000 0.56250000) *
##               203) IntRate>=-1.510006 45    9 No (0.20000000 0.80000000) *
##            51) IntRate>=-1.401334 879  262 No (0.29806598 0.70193402)  
##             102) RevolUtil>=-0.5252478 407  167 No (0.41031941 0.58968059)  
##               204) Purpose_debt_consolidation< 0.9808642 244  119 Yes (0.51229508 0.48770492)  
##                 408) Purpose_debt_consolidation>=0.005453275 25    0 Yes (1.00000000 0.00000000) *
##                 409) Purpose_debt_consolidation< 0.005453275 219  100 No (0.45662100 0.54337900) *
##               205) Purpose_debt_consolidation>=0.9808642 163   42 No (0.25766871 0.74233129)  
##                 410) RevolBal< -0.2840104 39   13 Yes (0.66666667 0.33333333) *
##                 411) RevolBal>=-0.2840104 124   16 No (0.12903226 0.87096774) *
##             103) RevolUtil< -0.5252478 472   95 No (0.20127119 0.79872881)  
##               206) InqLast6mths>=0.1694396 156   59 No (0.37820513 0.62179487)  
##                 412) Dti< -0.758733 85   33 Yes (0.61176471 0.38823529) *
##                 413) Dti>=-0.758733 71    7 No (0.09859155 0.90140845) *
##               207) InqLast6mths< 0.1694396 316   36 No (0.11392405 0.88607595) *
##        13) Purpose_credit_card>=0.9999332 151   10 No (0.06622517 0.93377483) *
##       7) IntRate< -1.639956 645   71 No (0.11007752 0.88992248)  
##        14) LogAnnualInc< -0.7976023 147   42 No (0.28571429 0.71428571)  
##          28) RevolBal< -1.879939 15    2 Yes (0.86666667 0.13333333) *
##          29) RevolBal>=-1.879939 132   29 No (0.21969697 0.78030303)  
##            58) IntRate>=-1.747644 58   22 No (0.37931034 0.62068966)  
##             116) IntRate< -1.643617 28    9 Yes (0.67857143 0.32142857)  
##               232) LogAnnualInc>=-1.346504 19    2 Yes (0.89473684 0.10526316) *
##               233) LogAnnualInc< -1.346504 9    2 No (0.22222222 0.77777778) *
##             117) IntRate>=-1.643617 30    3 No (0.10000000 0.90000000) *
##            59) IntRate< -1.747644 74    7 No (0.09459459 0.90540541) *
##        15) LogAnnualInc>=-0.7976023 498   29 No (0.05823293 0.94176707)  
##          30) Fico< 0.9780507 78   16 No (0.20512821 0.79487179)  
##            60) RevolBal< -0.6742385 16    7 No (0.43750000 0.56250000) *
##            61) RevolBal>=-0.6742385 62    9 No (0.14516129 0.85483871)  
##             122) Dti< -1.09594 7    3 Yes (0.57142857 0.42857143) *
##             123) Dti>=-1.09594 55    5 No (0.09090909 0.90909091) *
##          31) Fico>=0.9780507 420   13 No (0.03095238 0.96904762) *
vip(tree_fit)
 
rpart.plot(tree_fit$fit, roundint = FALSE)
## Warning: labs do not fit even at cex 0.15, there may be some overplotting
 
tree_last_fit <- final_tree_workflow %>% 
                 last_fit(loans_split)
tree_predictions <- tree_last_fit %>% 
  collect_predictions()
tree_predictions
## # A tibble: 2,396 × 7
##    id               .pred_Yes .pred_No  .row .pred_class NotFullyPaid .config   
##    <chr>                <dbl>    <dbl> <int> <fct>       <fct>        <chr>     
##  1 train/test split    0.0909    0.909     6 No          No           Preproces…
##  2 train/test split    0.114     0.886    13 No          No           Preproces…
##  3 train/test split    0.361     0.639    16 No          No           Preproces…
##  4 train/test split    0.463     0.537    17 No          No           Preproces…
##  5 train/test split    0.0310    0.969    21 No          No           Preproces…
##  6 train/test split    0.114     0.886    22 No          No           Preproces…
##  7 train/test split    0.457     0.543    26 No          No           Preproces…
##  8 train/test split    0.437     0.562    31 No          No           Preproces…
##  9 train/test split    0.690     0.310    32 Yes         No           Preproces…
## 10 train/test split    0.0310    0.969    33 No          No           Preproces…
## # … with 2,386 more rows
tree_predictions %>% 
  roc_curve(truth=NotFullyPaid,estimate=.pred_Yes)%>% 
  autoplot()
 
roc_auc_tree <- roc_auc(tree_predictions, truth = NotFullyPaid, .pred_Yes)

f1_tree <- f_meas(tree_predictions,truth=NotFullyPaid, estimate=.pred_class)

conf_mat(tree_predictions,truth=NotFullyPaid,estimate=.pred_class)
##           Truth
## Prediction  Yes   No
##        Yes   76  181
##        No   308 1831
3.3 Models Results and Comparasion
f1_compared <- rbind(f1_logistics, f1_knn, f1_tree)
model_name <- c("Logistics", "KNN", "Tree Decision")

f1_compared <- f1_compared %>% 
                    cbind(model_name)
f1_compared
##   .metric .estimator .estimate    model_name
## 1  f_meas     binary 0.3451327     Logistics
## 2  f_meas     binary 0.3378582           KNN
## 3  f_meas     binary 0.2371295 Tree Decision
knitr::kable(f1_compared, format = "markdown")
.metric	.estimator	.estimate	model_name
f_meas	binary	0.3451327	Logistics
f_meas	binary	0.3378582	KNN
f_meas	binary	0.2371295	Tree Decision
roc_auc_compared <- rbind(roc_auc_logistics, roc_auc_knn, roc_auc_tree)
model_name <- c("Logistics", "KNN", "Tree Decision")

roc_auc_compared <- roc_auc_compared %>% 
                    cbind(model_name)
roc_auc_compared
##   .metric .estimator .estimate    model_name
## 1 roc_auc     binary 0.6809016     Logistics
## 2 roc_auc     binary 0.6530090           KNN
## 3 roc_auc     binary 0.6279886 Tree Decision
knitr::kable(roc_auc_compared, format = "markdown")
.metric	.estimator	.estimate	model_name
roc_auc	binary	0.6809016	Logistics
roc_auc	binary	0.6530090	KNN
roc_auc	binary	0.6279886	Tree Decision


— End of the Project —
