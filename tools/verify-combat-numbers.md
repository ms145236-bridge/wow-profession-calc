# ShengHealing 分析頁戰鬥數值查核

版本基準為《魔獸世界：永恆》**1.60.1.70938**。正式服原始戰鬥紀錄另標明日期和可辨識的版本，並保留 Beta 與經典對照。插件的「每次傷害」直接從生命值扣除，所以下方建議填**實收**。怪物的原傷留在證據表，用於套入不同護甲。HP 以未吃世界增益、藥劑和隊伍耐力增益的一般練級裝／剛滿級五人裝為主。[永恆版官方說明](https://news.blizzard.com/en-us/article/24315821/wow-foreverwhats-new-and-what-feels-familiar) · [原始戰鬥紀錄欄位](https://github.com/wowsims/forever/issues/76#reading-the-logs)

## 建議替換值

`L` 是玩家等級。非表列等級用相鄰兩列線性內插，最後把 HP 取到百位、傷害取到十位。兩隻菁英用同一個每擊值，間隔改成 **1.0 秒**，代表兩隻 2 秒攻速錯開的平均壓力。一隻菁英與首領用 **2.0 秒**等效間隔。這個設定保留每秒壓力，兩隻同時揮擊時的瞬間爆發另做壓力情境。

| L | 坦克 HP | 布甲 HP | 1 菁英實收／2 秒 | 王戰實收／2 秒 | 聖騎單練實收／2 秒 | 單練戰鬥秒數 |
|---:|---:|---:|---:|---:|---:|---:|
| 20 | 700 | 400 | 30 | 50 | 20 | 15 |
| 30 | 1200 | 700 | 50 | 80 | 40 | 20 |
| 35 | 1600 | 900 | 60 | 90 | 40 | 25 |
| 40 | 1900 | 1100 | 70 | 110 | 50 | 25 |
| 45 | 2400 | 1300 | 100 | 160 | 60 | 25 |
| 50 | 2900 | 1700 | 130 | 160 | 60 | 30 |
| 55 | 3500 | 2000 | 190 | 360 | 70 | 30 |
| 60 | 4300 | 2400 | 300 | 360 | 80 | 30 |

- **菁英**以每級兩隻經典原傷樣本的 DPS 中位數，乘同級坦克護甲及防禦姿態 0.9，再換算每 2 秒等效實收。30 級正式服諾莫瑞根兩隻菁英實收 36–56、47–55，攻速分別約 2.4 和 2.0 秒，支持把 50 當第一版。55／60 級的加重來自所選黑石深淵、斯坦索姆和通靈學院怪種，仍需正式服驗證。預設反映持續承傷，格擋、閃躲、招架、減攻速、碾壓、法術與同時挨打另看場景。[正式服諾莫瑞根原始紀錄](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455) · [防禦姿態台服提示](https://nether.wowhead.com/forever/tooltip/spell/71?locale=10)
- **首領**的 30／35 級錨點參考諾莫瑞根的每擊實收，再以樣本坦克護甲、首領等級和姿態估算。其他級距取下方對照表相近副本的武器傷害，以相同方式轉成 2 秒值，排除明顯異常的瑟萊德絲公主欄。40 級赫洛德約 108／2 秒。57 級瑪格姆斯套 55 級模型約 360／2 秒。60 級端取黑石深淵尾王、斯坦索姆及通靈學院的中位附近。35 級以上指定王的永恆白字仍【需遊戲實測】，這組值是情境預設，個別王可大幅偏離。[永恆首領資料入口](https://www.wowhead.com/forever/guide/dungeons-overview-locations-details) · [經典比較基礎資料](https://github.com/cmangos/classic-db/blob/master/Full_DB/ClassicDB_1_12_1_z2815.sql.gz)
- **單練**有角色的 `UnitHealthMax("player")` 就用自身最大生命，未知時才使用估值。角色護甲可讀時用實際護甲套下方公式。上表已按懲戒聖騎、雙手武器、沒有盾牌估計。現有分析頁單次傷害最低 50、團員 HP 最低 500、單人戰鬥長度滑桿從 30 秒起，預設直接指派時則可有不同的值。這些下限會擋住表內幾組低等建議值，且傷害和戰鬥長度也會受現有介面步進影響。若保留既有下限，20 級布甲 HP 會成為 500，20–35 級單練實收也會被抬到 50／2 秒。[永恆聖騎練級技能順序](https://www.wowhead.com/forever/guide/classes/paladin/retribution/dps-leveling-tips)

### 團刷預設

下表的傷害以布甲預設最大生命為基準，取到十位。全員大招為每人 **20% HP／20 秒／5 人**的壓力測試。持續範圍為每跳 **6% HP，上限 150／3 秒／2 人**。點名為 **17% HP／15 秒／1 人**，坦克同時以王戰欄每 2 秒承傷。這些比例是建議預設強度。各副本依實際受擊人數、階段和跳傷間隔覆蓋。沒有團傷的群怪設 0 範圍傷害，坦克吃兩隻菁英。想保留可躲的近身群怪壓力，可用持續範圍欄取 1–2 名近戰。團刷分析頁的命中人數 `0` 代表全員，因此全員情境填 `gAoeK=0`，持續範圍填 2，點名填 1。

| L | 全員大招（每人／20 秒） | 持續範圍（每人／3 秒，2 人） | 點名（／15 秒，1 人） |
|---:|---:|---:|---:|
| 20 | 80 | 20 | 70 |
| 30 | 140 | 40 | 120 |
| 35 | 180 | 50 | 150 |
| 40 | 220 | 70 | 190 |
| 45 | 260 | 80 | 220 |
| 50 | 340 | 100 | 290 |
| 55 | 400 | 120 | 340 |
| 60 | 480 | 140 | 410 |

諾莫瑞根已見近身傷害打中 1–4 人，兩次擊飛相隔 15.89 秒。剃刀高地的疾病雲與瑪拉頓諾克賽恩的毒性齊射約每 3 秒一跳。斯坦索姆男爵的近身光環資料是每 2 秒 150 暗影，直接使用 150／2 秒和近身人數。黑石深淵瑪格姆斯的 8 碼烈焰爆發法術列 694–806，若要模擬踩到爆發，可用約 750 加實際受擊人數，施放間隔【需遊戲實測】。持續傷害的每跳間隔和首領重施間隔需分開。法術傷害依抗性、站位與可打斷性分開，護甲公式用在物理攻擊。[11 月正式服紀錄](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455) · [正式服抗性與跳傷資料](https://github.com/wowsims/forever/issues/76) · [瑞文戴爾男爵地城手冊](https://www.wowhead.com/forever/dungeon-journal/stratholme-undead/baron-rivendare) · [烈焰爆發](https://www.wowhead.com/forever/spell=1294482/fiery-burst)

## 客戶端資料覆蓋與護甲

70938 的公開 `Creature` 與 `CreatureDifficulty` CSV 各 189 筆。前者有名稱與分類，後者有等級、陣營、旗標和調校 ID。代表怪和首領的每擊傷害、攻速、個體倍率無法從這兩份 CSV 查到。Wowhead 永恆頁與台服提示可比對怪名、等級和分類，所查代表頁也沒有可對應正式服的傷害欄。QuestieDB 供等級、區域與怪種定位。公開 `ExpectedStat` 的八列都是 `ExpansionID=-2 / ContentSetID=0`，可取等級基準。這批經典普通怪初始化模型與基準 DPS 一致到小數點後兩位，20／30 級野外實測也支持該量級。公開 `ExpectedStatMod` 只有少量共用倍率，沒有查到把指定 NPC 唯一連到傷害倍率與攻速的資料。【需遊戲實測】[Creature CSV](https://wago.tools/db2/Creature/csv?build=1.60.1.70938) · [CreatureDifficulty CSV](https://wago.tools/db2/CreatureDifficulty/csv?build=1.60.1.70938) · [ExpectedStat CSV](https://wago.tools/db2/ExpectedStat/csv?build=1.60.1.70938) · [ExpectedStatMod CSV](https://wago.tools/db2/ExpectedStatMod/csv?build=1.60.1.70938) · [QuestieDB](https://github.com/Questie/QuestieDB)

| L | ExpectedStat 怪物 HP | 怪物基準原始近戰 DPS | 基準怪物護甲 | ArmorConstant |
|---:|---:|---:|---:|---:|
| 20 | 629 | 17.10 | 861 | 2100 |
| 30 | 1242 | 24.69 | 1212 | 2950 |
| 35 | 1586 | 28.26 | 1387 | 3375 |
| 40 | 1981 | 32.59 | 1980 | 3800 |
| 45 | 2402 | 43.99 | 2742 | 4225 |
| 50 | 2909 | 49.20 | 3018 | 4650 |
| 55 | 3602 | 54.68 | 3292 | 5075 |
| 60 | 4365 | 60.45 | 3566 | 5500 |

物理普攻用 `K=400+85×攻擊者等級`、`DR=min(0.75,A/(A+K))`，A 為**受擊者**護甲。以原傷乘 `1−DR` 得護甲後傷害，戰士防禦姿態另乘 0.9。永恆 70938 的 `ArmorConstant` 和經典算式逐列相同，Beta 原始紀錄也支持此式。例：40 級怪的 112–149 普攻打 3,000 護甲戰士，僅算護甲是 63–83，防禦姿態約 56–75。等級用攻擊者，挨 62 級王攻擊用 5,670。正式服高等怪跨等級實收、格擋及特殊狀態【需遊戲實測】。[70938 ExpectedStat](https://wago.tools/db2/ExpectedStat/csv?build=1.60.1.70938) · [永恆 Beta 護甲實測](https://github.com/magey/forever-warrior/issues/24) · [防禦姿態](https://nether.wowhead.com/forever/tooltip/spell/71?locale=10)

## 普通怪與菁英小怪樣本

每級兩隻野外普通怪與兩隻副本菁英。等級、分類以 Wowhead 永恆台服提示為主，並比對本機 QuestieDB Forever。下表傷害及秒數採 CMaNGOS ClassicDB 1.12.1 z2815 對照模型，永恆正式服個別怪的近戰範圍、攻速【需遊戲實測】。數值在表列基準等級計算，未把怪物等級範圍的兩端混算。護甲後使用本報告的同級坦克護甲估值，僅扣護甲，格擋、閃躲、防禦姿態及特殊技能另計。[ClassicDB 原始資料](https://github.com/cmangos/classic-db/blob/master/Full_DB/ClassicDB_1_12_1_z2815.sql.gz) · [CMaNGOS Classic 傷害公式](https://github.com/cmangos/issues/wiki/Creature_template_classic) · [護甲減傷原始碼](https://github.com/cmangos/mangos-classic/blob/master/src/game/Entities/Unit.cpp#L2333-L2355)

每擊的基礎武器傷害範圍用 `[(B×V + AP/14)×S×M, (1.5×B×V + AP/14)×S×M]`，其中 B、AP 是怪物職業與等級基礎值，V 是傷害浮動參數，S 是攻擊間隔秒數，M 是 NPC 傷害倍率。如此可反映多隻小怪共用基礎等級值、但不同攻速與倍率的情況。此模型使用等級表分支，網站若只顯示傳統 `MinMeleeDmg/MaxMeleeDmg` 欄會得到不同結果。CMaNGOS 模擬器的後續戰鬥結算另有攻擊強度與其他修正，此處以和 `ExpectedStat` 一致的初始化基準比較。[Classic z2815 基礎傷害原始碼](https://github.com/cmangos/mangos-classic/blob/37206a9b5f5f61f23b17dee93651a8cd43bb8d32/src/game/Entities/Creature.cpp#L1274-L1287) · [Classic z2815 後續結算原始碼](https://github.com/cmangos/mangos-classic/blob/37206a9b5f5f61f23b17dee93651a8cd43bb8d32/src/game/Entities/StatSystem.cpp#L652-L685)

| 基準等級 | 區域 | NPC（ID） | 永恆等級／分類 | 經典模型原傷／擊 | 經典攻速（秒） | 僅扣護甲實收／擊 |
|---:|---|---|---|---:|---:|---:|
| 20 | 貧瘠之地 | [草原科多獸（3236）](https://nether.wowhead.com/forever/tooltip/npc/3236?locale=10) | 19–20／普通 | 44–59 | 3 | 25–34 |
| 20 | 貧瘠之地 | [漫遊斑馬（3466）](https://nether.wowhead.com/forever/tooltip/npc/3466?locale=10) | 20–21／普通 | 29–39 | 2 | 17–22 |
| 20 | 影牙城堡 | [影牙狼人衛兵（3854）](https://nether.wowhead.com/forever/tooltip/npc/3854?locale=10) | 20–21／菁英 | 50–66 | 2 | 29–38 |
| 20 | 影牙城堡 | [鬼怪僕從（3875）](https://nether.wowhead.com/forever/tooltip/npc/3875?locale=10) | 20–21／菁英 | 50–66 | 2 | 29–38 |
| 30 | 荊棘谷 | [小荊棘谷猛虎（681）](https://nether.wowhead.com/forever/tooltip/npc/681?locale=10) | 30–31／普通 | 28–37 | 1.3 | 17–22 |
| 30 | 阿拉希高地 | [枯木食人妖（2552）](https://nether.wowhead.com/forever/tooltip/npc/2552?locale=10) | 30–31／普通 | 42–56 | 2 | 26–34 |
| 30 | 剃刀沼澤 | [剃刀沼澤獸王（4532）](https://nether.wowhead.com/forever/tooltip/npc/4532?locale=10) | 30–31／菁英 | 72–96 | 2 | 43–58 |
| 30 | 血色修道院 | [血色拷問者（4306）](https://nether.wowhead.com/forever/tooltip/npc/4306?locale=10) | 30–31／菁英 | 85–113 | 2 | 51–68 |
| 35 | 荊棘谷 | [鞭尾迅猛龍（686）](https://nether.wowhead.com/forever/tooltip/npc/686?locale=10) | 35–36／普通 | 49–64 | 2 | 30–40 |
| 35 | 奧特蘭克山脈 | [破碎嶺蠻兵（2253）](https://nether.wowhead.com/forever/tooltip/npc/2253?locale=10) | 35–36／普通 | 73–97 | 3 | 45–60 |
| 35 | 血色修道院 | [血色士兵（4286）](https://nether.wowhead.com/forever/tooltip/npc/4286?locale=10) | 35–36／菁英 | 83–110 | 2 | 51–68 |
| 35 | 血色修道院 | [血色僧侶（4540）](https://nether.wowhead.com/forever/tooltip/npc/4540?locale=10) | 35–36／菁英 | 105–139 | 1.8 | 65–86 |
| 40 | 荊棘谷 | [劈顱戰士（667）](https://nether.wowhead.com/forever/tooltip/npc/667?locale=10) | 39–40／普通 | 56–74 | 2 | 31–42 |
| 40 | 悲傷沼澤 | [暗影黑豹（768）](https://nether.wowhead.com/forever/tooltip/npc/768?locale=10) | 39–40／普通 | 45–59 | 1.6 | 25–33 |
| 40 | 奧達曼 | [玉脊蜥蜴（4863）](https://nether.wowhead.com/forever/tooltip/npc/4863?locale=10) | 39–40／菁英 | 112–149 | 2 | 63–83 |
| 40 | 剃刀高地 | [碎骨統帥（7345）](https://nether.wowhead.com/forever/tooltip/npc/7345?locale=10) | 39–40／菁英 | 157–208 | 2.8 | 88–116 |
| 45 | 辛特蘭 | [銀鬃嗥狼（2925）](https://nether.wowhead.com/forever/tooltip/npc/2925?locale=10) | 45–46／普通 | 76–100 | 2 | 39–52 |
| 45 | 塵泥沼澤 | [老年黑色蛇頸龍（4390）](https://nether.wowhead.com/forever/tooltip/npc/4390?locale=10) | 43–45／普通 | 76–100 | 2 | 39–52 |
| 45 | 祖爾法拉克 | [沙怒飲血者（5649）](https://nether.wowhead.com/forever/tooltip/npc/5649?locale=10) | 44–45／菁英 | 189–251 | 2 | 97–129 |
| 45 | 祖爾法拉克 | [沙怒守護者（7268）](https://nether.wowhead.com/forever/tooltip/npc/7268?locale=10) | 45–46／菁英 | 167–222 | 1.7 | 86–114 |
| 50 | 辛特蘭 | [海水鉗嘴龜（2505）](https://nether.wowhead.com/forever/tooltip/npc/2505?locale=10) | 49–50／普通 | 85–112 | 2 | 42–56 |
| 50 | 菲拉斯 | [格羅多克大猩猩（5262）](https://nether.wowhead.com/forever/tooltip/npc/5262?locale=10) | 49–50／普通 | 85–112 | 2 | 42–56 |
| 50 | 黑石深淵 | [鐵怒獄卒（8890）](https://nether.wowhead.com/forever/tooltip/npc/8890?locale=10) | 49–50／菁英 | 254–337 | 2 | 126–167 |
| 50 | 黑石深淵 | [鐵怒衛士（8891）](https://nether.wowhead.com/forever/tooltip/npc/8891?locale=10) | 50–51／菁英 | 262–348 | 2 | 130–173 |
| 55 | 西瘟疫之地 | [骷髏劊子手（1787）](https://nether.wowhead.com/forever/tooltip/npc/1787?locale=10) | 54–55／普通 | 127–168 | 2.7 | 63–84 |
| 55 | 西瘟疫之地 | [生病的灰熊（1816）](https://nether.wowhead.com/forever/tooltip/npc/1816?locale=10) | 55–56／普通 | 94–125 | 2 | 47–62 |
| 55 | 黑石深淵 | [暮光之錘劊子手（9398）](https://nether.wowhead.com/forever/tooltip/npc/9398?locale=10) | 55–56／菁英 | 376–499 | 2 | 187–248 |
| 55 | 斯坦索姆 | [被撕裂的死屍（10382）](https://nether.wowhead.com/forever/tooltip/npc/10382?locale=10) | 54–56／菁英 | 338–449 | 2 | 168–223 |
| 60 | 冬泉谷 | [霜刃捕食者（7432）](https://nether.wowhead.com/forever/tooltip/npc/7432?locale=10) | 59–60／普通 | 78–103 | 1.5 | 39–51 |
| 60 | 東瘟疫之地 | [憎惡（8545）](https://nether.wowhead.com/forever/tooltip/npc/8545?locale=10) | 59–60／普通 | 104–138 | 2 | 52–69 |
| 60 | 斯坦索姆 | [鮮肉食屍鬼（10407）](https://nether.wowhead.com/forever/tooltip/npc/10407?locale=10) | 59–60／菁英 | 520–689 | 2 | 259–343 |
| 60 | 通靈學院 | [復活的戰士（10486）](https://nether.wowhead.com/forever/tooltip/npc/10486?locale=10) | 59–61／菁英 | 748–993 | 2.4 | 372–494 |

這批普通樣本的經典模型原始 DPS 在 20／30／35／40／45／50／55／60 級依序為 17.10／24.69／28.26／32.59／43.99／49.20／54.68／60.45，與永恆客戶端 `ExpectedStat.CreatureAutoAttackDps` 同級列一致到小數點後兩位。此比對支持採等級基準做預設，個別怪倍率與攻速仍由戰鬥紀錄校正。菁英兩隻樣本的原始 DPS 依序為 29／42–49／48–68／65／110–114／148–153／197–219／302–363，樣本分布反映不同副本小怪的倍率差距。[永恆 ExpectedStat 70938](https://wago.tools/db2/ExpectedStat?build=1.60.1.70938)

## 五人副本首領

等級用本機 QuestieDB Forever NPC，技能機制比對 Wowhead 永恆地城手冊及 70938 SpellEffect。公開 Creature 與 CreatureDifficulty 各 189 筆，都未覆蓋下列首領。代表 NPC 頁有等級、技能、掉落，未找到可對應版本的白字或揮擊時間欄。各列「經典對照」取 CMaNGOS 1.12 初始化武器傷害與揮擊間隔。法術施放間隔都標明經典腳本估計或【需遊戲實測】，持續技能的跳傷間隔另外列出。[QuestieDB](https://github.com/Questie/QuestieDB) · [70938 Creature](https://wago.tools/db2/Creature?build=1.60.1.70938) · [70938 CreatureDifficulty](https://wago.tools/db2/CreatureDifficulty?build=1.60.1.70938) · [70938 SpellEffect](https://wago.tools/db2/SpellEffect?build=1.60.1.70938) · [經典模擬資料庫](https://github.com/cmangos/classic-db/blob/master/Full_DB/ClassicDB_1_12_1_z2815.sql.gz) · [經典重建公式](https://github.com/hermensbas/cmangos-issues-wiki/blob/master/creature_template_classic.textile)

經典對照使用等級／怪物職業的基礎傷害 D、基礎攻強 AP、個體傷害倍率 M、變異係數 V 與間隔 S（秒）。範圍為 `(D×V + AP/14)×S×M` 至 `(1.5×D×V + AP/14)×S×M`。血量階段、加速、雙持、連擊、額外傷害與施法暫停普攻另算。部分資料站顯示的 70–93（赫洛德）來自經典資料庫未乘倍率欄位，同一模型計入倍率後為 231–307。瑟萊德絲公主的舊欄 344–444 與等級公式 86–114 相差很大，先保留兩值，不納入通用白字校正。【需遊戲實測】[赫洛德舊欄示例](https://www.wowforeverfriends.org/npcs/3975/) · [經典模擬計算原始碼](https://github.com/cmangos/mangos-classic/blob/master/src/game/Entities/Creature.cpp#L1336)

| 副本 | 首領（NPC ID）、等級 | 永恆白字／攻速 | 經典對照（傷害／秒一刀） | 範圍傷害與頻率 |
|---|---|---|---|---|
| 怒焰裂谷 | 『飢餓者』塔拉加曼 11520，16 | 【需遊戲實測】 | 56–74／2.0 | 火焰新星 #11970 約 10 碼。70938 客戶端效果中心約 620，舊版 NPC 描述 100–112，實收【需遊戲實測】。經典首次 9.2–14.7 秒、之後 10.4–18.1 秒。[永恆機制](https://www.wowhead.com/forever/guide/ragefire-chasm-dungeon-overview-location-rewards) · [永恆法術](https://www.wowhead.com/forever/spell=11970/fire-nova) · [舊版 NPC 技能描述](https://www.wowhead.com/npc=11520/taragaman-the-hungerer) |
| 哀嚎洞穴 | 『吞噬者』穆坦努斯 3654，22 | 【需遊戲實測】 | 77–102／2.0 | 雷霆震裂 #8150 近身，自然傷害 100 為永恆手冊與 DB2 基值，暈 2.5 秒。直接提示顯示 475，實收【需遊戲實測】。經典首次 0–10 秒、之後 10–16 秒。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/wailing-caverns/mutanus-the-devourer) · [永恆提示](https://nether.wowhead.com/forever/tooltip/spell/8150?locale=10) |
| 影牙城堡 | 大法師阿魯高 4275，26 | 【需遊戲實測】 | 196–260／2.0 | 雷霆震盪 #7803 近身自然傷害 75 為手冊與 DB2 基值，暈 5 秒。虛空箭 #7588 為單點暗影，手冊列 1,000，DB2 基值 275，兩招的實收和間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/shadowfang-keep/archmage-arugal) · [永恆雷霆震盪](https://nether.wowhead.com/forever/tooltip/spell/7803?locale=10) · [永恆虛空箭](https://nether.wowhead.com/forever/tooltip/spell/7588?locale=10) |
| 黑暗深淵 | 阿庫麥爾 4829，28 | 【需遊戲實測】 | 177–234／2.0 | 毒雲術 #3815 每 5 秒近身自然 50，持續 45 秒，手冊與 DB2 基值一致，直接提示顯示 527，實收【需遊戲實測】。經典首次 5–9 秒、之後 25–50 秒。狂暴怒氣另外提高攻速 75%。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/blackfathom-deeps/akumai) · [永恆法術](https://nether.wowhead.com/forever/tooltip/spell/3815?locale=10) |
| 血色修道院墓地 | 血法師薩爾諾斯 4543，34 | 【需遊戲實測】 | 75–99／2.0 | 烈焰尖刺 #8814 火焰 93–107，站在範圍內再每 3 秒 50，持續 9 秒。火焰新星 #12470 為近身，DB2 中心約 930，實收【需遊戲實測】。經典模擬的兩套 AI 表間隔不同，先保留永恆間隔未知。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scarlet-monastery-graveyard/bloodmage-thalnos) · [永恆法術](https://nether.wowhead.com/forever/tooltip/spell/8814?locale=10) |
| 血色修道院圖書館 | 秘法師杜安 6487，37 | 【需遊戲實測】 | 73–102／2.0 | 魔爆術 #9433 鄰近玩家秘法 192（手冊，DB2 中心同值）。自爆 #9435 可走遠或用柱子卡視線，DB2 基值中心 750。經典魔爆重複 2.5–8.5 秒，自爆約半血一次。永恆實收與節奏【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scarlet-monastery-library/arcanist-doan) · [經典腳本](https://github.com/cmangos/mangos-classic/blob/master/src/game/AI/ScriptDevAI/scripts/eastern_kingdoms/scarlet_monastery/boss_arcanist_doan.cpp) |
| 血色修道院軍械庫 | 赫洛德 3975，40 | 【需遊戲實測】 | 231–307／2.5 | 旋風斬 #8989 → #15578，10 秒內每 2 秒對近身玩家造成一次 100% 武器傷害，護甲可減。經典首輪 14.5 秒、之後 15–25 秒。撤出近戰圈可不吃，永恆重放間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scarlet-monastery-armory/herod-the-scarlet-champion) · [經典腳本](https://github.com/cmangos/mangos-classic/blob/master/src/game/AI/ScriptDevAI/scripts/eastern_kingdoms/scarlet_monastery/boss_herod.cpp) |
| 血色修道院大教堂 | 血色十字軍指揮官莫格萊尼 3976／高等審判官懷特邁恩 3977，皆 42 | 【需遊戲實測】 | 153–203／2.2、116–154／2.0 | 團體睡眠是轉階段的控制。懷特邁恩主要是單體聖光懲擊，莫格萊尼懲罰光環是對攻擊者的反傷。沒有查到固定的全隊傷害，永恆實收和間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scarlet-monastery-cathedral/scarlet-commander-mograine-high-inquisitor-whitemane) |
| 剃刀高地 | 『寒冰使者』亞門納爾 7358，41 | 【需遊戲實測】 | 218–290／2.0 | 冰霜新星 #15531 為 10 碼內冰傷及最長 8 秒定身，70938 效果中心約 702。經典首次 10–15 秒、之後每 15 秒。寒冰箭為單點，冰霜亡魂要另外計，永恆實收與間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/razorfen-downs/amnennar-the-coldbringer) · [永恆法術](https://www.wowhead.com/forever/it/spell=15531/frost-nova) |
| 奧達曼 | 阿札達斯 2748，47 | 【需遊戲實測】 | 277–367／2.6 | 大地震顫 #6524 為 2 秒暈眩，DB2 無傷害效果。5 秒法術冷卻。經典腳本首次 7–14 秒、之後 8–17 秒。喚醒的石像應按額外敵人計，永恆觸發間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/uldaman/archaedas) · [永恆法術](https://nether.wowhead.com/forever/tooltip/spell/6524?locale=10) · [經典腳本](https://github.com/cmangos/mangos-classic/blob/master/src/game/AI/ScriptDevAI/scripts/eastern_kingdoms/uldaman/boss_archaedas.cpp) |
| 祖爾法拉克 | 安圖蘇爾 8127，48 | 【需遊戲實測】 | 319–423／2.0 | 閃電鏈首發自然 109–122，最多 3 目標，每跳衰減 30%。地震術單點 207–219 自然，會斷法。以上為永恆手冊標示值，施放間隔和實收【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/zulfarrak/antusul) |
| 祖爾法拉克 | 加茲瑞拉 7273，46 | 【需遊戲實測】 | 270–358／2.0 | 近身猛擊 #11902 為武器傷害 +50，附擊飛，效果半徑 20 碼。經典首次 27.7–31.2 秒、之後 16.9–28.9 秒。永恆實收和頻率【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/zulfarrak/gahzrilla) · [永恆法術](https://www.wowhead.com/forever/it/spell=11902/gahzrilla-slam) |
| 瑪拉頓 | 瑟萊德絲公主 12201，51 | 【需遊戲實測】 | 86–114／2.0（舊欄 344–444，見上） | 灰塵力場 #21909 每 1 秒觸發 #21868，20 碼內自然傷害並擊退，70938 持續 8 秒、子法術中心 150，永恆實際跳數與實收【需遊戲實測】。經典灰塵力場重複 20–25 秒，投石重複 8–10 秒為單點。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/maraudon/princess-theradras) · [子法術](https://www.wowhead.com/forever/spell=21868/dust-field) |
| 黑石深淵 | 瑪格姆斯 9938，57 | 【需遊戲實測】 | 822–1091／2.4 | 新法術烈焰爆發 #1294482 命中區域半徑 8 碼，永恆頁 694–806 火焰。戰爭踐踏 #24375 為近身武器傷害 +500 並暈 5 秒。房間火焰另算，實收和頻率【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/blackrock-depths/magmus) · [永恆新增法術](https://www.wowhead.com/forever/spell=1294482/fiery-burst) |
| 黑石深淵 | 達格蘭·索瑞森大帝 9019，59 | 【需遊戲實測】 | 738–979／2.0 | 烈焰化身 #15636 持續 10 秒，普攻觸發 #15643 額外單體火焰 200（手冊及 DB2 基值）。索瑞森之手 #17492 為單點火傷暈 5 秒，DB2 效果中心約 1,403。經典手首次 4 秒、之後 5–10 秒，永恆實收及間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/blackrock-depths/emperor-dagran-thaurissan) · [經典腳本](https://github.com/cmangos/mangos-classic/blob/master/src/game/AI/ScriptDevAI/scripts/eastern_kingdoms/blackrock_depths/boss_emperor_dagran_thaurissan.cpp) |
| 斯坦索姆血色區 | 巴納札爾 10813，62 | 【需遊戲實測】 | 903–1197／2.0 | 半血變身後有近身暗影震擊 #17399，70938 效果中心約 1,321。心靈尖嘯可恐懼最多 5 人，這項控制無需計進純傷害。暗影震擊實收、間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/stratholme-live/balnazzar) · [永恆機制及法術連結](https://www.wowhead.com/forever/guide/stratholme-live-side-dungeon-overview-location-rewards) |
| 斯坦索姆亡靈區 | 瑞文戴爾男爵 10440，62 | 【需遊戲實測】 | 602–798／2.0 | 邪惡光環 #17467 → #17466，近身每 2 秒 150 暗影（永恆手冊與 70938 一致），持續到離開範圍或光環消失。順劈斬近身、致死打擊減療 50%／5 秒，實際施放頻率【需遊戲實測】。經典致死首次 12 秒、重複 10–25 秒。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/stratholme-undead/baron-rivendare) · [永恆法術](https://nether.wowhead.com/forever/tooltip/spell/17467?locale=10) |
| 通靈學院 | 血骨傀儡 11622，61 | 【需遊戲實測】 | 690–913／2.0 | 近身戰爭踐踏 #16727 為武器傷害 +50（70938），永恆手冊列 +23，暈 5 秒。經典首次 15.8–21.4 秒、之後 13.1–26.4 秒，永恆實收與間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scholomance/rattlegore) · [永恆法術](https://nether.wowhead.com/forever/tooltip/spell/16727?locale=10) |
| 通靈學院 | 萊斯·霜語 10508，62（QuestieDB，攻略內文另寫 60） | 【需遊戲實測】 | 402–532／2.0 | 連發寒冰箭 #8398 為 20 碼範圍冰傷，永恆手冊列 1,321–1,403，經典 Wowhead 為 226–240，跨版差距大。經典首次 0–10 秒、之後 10–20 秒，永恆實收與間隔【需遊戲實測】。[永恆手冊](https://www.wowhead.com/forever/dungeon-journal/scholomance/ras-frostwhisper) · [永恆 NPC](https://www.wowhead.com/forever/npc=10508/ras-frostwhisper) · [經典法術](https://www.wowhead.com/classic/spell=8398/frostbolt-volley) |

永恆手冊、網站法術提示與 DB2 效果欄可能套用不同等級縮放。上表優先採用同一機制有直接資料佐證的數值，例如男爵光環的每跳 150。首領白字欄等待 1.60.1 戰鬥紀錄，以等級、實際裝備護甲、架勢與格擋可核對的場次驗證。插件情境可分成「坦克持續受擊」「近身週期傷害」「可躲的區域爆發」「單體點名」「階段或小怪」，避免把可躲技能攤到全隊的每秒壓力。[Archon 永恆戰鬥紀錄說明](https://www.archon.gg/wow-forever/articles/news/plans-for-wow-forever-launch)

## 永恆戰鬥紀錄交叉核對

11 月 6 日的諾莫瑞根原始紀錄標頭為 `COMBAT_LOG_VERSION 22 / BUILD_VERSION 1.60.1 / PROJECT_ID 18`，屬正式服。標頭沒有細版號，以下只採作 1.60.1 正式服樣本。10 月護甲測試的原始紀錄來自永恆 Beta，另列對照。普攻取怪物對玩家的物理 `SWING_DAMAGE`，去掉爆擊、碾壓、格擋、抵抗和吸收。原始值取 `baseAmount`，實收取 `amount`。攻擊間隔取同一隻怪（同 GUID）連續普攻事件的間隔眾數（命中與未命中都算），四捨五入至 0.1 秒。間隔會受招架加速、換目標、施法和移動影響。表中區間是紀錄觀測值。各怪的台服名及分類取本機 QuestieDB 永恆版，實測等級取紀錄。[諾莫瑞根原始紀錄及測試情境](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455) · [10 月護甲測試與原始紀錄](https://github.com/magey/forever-warrior/issues/24)

| 樣本 | 怪物（等級、ID） | 分類 | 普攻原始／實收觀測（每下） | 常見間隔 | 有效命中數 |
|---|---|---|---|---|---:|
| 10 月 Beta | 雷首蜥蜴（20，3239） | 野外普通 | 30–38／17–29 | 2.0 秒 | 28 |
| 10 月 Beta | 森林食苔蛛（20，2350） | 野外普通 | 23–38／16–36 | 2.0 秒 | 50 |
| 10 月 Beta | 迪菲亞海賊（20，657） | 副本菁英 | 46–79／24–53 | 2.4 秒 | 48 |
| 10 月 Beta | 高戈羅克（20，11920） | 野外菁英 | 51–66／32–44 | 約 2.0 秒 | 21 |
| 10 月 Beta | 洞穴雪人（30，2248） | 野外普通 | 42–56／32–43 | 2.0 秒 | 24 |
| 10 月 Beta | 尖嘯的遊蕩者（30，4101） | 野外普通 | 25–36／15–31 | 1.3 秒 | 278 |
| 10 月 Beta | 鉗嘴龜（30，2408） | 野外普通 | 44–55／30–37 | 2.0 秒 | 12 |
| 10 月 Beta | 羅卡里姆（30，4499） | 野外菁英 | 51–94／28–73 | 2.0 秒 | 66 |
| 10 月 Beta | 遊蕩的守護古樹（35，12836） | 野外菁英 | 85–109／66–84 | 樣本不足【需遊戲實測】 | 3 |
| 11 月 6 日正式服 | 麻瘋機械師（30，6224） | 副本普通 | 40–67／20–34 | 2.4 秒 | 19 |
| 11 月 6 日正式服 | 麻瘋技師（30，6222） | 副本普通 | 38–63／20–32 | 2.4 秒 | 13 |
| 11 月 6 日正式服 | 麻瘋防衛者（30，6223） | 副本菁英 | 71–109／36–56 | 2.4 秒 | 12 |
| 11 月 6 日正式服 | 動力保安裝甲（30，6230） | 副本菁英 | 93–111／47–55 | 2.0 秒 | 4 |
| 11 月 6 日正式服 | 群體打擊者9-60（32，6229） | 首領 | 131–164／69–86 | 2.0 秒 | 6 |
| 11 月 6 日正式服 | 麥克尼爾·瑟瑪普拉格（34，7800） | 首領 | 147–177／103–124 | 2.0 秒 | 4 |

11 月 6 日表中實收通常是同一名戰士的實收（前五列）。該戰士以盾牌格擋、復仇和嘲諷辨識，常見護甲約 2249–2385，最大生命 1948–2108。瑟瑪普拉格四次合格命中全打在懲戒聖騎士身上，常見護甲 1416、最大生命 2024–2194。這位戰士承受該王另外七次普攻，皆有格擋，傷害為 17–69，最低一次還有吸收。牧師的紀錄樣本最大生命 1013–1040，護甲 1249–1251。這些是同一趟 PvP 規則伺服器隊伍的實際狀態，受裝備與增益影響。進階區塊最後一欄在怪物是等級，在玩家可能是平均裝等，故玩家角色等級留空【需遊戲實測】。10 月樣本的實收混合多名玩家，適合取原始傷害套入同一組護甲比較。[11 月 6 日原始紀錄](https://github.com/user-attachments/files/34515811/WoWCombatLog-110626_154932.zip) · [戰鬥紀錄欄位核對](https://github.com/wowsims/forever/issues/76#reading-the-logs)

| 1.60.1 正式服首領技能樣本 | 原始／實收（每人每次） | 實測目標與時間 |
|---|---|---|
| 群體打擊者9-60・Crowd Pummel | 143–152／56–116 | 3 名玩家各一次，單一施放 |
| 群體打擊者9-60・Trample | 192–199／105–147 | 2 名玩家各一次，單一施放，距上一個不同技能 2.43 秒 |
| 電刑器6000・Megavolt | 165／132 | 1 名玩家，單一施放，有 17 點吸收 |
| 瑟瑪普拉格・Knock Away | 169–209／78–166 | 兩次施放相隔 15.89 秒，第一次打中 1 名，第二次打中 4 名 |

上述範圍技能是單趟樣本。有些只看到一次，重施間隔【需遊戲實測】。WowCoach 另有開放的永恆《領主大廳》實際匿名紀錄，細版號沒有公開。首領 Faldrim 的普攻對該隊聖騎坦 38–40，間隔眾數 2.0 秒，Mind Blast 命中 6 次各 70–75，單點施放間隔約 18–21 秒，另有較長空窗。首領 Plunder 的 Knock Away 兩次相隔 17.11 秒，第一波打中 3 名玩家各 100–106，第二波打中 1 名玩家 74。這兩份紀錄支持按「打到幾人」設定團刷，並按首領技能各自填間隔。[原始紀錄](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455) · [WowCoach 公開範例](https://forever.wowcoach.gg/example/)

護甲公式 `DR=A/(A+400+85×怪物等級)` 另有永恆 Beta 實測。Magey 匯總 8,990 次，理論平均減傷 38.87%、實測 38.82%。同議題另一組 30,124 次取樣中，怪物 14／23／24／26 級的擬合常數約為經典公式的 99.5–100.4%。正式服諾莫瑞根樣本也與護甲造成的約半額傷害相容，精確分離護甲、姿態、增益與怪物減攻需固定條件再測。9 月至 10 月 Beta 與 11 月 6 日正式服樣本無法直接覆蓋 40–60 級副本。Warcraft Logs 永恆站有正式服報告，但本次無法讀取事件明細。ForeverDB 的血色修道院及通靈學院頁可查版本資訊，血色公開的能力與間隔仍標作經典資料。其公開報告列表回傳空陣列，副本統計回傳 0 筆報告、0 次交戰。[永恆 Beta 護甲測試](https://github.com/magey/forever-warrior/issues/24) · [Warcraft Logs Forever](https://forever.warcraftlogs.com/) · [ForeverDB 血色修道院](https://foreverdb.net/dungeon/189-scarlet-monastery) · [ForeverDB 通靈學院](https://foreverdb.net/dungeon/289-scholomance) · [公開報告列表](https://foreverdb.net/api/reports) · [公開副本統計](https://foreverdb.net/api/stats/dungeons)

怪物自己的進階區塊也有最大生命與護甲。20 級雷首蜥蜴 3239、森林食苔蛛 2350、漫遊角斑馬 3466 都是 642 HP／護甲眾數 861，異種幼蠍 3251、深苔結網蛛 4006 則是 629 HP／861。30 級洞穴雪人 2248 為 1366／1212，尖嘯的遊蕩者 4101 為 1304／1212，鉗嘴龜 2408 為 1366／1818，菁英羅卡里姆 4499 為 3726／1212。正式服諾莫瑞根兩隻 30 級普通怪（6222、6224）皆為 1303／1212，兩隻 30 級菁英（6223、6230）皆為 3725／1212。部分護甲讀數因破甲低於眾數。[Beta 戰鬥紀錄](https://github.com/magey/forever-warrior/issues/24) · [正式服戰鬥紀錄](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455)

### 正式服剃刀高地、瑪拉頓補充技能樣本

11 月 7–8 日的抗性研究提供原始傷害行摘錄。表列伺服器的 `ST`（單目標）或 `AOE`（範圍）。這組資料按抗性研究需求挑選，適合核對單跳、目標和週期，無法核對所有施放或每場總傷。[公開原始摘錄](https://gist.github.com/1337LutZ/26257897f20ba4216c53cc1a9a644b21) · [研究與欄位說明](https://github.com/wowsims/forever/issues/76)

| 副本與首領 | 技能（法術 ID） | 觀測 |
|---|---|---|
| 剃刀高地・圖特卡什（7355） | Virulent Poison（12251） | 單目標，同一玩家 17 跳，原始 35→70→105，實收 35–105，約每 3 秒跳一次。重施間隔【需遊戲實測】。 |
| 剃刀高地・暴食者（8567） | Disease Cloud（12626） | 範圍標記，同一玩家 6 次原始 40–45／實收 36–45，觀測事件在約 3 秒的時間格上，部分相隔 6 或 9 秒。場上總目標數與完整觸發間隔【需遊戲實測】。 |
| 剃刀高地・拉戈斯諾特（7354） | Shadow Word: Pain（11639） | 單目標，同一玩家 6 跳，原始 46／實收 41–46，每 3 秒一跳。重施間隔【需遊戲實測】。 |
| 瑪拉頓・諾克賽恩（13282） | Toxic Volley（21687） | 範圍持續，同一戰鬥有 31 個傷害事件，涵蓋 5 名玩家及 1 寵物，原始每跳出現 12／25／38，實收 4–38，同目標約每 3 秒一跳。重施間隔【需遊戲實測】。 |
| 瑪拉頓・被詛咒的塞雷布拉斯（12225） | Entangling Roots（12747） | 單目標，一名玩家有一跳原始及實收皆為 25。間隔【需遊戲實測】。 |

## 戰士坦克與布甲隊員生命

估算用經典 1.12 的職業基礎生命與種族基礎耐力，坦克用獸人戰士，布甲用不死族法師和牧師。70938 `PlayerExpectedStat` 這幾個職業的 `HPPerStamina` 都是 10。採用經典的前 20 耐力每點 1 HP、其後每點 10 HP，`HP = 職業基礎HP + min(耐力,20) + 10×max(耐力−20,0)`。DB2 的共用 `PlayerHealth` 無職業欄，用來看尺度。範圍按裝備耐力上下浮動 30%，布甲範圍同時包住兩個樣本職業。耐力是場景假設，沒有加命令怒吼、真言術：韌、王者祝福、藥劑或世界增益。[經典職業生命與種族屬性表](https://github.com/cmangos/mangos-classic/blob/master/sql/base/mangos.sql) · [經典耐力結算](https://github.com/cmangos/mangos-classic/blob/master/src/game/Entities/StatSystem.cpp) · [70938 PlayerExpectedStat](https://wago.tools/db2/PlayerExpectedStat/csv?build=1.60.1.70938)

| L | 戰士基礎 HP／裸耐 | 戰士裝備耐力 | 戰士總 HP 中心（範圍） | 布甲裸基礎 HP／耐力（法師／牧師） | 布甲裝備耐力 | 布甲總 HP 中心（範圍） | 戰士護甲（減傷） |
|---:|---|---:|---|---|---:|---|---|
| 20 | 199／45 | +24 | 709（639–779） | 247／27、237／28 | +8 | 417（397–437） | 1550（42.5%） |
| 30 | 374／59 | +42 | 1204（1074–1334） | 385／31、382／33 | +16 | 675–692（625–742） | 1950（39.8%） |
| 35 | 499／66 | +58 | 1559（1389–1729） | 490／33、497／35 | +22 | 860–887（790–957） | 2100（38.4%） |
| 40 | 649／74 | +72 | 1929（1709–2149） | 620／35、627／38 | +28 | 1070–1107（990–1187） | 3000（44.1%） |
| 45 | 839／83 | +90 | 2389（2119–2659） | 765／38、782／41 | +36 | 1325–1372（1215–1482） | 4000（48.6%） |
| 50 | 1079／92 | +110 | 2919（2589–3249） | 945／40、962／44 | +46 | 1625–1682（1485–1822） | 4700（50.3%） |
| 55 | 1359／102 | +135 | 3549（3149–3949） | 1140／43、1167／47 | +58 | 1970–2037（1800–2207） | 5150（50.4%） |
| 60 | 1689／112 | +165 | 4279（3779–4779） | 1360／46、1387／51 | +75 | 2390–2467（2170–2687） | 5550（50.2%） |

護甲假設為角色等級 +2 的裝等，綠裝混少量藍裝，盾牌用同裝等綠裝值，護甲加少量敏捷。20–35 鎖甲，40 約半套鎖甲／半套鎧甲，45 約四分之三鎧甲，50 起按鎧甲。計算用 70938 的整套護甲量，披風按 8% 布甲值，其餘 92% 用主護甲類型，品質混合倍率 1.025，再加盾與 `2×(基礎敏捷+5)` 並取到 50。永恆 Beta 的 20 級戰士有裸體 439 HP／72 護甲、穿裝 659 HP／980 護甲的實例。正式服諾莫瑞根樣本的戰士最高生命約 1,948–2,108、牧師約 1,013–1,040，角色等級及增益未完整控制。這些紀錄反映裝備和增益差異，高等角色預設仍【需遊戲實測】。[70938 裝甲量](https://wago.tools/db2/ItemArmorTotal/csv?build=1.60.1.70938) · [護甲位置比例](https://wago.tools/db2/ArmorLocation/csv?build=1.60.1.70938) · [盾牌護甲](https://wago.tools/db2/ItemArmorShield/csv?build=1.60.1.70938) · [永恆 Beta 裝備對照](https://github.com/magey/forever-warrior/issues/3#rage-from-damage-taken) · [正式服諾莫瑞根樣本](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455)

## 聖騎單練

情境為同級普通近戰怪、懲戒聖騎拿 3.5 秒雙手武器、未帶盾。只算一隻怪的物理普攻，持續吃全程白字。攻方原始 DPS 取 `ExpectedStat`，套聖騎護甲得實收 DPS，取兩倍就是 2 秒等效傷害。擊殺時間按同級怪 HP 除以聖騎有效 DPS，排除走路、喝水、切目標和怪物逃跑。官方曾以一般單練普通怪約 10–15 秒描述戰鬥節奏，上市前又公告上調高等怪生命。未找到涵蓋八個等級且能核對裝備、起迄點的聖騎單練紀錄。下表為可重算的情境估算，【需遊戲實測】。[暴雪戰鬥節奏](https://news.blizzard.com/en-gb/article/24303313/recapitulatif-de-la-presentation-au-cur-de-world-of-warcraft-forever) · [上市前職業與怪物調整](https://us.forums.blizzard.com/en/wow/t/major-class-final-tuning/2399448/1) · [永恆懲戒練級](https://www.wowhead.com/forever/guide/classes/paladin/retribution/dps-leveling-tips)

| L | 普通怪 HP（場景輸入） | 聖騎護甲 | 怪物原傷 DPS | 聖騎實收 DPS | 聖騎輸出 DPS | 估算擊殺秒數（敏感度範圍） |
|---:|---:|---:|---:|---:|---:|---|
| 20 | 636 | 1000 | 17.1 | 11.6 | 40.7 | 16（12–22） |
| 30 | 1335 | 1200 | 24.7 | 17.6 | 60.2 | 22（17–32） |
| 35 | 1586 | 1300 | 28.3 | 20.4 | 70.0 | 23（17–33） |
| 40 | 1981 | 1650 | 32.6 | 22.7 | 81.8 | 24（18–35） |
| 45 | 2402 | 2300 | 44.0 | 28.5 | 90.7 | 26（20–38） |
| 50 | 2909 | 2800 | 49.2 | 30.7 | 102.8 | 28（21–41） |
| 55 | 3602 | 3050 | 54.7 | 34.2 | 115.2 | 31（23–45） |
| 60 | 4365 | 3300 | 60.5 | 37.8 | 134.4 | 32（24–47） |

聖騎護甲約為戰士不含盾護甲的 90%，並代入聖騎敏捷。20／30 級 HP 用 Beta 普通怪觀測的低高值中點，35–60 採 70938 基準。輸出用角色等級 +4 的綠、藍雙手武器 DPS 中點。攻強用經典聖騎 `3L−20+2×力量` 加當級力量祝福，力量取經典人類聖騎成長作代理並加裝備力量 8／18／24／34／44／55／68／84。白字取武器加攻強 DPS，乘對怪護甲減傷後再乘 0.9。審判、神聖打擊按每 10 秒，分別乘命中假設 0.95 和 0.9。命令聖印採經典每分鐘 7 次的假設，按 70% 武器傷害並乘 0.9。70938 的觸發欄沒有對應 PPM，精確機率【需遊戲實測】。懲戒光環按怪 2 秒一擊和 90% 命中。敏感度用怪 HP 90–115%、聖騎 DPS 80–120% 的兩端，能涵蓋普通換裝、施法、命令聖印運氣及野怪差異的一部分。光環、先手、控場、驅魔和處決會改變單場結果。[70938 武器 DPS](https://wago.tools/db2/ItemDamageTwoHand/csv?build=1.60.1.70938) · [力量祝福](https://nether.wowhead.com/forever/tooltip/spell/25291?locale=10) · [神聖打擊](https://nether.wowhead.com/forever/tooltip/spell/10333?locale=10) · [審判](https://nether.wowhead.com/forever/tooltip/spell/20271?locale=10) · [命令聖印](https://nether.wowhead.com/forever/tooltip/spell/20920?locale=10) · [70938 觸發欄](https://wago.tools/db2/SpellAuraOptions/csv?build=1.60.1.70938)

## 舊公式差異與待實測

- **血量偏高。**舊戰士公式比表列一般裝中心高約 50–77%，舊布甲公式高約 66–102%。60 級舊值約 6,420／4,020，本報告一般裝中心約 4,280／2,430。高耐配裝、隊伍增益和世界增益可能拉近差距。
- **單練普攻偏高。**舊 2.2L 每兩秒給出 22–66 實收 DPS。懲戒場景模型約 12–38，舊值約為 1.7–1.9 倍。單練 30 秒固定戰鬥長度對 20–40 級多半偏長，55–60 級接近這組情境。
- **菁英低中等級偏高，高等硬怪可能偏低。**30 級舊 135／2 秒，正式服諾莫瑞根樣本和校正值約每 2 秒 50；55 級舊 248 對經典高等對照約 190，60 級舊 270 對高傷樣本約 300，實際倍率【需遊戲實測】。
- **首領白字低中等級偏高，高等要看王。**30／35 級舊值 210／245，對照預設 80／90。55 級瑪格姆斯等較重的王會接近舊式，技能疊到普攻時可能更高。高等正式服白字與揮擊間隔【需遊戲實測】。
- **團刷通常把持續壓力與點名排得太密。**舊點名每 5 秒一次，改成每 15 秒，且以技能覆蓋。60 級舊範圍 108／2 秒全員，每秒合計 270；建議壓力場景 140／3 秒、2 人，每秒合計約 93。真的覆蓋全隊、無法躲避的技能另按戰鬥紀錄設定。正式服高等副本需要完整的技能時間軸與首領白字。【需遊戲實測】[正式服 Gnomeregan 原始紀錄](https://github.com/ClassicWoWCommunity/forever-bugs/issues/455) · [正式服剃刀高地／瑪拉頓資料索引](https://github.com/wowsims/forever/issues/76)

後續能用進階戰鬥紀錄補表時，每個怪種記同級下至少 30 次同 GUID 的普攻事件，分開原始 `baseAmount` 與實收 `amount`，保留 `SWING_MISSED` 用來估攻速。記坦克護甲、姿態、盾牌、格擋與減攻速。技能計時以同一招的施放成功時間間隔為主，另外記每跳、受擊人數及階段。聖騎可記 10 隻同級同種野怪，從首次攻擊到擊殺，並附武器、天賦與護甲，報中位數及範圍。[Warcraft Logs 永恆上傳說明](https://www.archon.gg/wow-forever/articles/help/how-to-upload-logs-for-wow-forever-on-warcraft-logs) · [原始紀錄欄位](https://github.com/wowsims/forever/issues/76#reading-the-logs)
