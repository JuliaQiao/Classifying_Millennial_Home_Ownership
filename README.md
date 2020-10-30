# Classifying Millenial Home Owners

## Objective:

Build a supervised classification model to interpret factors contributing to millennial home ownership. 

## Data Sources:

[U.S. Bureau of Labor Statistics National Longitutional Survey ('97)](https://www.bls.gov/nls/nlsy97.htm) 

"The NLSY97 consists of a nationally representative sample of 8,984 men and women born during the years 1980 through 1984 and living in the United States at the time of the initial survey in 1997. Participants were ages 12 to 16 as of December 31, 1996. Interviews were conducted annually from 1997 to 2011 and biennially since then. The ongoing cohort has been surveyed 18 times as of date. Data are available from Round 1 (1997-98) through Round 18 (2017-18)."



## Approach: 

Extracted 26 variables from Rounds 14-18 of the NLSY97 data in order to provide a snapshot of subjects at age 30. Defined "homeowners" as those who owned their primary residences with permanent addresses (excluding mobile homes) and didn't include farms/ranches for binary classification. Homeowners were outnumbered 2:1 in the data, leading to imbalanced class sizes. NLSY07 variables were decoded via SAS, data was uploaded to Postgres, initial EDA was performed through SQL, then further cleaning, imputation, feature engineering were performed Pandas and Numpy. Classification models were built through SKlearn. Types of models tested included Random Forest, XGboost, KNN, and Logistic Regression (Naive Bayes was not considered due to the difficulty in establishing the initial assumption of feature probability independence with demographic data). Cross validation, oversampling via RandomSampler, regularization via Ridge and LASSO, and parameter tunning were all used to optimize for recall, AUC, and precision (in that order). The focus on recall is due to the fact that for any outreach/marketing purposes, spend is usually adjustable and casting a wider net is key, so the opportunity cost of leaving out a millenial who is a homeowner (false negative) is greater than reaching a millenial who is not currently a homeowner (false positive). 

## Results:

The final model was a logistic regression model with LASSO regularization (increased strength of C= 0.4) and balanced class weights. When applied to the test holdout set, it generated a recall of 0.73, AUC of 0.78, precision of 0.53.  False negatives were successfully minimized and recall was maximized, while still keeping precision above 0.5. The most highly correlated positive features (in order of significance) were marriage, financial assets at age 30, highest educational level being a Bachelor's degree, then Master's degree, total income, and ownership of subject's childhood home. Negatively correlated features included relocations since age 12 (the most significant feature in our model), and being a racial/ethnic minority--Black, Hispanic, and mixed race subjects in order of significance (the study only included these categories for racial/ethnic minorities). Interestingly, all education levels, from high school to medical/law degrees had positive correlations with home ownership, with the exception of PhD degrees. This may be partially due to most PhD students still finishing their programs at age 30 and thus not in positiions to invest in permanent homes. Only half the subjects in NLSY97 had turned 35 by the time of the last question round in 2017/18, but next steps include coming back to run the model again once all subjects are surveyed at age 35, as well as  incorporating additional data on more nuanced racial/ethnic minority subjects where possible.



