// https://github.com/stan-dev/example-models/blob/master/bugs_examples/vol1/kidney/kidney.stan
// http://blogs.oregonstate.edu/bida/data-sets-and-code/

data {
  int<lower=0> N_uc;
  int<lower=0> N_rc;
  real<lower=0> t_uc[N_uc]; 
  real<lower=0> t_rc[N_rc]; 
  real<lower=0> age_uc[N_uc]; 
  real<lower=0> age_rc[N_rc];
  real<lower=0> npi_uc[N_uc]; 
  real<lower=0> npi_rc[N_rc];
  int chem_uc[N_uc]; 
  int chem_rc[N_rc]; 
  int horm_uc[N_uc]; 
  int horm_rc[N_rc];
  int radio_uc[N_uc]; 
  int radio_rc[N_rc];
  int claudin_uc[N_uc]; 
  int claudin_rc[N_rc];
  int N_group;
} 
parameters {
  vector[N_group] alpha; 
  real beta_age;
  real beta_npi;
  real beta_horm;
  real<lower=0> r; 
} 

model {  
  alpha ~ normal(0, 100); 
  beta_age ~ normal(0, 100);
  beta_npi ~ normal(0, 100);
  beta_horm ~ normal(0, 100);

  r ~ gamma(1, 1.0E-3); 

  for (i in 1:N_uc) {
    t_uc[i] ~ weibull(r, exp(-(alpha[claudin_uc[i]] + beta_age * age_uc[i] + beta_npi * npi_uc[i] + beta_horm * horm_uc[i]) / r));
  } 
  for (i in 1:N_rc) {
    
    1 ~ bernoulli(exp(-pow(t_rc[i] / exp(-(alpha[claudin_rc[i]] + beta_age * age_rc[i] + beta_npi * npi_rc[i] + beta_horm * horm_rc[i]) / r), r)));
  }
}

generated quantities {
  vector[N_uc+N_rc] log_lik;
  vector[N_uc+N_rc] y_rep;
  for (i in 1:N_uc) {
    log_lik[i] = weibull_lpdf(t_uc[i]|r, exp(-(alpha[claudin_uc[i]] + beta_age * age_uc[i] + beta_npi * npi_uc[i] + beta_horm * horm_uc[i]) / r));
  }
  for (i in 1:N_rc){
    log_lik[N_uc+i] = bernoulli_lpmf(1|exp(-pow(t_rc[i] / exp(-(alpha[claudin_rc[i]] + beta_age * age_rc[i] + beta_npi * npi_rc[i] + beta_horm * horm_rc[i])/ r), r)));
  }
  for (i in 1:N_uc) {
    y_rep[i] = weibull_rng(r, exp(-(alpha[claudin_uc[i]] + beta_age * age_uc[i] + beta_npi * npi_uc[i] + beta_horm * horm_uc[i]) / r));
  }
  for (i in 1:N_rc){
    y_rep[N_uc+i] = weibull_rng(r, exp(-(alpha[claudin_rc[i]] + beta_age * age_rc[i] + beta_npi * npi_rc[i] + beta_horm * horm_rc[i])/ r));
  }
}
