module.exports = function(config) {
   config.set({
      basePath: './',
      frameworks: ['qunit'],
      files: [
         "bower_components/underscore/underscore.js",
         "lib/binary-trunk.js",
         "lib/binary-trunk.test.js"
      ],
      reporters: ['dots'],
      port: 9876,
      colors: true,
      logLevel: config.LOG_INFO,
      browsers: process.env.TRAVIS ? ['Firefox'] : ['Chrome'],
      singleRun: false,
      reportSlowerThan: 500,
      plugins: [
         'karma-chrome-launcher',
         'karma-firefox-launcher',
         'karma-qunit'
      ]
   });
};