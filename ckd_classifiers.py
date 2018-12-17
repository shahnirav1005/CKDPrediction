import numpy as np
import pandas as pd
import time 

from sklearn.model_selection import cross_val_score, GridSearchCV, cross_validate, train_test_split as tts
from sklearn.metrics import accuracy_score, classification_report
from sklearn.svm import LinearSVC
from sklearn.svm import SVC
from sklearn.linear_model import LinearRegression
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier

data = pd.read_csv('CKD_UCI_Data/CKD.csv')

x_data = data.loc[:, data.columns != "y"]
y_data = data.loc[:, "y"]
random_state = 100

x_train, x_test, y_train, y_test = tts(x_data, y_data, test_size=0.3, shuffle = True, random_state = 100)
#print x_test
#print len(y_test), len(y_train)
#print y_test.dtype

# TODO: Create a LinearRegression classifier and train it.
lr = LinearRegression()
lr.fit(x_train, y_train)

lr_predictions_ytest = lr.predict(x_test).round()
lr_predictions_ytrain = lr.predict(x_train).round()

#print lr_predictions_y
#print lr_predictions_y.astype(int)
#print y_test, lr_predictions_y
lr_accuracy_ytest = accuracy_score(y_test, lr_predictions_ytest)
lr_accuracy_ytrain = accuracy_score(y_train, lr_predictions_ytrain)
print "LR Test: ", lr_accuracy_ytest, "LR Training: ", lr_accuracy_ytrain


# TODO: Create an MLPClassifier and train it.
mlp = MLPClassifier()
mlp.fit(x_train, y_train)

mlp_predictions_ytest = mlp.predict(x_test)
mlp_predictions_ytrain = mlp.predict(x_train)
mlp_accuracy_ytest = accuracy_score(y_test, mlp_predictions_ytest)
mlp_accuracy_ytrain = accuracy_score(y_train, mlp_predictions_ytrain)
print "MLP Test: ", mlp_accuracy_ytest, "MLP Training: ", mlp_accuracy_ytrain

#Random Forest Classifier
rfc = RandomForestClassifier()
rfc.fit(x_train, y_train)

rfc_predictions_ytest = rfc.predict(x_test)
rfc_predictions_ytrain = rfc.predict(x_train)
rfc_accuracy_ytest = accuracy_score(y_test, rfc_predictions_ytest)
rfc_accuracy_ytrain = accuracy_score(y_train, rfc_predictions_ytrain)
print "RF Test: ", rfc_accuracy_ytest, "RF Training: ", rfc_accuracy_ytrain

#Tuning hyperparameters for Random Forest
rfcCV = RandomForestClassifier()
rfc_params = {'n_estimators':(5,10,50,300), 'max_depth':(5,10,20,50)}
clfCV = GridSearchCV(rfcCV, rfc_params)
clfCV.fit(x_train, y_train)
print clfCV.best_params_

rfcbest = RandomForestClassifier(n_estimators=300,max_depth=50)
rfcbest.fit(x_train, y_train)
rfcbest_predictions = rfcbest.predict(x_test)
print 'Accuracy Score RFC Best Predictions', accuracy_score(y_test, rfcbest_predictions)

#SVM
svc = SVC()
linsvc=LinearSVC()
svc.fit(x_train, y_train)
linsvc.fit(x_train,y_train)

svc_predictions_ytest = svc.predict(x_test)
svc_predictions_ytrain = svc.predict(x_train)
svc_predictions_ytestlin = linsvc.predict(x_test)
svc_predictions_ytrainlin = linsvc.predict(x_train)
svc_accuracy_ytest = accuracy_score(y_test, svc_predictions_ytest)
svc_accuracy_ytrain = accuracy_score(y_train, svc_predictions_ytrain)
svc_accuracy_ytestlin = accuracy_score(y_test, svc_predictions_ytestlin)
svc_accuracy_ytrainlin = accuracy_score(y_train, svc_predictions_ytrainlin)

print "SVC Test: ", svc_accuracy_ytest, "SVC Training: ", svc_accuracy_ytrain
print "LinSVC Test: ", svc_accuracy_ytestlin, "LinSVCTraining ", svc_accuracy_ytrainlin

#Tuning hyperparameters
svcCV = SVC()
svcCV_params = {'C':(0.001, 0.1, 1, 100, 500)}
svcCV = GridSearchCV(svcCV, svcCV_params, return_train_score = True)
svcCV.fit(x_train, y_train)
print "Best Parameters Chosen", svcCV.best_params_
