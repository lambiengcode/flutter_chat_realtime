require("dotenv").config();
const express = require("express");
const app = express();
const server = require("http").Server(app);
const io = require("socket.io")(server);
const connectDatabase = require("./common/connectDb");
const { getAllMessages, addMessage } = require("./controllers/Message");

connectDatabase();

io.on("connection", function (socket) {
  var id;

  socket.on("join", function (msg) {
    id = msg;
  });

  socket.on("subscribe", async function (roomInfo) {
    socket.join(roomInfo);
    const history = await getAllMessages(roomInfo);
    io.emit(`${id}-${roomInfo}-history`, history);

    socket.on(roomInfo, async function (msg) {
      socket.broadcast.to(roomInfo).emit(roomInfo, {
        msg: msg,
        id: id,
      });
      await addMessage({ msg: msg, id: id }, roomInfo);
    });

    socket.on(`${roomInfo}-typing`, function (typing) {
      socket.broadcast.to(roomInfo).emit(`${roomInfo}-typing`, {
        id: id,
        name: typing.name,
        isTyping: typing.isTyping,
      });
    });
  });

  socket.on("unsubscribe", function (roomInfo) {
    socket.leave(roomInfo);
    socket.removeAllListeners(roomInfo);
  });
});

server.listen(process.env.PORT, "0.0.0.0", function () {
  console.log("Server is running on port: " + process.env.PORT);
});
