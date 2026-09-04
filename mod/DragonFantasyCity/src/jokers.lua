DFC = DFC or SMODS.current_mod

local specs = {
  { 'smaug', '红龙史矛革', { '每累计主动花费 {C:money}$7{}', '永久获得 {X:mult,C:white}X0.20{} 倍率', '{C:inactive}(当前 X#1#，进度 $#2#/7)' }, 4, 20, { xmult = 1, spent = 0 } },
  { 'asabith', '黑毒龙阿萨比斯', { '每累计摧毁 {C:attention}3{} 张扑克牌', '所有打出的牌永久额外触发 {C:attention}1{} 次', '{C:inactive}(当前 #1# 次，进度 #2#/3)' }, 4, 20, { destroyed = 0, repetitions = 0 } },
  { 'gorn', '骷髅龙骨恩', { '每次出牌结算后', '向牌组加入一张随机花色的', '{C:attention}红蜡封钢铁 K{}' }, 4, 20, {} },
  { 'chinese_dragon', '中华龙', { '其他所有{C:rare}非普通小丑{}触发时', '永久获得 {C:mult}+1{} 倍率', '{C:inactive}(当前 +#1#)' }, 4, 20, { mult = 0 } },
  { 'captain_cook', '海盗船长库克', { '每盲注首次打出一种新牌型获得 {C:money}$3{}', '重复牌型后本盲注停止探索' }, 3, 9, { seen = {}, active = true } },
  { 'shadow_warrior', '暗影武士', { '打出但未计分的黑色牌', '点数永久转化为筹码', '{C:inactive}(当前 +#1#)' }, 3, 9, { chips = 0 } },
  { 'phantom_ninja', '幻忍者', { '每盲注结束有 {C:green}1/3{} 几率', '将一张其他小丑变为{C:dark_edition}负片{}' }, 3, 9, {} },
  { 'mad_treant', '疯狂树魔', { '所有其他起作用的小丑', '额外触发 {C:attention}1{} 次', '{C:inactive}(不触发自身或同名牌)' }, 3, 10, {} },
  { 't800', 'T-800', { '每盲注第一次弃牌的第一张牌', '被摧毁并以{C:attention}钢铁牌{}回到手中' }, 3, 9, { used = false } },
  { 'wukong', '孙悟空', { '每次出牌有 {C:green}1/3{} 几率', '将所有计分牌变为随机功能牌' }, 3, 9, {} },
  { 'bull_demon', '牛魔王', { '每次出牌有 {C:green}1/3{} 几率摧毁计分牌', '并将其点数永久加入倍率', '{C:inactive}(当前 +#1#)' }, 3, 10, { mult = 0, active = false } },
  { 'great_white_shark', '大白鲨', { '每次出牌有 {C:green}1/4{} 几率摧毁打出的牌', '并生成 {C:planet}2{} 张星球牌' }, 3, 9, { active = false } },
  { 'cannon_mark', '巨炮马克', { '每摧毁一张{C:attention}石头牌{}', '永久获得 {X:mult,C:white}X0.5{} 倍率', '{C:inactive}(当前 X#1#)' }, 3, 9, { xmult = 1 } },
  { 'spider_witch', '蜘蛛女巫', { '每次出牌首次发生牌的重复触发时', '生成一张{C:tarot}塔罗牌{}', '{C:inactive}(需有空位)' }, 3, 9, { made = false } },
  { 'striped_python', '斑纹巨蟒', { '{C:attention}顺子{}中的所有计分牌', '额外触发 {C:attention}2{} 次' }, 3, 10, {} },
  { 'great_wall', '长城', { '每次恰好打出 {C:attention}5{} 张牌时', '永久获得 {C:chips}+8{} 筹码', '{C:inactive}(当前 +#1#)' }, 3, 8, { chips = 0 } },
  { 'tokamak', '托卡马克', { '盲注要求分数 {X:attention,C:white}X2{}', '进入盲注时资金翻倍', '{C:inactive}(最多 $40)' }, 3, 10, {} },
  { 'silver_walker', '银翼杀手', { '每家商店第一次付费重掷后', '使一个随机补充包变为{C:money}免费{}', '{C:inactive}(通过正常点击打开)' }, 3, 9, { used = false } },
  { 'genghis', '成吉思汗', { '从左到右，每张点数', '高于前一张的计分牌 {C:mult}+7{} 倍率' }, 2, 6, {} },
  { 'melatonin', '褪黑素', { '每手新增 {C:attention}2{} 张背面朝上的牌', '若两张均未打出，获得 {X:mult,C:white}X1.40{}' }, 2, 6, { generated = {} } },
  { 'dwarf_miner', '矮人矿工', { '只弃一张{C:attention}石头牌{}时', '摧毁它并获得 {C:money}$4{}' }, 2, 6, {} },
  { 'oak_shield', '橡树盾', { '每次弃牌后，从弃牌堆', '随机抽回最多 {C:attention}2{} 张牌' }, 2, 6, {} },
  { 'first_blood', '第一滴血', { '每盲注第一次出牌摧毁首张计分牌', '其点数作为本盲注额外倍率', '{C:inactive}(当前 +#1#)' }, 2, 6, { mult = 0, target = nil } },
  { 'white_elephant', '印度白象', { '商店商品价格减半', '但重掷费用翻倍' }, 2, 6, {} },
  { 'wild_pear', '野梨树', { '每次打出{C:attention}同花顺{}', '获得 {C:chips}+50{} 筹码' }, 2, 6, {} },
  { 'suspect_x', '嫌疑人 X', { '每盲注随机翻面两张牌', '其中一张点数的两倍作为倍率' }, 2, 6, { chosen = nil } },
  { 'swamp_crocodile', '沼泽鳄鱼', { '盲注结束时摧毁手中点数最低的牌', '并获得等于其点数的金币' }, 2, 6, {} },
  { 'drifting_iceberg', '漂流冰山', { '未计分牌的基础筹码存入冰山', '最后一手获得储存筹码并补充一次出牌', '{C:inactive}(储存 #1#)' }, 2, 6, { chips = 0, restored = false } },
  { 'ugly_giant', '丑巨人刚比', { '打出5张牌且仅1或2张计分时', '获得 {C:mult}+30{} 倍率' }, 2, 6, {} },
  { 'onion_knight', '洋葱骑士', { '每剩余一次弃牌', '获得 {X:mult,C:white}X0.25{} 倍率' }, 2, 6, {} },
  { 'zombie_shaun', '僵尸肖恩', { '本盲注弃牌中最高点数的两倍', '作为额外倍率', '{C:inactive}(当前 +#1#)' }, 2, 6, { max = 0 } },
  { 'rapper_hawk', '说唱歌手霍克', { '第2与第5张计分牌', '各额外触发 {C:attention}1{} 次' }, 2, 6, {} },
  { 'fund_manager', '基金经理伊森', { '选择盲注时支付 {C:money}$5{}', '一手获胜返还 $12，两手获胜返还 $5' }, 2, 6, {} },
  { 'preacher', '传教士', { '所有 {C:attention}6{} 和 {C:attention}9{}', '计分时获得 {X:mult,C:white}X2{}' }, 2, 6, {} },
  { 'road_roller', '压路机', { '最后一手若最高与最低点数牌均打出', '结算后生成一张{C:spectral}幻灵牌{}' }, 2, 6, { active = false } },
  { 'gangster_goon', '黑帮打手', { '红心与方片计分时 {C:mult}+4{} 倍率', '梅花与黑桃计分时 {C:chips}+30{} 筹码' }, 2, 6, {} },
  { 'crab_catcher', '捕蟹人', { '每盲注第一次出牌后', '复制其中点数最大的人头牌回到手中' }, 2, 6, { target = nil } },
  { 'javelin', '标枪手', { '首尾计分牌点数每相差1', '获得 {C:chips}+10{} 筹码', '{C:inactive}(J/Q/K=10，A=11)' }, 2, 6, {} },
  { 'camellia_lady', '茶花女', { '盲注结束时摧毁手中最左侧牌', '并复制最右侧牌' }, 2, 6, {} },
  { 'strong_sailor', '大力水手', { '每使用一张消耗牌，下一手', '每张计分牌获得 {C:chips}+2{} 筹码', '{C:inactive}(当前每张 +#1#)' }, 2, 6, { chips = 0 } },
  { 'serotonin', '血清素', { '进入盲注时等概率获得', '{C:money}$10{}、一张幻灵牌或一张塔罗牌' }, 2, 6, {} },
  { 'werther', '烦恼维特', { '初始 {X:mult,C:white}X3{} 倍率', '每打出一张牌失去 {X:mult,C:white}X0.05{}', '{C:inactive}(当前 X#1#)' }, 2, 6, { xmult = 3 } },
  { 'hacker', '黑客', { '每家商店第一次付费重掷后', '随机一件商品价格变为 {C:money}$0{}' }, 2, 6, { used = false } },
  { 'rubber_head', '橡皮头', { '获得手中所有未打出牌', '基础筹码总和的 {C:chips}2倍{}' }, 2, 6, {} },
  { 'clockwork_orange', '发条橙', { '新加入牌组的牌计分时', '获得 {X:mult,C:white}X1.5{} 并额外触发一次' }, 2, 6, {} },
  { 'django', '姜戈', { '每盲注第一次恰好打出2张牌时', '计分后随机摧毁1张，点数转为', '幸存牌的永久额外筹码' }, 2, 6, { target = nil, survivor = nil } },
}

