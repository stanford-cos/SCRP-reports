# Supply Chain Risk Project

Collaborative project among the [World Economic Forum](https://www.weforum.org/), [FishWise](http://www.fishwise.org), [Global Fishing Watch](https://globalfishingwatch.org/), and the [Stanford Center for Ocean Solutions](https://oceansolutions.stanford.edu/).

[SRC Website](https://www.weforum.org/friends-of-ocean-action/iuu-fishing-supply-chain-risk-tool-scrt)

## Phase 3 Pilot Reports

`Report_summary_phase_03.qmd` is the file to run.
- sources `R/functions-survey.R` for general and visualization functions
- `Data/` not publically available yet

## Phase 2 Pilot Reports

This repository holds script used to generate summary numbers used to populate reports for pilot supply chain analyses. 

`Report_summary_phase_02.qmd` is the file to run. 
- `package_directories` chunk creates data directory to store supply chain .csv for analysis
- Change `all_vessels` object to read desired supply chain .csv in data directory OR
- Create new supply chain object in `wrangle_data` chunk 
- Change all function arguements in `generate_report_values` chunk to new supply chain object

