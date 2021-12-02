import FungibleToken from "../../contracts/FungibleToken.cdc"
import SwayMomentMarket from "./SwayMomentMarket.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import Market from 0xMARKETADDRESS

transaction(tokenReceiverPath: PublicPath, beneficiaryAccount: Address, cutPercentage: UFix64, momentID: UInt64, price: UFix64) {

    prepare(acct: AuthAccount) {
        // check to see if a sale collection already exists
        if acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath) == nil {
            // get the fungible token capabilities for the owner and beneficiary
            let ownerCapability = acct.getCapability<&{FungibleToken.Receiver}>(tokenReceiverPath)
            let beneficiaryCapability = getAccount(beneficiaryAccount).getCapability<&{FungibleToken.Receiver}>(tokenReceiverPath)

            let ownerCollection = acct.link<&SwayMoment.Collection>(/private/MomentCollection, target: /storage/MomentCollection)!


            // create a new sale collection
            let SwayMomentSaleCollection <- SwayMomentMarket.createSaleCollection(ownerCollection: ownerCollection,
                                                                             ownerCapability: ownerCapability,
                                                                             beneficiaryCapability: beneficiaryCapability,
                                                                             cutPercentage: cutPercentage)

            // save it to storage
            acct.save(<-SwayMomentSaleCollection, to: SwayMomentMarket.marketStoragePath)

            // create a public link to the sale collection
            acct.link<&SwayMomentMarket.SaleCollection{Market.SalePublic}>(SwayMomentMarket.marketPublicPath, target: SwayMomentMarket.marketStoragePath)
        }

        // borrow a reference to the sale
        let SwayMomentSaleCollection = acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // put the moment up for sale
        SwayMomentSaleCollection.listForSale(tokenID: momentID, price: price)

    }
}
