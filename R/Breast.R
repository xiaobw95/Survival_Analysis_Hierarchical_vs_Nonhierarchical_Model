#input
data_clinical_patient <- read.delim("./data/data_clinical_patient.txt", comment.char="#")
breast<-data.frame(time=data_clinical_patient$OS_MONTHS,
                   delta=as.integer(data_clinical_patient$OS_STATUS),
                   age=data_clinical_patient$AGE_AT_DIAGNOSIS,
                   npi=data_clinical_patient$NPI,
                   chem=as.integer(data_clinical_patient$CHEMOTHERAPY),
                   horm=as.integer(data_clinical_patient$HORMONE_THERAPY),
                   radio=as.integer(data_clinical_patient$RADIO_THERAPY),
                   claudin=as.integer(data_clinical_patient$CLAUDIN_SUBTYPE))
breast<-breast[complete.cases(breast),]
breast$delta<-abs(breast$delta-3)
breast$chem<-breast$chem-2
breast$horm<-breast$horm-2
breast$radio<-breast$radio-2
breast$claudin<-breast$claudin-1

#data visualization
library(survival)
library(survminer)
surv_object <- Surv(breast$time,breast$delta)
model<-survfit(surv_object~claudin,data=breast)
ggsurvplot(model, data = breast, pval = TRUE)

#data preparation for stan models
N_uc<-nrow(breast[breast$delta==1,])
N_rc<-nrow(breast[breast$delta==0,])
t_uc<-breast[breast$delta==1,]$time
t_rc<-breast[breast$delta==0,]$time
chem_uc<-breast[breast$delta==1,]$chem
chem_rc<-breast[breast$delta==0,]$chem
horm_uc<-breast[breast$delta==1,]$horm
horm_rc<-breast[breast$delta==0,]$horm
radio_uc<-breast[breast$delta==1,]$radio
radio_rc<-breast[breast$delta==0,]$radio
age_uc<-breast[breast$delta==1,]$age
age_rc<-breast[breast$delta==0,]$age
npi_uc<-breast[breast$delta==1,]$npi
npi_rc<-breast[breast$delta==0,]$npi
claudin_uc<-as.integer(breast[breast$delta==1,]$claudin)
claudin_rc<-as.integer(breast[breast$delta==0,]$claudin)
N_group<-7
data<-list(N_uc,N_rc,t_uc,t_rc,
           chem_uc,chem_rc,horm_uc,horm_rc,radio_uc,radio_rc,
           npi_uc,npi_rc,age_uc,age_rc,
           claudin_uc,claudin_rc,N_group)

#stan models
library(rstan)
model1<-stan('./stan/Breast_nonhierarchical.stan',data=data)
check_hmc_diagnostics(model1)
model2<-stan('./stan/Breast_hierarchical.stan',data=data,chains=2)
check_hmc_diagnostics(model2)
model3<-stan('./stan/Breast_hierarchical1.stan',data=data)
check_hmc_diagnostics(model3)

#LOO-PSIS
library(loo)
log_lik1<-extract_log_lik(model1)
loo1<-loo(log_lik1)
log_lik2<-extract_log_lik(model2)
loo2<-loo(log_lik2)
log_lik3<-extract_log_lik(model3)
loo3<-loo(log_lik3)
compare(loo1,loo2,loo3)

#simulation
y_rep_1<-matrix(unlist(rstan::extract(model1,pars=c("y_rep"))),nrow = 4000, byrow = FALSE)
y_rep_3<-matrix(unlist(rstan::extract(model3,pars=c("y_rep"))),nrow = 4000, byrow = FALSE)

temp<-breast[breast$claudin==6,]
surv_object_t <- Surv(temp$time,temp$delta)
model_t<-survfit(surv_object_t~1,data=temp)
plot(model_t$time,model_t$surv,type='l',lwd=2, xlab='time',ylab='survival',xlim=c(0,350),ylim=c(0,1),main='survival rate versus time (Claudin=6)')

for (i in 1:100){
  par(new=TRUE)
  temp<-data.frame(time=y_rep_1[i,breast$claudin==6],delta=rep(1,sum(breast$claudin==6)))
  surv_object_t <- Surv(temp$time,temp$delta)
  model_t<-survfit(surv_object_t~1,data=temp)
  plot(model_t$time,model_t$surv,col=rgb(red = 1, green = 0, blue = 0, alpha = 0.5),type='l',lwd=2, xlab='time',ylab='survival',xlim=c(0,350),ylim=c(0,1))
  
}
for (i in 1:100){
  par(new=TRUE)
  temp<-data.frame(time=y_rep_3[i,breast$claudin==6],delta=rep(1,sum(breast$claudin==6)))
  surv_object_t <- Surv(temp$time,temp$delta)
  model_t<-survfit(surv_object_t~1,data=temp)
  plot(model_t$time,model_t$surv,col=rgb(red = 0, green = 0, blue = 1, alpha = 0.5),type='l',lwd=2, xlab='time',ylab='survival',xlim=c(0,350),ylim=c(0,1))
  
}
legend('topright', legend=c("Observation","model1","model3"), 
       col=c(1,rgb(red = 1, green = 0, blue = 0, alpha = 0.5),rgb(red = 0, green = 0, blue = 1, alpha = 0.5)), lty=1, cex=0.8)

