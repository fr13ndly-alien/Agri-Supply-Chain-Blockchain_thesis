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
    
    constructor() public {
        _owner = msg.sender;
    }

    // add a proof to an existing tracking - requires that
    // the previousOwner transfered the ownership 
    function storeTraceData(string memory dateCreate,
        string memory description,
        string memory previousBarcode,
        string memory publicBarcode) public returns(bool success){
    
        // if we don't already have this tracingId
        if (hasAdded(publicBarcode)) {
        // already exists- return
            return false;
        }

        traceDatas[publicBarcode] = TraceData(msg.sender, dateCreate, 
                                        description, previousBarcode, publicBarcode);
        emit storeTraceDataCompleted(msg.sender, publicBarcode, previousBarcode);
        return true;
    }

    function transfer(string memory publicBarcode, address newOwner) public returns(bool success) {
    
        if (hasAdded(publicBarcode)) {
            TraceData memory td = getTraceDataInternal(publicBarcode);
            if (msg.sender == td.owner) {

                // TODO: ask Beat- why not just change the owner in the TraceData?
                //why do we need the isTransfered mapping?
                // in this case, there might be multiple owners. Is this what we want?
                isTransfered[publicBarcode][newOwner] = true;
                emit TransferCompleted(msg.sender, newOwner, publicBarcode);
            }

            // TODO: ask Beat- why do we want to return true if the tx sender is not the owner? 
            // we didn't really transfer the ownership in this case...
            return true;
        }
        
        return false;
    }
    
    function addPartner(address addr, 
        string memory partnerid, 
        string memory GLN, 
        string memory name, 
        string memory partnerAddress, 
        string memory proof, 
        string memory typeOfPartner) public returns (bool success){
    
        require(isOwner());
        partners[addr] = Partner(msg.sender, partnerid, GLN, name, partnerAddress, proof, typeOfPartner);
        emit addPartnerCompleted(name, proof);
        return true;
    }
        
    function getPartner(address addr) public returns (string memory GLN,
        string memory name,
        string memory partnerAddress,
        string memory proof,
        string memory typeOfPartner) {
            Partner memory partner = partners[addr];
            GLN = partner.GLN;
            name = partner.name;
            partnerAddress = partner.partnerAddress;
            proof = partner.proof;
            typeOfPartner = partner.typeOfPartner;
        }
    
    function getContractOwner() public returns (address owner){
        return _owner;
    }
    
    function isOwner() public returns (bool result){
        return msg.sender == _owner;
    }

    // returns true if proof is stored
    function hasAdded(string memory publicBarcode) internal returns(bool exists) {
        return traceDatas[publicBarcode].owner != address(0);
    }


    // returns the proof (what is proof?????)
  function getTraceDataInternal(string memory publicBarcode) internal returns(TraceData memory traceData) {
    if (hasAdded(publicBarcode)) {
      return traceDatas[publicBarcode];
    }

    // proof doesn't exist, throw and terminate transaction
    revert();
  }
    
    function getTraceData(string memory publicBarcode) public returns(address owner, 
                                        string memory dateCreate, 
                                        string memory description,
                                        string memory previousBarcode) {
        address _owner; 
        string memory _dateCreate; 
        string memory _description; 
        string memory _previousBarcode; 
        string memory _publicBarcode;
        if (hasAdded(publicBarcode)) {
            TraceData memory td = getTraceDataInternal(publicBarcode);
            _owner = td.owner;
            _dateCreate = td.dateCreate;
            _description = td.description;
            _previousBarcode = td.previousBarcode;
            _publicBarcode = td.publicBarcode;
        }
        return (_owner, _dateCreate, _description, _previousBarcode);
  }

  // returns the dateCreate of traceData
  function getdateCreate(string memory publicBarcode) public returns(string memory dateCreate) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).dateCreate;
    }
  }

  // returns the previous barcode
  function getPreviousBarcode(string memory publicBarcode)public returns(string memory previousBarcode) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).previousBarcode;
    }
  }
    // return the powner
  function getOwner(string memory publicBarcode) public returns(address owner) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).owner;
    }
  }

  function getdDescription(string memory publicBarcode) public returns(string memory description) {
    if (hasAdded(publicBarcode)) {
      return getTraceDataInternal(publicBarcode).description;
    }
  }
}