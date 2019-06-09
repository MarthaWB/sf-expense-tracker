public class ExchangeRateBatchScheduler implements Schedulable {
    
    // Execute at regular intervals
    public void execute(SchedulableContext ctx){
      String soql = 'SELECT Id, Name FROM Account';
      ExchangeRateBatch batch = new ExchangeRateBatch(soql);
      Database.executebatch(batch, 200);
    }
}
