//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./Ownable.sol";
import "./IERC20.sol";

interface ILottoManager {
    function currentLotto() external view returns (address);
}

contract OTCRoyaltyReceiver is Ownable {

    mapping ( address => uint256 ) public allocations;
    uint256 public totalAllocations;
    address[] private recipients;

    address public lottoManager;
    uint256 public lottoCut = 70;

    function setLottoManager(address newManager) external onlyOwner {
        require(
            newManager != address(0),
            'Zero Address'
        );
        lottoManager = newManager;
    }

    function setLottoCut(uint newCut) external onlyOwner {
        require(
            newCut <= 100,
            'Cut Too High'
        );
        lottoCut = newCut;
    }

    function addRecipient(address recipient, uint newAllocation) external onlyOwner {
        require(
            allocations[recipient] == 0,
            'Has Allocation'
        );
        require(
            newAllocation > 0,
            'Remove Recipient'
        );
        recipients.push(recipient);
        allocations[recipient] = newAllocation;
        totalAllocations += newAllocation;
    }

    function removeRecipient(address recipient) external onlyOwner {
        totalAllocations -= allocations[recipient];
        delete allocations[recipient];

        uint index = recipients.length;
        for (uint i = 0; i < index;) {
            if (recipient == recipients[i]) {
                index = i;
                break;
            }
            unchecked { ++i; }
        }
        require(
            index < recipients.length,
            'Recipient Not Found'
        );

        recipients[index] = recipients[recipients.length - 1];
        recipients.pop();
    }

    function changeAllocation(address recipient, uint newAllocation) external onlyOwner {
        require(
            newAllocation > 0,
            'Remove Recipient'
        );
        require(
            allocations[recipient] > 0,
            'No Allocation'
        );

        totalAllocations = ( totalAllocations + newAllocation ) - allocations[recipient];
        allocations[recipient] = newAllocation;
    }


    function withdraw() external onlyOwner {
        _send(msg.sender, address(this).balance);
    }

    function withdrawToken(address token) external onlyOwner {
        uint bal = IERC20(token).balanceOf(address(this));
        _sendToken(token, msg.sender, bal);
    }

    function withdrawTokens(address[] calldata tokens) external onlyOwner {
        uint len = tokens.length;
        for (uint i = 0; i < len;) {
            _sendToken(tokens[i], msg.sender, IERC20(tokens[i]).balanceOf(address(this)));
            unchecked { ++i; }
        }
    }

    function distributeETH() external {
        _distributeETH();
    }

    function distribute(address[] calldata tokens) internal {
        _distribute(tokens);
    }

    function _sendToken(address token, address to, uint amount) internal {
        uint tokenBal = IERC20(token).balanceOf(address(this));
        if (amount > tokenBal) {
            amount = tokenBal;
        }
        if (amount == 0 || to == address(0)) {
            return;
        }
        IERC20(token).transfer(to, amount);
    }

    function _send(address to, uint amount) internal {
        if (amount > address(this).balance) {
            amount = address(this).balance;
        }
        if (amount == 0 || to == address(0)) {
            return;
        }
        (bool s,) = payable(to).call{value: amount}("");
        require(s);
    }

    function _distributeETH() internal {
        uint len = recipients.length;
        uint bal = address(this).balance;
        uint bal0 = ( bal * lottoCut ) / 100;
        uint bal1 = bal - bal0;
        _send(currentLotto(), bal0);
        for (uint i = 0; i < len;) {
            _send(recipients[i], ( bal1 * allocations[recipients[i]] ) / totalAllocations);
            unchecked { ++i; }
        }
    }

    function _distribute(address[] calldata tokens) internal {
        uint len = tokens.length;
        for (uint i = 0; i < len;) {
            _distributeToken(tokens[i]);
            unchecked { ++i; }
        }
    }

    function _distributeToken(address token) internal {
        uint len = recipients.length;
        uint bal = IERC20(token).balanceOf(address(this));
        uint bal0 = ( bal * lottoCut ) / 100;
        uint bal1 = bal - bal0;
        _sendToken(token, currentLotto(), bal0);
        for (uint i = 0; i < len;) {
            _sendToken(token, recipients[i], ( bal1 * allocations[recipients[i]] ) / totalAllocations);
            unchecked { ++i; }
        }
    }

    receive() external payable {}

    function currentLotto() public view returns (address) {
        if (lottoManager == address(0)) {
            return this.getOwner();
        }
        address lotto = ILottoManager(lottoManager).currentLotto();
        return lotto == address(0) ? this.getOwner() : lotto;
    }

}