matchdep = require 'matchdep'


module.exports = (grunt) ->
	grunt.initConfig release: {}
	matchdep.filterDev('grunt-*', './package.json').forEach (task)-> grunt.loadNpmTasks(task)
	