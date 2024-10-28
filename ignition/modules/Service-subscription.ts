import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";


const SubscriptionModule = buildModule("SubscriptionModule", (m) => {

    const subscriptionFee = ethers.parseEther("0.001"); 
  const servicePeriod = 4 * 7 * 24 * 60 * 60;  
  const soliuService = m.contract("SoliuService", [servicePeriod, subscriptionFee] );

  


  return { soliuService };
});

export default SubscriptionModule;