local function e(card) return card.ability.extra or {} end
local H = {}

function H.smaug(card, context) if context.joker_main then return { x_mult = e(card).xmult } end end
function H.asabith(card, context)
  if context.remove_playing_cards and not context.blueprint then
    e(card).destroyed = e(card).destroyed + #(context.removed or {})
    local n = math.floor(e(card).destroyed / 3)
    if n > 0 then e(card).destroyed = e(card).destroyed - n * 3; e(card).repetitions = e(card).repetitions + n; return DFC.status(card) end
  end
  if context.repetition and context.cardarea == G.play and e(card).repetitions > 0 then return { repetitions = e(card).repetitions } end
end
function H.gorn(card, context)
  if context.after and context.main_eval and not context.blueprint then G.E_MANAGER:add_event(Event({func=function() DFC.add_steel_king(); return true end})); return DFC.status(card, '+钢铁 K', G.C.SECONDARY_SET.Enhanced) end
end
function H.chinese_dragon(card, context)
  if context.post_trigger and not context.blueprint and context.other_card and context.other_card ~= card then
    local r = context.other_card.config and context.other_card.config.center and context.other_card.config.center.rarity
    if r and r > 1 and context.other_ret and next(context.other_ret) then e(card).mult = e(card).mult + 1; return DFC.status(card) end
  end
  if context.joker_main and e(card).mult > 0 then return { mult = e(card).mult } end
