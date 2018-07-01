pragma solidity ^0.4.18;

contract AccountValidator3 {
    /* Constructor */
    function AccountValidator3() public {

    }
    
    function getAccount(bytes32 d, uint8 v, bytes32 r, bytes32 s) public pure returns(address) {
        address a = ecrecover(d,v,r,s);
        return a;
    }
}