/**
 * Results App Server
 * This server provides real-time results of the voting
 * using web sockets and a PostgreSQL database.
 * It serves a static HTML/JS frontend for displaying the results.
 */
var path = require('path')
var express = require('express'),
    async = require('async'),
    { Pool } = require('pg'),
    cookieParser = require('cookie-parser'),
    app = express(),
    server = require('http').Server(app),
    io = require('socket.io')(server);

var port = process.env.PORT || process.env.SERVER_PORT || 4000;
var pgHost = process.env.PGSQL_HOST_NAME || "localhost";
var pgUsername = process.env.POSTGRES_USER || "postgres";
var pgPassword = process.env.POSTGRES_PASSWORD || "postgres";
var pgDBName = process.env.POSTGRES_DBNAME || "postgres";
var pgPort = process.env.PGSQL_PORT || 5432;

io.on('connection', function (socket) {

  socket.emit('message', { text : 'Welcome!' });

  socket.on('subscribe', function (data) {
    socket.join(data.channel);
  });
});

var pool = new Pool({
  connectionString: `postgresql://${pgUsername}:${pgPassword}@${pgHost}:${pgPort}/${pgDBName}`
});

async.retry(
  {times: 1000, interval: 1000},
  function(callback) {
    pool.connect(function(err, client, done) {
      if (err) {
        console.error("Waiting for db");
      }
      callback(err, client);
    });
  },
  function(err, client) {
    if (err) {
      return console.error("Giving up");
    }
    console.log("Connected to db");
    getVotes(client);
  }
);

/**
 * This function queries the database for vote counts
 * and emits the results to all connected clients every second.
 * @param {*} client
 */
function getVotes(client) {
  client.query('SELECT vote, COUNT(id) AS count FROM votes GROUP BY vote', [], function(err, result) {
    if (err) {
      console.error("Error performing query: " + err);
    } else {
      var votes = collectVotesFromResult(result);
      io.sockets.emit("scores", JSON.stringify(votes));
    }

    setTimeout(function() {getVotes(client) }, 1000);
  });
}

/**
 * This function collects votes from the result of the query
 * and returns an object with counts for 'a' and 'b'.
 * @param {*} result 
 * @returns {a: int, b: int} votes 
 */
function collectVotesFromResult(result) {
  var votes = {a: 0, b: 0};

  result.rows.forEach(function (row) {
    votes[row.vote] = parseInt(row.count);
  });

  return votes;
}

app.use(cookieParser());
app.use(express.urlencoded());
app.use(express.static(__dirname + '/views'));

app.get('/', function (req, res) {
  res.sendFile(path.resolve(__dirname + '/views/index.html'));
});

// Start the server
server.listen(port, function () {
  var port = server.address().port;
  console.log('App running on port ' + port);
});
