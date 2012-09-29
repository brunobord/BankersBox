assert = require "assert"
{ BankersBox, BankersBoxException, BankersBoxKeyException } = require "bankersbox"

# I tried to write a test for no JSON object, but it blows up the
# testing framework, so I have to leave it out... boo
#exports.testNoJSON = ->
#  assert.throws (->
#    `JSON = undefined;`
#    bb = new BankersBox())

exports.testWrongKeyTypes = ->
  bb = new BankersBox()
  bb.flushdb()
  bb.set "foo", "bar"
  assert.throws (-> bb.sadd("foo", "qux")), BankersBoxKeyException
  # reset
  bb.del "foo"
  bb.lpush "foo", "bar"
  assert.throws (-> bb.get("foo")), BankersBoxKeyException
  # reset
  bb.del "foo"
  bb.lpush "foo", "bar"
  assert.throws (-> bb.smembers("foo")), BankersBoxKeyException

exports.testIncrNonInt = ->
  bb = new BankersBox()
  bb.flushdb()
  bb.set "foo", "bar"
  assert.throws (-> bb.incr("foo")), BankersBoxKeyException
  assert.throws (-> bb.incrby("foo", 5)), BankersBoxKeyException
  assert.throws (-> bb.decr("foo")), BankersBoxKeyException
  assert.throws (-> bb.decrby("foo", 5)), BankersBoxKeyException

exports.testLsetNoSuchKey = ->
  bb = new BankersBox()
  bb.flushdb()
  assert.throws (-> bb.lset("foo", 0, "bar")), BankersBoxKeyException

exports.testLsetIndexOutOfRange = ->
  bb = new BankersBox()
  bb.flushdb()
  bb.lpush "foo", "bar"
  bb.lpush "foo", "baz"
  assert.throws (-> bb.lset("foo", 2, "qux")), BankersBoxException

exports.testBBExceptionToString = ->
  bb = new BankersBox()
  bb.flushdb()
  try
    bb.lset "foo", 0, "bar"
    assert.equal true, false, "test exception toString - should not reach here"
  catch e
    assert.equal e.toString(), "BankersBoxKeyException: no such key", "test exception toString"