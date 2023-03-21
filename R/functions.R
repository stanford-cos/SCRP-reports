# Analysis Functions

# create report of general supply chain summary stats
speak_generally <- function(supply_chain){
  report_general <- supply_chain %>% 
    summarize("company" = unique(c),
              "supply_chain" = unique(c_listname),
              "vessels_total_n" = length(v_id),
              "vessels_ais_n" = sum(!is.na(vv_ais_coverage_percent)),
              "prct_vessels_ais" = vessels_ais_n / vessels_total_n,
              "prct_ais_cover_min" = min(vv_ais_coverage_percent, na.rm = T),
              "prct_ais_cover_max" = max(vv_ais_coverage_percent, na.rm = T),
              "prct_ais_cover_median" = median(vv_ais_coverage_percent, na.rm = T),
              "prct_ais_cover_mean" = mean(vv_ais_coverage_percent, na.rm = T)
    )
  name <- paste0("rep_1_general_", deparse(substitute(supply_chain)))
  assign(name, report_general, envir = parent.frame())
  return(report_general)
}

# create checklist of Key data elements (kde) for each company supply chain
# assesses completeness of data company provided
check_kde_list <- function(supply_chain){
  kde <- supply_chain %>% 
    summarize("company" = unique(c),
              "supply_chain" = unique(c_listname),
              "species" = any(!is.na(c_species) | !is.na(c_common_name)),
              "country_harvest" = any(!is.na(c_country)),
              "ports_landing" = any(!is.na(c_port)),
              "eez_highseas" = "check",
              "harvest_rfmo" = "check",
              "harvest_fao" = any(!is.na(c_fao)),
              "harvest_fao_sub" = "check",
              "cert_name" = "check",
              "fip" = any(!is.na(FIP)) | any(me_fip_status != "Not on FIP vessel lists"),
              "vessel_name" = any(!is.na(c_name)),
              "vessel_name_n" = sum(!is.na(c_name)),
              "vessel_imo" = any(!is.na(c_imo)),
              "vessel_imo_n" = sum(!is.na(c_imo)),
              "vessel_mmsi" = any(!is.na(c_mmsi)),
              "vessel_mmsi_n" = sum(!is.na(c_mmsi)),
              "vessel_callsign" = any(!is.na(c_ircs)),
              "vessel_callsign_n" = sum(!is.na(c_ircs)),
              "vessel_flag" = any(!is.na(c_flag)),
              "vessel_flag_n" = sum(!is.na(c_flag)),
              "ais_data" = any(!is.na(vv_ais_coverage_percent)),
              "transship_reported" = "check"
    ) 
  name <- paste0("rep_2_kde_", deparse(substitute(supply_chain)))
  assign(name, kde, envir = parent.frame())
  return(kde)
}

# Generate Risk Indicators for report with vessel viewer values
assess_risk <- function(supply_chain){
  indicators <- supply_chain %>% 
    summarize("company" = unique(c),
              "supply_chain" = unique(c_listname),
              "iuu_listed_vessel_n" = sum(as.logical(vv_iuu_listed), na.rm = T),
              "rfmo_no_auth_events" = sum(vv_rfmo_unauthorized_events, na.rm = T),
              "rfmo_no_auth_vessels_n" = sum(vv_rfmo_unauthorized_events > 0, na.rm = T),
              "transship_rfmo_events" = sum(vv_encounters_rfmo_unauthorized, na.rm = T),
              "transship_rfmo_vessels_n" = sum(vv_encounters_rfmo_unauthorized > 0, na.rm = T),
              "mpa_events" = sum(vv_mpa_events, na.rm = T),
              "mpa_vessels_n" = sum(vv_mpa_events > 0, na.rm = T),
              "mpa_total_hrs" = sum(vv_mpa_hrs, na.rm = T),
              # Medium Risk Indicators
              "ais_disabling_events" = sum(vv_ais_disabled_n, na.rm = T),
              "ais_disabling_vessels_n" = sum(vv_ais_disabled_n > 0, na.rm = T),
              "ais_disabling_total_hrs" = sum(vv_ais_disable_hrs, na.rm = T),
              "ais_cover_prct_1yr_min" = min(vv_ais_coverage_percent, na.rm = T),
              "ais_cover_prct_1yr_max" = max(vv_ais_coverage_percent, na.rm = T),
              "ais_cover_prct_1yr_median" = median(vv_ais_coverage_percent, na.rm = T),
              "ais_cover_prct_1yr_mean" = mean(vv_ais_coverage_percent, na.rm = T),
              # number of vessels with trips > 11 months
              "long_trip_vessels_n" = sum(map_long_trip_n > 0, na.rm = T),
              "name_changes_n" = sum(vv_name_change, na.rm = T),
              "flag_changes_n" = sum(vv_flag_change, na.rm = T)
    )
  name <- paste0("rep_3_ind_vv_", deparse(substitute(supply_chain)))
  assign(name, indicators, envir = parent.frame())
  return(indicators)
}

