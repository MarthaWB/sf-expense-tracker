public class ExpenseItemTriggerHandler extends TriggerHandler {

    void beforeInsert() {
        calculateReimbursableAmount(Trigger.new);
    }

    void afterInsert(){}

    void beforeUpdate(){
        calculateReimbursableAmount(Trigger.new);
    }

    void afterUpdate(){}

    void beforeDelete(){}

    void afterDelete(){}

    void calculateReimbursableAmount(List<Expense_Item__c> ExpenseItemList) {

        for (Expense_Item__c expenseItem : ExpenseItemList) {
            if(expenseItem.Currency__c == 'USD') {
                expenseItem.Exchange_Rate__c = 1;
            } else {
                expenseItem.Exchange_Rate__c = 0;
            }
        }

        Set<Id> catergoryIds = new Set<Id>();

        for (Expense_Item__c ei : ExpenseItemList) {
          catergoryIds.add(ei.Category__c);
	    }

        Map<Id, Category__c> categories = new Map<Id, Category__c>([
            SELECT Id, Reimbursable_Percentage__c
            FROM Category__c
            WHERE Id IN:catergoryIds
        ]);

        for (Expense_Item__c expenseI : ExpenseItemList) {
           Id categoryId = expenseI.Category__c;
          expenseI.Reimbursable_Amount__c = expenseI.Exchange_Rate__c * expenseI.Amount__c * categories.get(categoryId).Reimbursable_Percentage__c;
	    }
    }
}