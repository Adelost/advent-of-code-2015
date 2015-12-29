exports.boss =
  hp: 100
  damage: 8
  armor: 2

exports.player =
  hp: 100
  damage: 0
  armor: 0

exports.store =
  weapons: [
    {name: "Dagger", cost: 8, damage: 4}
    {name: "Shortsword", cost: 10, damage: 5}
    {name: "Warhammer", cost: 25, damage: 6}
    {name: "Longsword", cost: 40, damage: 7}
    {name: "Greataxe", cost: 74, damage: 8}
  ],
  armor: [
    {name: "No armor", cost: 0, armor: 0}
    {name: "Leather", cost: 13, armor: 1}
    {name: "Chainmail", cost: 31, armor: 2}
    {name: "Splintmail", cost: 53, armor: 3}
    {name: "Bandedmail", cost: 75, armor: 4}
    {name: "Platemail", cost: 102, armor: 5}
  ],
  rings: [
    {name: "No ring", cost: 0, armor: 0, damage: 0}
    {name: "No ring", cost: 0, armor: 0, damage: 0}
    {name: "Damage +1", cost: 25, armor: 0, damage: 1}
    {name: "Damage +2", cost: 50, armor: 0, damage: 2}
    {name: "Damage +3", cost: 100, armor: 0, damage: 3}
    {name: "Defense +1", cost: 20, armor: 1, damage: 0}
    {name: "Defense +2", cost: 40, armor: 2, damage: 0}
    {name: "Defense +3", cost: 80, armor: 3, damage: 0}
  ]
