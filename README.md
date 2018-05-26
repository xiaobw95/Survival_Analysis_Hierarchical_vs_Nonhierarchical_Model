# Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model

Conducted comparison of hierarchical and non-hierarchical model in survival analysis with two example.

- [Kidney](http://blogs.oregonstate.edu/bida/data-sets-and-code/)

  Build two `stan` Weibull model of survival time after kidney transplantation: one is non-hierarchical model `time ~ 1 + age + sex + race`, and another is hierarchical model `time ~ 1 + age|(sex, race)`. Hierarchical model is slightly better according to `loo` (elpd_diff = 0.1).

  <p align="center">
    <img src="https://github.com/xiaobw95/Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model/blob/master/group_effect.png" alt=""/>
  </p>

- [Breast](http://www.cbioportal.org/study?id=brca_metabric#clinical)

  Build two `stan` Weibull model of survival time after kidney transplantation: one is non-hierarchical model `time ~ 1 + age + npi + horm + claudin`, and another is hierarchical model `time ~ 1 + (age + npi + horm)|(claudin)`, where `claudin` are types of cancer. Hierarchical model is better according to `loo` (elpd_diff = 13.3).

  <p align="center">
    <img src="https://github.com/xiaobw95/Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model/blob/master/claudin.png" alt=""/>
  </p>
