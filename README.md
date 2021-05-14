# shiny project

Last year and in this semester, I have worked on one finished Kaggle competition called Zillow Prize: Zillow’s Home Value Prediction (Zestimate)

The kaggle competition website is here:
https://www.kaggle.com/c/zillow-prize-1/overview

The mean idea of this competition is that zillow have their own machine learning model to predict the housing price with different features, 
in this project, we want to predict the error between the model prediction and real prices. This is the similar as gradient boost. This will significantly increase the accuracy of the models.

Here is the old version of my project: http://zestimate-prediction.herokuapp.com/

There are 2 problems of this data: there are lots of missing values in different features (showing in missing values detection section) and there are too many features with very low correlation from the targets and high correlation between each others. To solve these problems, I tried to use KNN (k-nearest neighborhood) to fill the missing values since there are detailed location information and theoritically the houses near each other (in same block) should share similar properties; and I use several way to select the features (stepwise feature selection) and use gradient based decision tree based model (GBDT) to predict.

One of the concern of this project is whether the missing values filling is meaningful or worked. In Using k-nearest neighbors to fill geographic features missing value section, the left one is before filling, the right one is after filling, it is easy to get the conclusion that roughly, the missing value filling works. But if I want to see the detailed filling results, it is very hard to make any conclusion. Therefore, I used shiny app to build a detailed visualization of fillings. In the figure, the missing value filled data point is marked by the black circles and the values is the color of the filled inside. Using this app, I can get a better visualization of how good each individual data filling is.