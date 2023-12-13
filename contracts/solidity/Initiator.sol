// SPDX-License-Identifier: GPL 3.0
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

interface IUpdateNumber {
    function updateNumber(address from, uint _number) external;
    function getNum() external returns(uint);
}

interface IERC20TokenInterface {
    function interChainBurn(address owner, uint amount_or_id) external;
}

interface IERC721TokenInterface {
    function interChainBurn(uint tokenId) external;
}

interface IStoreSamplings {
    function storeSamples(int a, int b) external;
}

contract Initiator {

    address public owner;
    address public watchtower;

    mapping(string => address) sourceServiceContracts;
    mapping(address => mapping(string => uint)) public nonceSetMap;

    string constant SYNC_DATA = "SYNC_DATA";
    string constant ERC20_TRANSFER = "ERC20_TRANSFER";
    string constant ERC721_TRANSFER = "ERC721_TRANSFER";
    string constant CCSCEFrom = "CCSCEStorage";
    string constant CCSCETo = "CCSCEAggregate";

    event interChainTransactionSyncDataRequest(address indexed from, uint indexed nonce, string indexed service, string message);
    event interChainTransactionERC20TokenTransferRequest(address indexed from, uint indexed nonce, string indexed service, string message);
    event interChainTransactionERC721TokenTransferRequest(address indexed from, uint indexed nonce, string indexed service, string message);
    event interChainTransactionCCSCExecRequest(address indexed from, uint indexed nonce, string indexed service, string message);

    constructor(address _watchtower) {
        owner = msg.sender;
        watchtower = _watchtower;
    }

    function interChainTransactionRequestSyncData(
        uint _nonce, string calldata service, uint256 number) public {
        require(nonceSetMap[msg.sender][service]+1 == _nonce);

        nonceSetMap[msg.sender][service] = nonceSetMap[msg.sender][service] + 1;

        this.updateNumber(service, number);
        string memory numString = Strings.toString(number);
        string memory header = createHeader(msg.sender,  SYNC_DATA, "");

        string memory body = string.concat(
            '"body":{',
            '   "instructions":{',
            '       "service":"', service,'",',
            '       "function":"interChainTransactionSyncDataFinalize"',
            '   },'
            '   "content":{'
            '       "value":"', numString, '"',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body,'}');
        emit interChainTransactionSyncDataRequest(msg.sender, _nonce, service, message);

    }

    function interChainTransactionRequestERC20TokenTransfer(
        uint _nonce, string calldata service, string calldata to, uint amount) public {
        require(nonceSetMap[msg.sender][service]+1 == _nonce);
        nonceSetMap[msg.sender][service] = nonceSetMap[msg.sender][service] + 1;

        // burn the required amount
        IERC20TokenInterface(sourceServiceContracts[service]).interChainBurn(msg.sender, amount);

        string memory amountString = Strings.toString(amount);

        string memory header = createHeader(msg.sender, ERC20_TRANSFER, to);
        string memory body = string(string.concat(

            '"body":{',
            '   "instructions":{',
            '       "service":"', service,'",',
            '       "function":"interChainTransactionERC20TokenTransferFinalize"',
            '   },'
            '   "content":{'
            '       "value":"', amountString, '"',
            '   }',
            '}'
        ));

        string memory message = string.concat('{', header, body,'}');

        emit interChainTransactionERC20TokenTransferRequest(msg.sender, _nonce, service, message);

    }

    function interChainTransactionRequestERC721TokenTransfer(
        uint _nonce, string calldata service, string calldata to, uint id) public {
        require(nonceSetMap[msg.sender][service]+1 == _nonce);
        nonceSetMap[msg.sender][service] = nonceSetMap[msg.sender][service] + 1;

        // burn the required amount
        IERC721TokenInterface(sourceServiceContracts[service]).interChainBurn(id);
        string memory idString = Strings.toString(id);

        string memory header = createHeader(msg.sender, ERC721_TRANSFER, to);
        string memory body = string.concat(

            '"body":{',
            '   "instructions":{',
            '       "service":"', service,'",',
            '       "function":"interChainTransactionERC721TokenTransferFinalize"',
            '   },'
            '   "content":{'
            '       "value":"', idString, '"',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body,'}');

        emit interChainTransactionERC20TokenTransferRequest(msg.sender, _nonce, service, message);
    }

    function interChainRequestExcecutionOfSmartContract(
        uint _nonce,
        string calldata service,
        int a,
        int b) public {

        require(nonceSetMap[msg.sender][service]+1 == _nonce);
        nonceSetMap[msg.sender][service] = nonceSetMap[msg.sender][service] + 1;

        IStoreSamplings(sourceServiceContracts[service]).storeSamples(a, b);

        string memory aStr = Strings.toString(a);
        string memory bStr = Strings.toString(b);

        string memory header = createHeader(msg.sender, CCSCEFrom, "");

        string memory body = string.concat(
            '"body":{',
            '   "instructions":{',
            '       "service":"', CCSCETo,'",',
            '       "function":"interChainEcecutionOfSmartContractFinalize"',
            '   },'
            '   "content":{'
            '       "a":"', aStr, '",',
            '       "b":"', bStr, '"',
            '   }',
            '}'
        );

        string memory message = string.concat('{', header, body, '}');

        emit interChainTransactionCCSCExecRequest(msg.sender, _nonce, service, message);

    }

    function getNextNonce(string calldata service) public view returns(uint256) {
        return nonceSetMap[msg.sender][service] + 1;
    }

    function updateNumber(string calldata service, uint number) external {
        require(msg.sender == address(this));
        IUpdateNumber(sourceServiceContracts[service]).updateNumber(address(this), number);
    }

    function addService(address _addr, string calldata name) public {
        sourceServiceContracts[name] = _addr;
    }

    function getNum(string calldata service) external returns(uint) {
        return IUpdateNumber(sourceServiceContracts[service]).getNum();
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
            '   "sender":"', Strings.toHexString(uint256(uint160(sender)), 20),'"},');
        }
        return header;
    }
}
