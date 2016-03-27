// webサーバ
var app = require('http').createServer(handler);
var io = require('socket.io').listen(app);

var fs = require('fs');
var html = fs.readFileSync('monitor.html', 'utf8');
var c3_css = fs.readFileSync('c3/c3.css', 'utf8');
var c3_js = fs.readFileSync('c3/c3.min.js', 'utf8');
var d3_js = fs.readFileSync('d3/d3.min.js', 'utf8');
app.listen(8124);

function handler(req, res){
 console.log(req.url);
 if(req.url == '/c3/c3.css'){
    res.writeHeader('Content-Type', 'text/css');
    res.write(c3_css);
 }else if(req.url == '/c3/c3.min.js'){
    res.writeHeader('Content-Type', 'text/javascript');
    res.write(c3_js);
 }else if(req.url == '/d3/d3.min.js'){
    res.writeHeader('Content-Type', 'text/javascript');
    res.write(d3_js);
 }else{
    res.writeHeader('Content-Type', 'text/html');
    res.write(html);
 }
 res.end();
}

var web_socket;
io.sockets.on('connection', function(socket){
    console.log("web_socket connection");
    web_socket = socket;
});

// センサクライアント
var net = require('net');

var client = net.createConnection(24, '192.168.1.14', function() {
	console.log('client connected');
	sendRequestMessage();
});

// 1秒毎にポーリングを実施し、センサデータを受信する
function sendRequestMessage(){
  
  client.write('a');

  setTimeout(sendRequestMessage, 1000);
}

// センサの値をWebにアップする
client.on('data', function(data) {
    var message = data.toString();
	console.log(message);
	if(web_socket != null){
	    web_socket.write(message);
	}
});

client.on('end', function() {
	console.log('client disconnected');
});

