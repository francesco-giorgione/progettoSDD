// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";
import "./gestioneUtenti.sol";

contract MilkhubInterface {
    
    AcquistoMilkhub private acquistoMilkhub;
    ScambioMilkhubProducer private scambioMilkhubProducer;
    GestioneUtenti private gestioneUtenti;

    constructor(address acquistoMilkhubAddress, address scambioMilkhubProducerAddress, address gestioneUtentiAddress) {
        acquistoMilkhub = AcquistoMilkhub(acquistoMilkhubAddress);
        scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
        gestioneUtenti = GestioneUtenti(gestioneUtentiAddress);
    }

    function acquistaSilos(string memory provenienza, string memory fornitore, string memory razzaMucca, string memory alimentazioneMucca, 
                    uint quantita, uint dataProduzione, uint dataScadenza, string memory user) public { 
        
        require(gestioneUtenti.isMilkhub(user), "Username milkhub errato: transazione rifiutata");
        acquistoMilkhub.acquistaSilos(provenienza, fornitore, razzaMucca, alimentazioneMucca, quantita, dataProduzione, dataScadenza, user);

    }

    function mettiInVenditaPartitaLatte(string[] memory tipoTrasformazione, uint dataScadenza, uint temperaturaConservazione, uint quantita,
                                            uint[] memory idSilosUsati, string memory user) public {
        
        require(gestioneUtenti.isMilkhub(user), "Username milkhub errato: transazione rifiutata");
        scambioMilkhubProducer.mettiInVenditaPartitaLatte(tipoTrasformazione, dataScadenza, temperaturaConservazione, quantita, idSilosUsati, user);
    }
}