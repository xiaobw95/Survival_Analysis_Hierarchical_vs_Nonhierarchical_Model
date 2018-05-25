# Survival_Analysis_Hierarchical_vs_Nonhierarchical_Model

Build two Weibull model of survival time after kidney transplantation: one is non-hierarchical model `time ~ age + sex + race`, and another is hierarchical model `time ~ age|(sex, race)`. Hierarchical model is slightly better according to `loo`.

[Data source](http://blogs.oregonstate.edu/bida/data-sets-and-code/)
