import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

transaction(receiverPath: PublicPath) {
    prepare(acct: AuthAccount) {

        let SwayMomentSaleCollection = acct.borrow<&SwayMomentMarket.SaleCollection>(from: /storage/SwayMomentSaleCollection)
            ?? panic("Could not borrow from sale in storage")

        SwayMomentSaleCollection.changeOwnerReceiver(acct.getCapability(receiverPath))
    }
}
