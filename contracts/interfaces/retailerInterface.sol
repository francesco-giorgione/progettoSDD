// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";
import "./gestioneUtenti.sol";

contract RetailerInterface {
    
    address private scambioProducerRetailerAddress;
    address private scambioRetailerConsumerAddress;
    address private nodoChiamanteAddress;
    GestioneUtenti private gestioneUtenti;

    constructor(address _scambioProducerRetailerAddress, address _scambioRetailerConsumerAddress, address _nodoChiamanteAddress, address gestioneUtentiAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        scambioRetailerConsumerAddress = _scambioRetailerConsumerAddress;
        nodoChiamanteAddress = _nodoChiamanteAddress;
        gestioneUtenti = GestioneUtenti(gestioneUtentiAddress);
    }

    function acquistaFormaggio(string memory user, uint id) public {
        require(msg.sender == nodoChiamanteAddress, "Chiamante non autorizzato, la transazione deve provenire dal nodo firefly");
        require(gestioneUtenti.isRetailer(user), "Username retailer errato: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.acquistaFormaggio(id, user);
    }

    function mettiInVenditaPezzoFormaggio(string memory user, uint idFormaggioUsato) public {
        require(msg.sender == nodoChiamanteAddress, "Chiamante non autorizzato, la transazione deve provenire dal nodo firefly");
        require(gestioneUtenti.isRetailer(user), "Username retailer errato: transazione rifiutata");
        ScambioRetailerConsumer scambioRetailerConsumer = ScambioRetailerConsumer(scambioRetailerConsumerAddress);
        scambioRetailerConsumer.mettiInVenditaPezzoFormaggio(idFormaggioUsato, user);
    }
}