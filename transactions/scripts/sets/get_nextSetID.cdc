import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script reads the next Set ID from the SwayMoment contract and
// returns that number to the caller

// Returns: UInt32
// Value of nextSetID field in SwayMoment contract

pub fun main(): UInt32 {

    log(SwayMoment.nextSetID)

    return SwayMoment.nextSetID
}
