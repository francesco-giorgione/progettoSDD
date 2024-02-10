// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";

contract MilkhubInterface {
    
    AcquistoMilkhub private acquistoMilkhub;
    ScambioMilkhubProducer private scambioMilkhubProducer;

    constructor(address acquistoMilkhubAddress, address scambioMilkhubProducerAddress) {
        acquistoMilkhub = AcquistoMilkhub(acquistoMilkhubAddress);
        scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
    }

    function acquistaSilos(string memory provenienza, string memory fornitore, string memory razzaMucca, string memory alimentazioneMucca, 
                    uint quantita, uint dataProduzione, uint dataScadenza, string memory user) public { 
        
        // require(isMilkhub(user), "Operazione non consentita ai milkhub: transazione rifiutata");
        acquistoMilkhub.acquistaSilos(provenienza, fornitore, razzaMucca, alimentazioneMucca, quantita, dataProduzione, dataScadenza, user);

    }

    function mettiInVenditaPartitaLatte(string[] memory tipoTrasformazione, uint dataScadenza, uint temperaturaConservazione, uint quantita,
                                            uint[] memory idSilosUsati, string memory user) public {
        
        // require(isMilkhub(user), "Operazione non consentita ai milkhub: transazione rifiutata");
        scambioMilkhubProducer.mettiInVenditaPartitaLatte(tipoTrasformazione, dataScadenza, temperaturaConservazione, quantita, idSilosUsati, user);
    }
}