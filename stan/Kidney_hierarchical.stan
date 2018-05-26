# https://github.com/stan-dev/example-models/blob/master/bugs_examples/vol1/kidney/kidney.stan
# http://blogs.oregonstate.edu/bida/data-sets-and-code/

data {
  int<lower=0> N_uc;
  int<lower=0> N_rc;
  real<lower=0> t_uc[N_uc]; 
  real<lower=0> t_rc[N_rc]; 
  int age_uc[N_uc]; 
  int age_rc[N_rc]; 
  int group_uc[N_uc]; 
  int group_rc[N_rc];
  int N_group;
} 
parameters {
  real alpha; 
  vector[N_group] beta_age;
  real<lower=0> r; 
} 

model {  
  alpha ~ normal(0, 100); 
  beta_age ~ normal(0, 100); 

  r ~ gamma(1, 1.0E-3); 

  for (i in 1:N_uc) {
    t_uc[i] ~ weibull(r, exp(-(alpha + beta_age[group_uc[i]] * age_uc[i]) / r));
  } 
  for (i in 1:N_rc) {
    
    1 ~ bernoulli(exp(-pow(t_rc[i] / exp(-(alpha + beta_age[group_rc[i]] * age_rc[i]) / r), r)));
  }
}

generated quantities {
  vector[N_uc+N_rc] log_lik;
  for (i in 1:N_uc) {
    log_lik[i] = weibull_lpdf(t_uc[i]|r, exp(-(alpha + beta_age[group_uc[i]] * age_uc[i]) / r));
  }
  for (i in 1:N_rc){
    log_lik[N_uc+i] = bernoulli_lpmf(1|exp(-pow(t_rc[i] / exp(-(alpha + beta_age[group_rc[i]] * age_rc[i]) / r), r)));
  }

}
