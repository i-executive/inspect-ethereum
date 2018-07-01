pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ECRecovery.sol";

contract AccountValidator {

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
        return ECRecovery.recover(digest, signature);
    }

    function validateAccount(bytes32 digest, bytes signature, address account) public pure returns (bool) {
        return getAccount(digest, signature) == account;
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