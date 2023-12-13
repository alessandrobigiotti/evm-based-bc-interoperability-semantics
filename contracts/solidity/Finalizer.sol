// SPDX-License-Identifier: GPL 3.0
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

interface IUpdateNumber {
    function updateNumber(address from, uint _number) external;
    function getNum() external returns(uint);
}

interface IERC20TokenInterface {
    function interChainMint(address _address, uint _amount) external;
}

interface IERC721TokenInterface {
    function interChainMint(address to) external returns(uint);
}

interface IAggregateData {
    function calculateAverage(int _a, int _b) external;
    function getLastValue() external returns(int);
}

contract Finalizer {

    address public owner;
    address public watchtower;
    mapping(string => address) private sourceServiceContracts;

    string constant SYNC_DATA = "SYNC_DATA";
    string constant ERC20_TRANSFER = "ERC20_TRANSFER";
    string constant ERC721_TRANSFER = "ERC721_TRANSFER";
    string constant CCSCEFrom = "CCSCEStorage";
    string constant CCSCETo = "CCSCEAggregate";

    event interChainTransactionSyncDataCompleted(address indexed from, string indexed _from, uint nonce, string message);
    event interChainTransactionERC20TokenTransferCompleted(address indexed from, string indexed _from, uint nonce, string message);
    event interChainTransactionERC721TokenTransferCompleted(address indexed from, string indexed _from, uint nonce, string message);
    event interChainTransactionCCSCExecCompleted(address indexed from, string indexed _from, uint nonce, string message);

    constructor(address _watchtower) {
        owner = msg.sender;
        watchtower = _watchtower;
    }

    function interChainTransactionSyncDataFinalize(
        string calldata _from, uint _nonce, string calldata service, uint256 number) public {
        require(msg.sender == listener);
        this.updateNumber(service, number);

        string memory numString = Strings.toString(number);

        string memory header = createHeader(msg.sender, SYNC_DATA, "");

        string memory body = string(string.concat(
            '"body":{',
            '   "content":{'
            '       "value":"', numString, '"',
            '   }',
            '}'
        ));

        string memory message = string.concat('{', header, body, '}');

        emit interChainTransactionSyncDataCompleted(msg.sender, _from, _nonce, message);

    }

    function interChainTransactionERC20TokenTransferFinalize(
        string calldata _from, address to, uint _nonce, string calldata service, uint256 amount) public {
        require(msg.sender == listener);

        IERC20TokenInterface(sourceServiceContracts[service]).interChainMint(to, amount);

        string memory amountString = Strings.toString(amount);

        string memory header = createHeader(msg.sender, ERC20_TRANSFER, Strings.toHexString(to));

        string memory body = string.concat(
            '"body":{',
            '   "content":{'
            '       "value":"', amountString, '"',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body, '}');

        emit interChainTransactionERC20TokenTransferCompleted(msg.sender, _from, _nonce, message);

    }

    function interChainTransactionERC721TokenTransferFinalize(
        string calldata _from, address to, uint _nonce, string calldata service) public {
        require(msg.sender == listener);

        uint newId = IERC721TokenInterface(sourceServiceContracts[service]).interChainMint(to);

        string memory idString = Strings.toString(newId);

        string memory header = createHeader(msg.sender, ERC721_TRANSFER, Strings.toHexString(to));

        string memory body = string.concat(
            '"body":{',
            '   "content":{'
            '       "tokenId":"', idString, '"',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body, '}');

        emit interChainTransactionERC20TokenTransferCompleted(msg.sender, _from, _nonce, message);

    }

    function interChainExcecutionOfSmartContractFinalize(
        string calldata _from, uint _nonce, int _a, int _b, string calldata service) public {

        require(msg.sender == listener);

        IAggregateData(sourceServiceContracts[service]).calculateAverage(_a, _b);
        int res = IAggregateData(sourceServiceContracts[service]).getLastValue();

        string memory header = createHeader(msg.sender, CCSCETo, "");

        string memory body = string.concat(
            '"body":{',
            '   "content":{'
            '       "response":"', Strings.toString(res), '",',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body, '}');

        emit interChainTransactionCCSCExecCompleted(msg.sender, _from, _nonce, message);
    }

    function updateNumber(string calldata service, uint number) external {
        require(msg.sender == address(this));
        IUpdateNumber(sourceServiceContracts[service]).updateNumber(address(this), number);
    }

    function addService(address _addr, string calldata name) public {
        sourceServiceContracts[name] = _addr;
    }

    function createHeader(address sender, string memory _type, string memory to) private view returns(string memory) {
        string memory header;
        if (bytes(to).length != 0) {
            header = string.concat(
            '"header":{',
            '   "source_chain":"',Strings.toString(block.chainid),'",',
            '   "type":"',_type,'",',
            '   "block_number":"' ,Strings.toString(block.number),'",',
            '   "timestamp":"', Strings.toString(block.timestamp),'",',
            '   "sender":"', Strings.toHexString(uint256(uint160(sender)), 20),'",',
            '   "receiver":"',to,'"},');

        } else {
            header = string.concat(
            '"header":{',
            '   "source_chain":"',Strings.toString(block.chainid),'",',
            '   "type":"',_type,'",',
            '   "block_number":"' ,Strings.toString(block.number),'",',
            '   "timestamp":"', Strings.toString(block.timestamp),'",',
            '   "sender":"', Strings.toHexString(sender),'"},');
        }

        return header;
    }
}
