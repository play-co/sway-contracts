import SwayMoment from "../../contracts/SwayMoment.cdc"
import Market from 0xMARKETADDRESS
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction is for a user to stop a moment sale in their account

// Parameters
//
// tokenID: the ID of the moment whose sale is to be delisted

transaction(tokenID: UInt64) {

    prepare(acct: AuthAccount) {

        // borrow a reference to the owner's sale collection
        if let swayMomentSaleCollection = acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath) {

            // cancel the moment from the sale, thereby de-listing it
            swayMomentSaleCollection.cancelSale(tokenID: tokenID)

        } else if let SwayMomentSaleCollection = acct.borrow<&Market.SaleCollection>(from: /storage/SwayMomentSaleCollection) {
            // Borrow a reference to the NFT collection in the signers account
            let collectionRef = acct.borrow<&SwayMoment.Collection>(from: /storage/MomentCollection)
                ?? panic("Could not borrow from MomentCollection in storage")

            // withdraw the moment from the sale, thereby de-listing it
            let token <- SwayMomentSaleCollection.withdraw(tokenID: tokenID)

            // deposit the moment into the owner's collection
            collectionRef.deposit(token: <-token)
        }
    }
}
