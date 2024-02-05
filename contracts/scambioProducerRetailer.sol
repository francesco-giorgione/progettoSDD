// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";

// manca id producer, id retailer e in generale gestione delle identità
contract ScambioProducerRetailer {

    struct Formaggio {
        uint id;
        string[] tipoTrasformazione;

        // 1 CERT. 12 MESI --- 2 CERT. 18 MESI --- 3 CERT. 24 MESI --- 4 CERT. 30 MESI
        uint certificatoStagionatura;
        string dataScadenza;        // formato "dd-mm-yyyy"
        uint altezza;               // in pollici/10
        uint diametro;              // in pollici
        uint peso;                  // in libbre
        uint dataAcquisto;
        uint[] idPartiteLatteUsate;
    }

    uint private lastFormaggioId;
    string[] private trasformazioniRichieste = ["Brandizzazione con il logo del consorzio",
                "Conservazione per 6 mesi in aging room a una temperatura di 18-20 gradi",
                "Immersione per 20-25 giorni in acqua salina a temperatura di 16-18 gradi",
                "Conservazione per 2-3 giorni in una ruota d'acciaio a temperatura di 16-18 gradi"];

    mapping(uint => Formaggio) public allFormaggi;
    address public scambioMilkhubProducerAddress;

    event MessaInVenditaFormaggio(Formaggio);
    event AcquistoFormaggio(Formaggio);

    constructor(address _scambioMilkhubProducerAddress) {
        scambioMilkhubProducerAddress = _scambioMilkhubProducerAddress;
    }


    function mettiInVenditaFormaggio(string[] memory _tipoTrasformazione, uint _stagionatura, string memory _dataScadenza, uint _altezza, uint _diametro, 
                                        uint _peso, uint[] memory _idPartiteLatteUsate) public {

        // checkDati(_tipoTrasformazione, _stagionatura, _altezza, _diametro, _peso);
        uint _id = getId();

        Formaggio memory daVendere = Formaggio({
            id:                         _id,
            tipoTrasformazione:         _tipoTrasformazione,
            certificatoStagionatura:    getCertificatoStagionatura(_stagionatura),
            dataScadenza:               _dataScadenza,
            altezza:                    _altezza,
            diametro:                   _diametro,
            peso:                       _peso,
            dataAcquisto:               0,
            idPartiteLatteUsate:        _idPartiteLatteUsate
        });

        allFormaggi[_id] = daVendere;
        emit MessaInVenditaFormaggio(daVendere);
    }

    function acquistaFormaggio(uint id) public {
        Formaggio memory daAcquistare = allFormaggi[id];

        // Se i campi di daAcquistare contengono i valori di default, significa che non esiste una partita di latte associata all'id. Il controllo viene eseguito sul
        // campo alettza, ma può essere eseguito anche su altri campi
        require(daAcquistare.altezza > 0, "Formaggio non trovato: operazione rifiutata");

        require(daAcquistare.dataAcquisto == 0, "Il formaggio e' gia' stato venduto: operazione rifiutata");  

        daAcquistare.dataAcquisto = block.timestamp;
        allFormaggi[id] = daAcquistare;
        emit AcquistoFormaggio(daAcquistare);
    }

    function checkDisciplinare(string[] memory tipoTrasformazione, uint stagionatura, uint altezza, uint diametro, uint peso) private view {
        require(stagionatura >= 12, "Tempo di stagionatura insufficiente: registrazione rifiutata");
        require(altezza >= 71 && altezza <= 94, "Altezza del formaggio non lecita: registrazione rifiutata");
        require(diametro >= 16 && diametro <= 18, "Diametro del formaggio non lecito: registrazione rifiutata");
        require(peso == 84, "Peso del formaggio non lecito: registrazione rifiutata");
        require(tipoTrasformazione.length == trasformazioniRichieste.length, "Tipo di trasformazione non lecita: registrazione rifiutata");
        require(Utils.compareStringArrays(tipoTrasformazione, trasformazioniRichieste), "Tipo di trasformazione non lecita: registrazione rifiutata");
    }

    function checkDati(string[] memory tipoTrasformazione, uint stagionatura, uint altezza, uint diametro, uint peso, uint[] memory idPartiteLatteUsate) private view {
        /* ScambioMilkhubProducer scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
        
        for(uint i=0; i < idPartiteLatteUsate.length; i++) {
            PartitaLatte memory tmp = scambioMilkhubProducer.allPartiteLatte[idPartiteLatteUsate[i]];
            require(tmp.quantita > 0, "Almeno una delle partite di latte usate non esiste: operazione rifiutata");
        }

        checkDisciplinare(tipoTrasformazione, stagionatura, altezza, diametro, peso); */
    }

    function getCertificatoStagionatura(uint stagionatura) private pure returns(uint) {
        if(stagionatura < 18)           return 1;       // CERTIFICATO 12 MESI
        if(stagionatura < 24)           return 2;       // CERTIFICATO 18 MESI
        if(stagionatura < 30)           return 3;       // CERTIFICATO 24 MESI
        return 4;                                       // CERTIFICATO 30 MESI
    }

    function getId() private returns(uint) {
        lastFormaggioId += 1;
        return lastFormaggioId;
    }
}