const mongoose = require('mongoose');

connectDatabase = () => {
  mongoose.connect(`${process.env.DB_URL}`, {
    //mongoose.connect(`mongodb://${process.env.DB_URL}/${process.env.DB_NAME}`, {
    useUnifiedTopology: true,
    useFindAndModify: false,
    useNewUrlParser: true,
    useCreateIndex: true
  }).then(async () => {
    console.log('Connect Db successfully');
  }).catch(err => {
    console.log(err);
  });
};

module.exports = connectDatabase;