trigger ExpenseItemTrigger on Expense_Item__c (before insert, before update) {
List<Expense_Item__c> expenseItems = new List<Expense_Item__c>();

	        for (Expense_Item__c a : Trigger.new) {
	            if(a.Currency__c == 'USD') {
	                a.Exchange_Rate__c = 1;
	            } else {
                 a.Exchange_Rate__c = 0;
              }
	        }
	      insert expenseItems;
}