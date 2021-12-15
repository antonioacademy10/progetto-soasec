# Progetto SOASEC Front-End

Progetto esame Sicurezza delle Architetture Orientate ai Servizi: Back-End

Affinchè sia possibile interagire con tale progetto bisognerà utilizzare l'interfaccia grafica raggiungibile al seguente link:

[Demo App Front-End](https://antonioacademy10.github.io/progetto-soasec-github-pages/#/)

Bisognerà tutavia eseguire alcune configurazioni iniziali necessarie al corretto funzionamento del progetto.

Queste sono recuperabili al seguente [repository](https://github.com/antonioacademy10/progetto-soasec-github-pages).

# Getting Started

## Pre-Requisiti
La componente Back-End del progetto disponibile a tale repository è completamente funzionante *out-of-the-box*.

Tale progetto presenta un architettura a 3 blocchi costituita dai seguenti:

 - Server NodeJS (Services)
 - Server Keycloak (Auth)
 - Server MongoDB (Storage)

## Framework/Linguaggi utilizzati

 - [Keycloak](https://www.keycloak.org/)
 - [NodeJS](https://www.nodejs.org/)
- [MongoDB](https://www.mongodb.com/)
- [Docker](https://docker.com/)

# Installazione & Utilizzo
Come precedentemente specificato, tale progetto risulta immediatamente funzionante senza la necessità di eseguire alcuna configurazione particolare.

Nello specifico infatti basterà eseguire un *clone*  di tale repository, a questo punto bisognerà navigare tramite terminale alla cartella **nodejs** e quindi avviare il tutto.

Per far ciò quindi bisognerà:

> cd ./progetto/nodejs/

e successivamente

> docker-compose up --build

Tale comando sfrutterà quindi la configurazione presente nel file docker-compose.yaml al fine di scaricare le dipendenze necessarie per il corretto funzionamento del tutto.

Per impostazione di default sono esposti quindi i seguenti servizi alle seguenti porte:

| Service  | Port |
| ------------- | ------------- |
| Keycloak  | 8080 |
| NodeJS  | 3050  |
| MongoDB  | 6060 |

Per quanto riguarda gli endpoint esposti dal server NodeJS invece:

| URL Path  | HTTP Request Type | Role |
| ------------- | ------------- | ---------- |
| /anonymous/lista-candidati  | GET |  |
| /user/vota/:id  | PATCH | User  |
| /admin/creazione-nuovo-candidato  | POST | Admin  |
| /admin/cancella-candidato/:id  | DELETE | Admin  |

# Contatti

Antonio Elefante - antonioacademy10@gmail.com

Salvatore Ambrosio
