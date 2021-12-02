import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction is for a user to put a new moment up for sale
// They must have SwayMoment Collection and a SwayMomentMarket Sale Collection already
// stored in their account

// Parameters
//
// momentId: the ID of the moment to be listed for sale
// price: the sell price of the moment

transaction(momentID: UInt64, price: UFix64) {
    prepare(acct: AuthAccount) {

        // borrow a reference to the SwayMoment Sale Collection
        let SwayMomentSaleCollection = acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // List the specified moment for sale
        SwayMomentSaleCollection.listForSale(tokenID: momentID, price: price)
    }
}
