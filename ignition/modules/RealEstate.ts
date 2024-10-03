import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";

const RealEstateRegistryModule = buildModule("RealEstateRegistryModule", (m) => {
    const deployRealEstateRegistry = m.contract("RealEstateRegistry", []);

    return { deployRealEstateRegistry};
});

export default RealEstateRegistryModule;