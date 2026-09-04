DFC = DFC or SMODS.current_mod

function DFC.rank_value(c)
  if not c or not c.get_id then return 0 end
  local id = c:get_id()
  if id == 14 then return 11 end
  if id >= 11 and id <= 13 then return 10 end
  if id >= 2 and id <= 10 then return id end
  return 0
end

function DFC.is_black(c)
  return c and (c:is_suit('Spades') or c:is_suit('Clubs'))
end

function DFC.contains(list, value)
  for _, v in ipairs(list or {}) do if v == value then return true end end
  return false
end

function DFC.status(card, message, colour)
  return { message = message or localize('k_upgrade_ex'), colour = colour or G.C.MULT, card = card }
end

function DFC.room(area)
  return area and #area.cards < area.config.card_limit
end

function DFC.add_consumable(set, seed)
  if not DFC.room(G.consumeables) then return nil end
  return SMODS.add_card { set = set, area = G.consumeables, key_append = seed or 'dfc' }
end

function DFC.add_steel_king()
  local suits = { 'Spades', 'Hearts', 'Clubs', 'Diamonds' }
  local c = SMODS.add_card {
    set = 'Base', area = G.hand, rank = 'King',
    suit = pseudorandom_element(suits, pseudoseed('dfc_gorn_suit')),
    enhancement = 'm_steel', seal = 'Red', key_append = 'dfc_gorn'
  }
  if c then playing_card_joker_effects({c}) end
  return c
end

function DFC.copy_to_area(source, area, enhancement)
  if not source or not area then return nil end
  local c = copy_card(source, nil, nil, G.playing_card)
  G.playing_card = (G.playing_card or 0) + 1
  c.playing_card = G.playing_card
  if enhancement then c:set_ability(enhancement, nil, true) end
  c:add_to_deck()
  table.insert(G.playing_cards, c)
  area:emplace(c)
  return c
end

function DFC.destroy_playing_card(c)
  if not c then return end
  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.1, func = function()
    c:start_dissolve(nil, nil, 1.6)
    return true
  end }))
end

function DFC.random_other_joker(card)
  local choices = {}
  for _, j in ipairs((G.jokers and G.jokers.cards) or {}) do
    if j ~= card then choices[#choices + 1] = j end
  end
  return #choices > 0 and pseudorandom_element(choices, pseudoseed('dfc_other_joker')) or nil
end

function DFC.current_shop_cards()
  local out = {}
  for _, area in ipairs({ G.shop_jokers, G.shop_booster, G.shop_vouchers }) do
    for _, c in ipairs((area and area.cards) or {}) do out[#out + 1] = c end
  end
  return out
end

function DFC.first_scoring_index(context, target)
  for i, c in ipairs(context.scoring_hand or {}) do if c == target then return i end end
  return nil
end

return DFC

