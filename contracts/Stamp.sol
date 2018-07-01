
pragma solidity ^0.4.18;

contract Stamp {


    struct Signer {
        address account;
        bytes   signature;
    }

    struct Document {
        bytes32 documentId;
        string uri;
        string revision;
        bytes32 documentHash;
        Signer owner;
        // Signer[] signers;
    }

    // key documentId 
    // value Document
    mapping(bytes32 => Document) public documents;
    mapping(bytes32 => Signer[]) public signers;

    string public name;

    bytes32 public lastRegisterDocId;

    /* Constructor */
    function Stamp() public {

    }

    function setName(string _name) public{
        name = _name;
    } 

    function registerDocument( string uri, string revision, bytes32 docHash, address _owner, bytes signature) public  {
        bytes32 h = keccak256(uri, revision);
        Signer memory owner = Signer( _owner, signature);

        Document memory d = Document(h, uri, revision, docHash, owner);
        // d.documentId = h;
        // d.uri = uri;
        // d.revision = revision;
        // d.documentHash = docHash;

        documents[h] = d;

        lastRegisterDocId = h;

    }

    function getDocument(bytes32 docId) public view returns(bytes32, string, string, bytes32){
        Document storage doc = documents[docId];

        return(doc.documentId, doc.uri, doc.revision, doc.documentHash);
    }

    function signDocument(bytes32 docId, address account, bytes sign) public  {
        Signer memory signer = Signer(account, sign);
        Signer[] storage signersOnDoc = signers[docId];

        signersOnDoc.push(signer);
    }

    function validateSign(bytes32 docId, address account) public view returns(bool) {
        // ecrecoverでaddressを求めて比較する。

        Document storage doc = documents[docId];
        address s = recovery(docId, doc.owner.signature);


        return(s == account);

    }    

    function getDocumentSigners(bytes32 docId) public view returns (address[]) {

        Signer[] storage signersOnDoc = signers[docId];
        uint8 len = uint8(signersOnDoc.length);
        address[] memory list = new address[](len);

        for(uint i = 0; i < len; i++){
            list[i] = signersOnDoc[i].account;
        }

        return(list);
    }
 

    function recovery(bytes32 digest, bytes sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        //Check the signature length
        if (sig.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(digest, v, r, s);
        }
    }
}