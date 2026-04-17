// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/identity/UserProfileNFT.sol";
import "../src/meetings/MeetingAttendanceNFT.sol";
import "../src/meetings/MeetingContract.sol";
import "../src/finance/TreasuryContract.sol";
import "../src/finance/CommunityVault.sol";
import "../src/registry/ContractRegistry.sol";

/**
 * @title Deploy
 * @notice Deploy all contracts in the correct order
 * @dev Deploy order:
 *      1. UserProfileNFT
 *      2. MeetingAttendanceNFT
 *      3. CommunityVault
 *      4. TreasuryContract (with CommunityVault address)
 *      5. ContractRegistry (with all addresses)
 * @dev After deployment, the script outputs the addresses of all deployed contracts and generates a JSON object for frontend integration.
 */
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with account:", deployer);
        console.log("Balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);
        UserProfileNFT userProfileNFT = new UserProfileNFT();
        console.log("UserProfileNFT deployed at:", address(userProfileNFT));

        MeetingAttendanceNFT meetingAttendanceNFT = new MeetingAttendanceNFT();
        console.log(
            "MeetingAttendanceNFT deployed at:",
            address(meetingAttendanceNFT)
        );

        CommunityVault communityVault = new CommunityVault(address(0));
        console.log("CommunityVault deployed at:", address(communityVault));

        TreasuryContract treasuryContract = new TreasuryContract(address(0));
        console.log("TreasuryContract deployed at:", address(treasuryContract));

        ContractRegistry registry = new ContractRegistry(deployer);
        console.log("ContractRegistry deployed at:", address(registry));

        registry.setUserProfileNFT(address(userProfileNFT));
        registry.setMeetingAttendanceNFT(address(meetingAttendanceNFT));
        registry.setTreasuryContract(address(treasuryContract));
        registry.setCommunityVault(address(communityVault));
        vm.stopBroadcast();

        console.log("");
        console.log("=== Deployment Complete ===");
        console.log("UserProfileNFT:", address(userProfileNFT));
        console.log("MeetingAttendanceNFT:", address(meetingAttendanceNFT));
        console.log("TreasuryContract:", address(treasuryContract));
        console.log("CommunityVault:", address(communityVault));
        console.log("ContractRegistry:", address(registry));

        console.log("");
        console.log("=== contracts.json ===");
        console.log(
            string.concat(
                '{"sepolia":{',
                '"UserProfileNFT":"',
                vm.toString(address(userProfileNFT)),
                '",',
                '"MeetingAttendanceNFT":"',
                vm.toString(address(meetingAttendanceNFT)),
                '",',
                '"TreasuryContract":"',
                vm.toString(address(treasuryContract)),
                '",',
                '"CommunityVault":"',
                vm.toString(address(communityVault)),
                '",',
                '"ContractRegistry":"',
                vm.toString(address(registry)),
                '"',
                "}}"
            )
        );
    }
}
