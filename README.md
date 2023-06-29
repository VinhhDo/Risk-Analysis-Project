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

## Exploratory Data Analysis (6 relevant questions)

### Question 1 Is there a relationship between the customer’s repay record and the public record? Do people with more public record tend to unable pay full installment?

#### Methods

The method used in the study was a table summary of the number of public records (counts) and the full payment record to show numeric values. Hence, we can analysis relying on the numeric values

#### Analysis

In summary, the borrower who did not pay fully installment and interest is more likely to have a public record compared to borrower who has paid fully. The table show the difference between them is close to 5%. For the ’fully payment” borrower, the rate to have a public record is only 4%. On the other hand, the chance of having the public record for “No fully paid” borrower is 9%. In consequence, the public record have a negative impact on the installment paying of the borrower. People with no public record will more likely to pay the installment fully.

![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/4a568412-6ab1-4c7e-a49d-c68bb165edad)

### Question 2 Is there a relationship between The debt-to-income rate of borrower and the chance of fully repay?

#### Methods

The method used is a table summary of the number (counts) and percentage of debt to income ration on fully payment record.

#### Analysis

Table shows that people who did not pay the loan in full have higher Deb-to-Income rating. 85% of “Not fully repayment” consumer have the Deb-to-Income above 10%. In contrast, people who have paid the loans in full have 5% higher chance in having Deb-to-ratio below 5.
![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/f7c98dea-5ee0-4e1d-a7d1-9c4359ea4605)


### Question 3 Does the purpose of loans affect the full repayment?

#### Methods

To visualize and analyze this question, both the summary table and visualizing plot were used to compare variables. And, the bar column is a great option to indicate the difference in distribution. Also, the color will be another method to contrast the main difference between fully repayment and not fully repayment factors.

#### Analysis
There are seven variables from “Purpose” variables across full repayment and not fully repayment factors. Based on the figure, the two columns represent the difference between two factors in “small business” and “credit card” purposes. The “small business” purpose have a higher chance to unable to pay the loan in full. According to the summary table, the borrower who has to apply the loans for small business purposes will have about 12% unable to pay the loans. In contrast, only 5% of people who usually pay the loan in full will borrow money for business purposes. In addition, customers who pay the loan in full usually apply the loan for a credit card compared to the “not fully paid” customers. The different percentage is approximately 5%. Based on the analysis, there is a relationship between the purpose of loans and the full repayment. The purpose can be used by the company to consider as a factor in deciding to lend a loan to the customer.

![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/dff20c71-619a-4974-93da-e22f3f1f8b62)

![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/1a1f354b-848d-4304-8b1c-013a52a3e613)

### Question 4 Does borrower who did not pay instament fully more likely to have a high interest rate?

#### Methods

A density was used to show the different distributions of data. In the density, we can easily see the common in the data range and the outliner between interest rate of “fully repaid” customers and “not fully repaid”

#### Analysis
In the graph, the range of the “fully repay” outliner is lean to the left side of the plot. In contrast, the range of “not fully repay” is wider and lean to the right side, which means that they are more likely to have a higher interest. Moreover, the peak of “not fully payment” interest rate is approximately 15, and the “fully payment” is around 12. Finally, the plot demonstrates the relationship between “not fully repay” interest and “fully_repay” interest by the distribution spread. The higher interest rate correlates to a higher chance of being unable to repay full installment.

![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/73d05b41-7593-4c3f-af9d-eb4cfe133107)





### Question 5 Is there a relationship between Fico rating (credit rating scores) and the repayment outcome?

#### Methods

The method used Is a box plot visualization representing the spread of data, the standard deviation, and the median fico. There are two boxes. The “Fully Paid” spread is shown on the left side and has a green colour, and the “Not Fully Payment” status spread is on the other side with red colour.

#### Analysis

The figure illustrates different contributions with Fully paid and Not Fully paid status based on Fico credit ratings. The interquartile range is higher for fully paid observations that start at 685 and end around 740. Compared to not fully repayment observations, it begins at about 670 and ends at 710. Moreover, the average fully paid observation is 705 scores which is higher than not fully paid observations 15-20. Based on the analysis, repayment status is significantly impacted by Fico rating score. A higher fico rating can tell that a person pay all their loan timely and fully. Thus, the plot represents the better Fico rating is as, the better chance of the customer pay the loan entirely.

![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/71ef4229-bc8b-416f-b0d3-e1a05b6680b9)

### Question 6 Do high monthly installments have a lower chance of paying loans fully?

#### Methods

A bar plot with a full-fill position will be used to allow the comparison of two repayment statuses to be more efficient to allow us to see the trend more clearly.

#### Analysis
The bar chart visualization (figure ) shows a clear negative relationship between repayment and the installment rate. The entire repayment steadily decreases as the installment rises. Throughout the figure, monthly installments are below 200, and there is more likely the customer repay their loans in full. The difference between “Under 200” and “600 and above” is around 10%-20%. So, there is a 10% higher for the company to get the repayment from customers by funding the loans with monthly installments below $200. The analysis shows a strong correlation between repayment and the monthly installment. The lower the installment is, the higher the chance of a customer paying back the loans in full.



![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/0de794b2-ca56-4012-b209-cabb03f5647d)



![image](https://github.com/VinhhDo/Risk-Analysis-Project/assets/98499217/1b03d3ad-0745-4c1a-9540-adfd2311e8f5)

## Recommendations & Solutions

### In order to identify a “fully repayment” customer and avoid risks associated with “Not fully repay” customer, the following factors must be considered as the company’s strategy.

 <br /> •	To limit transactions involving “Not Fully Repayment”, the company must target customers with Fewer Public Record . People without public record in financial such as bankruptcy, filings, tax liens, or judgments will be much higher chance to pay the loan back in full.
 
 <br /> •	The Debt-To-Income is another factor to consider. Customers with fully repayment often have the debt to income ratio (DTI) below 15% which means that the monthly installment less than 15% of their salary.
 
 <br /> •	Higher-interest rate have a higher chance of accumulating “Not Fully Repayment”. the company should be careful to engage in all leasing with interest rate above 15%.
 
 <br /> •	Moreover, the Fico scores of “fully repayment” customer starts from 685 to 740. As the result, People with high Fico scores will be safer when providing the loan. Additionally, the company need to avoid people who have Fico score less than 650.



### Thank you to all who have taken the time to view my project. Your support and interest are truly appreciated.
                                                — End of the Project —
