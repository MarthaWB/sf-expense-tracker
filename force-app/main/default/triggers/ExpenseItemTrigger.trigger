trigger ExpenseItemTrigger on Expense_Item__c (
	before insert, 
    before update,
	before delete, 
    after insert, 
    after update,
	after delete
	) {
	ExpenseItemTriggerHandler eiTrigger = new ExpenseItemTriggerHandler();
	eiTrigger.execute();
}
