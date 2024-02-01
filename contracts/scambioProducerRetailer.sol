// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";

// manca id producer, id retailer e in generale gestione delle identità
contract ScambioProducerRetailer {

    // i valori associati a id (chiavi) non ancora inizializzati sono false di default
    mapping (uint => bool) idFormaggiVenduti;

    struct Formaggio {
        uint id;
        string[] tipoTrasformazione;
        // 1 CERT. 12 MESI --- 2 CERT. 18 MESI --- 3 CERT. 24 MESI --- 4 CERT. 30 MESI
        uint certificatoStagionatura;
        string dataScadenza;  // formato ""dd-mm-yyyy"
        uint altezza;       // in pollici/10
        uint diametro;      // in pollici
        uint peso;          // in libbre
        uint dataAcquisto;
        string[] eventiAcquistoPartitaLatte;      // id degli eventi riferiti alle partite di latte usate per produrre il formaggio
    }

    string[] private trasformazioniRichieste = ["Brandizzazione con il logo del consorzio",
                "Conservazione per 6 mesi in aging room a una temperatura di 18-20 gradi",
                "Immersione per 20-25 giorni in acqua salina a temperatura di 16-18 gradi",
                "Conservazione per 2-3 giorni in una ruota d'acciaio a temperatura di 16-18 gradi"];

    address private idGeneratorLibrary;

    constructor(address _idGeneratorLibrary) {
        idGeneratorLibrary = _idGeneratorLibrary;
    }

    // Dichiarazione evento
    event MessaInVenditaFormaggio(Formaggio formaggio);
    event AcquistoFormaggio(Formaggio formaggio);

    // Contiene l'emissione dell'evento
    function mettiInVenditaFormaggio(string[] memory _tipoTrasformazione, uint _stagionatura, string memory _dataScadenza, uint _altezza, uint _diametro, uint _peso,
                                        string[] memory _eventiAcquistoPartitaLatte) public {
        
        (bool success, bytes memory data) = idGeneratorLibrary.delegatecall(abi.encodeWithSignature("getFormaggioId()"));
        require(success, "Delegate call fallita");

        checkDisciplinare(_tipoTrasformazione, _stagionatura, _altezza, _diametro, _peso);

        Formaggio memory formaggio = Formaggio({
            id: abi.decode(data, (uint)),
            tipoTrasformazione: _tipoTrasformazione,
            certificatoStagionatura: getCertificatoStagionatura(_stagionatura),
            dataScadenza: _dataScadenza,
            altezza: _altezza,
            diametro: _diametro,
            peso: _peso,
            dataAcquisto: 0,
            eventiAcquistoPartitaLatte: _eventiAcquistoPartitaLatte
        });

        emit MessaInVenditaFormaggio(formaggio);
    }

    // Contiene l'emissione dell'evento di acquisto
    // I dati del formaggio (già esistente) vengono ottenuti tramite interfaccia web3.js e passati a questo metodo
    function acquistaFormaggio(uint _id, string[] memory _tipoTrasformazione, uint _certificatoStagionatura, string memory _dataScadenza, uint _altezza, uint _diametro, uint _peso,
                                    string[] memory _eventiAcquistoPartitaLatte) public {

        bool isFormaggioGiaVenduto = idFormaggiVenduti[_id];
        require(!isFormaggioGiaVenduto, "Il formaggio e' gia' stato venduto: operazione rifiutata");

        Formaggio memory formaggio = Formaggio({
            id: _id,
            tipoTrasformazione: _tipoTrasformazione,
            certificatoStagionatura: _certificatoStagionatura,
            dataScadenza: _dataScadenza,
            altezza: _altezza,
            diametro: _diametro,
            peso: _peso,
            dataAcquisto: block.timestamp,
            eventiAcquistoPartitaLatte: _eventiAcquistoPartitaLatte
        });

        idFormaggiVenduti[_id] = true;
        emit AcquistoFormaggio(formaggio);
    }

    function checkDisciplinare(string[] memory tipoTrasformazione, uint stagionatura, uint altezza, uint diametro, uint peso) private view {
        require(stagionatura >= 12, "Tempo di stagionatura insufficiente: registrazione rifiutata");
        require(altezza >= 71 && altezza <= 94, "Altezza del formaggio non lecita: registrazione rifiutata");
        require(diametro >= 16 && diametro <= 18, "Diametro del formaggio non lecito: registrazione rifiutata");
        require(peso == 84, "Peso del formaggio non lecito: registrazione rifiutata");
        require(tipoTrasformazione.length == trasformazioniRichieste.length, "Tipo di trasformazione non lecita: registrazione rifiutata");
        require(Utils.compareStringArrays(tipoTrasformazione, trasformazioniRichieste), "Tipo di trasformazione non lecita: registrazione rifiutata");
    }

    function getCertificatoStagionatura(uint stagionatura) private pure returns(uint) {
        if(stagionatura < 18)           return 1;       // CERTIFICATO 12 MESI
        if(stagionatura < 24)           return 2;       // CERTIFICATO 18 MESI
        if(stagionatura < 30)           return 3;       // CERTIFICATO 24 MESI
        return 4;                                       // CERTIFICATO 30 MESI
    }
}