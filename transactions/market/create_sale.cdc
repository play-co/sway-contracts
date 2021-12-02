import FungibleToken from "../../contracts/FungibleToken.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import Market from 0xMARKETADDRESS
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction creates a sale collection and stores it in the signer's account
// It does not put an NFT up for sale

// Parameters
//
// beneficiaryAccount: the Flow address of the account where a cut of the purchase will be sent
// cutPercentage: how much in percentage the beneficiary will receive from the sale

transaction(tokenReceiverPath: PublicPath, beneficiaryAccount: Address, cutPercentage: UFix64) {
    prepare(acct: AuthAccount) {
        let ownerCapability = acct.getCapability<&AnyResource{FungibleToken.Receiver}>(tokenReceiverPath)

        let beneficiaryCapability = getAccount(beneficiaryAccount).getCapability<&AnyResource{FungibleToken.Receiver}>(tokenReceiverPath)

        let ownerCollection = acct.link<&SwayMoment.Collection>(/private/MomentCollection, target: /storage/MomentCollection)!

        let collection <- SwayMomentMarket.createSaleCollection(ownerCollection: ownerCollection,
                                                               ownerCapability: ownerCapability,
                                                               beneficiaryCapability: beneficiaryCapability,
                                                               cutPercentage: cutPercentage)

        acct.save(<-collection, to: SwayMomentMarket.marketStoragePath)

        acct.link<&SwayMomentMarket.SaleCollection{Market.SalePublic}>(SwayMomentMarket.marketPublicPath, target: SwayMomentMarket.marketStoragePath)
    }
}
