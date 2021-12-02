import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentShardedCollection from "../../contracts/SwayMomentShardedCollection.cdc"

// This transaction deposits a number of NFTs to a recipient

// Parameters
//
// recipient: the Flow address who will receive the NFTs
// momentIDs: an array of moment IDs of NFTs that recipient will receive

transaction(recipient: Address, momentIDs: [UInt64]) {

    let transferTokens: @NonFungibleToken.Collection

    prepare(acct: AuthAccount) {

        self.transferTokens <- acct.borrow<&SwayMomentShardedCollection.ShardedCollection>(from: /storage/ShardedMomentCollection)!.batchWithdraw(ids: momentIDs)
    }

    execute {

        // get the recipient's public account object
        let recipient = getAccount(recipient)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()!

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-self.transferTokens)
    }
}
