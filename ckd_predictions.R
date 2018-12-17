#Pre-downloaded data from UCI repository
#URL - https://archive.ics.uci.edu/ml/datasets/chronic_kidney_disease#

#Model to get all values
aNA=read.table('./CKD_UCI_Data/CKD.csv',sep=',',dec='.',na.strings='?')

names(aNA)=c('age','bp','sg','al','su','rbc','pc','pcc','ba','bgr','bu','sc','sod','pot','hemo','pcv','wc','rc','hnt','dm','cad','appet','pe','ane','class')

for (i in 3:5) {
  aNA[,i]=as.ordered(aNA[,i])
}

for (i in c(6:9,19:25)){
  aNA[,i]=as.factor(aNA[,i])
}

aNA.class=matrix(0)
for (i in 1:25){
  aNA.class[i]=class(aNA[,i])
}
aNA.class

num_aNA=matrix(0)
for (i in 1:24){
  num_aNA[i]=sum(is.na(aNA[,i]))
}
num_aNA

barplot(num_aNA,xlab="24 Variables",ylab="Number of Missing values",names.arg =c('age','bp','sg','al','su','rbc','pc','pcc','ba','bgr','bu','sc','sod','pot','hemo','pcv','wc','rc','hnt','dm','cad','appet','pe','ane'))

library(VIM)
aggr_plot=aggr(aNA, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.3, gap=2, ylab=c("Histogram of missing data","Pattern"))

# Impute with Amelia
nominal = c('rbc','pc','pcc','ba','hnt','dm','cad','appet','pe','ane','class')
ordinal = c('sg','al','su')
library(Amelia)
aAmelia=amelia(aNA, m = 5 , noms = nominal, ords = ordinal)
a1=aAmelia$imputations[[1]]
a2=aAmelia$imputations[[2]]
a3=aAmelia$imputations[[3]]
a4=aAmelia$imputations[[4]]
a5=aAmelia$imputations[[5]]

# Delete Indivisuals with NA
aNA=data.frame(aNA)
a=na.omit(aNA)
names(a)=c('age','bp','sg','al','su','rbc','pc','pcc','ba','bgr','bu','sc','sod','pot','hemo','pcv','wc','rc','hnt','dm','cad','appet','pe','ane','class')
head(a)
dim(a)


nam=c('Age','Blood Pressure','specific gravity','Albumin','Sugar','Red Blood Cells','Pus Cell','Pus Cell Clumps','Bacteria','Blood Glucose Random','Blood Urea','Serum Creatinine','Sodium','Potassium','Hemoglobin','Packed Cell Volume','White Blood Cell Count','Red Blood Cell Count','Hypertension','Diabetes Mellitus','Coronary Artery Disease','Appetite','Pedal Edema','Anemia','CKD')
par(mfrow=c(3,4))
for (i in c(1,2,10:18)){
  plot(a[,25],a[,i])
  title(nam[i])
}

library(vcd)
par(mfrow=c(1,1))
for (i in c(3:9,19:24)){
  x1=xtabs(~class+a[,i],data=a)
  mosaic(x1,shade=TRUE, legend=TRUE) 
} 

########

x1=xtabs(~class+sg,data=a); mosaic(x1,shade=TRUE, legend=TRUE)
x2=xtabs(~class+al,data=a); mosaic(x2,shade=TRUE, legend=TRUE)
x3=xtabs(~class+su,data=a); mosaic(x3,shade=TRUE, legend=TRUE)
x4=xtabs(~class+rbc,data=a); mosaic(x4,shade=TRUE, legend=TRUE)
x5=xtabs(~class+pc,data=a); mosaic(x5,shade=TRUE, legend=TRUE)
x6=xtabs(~class+pcc,data=a); mosaic(x6,shade=TRUE, legend=TRUE)
x7=xtabs(~class+ba,data=a); mosaic(x7,shade=TRUE, legend=TRUE)
x8=xtabs(~class+hnt,data=a); mosaic(x8,shade=TRUE, legend=TRUE)
x9=xtabs(~class+dm,data=a); mosaic(x9,shade=TRUE, legend=TRUE)
x10=xtabs(~class+cad,data=a); mosaic(x10,shade=TRUE, legend=TRUE)
x11=xtabs(~class+appet,data=a); mosaic(x11,shade=TRUE, legend=TRUE)
x12=xtabs(~class+pe,data=a); mosaic(x12,shade=TRUE, legend=TRUE)
x13=xtabs(~class+ane,data=a); mosaic(x13,shade=TRUE, legend=TRUE)

