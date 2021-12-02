import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let fusdReceiver: Capability<&FUSD.Vault{FungibleToken.Receiver}>
    let swayMomentProvider: Capability<&SwayMoment.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        // We need a provider capability, but one is not provided by default so we create one if needed.
        let swayMomentCollectionProviderPrivatePath = /private/swayMomentCollectionProviderForNFTStorefront

        self.fusdReceiver = acct.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)!

        assert(self.fusdReceiver.borrow() != nil, message: "Missing or mis-typed FUSD receiver")

        if !acct.getCapability<&SwayMoment.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(swayMomentCollectionProviderPrivatePath)!.check() {
            acct.link<&SwayMoment.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(swayMomentCollectionProviderPrivatePath, target: SwayMoment.CollectionStoragePath)
        }

        self.swayMomentProvider = acct.getCapability<&SwayMoment.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(swayMomentCollectionProviderPrivatePath)!
        assert(self.swayMomentProvider.borrow() != nil, message: "Missing or mis-typed SwayMoment.Collection provider")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    // TODO: how to add playco sales cut?
    execute {
        let saleCut = NFTStorefront.SaleCut(
            receiver: self.fusdReceiver,
            amount: saleItemPrice
        )
        self.storefront.createListing(
            nftProviderCapability: self.swayMomentProvider,
            nftType: Type<@SwayMoment.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FUSD.Vault>(),
            saleCuts: [saleCut]
        )
    }
}
