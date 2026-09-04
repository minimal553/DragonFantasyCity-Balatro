DFC = SMODS.current_mod

DFC.optional_features = {
  retrigger_joker = true,
  post_trigger = true
}

assert(SMODS.load_file('src/util.lua'))()
assert(SMODS.load_file('src/hooks.lua'))()

SMODS.Atlas {
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95
}

SMODS.Atlas {
  key = 'Decks',
  path = 'Decks.png',
  px = 71,
  py = 95
}

assert(SMODS.load_file('src/jokers.lua'))()
assert(SMODS.load_file('src/deck.lua'))()

