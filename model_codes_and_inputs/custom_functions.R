

prepare_inla_data <- function(modData_seas){
  # prepare all seasons model at county level
  print(match.call())
  
  # response data
  Y_nz <- modData_seas %>% 
    select(y1) %>%
    unlist
  
  # covariate matrix for nonzero lik: response, predictors, random effects & offset
  if(is.null(modData_seas$graphIdx) & is.null(modData_seas$graphIdx_st) & is.null(modData_seas$seasonID)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season) %>%
      mutate(intercept = 1) 
  } else if(is.null(modData_seas$graphIdx_st) & !is.null(modData_seas$graphIdx) & is.null(modData_seas$seasonID)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season, graphIdx) %>%
      mutate(intercept = 1) 
  } else if(!is.null(modData_seas$graphIdx_st) & is.null(modData_seas$graphIdx) & is.null(modData_seas$seasonID)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season, graphIdx_st) %>%
      mutate(intercept = 1)
  } else if(!is.null(modData_seas$graphIdx_st) & !is.null(modData_seas$graphIdx) & is.null(modData_seas$seasonID)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season, graphIdx, graphIdx_st) %>%
      mutate(intercept = 1)
  } else if(!is.null(modData_seas$graphIdx_st) & !is.null(modData_seas$graphIdx) & !is.null(modData_seas$seasonID)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season, graphIdx, graphIdx_st, seasonID) %>%
      mutate(intercept = 1)
  }
  colnames(Mx_nz) <- paste0(colnames(Mx_nz), "_nonzero")
  
  # convert matrix information to a list of lists/matrixes
  modData_seas_lists <- list()
  for (column in colnames(Mx_nz)){
    modData_seas_lists[[column]] <- Mx_nz[[column]]
  }
  # add Y response vector as a list
  modData_seas_lists[['Y']] <- Y_nz
  
  return(modData_seas_lists)
}

################################

prepare_inla_data_st <- function(modData_seas){
  # prepare all seasons model at state level
  print(match.call())
  
  # response data
  Y_nz <- modData_seas %>% 
    select(y1) %>%
    unlist
  
  # covariate matrix for nonzero lik: response, predictors, random effects & offset
  if(is.null(modData_seas$graphIdx) & is.null(modData_seas$graphIdx_st)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips_st, regionID, ID, logE, season) %>%
      mutate(intercept = 1) 
  } else if(is.null(modData_seas$graphIdx_st) & !is.null(modData_seas$graphIdx)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips_st, regionID, ID, logE, season) %>%
      mutate(intercept = 1) 
  } else if(!is.null(modData_seas$graphIdx_st) & is.null(modData_seas$graphIdx)){
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips_st, regionID, ID, logE, season, graphIdx_st) %>%
      mutate(intercept = 1)
  } else{
    Mx_nz <- modData_seas %>%
      select(contains("X_"), contains("O_"), fips_st, regionID, ID, logE, season, graphIdx_st) %>%
      mutate(intercept = 1)
  }
  colnames(Mx_nz) <- paste0(colnames(Mx_nz), "_nonzero")
  
  # convert matrix information to a list of lists/matrixes
  modData_seas_lists <- list()
  for (column in colnames(Mx_nz)){
    modData_seas_lists[[column]] <- Mx_nz[[column]]
  }
  # add Y response vector as a list
  modData_seas_lists[['Y']] <- Y_nz
  
  return(modData_seas_lists)
}