end
function H.captain_cook(card, context)
  if context.setting_blind and not context.blueprint then e(card).seen = {}; e(card).active = true end
  if context.before and context.main_eval and not context.blueprint and e(card).active then
    local hand = context.scoring_name or 'High Card'
    if e(card).seen[hand] then e(card).active = false; return DFC.status(card, '停止探索', G.C.RED) end
    e(card).seen[hand] = true; ease_dollars(3); return DFC.status(card, '$3', G.C.MONEY)
  end
end
function H.shadow_warrior(card, context)
  if context.before and context.main_eval and not context.blueprint then
    for _, c in ipairs(context.full_hand or {}) do if not DFC.contains(context.scoring_hand, c) and DFC.is_black(c) then e(card).chips = e(card).chips + DFC.rank_value(c) end end
  end
  if context.joker_main and e(card).chips > 0 then return { chips = e(card).chips } end
end
function H.phantom_ninja(card, context)
  if context.end_of_round and context.main_eval and not context.blueprint and pseudorandom('dfc_phantom') < 1/3 then
    local j = DFC.random_other_joker(card); if j then j:set_edition({negative=true}, true); return DFC.status(card, '负片！', G.C.DARK_EDITION) end
  end
end
function H.mad_treant(card, context)
  if context.retrigger_joker_check and context.other_card and context.other_card ~= card and context.other_card.config.center.key ~= card.config.center.key then return { repetitions = 1 } end
end
function H.t800(card, context)
  if context.setting_blind and not context.blueprint then e(card).used = false end
  if context.discard and not context.blueprint and not e(card).used and context.full_hand and context.other_card == context.full_hand[1] then
    e(card).used = true; DFC.copy_to_area(context.other_card, G.hand, 'm_steel'); return { remove = true, message = '钢铁回归', colour = G.C.SECONDARY_SET.Enhanced }
  end
