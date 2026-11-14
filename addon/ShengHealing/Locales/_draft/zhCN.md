# ShengHealing UI · zhCN

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName zhCN](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhCN)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7阿圣|r|cffd9b25f治疗助手|r 
阿聖治療幫手｜Sheng Healing｜阿圣治疗助手
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s出错：|r%s　请将这行发给开发者。
滑鼠提示｜Tooltip｜鼠标提示
分析｜Analysis｜分析
比較表｜Table｜比较表
除錯指令｜Debug command｜调试命令
掛上滑鼠提示｜Tooltip hook｜鼠标提示挂钩
小地圖按鈕｜Minimap button｜小地图按钮
聖光術｜Holy Light｜圣光术
聖光閃現｜Flash of Light｜圣光闪现
神聖震擊｜Holy Shock｜神圣震击
聖光戒備→震擊｜Light's Vigil > Shock｜圣光守望 > 震击
次級治療術｜Lesser Heal｜次级治疗术
治療術｜Heal｜治疗术
快速治療｜Flash Heal｜快速治疗
強效治療術｜Greater Heal｜强效治疗术
恢復｜Renew｜恢复
真言術：盾｜Power Word: Shield｜真言术：盾
治療禱言｜Prayer of Healing｜治疗祷言
懺悟｜Penance｜苦修
癒合禱言｜Prayer of Mending｜愈合祷言
神聖新星（治療）｜Holy Nova (heal)｜神圣新星（治疗）
治療之觸｜Healing Touch｜治疗之触
回春術｜Rejuvenation｜回春术
癒合（不含HoT）｜Regrowth (direct)｜愈合（直接治疗）
癒合｜Regrowth｜愈合
寧靜｜Tranquility｜宁静
野性痊癒｜Wild Growth｜野性成长
治療波｜Healing Wave｜治疗波
次級治療波｜Lesser Healing Wave｜次级治疗波
治療鍊｜Chain Heal｜治疗链
激流｜Riptide｜激流
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜冷却10秒，永恒中的治疗之光也会提高震击治疗量。
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜守望冷却6秒，只计小队治疗。
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜法术书显示774–910，采用客户端降阶数值。
HoT 總量／15秒｜HoT total over 15 sec｜15秒持续治疗总量
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜吸收，基础冷却4秒。同一目标的虚弱灵魂持续15秒（永恒待验证）。
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜为目标所在小队的每位成员恢复此数值的生命值。
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3跳，每跳133点。冷却12秒，系数待验证。
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜每跳治疗量相同，最多5跳，冷却10秒。
治療分量；係數待核｜Healing part only; coefficient unverified｜仅计算治疗量，系数待验证。
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜12秒总治疗量，永恒已验证。
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜仅直接治疗，持续治疗另列。
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜持续治疗：21秒共91点（客户端）。直接治疗系数0.286，持续治疗系数0.497。
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜引导法术，每人总治疗量，冷却较长。
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜施法3秒，冷却6秒（ForeverChanges），不是瞬发。
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜第一跳是基础治疗量，总量为1＋0.5＋0.25。
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜仅持续治疗，冷却12秒，无直接治疗。
聖光誓約｜Oath of Light｜圣光誓约
誓約目標｜Oath target｜誓约目标
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜对誓约目标施放圣光术、圣光闪现和神圣震击时获得固定加成。计入时，比较表使用誓约目标的治疗量。
聖光束縛｜Holy Binding｜神圣联结
對他人施放（含自療）｜On others (with self-heal)｜对他人施放（含自疗）
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜对别人施放快速治疗时，也为你恢复治疗量的50%。计入时，比较表把自疗加到快速治疗中。
激流加成｜Riptide bonus｜激流加成
目標有激流｜Target has Riptide｜目标有激流
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜对带有你的激流的目标直接施放治疗链时，第一跳治疗量提高25%。计入时，比较表使用该数值。
綻放｜Bloom｜绽放
含綻放｜With Bloom｜包含绽放
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜你的回春术或愈合的持续治疗结束时，目标恢复等同于你精神值100%的生命值（被驱散时为50%）。计入时，比较表包含这部分治疗。
沒學｜Not learned｜未学习
計入｜Included｜计入
不計入｜Excluded｜不计入
讀不到｜not found｜未找到
經典｜Classic｜经典旧世
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜天赋加成
沒有偵測到治療加成天賦｜No healing talents detected｜未检测到治疗加成天赋。
治療加成 ｜Healing bonus ｜治疗加成 
%（手動）｜% (manual)｜%（手动）
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜圣光誓约：未读取到加成（请执行 /shps debug 后回报）
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜圣光誓约：圣光术 +%d、圣光闪现 +%d、神圣震击 +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜绽放：每次持续治疗结束＋
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ 等级
 秒｜ sec｜ 秒
