public class HerokuAppData {
    public AdminSetting__c adminSetting;
    public List<AdminSetting__c> adminSettingList;
    public String errorMessage{get;set;}
    public herokuAppData(){
        errorMessage = '';
        adminSettingList = [SELECT Id,Active_Flows__c,Active_Force_Com_Site__c,Api_Request__c,Char_Used_In_Code__c,Custom_Apps__c,Custom_Objects__c,Custom_Tabs__c,Data_Storage__c,Edition_Name__c,Lic_Chatter_Free__c,Lic_Customer_Community_Plus__c,Lic_Salesforce__c,Release_Name__c,Rules__c FROM AdminSetting__c Limit 1];
        if(adminSettingList != null && adminSettingList.size() >0){
            adminSetting = adminSettingList.get(0);
        }
    }
    
    //  hAppData method getting data from heroku app using http Callout and store value into AdminSetting__c object.
    public void hAppData(String orgEdition,String releaseName){
        String endPoint = 'http://ks-admin-plus.herokuapp.com/adminplus/limit_data?edition_name='+orgEdition+'&release_name='+releaseName;
        System.debug('fullEndPoint' + endPoint);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('Accept','application/json');
        req.setTimeout(60000);
        http h = new http();
        HttpResponse res = new HttpResponse();
        System.debug('request--' + req);
        res = h.send(req);
        
        System.debug(JSON.serialize(res.getBody()));
        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        System.debug('Test--'+ data);
        
        Map<String, Object> aSetting = (Map<String,Object>)data.get('admin_setting');
        if(aSetting != null && adminSetting != null){
        adminSetting.Active_Flows__c = Integer.valueOf(aSetting.get('active_flows'));
        adminSetting.Active_Force_Com_Site__c = Integer.valueOf(aSetting.get('active_force_com_sites')); 
       // adminSetting.Api_Request__c=Integer.valueOf(aSetting.get('api_requests'));
        adminSetting.Char_Used_In_Code__c=Integer.valueOf(aSetting.get('chars_used_in_code'));
        adminSetting.Custom_Apps__c=Integer.valueOf(aSetting.get('custom_apps'));
        adminSetting.Custom_Objects__c=Integer.valueOf(aSetting.get('custome_object'));
        adminSetting.Custom_Tabs__c=Integer.valueOf(aSetting.get('custom_tabs'));
      //  adminSetting.Data_Storage__c=Integer.valueOf(aSetting.get('data_storage'));
        adminSetting.Lic_Chatter_Free__c=Integer.valueOf(aSetting.get('lic_chatter_free'));
        adminSetting.Lic_Customer_Community_Plus__c=Integer.valueOf(aSetting.get('lic_customer_community_plus'));
        adminSetting.Lic_Salesforce__c=Integer.valueOf(aSetting.get('lic_salesforce'));
        adminSetting.Rules__c=Integer.valueOf(aSetting.get('rules'));
        adminSetting.Edition_Name__c=String.valueOf(aSetting.get('edition_name'));
        adminSetting.Release_Name__c=String.valueOf(aSetting.get('release_name'));
        upsert adminSetting;
        }else{
            errorMessage = 'Please check there is some problem in response';
        }
        
    } 
}