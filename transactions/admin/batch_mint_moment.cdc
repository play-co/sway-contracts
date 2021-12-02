import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction mints multiple moments
// from a single set/clip combination (otherwise known as edition)

// Parameters:
//
// setID: the ID of the set to be minted from
// clipID: the ID of the Clip from which the Moments are minted
// quantity: the quantity of Moments to be minted
// recipientAddr: the Flow address of the account receiving the collection of minted moments

transaction(setID: UInt32, clipID: UInt32, quantity: UInt64, recipientAddr: Address) {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)!
    }

    execute {

        // borrow a reference to the set to be minted from
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Mint all the new NFTs
        let collection <- setRef.batchMintMoment(clipID: clipID, quantity: quantity)

        // Get the account object for the recipient of the minted tokens
        let recipient = getAccount(recipientAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's collection")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-collection)
    }
}
