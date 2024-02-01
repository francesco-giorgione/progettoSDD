// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";

// per il momento manca id silos usati
// manca id milkhub, id producer e in generale gestione delle identità
contract ScambioMilkhubProducer {

    struct PartitaLatte {
        uint id;
        string[] tipoTrasformazione;
        string dataScadenza;                    // formato ""dd-mm-yyyy"
        uint temperaturaConservazione;
        uint quantita;                          // in litri
        uint dataAcquisto;
        string[] eventiAcquistoSilos;           // id degli eventi riferiti ai silos usati per produrre la partita
    }

    string[] private trasformazioniRichieste = ["Separazione della crema per l'ottenimento di una miscela parzialmente scremata",
                "Aggiunta di siero contenente batteri acidi per 10-12 minuti a temperatura di 33-35 gradi",
                "Aggiunta di caglio di vitello e riposo per 10-12 minuti a temperatura di 33-35 gradi",
                "Rottura della cagliata in piccoli pezzi per 10-12 minuti a temperatura di 55 gradi"];

    address private idGeneratorLibrary;

    constructor(address _idGeneratorLibrary) {
        idGeneratorLibrary = _idGeneratorLibrary;
    }

    // Dichiarazione evento
    event MessaInVenditaPartitaLatte(PartitaLatte partitaLatte);
    event AcquistoPartitaLatte(PartitaLatte partitaLatte);

    // Contiene l'emissione dell'evento di messa in vendita
    function mettiInVenditaPartitaLatte(string[] memory _tipoTrasformazione, string memory _dataScadenza, uint _temperaturaConservazione, uint _quantita, 
                                            string[] memory _eventiAcquistoSilos) public {
        
        (bool success, bytes memory data) = idGeneratorLibrary.delegatecall(abi.encodeWithSignature("getPartitaLatteId()"));
        require(success, "Delegate call fallita");
        
        checkDisciplinare(_tipoTrasformazione, _temperaturaConservazione);

        PartitaLatte memory partitaLatte = PartitaLatte({
            id: abi.decode(data, (uint)),
            tipoTrasformazione: _tipoTrasformazione,
            dataScadenza: _dataScadenza,
            temperaturaConservazione: _temperaturaConservazione,
            quantita: _quantita,
            dataAcquisto: 0,
            eventiAcquistoSilos: _eventiAcquistoSilos
        });

        emit MessaInVenditaPartitaLatte(partitaLatte);
    }

    // Contiene l'emissione dell'evento di acquisto
    // I dati della partita (già esistente) vengono ottenuti tramite interfaccia web3.js e passati a questo metodo
    function acquistaPartitaLatte(uint _id, string[] memory _tipoTrasformazione, string memory _dataScadenza, uint _temperaturaConservazione, uint _quantita, 
                                            string[] memory _eventiAcquistoSilos) public {

        PartitaLatte memory partitaLatte = PartitaLatte({
            id: _id,
            tipoTrasformazione: _tipoTrasformazione,
            dataScadenza: _dataScadenza,
            temperaturaConservazione: _temperaturaConservazione,
            quantita: _quantita,
            dataAcquisto: block.timestamp,
            eventiAcquistoSilos: _eventiAcquistoSilos
        });                                    

        emit AcquistoPartitaLatte(partitaLatte);
    }

    function checkDisciplinare(string[] memory tipoTrasformazione, uint temperaturaConservazione) public view {
        require(temperaturaConservazione >= 18, "Temperatura di conservazione non lecita: registrazione rifiutata");
        require(tipoTrasformazione.length == trasformazioniRichieste.length, "Tipo di trasformazione non lecita: registrazione rifiutata");
        require(Utils.compareStringArrays(tipoTrasformazione, trasformazioniRichieste), "Tipo di trasformazione non lecita: registrazione rifiutata");
    }
}