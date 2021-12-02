import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns the full metadata associated with a clip
// in the SwayMoment smart contract

// Parameters:
//
// clipID: The unique ID for the clip whose data needs to be read

// Returns: {String:String}
// A dictionary of all the clip metadata associated
// with the specified clipID

pub fun main(clipID: UInt32): {String:String} {

    let metadata = SwayMoment.getClipMetaData(clipID: clipID) ?? panic("Clip doesn't exist")

    log(metadata)

    return metadata
}
