import Market from 0xMARKETADDRESS
import SwayMomentMarket from "./SwayMomentMarket.cdc"

pub fun main(sellerAddress: Address, momentID: UInt64): UFix64 {

    let acct = getAccount(sellerAddress)
    let collectionRef = acct.getCapability(SwayMomentMarket.marketPublicPath).borrow<&{Market.SalePublic}>()
        ?? panic("Could not borrow capability from public collection")

    let price = collectionRef.getPrice(tokenID: UInt64(momentID))
        ?? panic("Could not find price")

    return price

}
