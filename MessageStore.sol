// Reconstruction - 3 of 8 function selectors remain unidentified
// Verified via deployment transaction (creation tx runtime == on-chain code)
contract MessageStore {
    struct Message {
        uint64 timestamp;
        string content;
    }

    uint nonce;
    mapping(address => mapping(bytes32 => Message)) messages;
    mapping(address => bytes32[]) inbox;

    function sendMessage(address recipient, string message) {
        nonce++;
        bytes32 key = bytes32(block.timestamp);
        messages[recipient][key].timestamp = uint64(block.timestamp);
        messages[recipient][key].content = message;
        inbox[recipient].push(key);
    }

    function getMessageContents(bytes32 key) constant returns (string) {
        return messages[msg.sender][key].content;
    }

    // selector 0xfe1e3eca
    function deleteMessage(bytes32 key) {
        messages[msg.sender][key].timestamp = 0;
        delete messages[msg.sender][key].content;
        for (uint i = 0; i < inbox[msg.sender].length; i++) {
            if (inbox[msg.sender][i] == key) {
                delete inbox[msg.sender][i];
            }
        }
    }
}