開｜On｜开
關｜Off｜关
單補｜Single｜单体
群補｜Group｜群体
冷卻｜Cooldown｜冷却
救命｜Emergency｜救急
保持｜Keep ｜保持
鋪｜Spread ｜铺给
，救命 ｜, emergency ｜，救急 
（停到 %d%%）｜ (hold until %d%%)｜（等到%d%%再施放）
（救命 %s）｜ (emergency %s)｜（救急%s）
，坦克快倒時改放 %s｜, %s when the tank is low｜，坦克濒死时施放%s
戰鬥中不分析｜Not available in combat｜战斗中无法分析
讀不到回藍｜Can't read mana regen｜无法读取法力回复
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜%d秒内补完，冷却%s秒
冷卻 %s 秒｜%s sec cooldown｜冷却%s秒
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜直接治疗%s（每秒%s），%d秒持续治疗%s；轮流治疗%d个目标时，每次只生效%d%%。
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜直接治疗%s（每秒%s），%d秒持续治疗%s（每秒%s）\n轮流治疗不同目标：每秒%s
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜%d秒内补完，铺给%d个目标
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜%d秒内补完，轮流治疗时每秒%s
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜每个目标每15秒一次，轮流施放时每秒%s
（吸收）｜ (absorb)｜（吸收）
（%d人）｜ (%d targets)｜（%d人）
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜降阶
治療效果只算 %d%%｜%d%% of Bonus Healing｜只计治疗效果的%d%%
★ %s HPS最高｜* Best HPS (%s)｜* 最佳HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* 最佳HPM (%s)
拖曳調整視窗大小｜Drag to resize｜拖动调整大小
設定｜Settings｜设置
技能｜Spell｜法术
等級｜Rank｜等级
有效量｜Heal｜有效治疗
法力｜Mana｜法力
秒｜Sec｜秒
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜%d级 · 治疗效果%d
 · 精神 %d｜ · Spirit %d｜ · 精神%d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · 每5秒回蓝：停手%d／施法中%d
技能提示：｜Spell tooltip: ｜法术提示： 
精簡｜Brief｜简洁
標準｜Standard｜标准
完整｜Full｜完整
群補人數 ｜Group targets ｜群体治疗人数 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS＝治疗量÷施法时间\n|cff9a9282瞬发按1.5秒计算\n持续治疗按持续时间计算，群体模式看可同时维持的目标数\n有冷却的法术单独显示，按次计算|r
（吸收）|r｜ (absorb)|r｜（吸收）|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜此页没有已学会的法术。
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* 最高HPS|r %s 等级%d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* 最高HPM|r %s 等级%d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜没有可比较的治疗法术（吸收效果不参与比较）。
（滾輪看更多）｜(scroll for more)｜（滚动查看更多）
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜吸收不属于治疗，不参与最高HPS/HPM的比较。
學習等級｜Learned at｜学习等级
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜一些值来自数据表（游戏中无法读取）
單坦｜Tank｜坦克
團刷｜Group｜群体
小怪｜Trash｜小怪
王戰｜Boss｜首领
單練｜Solo｜单刷
省水｜Easy｜轻松
群怪｜Trash｜小怪群
全團技｜Raid AoE｜团队范围伤害
範圍｜AoE｜范围伤害
點名｜Targeted｜点名
詳細｜Details｜详情
坦克生命 %d｜Tank HP %d｜坦克生命值%d
每次傷害 %d｜Damage per hit %d｜每击伤害 %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜受击间隔%.1f秒
戰鬥長度 %d 秒｜Fight length %d sec｜战斗时长%d秒
人數 %d｜Group size %d｜小队人数%d
成員生命 %d｜Member HP %d｜队员生命值%d
坦克每次傷害 %d｜Tank hit %d｜坦克单次承伤%d
坦克每次傷害 無｜Tank hit: none｜坦克承伤：无
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜坦克受击间隔%.1f秒
範圍每次傷害 %d｜AoE hit %d｜范围伤害每次%d
範圍每次傷害 無｜AoE hit: none｜范围伤害：无
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜范围伤害间隔%.1f秒
範圍命中 隨機 %d 人｜AoE hits %d random｜范围伤害命中随机%d人
範圍命中 全員｜AoE hits everyone｜范围伤害命中所有人
最省藍｜Most efficient｜最省蓝
最穩定｜Most stable｜最稳定
撐最久｜Lasts longest｜撑得最久
沒有可以補的技能｜No healing spells to use｜没有可用的治疗法术
沒有可以單補的技能｜No single-target heals to use｜没有可用的单体治疗
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100最高效：|r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100最稳定：|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6b都撑不住：|r最好 %s（%s）
%d 秒滅團｜wipe at %d sec｜%d秒时灭团
倒 %d 人｜%d dead｜%d人阵亡
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6b都撑不住：|r最久 %s（撑%d秒）
活｜Alive｜活着
倒下 %d 秒｜Dead at %d sec｜%d秒时阵亡
滅團 %d 秒｜Wipe at %d sec｜%d秒时灭团
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d人阵亡，首人在%d秒倒下
沒藍 %d 秒｜OOM at %d sec｜%d秒时耗尽法力
補滿差 ｜Short by ｜还缺 
剩藍 ｜Mana left ｜剩余法力 
最低 %d%%｜Low %d%%｜最低%d%%
每 ｜Every ｜每 
 秒一發｜ sec｜ 秒一次
