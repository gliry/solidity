//SPDX-License-Identifier: MIT
pragma solidity 0.8.15.0;

import "./Ownable.sol";
import "./ERC20.sol";

contract Documents is Ownable
{
    enum Type
    {
        Vaccination,
        Pcr
    }
    
    struct Doc 
    {
        string number;
        string ipfsCID;
        bool status;
        Type docType;
    }
    
    struct Org 
    {
        string nameOrg;
        bool approved;
    }

    struct Child 
    {
        uint idChild;
        address ownerAddress;
    }

    mapping(bytes32 => Doc) docs;
    address[] public organisations;
    address[] public organisationsApproved;
    mapping(address => Org) public mapOrgs;
    address[] public children;
    mapping(address => Child) public mapChildren;

    event addedRequest(address adr, string nameOrg);
    event newCenter(string nameOrg);
    event createdContract(uint id, address ownerAddress);
    event changedDoc(string number, string fio);


    function newChild(address ownerAddress) public onlyOwner returns(bool) 
    {
        uint idChild = children.length;
        address newContract = address(new ChildContract(idChild, ownerAddress, address(this)));
        Child memory tempData = Child({
            idChild: idChild,
            ownerAddress: ownerAddress
        });
        mapChildren[newContract] = tempData;
        children.push(newContract);
        emit createdContract(idChild, ownerAddress);
        return true;
    }

    function getChildrenCount() public view returns(uint)
    {
        return children.length;
    }

    function addRequest(string memory nameOrg) public payable
    {
        require(strLength(nameOrg) > 5 , "Name of your organisation is too short. Request is cancelled.");
        require(msg.value >= 0.1 ether, "Not enough value to add request.");
        organisations.push(_msgSender());
        Org memory tempData = Org({
            nameOrg: nameOrg,
            approved: false
        });
        mapOrgs[_msgSender()] = tempData;
        emit addedRequest(_msgSender(), nameOrg);
    }

    function approveRequest(address addrOrg) public onlyOwner returns(bool)
    {
        require(strLength(mapOrgs[addrOrg].nameOrg) > 0 , "Organisation not found. Approve is cancelled.");
        require(mapOrgs[addrOrg].approved == false, "This request is allready approved.");
        mapOrgs[addrOrg].approved = true;
        organisationsApproved.push(addrOrg);
        newChild(addrOrg);
        address payable addrOrgP  = payable(addrOrg);
        addrOrgP.transfer(0.1 ether);
        emit newCenter(mapOrgs[addrOrg].nameOrg);
        return true;
    }

    function strLength (string memory myText) internal pure returns (uint ) 
    {
        bytes memory myRes =  abi.encodePacked(myText);
        return myRes.length;
    }

    function withdrawMoney() public onlyOwner
    {
        address payable ownerP = payable(_owner);
        ownerP.transfer(address(this).balance);
    }

    function addCert(string memory fio, string memory docNum, string memory ipfsCID) external 
    {
        require(getRights(_msgSender()) == true, "Unauthorized access is prohibited");
        bytes32 hashFIO =  keccak256(abi.encodePacked(fio, Type.Vaccination));
        Doc memory tempData = Doc({
            number: docNum,
            ipfsCID: ipfsCID,
            status: true,
            docType: Type.Vaccination
        });
        docs[hashFIO]=tempData;
        emit changedDoc(docNum, fio);
    }

    function addTest(string memory fio, string memory docNum, string memory ipfsCID) external 
    {
        require(getRights(_msgSender()) == true, "Unauthorized access is prohibited");
        bytes32 hashFIO =  keccak256(abi.encodePacked(fio, Type.Vaccination));
        Doc memory tempData = Doc({
            number: docNum,
            ipfsCID: ipfsCID,
            status: true,
            docType: Type.Pcr
        });
        docs[hashFIO]=tempData;
        emit changedDoc(docNum, fio);
    }

    function showDoc(uint8 docType, string memory fio) public view returns(Doc memory)
    {
        bytes32 hashFIO =  keccak256(abi.encodePacked(fio, docType));
        return docs[hashFIO];
    }

    function getRights(address addrSender) internal view returns(bool)
    {
        return mapOrgs[mapChildren[addrSender].ownerAddress].approved;
    }
}

contract ChildContract {

    address public owner;
    uint public idChild;
    Documents mainContract;

 
    constructor(uint id, address ownerAddress, address documents) 
    {
        idChild = id;
        owner = ownerAddress;
        mainContract = Documents(documents);
    }

    modifier onlyOwner() 
    {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }
    
    function addCert(string memory fio, string memory docNum, string memory ipfsCID) public onlyOwner 
    {
        mainContract.addCert(fio, docNum, ipfsCID);
    }

    function addTest(string memory fio, string memory docNum, string memory ipfsCID) public onlyOwner 
    {
        mainContract.addTest(fio, docNum, ipfsCID);
    }

}