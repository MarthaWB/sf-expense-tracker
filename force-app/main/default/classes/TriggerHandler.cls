public abstract class TriggerHandler {
    public abstract void beforeInsert();
    public abstract void afterInsert();
    public abstract void beforeUpdate();
    public abstract void afterUpdate();
    public abstract void beforeDelete();
    public abstract void afterDelete();
    public void execute() {
      isInsert && ( isBefore ? beforeInsert() : afterInsert() );
      isUpdate && ( isBefore ? beforeUpdate() : afterUpdate() );
      isDelete && ( isBefore ? beforeDelete() : afterDelete() );
    }
}

