import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns the value for the specified metadata field
// associated with a clip in the SwayMoment smart contract

// Parameters:
//
// clipID: The unique ID for the clip whose data needs to be read
// field: The specified metadata field whose data needs to be read

// Returns: String
// Value of specified metadata field associated with specified clipID

pub fun main(clipID: UInt32, field: String): String {

    let field = SwayMoment.getClipMetaDataByField(clipID: clipID, field: field) ?? panic("Clip doesn't exist")

    log(field)

    return field
}