end
function H.wukong(card, context)
  if context.before and context.main_eval and not context.blueprint and pseudorandom('dfc_wukong') < 1/3 then
    local pool = {'m_bonus','m_mult','m_wild','m_glass','m_steel','m_stone','m_gold','m_lucky'}
    for _, c in ipairs(context.scoring_hand or {}) do c:set_ability(pseudorandom_element(pool, pseudoseed('dfc_wukong_enh')), nil, true) end
    return DFC.status(card, '变化！', G.C.SECONDARY_SET.Enhanced)
  end
end
function H.bull_demon(card, context)
  if context.before and context.main_eval and not context.blueprint then e(card).active = pseudorandom('dfc_bull') < 1/3 end
  if context.destroying_card and context.cardarea == G.play and e(card).active then e(card).mult = e(card).mult + DFC.rank_value(context.destroying_card); return { remove = true } end
  if context.joker_main and e(card).mult > 0 then return { mult = e(card).mult } end
end
function H.great_white_shark(card, context)
  if context.before and context.main_eval and not context.blueprint then e(card).active = pseudorandom('dfc_shark') < 1/4 end
  if context.destroying_card and context.cardarea == G.play and e(card).active then return { remove = true } end
  if context.after and context.main_eval and not context.blueprint and e(card).active then e(card).active=false; DFC.add_consumable('Planet','dfc_shark1'); DFC.add_consumable('Planet','dfc_shark2'); return DFC.status(card, '+2 星球', G.C.PLANET) end
end
function H.cannon_mark(card, context)
  if context.remove_playing_cards and not context.blueprint then for _, c in ipairs(context.removed or {}) do if SMODS.has_enhancement(c,'m_stone') then e(card).xmult=e(card).xmult+0.5 end end end
  if context.joker_main then return { x_mult = e(card).xmult } end
end
function H.spider_witch(card, context)
  if context.before and not context.blueprint then e(card).made=false end
  if context.repetition and context.cardarea == G.play and not context.blueprint and not e(card).made then e(card).made=true; DFC.add_consumable('Tarot','dfc_spider'); return DFC.status(card, '+塔罗', G.C.TAROT) end
end
function H.striped_python(card, context) if context.repetition and context.cardarea == G.play and context.poker_hands and next(context.poker_hands['Straight'] or {}) then return { repetitions=2 } end end
function H.great_wall(card, context)
  if context.before and context.main_eval and not context.blueprint and #(context.full_hand or {})==5 then
    e(card).chips=e(card).chips+8
    return DFC.status(card,'+8',G.C.CHIPS)
  end
  if context.joker_main and e(card).chips>0 then return {chips=e(card).chips} end
end
function H.tokamak(card, context)
  if context.setting_blind and not context.blueprint then
    if G.GAME.blind and G.GAME.blind.chips then G.GAME.blind.chips=G.GAME.blind.chips*2; G.GAME.blind.chip_text=number_format(G.GAME.blind.chips) end
    local target=math.min((G.GAME.dollars or 0)*2,40); if target>G.GAME.dollars then ease_dollars(target-G.GAME.dollars) end
    return DFC.status(card,'双倍',G.C.MONEY)
  end
end
function H.silver_walker(card, context)
  if context.starting_shop then e(card).used=false end
  if context.reroll_shop and not context.blueprint and not e(card).used then
    e(card).used=true
    G.E_MANAGER:add_event(Event({trigger='after',delay=0.2,func=function()
      local boosters=(G.shop_booster and G.shop_booster.cards) or {}
      local b=#boosters>0 and pseudorandom_element(boosters,pseudoseed('dfc_silver_pack')) or nil
      if not b and DFC.room(G.shop_booster) then b=SMODS.add_card{set='Booster',area=G.shop_booster,key_append='dfc_silver'} end
      if b then b.ability.couponed=true; b:set_cost(); b:juice_up(0.3,0.3) end
      return true
    end}))
    return DFC.status(card,'免费补充包',G.C.SECONDARY_SET.Booster)
  end
end
function H.genghis(card, context)
  if context.joker_main then local m=0; for i=2,#(context.scoring_hand or {}) do if DFC.rank_value(context.scoring_hand[i])>DFC.rank_value(context.scoring_hand[i-1]) then m=m+7 end end; if m>0 then return {mult=m} end end
