module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      code:
        src: ['src/binary-trunk.coffee']
        dest: 'lib/<%= pkg.name %>.js'
        ext: '.js'
      tests:
        src: ['src/binary-trunk.test.coffee']
        dest: 'lib/<%= pkg.name %>.test.js'
        ext: '.js'

    bump: options:
      files: ['package.json', 'bower.json']
      updateConfigs: ['pkg'],
      commit: true,
      commitMessage: 'chore(deploy): release v%VERSION%',
      commitFiles: ['package.json','bower.json','CHANGELOG.md'], # '-a' for all files
      createTag: true,
      tagName: 'v%VERSION%',
      tagMessage: 'Version %VERSION%',
      push: true,
      pushTo: 'origin',
      gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d' # options to use with '$ git describe'

    changelog: {}

    'npm-contributors':
      options:
        commitMessage: 'chore(attribution): update contributors'

    watch:
      tests:
        files: ['<%= coffee.tests.src %>']
        tasks: ['coffee:tests']
      code:
        files: ['<%= coffee.code.src %>']
        tasks: ['coffee:code']
      karma:
        files: ['lib/*.js']
        tasks: ['karma:unit:run']

    karma:
      unit:
        configFile: 'karma.conf.js',
        background: true
      once:
        configFile: 'karma.conf.js'
        options: singleRun:true

    coveralls:
      options:
        coverageDir: '.coverage/',
        debug: !process.env.TRAVIS,
        dryRun: !process.env.TRAVIS,
        force: true,
        recursive: true

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-conventional-changelog'
  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-karma-coveralls'

  grunt.registerTask 'default', ['karma:unit', 'coffee']
  grunt.registerTask 'develop',    ['default','watch']

  grunt.registerTask 'release', 'Build, bump and tag a new release.', (type) ->
    grunt.task.run [
      'npm-contributors'
      "bump:#{type||'patch'}:bump-only"
      'changelog'
      'bump-commit'
    ]
