# Certificate Verification Platform

## Overview
A blockchain-based platform designed to **issue and verify digital certificates** securely and transparently.

- **On-chain:** Saves only the certificate hash, issuer address, and timestamp in a Solidity smart contract.  
- **Off-chain:** Stores readable certificate data (name, ID, date) in a Node.js backend (`db.json`).  
- **Fee:** Each issuance costs **0.001 ETH**, withdrawable by the contract owner.

## Main Features
- Register and issue new certificates  
- Verify authenticity of certificates  
- Store data electronically (off-chain)  
- Collect blockchain fees (0.001 ETH per issue)  
- Admin control through Remix (issue, verify, withdraw)

## Tools Used
- **Frontend:** HTML, CSS, JavaScript (ethers.js)  
- **Backend:** Node.js + Express  
- **Smart Contract:** Solidity (`CertRegistry.sol`)  
- **IDE:** Remix Ethereum VM (London)

## How It Works
1. The user enters certificate information (name, ID, date).  
2. The system creates a unique hash using `keccak256(name|id|date)`.  
3. Data is saved off-chain and optionally recorded on the blockchain.  
4. The issuer pays a small fee (0.001 ETH).  
5. Verification checks if the hash exists on-chain.

## Quick Start

**Backend:**
```bash
cd backend
npm install
node server.js
```

**Frontend:**  
Open `frontend/index.html` in your browser.

**Smart Contract (Remix):**
1. Compile with Solidity 0.8.20  
2. Deploy with Value = 0  
3. Set Value = 1 Finney (0.001 ETH)  
4. Call `issueFromFields(name, id, date)`  
5. Verify using `isValidFromFields(name, id, date)`

## Project Structure
```
project/
├─ backend/          # Node.js API
├─ frontend/         # HTML + JS Interface
├─  smart_contract/   # Solidity Contract
└─ README.md        # This file
```

## Course Details
**Course:** Blockchain / CSCI 4309  
**Professor:** Dr. Raed Rashid  

## Contributors
- **Abdallah Kassab** — Student ID: 120212459  

