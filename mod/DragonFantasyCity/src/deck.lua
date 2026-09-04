DFC = DFC or SMODS.current_mod

SMODS.Back {
  key = 'equal_fortune',
  atlas = 'Decks',
  pos = { x = 0, y = 0 },
  unlocked = true,
  discovered = true,
  config = {
    consumables = { 'c_soul' }
  },
  loc_txt = {
    name = '众生平等牌组',
    text = {
      '开局获得一张{C:spectral}灵魂{}',
      '可随时使用以创建{C:legendary}传奇小丑{}',
      '小丑稀有度概率：普通 {C:attention}60%{}',
      '罕见 {C:attention}24%{}，稀有 {C:attention}13%{}',
      '传奇 {C:legendary}3%{}',
      '从第 {C:attention}3{} 个盲注起',
      '基础出牌与弃牌次数各 {C:red}-1{}'
    }
  },
  apply = function(self, back)
    G.GAME.modifiers.dfc_equal_rarities = true
    G.GAME.modifiers.dfc_blinds_started = 0
    G.GAME.modifiers.dfc_blind_penalty_applied = false
  end,
  calculate = function(self, back, context)
    if context.setting_blind then
      local modifiers = G.GAME.modifiers
      modifiers.dfc_blinds_started = (modifiers.dfc_blinds_started or 0) + 1
      if modifiers.dfc_blinds_started >= 3 and not modifiers.dfc_blind_penalty_applied then
        modifiers.dfc_blind_penalty_applied = true
        G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
        G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
        ease_hands_played(-1)
        ease_discard(-1)
      end
    end
  end
}

sendInfoMessage('Registered Equal Fortune deck', 'DragonFantasyCity')

