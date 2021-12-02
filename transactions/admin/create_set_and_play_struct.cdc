import SwayMoment from "../../contracts/SwayMoment.cdc"

transaction() {

    prepare(acct: AuthAccount) {

        let metadata: {String: String} = {"ClipType": "Shoe becomes untied"}

        let newClip = SwayMoment.Clip(metadata: metadata)

        let newSet = SwayMoment.SetData(name: "Sneaky Sneakers")
    }
}
