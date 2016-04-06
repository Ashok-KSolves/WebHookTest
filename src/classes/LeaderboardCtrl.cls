public class LeaderboardCtrl {
    
    public Id team { get; set; }
    public List<SelectOption> teams { get; set; }
    public List<TeamMember> firstTeamMembers { get; set; }
    public List<TeamMember> secondTeamMembers { get; set; }
    public String firstTeamLabel { get; set; }
    public String secondTeamLabel { get; set; }
    
    public LeaderboardCtrl() {
        
        teams = new List<SelectOption>();
        firstTeamMembers = new List<TeamMember>();
        secondTeamMembers = new List<TeamMember>();
        initialLoad();
    }
    
    public void initialLoad() {
        
        Period currentQuarter = [SELECT StartDate, EndDate FROM Period WHERE Type='Year' AND StartDate = THIS_FISCAL_YEAR];
        
        Map<Id, Map<Id, TeamMember>> teamWiseMembers = new Map<Id, Map<Id, TeamMember>>();
        Set<Id> users = new Set<Id>();
        Map<Id, Sales_Team__c> salesTeams = new Map<Id, Sales_Team__c>([SELECT Id, Name FROM Sales_Team__c]);
        Map<Id, String> userToTeam = new Map<Id, String>();
        for(Sales_Team_Member__c member : [SELECT Sales_Team__c, Sales_Team__r.Name, Sales_Team_Member__c FROM Sales_Team_Member__c ORDER BY Sales_Team__r.Name]) {
            userToTeam.put(member.Sales_Team_Member__c, member.Sales_Team__c);
        }
        users = userToTeam.keySet();
        List<Opportunity> opportunities = [SELECT Amount, StageName, Owner.Name, Owner.UserRole.Name FROM Opportunity WHERE OwnerId IN :users AND CloseDate >=: currentQuarter.StartDate AND CloseDate <=: currentQuarter.EndDate];
        Map<Id, Integer> userToAccounts = new Map<Id, Integer>();
        for(AggregateResult agr : [SELECT OwnerId owner, COUNT(Id) FROM Account WHERE OwnerId IN :users GROUP BY OwnerId]) {
            
            userToAccounts.put((Id)agr.get('owner'), (Integer)agr.get('expr0'));
        }
        
        //Map<Id, TeamMember> teamMembersMap = new Map<Id, TeamMember>();
        for(Opportunity opp : opportunities) {
            
            TeamMember tMember;
            Id teamId = userToTeam.get(opp.OwnerId);
            if(teamWiseMembers.containsKey(teamId)) {
                if(teamWiseMembers.get(teamId).containsKey(opp.OwnerId)) {
                    tMember = teamWiseMembers.get(teamId).get(opp.OwnerId);
                } else {
                    Map<Id, TeamMember> userToMember = teamWiseMembers.get(teamId);
                    tMember = new TeamMember();
                    userToMember.put(opp.OwnerId, tMember);
                }
            } else {
                tMember = new TeamMember();
                Map<Id, TeamMember> tempMap = new Map<Id, TeamMember>();
                tempMap.put(opp.OwnerId, tMember);
                teamWiseMembers.put(teamId, tempMap);
            }
            /*if(teamMembersMap.containsKey(opp.OwnerId)) {
                tMember = teamMembersMap.get(opp.OwnerId);
            } else {
                tMember = new TeamMember();
            }*/
            tMember.name = opp.Owner.Name;
            tMember.role = opp.Owner.UserRole.Name;
            tMember.opportunities++;
            tMember.target += opp.Amount;
            if(opp.StageName == 'Closed Won') {
                tMember.targetAchieved += opp.Amount;
            }
            if(userToAccounts.containsKey(opp.OwnerId)) {
                
                tMember.accounts = userToAccounts.get(opp.OwnerId);
            }
            //teamMembersMap.put(opp.OwnerId, tMember);
            
        }
        //firstTeamLabel = userToTeam.values().get(0)
        List<Id> teamsIds = new List<Id>(teamWiseMembers.keySet());
        firstTeamLabel = salesTeams.get(teamsIds.get(0)).Name;
        secondTeamLabel = salesTeams.get(teamsIds.get(1)).Name;
        firstTeamMembers = teamWiseMembers.get(teamsIds.get(0)).values();
        secondTeamMembers = teamWiseMembers.get(teamsIds.get(1)).values();
        firstTeamMembers.sort();
        secondTeamMembers.sort();
        }
        
    public class TeamMember implements Comparable {
        
        public String name { get; set; }
        public String role { get; set; }
        public Integer accounts { get; set; }
        public Integer opportunities { get; set; }
        public Decimal target { get; set; }
        public Decimal targetAchieved { get; set; }
        public String formattedTarget { get { return target.format(); } set; }
        public String formattedTargetAchieved { get { return targetAchieved.format(); } set; }
        
        public TeamMember() {
            
            accounts = 0;
            opportunities = 0;
            target = 0.0;
            targetAchieved = 0.0;
            
        }
        
        public Integer compareTo(Object compareTo) {
  
            TeamMember tMember = (TeamMember)compareTo;
            if(targetAchieved > tMember.targetAchieved) {
                return -1;
            }
            if(targetAchieved == tMember.targetAchieved) {
                return 0;
            }
            return 1;
            /*
            TeamMember tMember = (TeamMember)compareTo;
            if(((targetAchieved*100)/target) > ((tMember.targetAchieved*100)/tMember.target)) {
                return -1;
            }
            if(((targetAchieved*100)/target) == ((tMember.targetAchieved*100)/tMember.target)) {
                return 0;
            }
            return 1;
*/
        }
        
    }
}