import Market from 0xMARKETADDRESS
import SwayMomentMarket from "./SwayMomentMarket.cdc"

pub fun main(sellerAddress: Address, momentID: UInt64): UInt32 {
    let saleRef = getAccount(sellerAddress).getCapability(SwayMomentMarket.marketPublicPath)
        .borrow<&{Market.SalePublic}>()
        ?? panic("Could not get public sale reference")

    let token = saleRef.borrowMoment(id: momentID)
        ?? panic("Could not borrow a reference to the specified moment")

    let data = token.data

    return data.setID
}
