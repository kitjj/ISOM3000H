pragma solidity ^0.8.0;

interface IIDIssuer {
    function getCredential(address student) external view returns (string memory, string memory, string memory, uint256);
}

interface IDigitalWallet {
    function getIdentity(address user) external view returns (string memory, string memory, string memory, string[] memory);
}

contract Verifier {
    IIDIssuer public idIssuer;
    IDigitalWallet public digitalWallet;

    event VerificationRequest(address indexed verifier, address indexed student);
    event VerificationResult(address indexed verifier, address indexed student, bool verified);

    constructor(address _idIssuer, address _digitalWallet) {
        idIssuer = IIDIssuer(_idIssuer);
        digitalWallet = IDigitalWallet(_digitalWallet);
    }

    function verifyCredential(address student) public returns (bool) {
        (, string memory studentName, string memory universityName, ) = idIssuer.getCredential(student);
        (string memory did, , , string[] memory credentials) = digitalWallet.getIdentity(student);
        
        bool verified = false;

        for (uint i = 0; i < credentials.length; i++) {
            if (keccak256(abi.encodePacked(credentials[i])) == keccak256(abi.encodePacked(did))) {
                verified = true;
                break;
            }
        }

        emit VerificationResult(msg.sender, student, verified);
        return verified;
    }
}
