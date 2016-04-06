public with sharing class StorageSpaceCtrl {
  public static List<String> objList;
    public String errorMsg{get;set;}
    
    // getObjectRecord method fetch all object using metadata api and caluculate the record count of all object and its storage space
    public List<InnerObjectRecord> getObjectRecord(){
        List<InnerObjectRecord>  InnerObjectRecordList = new List<InnerObjectRecord>();
        DescribeSObjectResult sObjectResult;
        objList = new List<String>();
        
        for(Schema.SObjectType sObjectType : Schema.getGlobalDescribe().Values()){
            sObjectResult = sObjectType.getDescribe();
            if(sObjectResult.isAccessible() && sObjectResult.isCreateable() && sObjectResult.isUpdateable() && sObjectResult.isDeletable() && sObjectResult.isUndeletable()){     
               objList.add(sObjectResult.getName());
            }
        }  
        
        objList.sort();
        
        System.debug('ObjList1234:'+ objList.size()+ ':' + JSON.serialize(objList) );
        Integer accTSpace;
        Integer accountSpace;
        InnerObjectRecord innerObjR;
        
        if(objList != null && !objList.isEmpty()){
            for(String objName : objList){
                if(objName != 'CollaborationGroupRecord' && objName != 'IdeaComment'){
                    
                    String query = 'Select count() from '+ objName;
                    
                    Integer objCount = Database.countQuery(query);
                    accTSpace = objCount*2;
                    
                    if(accTSpace > 1024){
                        accountSpace = Math.round(Decimal.valueOf(accTSpace)/1024);
                    }else{
                        accountSpace = accTSpace;
                    }
                    
                    innerObjR = new InnerObjectRecord();
                    innerObjR.name = objName;
                    innerObjR.recordCount = objCount;
                    innerObjR.recordStorageSpace = accountSpace;
                    InnerObjectRecordList.add(innerObjR); 
                }
            } 
        }
        return InnerObjectRecordList;
    }
  
    // Inner Class
    public class InnerObjectRecord{
        public String name{get;set;}
        public String apiName{get;set;}
        public Integer recordCount{get;set;}
        public Integer recordStorageSpace{get;set;}
    }
}