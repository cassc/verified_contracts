// SPDX-License-Identifier: GPL-3.0-only

pragma solidity >=0.5.0;

import "../interfaces/INXMMaster.sol";

contract LegacyMasterAware {

  INXMMaster public ms;
  address public nxMasterAddress;

  modifier onlyInternal {
    require(ms.isInternal(msg.sender));
    _;
  }

  modifier onlyGovernance {
    require(msg.sender == ms.getLatestAddress("GV"));
    _;
  }


  modifier isMemberAndcheckPause {
    require(ms.isPause() == false && ms.isMember(msg.sender) == true);
    _;
  }

  modifier checkPause {
    require(ms.isPause() == false);
    _;
  }

  /**
   * @dev change master address
   * @param _masterAddress is the new address
   */
  function changeMasterAddress(address _masterAddress) public {
    if (address(ms) != address(0)) {
      require(address(ms) == msg.sender, "Not master");
    }

    ms = INXMMaster(_masterAddress);
    nxMasterAddress = _masterAddress;
  }

}