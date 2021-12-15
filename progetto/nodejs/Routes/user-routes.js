

var express = require('express'); 
var router = express.Router();

const Candidato = require('../Model/candidato-model.js')

const keycloak = require("../Keycloak/keycloak-config").getKeycloak();

router.patch('/vota/:id', 
	async function(req, res){ 
		try {
			let id = req.params.id;
			console.log("votando: " + id);
			let username = req.kauth.grant.access_token.content.preferred_username;
			let candidato = await Candidato.findById(id);
			await Candidato.updateOne({ _id: id },{ $addToSet: { votanti: username } });

			await candidato.save();
			res.send(
	          	{
	          		"error":false,
	          		"message":"votazione aggiornata correttamente"
	          	}
          	);
		}
		catch (err) {
          res.status(500).send(
          	{
          		"error":true,
          		"message":"impossibile completare la votazione"
          	}
          );
        }
	}
);


module.exports = router;