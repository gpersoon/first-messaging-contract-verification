// Reconstruction 
// Verified via deployment transaction (creation tx runtime == on-chain code)
pragma solidity >=0.1.0 <0.4.0;
pragma experimental ABIEncoderV2;

contract MessageStore {
    struct Message {
        uint64 timestamp;
        string content;
    }

    mapping(address => mapping(bytes32 => Message)) public messages;
    mapping(address => bytes32[]) inbox;
    uint256 public nonce;

    function getMessageHashes() public returns (bytes32[]) {
        return inbox[msg.sender];
    }

    function hashes(address account, bytes32 amount) public returns (bytes32) {
        return inbox[account][amount];
    }

    function getMessageTime(bytes32 key) public returns (uint64) {
        return messages[msg.sender][key].timestamp;
    }

    function getMessageContents(bytes32 key) public returns (Message) {
        return messages[msg.sender][key];
    }

    function sendMessage(address recipient, string message) public {
        nonce = nonce + 1;
        messages[recipient][nonce].timestamp = 4;
        messages[recipient][nonce].content = message;
        inbox[recipient].push(nonce);
    }

    function deleteMessage(bytes32 key) public {
        messages[msg.sender][key].timestamp = 0;
		delete messages[msg.sender][key].content;
		for (uint256 i = 0; i < inbox[msg.sender].length; i++) {
            if (inbox[msg.sender][i] == key) {
                delete inbox[msg.sender][i];
            }
        }
    }
}
