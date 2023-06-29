# Risk Analysis Project – LendingClub.com

## Project Introduction: Loan Repayment
<p align="center">
  <img src="https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/d541d9fc-95b2-4a28-a7cf-14eb8f7fc778" alt="Lending">
</p>

In the lending industry, investors provide loans to borrowers in exchange for the promise of repayment with interest. If the borrower repays the loan, the lender profits from the interest. However, if the borrower is unable to repay the loan, then the lender loses money. Therefore, lenders would like to minimize the risk of a borrower being unable to repay a loan.
 
 <br /> This analysis aims to analyze, predict, and present the characteristics posed by borrowers who are more likely to be unable to repay the loan, thereby enabling the company to avoid engaging in high-risk leasing and financial contract with these customers. In addition, this report provides machine learning models assisting the company in classifying the factors more likely to contribute to the repaid loan. 

 <br /> Six different factors will be applied in the analysis, including credit score (fico), purpose of the loan (Purpose), interest rate(IntRate), montly installments(Installment), the debt-to-income ratio of the borrower(Dti), Public record(PubRec). And three other ML classification models also will be used, including Logistic model, LDA and Tree decision. 

## Objective 
#### • What factors contribute to loans not being fully paid based on exploratory analysis? 
#### • Build classification models, assess their performance, identify the variables most important in determining whether the loans will be fully paid up based on models, and choose the best model based on the performance metrics
#### • Based on insights from data mining, providing solutions for the lending.club to limit loan default.


## Data
There are 9,578 observations, each representing a 3-year loan that was funded through the Lendingclub.com platform from past data. There are 14 variables in the dataset, described in the Table below.

<p align="center">
  <img src="https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/28cd6fb3-2c87-44cd-a377-936b9ab192d2" alt="Lending-DatasetAttributes">
</p>

## 1. Exploratory Data Analysis (6 relevant questions)

#### Table 1:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/4a568412-6ab1-4c7e-a49d-c68bb165edad)
#### Table 2:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/f7c98dea-5ee0-4e1d-a7d1-9c4359ea4605)
#### Table 3:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/dff20c71-619a-4974-93da-e22f3f1f8b62)
#### Figure 1:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/1a1f354b-848d-4304-8b1c-013a52a3e613)
#### Figure 2:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/73d05b41-7593-4c3f-af9d-eb4cfe133107)
#### Figure 3:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/71ef4229-bc8b-416f-b0d3-e1a05b6680b9)

#### Table 4: 
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/0de794b2-ca56-4012-b209-cabb03f5647d)
#### Figure 4:
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/1b03d3ad-0745-4c1a-9540-adfd2311e8f5)
