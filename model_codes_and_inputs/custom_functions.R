

prepare_inla_data <- function(modData_seas){
  # 8/17/16: prepare all seasons model data for 2 stage (hurdle) model in INLA 
  print(match.call())
  
  # top half response matrix with epi/no-epi indicator (binomial lik) and NA (gamma lik)
  Y_bin <- modData_seas %>% 
    select(y) %>%
    mutate(y0 = ifelse(y == 0, 0, ifelse(!is.na(y1), 1, NA))) %>% # 0 = no epidemic, 1 = epidemic, NA = NA
    mutate(y1 = NA) %>%
    select(-y) 
  
  # bottom half response matrix with NA (binomial lik) and non-zeros/NA (gamma lik)
  Y_gam <- modData_seas %>% 
    mutate(y0 = NA) %>% # 0 = no epidemic, 1 = epidemic, NA = NA
    select(y0, y1) 
  
  Y <- bind_rows(Y_bin, Y_gam) %>% data.matrix
  
  # covariate matrix for binomial lik: response, predictors, random effects
  Mx_bin <- modData_seas %>%
    select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, season) %>%
    mutate(intercept = 1) 
  colnames(Mx_bin) <- paste0(colnames(Mx_bin), "_bin")
  
  # covariate matrix for gamma lik: response, predictors, random effects & offset
  Mx_gam <- modData_seas %>%
    select(contains("X_"), contains("O_"), fips, fips_st, regionID, ID, logE, season) %>%
    mutate(intercept = 1) 
  colnames(Mx_gam) <- paste0(colnames(Mx_gam), "_nonzero")
  
  # NA block for bin & gam Mx
  NA_bin <- data.frame(matrix(data = NA, nrow = nrow(Mx_bin), ncol = ncol(Mx_bin)))
  names(NA_bin) <- colnames(Mx_bin)
  NA_gam <- data.frame(matrix(data = NA, nrow = nrow(Mx_gam), ncol = ncol(Mx_gam)))
  names(NA_gam) <- colnames(Mx_gam)
  # add NAs to appropriate locations
  Mx_bin2 <- bind_rows(Mx_bin , NA_bin)
  Mx_gam2 <- bind_rows(NA_gam, Mx_gam)
  
  # convert matrix information to a list of lists/matrixes
  Mx <- bind_cols(Mx_bin2, Mx_gam2)
  modData_seas_lists <- list()
  for (column in colnames(Mx)){
    modData_seas_lists[[column]] <- Mx[[column]]
  }
  # add Y response matrix as a list
  modData_seas_lists[['Y']] <- Y
  
  return(modData_seas_lists)
}

################################

prepare_inla_data_st <- function(modData_seas){
  # 10/11/16: prepare data seasonal model data for nonzero model component
  print(match.call())
  
  # bottom half response matrix with NA (binomial lik) and non-zeros/NA (gamma/normal lik)
  Y_nz <- modData_seas %>% 
    select(y1) %>%
    unlist
  
  # covariate matrix for nonzero lik: response, predictors, random effects & offset
  # 10/30/16 control flow for graph Idx # 12/20/16 graph Idx st 
  # 2/14/17 didn't rm vestigial cty code
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