end
function H.melatonin(card, context)
  if context.hand_drawn and not context.blueprint then e(card).generated={}; for i=1,2 do local c=SMODS.add_card{set='Base',area=G.hand,key_append='dfc_melatonin'}; if c then c:flip(); e(card).generated[#e(card).generated+1]=c end end end
  if context.joker_main and #e(card).generated==2 and not DFC.contains(context.full_hand,e(card).generated[1]) and not DFC.contains(context.full_hand,e(card).generated[2]) then return {x_mult=1.4} end
end
function H.dwarf_miner(card, context)
  if context.discard and not context.blueprint and context.full_hand and #context.full_hand==1 and SMODS.has_enhancement(context.other_card,'m_stone') then ease_dollars(4); return {remove=true,message='$4',colour=G.C.MONEY} end
end
function H.oak_shield(card, context)
  if context.pre_discard and not context.blueprint then G.E_MANAGER:add_event(Event({trigger='after',delay=0.2,func=function() for i=1,math.min(2,#(G.discard and G.discard.cards or {})) do draw_card(G.discard,G.hand,90,'up') end return true end})) end
end
function H.first_blood(card, context)
  if context.setting_blind then e(card).mult=0; e(card).target=nil end
  if context.before and context.main_eval and G.GAME.current_round.hands_played==0 and not context.blueprint then e(card).target=context.scoring_hand and context.scoring_hand[1]; e(card).mult=DFC.rank_value(e(card).target) end
  if context.destroying_card and context.destroying_card==e(card).target then return {remove=true} end
  if context.joker_main and e(card).mult>0 then return {mult=e(card).mult} end
end
function H.white_elephant(card, context)
  if context.starting_shop and G.GAME.current_round.reroll_cost then G.GAME.current_round.reroll_cost=G.GAME.current_round.reroll_cost*2 end
end
function H.wild_pear(card, context) if context.joker_main and context.poker_hands and next(context.poker_hands['Straight Flush'] or {}) then return {chips=50} end end
function H.suspect_x(card, context)
  if context.first_hand_drawn and not context.blueprint and G.hand and #G.hand.cards>=2 then local pool={}; for _,c in ipairs(G.hand.cards) do pool[#pool+1]=c end; local a=pseudorandom_element(pool,pseudoseed('dfc_x1')); local b=pseudorandom_element(pool,pseudoseed('dfc_x2')); a:flip(); if b~=a then b:flip() end; e(card).chosen=(pseudorandom('dfc_xpick')<0.5 and a or b) end
  if context.joker_main and e(card).chosen then return {mult=DFC.rank_value(e(card).chosen)*2} end
end
function H.swamp_crocodile(card, context)
  if context.end_of_round and context.main_eval and not context.blueprint and G.hand and #G.hand.cards>0 then local low=G.hand.cards[1]; for _,c in ipairs(G.hand.cards) do if DFC.rank_value(c)<DFC.rank_value(low) then low=c end end; local v=DFC.rank_value(low); DFC.destroy_playing_card(low); ease_dollars(v); return DFC.status(card,'$'..v,G.C.MONEY) end
end
function H.drifting_iceberg(card, context)
  if context.setting_blind then e(card).chips=0; e(card).restored=false end
  if context.before and context.main_eval and not context.blueprint then for _,c in ipairs(context.full_hand or {}) do if not DFC.contains(context.scoring_hand,c) then e(card).chips=e(card).chips+(c.base and c.base.nominal or 0) end end end
  if context.joker_main and G.GAME.current_round.hands_left==0 and e(card).chips>0 then return {chips=e(card).chips} end
  if context.after and context.main_eval and not context.blueprint and G.GAME.current_round.hands_left==0 and not e(card).restored then e(card).restored=true; ease_hands_played(1); return DFC.status(card,'+1 出牌',G.C.CHIPS) end
end
function H.ugly_giant(card, context) if context.joker_main and #(context.full_hand or {})==5 and (#(context.scoring_hand or {})==1 or #(context.scoring_hand or {})==2) then return {mult=30} end end
function H.onion_knight(card, context) if context.joker_main then return {x_mult=1+math.max(0,G.GAME.current_round.discards_left or 0)*0.25} end end
function H.zombie_shaun(card, context)
  if context.setting_blind then e(card).max=0 end
  if context.discard and not context.blueprint then e(card).max=math.max(e(card).max,DFC.rank_value(context.other_card)) end
  if context.joker_main and e(card).max>0 then return {mult=e(card).max*2} end
end
function H.rapper_hawk(card, context) if context.repetition and context.cardarea==G.play then local i=DFC.first_scoring_index(context,context.other_card); if i==2 or i==5 then return {repetitions=1} end end end
function H.fund_manager(card, context)
  if context.setting_blind and not context.blueprint then ease_dollars(-5) end
  if context.end_of_round and context.main_eval and not context.blueprint then local n=G.GAME.current_round.hands_played or 0; if n==1 then ease_dollars(12); return DFC.status(card,'$12',G.C.MONEY) elseif n==2 then ease_dollars(5); return DFC.status(card,'$5',G.C.MONEY) end end
end
function H.preacher(card, context) if context.individual and context.cardarea==G.play then local v=DFC.rank_value(context.other_card); if v==6 or v==9 then return {x_mult=2} end end end
function H.road_roller(card, context)
  if context.before and context.main_eval and not context.blueprint and G.GAME.current_round.hands_left==0 then local all={}; for _,c in ipairs(context.full_hand or {}) do all[#all+1]=c end; for _,c in ipairs(G.hand.cards or {}) do all[#all+1]=c end; local lo,hi=99,0; for _,c in ipairs(all) do local v=DFC.rank_value(c); lo=math.min(lo,v); hi=math.max(hi,v) end; local haslo,hashi=false,false; for _,c in ipairs(context.full_hand or {}) do local v=DFC.rank_value(c); haslo=haslo or v==lo; hashi=hashi or v==hi end; e(card).active=haslo and hashi end
  if context.after and context.main_eval and not context.blueprint and e(card).active then e(card).active=false; DFC.add_consumable('Spectral','dfc_roller'); return DFC.status(card,'+幻灵',G.C.SPECTRAL) end
end
function H.gangster_goon(card, context)
  if context.individual and context.cardarea==G.play then if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') then return {mult=4} else return {chips=30} end end
end
function H.crab_catcher(card, context)
  if context.setting_blind then e(card).target=nil end
  if context.before and context.main_eval and G.GAME.current_round.hands_played==0 and not context.blueprint then for _,c in ipairs(context.full_hand or {}) do if c:is_face() and (not e(card).target or DFC.rank_value(c)>DFC.rank_value(e(card).target)) then e(card).target=c end end end
  if context.after and context.main_eval and not context.blueprint and e(card).target then DFC.copy_to_area(e(card).target,G.hand); e(card).target=nil; return DFC.status(card,'复制！',G.C.CHIPS) end
end
function H.javelin(card, context) if context.joker_main and #(context.scoring_hand or {})>=2 then local d=math.abs(DFC.rank_value(context.scoring_hand[1])-DFC.rank_value(context.scoring_hand[#context.scoring_hand])); if d>0 then return {chips=d*10} end end end
function H.camellia_lady(card, context)
  if context.end_of_round and context.main_eval and not context.blueprint and G.hand and #G.hand.cards>0 then local left=G.hand.cards[1]; local right=G.hand.cards[#G.hand.cards]; if right then DFC.copy_to_area(right,G.deck) end; DFC.destroy_playing_card(left); return DFC.status(card,'交换',G.C.RED) end
end
function H.strong_sailor(card, context)
  if context.using_consumeable and not context.blueprint then e(card).chips=e(card).chips+2; return DFC.status(card) end
  if context.individual and context.cardarea==G.play and e(card).chips>0 then return {chips=e(card).chips} end
  if context.after and context.main_eval and not context.blueprint then e(card).chips=0 end
end
function H.serotonin(card, context)
  if context.setting_blind and not context.blueprint then local r=pseudorandom('dfc_serotonin'); if r<1/3 then ease_dollars(10); return DFC.status(card,'$10',G.C.MONEY) elseif r<2/3 then DFC.add_consumable('Spectral','dfc_serotonin'); return DFC.status(card,'+幻灵',G.C.SPECTRAL) else DFC.add_consumable('Tarot','dfc_serotonin'); return DFC.status(card,'+塔罗',G.C.TAROT) end end
end
function H.werther(card, context)
  if context.joker_main then return {x_mult=math.max(1,e(card).xmult)} end
  if context.after and context.main_eval and not context.blueprint then e(card).xmult=math.max(1,e(card).xmult-0.05*#(context.full_hand or {})) end
end
function H.hacker(card, context)
  if context.starting_shop then e(card).used=false end
  if context.reroll_shop and not context.blueprint and not e(card).used then e(card).used=true; G.E_MANAGER:add_event(Event({func=function() local pool=DFC.current_shop_cards(); local c=#pool>0 and pseudorandom_element(pool,pseudoseed('dfc_hacker')) or nil; if c then c.ability.couponed=true; c:set_cost() end; return true end})); return DFC.status(card,'$0',G.C.MONEY) end
end
function H.rubber_head(card, context)
  if context.joker_main then local chips=0; for _,c in ipairs(G.hand.cards or {}) do chips=chips+(c.base and c.base.nominal or 0) end; if chips>0 then return {chips=chips*2} end end
end
function H.clockwork_orange(card, context)
  if context.individual and context.cardarea==G.play and context.other_card.ability.dfc_new_card then return {x_mult=1.5} end
  if context.repetition and context.cardarea==G.play and context.other_card.ability.dfc_new_card then return {repetitions=1} end
end
function H.django(card, context)
  if context.setting_blind then e(card).target=nil; e(card).survivor=nil end
  if context.before and context.main_eval and G.GAME.current_round.hands_played==0 and #(context.full_hand or {})==2 and not context.blueprint then local pick=pseudorandom('dfc_django')<0.5 and 1 or 2; e(card).target=context.full_hand[pick]; e(card).survivor=context.full_hand[3-pick] end
  if context.destroying_card and context.destroying_card==e(card).target then return {remove=true} end
  if context.after and context.main_eval and not context.blueprint and e(card).target and e(card).survivor then e(card).survivor.ability.perma_bonus=(e(card).survivor.ability.perma_bonus or 0)+DFC.rank_value(e(card).target); e(card).target=nil; return DFC.status(card,'转移！',G.C.CHIPS) end
end

local function loc_vars(key, card)
  local x=e(card)
  if key=='smaug' then return {x.xmult,x.spent} end
  if key=='asabith' then return {x.repetitions,x.destroyed} end
  if key=='chinese_dragon' or key=='bull_demon' or key=='shadow_warrior' or key=='first_blood' then return {x.mult or x.chips or 0} end
  if key=='cannon_mark' or key=='werther' then return {x.xmult} end
  if key=='drifting_iceberg' or key=='great_wall' then return {x.chips} end
  if key=='zombie_shaun' then return {x.max*2} end
  if key=='strong_sailor' then return {x.chips} end
  return {}
end

for index, s in ipairs(specs) do
  local key,name,text,rarity,cost,extra = s[1],s[2],s[3],s[4],s[5],s[6]
  SMODS.Joker {
    key=key, atlas='Jokers', pos={x=(index-1)%10,y=math.floor((index-1)/10)},
    rarity=rarity, cost=cost, unlocked=true, discovered=true,
    blueprint_compat=not ({smaug=true,asabith=true,gorn=true,chinese_dragon=true,phantom_ninja=true,mad_treant=true,t800=true,bull_demon=true,great_white_shark=true,cannon_mark=true,spider_witch=true,tokamak=true,silver_walker=true,melatonin=true,dwarf_miner=true,oak_shield=true,first_blood=true,white_elephant=true,suspect_x=true,swamp_crocodile=true,drifting_iceberg=true,zombie_shaun=true,fund_manager=true,road_roller=true,crab_catcher=true,camellia_lady=true,strong_sailor=true,serotonin=true,hacker=true,django=true})[key],
    eternal_compat=true, perishable_compat=true,
    config={extra=extra}, loc_txt={name=name,text=text},
    loc_vars=function(self,info_queue,card) return {vars=loc_vars(key,card)} end,
    calculate=function(self,card,context) return H[key] and H[key](card,context) end,
    add_to_deck=key=='white_elephant' and function(self,card,from_debuff) if not from_debuff then G.GAME.discount_percent=(G.GAME.discount_percent or 0)+50 end end or nil,
    remove_from_deck=key=='white_elephant' and function(self,card,from_debuff) if not from_debuff then G.GAME.discount_percent=math.max(0,(G.GAME.discount_percent or 0)-50) end end or nil,
  }
end

sendInfoMessage('Registered ' .. tostring(#specs) .. ' Jokers', 'DragonFantasyCity')

return specs

