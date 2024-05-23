pragma solidity ^0.8.0;

contract DigitalWallet {
    struct Identity {
        string did;
        string name;
        string email;
        string[] credentials;
    }

    mapping(address => Identity) public identities;

    event IdentityUpdated(address indexed user, string did);

    function createIdentity(
        address user,
        string memory did,
        string memory name,
        string memory email
    ) public {
        identities[user] = Identity(did, name, email, new string[](0));
        emit IdentityUpdated(user, did);
    }

    function addCredential(address user, string memory credential) public {
        identities[user].credentials.push(credential);
        emit IdentityUpdated(user, identities[user].did);
    }

    function getIdentity(address user) public view returns (Identity memory) {
        return identities[user];
    }
}
