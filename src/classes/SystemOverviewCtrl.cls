public class SystemOverviewCtrl {
 
    public Integer customObjCount{get;set;}
    public Integer customSettingCount{get;set;}
    public Integer apexClassesCount{get;set;}
    public Integer apexTriggersCount{get;set;}
    public Integer apexPagesCount{get;set;}
    public Integer DailyApiRequests{get;set;}
    public Integer DataStorageUsed{get;set;}
    public Integer DailyApiMax{get;set;}
    public Integer DailyApiRem{get;set;}
    public Integer dataStorageMax{get;set;}
    public Integer dataStorageRem{get;set;}
    public Integer customTabCount{get;set;}
    public Integer siteCount{get;set;}
    public Integer sfCount{get;set;}
    public Integer cfCount{get;set;}
    public Integer ccpCount{get;set;}
    public Integer customAppCount{get;set;}
    public Integer codeUsedCount{get;set;}
    public Integer visualWorkFlow{get;set;}
    public Map<String,Integer> fieldWithValueMap{get;set;}
    public List<AdminSetting__c> adminSettingList{get;set;}
    public String errorMsg{get;set;}
    public String orgEdition{get;set;}
    public String releaseName{get;set;}
    
    public SystemOverviewCtrl(){
        DailyApiMax = 0;
        DailyApiRem = 0;
        dataStorageMax = 0;
        dataStorageRem = 0;
        customObjCount=0;
        customSettingCount = 0;
        customTabCount=0;
        DataStorageUsed=0;
        DailyApiRequests= 0;
        sfCount = 0;
        cfCount = 0;
        ccpCount = 0;
        customAppCount =0;
        codeUsedCount = 0;
        releaseName = '';
       
        // custom object and setting count
        DescribeSObjectResult sObjectResult;
        for(Schema.SObjectType sObjectType : Schema.getGlobalDescribe().Values()){
            sObjectResult = sObjectType.getDescribe();
            if(sObjectResult.isAccessible() && sObjectResult.isCreateable() && sObjectResult.isUpdateable() && sObjectResult.isDeletable() && sObjectResult.isUndeletable()){     
               System.debug('Test:'+ sObjectResult.getLabel() );
                if((sObjectResult.getName()).endsWith('__c')){
                    if(sObjectResult.isCustomSetting()){
                        customSettingCount++;
                    }
                    customObjCount++;
                }
            }
        }  
        
       // custom tab count
        Set<String> cTabLableSet = new Set<String>();
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        for(DescribeTabSetResult tsr : tabSetDesc) {
            String appLabel = tsr.getLabel();
                List<Schema.DescribeTabResult> tabDesc = tsr.getTabs();
                for(Schema.DescribeTabResult tr : tabDesc) {
                    if(tr.isCustom()){
                        cTabLableSet.add(tr.getLabel());
                    }
                }       
        }
        customTabCount = cTabLableSet.size();
        
        // Most used licenses count
        List<AggregateResult> aggrList = [select count(Id) rc, profile.userlicense.name name from user  where user.IsActive = true group by profile.userlicense.name];
        for(AggregateResult ar : aggrList){
            if(ar.get('name')== 'Salesforce'){
               // sfCount = Integer.valueOf(ar.get('rc'));
            }else if(ar.get('name')== 'Chatter Free'){
                cfCount = Integer.valueOf(ar.get('rc'));
            }else if(ar.get('name')== 'CUSTOMER COMMUNITY PLUS'){
                ccpCount = Integer.valueOf(ar.get('rc'));
            }
        }
        
        // Code used count
        List<AggregateResult> apexCharSum =  [SELECT Sum(LengthWithoutComments) cCharSum  FROM ApexClass];
        List<AggregateResult> triggerCharSum =  [SELECT Sum(LengthWithoutComments) tCharSum FROM ApexTrigger];
        if(apexCharSum[0].get('cCharSum') != null && triggerCharSum[0].get('tCharSum') != null){
            codeUsedCount = (Integer.valueOf(apexCharSum[0].get('cCharSum'))  + Integer.valueOf(triggerCharSum[0].get('tCharSum')) );
        }else if(apexCharSum[0].get('cCharSum') != null){
            codeUsedCount = Integer.valueOf(apexCharSum[0].get('cCharSum'));
        }else if(triggerCharSum[0].get('tCharSum') != null){
            codeUsedCount = Integer.valueOf(triggerCharSum[0].get('tCharSum')); 
        }
             
        // Custom app Count
        ApexClass apClass = [SELECT NamespacePrefix FROM ApexClass Limit 1];
        for(AppMenuItem appManu : [SELECT NamespacePrefix,StartUrl FROM AppMenuItem]){
            if(appManu.NamespacePrefix == null || appManu.NamespacePrefix == '' || (appManu.NamespacePrefix == apClass.NamespacePrefix && appManu.StartUrl != NULL)){
                customAppCount++;
            }
        }
        
        // Getting value from AdminSetting__c object stored at the time of ajax call
        AdminSetting__c adminSetting = [SELECT Active_Flows__c,Active_Force_Com_Site__c,Api_Request_Uses__c,Data_Storage_Uses__c,Org_Release_Name__c,Api_Request__c,Char_Used_In_Code__c,Custom_Apps__c,Custom_Objects__c,Custom_Tabs__c,Data_Storage__c,Edition_Name__c,Lic_Chatter_Free__c,Lic_Customer_Community_Plus__c,Lic_Salesforce__c,Release_Name__c,Rules__c FROM AdminSetting__c Limit 1];
        if(adminSetting != null){
            DailyApiRequests = Integer.valueOf(adminSetting.Api_Request_Uses__c);
            DataStorageUsed = Integer.valueOf(adminSetting.Data_Storage_Uses__c);
            releaseName = adminSetting.Org_Release_Name__c;
        }
        
        // Getting count using soql
        apexClassesCount = [SELECT count() FROM ApexClass];
        apexTriggersCount = [SELECT count() FROM ApexTrigger];
        apexPagesCount = [SELECT count() FROM ApexPage];
        siteCount= [SELECT count() FROM Site];
        visualWorkFlow = [SELECT count() FROM FlowInterview];
        Organization org = [SELECT OrganizationType FROM Organization Limit 1];
        String orgEd = org.OrganizationType;
        orgEdition = orgEd.remove(' ');
        
        fieldWithValueMap = new Map<String,Integer>();
        fieldWithValueMap.put('Active_Flows__c', visualWorkFlow);
        fieldWithValueMap.put('Active_Force_Com_Site__c', siteCount);
        fieldWithValueMap.put('Api_Request__c', DailyApiRequests);
        fieldWithValueMap.put('Char_Used_In_Code__c', codeUsedCount);
        fieldWithValueMap.put('Custom_Apps__c', customAppCount);
        fieldWithValueMap.put('Custom_Objects__c', customObjCount);
        fieldWithValueMap.put('Custom_Tabs__c', customTabCount );
        fieldWithValueMap.put('Data_Storage__c', DataStorageUsed );
        fieldWithValueMap.put('Lic_Chatter_Free__c', cfCount);
        fieldWithValueMap.put('Lic_Customer_Community_Plus__c', ccpCount);
        fieldWithValueMap.put('Lic_Salesforce__c', sfCount);
        fieldWithValueMap.put('Apex_Classes', apexClassesCount);   
        fieldWithValueMap.put('Apex_Pages', apexPagesCount); 
        
		 
       /* fieldWithValueMap.put('Custom_Settings', customSettingCount); 
        fieldWithValueMap.put('Apex_Triggers', apexTriggersCount);  */
    }
    
    // SynDate method feteching data from heroku app using httpCallOut and store data in object.
    public void syncData(){
        if(releaseName != ''){
           releaseName = releaseName.remove(' \''); 
        }
        HerokuAppData hApp = new HerokuAppData();
        hApp.hAppData(orgEdition,releaseName);
        errorMsg = hApp.errorMessage;
    }
    
    // getPieData method return data with max and used count
    public List<List<pieData>> getPieData(){
        errorMsg = '';
        Integer rmCount = 0, uCount = 0;
        List<List<pieData>> listOfPieData = new List<List<pieData>>();
        
        if(fieldWithValueMap != null ){  
            System.debug('fieldWithValueMap12' + fieldWithValueMap);
            List<String> objField = new List<String>();
            
            adminSettingList = [SELECT Active_Flows__c,Active_Force_Com_Site__c,Api_Request__c,Char_Used_In_Code__c,Custom_Apps__c,Custom_Objects__c,Custom_Tabs__c,Data_Storage__c,Edition_Name__c,Lic_Chatter_Free__c,Lic_Customer_Community_Plus__c,Lic_Salesforce__c,Release_Name__c,Rules__c FROM AdminSetting__c];
            
            if(adminSettingList != null && !adminSettingList.isEmpty()){
                Set<String> ObjfieldSet = new Set<String>{'Custom_Objects__c','Custom_Apps__c','Api_Request__c','Custom_Tabs__c','Active_Flows__c','Active_Force_Com_Site__c','Char_Used_In_Code__c','Data_Storage__c','Edition_Name__c','Lic_Chatter_Free__c','Lic_Customer_Community_Plus__c','Lic_Salesforce__c','Release_Name__c'};
                    
                AdminSetting__c adminSetting = adminSettingList.get(0);
                System.debug('Test ::'+ adminSetting.Release_Name__c);
               
                if(adminSetting.Release_Name__c != Null ){
                List<String> fieldList = new List<String>{'Custom_Objects__c','Custom_Apps__c','Api_Request__c','Custom_Tabs__c','Active_Flows__c','Active_Force_Com_Site__c','Char_Used_In_Code__c','Data_Storage__c','Edition_Name__c','Lic_Chatter_Free__c','Lic_Customer_Community_Plus__c','Lic_Salesforce__c','Release_Name__c','Apex_Classes','Apex_Pages','Custom_Settings','Apex_Triggers'};
                    
                    for(String field : fieldList){
                        System.debug('1----'+ field);
                        
                        String chartL = field.contains('__c') ? field.substringBefore('__c') : field;
                        String chartLabel = chartL.replaceAll('_', ' ');
                        
                        if(fieldWithValueMap.containsKey(field)){
                            List<pieData> pieDataList = new List<pieData>();
                            
                            if(ObjfieldSet.contains(field)){
                                
                                rmCount = Integer.valueOf(adminSetting.get(field)) - fieldWithValueMap.get(field);
                                pieDataList.add(new pieData(rmCount, ' '+ rmCount ,chartLabel));
                                
                            }
                            uCount = fieldWithValueMap.get(field);
                            
                            if(fieldWithValueMap.get(field) == 0){
                                pieDataList.add(new pieData(uCount, '',chartLabel));
                            }else{
                                pieDataList.add(new pieData(uCount, ' ' + uCount,chartLabel));
                            }
                            listOfPieData.add(pieDataList);
                        }
                    }
                }else{
                    errorMsg ='Please click on Sync Data button to update your database';
                    return null;
                    System.debug('ErroMsg12 : '+ errorMsg);
                } 
            }else{
               
                errorMsg ='Please click on Sync Data button to update your database';
                return null;
                System.debug('ErroMsg : '+ errorMsg);
            }
        }
        System.debug('listOfPieData::'+listOfPieData);
        return listOfPieData;
    }
    
    //Inner class
    public class pieData{
        public Integer usedVal{get;set;}
        public String maxVal{get;set;}
        public String chartLabel{get;set;}
        public pieData(Integer usedVal,String maxVal,String chartLabel){
            this.usedVal = usedVal != NULL ? usedVal : 0;
            this.maxVal = (maxVal != NULL  && maxVal != '') ? maxVal : '0';
            this.chartLabel = chartLabel;
        }
    } 
}