import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script gets the metadata associated with a moment
// in a collection by looking up its clipID and then searching
// for that clip's metadata in the SwayMoment contract

// Parameters:
//
// account: The Flow Address of the account whose moment data needs to be read
// id: The unique ID for the moment whose data needs to be read

// Returns: {String: String}
// A dictionary of all the clip metadata associated
// with the specified moment

pub fun main(account: Address, id: UInt64): {String: String} {

    // get the public capability for the owner's moment collection
    // and borrow a reference to it
    let collectionRef = getAccount(account).getCapability(/public/MomentCollection)
        .borrow<&{SwayMoment.MomentCollectionPublic}>()
        ?? panic("Could not get public moment collection reference")

    // Borrow a reference to the specified moment
    let token = collectionRef.borrowMoment(id: id)
        ?? panic("Could not borrow a reference to the specified moment")

    // Get the moment's metadata to access its clip and Set IDs
    let data = token.data

    // Use the moment's clip ID
    // to get all the metadata associated with that clip
    let metadata = SwayMoment.getClipMetaData(clipID: data.clipID) ?? panic("Clip doesn't exist")

    log(metadata)

    return metadata
}
