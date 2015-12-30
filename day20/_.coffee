assert = require "assert"

describe "findHouseNumber", ->
  it "finds lowest house number to receive the number of presents", ->
    assert.equal findHouseNumber(130), 8
  input = 36000000
  it "solves puzzle 1", ->
    console.log "House #{findHouseNumber input} got at least #{input} presents."
  it "solves puzzle 2", ->
    console.log "House #{findHouseNumberPartTwo input} got at least #{input} presents."

findHouseNumber = (count) ->
  houses = (0 for [1..count / 10])
  for i in [1...houses.length]
    for j in [i...houses.length] by i
      houses[j] += i * 10
  for h,i in houses
    if h >= count
      console.log "House #{i} got #{h} presents."
      return i
  -1

findHouseNumberPartTwo = (count) ->
  houses = (0 for [1..count / 11])
  for i in [1...houses.length]
    deliveries = 0
    for j in [i...houses.length] by i
      houses[j] += i * 11
      deliveries++
      if deliveries >= 50
        break
  for h,i in houses
    if h >= count
      console.log "House #{i} got #{h} presents."
      return i
  -1