@isTest
public class DataUpdateCtrlTest {
    @isTest
    public static void testDataUpdatewithValue(){
        DataUpdateCtrl dataUpdate = new DataUpdateCtrl();
        dataUpdate.DailyApiMax = 500;
        dataUpdate.DailyApiRem = 200;
        dataUpdate.dataStorageMax = 5;
        dataUpdate.dataStorageRem = 2;
        dataUpdate.dialyApiData();
    }
    @isTest
    public static void testDataUpdatewithoutValue(){
        AdminSetting__c adminSetting = new AdminSetting__c(Active_Flows__c = 5,Active_Force_Com_Site__c =1 ,Api_Request_Uses__c =200 ,Data_Storage_Uses__c = 5,Org_Release_Name__c ='Spring16' ,Api_Request__c = 15000,Char_Used_In_Code__c = 300000,Custom_Apps__c = 10,Custom_Objects__c = 400,Custom_Tabs__c = 100,Data_Storage__c = 250,Edition_Name__c ='Developer',Lic_Chatter_Free__c = 5,Lic_Customer_Community_Plus__c = 5000,Lic_Salesforce__c = 5,Release_Name__c= 'Spring16',Rules__c= 5);
        insert adminSetting;
        DataUpdateCtrl dataUpdate = new DataUpdateCtrl();
        dataUpdate.DailyApiMax = 500;
        dataUpdate.DailyApiRem = 200;
        dataUpdate.dataStorageMax = 5;
        dataUpdate.dataStorageRem = 2;
        DataUpdateCtrl.flagUpdate = true;
        dataUpdate.releaseName = 'Spring16';
        dataUpdate.dialyApiData();
    }
}