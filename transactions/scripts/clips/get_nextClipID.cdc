import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script reads the public nextClipID from the SwayMoment contract and
// returns that number to the caller

// Returns: UInt32
// the nextClipID field in SwayMoment contract

pub fun main(): UInt32 {

    log(SwayMoment.nextClipID)

    return SwayMoment.nextClipID
}
