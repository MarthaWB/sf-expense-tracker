trigger ExpenseItemTrigger on Expense_Item__c (before insert, before update) {

	for (Expense_Item__c expenseItem : Trigger.new) {
		if(expenseItem.Currency__c == 'USD') {
			expenseItem.Exchange_Rate__c = 1;
		} else {
			expenseItem.Exchange_Rate__c = 0;
		}
		// expenseItem.Reimbursable_Amount__c = expenseItem.Exchange_Rate__c * expenseItem.Amount__c;
	}
}