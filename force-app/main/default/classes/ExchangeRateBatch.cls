public class ExchangeRateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
// "Create a method in ExchangeRateBatch to populateExchangeRates. The method will:
// 1. Accespts a list of Expense_Item__c
// 2. Loop through the list of Expense_Item__c and organize them into a map where the key is the Date and the value is a Set of currencies for that date.
// 3. Call ExchangeRateService.getFXRates for every Map entry.
// 4. Append the results of getFXRates to a map where the key is formatted date string concatendated with currency code and delimited with colon sign. 
// Example: ""2019-05-09:JPY""
// The value of the map is Exchange_Rate__c object
// 5. Return the map"

    private String query;
    
    public ExchangeRateBatch (String soql){
        query = soql;
    }
    
    // The batch job starts

    public Database.Querylocator start(Database.BatchableContext bc){
        //String query = 'SELECT Id, Name FROM Account';
        return Database.getQuerylocator(query);
    } 

    public Map<String, Exchange_Rate__c> populateExchangeRates(List<Expense_Item__c> expenseItems){
        Map<Date, Set<String>> expenseItemsMap = new Map<Date, Set<String>>();
        Set<String> currenciesSetForDate = new Set<String>();

        // output a map with all expense item dates as key and a set of currencies as values
        for (Expense_Item__c expenseItem: expenseItems) {

            if(expenseItemsMap.get(expenseItem.Date__c)!= null){     
                currenciesSetForDate = expenseItemsMap.get(expenseItem.Date__c);
            }
                currenciesSetForDate.add(expenseItem.Currency__c);
                expenseItemsMap.put(expenseItem.Date__c, currenciesSetForDate);
        }


        //output a map with joined date_and_currency as key and exchange rate as value
        Map<String, Exchange_Rate__c> exchangeRateByDateAndCurrency = new Map<String, Exchange_Rate__c>();

        List<Exchange_Rate__c>FXRatesList;

        // callout for missing date and currency
        for (Date rateDate : expenseItemsMap.keySet()){
            List<String> currenciesToGet = new List<String>(expenseItemsMap.get(rateDate));
            ExchangeRateService exchangeRateService = new ExchangeRateService(rateDate, currenciesToGet);
            FXRatesList = exchangeRateService.getFXRates();

        for (Exchange_Rate__c exchangeRateObject: FXRatesList){
            if (rateDate == exchangeRateObject.Rate_Date__c && currenciesToGet.contains(exchangeRateObject.Currency__c) ){
                String exchangeRateKey = rateDate + ':' + exchangeRateObject.Currency__c;
                exchangeRateByDateAndCurrency.put(exchangeRateKey, exchangeRateObject);
            }
        }
      }

        for (Expense_Item__c expenseItem: expenseItems) {
            String exchangeRateKey = expenseItem.Date__c + ':' + expenseItem.Currency__c; 
            Boolean exchangeRateExists = exchangeRateByDateAndCurrency.get(exchangeRateKey) != null;
            if(exchangeRateExists){
                expenseItem.Exchange_Rate__c = 1 / exchangeRateByDateAndCurrency.get(exchangeRateKey).Rate__c;
            }
        }
    
        update expenseItems;

        if(FXRatesList.size() > 0){
            upsert FXRatesList;
        }
        return exchangeRateByDateAndCurrency;
    }
        // The batch job executes and operates on one batch of records
    public void execute(Database.BatchableContext bc, List<sObject> expenseItems) {
            populateExchangeRates(expenseItems);
        }
    
        // The batch job finishes
    public void finish(Database.BatchableContext bc){
            AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
            System.debug('>>>> finish ' + job.Status);
        }
    }

