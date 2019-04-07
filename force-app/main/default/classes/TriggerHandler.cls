public abstract class TriggerHandler {
     abstract void beforeInsert();
     abstract void afterInsert();
     abstract void beforeUpdate();
     abstract void afterUpdate();
     abstract void beforeDelete();
     abstract void afterDelete();

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

