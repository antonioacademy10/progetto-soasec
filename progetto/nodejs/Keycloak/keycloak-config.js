var session = require('express-session');
var Keycloak = require('keycloak-connect');

var keycloakConfig = {
    clientId: 'secure-nodejs-application', 
    bearerOnly: true,
    serverUrl: 'http://keycloak:8080/auth', 
    realm: 'SOASEC',
    credentials: {
        secret: 'e51bfd3e-6634-4319-bafa-e8022ee9f03b' 
    },
};

var _keycloak;

function getKeycloak() {
    if (_keycloak) {
        console.log("Keycloak già inizializzato")
        return _keycloak;
    }
    return initKeycloak();
}
function initKeycloak() {
    
    console.log("Inizializzazione connessione al server Keycloak...");
    var memoryStore = new session.MemoryStore();
    _keycloak = new Keycloak(
    { 
        store: memoryStore
    }, keycloakConfig);
    console.log("Keycloak inizializzato");
    return _keycloak;
    
}

module.exports = {
    initKeycloak,
    getKeycloak
}
