public class TestDataCtrl {
/*public Integer DailyApiMax{get;set;}
    public Integer DailyApiRem{get;set;}
    public Integer dataStorageMax{get;set;}
    public Integer dataStorageRem{get;set;}
    public String releaseName{get;set;} */
    
    List<String> objList = new List<String>();
    public TestDataCtrl(){
        for(Integer i=1;i<280;i++){
            objList.add('Account');
        }
    }
   
    public void test(){
        System.debug('In Test' + objList);
            ObjList(objList);
    }
    
    @future
    public static void ObjList(List<String> objList)
    {   
        System.debug('In future' + objList);
        List<Integer> countList = new List<Integer>();
        Integer i = 0;
        for(String obj : objList){
            String query = 'Select count() from '+ obj;
            System.debug(query);
            Integer objCount = Database.countQuery(query);
            countList.add(objCount);
            i++;
            if(i >199){
                break;
            }
        }
        System.debug('test' + countList);
        
    }
}