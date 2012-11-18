var jshint = require('jshint').JSHINT
  , puts = require('util').puts
  , stdin = process.openStdin()
  , body = []
  , path= require('path')
  , fs= require('fs')
  , options = fs.readFileSync(path.join(__dirname,'.jshintrc')).toString('utf8');


try{
	options = JSON.parse(options);
}catch(e){
	console.log('could not parse options')
}

stdin.on('data', function(chunk) {
  body.push(chunk);
});

stdin.on('end', function() {
  var error
    , ok = jshint( body.join('\n'), options );

  if( ok ){
    return;
  }

  var data = jshint.data();

  for( var i = 0, len = data.errors.length; i < len; i += 1 ){
    error = data.errors[i];
    if( error && error.reason ){
      puts( [error.line, error.character, error.reason].join(':') );
    }
  }

});

