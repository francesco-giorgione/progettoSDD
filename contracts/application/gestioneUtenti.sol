// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

contract gestioneUtenti {

    enum Ruolo { Null, Milkhub, Producer, Retailer, Consumer }

    struct Utente {
        string username;
        string PIVA;
        string ragioneSociale;
        string sede;
        Ruolo ruolo;
    }

    Utente milkhub1;
    Utente milkhub2;
    Utente milkhub3;

    Utente producer1;
    Utente producer2;
    Utente producer3;

    Utente retailer1;
    Utente retailer2;
    Utente retailer3;

    mapping(string => Utente) private utenti;

    constructor() {
        popolaUtenti();
    }

    function popolaUtenti() private {
        //definizione statica di un set di utenti milkhub

        milkhub1 = Utente({
            username : "milkhub1",
            PIVA : "55194110072",
            ragioneSociale : "ragione sociale milkhub1",
            sede : "sede milkhub1",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub1"] = milkhub1;

        milkhub2 = Utente({
            username : "milkhub2",
            PIVA : "13828510803",
            ragioneSociale : "ragione sociale milkhub2",
            sede : "sede milkhub2",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub2"] = milkhub2;

         milkhub3 = Utente({
            username : "milkhub3",
            PIVA : "15465950176",
            ragioneSociale : "ragione sociale milkhub3",
            sede : "sede milkhub3",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub3"] = milkhub3;


        //definizione statica di un set di utenti producer

        producer1 = Utente({
            username : "producer1",
            PIVA : "22092130362",
            ragioneSociale : "ragione sociale producer1",
            sede : "sede producer1",
            ruolo : Ruolo.Producer
        });
        utenti["producer1"] = producer1;

        producer2 = Utente({
            username : "producer2",
            PIVA : "69784221009",
            ragioneSociale : "ragione sociale producer2",
            sede : "sede producer2",
            ruolo : Ruolo.Producer
        });
        utenti["producer2"] = producer2;

        producer3 = Utente({
            username : "producer3",
            PIVA : "64135140396",
            ragioneSociale : "ragione sociale producer3",
            sede : "sede producer3",
            ruolo : Ruolo.Producer
        });
        utenti["producer3"] = producer3;


        //definizione statica di un set di utenti retailer

        retailer1 = Utente({
            username : "retailer1",
            PIVA : "64532390826",
            ragioneSociale : "ragione sociale retailer1",
            sede : "sede retailer1",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer1"] = retailer1;

        retailer2 = Utente({
            username : "retailer2",
            PIVA : "42366330944",
            ragioneSociale : "ragione sociale retailer2",
            sede : "sede retailer2",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer2"] = retailer2;

        retailer3 = Utente({
            username : "retailer3",
            PIVA : "19034251207",
            ragioneSociale : "ragione sociale retailer3",
            sede : "sede retailer3",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer3"] = retailer3;
    }

    function getUtenteByUsername(string memory username) public view returns (Utente memory) {
        Utente memory tmp = utenti[username];
        require(tmp.ruolo != Ruolo.Null, "Utente non trovato");
        return tmp;
    }

    function isMilkhub(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Milkhub;
    }
    
        function isProducer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Producer;
    }

        function isRetailer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Retailer;
    }

        function isConsumer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Consumer;
    }

}