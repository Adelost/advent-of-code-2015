crypto = require "crypto"
assert = require "assert"

describe "findNumber", ->
  this.timeout 100000
  it "returns 609043 for abcdef", ->
    assert.equal findNumber("abcdef", "00000"), 609043
  it "returns 1048970 for pqrstuv", ->
    assert.equal findNumber("pqrstuv", "00000"), 1048970
  it "solves puzzles", ->
    input = "iwrupvqb"
    console.log "Puzzle 1: " + findNumber input, "00000"
    console.log "Puzzle 2: " + findNumber input, "000000"

findNumber = (key, prefix) ->
  number = 1
  loop
    value = key + number
    hash = crypto.createHash("md5").update(value).digest "hex"
    return number if hash.indexOf(prefix) is 0
    number++