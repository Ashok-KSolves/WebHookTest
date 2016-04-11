public class ChartTestCtrl {
    List<Integer> aaa= new List<Integer>{5,6,7,8};
        List<String> bbb= new List<String>{'50','60','70','80'};
            List<String> ccc= new List<String>{'test 1','test 2','test 3','test 4'};
        
    public List<List<pieData>> getPieData(){
	System.debug('test');
	System.debug('test');
        List<List<pieData>> listOfPieData = new List<List<pieData>>();
        List<pieData> a = new List<pieData>();
        listOfPieData.add(a);
        for(Integer i =0 ; i<4;i++ ){
            a.add(new pieData(aaa[i],bbb[i],ccc[i])); 
        } 
        return listOfPieData;
    }
    public void refreshFn(){        aaa= new List<Integer>{5,6,7,8};
        bbb= new List<String>{'500','600','700','800'};
    }
    public class pieData{
        public Integer usedVal{get;set;}
        public String maxVal{get;set;}
        public String chartLabel{get;set;}
        public pieData(Integer usedVal,String maxVal,String chartLabel){
            this.usedVal = usedVal;
            this.maxVal = maxVal;
            this.chartLabel = chartLabel;
        }
    } 
}