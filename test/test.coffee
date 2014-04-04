path      = require 'path'
fs        = require 'fs'
should    = require 'should'
Roots     = require 'roots'
_path     = path.join(__dirname, 'fixtures')
RootsUtil = require 'roots-util'
h         = new RootsUtil.Helpers(base: _path)

# utils

compile_fixture = (fixture_name, done) ->
  @public = path.join(fixture_name, 'public')
  h.project.compile(Roots, fixture_name, done)

before (done) ->
  h.project.install_dependencies('*', done)

after ->
  h.project.remove_folders('**/public')

# tests

describe 'basic', ->

  before (done) -> compile_fixture.call(@, 'basic', done)

  it 'should compile output', ->
    build = path.join(@public, 'build.min.js')

    h.file.exists(build).should.be.ok
    h.file.contains(build, "var doge = require('./doge');").should.be.ok
    h.file.contains(build, "module.exports = 'wow'").should.be.ok

describe 'minify', ->

  before (done) -> compile_fixture.call(@, 'minify', done)

  it 'should compile and minify output', ->
    build = path.join(@public, 'build.min.js')

    h.file.exists(build).should.be.ok
    h.file.contains(build, 'var doge=require("./doge");').should.be.ok
    h.file.contains(build, 'module.exports="wow"').should.be.ok

describe 'sourcemap', ->

  before (done) -> compile_fixture.call(@, 'sourcemap', done)

  it 'should compile and provide sourcemap', ->
    build = path.join(@public, 'build.min.js')
    map = path.join(@public, 'build.min.js.map')

    h.file.exists(build).should.be.ok
    h.file.exists(map).should.be.ok
    h.file.contains(build, "//# sourceMappingURL=build.min.js.map").should.be.ok
    h.file.contains(build, "var doge = require('./doge');").should.be.ok
    h.file.contains(build, "module.exports = 'wow'").should.be.ok

describe 'minify-sourcemap', ->

  before (done) -> compile_fixture.call(@, 'minify-sourcemap', done)

  it 'should compile, minify, and provide sourcemap', ->
    build = path.join(@public, 'build.min.js')
    map = path.join(@public, 'build.min.js.map')

    h.file.exists(build).should.be.ok
    h.file.contains(build, 'var doge=require("./doge");').should.be.ok
    h.file.contains(build, 'module.exports="wow"').should.be.ok
    h.file.contains(build, '//# sourceMappingURL=build.min.js.map').should.be.ok
    h.file.exists(map).should.be.ok
    h.file.has_content(map).should.be.ok

describe 'coffeescript', ->

  before (done) -> compile_fixture.call(@, 'coffeescript', done)

  it 'should compile coffeescript files', ->
    out = path.join(@public, 'build.js')

    h.file.contains(out, "doge = require('./doge');").should.be.ok
    h.file.contains(out, "module.exports = 'wow';").should.be.ok

describe 'coffeescript-minify', ->

  before (done) -> compile_fixture.call(@, 'coffee-minify', done)

  it 'should compile and minify output', ->
    build = path.join(@public, 'build.min.js')

    h.file.exists(build).should.be.ok
    h.file.contains(build, 'doge=require("./doge")').should.be.ok
    h.file.contains(build, 'module.exports="wow"').should.be.ok

describe 'coffeescript-sourcemap', ->

  before (done) -> compile_fixture.call(@, 'coffee-sourcemap', done)

  it 'should compile and provide sourcemap', ->
    build = path.join(@public, 'build.js')
    map = path.join(@public, 'build.js.map')

    h.file.exists(build).should.be.ok
    h.file.exists(map).should.be.ok
    h.file.contains(build, "//# sourceMappingURL=build.js.map").should.be.ok
    h.file.contains(build, "doge = require('./doge');").should.be.ok
    h.file.contains(build, "module.exports = 'wow'").should.be.ok

describe 'coffeescript-minify-sourcemap', ->

  before (done) -> compile_fixture.call(@, 'coffee-minify-sourcemap', done)

  it 'should compile, minify, and provide sourcemap', ->
    build = path.join(@public, 'build.min.js')
    map = path.join(@public, 'build.min.js.map')

    h.file.exists(build).should.be.ok
    h.file.contains(build, 'doge=require("./doge")').should.be.ok
    h.file.contains(build, 'module.exports="wow"').should.be.ok
    h.file.contains(build, '//# sourceMappingURL=build.min.js.map').should.be.ok
    h.file.exists(map).should.be.ok
    h.file.has_content(map).should.be.ok
