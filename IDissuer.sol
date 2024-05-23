pragma solidity ^0.8.0;

contract IDIssuer {
    struct Credential {
        string did;
        string studentName;
        string universityName;
        string degree;
        uint256 issueDate;
    }
    
    mapping(address => Credential) public credentials;
    address public university;

    event CredentialIssued(address indexed student, string did);

    constructor(address _university) {
        university = _university;
    }

    modifier onlyUniversity() {
        require(msg.sender == university, "Only university can issue credentials");
        _;
    }

    function issueCredential(
        address student,
        string memory did,
        string memory studentName,
        string memory universityName,
        string memory degree,
        uint256 issueDate
    ) public onlyUniversity {
        credentials[student] = Credential(did, studentName, universityName, degree, issueDate);
        emit CredentialIssued(student, did);
    }

    function getCredential(address student) public view returns (Credential memory) {
        return credentials[student];
    }
}
