var express = require('express');
var router = express.Router();

var Candidato = require('../Model/candidato-model.js')

router.post('/creazione-nuovo-candidato', 
    async function(req, res) {
        try {
        	console.log("creazione nuovo candidato");
        	let username = req.kauth.grant.access_token.content.preferred_username;
            const nuovoCandidato = new Candidato({
                'nome': req.body.nome,
                'cognome': req.body.cognome,
                'creato_da':username,
                'votanti': []
            });
            await nuovoCandidato.save();
            res.send(
                {
                    "error":"false",
                    "message":"candidato creato correttamente"
                }
            )
        } catch (err) {
          res.status(500).send(
          	{
          		"error":true,
          		"message":err
          	}
          );
        }
    }
);

router.delete('/cancella-candidato/:id', 
    async function(req, res) {
        try {
        	let id = req.params.id;
            await Candidato.findOneAndRemove({_id: id}).exec();
            res.send(
                {
                    "error":"false",
                    "message":"candidato rimosso correttamente"
                }
            )
        } catch (err) {
          res.status(500).send(
          	{
          		"error":true,
          		"message":err
          	}
          );
        }
    }
);

module.exports = router;