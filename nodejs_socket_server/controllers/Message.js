const {Messages} = require("../models/index");

async function getAllMessages(roomInfo) {
  const payload = await Messages.find({
    room: roomInfo,
  });
  return payload;
}

async function addMessage(message, roomInfo) {
    const payload = await Messages.create(
        {
            msg: message.msg,
            id: message.id,
            room: roomInfo,
        }
    );
    return payload;
  }

module.exports = {
  getAllMessages,
  addMessage,
};
