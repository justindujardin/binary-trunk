module.exports = function(config) {

   var coverageDebug = false;

   config.set({
      basePath: './',
      frameworks: ['qunit'],
      files: [
         "bower_components/underscore/underscore.js",
         "lib/binary-trunk.js",
         "lib/binary-trunk.test.js"
      ],
      reporters: ['dots','coverage'],
      port: 9876,
      colors: true,
      logLevel: config.LOG_INFO,
      browsers: process.env.TRAVIS ? ['Firefox'] : ['Chrome'],
      singleRun: false,
      reportSlowerThan: 500,
      plugins: [
         'karma-chrome-launcher',
         'karma-firefox-launcher',
         'karma-qunit',
         'karma-coverage'
      ],
      preprocessors: (process.env.TRAVIS || coverageDebug) ? { "lib/binary-trunk.js": "coverage" } : {},
      coverageReporter: {
         type: "lcov",
         dir: ".coverage/"
      }

   });
};