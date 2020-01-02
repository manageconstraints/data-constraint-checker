# data-constraint-checker

This is for data constraints checking.

## Set up
Install required gems:

Ensure you have installed ruby 2.3.7

`rvm use 2.3.7`

`gem install yard`

`gem install regexp-examples -v 1.4.4`

`gem install pg_query`

`gem install activesupport -v 5.2.3`

`gem install write_xlsx -v 0.85.6`

cloc for line of code analysis:
* linux
```export PATH=`pwd`/cloc-1.82/cloc:$PATH```
* mac
`brew install cloc`

bs4 under python3

`apt-get install python3-bs4`

or

`pip3 install beautifulsoup4`

## Prepare 

### clone all 12 apps 

`ruby clone_repo.rb`

## Run

### Extract the latest version constraints:

`$ ruby run_apps.rb -l` 


### Traverse all versions 

`$ ruby run_apps.rb --tva`
* This will extract the evolution history of constraints, also the column associated with constraints

### Compare the onstraints defined in the first and last versions 

`$ ruby run_apps.rb --first-last-num`

### Extract the breakdown of different type constraints: 

`$ ruby run_apps.rb  --api-breakdown`

  * This will generate a single log file for each application under log/api_breakdown_#{app_name}.log

`$ ruby api_breakdown_spread_sheets.rb `    
  
  * The summarized breakdown will be written to output/api_total_breakdown.xlsx. 

