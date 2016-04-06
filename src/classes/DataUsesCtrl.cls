public class DataUsesCtrl {
    public Integer DailyApiMax{get;set;}
    public Integer DailyApiRem{get;set;}
    public Integer dataStorageMax{get;set;}
    public Integer dataStorageRem{get;set;}
    public static boolean flagUpdate = true;
    public String releaseName{get;set;}
    public integer count {get;set;}
    public DataUsesCtrl(){
        count = 0;
    }
    
    // dialyApiData method update value to AdminSetting__c object 
    public void dialyApiData(){
        count++;
        AdminSetting__c adminSetting;
        List<AdminSetting__c> adminSettingList = [SELECT Active_Flows__c,Active_Force_Com_Site__c,Api_Request_Uses__c,Data_Storage_Uses__c,Org_Release_Name__c,Api_Request__c,Char_Used_In_Code__c,Custom_Apps__c,Custom_Objects__c,Custom_Tabs__c,Data_Storage__c,Edition_Name__c,Lic_Chatter_Free__c,Lic_Customer_Community_Plus__c,Lic_Salesforce__c,Release_Name__c,Rules__c FROM AdminSetting__c];
        if(adminSettingList != null && !adminSettingList.isEmpty()){
            adminSetting = adminSettingList.get(0);
        }
        if(adminSetting != null){
            adminSetting.Api_Request_Uses__c = DailyApiMax - DailyApiRem;
            adminSetting.Data_Storage_Uses__c = dataStorageMax - dataStorageRem; 
            adminSetting.Org_Release_Name__c = releaseName;
            adminSetting.Api_Request__c= DailyApiMax;
            adminSetting.Data_Storage__c = dataStorageMax;
            update adminSetting;
        }else{
            adminSetting = new AdminSetting__c();
            adminSetting.Active_Flows__c = 0;
            adminSetting.Active_Force_Com_Site__c = 0; 
            adminSetting.Char_Used_In_Code__c = 0;
            adminSetting.Custom_Apps__c = 0;
            adminSetting.Custom_Objects__c = 0;
            adminSetting.Custom_Tabs__c = 0;
            adminSetting.Lic_Chatter_Free__c = 0;
            adminSetting.Lic_Customer_Community_Plus__c = 0;
            adminSetting.Lic_Salesforce__c = 0;
            adminSetting.Rules__c = 0;
            adminSetting.Edition_Name__c = '';
            adminSetting.Release_Name__c = '';
            adminSetting.Api_Request__c= DailyApiMax;
            adminSetting.Data_Storage__c = dataStorageMax;
            adminSetting.Api_Request_Uses__c = DailyApiMax - DailyApiRem;
            adminSetting.Data_Storage_Uses__c = dataStorageMax - dataStorageRem; 
            adminSetting.Org_Release_Name__c = releaseName;
            insert adminSetting;
        } 
       
    }
}