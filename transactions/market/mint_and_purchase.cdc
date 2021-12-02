import FungibleToken from "../../contracts/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/DapperUtilityCoin.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import Market from 0xMARKETADDRESS
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

transaction(sellerAddress: Address, recipient: Address, tokenID: UInt64, purchaseAmount: UFix64) {

    prepare(signer: AuthAccount) {

        let tokenAdmin = signer
            .borrow<&DapperUtilityCoin.Administrator>(from: /storage/dapperUtilityCoinAdmin)
            ?? panic("Signer is not the token admin")

        let minter <- tokenAdmin.createNewMinter(allowedAmount: purchaseAmount)
        let mintedVault <- minter.mintTokens(amount: purchaseAmount) as! @DapperUtilityCoin.Vault

        destroy minter

        let seller = getAccount(sellerAddress)
        let SwayMomentSaleCollection = seller.getCapability(SwayMomentMarket.marketPublicPath)
            .borrow<&{Market.SalePublic}>()
            ?? panic("Could not borrow public sale reference")

        let boughtToken <- SwayMomentSaleCollection.purchase(tokenID: tokenID, buyTokens: <-mintedVault)

        // get the recipient's public account object and borrow a reference to their moment receiver
        let recipient = getAccount(recipient)
            .getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()
            ?? panic("Could not borrow a reference to the moment collection")

        // deposit the NFT in the receivers collection
        recipient.deposit(token: <-boughtToken)
    }
}
