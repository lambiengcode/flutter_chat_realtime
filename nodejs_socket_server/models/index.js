const mongoose = require('mongoose');
const MessageSchema = require('./Messages')

const Schema = mongoose.Schema

const createSchema = (schema) => {
  const model = new Schema(schema, { timestamps: true })
  return model
}

const Messages = mongoose.model('Messages', createSchema(MessageSchema))


module.exports = {
  Messages,
}