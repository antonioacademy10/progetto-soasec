const Candidato = require('../Model/candidato-model.js')

async function generate_mock_data() {
	await Candidato.collection.drop();
	const nuovoCandidato1 = new Candidato({
        'nome': "Aldo",
        'cognome': "Baglio",
        'creato_da':"antonio.elefante",
        'votanti': []
    });
    await nuovoCandidato1.save();
    const nuovoCandidato2 = new Candidato({
        'nome': "Giovanni",
        'cognome': "Storti",
        'creato_da':"antonio.elefante",
        'votanti': []
    });
    await nuovoCandidato2.save();
    const nuovoCandidato3 = new Candidato({
        'nome': "Giacomo",
        'cognome': "Poretti",
        'creato_da':"antonio.elefante",
        'votanti': []
    });
    await nuovoCandidato3.save();
}


module.exports = {generate_mock_data}