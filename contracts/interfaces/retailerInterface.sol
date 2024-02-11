// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";

contract RetailerInterface {
    
    address public scambioProducerRetailerAddress;
    address public scambioRetailerConsumerAddress;
    GestioneUtenti gestioneUtenti;

    constructor(address _scambioProducerRetailerAddress, address _scambioRetailerConsumerAddress, address _gestioneUtentiAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        scambioRetailerConsumerAddress = _scambioRetailerConsumerAddress;
        gestioneUtenti = GestioneUtenti(_gestioneUtentiAddress);
    }

    function acquistaFormaggio(string memory user, uint id) public {
        require(GestioneUtenti.isRetailer(user), "Operazione consentita esclusivamente ai retailer: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.acquistaFormaggio(id);
    }

    function mettiInVenditaPezzoFormaggio(string memory user, uint quantita, uint idFormaggioUsato) public {
        require(GestioneUtenti.isRetailer(user), "Operazione consentita esclusivamente ai retailer: transazione rifiutata");
        ScambioRetailerConsumer scambioRetailerConsumer = ScambioRetailerConsumer(scambioRetailerConsumerAddress);
        scambioRetailerConsumer.mettiInVenditaPezzoFormaggio(quantita, idFormaggioUsato, user);
    }
}