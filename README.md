# Mapping and modeling drivers of influenza disease burden using hierarchical models
## Approximate Bayesian inference performed in R-INLA

This repository provides the source code and model outputs for a spatial Bayesian hierarchical model that maps county-level disease burden for influenza-like illness in the United States.

The model and mapping outputs are described in the following paper:
Lee, Elizabeth C., Ali Arab, Sandra M. Goldlust, C&eacute;cile Viboud, Bryan T. Grenfell, and Shweta Bansal. (2018). "Deploying digital health data to optimize influenza surveillance at national and local scales." PLOS Computational Biology. doi:10.1371/journal.pcbi.1006020.

### model codes and inputs
The source code for the primary models presented in the manuscript may be found in `model_codes/`. The codes here demonstrate the specific settings and parameters in our INLA models and provide additional examples for how to utilize the [R-INLA software](http://www.r-inla.org/). Please note that the input data to run the source code are not posted in this repository. 

Descriptions of the files are as follows:
  * `model_epidemicIntensity.R`: INLA code for county-level multi-season epidemic intensity models for the total, adult, and child population models
  * `model_epidemicDuration.R`: INLA code for county-level multi-season epidemic duration model
  * `model_epidemicIntensity_pandemic.R`: INLA model code for county-level 2009 H1N1 pandemic epidemic intensity models for the total population
  * `model_epidemicIntensity_state.R`: INLA code for the state-level multi-season epidemic intensity models used to examine aggregation bias
  * `custom_functions.R`: functions to prepare covariate data for INLA
  * `US_county_adjacency.graph`: county neighborhood structure, an input file for the county-level multi-season models

### model outputs
Summary statistics for estimated model parameters and fitted model values are provided as follows:
  * `summaryStats_epidemicDuration.csv`
  * `summaryStatsFitted_epidemicDuration.csv`

  * `summaryStats_epidemicIntensity.csv`
  * `summaryStatsFitted_epidemicIntensity.csv`

  * `summaryStats_epidemicIntensity_adult.csv`
  * `summaryStatsFitted_epidemicIntensity_adult.csv`

  * `summaryStats_epidemicIntensity_child.csv`
  * `summaryStatsFitted_epidemicIntensity_child.csv`

  * `summaryStats_epidemicIntensity_pandemic.csv`
  * `summaryStatsFitted_epidemicIntensity_pandemic.csv`
  
  * `summaryStats_epidemicIntensity_state.csv`
  * `summaryStatsFitted_epidemicIntensity_state.csv`


email: ecl48@georgetown.edu, shweta.bansal@georgetown.edu
