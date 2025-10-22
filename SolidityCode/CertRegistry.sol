// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CertRegistry {
    // --- admin / ownership ---
    address public owner;
    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }

    constructor() { owner = msg.sender; }

    // --- certificate storage ---
    struct Cert { address issuer; uint256 issuedAt; }
    mapping(bytes32 => Cert) public certs;

    event Issued(bytes32 indexed certHash, address indexed issuer, uint256 when);

    // --- low-level API (precomputed hash) ---
    function issue(bytes32 certHash) public payable {
        require(msg.value >= 0.001 ether, "Fee: 0.001 ETH required");
        require(certs[certHash].issuedAt == 0, "Already issued");
        certs[certHash] = Cert(msg.sender, block.timestamp);
        emit Issued(certHash, msg.sender, block.timestamp);
    }

    function isValid(bytes32 certHash) public view returns (bool,address,uint256) {
        Cert memory c = certs[certHash];
        return (c.issuedAt != 0, c.issuer, c.issuedAt);
    }

    // --- helpers (use plain text like your website) ---
    function makeHash(
        string memory name,
        string memory idNumber,
        string memory issueDate
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(name, "|", idNumber, "|", issueDate));
    }

    function issueFromFields(
        string memory name,
        string memory idNumber,
        string memory issueDate
    ) external payable {
        require(msg.value >= 0.001 ether, "Fee: 0.001 ETH required");
        bytes32 h = makeHash(name, idNumber, issueDate);
        require(certs[h].issuedAt == 0, "Already issued");
        certs[h] = Cert(msg.sender, block.timestamp);
        emit Issued(h, msg.sender, block.timestamp);
    }

    function isValidFromFields(
        string memory name,
        string memory idNumber,
        string memory issueDate
    ) external view returns (bool,address,uint256) {
        bytes32 h = makeHash(name, idNumber, issueDate);
        return isValid(h);
    }

    // --- fees management ---
    function getBalance() public view returns (uint256) {
        return address(this).balance; // in wei
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
