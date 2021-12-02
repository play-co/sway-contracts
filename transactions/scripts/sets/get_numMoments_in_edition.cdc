import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns the number of specified moments that have been
// minted for the specified edition

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read
// clipID: The unique ID for the clip whose data needs to be read

// Returns: UInt32
// number of moments with specified clipID minted for a set with specified setID

pub fun main(setID: UInt32, clipID: UInt32): UInt32 {

    let numMoments = SwayMoment.getNumMomentsInEdition(setID: setID, clipID: clipID)
        ?? panic("Could not find the specified edition")

    return numMoments
}