########
## Check correlation for numeric variables

# GLM for class

# GLM for all the 24 numerical and nominal
# Algorithm does not converge, the variables could be correlated to each other.
model0=glm(factor(class)~.*.,data=a,family='binomial')
summary(model0)

#Trying a few factors to check if model converges
model1=glm(factor(class)~age+bp+sg+rbc+pc+pcc+ba+bgr+bu+sc+sod+pot+hemo+pcv+wc+rc+hnt+dm+cad+appet+pe+ane,data=a,family='binomial')
summary(model1)
aa=step(model1)
summary(aa)

# GLM for just 11 numerical   # algorithm did not converge
x=cbind(a[,1:2],a[,10:18])
y=as.numeric(a[,25])
y[44:158]=0
b=data.frame(x,y)   # all numerical predictors and Binery response

model2=glm(y~.,family='binomial',data=b)
summary(model2)

# GLM for 6 low correlated numerical  # WORKED
corrplot(cor(a[,c(1,2,10,13,14,17)]),method='square')
model3=glm(factor(y)~age+bp+bgr+sod+pot+wc,family='binomial',data=b)
summary(model3)
summary(model3)$aic
exp.coeff=round(model3$coefficients,3)

p=model3$fitted.values
pred=rep(0,158)
pred[p>0.5]=1
table(y,pred)

library(ResourceSelection)
y=as.numeric(a[,25])
y[44:158]=0
hoslem.test(y,fitted(model3),g=10)

model4=step(model3,direction='both')
summary(model4)
summary(model4)$aic
exp.coeff=round(model4$coefficients,3)

library(ResourceSelection)
y=as.numeric(a[,25])
y[44:158]=0
hoslem.test(y,fitted(model4),g=10)

p=model4$fitted.values
pred=rep(0,158)
pred[p>0.5]=1
table(y,pred)

# GLM with predictors in Practice  # WORKED
cor(b$age,b$sc)
model5=glm(factor(y)~age+sc,family='binomial',data=b)
summary(model5)
summary(model5)$aic
exp.coeff=round(model4$coefficients,3)

library(ResourceSelection)
y=as.numeric(a[,25])
y[44:158]=0
hoslem.test(y,fitted(model5),g=10)

p=model5$fitted.values
pred=rep(0,158)
pred[p>0.5]=1
table(y,pred)

# Lasso model selection for Numerical
x=as.matrix(cbind(a[,1:2],a[,10:18]))
y=as.numeric(a[,25])
y[44:158]=0

library(lars)
model6=lars(x,y)
par(mfrow=c(1,2))
plot(model6)
plot.lars(model6,xvar = 'df'  ,plottype = 'Cp')
abline(0,1,col='red')
model6$Cp

# GLM with 11 pred from Lasso     # algorithm did not converge

model7=glm(factor(y)~hemo+pcv+bgr+sod+rc+sc+wc+age+bu+bp,family='binomial',data=b)
model8=glm(factor(y)~hemo+pcv+bgr+sod+rc+sc+wc,family='binomial',data=b)

# The model does not converge, not even with the first 2 var
# They cause perfect separation and highly correlated as well


# GLMnet just for Numerical
x=as.matrix(a[,c(1,2,10:18)])
y=as.numeric(a[,25])
y[44:158]=0
y=factor(y)

# 10-fold CV to find the optimal lambda
library(glmnet)
MCV1=cv.glmnet(x,y,family=c("binomial"),alpha=0.5,type="class",nfolds=10)
MCV1$lambda.min
MCV1$cvm[which(MCV1$lambda==MCV1$lambda.min)]