# Contextual Indicators
give_context <- function(supply_chain, foc_list){
  context <- supply_chain %>% 
    summarise("company" = unique(c),
              "supply_chain" = unique(c_listname),
              "vessel_flags" = paste(unique(c_flag), collapse = ";"),
              "landing_country" = paste(unique(c_country), collapse = ";"),
              "cpi" = "check",
              "psma" = paste(unique(m_c_psma), collapse = ";"),
              # these need to use vessel flag not country of operation
              "eu_card" = paste(unique(m_c_eu_flag), collapse = ";"),
              "us_card" = paste(unique(m_c_us_flag), collapse = ";"),
              "simp" = "check", # could create list of species or scrape
              "petrossian_clark" = paste(unique(m_petro_score), collapse = ";"),
              "species_harvest" = paste(unique(c_species), collapse = ";"),
              "pvr" = paste(unique(me_pvr_status), collapse = ";")
    )
  # True if vessel flags are on FOC list, False if not
  foc <- any(grepl(paste(foc_list$c_flag, collapse = "|"),
                   context$vessel_flags))
  # add foc to output
  context_2 <- context %>% 
    mutate("open_registry" = foc)
  
  name <- paste0("rep_4_context_", deparse(substitute(supply_chain)))
  assign(name, context_2, envir = parent.frame())
  return(context_2)
}

### Additions - scrape PSMA webpage for values
# https://www.fao.org/port-state-measures/background/parties-psma/en/

#count_ind <- nesi_srilanka %>% 
detail_vessels <- function(supply_chain) {
  detail <- supply_chain %>%
    rowwise() %>% 
    mutate(
      c_name = toupper(c_name),
      # True/False of flagged indicator
      "iuu_logic" = vv_iuu_listed > 0,
      "unauth_rfmo_fish_logic" = vv_rfmo_unauthorized_events > 0,
      "unauth_trans_logic" = vv_encounters_rfmo_unauthorized > 0,
      "mpa_events_logic" = vv_mpa_events > 0,
      "disable_events_logic" = vv_ais_disabled_n > 0,
      "long_trip_logic" = ifelse(map_long_trip_n > 0, TRUE, FALSE),
      "name_logic" = vv_name_change > 0,
      "flag_logic" = vv_flag_change > 0,
      # High risk
      "count_high_ind" = sum(c_across(c(iuu_logic,
                                        unauth_rfmo_fish_logic,
                                        unauth_trans_logic,
                                        mpa_events_logic)), na.rm = T),
      "iuu_listed" = ifelse(vv_iuu_listed == TRUE, "On IUU Lists", "Not on IUU Lists"),
      "unauth_rfmo_fish_events" = vv_rfmo_unauthorized_events,
      "unauth_transship_events" = vv_encounters_rfmo_unauthorized,
      "mpa_fishing_events" = vv_mpa_events,
      "mpa_fishing_hours" = vv_mpa_hrs,
      # Medium
      "count_med_ind" = sum(c_across(c(disable_events_logic,
                                       long_trip_logic,
                                       name_logic,
                                       flag_logic)), na.rm = T),
      "disable_events" = vv_ais_disabled_n,
      "disable_hours" = vv_ais_disable_hrs,
      "long_trip" = map_long_trip_n,
      "name_changes" = vv_name_change,
      "flag_changes" = vv_flag_change,
      "ais_coverage" = vv_ais_coverage_percent*100) %>%
    arrange(c_name) %>% 
    select(c_name, count_high_ind, iuu_listed, unauth_rfmo_fish_events,
           unauth_transship_events, mpa_fishing_events, mpa_fishing_hours,
           count_med_ind, disable_events, disable_hours, long_trip, name_changes,
           flag_changes, ais_coverage)
  
  name <- paste0("rep_5_details_", deparse(substitute(supply_chain)))
  assign(name, detail, envir = parent.frame())
  name2 <- paste0("detail_vessels_", deparse(substitute(supply_chain)), 
                  "_", Sys.Date(), ".csv")
  write_csv(detail, file.path(output_dir, name2))
  return(detail)
}


# flag_risky_vessels <- function(supply_chain){
# }