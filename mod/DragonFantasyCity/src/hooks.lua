DFC = DFC or SMODS.current_mod

if not DFC._hooks_installed then
  DFC._hooks_installed = true

  local ease_dollars_ref = ease_dollars
  function ease_dollars(mod, instant)
    if mod and mod < 0 and G and G.jokers and G.jokers.cards then
      for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center and j.config.center.key == 'j_DFC_smaug' then
          local e = j.ability.extra
          e.spent = (e.spent or 0) + math.abs(mod)
          local steps = math.floor(e.spent / 7)
          if steps > 0 then
            e.spent = e.spent - steps * 7
            e.xmult = (e.xmult or 1) + steps * 0.20
            card_eval_status_text(j, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
          end
        end
      end
    end
    return ease_dollars_ref(mod, instant)
  end

  local add_to_deck_ref = Card.add_to_deck
  function Card:add_to_deck(from_debuff)
    local ret = add_to_deck_ref(self, from_debuff)
    if self.playing_card and G and G.jokers and G.jokers.cards then
      for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center and j.config.center.key == 'j_DFC_clockwork_orange' then
          self.ability.dfc_new_card = true
          break
        end
      end
    end
    return ret
  end

  local poll_rarity_ref = SMODS.poll_rarity
  function SMODS.poll_rarity(pool_key, rand_key)
    if pool_key == 'Joker' and G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.dfc_equal_rarities then
      local roll = pseudorandom(pseudoseed(rand_key or ('dfc_weighted_rarity' .. G.GAME.round_resets.ante)))
      if roll < 0.60 then return 1 end
      if roll < 0.84 then return 2 end
      if roll < 0.97 then return 3 end
      return 4
    end
    return poll_rarity_ref(pool_key, rand_key)
  end
end

return DFC

