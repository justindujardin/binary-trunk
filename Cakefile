Docco         = require 'docco'
CoffeeScript  = require 'coffee-script'
{spawn, exec} = require 'child_process'
fs            = require 'fs'
path          = require 'path'
{parser, uglify} = require 'uglify-js'

# Extract the version from `package.json`
version = JSON.parse(fs.readFileSync("#{__dirname}/package.json")).version

option '-w', '--watch', 'continually build the library and outputs'

outputs =
  'src/binary-trunk.coffee': 'web/js/binary-trunk.js'
  'src/binary-trunk.test.coffee': 'web/js/binary-trunk.test.js'

task 'build', 'build the library', (options) ->
  for file,output of outputs
    build file, output
    watch file,['build','doc','test'] if options.watch

task 'doc', 'rebuild the documentation', ->
  options = output: './'
  Docco.document [ 'src/binary-trunk.coffee' ], options, ->
    fs.rename './binary-trunk.html', './index.html', ->
      Docco.document [ 'src/binary-trunk.test.coffee' ], options

task 'test', 'test the library using phantomjs', ->
  child = exec 'phantomjs ./web/js/qunit/run-qunit.js ./tests.html', (error, stdout, stderr) ->
    console.log('stdout: ' + stdout)
    if (error != null)
      console.log('stderr: ' + stderr)
      console.log('exec error: ' + error)
    process.exit if error != null then 1 else 0

watching = {}
watch = (file, changeTasks, notifyCallback) ->
  return if watching[file]
  watching[file] = true
  fs.watchFile file, (curr, prev) ->
    if +curr.mtime isnt +prev.mtime
      console.log "Saw change in #{file}"
      invoke change for change in changeTasks
    return
  notifyCallback() if notifyCallback

build = (source,output,notifyCallback) ->
  fileContents = null
  try
    fileContents = "#{fs.readFileSync source}"
    javascript = CoffeeScript.compile fileContents
    writeJavascript output, javascript
    unless process.env.MINIFY is 'false'
      writeJavascript output.replace(/\.js$/,'.min.js'), (
        uglify.gen_code uglify.ast_squeeze uglify.ast_mangle parser.parse javascript
      )
    notifyCallback() if typeof notifyCallback is 'function'
  catch e
    compileError e, output, fileContents

writeJavascript = (filename, body) ->
  fs.writeFileSync filename, """
// binary-trunk.coffee v#{version}
// Copyright (c) 2012 Justin DuJardin
// binary-trunk is freely distributable under the MIT license.
#{body}
"""
  console.log "Wrote #{filename}"

compileError = (error, file_name, file_contents) ->
  line = error.message.match /line ([0-9]+):/
  if line && line[1]
    line = parseInt(line[1])
    contents_lines = file_contents.split "\n"
    first = if line-4 < 0 then 0 else line-4
    last  = if line+3 > contents_lines.size then contents_lines.size else line+3
    console.log "Error compiling #{file_name}. \"#{error.message}\"\n"
    index = 0
    for line in contents_lines[first...last]
      index++
      line_number = first + 1 + index
      console.log "#{(' ' for [0..(3-(line_number.toString().length))]).join('')} #{line}"
  else
    console.log """
Error compiling #{file_name}:

  #{error.message}

"""

