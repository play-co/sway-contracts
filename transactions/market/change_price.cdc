import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction changes the price of a moment that a user has for sale

// Parameters:
//
// tokenID: the ID of the moment whose price is being changed
// newPrice: the new price of the moment

transaction(tokenID: UInt64, newPrice: UFix64) {
    prepare(acct: AuthAccount) {

        // borrow a reference to the owner's sale collection
        let SwayMomentSaleCollection = acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // Change the price of the moment
        SwayMomentSaleCollection.listForSale(tokenID: tokenID, price: newPrice)
    }
}
