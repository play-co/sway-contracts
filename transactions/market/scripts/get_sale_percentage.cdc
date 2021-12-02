import Market from 0xMARKETADDRESS
import SwayMomentMarket from "./SwayMomentMarket.cdc"

pub fun main(sellerAddress: Address): UFix64 {
    let acct = getAccount(sellerAddress)
    let collectionRef = acct.getCapability(SwayMomentMarket.marketPublicPath).borrow<&{Market.SalePublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.cutPercentage
}
