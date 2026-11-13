-- 升階訓練師（部落）：專家＝上限 150→225，大師＝225→300
-- 資料來源：tools/verify-prof-trainers.md（永恆 1.60.1.70938）。cost 單位為銅（基礎價，實付可能有折扣）。
-- at：可去的訓練師，主城排前面；map 是 uiMapID，x/y 為 0–100。沒有 map 的點不能設航點。
-- book／quest：副專業用技能書或任務升階；quest 的接取 NPC 就是 at[1]。
-- 欄位_語言（例如 name_enUS）：其他語言的顯示文字，沒有就用中文欄位。英文依 tools/english-prof-data.md（NPC ID 逐筆核對）

ProfLevel_Trainers = {
  alchemy = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "赫伯特·哈爾希醫生", map = 1458, x = 47.77, y = 73.34, place = "幽暗城", name_enUS = "Doctor Herbert Halsey", place_enUS = "Undercity" },
    } },
    master = { level = 35, skill = 200, cost = 50000, at = {
      { name = "羅格瓦爾", map = 1435, x = 48.53, y = 55.85, place = "斯通納德", name_enUS = "Rogvar", place_enUS = "Stonard" },
      -- 永恆新點，台服名【需遊戲實測】
      { name = "Master Mycologist Shurome", map = 1448, x = 51.41, y = 82.01, place = "翡翠聖地", name_enUS = "Master Mycologist Shurome", place_enUS = "Emerald Sanctuary" },
    } },
  },
  blacksmithing = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "薩魯·鋼怒", map = 1454, x = 82.35, y = 22.97, place = "奧格瑪", name_enUS = "Saru Steelfury", place_enUS = "Orgrimmar" },
    } },
    master = { level = 35, skill = 200, cost = 50000, at = {
      { name = "布里克·基克拉夫", map = 1434, x = 28.99, y = 75.56, place = "藏寶海灣", name_enUS = "Brikk Keencraft", place_enUS = "Booty Bay" },
    } },
  },
  enchanting = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "赫加斯", map = 1442, x = 49.18, y = 57.18, place = "烈日石居", name_enUS = "Hgarth", place_enUS = "Sun Rock Retreat" },
    } },
    -- 副本內，uiMapID／座標【需遊戲實測】，所以沒有航點
    master = { level = 35, skill = 200, cost = 50000, note = "地圖室與神殿大廳之間的洞穴，清掉周圍蠍群才現身", note_enUS = "In the cave between the Map Chamber and the Temple Hall; appears after the scorpids there are cleared", at = {
      { name = "安諾拉", place = "奧達曼副本", name_enUS = "Annora", place_enUS = "Uldaman (dungeon)" },
    } },
  },
  engineering = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "羅克希克", map = 1454, x = 76.17, y = 25.17, place = "奧格瑪", name_enUS = "Roxxik", place_enUS = "Orgrimmar" },
    } },
    master = { level = 35, skill = 200, cost = 50000, note = "旅店外信箱附近", note_enUS = "Near the mailbox outside the inn", at = {
      { name = "巴茲克·布拉斯溫", map = 1446, x = 52.34, y = 27.72, place = "加基森", name_enUS = "Buzzek Bracketswing", place_enUS = "Gadgetzan" },
    } },
  },
  leatherworking = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "猶納", map = 1456, x = 41.50, y = 42.57, place = "雷霆崖", name_enUS = "Una", place_enUS = "Thunder Bluff" },
    } },
    master = { level = 35, skill = 200, cost = 50000, at = {
      { name = "哈拉納·鐵皮", map = 1444, x = 74.36, y = 43.12, place = "莫沙徹營地", name_enUS = "Hahrana Ironhide", place_enUS = "Camp Mojache" },
    } },
  },
  tailoring = {
    expert = { level = 20, skill = 125, cost = 5000, at = {
      { name = "喬瑟夫·格里高利", map = 1458, x = 70.76, y = 30.69, place = "幽暗城", name_enUS = "Josef Gregorian", place_enUS = "Undercity" },
    } },
    master = { level = 35, skill = 200, cost = 50000, at = {
      { name = "達瑞爾·斯塔克", map = 1424, x = 63.75, y = 20.79, place = "塔倫米爾", name_enUS = "Daryl Stack", place_enUS = "Tarren Mill" },
    } },
  },
  -- 採集：無已知角色等級門檻（極低等角色的伺服器判定【需遊戲實測】），兩階可找同一位
  herbalism = {
    expert = { skill = 125, cost = 5000, at = {
      { name = "加迪", map = 1454, x = 55.62, y = 39.46, place = "奧格瑪", name_enUS = "Jandi", place_enUS = "Orgrimmar" },
      { name = "馬爾薩·奧列斯塔", map = 1458, x = 54.00, y = 49.55, place = "幽暗城", name_enUS = "Martha Alliestar", place_enUS = "Undercity" },
      { name = "克米恩·冰蹄", map = 1456, x = 49.95, y = 40.41, place = "雷霆崖", name_enUS = "Komin Winterhoof", place_enUS = "Thunder Bluff" },
      { name = "法魯薩", map = 1420, x = 59.79, y = 52.12, place = "布瑞爾", name_enUS = "Faruza", place_enUS = "Brill" },
      { name = "米什基", map = 1411, x = 55.44, y = 75.08, place = "森金村", name_enUS = "Mishiki", place_enUS = "Sen'jin Village" },
    } },
  },
  mining = {
    expert = { skill = 125, cost = 5000, at = {
      { name = "馬卡魯", map = 1454, x = 73.12, y = 26.08, place = "奧格瑪", name_enUS = "Makaru", place_enUS = "Orgrimmar" },
      { name = "布羅姆·基里安", map = 1458, x = 56.03, y = 37.45, place = "幽暗城", name_enUS = "Brom Killian", place_enUS = "Undercity" },
      { name = "布瑞克·石蹄", map = 1456, x = 34.37, y = 57.90, place = "雷霆崖", name_enUS = "Brek Stonehoof", place_enUS = "Thunder Bluff" },
      { name = "克魯恩", map = 1411, x = 51.81, y = 40.88, place = "剃刀嶺", name_enUS = "Krunn", place_enUS = "Razor Hill" },
      { name = "喬漢·弗徹", map = 1421, x = 43.41, y = 40.45, place = "瑟伯切爾", name_enUS = "Johan Focht", place_enUS = "The Sepulcher" },
    } },
  },
  skinning = {
    expert = { skill = 125, cost = 5000, at = {
      { name = "蘇爾德", map = 1454, x = 63.36, y = 45.42, place = "奧格瑪", name_enUS = "Thuwd", place_enUS = "Orgrimmar" },
      { name = "基里安·哈根", map = 1458, x = 70.16, y = 59.18, place = "幽暗城", name_enUS = "Killian Hagey", place_enUS = "Undercity" },
      { name = "莫蘭塔", map = 1456, x = 44.44, y = 43.15, place = "雷霆崖", name_enUS = "Mooranta", place_enUS = "Thunder Bluff" },
      { name = "姚恩·深刺", map = 1412, x = 44.97, y = 61.40, place = "血蹄村", name_enUS = "Yonn Deepcut", place_enUS = "Bloodhoof Village" },
      { name = "庫雷格·石角", map = 1444, x = 74.47, y = 43.04, place = "莫沙徹營地", name_enUS = "Kulleg Stonehorn", place_enUS = "Camp Mojache" },
    } },
  },
  -- 副專業：專家買書，大師接交任務（無學階費）
  cooking = {
    -- 書無角色等級欄，20 級以下能否使用【需遊戲實測】
    expert = { skill = 125, cost = 10000, book = "高級烹飪教材", book_enUS = "Expert Cookbook", bookID = 16072, at = {
      { name = "烏蘭", map = 1443, x = 26.17, y = 69.65, place = "葬影村", name_enUS = "Wulan", place_enUS = "Shadowprey Village" },
    } },
    master = { level = 35, skill = 225, cost = 0, quest = "蚌肉大餐", quest_enUS = "Clamlette Surprise", questID = 6610,
      note = "巨蛋 ×12、美味的蚌肉 ×10、奧特蘭克冷酪 ×20；奧格瑪札姆沙可先接引導任務「加基森之旅！」",
      note_enUS = "Giant Egg ×12, Zesty Clam Meat ×10, Alterac Swiss ×20; Zamja in Orgrimmar offers the lead-in quest \"To Gadgetzan You Go!\"", at = {
      { name = "迪爾格·奎克里弗", map = 1446, x = 52.63, y = 28.11, place = "加基森", name_enUS = "Dirge Quikcleave", place_enUS = "Gadgetzan" },
    } },
  },
  ["first-aid"] = {
    -- 書無角色等級欄，20 級以下能否使用【需遊戲實測】
    expert = { skill = 125, cost = 10000, book = "高級急救教材 - 繃帶縛體", book_enUS = "Expert First Aid - Under Wraps", bookID = 16084, at = {
      { name = "巴萊·洛克維", map = 1445, x = 36.49, y = 30.36, place = "蕨牆村", name_enUS = "Balai Lok'Wein", place_enUS = "Brackenwall Village" },
    } },
    master = { level = 35, skill = 225, cost = 0, quest = "救死扶傷", quest_enUS = "Triage", questID = 6622,
      note = "用任務給的繃帶在第 6 名傷兵死亡前救滿 15 名；奧格瑪阿諾克可先接引導任務「部落醫療隊」",
      note_enUS = "Use the quest bandages to save 15 patients before 6 die; Arnok in Orgrimmar offers the lead-in quest \"Horde Trauma\"", at = {
      { name = "格里高利·維克托醫生", map = 1417, x = 73.41, y = 36.89, place = "落錘鎮", name_enUS = "Doctor Gregory Victor", place_enUS = "Hammerfall" },
    } },
  },
  fishing = {
    expert = { level = 20, skill = 125, cost = 10000, book = "高級釣魚教材 - 鱸魚與你", book_enUS = "Expert Fishing - The Bass and You", bookID = 16083, at = {
      { name = "老人海明威", map = 1434, x = 27.42, y = 77.16, place = "藏寶海灣", name_enUS = "Old Man Heming", place_enUS = "Booty Bay" },
    } },
    master = { level = 35, skill = 225, cost = 0, quest = "釣魚專家納特·帕格", quest_enUS = "Nat Pagle, Angler Extreme", questID = 6607,
      note = "接取後到菲拉斯、悲傷沼澤、淒涼之地、荊棘谷四處各釣一尾；奧格瑪魯瑪克可先接引導任務「你真棒！」",
      note_enUS = "After accepting, catch one fish each in Feralas, Swamp of Sorrows, Desolace and Stranglethorn Vale; Lumak in Orgrimmar offers the lead-in quest \"You Too Good.\"", at = {
      { name = "納特·帕格", map = 1445, x = 58.61, y = 60.06, place = "狂潮灣小島", name_enUS = "Nat Pagle", place_enUS = "Tidefury Cove (islet)" },
    } },
  },
}
-- 採集兩階條件相同（技能 200、5 金），找同一批訓練師
for _, k in ipairs({ "herbalism", "mining", "skinning" }) do
  local e = ProfLevel_Trainers[k].expert
  ProfLevel_Trainers[k].master = { skill = 200, cost = 50000, at = e.at }
end
