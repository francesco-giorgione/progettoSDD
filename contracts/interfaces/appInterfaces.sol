// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "../application/gestioneUtenti.sol";

interface AcquistoMilkhub {
    function acquistaSilos(string memory _provenienza, string memory  _fornitore, string memory _razzaMucca, string memory _alimentazioneMucca, 
                    uint _quantita, uint _dataProduzione, uint _dataScadenza, string memory user) external;
}

interface ScambioMilkhubProducer {
    function mettiInVenditaPartitaLatte(string[] memory _tipoTrasformazione, uint _dataScadenza, uint _temperaturaConservazione, uint _quantita,
                                            uint[] memory _idSilosUsati, string memory user) external;

    function acquistaPartitaLatte(uint id, string memory user) external;                                            
}

interface ScambioProducerRetailer {
    function mettiInVenditaFormaggio(string[] memory _tipoTrasformazione, uint _stagionatura, uint _dataScadenza, uint _altezza, uint _diametro, 
                                        uint _peso, uint[] memory _idPartiteLatteUsate, string memory user) external;

    function acquistaFormaggio(uint id, string memory user) external;
}

interface ScambioRetailerConsumer {
    function mettiInVenditaPezzoFormaggio(uint _quantita, uint _idFormaggioUsato, string memory user) external;
}

interface GestioneUtenti {
    function getUtenteByUsername(string memory username) external returns (gestioneUtenti.Utente memory);

    function isMilkhub(string memory username) external returns (bool);

    function isProducer(string memory username) external returns (bool);

    function isRetailer(string memory username) external returns (bool);

    function isConsumer(string memory username) external returns (bool);
}