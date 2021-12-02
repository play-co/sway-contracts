import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentMarket from "../../contracts/SwayMomentMarket.cdc"

// This transaction transfers a moment to a recipient
// and cancels the sale in the collection if it exists

// Parameters:
//
// recipient: The Flow address of the account to receive the moment.
// withdrawID: The id of the moment to be transferred

transaction(recipient: Address, withdrawID: UInt64) {

    // local variable for storing the transferred token
    let transferToken: @NonFungibleToken.NFT

    prepare(acct: AuthAccount) {

        // borrow a reference to the owner's collection
        let collectionRef = acct.borrow<&SwayMoment.Collection>(from: /storage/MomentCollection)
            ?? panic("Could not borrow a reference to the stored Moment collection")

        // withdraw the NFT
        self.transferToken <- collectionRef.withdraw(withdrawID: withdrawID)

        if let saleRef = acct.borrow<&SwayMomentMarket.SaleCollection>(from: SwayMomentMarket.marketStoragePath) {
            saleRef.cancelSale(tokenID: withdrawID)
        }
    }

    execute {

        // get the recipient's public account object
        let recipient = getAccount(recipient)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()!

        // deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-self.transferToken)
    }
}
