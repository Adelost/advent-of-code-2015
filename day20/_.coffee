assert = require "assert"

describe "findHouseNumber", ->
  this.timeout 10000
  it "finds lowest house number to receive the number of presents", ->
    assert.equal findHouseNumber(130), 8
  input = 36000000
  it "solves puzzle 1", ->
    nr = findHouseNumber input
    console.log "House #{nr} got at least #{input} presents."
  it "solves puzzle 2", ->
    nr = findHouseNumber input,
      multiplier: 11
      visitLimit: 50
    console.log "House #{nr} got at least #{input} presents."

findHouseNumber = (count, options = {}) ->
  ###
  Finds the first occurring house to receive at least "count" presents
  --count: int - the number of presents to look for
  --options: object
    --multiplier: int - present multiplier [default: 10]
    --visitLimit: int - limits the number of houses an elf can visit
  ###
  options.multiplier = options.multiplier || 10;
  houses = (0 for [1..(count / options.multiplier)])
  for i in [1...houses.length]
    visited = 0
    for j in [i...houses.length] by i
      houses[j] += i * options.multiplier
      visited++
      break if options.visitLimit and visited >= options.visitLimit
  for h,i in houses
    if h >= count
      console.log "House #{i} got #{h} presents."
      return i
  throw new Error("No house found")