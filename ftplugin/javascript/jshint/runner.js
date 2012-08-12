var jshint = require('jshint').JSHINT
  , fs = require('fs')
  , path = require('path')
  , puts = require('util').puts
  , stdin = process.openStdin()
  , body = [];

function existsSync() {
    var obj = fs.existsSync ? fs : path;
    return obj.existsSync.apply(obj, arguments);
}

function _removeJsComments(str) {
    str = str || '';

    // replace everything between "/* */" in a non-greedy way
    // The English version of the regex is:
    //   match '/*'
    //   then match 0 or more instances of any character (including newlines)
    //     except for instances of '*/'
    //   then match '*/'
    str = str.replace(/\/\*(?:(?!\*\/)[\s\S])*\*\//g, '');

    str = str.replace(/\/\/[^\n\r]*/g, ''); //everything after "//"
    return str;
}

function _loadAndParseConfig(filePath) {
    return filePath && existsSync(filePath) ?
            JSON.parse(_removeJsComments(fs.readFileSync(filePath, "utf-8"))) : {};
}

/**
 * This function searches for a file with a specified name, it starts
 * with the dir passed, and traverses up the filesystem until it either
 * finds the file, or hits the root
 *
 * @param {String} name  Filename to search for (.jshintrc, .jshintignore)
 * @param {String} dir   Defaults to process.cwd()
 */
function _searchFile(name, dir) {
    dir = dir || process.cwd();

    var filename = path.normalize(path.join(dir, name)),
        parent = path.resolve(dir, "..");

    if (existsSync(filename)) {
        return filename;
    }

    return dir === parent ? null : _searchFile(name, parent);
}

function _findConfig(target) {
    var name = ".jshintrc",
        projectConfig = _searchFile(name),
        homeConfig = path.normalize(path.join(process.env.HOME, name));

    if (projectConfig) {
        return projectConfig;
    }

    // if no project config, check $HOME
    if (existsSync(homeConfig)) {
        return homeConfig;
    }

    return false;
}

stdin.on('data', function(chunk) {
  body.push(chunk);
});

stdin.on('end', function() {
  var error
    , config = _loadAndParseConfig(_findConfig())
    , ok = jshint( body.join('\n'), config );

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

