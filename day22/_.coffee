assert = require "assert"
Utils = require "../utils/Utils"
Data = require "./Data"

logging = false
earlyExit = true

#describe "simulate", ->
#  it "", ->
#    player = hp: 10, mana: 250, armor: 0
#    boss = hp: 14, dmg: 8
#    cost = findMinCost player, boss
##    cost = findMinCost Data.player, Data.boss
#    console.log "Cost: #{cost}"

findMinCost = (player, boss) ->
  state = {
    player
    boss
    cost: 0
    playerTurn: true
    effects: {}
  }
  min = Infinity
  hasEnded = (state, log) ->
    if earlyExit and state.cost > min
#      console.log "ABORT: #{state.cost}"
      log.push "ABORT: #{state.cost}" if logging
      return true
    if state.boss.hp <= 0
      log.push "WON! Cost: #{state.cost}" if logging
      if state.cost < min
        min = state.cost
        console.log "NEW BEST: #{state.cost}"
        log.push "NEW BEST!" if logging
        printLog log if logging
      return true
    if state.player.hp <= 0
      return true
    false
  recurse = (state, log) ->
    if hasEnded(state, log) then return
    if state.playerTurn
      for spell in Data.spells when validSpell(state, spell)
        newLog = if logging then log.concat [createLog {state: state, spell: spell}] else log
        newState = Utils.clone state
        applyEffects newState
        castSpell(spell, newState)
        if hasEnded(newState, newLog) then return
        newState.playerTurn = !newState.playerTurn
        recurse(newState, newLog)
      return
    else
      log.push createLog {state: state} if logging
      applyEffects state
      attack state.boss, state.player
      if hasEnded(state, log) then return
      state.playerTurn = !state.playerTurn
      recurse(state, log)
      return
  recurse(state, [])
  return min

createLog = (options) ->
  state = options.state
  activeEffects = ("#{k}:#{e.timer}" for k,e of options.state.effects)
  effectsLog = if Object.keys(activeEffects).length > 0 then "/(#{activeEffects.toString()})" else ""
  castLog = if options.spell then ", Casts: " + options.spell.name else ""
  "Boss: #{state.boss.hp}, Player: #{state.player.hp}/#{state.player.armor}/#{state.player.mana}#{effectsLog}#{castLog}"

printLog = (log) ->
  for s in log
    console.log s
  console.log()

applyEffects = (state) ->
  for key,e of state.effects
    if e.dmg
      state.boss.hp -= e.dmg
    if e.mana then state.player.mana += e.mana
    e.timer--
    if e.timer <= 0
      endEffect(key, state)
  return

startEffect = (key, state) ->
  effect = Data.effects[key]
  effect.timer = effect.turns
  state.effects[key] = effect
  if effect.armor
    state.player.armor += effect.armor

endEffect = (key, state) ->
  effect = state.effects[key]
  delete state.effects[key]
  if effect.armor then state.player.armor -= effect.armor

castSpell = (spell, state) ->
  if spell.cost?
    state.player.mana -= spell.cost
    state.cost += spell.cost
  if spell.dmg? then state.boss.hp -= spell.dmg
  if spell.heal? then state.player.hp += spell.heal
  if spell.effect?
    startEffect(spell.effect, state)

validSpell = (state, spell) ->
  return false if state.player.mana < spell.cost
  return false if spell.effect and spell.effect in state.effects
  true

attack = (attacker, defender) ->
  if attacker.dmg?
    armor = defender.armor ? 0
    damage = Math.max attacker.dmg - armor, 1
    defender.hp -= damage


player = hp: 10, mana: 250, armor: 0
boss = hp: 14, dmg: 8
#cost = findMinCost player, boss
cost = findMinCost Data.player, Data.boss
console.log "Cost: #{cost}"