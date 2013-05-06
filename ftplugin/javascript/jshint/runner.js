var jshint = require('jshint').JSHINT
  , puts = require('util').puts
  , stdin = process.openStdin()
  , fs = require('fs')
  , jshintrc = process.argv[2] ? fs.readFileSync(process.argv[2]) : ''
  , body = [];

function allcomments(s) {
  return /^\s*\/\*(?:[^\*]+|\*(?!\/))\*\/\s*$|^\s*\/\/[^\n]\s*$/.test(s);
}

stdin.on('data', function(chunk) {
  body.push(chunk);
});

stdin.on('end', function() {
  var error
    , options;

  if (allcomments(jshintrc)) {
    body.push('\n' + jshintrc);
  } else {
    // Try standard `.jshintrc` JSON format. Use `eval` because `.jshintrc`
    // files might contain comments.
    try {
      options = eval('(' + jshintrc + '\n)');
    } catch(e) {
      puts('1:1:Invalid ~/.jshintrc file');
    }
  }

  if( jshint( body.join(''), options ) ){
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

