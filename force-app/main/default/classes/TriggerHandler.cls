public abstract class TriggerHandler {
    public abstract void beforeInsert();
    public abstract void afterInsert();
    public abstract void beforeUpdate();
    public abstract void afterUpdate();
    public abstract void beforeDelete();
    public abstract void afterDelete();

    public void execute() {
      if (Trigger.isInsert) {
        if(Trigger.isBefore){
          beforeInsert();
        } else {
          afterInsert();
        }
      }

      if (Trigger.isUpdate) {
        if(Trigger.isBefore){
          beforeUpdate();
        } else {
          afterUpdate();
        }
      }

      if (Trigger.isDelete) {
        if(Trigger.isBefore){
          beforeDelete();
        } else {
          afterDelete();
        }
      }
    }
}

