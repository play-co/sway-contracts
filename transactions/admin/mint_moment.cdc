import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction is what an admin would use to mint a single new moment
// and deposit it in a user's collection

// Parameters:
//
// setID: the ID of a set containing the target clip
// clipID: the ID of a clip from which a new moment is minted
// recipientAddr: the Flow address of the account receiving the newly minted moment

transaction(setID: UInt32, clipID: UInt32, recipientAddr: Address) {
    // local variable for the admin reference
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {
        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)!
    }

    execute {
        // Borrow a reference to the specified set
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Mint a new NFT
        let moment1 <- setRef.mintMoment(clipID: clipID)

        // get the public account object for the recipient
        let recipient = getAccount(recipientAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/MomentCollection).borrow<&{SwayMoment.MomentCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's moment collection")

        // deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-moment1)
    }
}
