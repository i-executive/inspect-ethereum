pragma solidity ^0.4.23;

contract AccountValidator2 {

    constructor() public {
    }

    function test() external pure returns(string){
        return "this is account validator v01.";
    }

    function getDigestBytes32(bytes message) public pure returns(bytes32) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedDigest = keccak256(abi.encodePacked(prefix, message));
        return prefixedDigest;
    }

    // function getDigest(bytes message) public pure returns(bytes32) {
    //     bytes memory prefix = "\x19Ethereum Signed Message:\n"+uint2str(message.length);
    //     bytes32 prefixedDigest = keccak256(abi.encodePacked(prefix, message));
    //     return prefixedDigest;
    // }

    // function getAccount(string msg, bytes signature) public pure returns(address) {

    // }

    function getAccount(bytes32 digest, bytes signature) public pure returns (address) {
        return recovery(digest, signature);
    }

    function validateAccount(bytes32 digest, bytes signature, address account) public pure returns (bool) {
        return getAccount(digest, signature) == account;
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

    function uint2str(uint i) internal pure returns(string){
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        uint l = i;
        while (l != 0){
            bstr[k--] = byte(48 + l % 10);
            l /= 10;
        }
        return string(bstr);
    }

}