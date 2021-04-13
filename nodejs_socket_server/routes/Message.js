const routes = require('express').Router();
const {getAllMessages} = require('../controllers/Message');

routes.get('/getMessageByRoom', getAllMessages);

module.exports = routes;