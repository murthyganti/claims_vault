pragma solidity ^0.4.12;


contract ClaimazonContract {
    
    struct Claim {
        uint policy_id;
        uint claim_id;
        uint claim;
        string peril_type;
        string name;
        string loss_date;
        string status;
    }
    
    struct Policy {
        uint id;
        uint agreed_claim;
        uint max_limit;
        uint premium;
        string start;
        string end;
        string policy_type;
        bool isLive;
        
        mapping (uint => Claim) claimsAt;
        uint claimsCounter;
    }
    mapping (uint => Policy) policyAt;
    
    
    /*
        CREATION OF POLICY 
    */
    
    function proposePolicy(uint _id, string _start, string _end, string _type) {
        // Insured proposes a policy
        Policy policy = policyAt[_id];
        policy.id = _id;
        policy.start = _start;
        policy.end = _end;
        policy.policy_type = _type;
    }
    
    function proposePrice(uint _id, uint price) {
        // Insurer proposes a price after a policy has been submitted
        Policy policy = policyAt[_id];
        policy.max_limit = price;
    }
    
    function acceptPolicy(uint _id) {
        // Insured accepts the price proposed by the Insurer => Policy effective !
        Policy policy = policyAt[_id];
        policy.isLive = true;
    }
    
    /*
        CLAIM OF POLICY 
    */

    function claim(uint _id, uint _claim, string _type, string _name, string _date ){
        Policy policy = policyAt[_id];
        Claim claim = policy.claimsAt[policy.claimsCounter];
        
        claim.claim = _claim;
        claim.peril_type = _type;
        claim.name = _name;
        claim.loss_date = _date;
        policy.claimsCounter++;
    }
    
    /*
        ACTIONS ON POLICY 
    */
    
    function actionOnPolicy(uint _policyId, uint _claimId, string _status ) {
        // Insurer or expert makes an action on claim
        Policy  policy = policyAt[_policyId];
        Claim claim = policy.claimsAt[_claimId];
        claim.status = _status;
    }

    function getPolicy(uint _id) constant returns(uint, uint, uint, uint, 
        string, string, string, bool){
        Policy policy = policyAt[_id];
        return (
            policy.id,
            policy.agreed_claim,
            policy.max_limit,
            policy.premium,
            policy.start,
            policy.end,
            policy.policy_type,
            policy.isLive
        );
    }

    function getClaim(uint _policyId, uint _claimId) constant 
        returns(uint, uint, uint, string, string, string, string){
        Policy  policy = policyAt[_policyId];
        Claim claim = policy.claimsAt[_claimId];
        return (
            claim.policy_id,
            claim.claim_id,
            claim.claim,
            claim.peril_type,
            claim.name,
            claim.loss_date,
            claim.status
        );
    }
}