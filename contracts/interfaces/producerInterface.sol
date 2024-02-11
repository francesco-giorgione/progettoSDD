// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";

contract ProducerInterface {
    
    address public scambioMilkhubProducerAddress;
    address public scambioProducerRetailerAddress;
    GestioneUtenti private gestioneUtenti;

    constructor(address _scambioMilkhubProducerAddress, address _scambioProducerRetailerAddress, address _gestioneUtentiAddress) {
        scambioMilkhubProducerAddress = _scambioMilkhubProducerAddress;
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        gestioneUtenti = GestioneUtenti(_gestioneUtentiAddress);
    }

    function acquistaPartitaLatte(string memory user, uint id) public {
        require(gestioneUtenti.isProducer(user), "Operazione consentita esclusivamente ai producer: transazione rifiutata");
        ScambioMilkhubProducer scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
        scambioMilkhubProducer.acquistaPartitaLatte(id, user);
    }

    function mettiInVenditaFormaggio(string memory user, string[] memory tipoTrasformazione, uint stagionatura, uint dataScadenza, uint altezza, uint diametro, 
                                        uint peso, uint[] memory idPartiteLatteUsate, string memory user) public {
        require(gestioneUtenti.isProducer(user), "Operazione consentita esclusivamente ai producer: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.mettiInVenditaFormaggio(tipoTrasformazione, stagionatura, dataScadenza, altezza, diametro, peso, idPartiteLatteUsate);
    }
}