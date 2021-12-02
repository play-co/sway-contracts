import FungibleToken from "../../contracts/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/DapperUtilityCoin.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import Market from 0xMARKETADDRESS
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction purchases a moment from the sale collection

transaction(seller: Address, recipient: Address, momentID: UInt64, purchaseAmount: UFix64) {

    let purchaseTokens: @DapperUtilityCoin.Vault

    prepare(acct: AuthAccount) {

        // Borrow a provider reference to the buyers vault
        let provider = acct.borrow<&DapperUtilityCoin.Vault{FungibleToken.Provider}>(from: /storage/dapperUtilityCoinVault)
            ?? panic("Could not borrow a reference to the buyers FlowToken Vault")

        // withdraw the purchase tokens from the vault
        self.purchaseTokens <- provider.withdraw(amount: purchaseAmount) as! @DapperUtilityCoin.Vault

    }

    execute {

        // get the accounts for the seller and recipient
        let seller = getAccount(seller)
        let recipient = getAccount(recipient)

        // Get the reference for the recipient's nft receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection)!.borrow<&{SwayMoment.MomentCollectionPublic}>()
            ?? panic("Could not borrow a reference to the recipients moment collection")

        if let marketCollectionRef = seller.getCapability(/public/SwayMomentSaleCollection)
                .borrow<&{Market.SalePublic}>() {

            let purchasedToken <- marketCollectionRef.purchase(tokenID: momentID, buyTokens: <-self.purchaseTokens)
            receiverRef.deposit(token: <-purchasedToken)

        } else {
            panic("Could not borrow reference to Sale collection")
        }
    }
}
