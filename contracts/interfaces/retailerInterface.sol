// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";
import "./gestioneUtenti.sol";

contract RetailerInterface {
    
    address public scambioProducerRetailerAddress;
    address public scambioRetailerConsumerAddress;
    GestioneUtenti private gestioneUtenti;

    constructor(address _scambioProducerRetailerAddress, address _scambioRetailerConsumerAddress, address gestioneUtentiAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        scambioRetailerConsumerAddress = _scambioRetailerConsumerAddress;
        gestioneUtenti = GestioneUtenti(gestioneUtentiAddress);
    }

    function acquistaFormaggio(string memory user, uint id) public {
        require(gestioneUtenti.isRetailer(user), "Username retailer errato: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.acquistaFormaggio(id, user);
    }

    function mettiInVenditaPezzoFormaggio(string memory user, uint quantita, uint idFormaggioUsato) public {
        require(gestioneUtenti.isRetailer(user), "Username retailer errato: transazione rifiutata");
        ScambioRetailerConsumer scambioRetailerConsumer = ScambioRetailerConsumer(scambioRetailerConsumerAddress);
        scambioRetailerConsumer.mettiInVenditaPezzoFormaggio(quantita, idFormaggioUsato, user);
    }
}