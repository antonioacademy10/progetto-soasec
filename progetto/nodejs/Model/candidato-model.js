const mongoose = require('mongoose');

const Candidato = new mongoose.Schema({
    nome: {
        type: 'String',
        required: true
    },
    cognome: {
        type: 'String',
        required: true
    },
    votanti: [{ 
        type: 'String'
    }]
});

module.exports = mongoose.model("Candidati", Candidato);