沒出手｜No casts｜未施法
不用喝水｜No drinking｜不用喝水
打完要喝水｜Drink after｜打完喝水
可連打 %d 波｜%d pulls in a row｜可连打%d波
補到｜Healed｜有效治疗
溢補｜Overheal｜过量治疗
施法｜Casts｜施法次数
 次｜｜
、救命 ｜, emergency ｜，紧急 
倒下｜Deaths｜死亡
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d人，首人在%d秒倒下
，坦克或自己倒下｜, tank or you died｜，坦克或你阵亡
低於 30%｜Below 30%｜低于 30%
%d 人秒｜%d player-sec｜%d人秒
戰鬥結束｜Fight end｜战斗结束
不喝水連打｜Pulls in a row｜连续战斗次数
 波｜｜
救命 ｜emergency ｜紧急 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜坦克%d%%，剩余法力%s
技能提示的 HPS：｜Spell tooltip HPS: ｜法术提示中的HPS： 
左鍵：開關比較表｜Left-click: toggle the table｜左键：开关比较表
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜右键：开关提示HPS（当前
拖曳：沿著小地圖移動｜Drag: move around the minimap｜拖动：沿小地图移动
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜版本%s　API：%s　法术书：%d个法术
新版 C_SpellBook｜new C_SpellBook｜新版 C_SpellBook
舊版｜legacy｜旧版
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜职业%s　等级%d　治疗效果%d　说明数值：%s　天赋：%s
已含治療效果｜include Bonus Healing｜已含治疗效果
基礎量｜base only｜仅基础值
沒找到｜none｜无
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜圣光誓约：未读取到加成。天赋说明： 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜圣光誓约：圣光术 +%d、圣光闪现 +%d、神圣震击 +%d (%s)
比較表已計入｜included in the table｜比较表已计入
比較表未計入｜not included in the table｜比较表未计入
已點天賦：｜Talents: ｜天赋： 
有｜Yes｜是
（比較表已計入）｜ (included in the table)｜（比较表已计入）
（比較表未計入）｜ (not included in the table)｜（比较表未计入）
沒偵測到｜Not detected｜未检测到
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜没有匹配的治疗法术。法术书前几项： 
%s：法術書沒找到｜%s: not in spellbook｜%s：法术书中未找到
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s：游戏名称「%s」，最高等级%d（%d阶有法术ID）。解析：%s
不解析｜not parsed｜未解析
失敗：｜failed: ｜失败： 
說明未載入｜description not loaded｜说明未加载
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜此职业没有治疗法术，插件未启用。
小地圖按鈕：｜Minimap button: ｜小地图按钮： 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜隐藏（输入 /shps minimap 显示）
顯示｜shown｜已显示
治療加成 %：｜Healing bonus %: ｜治疗加成%： 
（手動）｜ (manual)｜ （手动）
依天賦自動｜auto from talents｜按天赋自动计算
吸收加成 %：｜Absorb bonus %: ｜吸收加成%： 
群補目標數：｜Group targets: ｜群体治疗人数： 
滑鼠提示：｜Tooltip: ｜鼠标提示： 
降級衰減：｜Downrank penalty: ｜降阶惩罚： 
視窗縮放：｜Window scale: ｜窗口缩放： 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜用法：/shps scale 1.2（0.5～2，当前 
技能說明數字：｜Spell description values: ｜法术说明数值： 
已含治療效果（手動）｜include Bonus Healing (manual)｜已含治疗效果（手动）
只有基礎量（手動）｜base only (manual)｜仅基础值（手动）
自動判斷｜auto｜自动
　目前：｜  Now: ｜  现在： 
直接採用說明數字｜using description values｜直接使用说明数值
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜基础值＋治疗效果×系数
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜界面语言：%s（/reload后生效）
設定已重設｜Settings reset｜设置已重置
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps 开关窗口  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = 压力测试，英文拉长35%)  /shps debug  /shps reset
```
