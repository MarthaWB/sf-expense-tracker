public class ExpenseItemTriggerHandler extends TriggerHandler {

    void beforeInsert() {
        assignExchangeRate(Trigger.new);
    }

    void afterInsert(){}

    void beforeUpdate(){}

    void afterUpdate(){
        assignExchangeRate(Trigger.new);
    }

    void beforeDelete(){}

    void afterDelete(){}

    void assignExchangeRate(List<Expense_Item__c> ExpenseItemList) {
        for (Expense_Item__c expenseItem : ExpenseItemList) {
		if(expenseItem.Currency__c == 'USD') {
			expenseItem.Exchange_Rate__c = 1;
		} else {
			expenseItem.Exchange_Rate__c = 0;
		}
		// expenseItem.Reimbursable_Amount__c = expenseItem.Exchange_Rate__c * expenseItem.Amount__c;
	    }
    }
}