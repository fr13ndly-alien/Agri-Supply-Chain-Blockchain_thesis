/*
* previous partner must be transfer the proof to the next partner of the chain
* this make sure that exactly the next partner received goods
* and no one can access the barcode of  prev partner to add any data.
*/

pragma solidity ^0.4.25;

contract AgriSCM {
    struct TraceData {
        address owner;
        string dateCreate;
        string description;
        string previousBarcode;
        string publicBarcode;
    }
  
    struct Partner{
        address addr;
        string partnerid;
        string GLN;
        string name;
        string partnerAddress;
        string proof;
        string typeOfPartner;
    }
    
    // map of tracing barcode 
    mapping (string =>TraceData) private traceDatas;

    // map of trackingId to addresses to check if a trackingId can be use as a previousTrackingId 
    mapping (string => mapping (address => bool )) private isTransfered;
      
    // map of partners on the supply chain
    mapping (address => Partner) partners;
    
    // address of smart contract owner
    address _owner;
    
    event storeTraceDataCompleted(
        address from,
        string publicBarcode,
        string previousBarcode
    );

    event TransferCompleted(
        address from,
        address to,
        string publicBarcode
    );
    
    event addPartnerCompleted(
        string name,
        string proof
    );
    
    function AgriSCM() {
        _owner = msg.sender;
    }

    // add a proof to an existing tracking - requires that
    // the previousOwner transfered the ownership 
    function storeTraceData(string dateCreate,
        string description,
        string previousBarcode,
        string publicBarcode) returns(bool success) {
    
        // if we don't already have this tracingId
        if (hasAdded(publicBarcode)) {
        // already exists- return
            return false;
        }

        traceDatas[publicBarcode] = TraceData(msg.sender, dateCreate, 
                                        description, previousBarcode, publicBarcode);
        storeTraceDataCompleted(msg.sender, publicBarcode, previousBarcode);
        return true;
    }

    function transfer(string publicBarcode, address newOwner) returns(bool success) {
    
        if (hasAdded(publicBarcode)) {
            TraceData memory td = getTraceDataInternal(publicBarcode);
            if (msg.sender == td.owner) {

                // TODO: ask Beat- why not just change the owner in the TraceData?
                //why do we need the isTransfered mapping?
                // in this case, there might be multiple owners. Is this what we want?
                isTransfered[publicBarcode][newOwner] = true;
                TransferCompleted(msg.sender, newOwner, publicBarcode);
            }

            // TODO: ask Beat- why do we want to return true if the tx sender is not the owner? 
            // we didn't really transfer the ownership in this case...
            return true;
        }
        
        return false;
    }
    
    function addPartner(address addr, string partnerid, string GLN, string name, string partnerAddress, string proof, string typeOfPartner) returns (bool success){
    
        require(isOwner());
        partners[addr] = Partner(msg.sender, partnerid, GLN, name, partnerAddress, proof, typeOfPartner);
        addPartnerCompleted(name, proof);
        return true;
    }
        
    function getPartner(address addr) constant returns (string GLN,
        string name,
        string partnerAddress,
        string proof,
        string typeOfPartner) {
            Partner partner = partners[addr];
            GLN = partner.GLN;
            name = partner.name;
            partnerAddress = partner.partnerAddress;
            proof = partner.proof;
            typeOfPartner = partner.typeOfPartner;
        }
    
    function getContractOwner() constant returns (address owner){
        return _owner;
    }
    
    function isOwner() constant returns (bool result){
        return msg.sender == _owner;
    }

    // returns true if proof is stored
    function hasAdded(string publicBarcode) constant internal returns(bool exists) {
        return traceDatas[publicBarcode].owner != address(0);
    }


    // returns the proof (what is proof?????)
  function getTraceDataInternal(string publicBarcode) constant internal returns(TraceData traceData) {
    if (hasAdded(publicBarcode)) {
      return traceDatas[publicBarcode];
    }

    // proof doesn't exist, throw and terminate transaction
    throw;
  }
    
  function getTraceData(string publicBarcode) constant returns(address owner, string dateCreate,
                string description, string previousBarcode) {
    if (hasAdded(publicBarcode)) {
      TraceData memory td = getTraceDataInternal(publicBarcode);
      owner = td.owner;
      dateCreate = td.dateCreate;
      description = td.description;
      previousBarcode = td.previousBarcode;
      publicBarcode = td.publicBarcode;
    }
  }

  // returns the dateCreate of traceData
  function getdateCreate(string publicBarcode) constant returns(string dateCreate) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).dateCreate;
    }
  }

  // returns the previous barcode
  function getPreviousBarcode(string publicBarcode) constant returns(string previousBarcode) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).previousBarcode;
    }
  }
    // return the powner
  function getOwner(string publicBarcode) constant returns(address owner) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).owner;
    }
  }

  function getdDescription(string publicBarcode) constant returns(string description) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).description;
    }
  }
}