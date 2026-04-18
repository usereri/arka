// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "./HelperConfig.s.sol";
import "../src/identity/UserProfileNFT.sol";
import "../src/registry/CommunityRegistry.sol";

contract Deploy is Script {
    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        uint256 deployerPrivateKey = config.deployerPrivateKey;
        address deployer = config.deployer;

        console.log("Deploying with account:", deployer);
        console.log("Balance:", deployer.balance);
        console.log("Chain ID:", block.chainid);

        vm.startBroadcast(deployerPrivateKey);

        UserProfileNFT userProfileNFT = new UserProfileNFT();
        console.log("UserProfileNFT:", address(userProfileNFT));

        CommunityRegistry registry = new CommunityRegistry(
            deployer,
            address(userProfileNFT)
        );
        console.log("CommunityRegistry:", address(registry));

        userProfileNFT.authorizeWriter(address(registry));

        registry.grantHost(deployer);

        vm.stopBroadcast();

        console.log("");
        console.log("=== Deployment Complete ===");
        console.log(
            string.concat(
                '{"chainId":',
                vm.toString(block.chainid),
                ',"UserProfileNFT":"',
                vm.toString(address(userProfileNFT)),
                '","CommunityRegistry":"',
                vm.toString(address(registry)),
                '"}'
            )
        );
    }
}
