# ACS 2018 Demographic Data.R
# SI

# From Nisar:

"Demographic data for six underserved population group by county. These underserved groups include
People with disabilities, older adults, low income, veterans, rural, and limited English proficiencies. 
We need the percentage of population in each of these groups by county."


# Bring in appropriate packages and install Census key

suppressMessages(library(dplyr))
library(tidycensus)

censuskey <- readLines("H:/Census/API.txt")

census_api_key(censuskey, install = TRUE, overwrite = TRUE)


# Import ACS library for variable inspection

ACS_table <- load_variables(year=2016, dataset="acs5", cache=TRUE)

# Set up census variables for API

ACS_year <- 2018
ACS_product <- "acs1"
baycounties <- c("01","13","41","55","75","81","85","95","97")
statenumber="06"

wd <- "M:/Data/Requests/Nisar Ahmed"
setwd(wd)

ACS_variables <- c(Total_V_Universe_  = "B21001_001",  #SEX BY AGE BY VETERAN STATUS FOR THE CIVILIAN POPULATION 18 YEARS AND OVER
                   Total_Veteran_     = "B21001_002",
                   Total_Nonveteran_  = "B21001_003",
                   Total_Dis_Pop_     = "C18108_001",
                   Under_18_1_Dis_    = "C18108_003",
                   Under_18_2p_Dis_   = "C18108_004",
                   From_18_64_1_Dis_  = "C18108_007",
                   From_18_64_2p_Dis_ = "C18108_008",
                   Over_64_1_Dis_     = "C18108_011",
                   Over_64_2p_Dis_    = "C18108_012",
                   Total_Pop_         = "B01003_001",
                   Age_65_66_Male_    = "B01001_020",
                   Age_67_69_Male_    = "B01001_021",
                   Age_70_74_Male_    = "B01001_022",
                   Age_75_79_Male_    = "B01001_023",
                   Age_80_84_Male_    = "B01001_024",
                   Age_85p_Male_      = "B01001_025",
                   Age_65_66_Female_  = "B01001_044",
                   Age_67_69_Female_  = "B01001_045",
                   Age_70_74_Female_  = "B01001_046",
                   Age_75_79_Female_  = "B01001_047",
                   Age_80_84_Female_  = "B01001_048",
                   Age_85p_Female_    = "B01001_049",
                   Total_Poverty_     = "C17002_001",
                   Under.50_Poverty_  = "C17002_002",
                   From.50_.99_Pov_   = "C17002_003",
                   From1.00_1.24_Pov_ = "C17002_004",
                   From1.25_1.49_Pov_ = "C17002_005",
                   From1.50_1.84_Pov_ = "C17002_006",
                   From1.85_1.99_Pov_ = "C17002_007",
                   Over2.00_Pov_      = "C17002_008",
                   Total_LEP_Pop_     = "C16008_001",
                   Citzen_U18_LEP_    = "C16008_007",
                   Citzen_O18_LEP_    = "C16008_012",
                   Not_Cit_U18_LEP_   = "C16008_018",
                   Not_Cit_O18_LEP_   = "C16008_023"
                   )




ACS_raw_data <- get_acs(geography = "county", variables = ACS_variables,
                          state = statenumber, county=baycounties,
                          year=ACS_year,
                          output="wide",
                          survey = ACS_product )

Final <- ACS_raw_data %>%  
  arrange(NAME) %>% 
  select(-(grep("_M$", names(.), value=TRUE)))  # Delete margins of error


write.csv(Final,"ACS2018_Demographic_Variables.csv", row.names = FALSE, quote = T)



