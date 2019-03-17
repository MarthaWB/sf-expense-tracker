#!/bin/bash

# set permissions: chmod u+x ./expense-tracker.sh
# end immediately on non-zero exit codes
set -e

# setup local development
if [[ $1 = 'up' ]]; then
    sfdx force:org:create -f config/project-scratch-def.json -a dev -s -d 21
    sfdx force:data:tree:import --plan data/Expense_Category.json/export-demo-Category__c-plan.json
    sfdx force:source:push -f
    sfdx force:user:create -f config/consultant-user-def.json
    sfdx force:user:create -f config/finance-user-def.json
fi
