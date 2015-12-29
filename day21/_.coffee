assert = require "assert"
Utils = require "../utils/Utils"
Data = require "./Data"

describe "simulate", ->
  it "logs cost spent to win and lose game", ->
    simulate Data.player, Data.boss, Data.store

describe "fightToDeath", ->
  it "reduces hp until one target dies ", ->
    player = hp: 8, damage: 5, armor: 5
    boss = hp: 12, damage: 7, armor: 2
    fightToDeath player, boss
    assert.equal player.hp, 2

simulate = (player, boss, store) ->
  combo = [0, 0, 0, 1]
  min = cost: Infinity, items: []
  max = cost: 0, items: []
  loop
    equipPlayer player, combo, store
    if playerWins player, boss
      if player.cost < min.cost
        min.cost = player.cost
        min.items = player.items
    else
      if player.cost > max.cost
        max.cost = player.cost
        max.items = player.items
    if not nextCombo combo, store
      break

  console.log """
    Minimum cost to win: #{min.cost}
    Items: #{JSON.stringify min.items}
    Maximum cost to lose: #{max.cost}
    Items: #{JSON.stringify max.items}
    """

equipPlayer = (player, combo, store) ->
  items = []
  items.push store.weapons[combo[0]]
  items.push store.armor[combo[1]]
  items.push store.rings[combo[2]]
  items.push store.rings[combo[3]]

  player.armor = 0
  player.damage = 0
  player.cost = 0
  player.items = items

  for item in items
    player.armor += item.armor if item.armor
    player.damage += item.damage if item.damage
    player.cost += item.cost if item.cost

playerWins = (player, boss) ->
  playerClone = Utils.clone player
  bossClone = Utils.clone boss
  fightToDeath playerClone, bossClone
  playerClone.hp > 0

fightToDeath = (attacker, defender) ->
  while attacker.hp > 0 and defender.hp > 0
    attack attacker, defender
    [defender, attacker] = [attacker, defender]

attack = (attacker, defender) ->
  damage = Math.max attacker.damage - defender.armor, 1
  defender.hp -= damage

# Switches to next valid combo, returns false
# if all combos has been tested
nextCombo = (combo, store) ->
  lengths = [
    store.weapons.length
    store.armor.length
    store.rings.length
    store.rings.length
  ]
  combo[0]++
  for c, i in combo
    if combo[i] >= lengths[i]
      combo[i] = 0
      nextIndex = i + 1
      if nextIndex < combo.length
        combo[nextIndex]++
      else
        return false
  if invalidCombo combo
    return nextCombo combo, store
  true

invalidCombo = (combo) ->
  combo[2] == combo[3]