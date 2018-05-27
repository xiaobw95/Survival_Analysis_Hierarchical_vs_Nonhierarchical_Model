#input
KidneyData <- read.csv("./data/KidneyData.txt", sep="", stringsAsFactors=FALSE)

#data preprocessing
group<-as.factor(as.integer(interaction(KidneyData$sex,  KidneyData$race)))
KidneyData<-cbind(KidneyData,group)

#data visualization
library(survival)
library(survminer)
surv_object <- Surv(KidneyData$time,KidneyData$delta)
model<-survfit(surv_object~sex+race,data=KidneyData)
ggsurvplot(model, data = KidneyData, pval = TRUE)

#data preparation for stan models
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

#stan models
library(rstan)
m1<-stan('./stan/Kidney_nonhierarchical.stan',data=data1)
check_hmc_diagnostics(m1)
m2<-stan('./stan/Kidney_hierarchical.stan',data=data2)
check_hmc_diagnostics(m2)
m3<-stan('./stan/Kidney_hierarchical1.stan',data=data2)
check_hmc_diagnostics(m3)

#LOO-PSIS
library(loo)
log_lik1<-extract_log_lik(m1)
loo1<-loo(log_lik1)
log_lik2<-extract_log_lik(m2)
loo2<-loo(log_lik2)
log_lik3<-extract_log_lik(m3)
loo3<-loo(log_lik3)
compare(loo1,loo2,loo3)
