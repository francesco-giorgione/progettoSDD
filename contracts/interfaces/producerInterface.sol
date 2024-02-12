// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";
import "./gestioneUtenti.sol";

contract ProducerInterface {
    
    address private scambioMilkhubProducerAddress;
    address private scambioProducerRetailerAddress;
    address private nodoChiamanteAddress;
    GestioneUtenti private gestioneUtenti;

    constructor(address _scambioMilkhubProducerAddress, address _scambioProducerRetailerAddress, address _nodoChiamanteAddress, address gestioneUtentiAddress) {
        scambioMilkhubProducerAddress = _scambioMilkhubProducerAddress;
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        nodoChiamanteAddress = _nodoChiamanteAddress;
        gestioneUtenti = GestioneUtenti(gestioneUtentiAddress);
    }

    function acquistaPartitaLatte(string memory user, uint id) public {
        require(msg.sender == nodoChiamanteAddress, "Chiamante non autorizzato, la transazione deve provenire dal nodo firefly");
        require(gestioneUtenti.isProducer(user), "Username producer errato: transazione rifiutata");
        ScambioMilkhubProducer scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
        scambioMilkhubProducer.acquistaPartitaLatte(id, user);
    }

    function mettiInVenditaFormaggio(string[] memory tipoTrasformazione, uint stagionatura, uint dataScadenza, uint altezza, uint diametro, 
                                        uint peso, uint[] memory idPartiteLatteUsate, string memory user) public {
        require(msg.sender == nodoChiamanteAddress, "Chiamante non autorizzato, la transazione deve provenire dal nodo firefly");
        require(gestioneUtenti.isProducer(user), "Username producer errato: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.mettiInVenditaFormaggio(tipoTrasformazione, stagionatura, dataScadenza, altezza, diametro, peso, idPartiteLatteUsate, user);
    }
}