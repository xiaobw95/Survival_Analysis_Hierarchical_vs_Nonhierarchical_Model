KidneyData <- read.csv("./data/KidneyData.txt", sep="", stringsAsFactors=FALSE)

group<-as.factor(as.integer(interaction(KidneyData$sex,  KidneyData$race)))
KidneyData<-cbind(KidneyData,group)

library(survival)
library(survminer)
surv_object <- Surv(KidneyData$time,KidneyData$delta)
model<-survfit(surv_object~sex+race,data=KidneyData)
ggsurvplot(model, data = KidneyData, pval = TRUE)

N_uc<-nrow(KidneyData[KidneyData$delta==1,])
N_rc<-nrow(KidneyData[KidneyData$delta==0,])
t_uc<-KidneyData[KidneyData$delta==1,]$time
t_rc<-KidneyData[KidneyData$delta==0,]$time
sex_uc<-KidneyData[KidneyData$delta==1,]$sex
sex_rc<-KidneyData[KidneyData$delta==0,]$sex
age_uc<-KidneyData[KidneyData$delta==1,]$age
age_rc<-KidneyData[KidneyData$delta==0,]$age
race_uc<-KidneyData[KidneyData$delta==1,]$race
race_rc<-KidneyData[KidneyData$delta==0,]$race
group_uc<-as.integer(KidneyData[KidneyData$delta==1,]$group)
group_rc<-as.integer(KidneyData[KidneyData$delta==0,]$group)
N_group<-4

data1<-list(N_uc,N_rc,t_uc,t_rc,sex_uc,sex_rc,age_uc,age_rc,race_uc,race_rc)
data2<-list(N_uc,N_rc,t_uc,t_rc,group_uc,group_rc,age_uc,age_rc,N_group)

library(rstan)
model1<-stan('./stan/Kidney_nonhierarchical.stan',data=data1)
check_hmc_diagnostics(model1)
model2<-stan('./stan/Kidney_hierarchical.stan',data=data2)
check_hmc_diagnostics(model2)

library(loo)
log_lik1<-extract_log_lik(model1)
loo1<-loo(log_lik1)
log_lik2<-extract_log_lik(model2)
loo2<-loo(log_lik2)
compare(loo1,loo2)


