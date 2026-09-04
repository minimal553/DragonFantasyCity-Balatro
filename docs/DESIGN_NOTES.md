# 设计说明 / Design Notes

## 1. 核心目标 / Core fantasy

《龙与奇幻城》的目标不是单纯把小丑牌数量从 150 增加到 196，而是让玩家进入一套新的组合语言：**花费、毁灭、重触发、新增牌、手牌位置与商店行为都可以成为可成长的资源。**

The goal is not merely to raise the Joker count. The mod introduces a new combo vocabulary in which **spending, destruction, retriggers, newly created cards, hand position, and shop actions can all become scaling resources.**

## 2. 三层稀有度结构 / Three-tier rarity structure

- **传奇 / Legendary**：必须值得围绕它重建整局。四条龙都是长期成长引擎，初始并非立即爆炸，但能把一种行为永久资本化。
- **稀有 / Rare**：必须改变路线或触发结构。它们负责强随机、资源转换、全局规则与高风险交易。
- **罕见 / Uncommon**：必须单句可懂、两张可组。它们覆盖具体窗口，既能独立工作，也能成为更大引擎的齿轮。

- **Legendary** cards should justify rebuilding the run around them. Each dragon permanently capitalizes one repeated behavior.
- **Rare** cards should redirect the run through conversion, global rules, high variance, or high-risk bargains.
- **Uncommon** cards should be understandable in one sentence and combinable in pairs. They occupy specific trigger windows and act as engine parts.

## 3. 四条主要构筑轴 / Four build axes

1. **经济与消费**：史矛革、库克、托卡马克、白象、基金经理、黑客、银翼杀手。
2. **毁牌与继承**：阿萨比斯、T-800、牛魔王、大白鲨、巨炮、矮人矿工、第一滴血、鳄鱼、茶花女、姜戈。
3. **重触发与新增牌**：骨恩、树魔、蜘蛛女巫、巨蟒、霍克、发条橙。
4. **手牌结构与顺序**：暗影武士、长城、成吉思汗、褪黑素、橡树盾、冰山、巨人、洋葱骑士、橡皮头。

这些轴故意交叉。例如骨恩不只是“给一张 K”：它提供钢铁、红蜡封、人头牌、新增牌事件和当前手牌资源，因此能同时接入留手、蜡封、K、发条橙与全息类效果。

The axes intentionally overlap. Gorn does not merely create a King: it creates a Steel card, a Red Seal, a face card, a newly-added-card event, and an immediate hand resource. One effect can therefore connect several otherwise separate builds.

## 4. 众生平等牌组 / Equal Fortune Deck

牌组的情绪曲线是“现在给你梦想，之后让你偿还”。开局灵魂保证玩家能尽快接触传奇内容；商店概率仍以普通牌为主体（60/24/13/3），避免传奇泛滥。第三个盲注开始，基础出牌与弃牌各减少一次，让早期礼物转化为持续的操作压力。

The deck says: **take the dream now, repay it later**. The starting Soul guarantees early access to a Legendary. The 60/24/13/3 rarity curve keeps ordinary Jokers dominant in shops, while the Blind-3 hand/discard penalty converts the opening gift into lasting pressure.

## 5. 美术层级 / Visual hierarchy

- **传奇牌**：角色占据画面主体，轮廓强、表情或姿态有冲击，背景流动但服务于主形。
- **稀有牌**：保留人物或场景叙事，减少传奇牌的满幅压迫，让机制道具更清楚。
- **罕见牌**：高度符号化与抽象化，一个主符号、简单背景、清楚的色彩对立；不强迫每张牌都出现人物或手持扑克牌。
- **共同质感**：该亮的地方亮、该重的地方重；保留暗部重量和高光分离，不靠整体漂白获得“明亮”。

- **Legendary**: dominant characters, aggressive silhouettes, and flowing backgrounds that support—not compete with—the subject.
- **Rare**: narrative characters or scenes with clearer mechanical props and less full-frame pressure.
- **Uncommon**: highly symbolic, abstract, one dominant icon, simple background, and strong color separation. Not every card needs a character or a hand of playing cards.
- **Shared finish**: highlights must shine and shadows must carry weight. Brightness comes from local separation, not from washing the whole image pale.

## 6. 平衡原则 / Balance principles

- 永久成长需要明确成本：花钱、毁牌、失败概率、提高盲注或牺牲资源。
- 强随机牌必须让玩家能围绕结果继续行动，而不是直接锁死流程。
- 重触发必须有递归边界；树魔不触发自身或同名牌，蜘蛛女巫每手只产一张塔罗。
- 新增牌必须进入标准事件链，保证能与其他 MOD 的“新增扑克牌”小丑联动。
- 人头牌统一按 10，A 按 11；所有点数型机制共享同一工具函数。

- Permanent scaling needs a visible cost: money, destroyed cards, failure probability, harder blinds, or sacrificed resources.
- High-variance effects must leave the player in a valid game state; rewards never bypass core pack-opening transitions.
- Retrigger systems require recursion boundaries.
- Newly created cards use the standard card-added event flow for cross-mod compatibility.
- Face cards count as 10 and Aces as 11 across all rank-based mechanics.

## 7. 当前验证边界 / Current verification boundary

v0.1.3 已通过静态结构、资源尺寸、关键机制断言和实际启动日志验证。46 张牌全部注册成功，未发现本 MOD 的 Lua 语法或启动栈错误。由于组合空间很大，尚不能声称每一种跨 MOD、每一种蓝图/负片/重触发排列都经过完整长局验证；因此公开版本明确标记为 playtest。

v0.1.3 passes structural checks, asset-size checks, key-mechanic assertions, and a real startup-log validation. All 46 Jokers register successfully with no known mod-originated Lua syntax or startup stack errors. The combinatorial space is too large to claim exhaustive cross-mod testing, so the public build is explicitly labeled a playtest.

[返回主页 / Back to README](../README.md)

