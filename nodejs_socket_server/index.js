require("dotenv").config();
const express = require("express");
const app = express();
const server = require("http").Server(app);
const io = require("socket.io")(server);
const connectDatabase = require('./common/connectDb');
const {getAllMessages, addMessage} = require('./controllers/Message');

connectDatabase();

io.on("connection", function (socket) {
  var id;

  socket.on("join", function (msg) {
    id = msg;
  });

  socket.on("subscribe", async function (roomInfo) {
    console.log(roomInfo);
    socket.join(roomInfo);

    socket.to(roomInfo).on(roomInfo, function (msg) {
      io.emit(roomInfo, {
        msg: msg,
        id: id,
      });
      addMessage({msg: msg, id: id}, roomInfo);
    });

    const history = await getAllMessages(roomInfo);
    console.log(history);
    socket.to(roomInfo).emit(`${roomInfo}-history`, history);

    socket.to(roomInfo).on(`${roomInfo}-typing`, function (typing) {
      socket.to(roomInfo).emit(`${roomInfo}-typing`, {
        id: id,
        name: typing.name,
        isTyping: typing.isTyping,
      });
    });
  });

  socket.on("unsubscribe", function (roomInfo) {
    socket.to(roomInfo).emit(`${roomInfo}-typing`, {
      id: id,
      name: id,
      isTyping: false,
    });
    socket.to(roomInfo).emit(roomInfo, {
      msg: `${id} left.`,
      id: id,
    });
    socket.leave(roomInfo);
  });
});

server.listen(process.env.PORT, "0.0.0.0", function () {
  console.log("Server is running on port: " + process.env.PORT);
});
