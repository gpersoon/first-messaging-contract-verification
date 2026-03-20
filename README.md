# First Messaging Contract - Frontier Era Bytecode Verification

Bytecode verification of `0x3a2c6e618b72f2047f5be10570582d41840b8e78`, the first known decentralized messaging contract on Ethereum mainnet.

Deployed at block 54,969 on August 8, 2015 - Frontier Day 1. Its only two transactions are the deployment and a single `sendMessage("hello2!")` call to the deployer's own address.

## Contract Details

| Field | Value |
|---|---|
| Address | [0x3a2c6e618b72f2047f5be10570582d41840b8e78](https://etherscan.io/address/0x3a2c6e618b72f2047f5be10570582d41840b8e78) |
| Block | 54,969 |
| Date | August 8, 2015 |
| Deployer | [0x8674c218F0351a62C3BA78C34FD2182A93Da94E2](https://etherscan.io/address/0x8674c218F0351a62C3BA78C34FD2182A93Da94E2) |

## Verification

Creation bytecode input = 19-byte deployment stub + 1,574-byte runtime.

The runtime extracted from the creation transaction matches the on-chain deployed code byte-for-byte.

**Method:** Deployment transaction bytecode analysis (creation tx runtime == on-chain code)

## Transaction History

Only 2 transactions ever:

1. **Block 54,969** - Deployment
2. **Block 54,971** - `sendMessage("hello2!")` from deployer to themselves

## Source Code

Best reconstruction. The original Solidity source was not recovered - 3 of 8 function selectors remain unidentified after exhaustive brute-force search.

```solidity
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
```

## Functions (8 total)

| Selector | Name | Status |
|---|---|---|
| (known) | `sendMessage(address,string)` | Identified |
| (known) | `getMessageContents(bytes32)` | Identified |
| (known) | `nonce()` | Identified |
| (known) | `messages(address,bytes32)` | Identified |
| `0xfe1e3eca` | `deleteMessage(bytes32)` | Identified |
| `0x0a936fe5` | unknown | Unidentified |
| `0x15853113` | unknown | Unidentified |
| `0x39bfc4a1` | unknown | Unidentified |

## Compiler

- **Version:** solc v0.1.1 (inferred from bytecode patterns)
- **Commit:** v0.1.1+commit.6ff4cd6a
- **Repo:** https://github.com/ethereum/webthree-umbrella

## Historical Context

This is the earliest known decentralized messaging contract on Ethereum mainnet. Deployed on Frontier Day 1, it demonstrates that developers were building communication infrastructure on the very first day of the network.

The deployer (`0x8674c218F0`) was funded by genesis holder `0x32be343b`, who funded multiple serious developers on Frontier Day 1. The deployer tested the contract immediately by sending "hello2!" to themselves, then never used it again.

Part of [Ethereum History](https://ethereumhistory.com) - [Proofs](https://ethereumhistory.com/proofs).

## License

[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) - Public domain.
