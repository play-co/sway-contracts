import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction transfers a number of moments to a recipient

// Parameters
//
// recipientAddress: the Flow address who will receive the NFTs
// momentIDs: an array of moment IDs of NFTs that recipient will receive

transaction(recipientAddress: Address, momentIDs: [UInt64]) {

    let transferTokens: @NonFungibleToken.Collection

    prepare(acct: AuthAccount) {

        self.transferTokens <- acct.borrow<&SwayMoment.Collection>(from: /storage/MomentCollection)!.batchWithdraw(ids: momentIDs)
    }

    execute {

        // get the recipient's public account object
        let recipient = getAccount(recipientAddress)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()
            ?? panic("Could not borrow a reference to the recipients moment receiver")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(token: <-self.transferTokens)
    }
}
