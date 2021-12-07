var express = require('express'); 
var router = express.Router();

const Candidato = require('../Model/candidato-model.js')

router.get('/lista-candidati', 
    async function(req, res) {
        try {
            candidati = await Candidato.find();
            res.send(
                {
                    "error":"false",
                    "message":"lista candidati recuperata correttamente",
                    "data":candidati
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