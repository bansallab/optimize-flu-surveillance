## Epidemic intensity model at the county level for the 2009 pandemic: CAR spatial model, shifted response variable (e.g., seasonal intensity 0 -> 1), with interaction terms

#### header #################################
rm(list = ls())
require(dplyr); require(tidyr); require(readr); require(DBI); require(RMySQL) # clean_data_functions dependencies
require(maptools); require(spdep) # prepare_inlaData_st.R dependencies
require(INLA) # main dependencies
require(RColorBrewer); require(ggplot2) # export_inlaData_st dependencies

source("custom_functions.R")
#### FILEPATHS #################################
file_dataImport <- "inlaImport_model9a_iliSum_v7.csv"

#### MAIN #################################
#### Import and process data ####
modData_full <- modData_full <- read_csv(file_dataImport) 

formula <- Y ~ -1 + 
  f(fips_nonzero, model = "iid") + 
  f(fips_st_nonzero, model = "iid") + 
  intercept_nonzero + O_imscoverage_nonzero + O_careseek_nonzero + O_insured_nonzero + X_poverty_nonzero + X_child_nonzero + X_adult_nonzero + X_hospaccess_nonzero + X_popdensity_nonzero + X_housdensity_nonzero + 
  X_vaxcovC_nonzero + X_vaxcovA_nonzero +
  X_priorImmunity_nonzero + 
  X_humidity_nonzero + X_pollution_nonzero + X_singlePersonHH_nonzero + offset(logE_nonzero)

#### run models by season ################################
modData_hurdle <- prepare_data_for_inla(modData_full)

mod <- inla(formula,
            family = "gaussian",
            data = modData_hurdle,
            control.fixed = list(mean = 0, prec = 1/100), # set prior parameters for regression coefficients
            control.predictor = list(compute = TRUE, link = rep(1, nrow(modData_full))), # compute summary statistics on fitted values, link designates that NA responses are calculated according to the first likelihood
            control.compute = list(dic = TRUE, cpo = TRUE),
            control.inla = list(correct = TRUE, correct.factor = 10, diagonal = 0, tolerance = 1e-6),
            verbose = TRUE,
            keep = TRUE, debug = TRUE)

