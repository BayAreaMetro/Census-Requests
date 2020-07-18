# ACS 2018 Demographic Data.R
# SI

# Request:

"Demographic data for six underserved population group by county. These underserved groups include
People with disabilities, older adults, low income, veterans, rural, and limited English proficiencies. 
We need the percentage of population in each of these groups by county."


# Bring in appropriate packages and install Census key

suppressMessages(library(dplyr))
library(tidycensus)

censuskey <- readLines("H:/Census/API.txt")

census_api_key(censuskey, install = TRUE, overwrite = TRUE)


# Import ACS library for variable inspection

ACS_table <- load_variables(year=2018, dataset="acs1", cache=TRUE)

# Set up census variables for API

ACS_year <- 2018
ACS_product <- "acs1"
baycounties <- c("01","13","41","55","75","81","85","95","97")
statenumber="06"

wd <- "M:/Data/Requests/Nisar Ahmed"
setwd(wd)

ACS_variables <- c(Total_V_Universe_  = "B21001_001",  # Total veteran universe
                   Total_Veteran_     = "B21001_002",  # Total veterans
                   Total_Nonveteran_  = "B21001_003",  # Total non-veterans
                   Total_Dis_Pop_     = "C18108_001",  # Total disability universe
                   Under_18_1_Dis_    = "C18108_003",  # Under 18 with 1 disability
                   Under_18_2p_Dis_   = "C18108_004",  # Under 18 with 2-plus disabilities
                   From_18_64_1_Dis_  = "C18108_007",  # 18-64 with 1 disability
                   From_18_64_2p_Dis_ = "C18108_008",  # 18-64 with 2-plus disabilities
                   Over_64_1_Dis_     = "C18108_011",  # Over 64 with 1 disability
                   Over_64_2p_Dis_    = "C18108_012",  # Over 64 with 2-plus disabilities
                   Total_Pop_         = "B01003_001",  # Total population
                   Age_65_66_Male_    = "B01001_020",  # Males ages 65-66
                   Age_67_69_Male_    = "B01001_021",  # Males ages 67-69  
                   Age_70_74_Male_    = "B01001_022",  # Males ages 70-74
                   Age_75_79_Male_    = "B01001_023",  # Males ages 75-79
                   Age_80_84_Male_    = "B01001_024",  # Males ages 80-84
                   Age_85p_Male_      = "B01001_025",  # Males ages 85-plus
                   Age_65_66_Female_  = "B01001_044",  # Females ages 65-66
                   Age_67_69_Female_  = "B01001_045",  # Females ages 67-69
                   Age_70_74_Female_  = "B01001_046",  # Females ages 70-74
                   Age_75_79_Female_  = "B01001_047",  # Females ages 75-79
                   Age_80_84_Female_  = "B01001_048",  # Females ages 80-84
                   Age_85p_Female_    = "B01001_049",  # Females ages 85-plus
                   Total_Poverty_     = "C17002_001",  # Total poverty universe
                   Under.50_Poverty_  = "C17002_002",  # Under 50 percent ratio income to poverty threshold
                   From.50_.99_Pov_   = "C17002_003",  # 50 to 99 percent ratio income to poverty threshold
                   From1.00_1.24_Pov_ = "C17002_004",  # 100 to 124 percent ratio income to poverty threshold
                   From1.25_1.49_Pov_ = "C17002_005",  # 125 to 149 percent ratio income to poverty threshold
                   From1.50_1.84_Pov_ = "C17002_006",  # 150 to 184 percent ratio income to poverty threshold
                   From1.85_1.99_Pov_ = "C17002_007",  # 185 to 199 percent ratio income to poverty threshold
                   Over2.00_Pov_      = "C17002_008",  # 200 percent-plus ratio income to poverty threshold
                   Total_LEP_Pop_     = "C16008_001",  # Limited-English proficiency universe
                   Citzen_U18_LEP_    = "C16008_007",  # Citizen under 18 speaks English less than "very well"
                   Citzen_O18_LEP_    = "C16008_012",  # Citizen 18-plus speaks English less than "very well"
                   Not_Cit_U18_LEP_   = "C16008_018",  # Not a citizen under 18 speaks English less than "very well"
                   Not_Cit_O18_LEP_   = "C16008_023"   # Not a citizen 18-plus speaks English less than "very well"
                   )

ACS_raw_data <- get_acs(geography = "county", variables = ACS_variables, # Make data call
                          state = statenumber, county=baycounties,
                          year=ACS_year,
                          output="wide",
                          survey = ACS_product )

Final <- ACS_raw_data %>%  
  arrange(NAME) %>%                                                      # Sort by county
  select(-(grep("_M$", names(.), value=TRUE)))                           # Delete margin of error variables

# Export raw data for additional processing in Excel

write.csv(Final,"ACS2018_Demographic_Variables.csv", row.names = FALSE, quote = T)



