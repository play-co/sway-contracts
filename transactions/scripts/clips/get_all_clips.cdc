import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns an array of all the clips
// that have ever been created for Sway Moment

// Returns: [SwayMoment.Clip]
// array of all clips created for SwayMoment

pub fun main(): [SwayMoment.Clip] {

    return SwayMoment.getAllClips()
}