Ml1=glmnet(x, y,family=c("binomial"), alpha = 0.5, nlambda = 100)
# model's attribute for optimal lambda
(Ml1_dev_ratio=Ml1$dev.ratio[which(Ml1$lambda==MCV1$lambda.min)])
(Ml1_null_dev=Ml1$nulldev)
(Ml1_dev_opt=Ml1_dev_ratio*Ml1_null_dev)

pred=predict(Ml1,x,s=MCV1$lambda.min,type=('class'))
(tpred=table(y,pred))
(accuracy=(tpred[1,1]+tpred[2,2])/sum(sum(tpred)))

Coeff1=Ml1$beta[,which(MCV1$lambda==MCV1$lambda.min)]
round(Coeff1,4)

plot(Ml1,xvar="lambda")
abline(v=log(MCV1$lambda.min),col='black',lty = 2)
log(MCV1$lambda.min)


model9=glm(factor(y)~hemo+rc+sod,family='binomial',data=b)
summary(model9)

library(ResourceSelection)
y=as.numeric(a[,25])
y[44:158]=0
hoslem.test(y,fitted(model9),g=10)

# GLMnet with all nominal+numerical
# After ommiting NAs

a.num=read.table('./CKD_UCI_Data/CKD.csv',sep=',',dec='.',na.strings='?')
a.num=na.omit(a.num)
names(a.num)=c('age','bp','sg','al','su','rbc','pc','pcc','ba','bgr','bu','sc','sod','pot','hemo','pcv','wc','rc','hnt','dm','cad','appet','pe','ane','class')

for (j in c(1:25)){
  a.num[,j]=as.numeric(a.num[,j])
}

for (j in c(6,7,8,9,19:25)){
  a.num[which(a.num[,j]==2),j]=0
}

a.class=matrix(0)
for (i in 1:25){
  a.class[i]=class(a.num[,i])
}
a.class

x2=as.matrix(a.num[,c(1:24)])
y=as.factor(a.num[,25])

# 'glmnet', 'yaml', 'cv.glmnet' package required
# 10-fold CV to find the optimal lambda
MCV2=cv.glmnet(x2,y,family=c("binomial"),alpha=0.5,type="class",nfolds=10)
MCV2$lambda.min
MCV2$cvm[which(MCV2$lambda==MCV2$lambda.min)]

Ml2=glmnet(x2, y,family=c("binomial"), alpha = 0.5, nlambda = 100)
# model's attribute for optimal lambda
(Ml2_dev_ratio=Ml2$dev.ratio[which(Ml2$lambda==MCV2$lambda.min)])
(Ml2_null_dev=Ml2$nulldev)
(Ml2_dev_opt=Ml2_dev_ratio*Ml2_null_dev)

pred2=predict(Ml2,x2,s=MCV2$lambda.min,type=('class'))
(tpred2=table(y,pred2))
(accuracy2=(tpred2[1,1]+tpred2[2,2])/sum(sum(tpred2)))

Coeff2=Ml2$beta[,which(MCV2$lambda==MCV2$lambda.min)]
round(Coeff2,4)

plot(Ml2,xvar="lambda")
abline(v=log(MCV2$lambda.min),col='black',lty = 2)
log(MCV2$lambda.min)

# algorithm did not converge for any of these
model10=glm(factor(y)~rbc+hnt,family='binomial',data=a)
summary(model10)


# Multinomial
which(a[which(a[,25]=='ckd'),4]==0)  #[1] 8

data=a[c(1:7,9:158),]
table(data[,4],data[,25])
data[,4]=factor(data[,4])
table(data[,4],data[,25])

library(nnet)
mod=multinom(al~.-class -su,data=data)  # all except sugare and class
summary(mod)
z=summary(mod)$coefficients/summary(mod)$standard.errors
p=(1-pnorm(abs(z),0,1))*2
round(p,4)

aa=glm(class~al,a,family = 'binomial')


