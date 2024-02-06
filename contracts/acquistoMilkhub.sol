// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";

// manca id milkhub e in generale gestione delle identità
contract AcquistoMilkhub {

    struct Silos {
        uint id;
        string provenienza;
        string fornitore;
        string razzaMucca;
        string alimentazioneMucca;
        uint quantita;                  // in litri
        uint dataProduzione;
        uint dataAcquisto;
        uint dataScadenza;              
    }

    uint private lastSilosId;
    string[] private provenienzeLatteOk = ["Provincia di Parma", "Provincia di Reggio Emilia", "Provincia di Modena", "Provincia di Bologna (ovest del Reno)", 
                                                "Provincia di Mantova (sud del Po)"];
    string[] private razzeMuccaOk = ["frisona", "reggiana rossa"];
    string[] private alimentazioniMuccaOk = ["erba", "fieno"];

    mapping(uint => Silos) private allSilos;

    event AcquistoSilos(Silos silos);


    constructor() {
        lastSilosId = 0;
    }


    function acquistaSilos(string calldata _provenienza, string calldata _fornitore, string calldata _razzaMucca, string calldata _alimentazioneMucca, 
                    uint _quantita, uint _dataProduzione, uint _dataScadenza) public { 

        checkDati(_dataProduzione, _dataScadenza, _provenienza, _razzaMucca, _alimentazioneMucca);
        uint _id = getId();

        Silos memory daAcquistare = Silos({
            id:                   _id,
            provenienza:          _provenienza,
            fornitore:            _fornitore,
            razzaMucca:           _razzaMucca,
            alimentazioneMucca:   _alimentazioneMucca,
            quantita:             _quantita,
            dataProduzione:       _dataProduzione,
            dataAcquisto:         block.timestamp,
            dataScadenza:         _dataScadenza
        });
        
        allSilos[_id] = daAcquistare;
        emit AcquistoSilos(daAcquistare);
    }

    function checkDisciplinare(string calldata provenienza, string calldata razzaMucca, string calldata alimentazioneMucca) private view {
        require(Utils.findString(provenienzeLatteOk, provenienza), "Provenienza non lecita: registrazione rifiutata");
        require(Utils.findString(razzeMuccaOk, razzaMucca), "Razza mucca non lecita: registrazione rifiutata");
        require(Utils.findString(alimentazioniMuccaOk, alimentazioneMucca), "Alimentazione mucca non lecita: registrazione rifiutata");
    }

    function checkDati(uint dataProduzione, uint dataScadenza, string calldata provenienza, string calldata razzaMucca, string calldata alimentazioneMucca) private view {
        require(dataProduzione < block.timestamp, "La data di produzione deve essere antecedente alla data attuale");
        require(dataScadenza > block.timestamp, "La data di scadenza deve essere successiva alla data attuale");
        checkDisciplinare(provenienza, razzaMucca, alimentazioneMucca);
    }

    function getId() private returns(uint) {
        lastSilosId += 1;
        return lastSilosId;
    }

    function getById(uint id) public view returns(Silos memory) {
        return allSilos[id];
    }
}
