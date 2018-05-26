# Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model

Conducted comparison of hierarchical and non-hierarchical model in survival analysis with two example.

- [Kidney](http://blogs.oregonstate.edu/bida/data-sets-and-code/)

  Build three `stan` Weibull model of survival time after kidney transplantation: first is non-hierarchical model `time ~ 1 + age + sex + race`, second is hierarchical model `time ~ 1 + age|(sex, race)`, and third is hierarchical model `time ~ 1|(sex, race) + age`. According to LOO-PSIS, none of them has a significant advantage.

  <p align="center">
    <img src="https://github.com/xiaobw95/Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model/blob/master/group_effect.png" alt=""/>
  </p>

- [Breast](http://www.cbioportal.org/study?id=brca_metabric#clinical)

  Build three `stan` Weibull model of survival time after kidney transplantation: first is non-hierarchical model `time ~ 1 + age + npi + horm + claudin`, second is hierarchical model `time ~ 1 + (age + npi + horm)|(claudin)`, and third is hierarchical model `time ~ 1|(claudin) + (age + npi + horm)`, where `claudin` are types of cancer. According to LOO-PSIS, the second model is the best and the third one is secondary.

  <p align="center">
    <img src="https://github.com/xiaobw95/Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model/blob/master/claudin.png" alt=""/>
  </p>
