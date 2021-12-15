

var express = require('express'); 
var app = express();

var cors = require('cors');
app.use(cors());

const keycloak = require('./Keycloak/keycloak-config').getKeycloak();
const mongoose = require('mongoose');

var mongoDB = 'mongodb://mongodb:27017/soasec';
mongoose.connect(mongoDB, 
    {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }
);
db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

db.once('open', async function(callback) {
    console.log("connection to db open")
    const mock_data = require("./Model/mock-data");
    await mock_data.generate_mock_data();
});

app.use(express.json());

app.use(keycloak.middleware());

var anonymous_routes = require('./Routes/anonymous-routes');
var user_routes = require('./Routes/user-routes');
var admin_routes = require('./Routes/admin-routes');

app.use('/anonymous', anonymous_routes); 
app.use('/user', keycloak.protect("user"),user_routes);
app.use('/admin', keycloak.protect("admin"),admin_routes);

app.listen(3050);




