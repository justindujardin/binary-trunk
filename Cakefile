Docco         = require 'docco'
CoffeeScript  = require 'coffee-script'
{spawn, exec} = require 'child_process'
fs            = require 'fs'
path          = require 'path'
{parser, uglify} = require 'uglify-js'

# Extract the docco version from `package.json`
version = JSON.parse(fs.readFileSync("#{__dirname}/package.json")).version

option '-w', '--watch', 'continually build the binaryTrunk library and outputs'

outputs =
  'src/binaryTrunk.coffee': 'web/js/binaryTrunk.js'
  'src/binaryTrunk.test.coffee': 'web/js/binaryTrunk.test.js'

task 'build', 'build the binaryTrunk library', (options) ->
  for file,output of outputs
    build file, output
    watch file,['build','doc','test'] if options.watch

task 'doc', 'rebuild the binaryTrunk documentation', ->
  options = output: './'
  Docco.document [ 'src/binaryTrunk.coffee' ], options, ->
    fs.rename './binaryTrunk.html', './index.html', ->
      Docco.document [ 'src/binaryTrunk.test.coffee' ], options

task 'test', 'test the binaryTrunk library using phantomjs', ->
  child = exec 'phantomjs ./web/js/qunit/run-qunit.js ./tests.html', (error, stdout, stderr) ->
    console.log('stdout: ' + stdout)
    if (error != null)
      console.log('stderr: ' + stderr)
      console.log('exec error: ' + error)

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

#
# Write files with a header
#
writeJavascript = (filename, body) ->
  fs.writeFileSync filename, """
// binaryTrunk.coffee v#{version}
// Copyright (c) 2012 Justin DuJardin
// binaryTrunk is freely distributable under the MIT license.
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

