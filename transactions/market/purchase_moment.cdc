import FungibleToken from "../../contracts/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/DapperUtilityCoin.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction is for a user to purchase a moment that another user
// has for sale in their sale collection

// Parameters
//
// sellerAddress: the Flow address of the account issuing the sale of a moment
// tokenID: the ID of the moment being purchased
// purchaseAmount: the amount for which the user is paying for the moment; must not be less than the moment's price
// TODO: determine when / where / if / this was ever used purchase_both_mnarkets seems to be the one that was being used

transaction(sellerAddress: Address, tokenID: UInt64, purchaseAmount: UFix64) {
    prepare(acct: AuthAccount) {

        // borrow a reference to the signer's collection
        let collection = acct.borrow<&SwayMoment.Collection>(from: /storage/MomentCollection)
            ?? panic("Could not borrow reference to the Moment Collection")

        // borrow a reference to the signer's fungible token Vault
        let provider = acct.borrow<&DapperUtilityCoin.Vault{FungibleToken.Provider}>(from: /storage/dapperUtilityCoinVault)!

        // withdraw tokens from the signer's vault
        let tokens <- provider.withdraw(amount: purchaseAmount) as! @DapperUtilityCoin.Vault

        // get the seller's public account object
        let seller = getAccount(sellerAddress)

        // borrow a public reference to the seller's sale collection
        let SwayMomentSaleCollection = seller.getCapability(SwayMomentMarket.marketPublicPath)
            .borrow<&{Market.SalePublic}>()
            ?? panic("Could not borrow public sale reference")

        // purchase the moment
        let purchasedToken <- SwayMomentSaleCollection.purchase(tokenID: tokenID, buyTokens: <-tokens)

        // deposit the purchased moment into the signer's collection
        collection.deposit(token: <-purchasedToken)
    }
}
