assert = require "assert"
Utils = require "../utils/Utils"
Data = require "./Data"

logging = true
earlyExit = true

describe "findMinCost", ->
  describe "examples", ->
    player = hp: 10 , mana: 250, armor: 0
    boss = hp: 13, dmg: 8, armor: 0
    it "solves example 1", ->
      assert.equal findMinCost(player, boss), 226
    it "solves example 2", ->
      boss.hp = 14
      assert.equal findMinCost(player, boss), 641
  describe "puzzle", ->
    this.timeout(0)
    player = hp: 50, mana: 500, armor: 0
    boss = hp: 71, dmg: 10, armor: 0
    it "solves part 1", ->
      assert.equal findMinCost(player, boss), 1824
    it "solves part 2", ->
      assert.equal findMinCost(player, boss, {partTwo: true}), 1937

findMinCost = (player, boss, options = {}) ->
  options.partTwo ? false
  state = {
    player
    boss
    cost: 0
    playerTurn: true
    effects: {}
    log: ''
  }
  min = Infinity
  minLog = ""
  turns = 0
  startTime = new Date().getTime()
  printTime = -> (new Date().getTime() - startTime) / 1000
  hasEnded = (state) ->
    if earlyExit and state.cost > min
      return true
    if state.player.hp <= 0
      return true
    if state.boss.hp <= 0
      if state.cost < min
        min = state.cost
        minLog = state.log
        console.log state.log + "NEW BEST! Cost: #{state.cost}, #{turns} turns, #{printTime()}s\n"
      return true
    false
  recurse = (state) ->
    turns++
    if options.partTwo and state.playerTurn
      state.player.hp--
      return if hasEnded(state)
    applyEffects state
    return if hasEnded(state)
    if state.playerTurn
      for spell in Data.spells when validSpell(state, spell)
        newState = Utils.clone state
        castSpell(spell, newState)
        newState.log += createLog {state, spell}
        continue if hasEnded(newState)
        endTurn newState
        recurse(newState)
      return
    attack state.boss, state.player
    state.log += createLog {state}
    return if hasEnded(state)
    endTurn state
    recurse(state)
  recurse(Utils.clone(state), [])
  console.log "Cost: #{min}, Turns: #{turns}, Time: #{printTime()}s\n"
  return min

endTurn = (state) ->
  state.playerTurn = !state.playerTurn

createLog = (options) ->
  return "" if not logging
  state = options.state
  effects = ("#{k}:#{e}" for k,e of options.state.effects)
  effectsEntry = if Object.keys(effects).length > 0 then " (#{effects.toString()})" else ""
  castEntry = if options.spell then " -> " + options.spell.name else ""
  "Boss: #{state.boss.hp} | Player: #{state.player.hp}/#{state.player.armor}/#{state.player.mana}#{effectsEntry}#{castEntry}\n"

applyEffects = (state) ->
  for key of state.effects
    e = Data.effects[key]
    timer = --state.effects[key]
    if timer <= 0 then endEffect(key, state)
    if e.dmg? then state.boss.hp -= e.dmg
    if e.mana? then state.player.mana += e.mana
  return

startEffect = (key, state) ->
  effect = Data.effects[key]
  state.effects[key] = effect.turns
  if effect.armor? then state.player.armor += effect.armor

endEffect = (key, state) ->
  delete state.effects[key]
  effect = Data.effects[key]
  if effect.armor? then state.player.armor -= effect.armor

castSpell = (spell, state) ->
  if spell.cost?
    state.player.mana -= spell.cost
    state.cost += spell.cost
  if spell.effect? then startEffect(spell.effect, state)
  if spell.dmg? then state.boss.hp -= spell.dmg
  if spell.heal? then state.player.hp += spell.heal

validSpell = (state, spell) ->
  if state.player.mana < spell.cost
    return false
  if spell.effect and spell.effect of state.effects
    return false
  return true

attack = (attacker, defender) ->
  if attacker.dmg?
    armor = defender.armor ? 0
    damage = Math.max attacker.dmg - armor, 1
    defender.hp -= damage