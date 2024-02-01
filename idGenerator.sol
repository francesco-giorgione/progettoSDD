// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

contract IdGenerator {
    uint private lastSilosId = 0;
    uint private lastPartitaLatteId = 0;
    uint private lastFormaggioId = 0;
    uint private lastPezzoFormaggioId = 0;

    function getSilosId() public returns (uint) {
        lastSilosId += 1;
        return lastSilosId;
    }

    function getPartitaLatteId() public returns (uint) {
        lastPartitaLatteId += 1;
        return lastPartitaLatteId;
    } 

    function getFormaggioId() public returns (uint) {
        lastFormaggioId += 1;
        return lastFormaggioId;
    }

    function getPezzoFormaggioId() public returns (uint) {
        lastPezzoFormaggioId += 1;
        return lastPezzoFormaggioId;
    }
}