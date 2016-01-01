exports.spells = [
  {name: "Magic Missile", cost: 53, dmg: 4}
  {name: "Drain", cost: 73, dmg: 2, heal: 2}
  {name: "Shield", cost: 113, effect: "shield"}
  {name: "Poison", cost: 173, effect: "poison"}
  {name: "Recharge", cost: 229, effect: "recharge"}
]
exports.effects =
  shield: turns: 6, armor: 7
  poison: turns: 6, dmg: 3
  recharge: turns: 5, mana: 101