#!/bin/bash

# Download the file
curl -s -O https://www.fdic.gov/bank/individual/failed/banklist.csv

# Grab the header and redirect it to a new file
head -1 banklist.csv > failed_banks_ca.csv

# Filter CA rows and *apend* to the new file
# QUESTION: Why is below approach brittle or error-prone?
grep CA banklist.csv >> failed_banks_ca.csv

# Use command substitution to generate a count
# NOTE: Below is a bit hacky. We use cat to pipe
# the content to wc -l to limit the latter's output
# to just a number
ROW_COUNT=$(cat failed_banks_ca.csv | wc -l)

# Subtract the header row from final count
NUM_BANKS=$(($ROW_COUNT - 1))

# Print the number of banks
echo "There are ${NUM_BANKS} failed banks in California"

# Or...if you were to go to the trouble of setting up the ability to email
#echo "There are ${NUM_BANKS} failed banks in California" | mail -s "CA Failed Banks ($(date))" tumgoren@stanford.edu
