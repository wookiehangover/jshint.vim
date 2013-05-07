var jshint = require('jshint').JSHINT
  , puts = require('util').puts
  , stdin = process.openStdin()
  , fs = require('fs')
  , jshintrc = process.argv[2] ? fs.readFileSync(process.argv[2], 'utf8') : ''
  , body = [];

function allcomments(s) {
  return /^\s*\/\/[^\n]\s*$|^\s*\/\*(?:[^\*]+|\*(?!\/))\*\/\s*$/.test(s);
}

function removecomments(s) {
  return s.replace(/\/\/[^\n]|\/\*(?:[^\*]+|\*(?!\/))\*\//g, '');
}

stdin.on('data', function(chunk) {
  body.push(chunk);
});

stdin.on('end', function() {
  var error
    , options
    , prefix = ''
    , offset = 0;

  if (allcomments(jshintrc)) {
    prefix = jshintrc + '\n';
    offset = prefix.split('\n').length - 1;
  } else {
    // Try standard `.jshintrc` JSON format.
    try {
      options = JSON.parse(removecomments(jshintrc));
    } catch(e) {
      puts('1:1:Invalid ~/.jshintrc file');
    }
  }

  if( jshint( prefix + body.join(''), options ) ){
    return;
  }

  var data = jshint.data();

  for( var i = 0, len = data.errors.length; i < len; i += 1 ){
    error = data.errors[i];
    if( error && error.reason ){
      puts( [error.line - offset, error.character, error.reason].join(':') );
    }
  }

});

