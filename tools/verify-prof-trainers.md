# 永恆 1.60.1 部落專業訓練師

查核版本為 **1.60.1.70938**。插件欄位沿用「專家 225／大師 300」，台服遊戲文字對應「高級（Expert）／專家級（Artisan）」。座標用 `uiMapID x, y`，0–100 比例。費用是基礎價，實付可能有折扣。[暴雪台服專業階級](https://worldofwarcraft.blizzard.com/zh-tw/news/24301516) · [永恆版專業總覽](https://www.wowhead.com/forever/tw/guide/professions/overview) · [ForeverChanges 70938](https://foreverchanges.pro/professions)

NPC 名稱優先用 Wowhead 永恆版 zhTW，座標以本機 QuestieDB Forever 為主。DB2 的法術效果與物品可核對技能階段和書本要求，訓練師實際開放的項目、費用和門檻另比對永恆版專業資料。遊戲資料和攻略有落差的點列在後面。[技能資料](https://wago.tools/db2/SkillLine?build=1.60.1.70938) · [法術效果](https://wago.tools/db2/SpellEffect?build=1.60.1.70938) · [地圖資料](https://wago.tools/db2/UiMap?build=1.60.1.70938) · [QuestieDB](https://github.com/Questie/QuestieDB)

## ShengProfession 精簡表

| 專業 | 階段（專家/大師） | 條件 | 部落訓練師（名稱、地圖ID、x、y） | 備註 |
|---|---|---|---|---|
| 鍊金術 | 專家 | 角色 20 級，技能 125，50 銀 | 赫伯特·哈爾希醫生（1458 47.77, 73.34） | 幽暗城煉金房 |
| 鍊金術 | 大師 | 角色 35 級，技能 200，5 金 | 羅格瓦爾（1435 48.53, 55.85）／Master Mycologist Shurome（1448 51.41, 82.01） | 斯通納德／翡翠聖地，中立新點台服名【需遊戲實測】 |
| 鍛造 | 專家 | 角色 20 級，技能 125，50 銀 | 薩魯·鋼怒（1454 82.35, 22.97） | 奧格瑪榮譽谷 |
| 鍛造 | 大師 | 角色 35 級，技能 200，5 金 | 布里克·基克拉夫（1434 28.99, 75.56） | 藏寶海灣 |
| 附魔 | 專家 | 角色 20 級，技能 125，50 銀 | 赫加斯（1442 49.18, 57.18） | 烈日石居東北坡 |
| 附魔 | 大師 | 角色 35 級，技能 200，5 金 | 安諾拉（奧達曼副本，座標 ?） | 清掉蠍群才現身，副本地圖定位【需遊戲實測】 |
| 工程學 | 專家 | 角色 20 級，技能 125，50 銀 | 羅克希克（1454 76.17, 25.17） | 奧格瑪榮譽谷 |
| 工程學 | 大師 | 角色 35 級，技能 200，5 金 | 巴茲克·布拉斯溫（1446 52.34, 27.72） | 加基森旅店外，海加爾山候選見下 |
| 草藥學 | 專家 | 技能 125，50 銀，無已知角色等級門檻 | 加迪（1454 55.62, 39.46）／馬爾薩·奧列斯塔（1458 54.00, 49.55）／克米恩·冰蹄（1456 49.95, 40.41） | 三主城，其他點見下 |
| 草藥學 | 大師 | 技能 200，5 金，無已知角色等級門檻 | 加迪（1454 55.62, 39.46）／馬爾薩·奧列斯塔（1458 54.00, 49.55）／克米恩·冰蹄（1456 49.95, 40.41） | 可找同一位 |
| 製皮 | 專家 | 角色 20 級，技能 125，50 銀 | 猶納（1456 41.50, 42.57） | 雷霆崖 |
| 製皮 | 大師 | 角色 35 級，技能 200，5 金 | 哈拉納·鐵皮（1444 74.36, 43.12） | 莫沙徹營地直接學 |
| 採礦 | 專家 | 技能 125，50 銀，無已知角色等級門檻 | 馬卡魯（1454 73.12, 26.08）／布羅姆·基里安（1458 56.03, 37.45）／布瑞克·石蹄（1456 34.37, 57.90） | 三主城，其他點見下 |
| 採礦 | 大師 | 技能 200，5 金，無已知角色等級門檻 | 馬卡魯（1454 73.12, 26.08）／布羅姆·基里安（1458 56.03, 37.45）／布瑞克·石蹄（1456 34.37, 57.90） | 可找同一位 |
| 剝皮 | 專家 | 技能 125，50 銀，無已知角色等級門檻 | 蘇爾德（1454 63.36, 45.42）／基里安·哈根（1458 70.16, 59.18）／莫蘭塔（1456 44.44, 43.15） | 三主城，其他點見下 |
| 剝皮 | 大師 | 技能 200，5 金，無已知角色等級門檻 | 蘇爾德（1454 63.36, 45.42）／基里安·哈根（1458 70.16, 59.18）／莫蘭塔（1456 44.44, 43.15） | 可找同一位 |
| 裁縫 | 專家 | 角色 20 級，技能 125，50 銀 | 喬瑟夫·格里高利（1458 70.76, 30.69） | 幽暗城魔法區 |
| 裁縫 | 大師 | 角色 35 級，技能 200，5 金 | 達瑞爾·斯塔克（1424 63.75, 20.79） | 塔倫米爾教堂 |
| 烹飪 | 專家 | 技能 125，1 金，書無等級欄 | 烏蘭（1443 26.17, 69.65） | 葬影村買書 16072，20 級以下使用【需遊戲實測】 |
| 烹飪 | 大師 | 角色 35 級，技能 225，0 金 | 迪爾格·奎克里弗（1446 52.63, 28.11） | 加基森任務 6610 |
| 急救 | 專家 | 技能 125，1 金，書無等級欄 | 巴萊·洛克維（1445 36.49, 30.36） | 蕨牆村買書 16084，20 級以下使用【需遊戲實測】 |
| 急救 | 大師 | 角色 35 級，技能 225，0 金 | 格里高利·維克托醫生（1417 73.41, 36.89） | 落錘鎮任務 6622 |
| 釣魚 | 專家 | 角色 20 級，技能 125，1 金 | 老人海明威（1434 27.42, 77.16） | 藏寶海灣買書 16083 |
| 釣魚 | 大師 | 角色 35 級，技能 225，0 金 | 納特·帕格（1445 58.61, 60.06） | 狂潮灣小島任務 6607 |

珠寶設計未開放。暴雪列出九個主專業、三個副專業，70938 的 `SkillLine` 也沒有珠寶設計技能 ID 755，插件無須新增兩階或訓練師。[暴雪專業說明](https://news.blizzard.com/en-us/article/24301516/gather-around-the-campfire-in-world-of-warcraft-forever) · [70938 SkillLine](https://wago.tools/db2/SkillLine?build=1.60.1.70938)

## 六個製作主專業

專家為角色 20 級、技能 125、50 銀。大師為角色 35 級、技能 200、5 金，技能上限 300。六個專業都可直接向對應訓練師學階，附魔要先讓安諾拉現身。現地紀錄的製皮費用為專家 47 銀 50 銅、大師 4 金 75 銀，對應 5% 折扣，表內用基礎價。Wowhead 工程等部分指南把升大師門檻列為 225，工程專業法術列表標 200，專項路線也列角色 35 級、技能 200。一般可在 200 就順路去學。[永恆版工程法術列表](https://www.wowhead.com/forever/spell=4037/engineering) · [工程學練級指南](https://www.wow-professions.com/forever/engineering-leveling-guide) · [永恆專業法術資料](https://www.wowhead.com/forever/spells/professions/min-skill-level:150/max-skill-level:225) · [製皮專家訓練紀錄](https://www.wow-professions.com/forever/npc/una) · [製皮大師訓練紀錄](https://www.wow-professions.com/forever/npc/hahrana-ironhide)

| 專業 | 階段 | NPC（ID） | 城市／區域 | 地圖 ID 與座標 | 來源 |
|---|---|---|---|---|---|
| 鍊金術 | 專家 | 赫伯特·哈爾希醫生（4611） | 幽暗城・煉金房 | 1458 47.77, 73.34 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4611?locale=10) · [永恆訓練表](https://www.wowhead.com/forever/tw/guide/professions/alchemy-overview-trainer-locations-recipes) |
| 鍊金術 | 大師 | 羅格瓦爾（1386） | 悲傷沼澤・斯通納德 | 1435 48.53, 55.85 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1386?locale=10) · [升階條件](https://www.wow-professions.com/forever/alchemy-leveling-guide) |
| 鍊金術 | 大師 | Master Mycologist Shurome（259585） | 費伍德森林・翡翠聖地（中立） | 1448 51.41, 82.01 | 永恆新點，台服名【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/259585?locale=10) · [永恆訓練表](https://www.wowhead.com/forever/tw/guide/professions/alchemy-overview-trainer-locations-recipes) |
| 鍛造 | 專家 | 薩魯·鋼怒（3355） | 奧格瑪・榮譽谷 | 1454 82.35, 22.97 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3355?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/blacksmithing-trainers) |
| 鍛造 | 大師 | 布里克·基克拉夫（2836） | 荊棘谷・藏寶海灣（中立） | 1434 28.99, 75.56 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/2836?locale=10) · [升階條件](https://www.wow-professions.com/forever/blacksmithing-leveling-guide) |
| 附魔 | 專家 | 赫加斯（11074） | 石爪山脈・烈日石居東北側小徑 | 1442 49.18, 57.18 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/11074?locale=10) · [永恆訓練表](https://www.wowhead.com/forever/tw/guide/professions/enchanting/overview) |
| 附魔 | 大師 | 安諾拉（11073） | 荒蕪之地・奧達曼副本（中立） | 副本 ID 70，`uiMapID`／座標 ?【需遊戲實測】 | 在地圖室與神殿大廳之間的洞穴，清掉周圍蠍群才現身。QuestieDB 對副本的相容映射是 230，70938 的 UiMap 沒有這筆，插件可先顯示副本與動線。[NPC](https://www.wowhead.com/forever/npc=11073/annora) · [永恆動線與門檻](https://www.wowhead.com/forever/tw/guide/uldaman-dungeon-overview-location-rewards) · [副本 Map 資料](https://wago.tools/db2/Map?build=1.60.1.70938) |
| 工程學 | 專家 | 羅克希克（11017） | 奧格瑪・榮譽谷 | 1454 76.17, 25.17 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/11017?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/engineering-trainers) |
| 工程學 | 大師 | 巴茲克·布拉斯溫（8736） | 塔納利斯・加基森（中立） | 1446 52.34, 27.72 | 旅店外信箱附近。[NPC](https://nether.wowhead.com/forever/tooltip/npc/8736?locale=10) · [現地訓練選單](https://www.wow-professions.com/forever/npc/buzzek-bracketswing) |
| 製皮 | 專家 | 猶納（3007） | 雷霆崖・中央高地 | 1456 41.50, 42.57 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3007?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/leatherworking-trainers) |
| 製皮 | 大師 | 哈拉納·鐵皮（11098） | 菲拉斯・莫沙徹營地 | 1444 74.36, 43.12 | 直接訓練，三種專精可另選。[NPC](https://nether.wowhead.com/forever/tooltip/npc/11098?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/leatherworking-trainers) |
| 裁縫 | 專家 | 喬瑟夫·格里高利（4576） | 幽暗城・魔法區 | 1458 70.76, 30.69 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4576?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/tailoring-trainers) |
| 裁縫 | 大師 | 達瑞爾·斯塔克（2399） | 希爾斯布萊德丘陵・塔倫米爾教堂 | 1424 63.75, 20.79 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/2399?locale=10) · [永恆訓練表](https://www.wow-professions.com/forever/tailoring-trainers) |

### 候選訓練師

- 工程學專家，弗蘭克林·洛伊德（11031），幽暗城盜賊區 `1458 76.12, 74.03`。Wowhead 永恆指南列可教專家，現地訓練師指南列只教到 150。到場看 225 上限的訓練項目是否出現【需遊戲實測】。[Wowhead 永恆工程表](https://www.wowhead.com/forever/tw/guide/professions/engineering-overview-trainer-locations-recipes) · [現地訓練師頁](https://www.wow-professions.com/forever/npc/franklin-lloyd)
- 工程學大師，Kaylaena Springwhisper（249235），海加爾山 `2482 60.10, 61.18`。兩份永恆指南列為大師，NPC 為塞納里奧議會，本機有點位。台服名和部落正式服訓練選單【需遊戲實測】。[NPC](https://www.wowhead.com/forever/npc=249235/kaylaena-springwhisper) · [Wowhead 永恆工程表](https://www.wowhead.com/forever/tw/guide/professions/engineering-overview-trainer-locations-recipes) · [工程指南](https://mobalytics.gg/wow-forever/profile/crix/guides/engineering-guide-for-wow-forever)
- 裁縫大師，梅羅什（11557），費伍德森林木喉要塞 `1448 65.69, 2.81`。有經典沿用資料列為大師，永恆的現地資料確認他販賣聲望圖樣。300 訓練選單及其聲望門檻【需遊戲實測】。[永恆 NPC 頁](https://www.wow-professions.com/forever/npc/meilosh) · [經典沿用條目](https://forever-tavern.com/professions/tailoring/)

## 三個採集主專業

草藥學、採礦、剝皮專家均為技能 125／50 銀，大師均為技能 200／5 金。永恆訓練表的角色等級欄三者皆空，剝皮有正式服 1.60.1.70790 訓練紀錄。草藥與採礦可用同樣的無等級門檻設定，極低等角色在台服 70938 的伺服器判定【需遊戲實測】。起始地的初級訓練師有些只教到 75，下表列的是可教兩階的主城與順路據點。[草藥訓練表](https://www.wow-professions.com/forever/herbalism-trainers) · [採礦訓練表](https://www.wow-professions.com/forever/mining-trainers) · [剝皮訓練表](https://www.wow-professions.com/forever/skinning-trainers) · [正式服訓練紀錄](https://hearthproof.com/ledger/)

| 專業 | NPC（ID） | 城市／區域 | 地圖 ID 與座標 | 來源 |
|---|---|---|---|---|
| 草藥學 | 加迪（3404） | 奧格瑪・暗巷區 | 1454 55.62, 39.46 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3404?locale=10) |
| 草藥學 | 馬爾薩·奧列斯塔（4614） | 幽暗城・煉金房 | 1458 54.00, 49.55 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4614?locale=10) · [現地訓練選單](https://www.wow-professions.com/forever/npc/martha-alliestar) |
| 草藥學 | 克米恩·冰蹄（3013） | 雷霆崖・中央高地 | 1456 49.95, 40.41 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3013?locale=10) |
| 草藥學 | 法魯薩（2114） | 提里斯法林地・布瑞爾 | 1420 59.79, 52.12 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/2114?locale=10) |
| 草藥學 | 米什基（3185） | 杜洛塔・森金村 | 1411 55.44, 75.08 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3185?locale=10) |
| 草藥學 | 哈菈莎‧蕨風（257021） | 微風島・申德村 | 2521 42.96, 43.54 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/257021?locale=10) |
| 草藥學 | 賽瑞兒‧夜雨（254345） | 微風島・瓦拉納爾 | 2521 57.90, 75.48 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/254345?locale=10) |
| 採礦 | 馬卡魯（3357） | 奧格瑪・榮譽谷 | 1454 73.12, 26.08 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3357?locale=10) |
| 採礦 | 布羅姆·基里安（4598） | 幽暗城・軍事區 | 1458 56.03, 37.45 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4598?locale=10) |
| 採礦 | 布瑞克·石蹄（3001） | 雷霆崖・中央高地下層 | 1456 34.37, 57.90 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3001?locale=10) |
| 採礦 | 克魯恩（3175） | 杜洛塔・剃刀嶺 | 1411 51.81, 40.88 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3175?locale=10) |
| 採礦 | 喬漢·弗徹（3555） | 銀松森林・瑟伯切爾 | 1421 43.41, 40.45 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/3555?locale=10) |
| 採礦 | 梅莎娜‧冠風（257022） | 微風島・申德村 | 2521 44.77, 44.56 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/257022?locale=10) |
| 採礦 | 哈拉弗爾‧峭風（252388） | 微風島・瓦拉納爾 | 2521 65.44, 80.47 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/252388?locale=10) |
| 採礦 | 格朗格（255891） | 大河林地・火線港（中立） | 2548 77.70, 51.93 | 永恆新點，有多個刷新點，名稱取 QuestieDB zhTW。[永恆訓練表](https://www.wowhead.com/forever/tw/guide/professions/mining/overview-leveling) · [港口點位](https://www.wow-professions.com/forever/mining-trainers) |
| 剝皮 | 蘇爾德（7088） | 奧格瑪・暗巷區 | 1454 63.36, 45.42 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/7088?locale=10) |
| 剝皮 | 基里安·哈根（7087） | 幽暗城・盜賊區 | 1458 70.16, 59.18 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/7087?locale=10) |
| 剝皮 | 莫蘭塔（7089） | 雷霆崖・中央高地 | 1456 44.44, 43.15 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/7089?locale=10) |
| 剝皮 | 姚恩·深刺（6290） | 莫高雷・血蹄村 | 1412 44.97, 61.40 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/6290?locale=10) |
| 剝皮 | 馬魯克斯（12030） | 淒涼之地・葬影村 | 1443 23.24, 69.72 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/12030?locale=10) |
| 剝皮 | 庫雷格·石角（8144） | 菲拉斯・莫沙徹營地 | 1444 74.47, 43.04 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/8144?locale=10) |
| 剝皮 | 曼達拉斯‧破癒（257024） | 微風島・申德村 | 2521 43.29, 43.37 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/257024?locale=10) |
| 剝皮 | 艾希莉‧風語（257003） | 微風島・瓦拉納爾 | 2521 59.63, 76.06 | 永恆新點。[NPC](https://nether.wowhead.com/forever/tooltip/npc/257003?locale=10) |

微風島採集訓練師可教到 300，部落可從雷霆崖北方搭飛船到瓦拉納爾。永恆新增的出生地採集教材用來入門，專家與大師仍找表中的全階訓練師。[永恆版微風島訓練與交通](https://www.wowhead.com/forever/guide/zephras-isle-zone-overview-maps-locations-and-trainers-34862) · [永恆專業變動](https://www.wowhead.com/ptr/news/changes-and-additions-to-professions-in-world-of-warcraft-forever-382924)

## 烹飪、急救、釣魚

三個副專業的專家階段都用技能書。1.60.1.70938 的三本書 `BuyPrice=10000`（1 金基礎價），實際商人價格依角色折扣。烹飪、急救書的 `RequiredLevel=0`，技能需 125，書面無角色等級門檻。釣魚書明列角色 20 級、釣魚 125。Wowhead 通用總覽把專家概列 20 級，烹飪和急救以各書的 DB2、提示及對應施法資料為準。若要驗證 20 級以下使用能否通過伺服器檢查，標【需遊戲實測】。三個副專業的大師階段皆是角色 35 級與技能 225，透過任務免費解鎖 300。主城引導任務均可選。NPC 位置以 QuestieDB Forever 刷新點為準，地圖 ID 用 `uiMapID`。[DB2 物品資料](https://wago.tools/db2/ItemSparse?build=1.60.1.70938) · [物品與法術對照](https://wago.tools/db2/ItemXItemEffect?build=1.60.1.70938) · [法術等級資料](https://wago.tools/db2/SpellLevels?build=1.60.1.70938) · [DB2 地圖](https://wago.tools/db2/UiMap?build=1.60.1.70938) · [DB2 子區域](https://wago.tools/db2/AreaTable?build=1.60.1.70938)

| 專業 | 階段 | 條件 | 部落可用 NPC／地圖 ID 座標 | 方式與費用 |
|---|---|---|---|---|
| 烹飪 | 專家 225 | 烹飪 125，書無角色等級欄 | 烏蘭 Wulan #12033，淒涼之地 葬影村 `1443 26.17, 69.65` | 購買高級烹飪教材 #16072，1 金。[物品](https://www.wowhead.com/forever/tw/item=16072) · [Forever 路線](https://www.wowhead.com/forever/guide/professions/cooking/overview-leveling) |
| 烹飪 | 大師 300 | 角色 35 級，烹飪 225 | 迪爾格·奎克里弗 Dirge Quikcleave #8125，塔納利斯 加基森 `1446 52.63, 28.11` | 直接接交蚌肉大餐 Clamlette Surprise #6610，巨蛋 #12207 ×12、美味的蚌肉 #7974 ×10、奧特蘭克冷酪 #8932 ×20。材料可先備，無學階費。奧格瑪札姆沙 Zamja #3399 `1454 57.40, 53.96` 可先接加基森之旅！ #6611。[任務](https://www.wowhead.com/forever/tw/quest=6610) · [台服 NPC 名](https://nether.wowhead.com/forever/tooltip/npc/8125?locale=10) · [引導](https://www.wowhead.com/forever/tw/quest=6611) |
| 急救 | 專家 225 | 急救 125，書無角色等級欄 | 巴萊·洛克維 Balai Lok'Wein #13476，塵泥沼澤 蕨牆村 `1445 36.49, 30.36` | 購買高級急救教材 - 繃帶縛體 #16084，1 金。可同趟買厚絲質繃帶、魔紋繃帶手冊。[物品](https://www.wowhead.com/forever/tw/item=16084) · [Forever 路線](https://www.wowhead.com/forever/guide/professions/first-aid/overview) |
| 急救 | 大師 300 | 角色 35 級，急救 225 | 格里高利·維克托醫生 Doctor Gregory Victor #12920，阿拉希高地 落錘鎮 `1417 73.41, 36.89` | 直接接交救死扶傷 Triage #6622，用提供的急救繃帶 #16991，在第 6 名傷兵死亡前救滿 15 名，優先致命傷、重傷、普通傷。無學階費。奧格瑪阿諾克 Arnok #3373 `1454 34.18, 84.58` 可先接部落醫療隊 #6623。[任務](https://www.wowhead.com/forever/tw/quest=6622) · [引導](https://www.wowhead.com/forever/tw/quest=6623) · [ForeverChanges](https://foreverchanges.pro/professions/first-aid) |
| 釣魚 | 專家 225 | 角色 20 級，釣魚 125 | 老人海明威 Old Man Heming #2626，荊棘谷 藏寶海灣 `1434 27.42, 77.16` | 購買高級釣魚教材 - 鱸魚與你 #16083，1 金。[物品](https://www.wowhead.com/forever/tw/item=16083) · [Forever 路線](https://www.wowhead.com/forever/guide/professions/fishing/overview-leveling) |
| 釣魚 | 大師 300 | 角色 35 級，釣魚 225 | 納特·帕格 Nat Pagle #12919，塵泥沼澤 狂潮灣小島 `1445 58.61, 60.06` | 直接接交釣魚專家納特·帕格 Nat Pagle, Angler Extreme #6607，接取後四處各釣一尾，無學階費。奧格瑪魯瑪克 Lumak #3332 `1454 69.80, 29.21` 可先接你真棒！ #6608。[任務](https://www.wowhead.com/forever/tw/quest=6607) · [引導](https://www.wowhead.com/forever/tw/quest=6608) · [ForeverChanges](https://foreverchanges.pro/professions/fishing) |

釣魚任務地點（QuestieDB `Object` 400006–400009）：菲拉斯 沃丹提斯河 `1444 63.50, 53.60` 釣菲拉斯草魚 #16967，悲傷沼澤 蘆葦海灘 `1435 90.70, 72.10` 釣蘆葦海岸大馬哈魚 #16970，淒涼之地 薩瑟里斯海岸 `1443 25.80, 77.40` 釣薩瑟里斯虎魚 #16968，荊棘谷 野人海岸 `1434 33.00, 32.10` 釣野人海岸藍色叉牙魚 #16969。一般水域拋竿，帶魚餌提升有效技能。[Forever 路線與釣點圖](https://www.wowhead.com/forever/guide/professions/fishing/overview-leveling)

永恆保留三個副專業的四階與經典版解鎖途徑。烹飪加入營火及營火物件、急救新增營地急救箱和多種由急救製作的治療藥水、釣魚新增魚缸與漁架。11 月 11 日官方熱修把熟練營火套件放置要求從烹飪 140 改為 90，並修復漁架部分魚餌問題。[暴雪專業與營地說明](https://news.blizzard.com/en-us/article/24301516/gather-around-the-campfire-in-world-of-warcraft-forever) · [11 月 11 日熱修](https://news.blizzard.com/en-us/article/24315281/wow-forever-hotfixes-november-11-2026) · [ForeverChanges 70938 專業](https://foreverchanges.pro/professions)

## 專精與永恆版變動

- **鍛造專精**，角色 40 級、鍛造 200。奧格瑪榮譽谷找奧克索斯·鐵怒（11177，`1454 79.80, 24.06`）接「護甲鍛造師的藝術」5301，或找伯古西（11178，`1454 79.41, 23.74`）接「武器鑄造師之道」5302。兩條互斥。此處是專精，升 300 找布里克。[5301](https://nether.wowhead.com/forever/tooltip/quest/5301?locale=10) · [5302](https://nether.wowhead.com/forever/tooltip/quest/5302?locale=10) · [永恆專精資料](https://www.wowhead.com/forever/tw/guide/professions/blacksmithing/overview)
- **製皮專精**，角色 40 級、製皮 225。龍鱗製皮 5145 找荒蕪之地索卡夫·龍眼（7867，`1418 62.70, 57.40`），元素製皮 5146 找阿拉希高地布魯姆·冰蹄（7869，`1417 28.27, 45.09`），部族製皮 5148 找荊棘谷瑟伊布（7871，`1434 36.55, 34.09`）。部族分支先到菲拉斯莫沙徹營地找杉多爾·迅蹄（7854，`1444 74.43, 42.91`），角色 30 級、製皮 200 時可接 2854「蠻皮護甲」。製皮 225 後做 2855／2856／2857，再做 2858／2859，最後交 2860「蠻皮護甲大師」。此處是專精，升 300 找哈拉納。[5145](https://nether.wowhead.com/forever/tooltip/quest/5145?locale=10) · [5146](https://nether.wowhead.com/forever/tooltip/quest/5146?locale=10) · [5148](https://nether.wowhead.com/forever/tooltip/quest/5148?locale=10) · [永恆專精路線](https://questing.wiki/wow-forever/professions/specializations/)
- **工程學專精**，角色 30 級、工程 200。可從幽暗城格拉哈姆·範·塔倫（4586，`1458 75.34, 73.13`）或貧瘠之地棘齒城廷克維斯（3494，`1413 62.67, 36.31`）接引導。哥布林分支 3526／3633 到加基森尼克斯·斯普克斯賓（8126，`1446 52.48, 27.33`）接 3638「保密協議」→ 3639「工作成果」。地精分支（Gnomish）3635／3637 到藏寶海灣奧格索普·奧布諾提斯（7406，`1434 28.36, 76.35`）接 3642「保密協議」→ 3643「工作成果」。永恆火線港的 Melbin Powderfuse（260562，`2548 77.74, 50.89`，台服名【需遊戲實測】）列為哥布林配方訓練師。升 300 可直接去加基森找巴茲克。[永恆工程表](https://www.wowhead.com/forever/tw/guide/professions/engineering-overview-trainer-locations-recipes) · [永恆專精路線](https://questing.wiki/wow-forever/professions/specializations/)
- 四階與最高 300 延續經典版，新增內容包括微風島全階採集師、大河林地採礦師、營地配方、傳承挑戰與商人貢獻點圖樣。現有資料沒有顯示新增的必解升階專精任務。營地設施有獨立技能門檻，例如 11 月 6 日熱修把製皮架放置要求從 140 降到 125，升階仍走上述訓練師與任務。[暴雪營地和專業說明](https://worldofwarcraft.blizzard.com/zh-tw/news/24301516) · [暴雪 11 月 6 日熱修](https://us.forums.blizzard.com/en/wow/t/2403040/4) · [ForeverChanges](https://foreverchanges.pro/professions)
