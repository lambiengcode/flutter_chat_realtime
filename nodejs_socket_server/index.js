require("dotenv").config();
var express = require("express");
var app = express();
var server = require("http").Server(app);
var io = require("socket.io")(server);

app.get("/", (req, res) => {
  res.write(`<html>
    <head>
      <title>Socket.IO chat</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        body {
          font: 14px Helvetica, Arial;
        }
        form {
          background: #000;
          padding: 3px;
          position: fixed;
          bottom: 0;
          width: 100%;
        }
        form input {
          border: 0;
          padding: 10px;
          width: 90%;
          margin-right: 0.5%;
        }
        form button {
          width: 9%;
          background: #5196f4;
          border: none;
          padding: 12px;
        }
        #messages {
          list-style-type: none;
          margin: 0;
          padding: 0;
        }
        #messages li {
          padding: 5px 10px;
        }
        #messages li:nth-child(odd) {
          background: #eee;
        }
      </style>
    </head>
    <body>
      <ul id="messages"></ul>
      <form action="">
        <input id="m" autocomplete="off" /><button>Send</button>
      </form>
    </body>
  
    <script src="/socket.io/socket.io.js"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script>
      $(function () {
        var socket = io();
        socket.emit("join", "18110240");
        $("form").submit(function (e) {
          e.preventDefault(); // prevents page reloading
          socket.emit("room", $("#m").val());
          $("#m").val("");
          return false;
        });
        socket.on("msg", function (history) {
          history.forEach(e=>$("#messages").append($("<li>").text(e)));
        });
        socket.on("room", function (msg) {
          $("#messages").append($("<li>").text(msg.msg));
        });
      });
    </script>
  </html>
  `);

  res.end();
});

io.on("connection", function (socket) {
  console.log(socket.id, "joined");
  var id;

  socket.on("join", function (msg) {
    id = msg;
    console.log(msg);
  });

  socket.on("typing", function (typing) {
    io.emit(typing.id, {
      id: id,
      name: typing.name,
      isTyping: typing.isTyping,
    });
  });

  socket.on("room", function (msg) {
    io.emit("room", {
      msg: msg,
      id: id,
    });
  });
});

server.listen(process.env.PORT, "0.0.0.0", function () {
  console.log("Server is running on port: " + process.env.PORT);
});
