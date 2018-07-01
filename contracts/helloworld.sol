pragma solidity ^0.4.18;

contract helloworld {
    string message;

    constructor() public {
        message = "Hello World!!";
    }

    function setHelloworld(string _message) public {
        message = _message;
    }

    function getHelloworld() public view returns (string) {
        return message;
    }
}