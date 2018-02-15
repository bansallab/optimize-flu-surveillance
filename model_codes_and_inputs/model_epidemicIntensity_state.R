
## Name: Elizabeth Lee
## Date: 2/14/17
## Function: Model 10a v2: state-level CAR spatial model, shifted response variable (e.g., seasonal intensity 0 -> 1), with interaction terms
## Filenames: physicianCoverage_IMSHealth_state.csv, dbMetrics_periodicReg_ilinDt_Octfit_span0.4_degree2_analyzeDB_st.csv
## Data Source: IMS Health
## Notes: 
## 
## useful commands:
## install.packages("pkg", dependencies=TRUE, lib="/usr/local/lib/R/site-library") # in sudo R
## update.packages(lib.loc = "/usr/local/lib/R/site-library")

#### header #################################
rm(list = ls())
require(dplyr); require(tidyr); require(readr); require(DBI); require(RMySQL) # clean_data_functions dependencies
require(maptools); require(spdep) # prepare_inlaData_st.R dependencies
require(INLA) # main dependencies
require(RColorBrewer); require(ggplot2) # export_inlaData_st dependencies

source("custom_functions.R")
#### FILEPATHS #################################
file_dataImport <- "inlaImport_model10a_iliSum_v1.csv" 

#### MAIN #################################
#### Import and process data ####
modData_full <- read_csv(file_dataImport) 

formula <- Y ~ -1 +
  f(ID_nonzero, model = "iid") +
  f(fips_st_nonzero, model = "iid") +
  f(regionID_nonzero, model = "iid") +
  f(season_nonzero, model = "iid") +
  intercept_nonzero + O_imscoverage_nonzero + O_careseek_nonzero + O_insured_nonzero + X_poverty_nonzero + X_child_nonzero + X_adult_nonzero + X_hospaccess_nonzero + X_popdensity_nonzero + X_housdensity_nonzero + X_vaxcovI_nonzero + X_vaxcovE_nonzero + X_H3A_nonzero + X_B_nonzero + X_priorImmunity_nonzero + X_humidity_nonzero + X_pollution_nonzero + X_singlePersonHH_nonzero + X_H3A_nonzero*X_adult_nonzero + X_B_nonzero*X_child_nonzero + offset(logE_nonzero)

#### run models for all seasons ################################
modData_hurdle <- prepare_inla_data_st(modData_full)

mod <- inla(formula,
            family = "gaussian",
            data = modData_hurdle,
            control.fixed = list(mean = 0, prec = 1/100), # set prior parameters for regression coefficients
            control.predictor = list(compute = TRUE, link = rep(1, nrow(modData_full))),
            control.compute = list(dic = TRUE, cpo = TRUE),
            control.inla = list(correct = TRUE, correct.factor = 10, diagonal = 0, tolerance = 1e-8), # http://www.r-inla.org/events/newfeaturesinr-inlaapril2015
            verbose = TRUE,
            keep = TRUE, debug = TRUE)




