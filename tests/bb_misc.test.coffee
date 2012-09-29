assert = require "assert"
{ BankersBox } = require "bankersbox"

exports.testBBToString = ->
  assert.equal BankersBox.toString(), "[object BankersBox]", "test BankersBox toString"

exports.testFlushdb = ->
  bb = new BankersBox()
  bb.flushdb()
  bb.set "foo", "bar"
  bb.set "baz", "qux"
  assert.equal bb.flushdb(), "OK", "test flushdb"
  assert.eql bb.keys("*"), [], "test flushdb keys remaining"

exports.testKyesAll = ->
  bb = new BankersBox()
  bb.flushdb()
  bb.set "foo", "bar"
  bb.set "baz", "qux"
  assert.includes bb.keys(), "foo", "test keys * foo"
  assert.includes bb.keys(), "baz", "test keys * bar"
  assert.equal bb.keys().length, 2, "test keys * length"