# Supply Chain Risk Project
## Phase 2 Pilot Reports

This repository holds script used to generate summary numbers used to populate reports for pilot supply chain analyses. 

`Report_summaries.qmd` is the file to run. 
- `package_directories` chunk creates data directory to store supply chain .csv for analysis
- Change `all_vessels` variable to pull from desired supply chain .csv in data directory OR
- Create new supply chain object in `wrangle_data` chunk 
- Change all function arguements in `generate_report_values` chunk to new supply chain object

[SRC Website](https://www.weforum.org/friends-of-ocean-action/iuu-fishing-supply-chain-risk-tool-scrt)
