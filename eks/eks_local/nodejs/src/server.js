var http = require('http'); // Import Node.js core module

var server = http.createServer(function (req, res) {   //create web server
    if (req.url == '/time') { //check the URL of the current request
        //USE req TO GET IP ADDRESS
        let date_ob = new Date();
        // current date
        // adjust 0 before single digit date
        let date = ("0" + date_ob.getDate()).slice(-2);
        // current month
        let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
        // current year
        let year = date_ob.getFullYear();
        // current hours
        let hours = date_ob.getHours();
        // current minutes
        let minutes = date_ob.getMinutes();
        // current seconds
        let seconds = date_ob.getSeconds();
        var ip = req.socket.localAddress
        res.writeHead(200, { 'Content-Type': 'text/html' });
	//BUILD JSON W/ Time and IP Address USE STRUCTURE THEY PROPOSE
    res.write("{\"timestamp\":\""+ date + " " + hours + ":" + minutes + ":" + seconds+"\", \"ip\":"+ip+"\"}");
        res.end();

    }
    else
        res.end('Invalid Request!');

});

server.listen(5000); //CAN BE ANY PORT, INCLUDING 80

console.log('Node.js web server at port PORT is running..')