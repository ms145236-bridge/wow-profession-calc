-- Deutsch (deDE)
-- ui: interface text, keyed by the original Chinese text in Core.lua / Data.lua (same keys as enUS.lua)
-- game: patterns for reading this client's spell descriptions (tools/tooltips-deDE.md, tested by tools/test-healing-locales.mjs),
--       and this client's names of the spells and talents in Data.lua / Core.lua (used only when the spell ID lookup returns nothing)
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.deDE = {
  game = {
    rangeSeps = { "bis" },                      -- "um 42 bis 50 Punkt(e)"
    damageAfter = "^%s*%a-schaden",             -- "129 bis 139 Heiligschaden" is damage, not healing
    hot = "Sek%.[%a ]-(%d+)",                   -- "15 Sek. lang um 45" / "im Verlauf von 7 Sek. um 336"
    absorb = "absorbiert%D-(%d+)",              -- "absorbiert dabei 48 Punkt(e) Schaden"
    single = "um%s+(%d+)%s+Gesundheit",         -- "der es um 172 Gesundheit heilt" (Prayer of Mending)
    tick = "alle%s+(%d+)%s*Sek%.%s*(%d+)",      -- "alle 2 Sek. 91 Gesundheit" (interval, amount)
    tickDur = "(%d+)%s*Sek%.%s*lang%s+alle",    -- "10 Sek. lang alle 2 Sek."
    extra = "weitere%s+(%d+)",                  -- "um weitere 91"
    dur = "(%d+)%s*Sek%.",                      -- "über 21 Sek."
    thousands = { "%." },                       -- "1.111"
    spells = {
      ["聖光術"] = "Heiliges Licht", ["聖光閃現"] = "Lichtblitz", ["神聖震擊"] = "Heiliger Schock", ["聖光戒備"] = "Lichtwacht",
      ["聖光守望"] = "Lichtwacht", ["次級治療術"] = "Geringes Heilen", ["治療術"] = "Heilen", ["快速治療"] = "Blitzheilung",
      ["強效治療術"] = "Große Heilung", ["恢復"] = "Erneuerung", ["真言術：盾"] = "Machtwort: Schild", ["治療禱言"] = "Gebet der Heilung",
      ["懺悟"] = "Sühne", ["苦修"] = "Sühne", ["癒合禱言"] = "Gebet der Besserung", ["愈合禱言"] = "Gebet der Besserung",
      ["神聖新星"] = "Heilige Nova", ["治療之觸"] = "Heilende Berührung", ["回春術"] = "Verjüngung", ["癒合"] = "Nachwachsen",
      ["愈合"] = "Nachwachsen", ["寧靜"] = "Gelassenheit", ["野性痊癒"] = "Wildwuchs", ["野性成長"] = "Wildwuchs",
      ["治療波"] = "Welle der Heilung", ["次級治療波"] = "Geringe Welle der Heilung", ["治療鍊"] = "Kettenheilung", ["治療鏈"] = "Kettenheilung",
      ["激流"] = "Springflut", ["治療之光"] = "Heilendes Licht", ["精神治療"] = "Spirituelle Heilung", ["強化真言術：盾"] = "Verbessertes Machtwort: Schild",
      ["自然賜福"] = "Geschenk der Natur", ["淨化"] = "Läuterung", ["聖光誓約"] = "Eid des Lichts", ["聖光誓言"] = "Eid des Lichts",
    },
  },
  ui = {
    -- product, chat
    ["|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r "] = "|cff4fc3f7Sheng|r|cffd9b25fHeilung|r ",
    ["阿聖治療幫手"] = "Sheng Heilung",
    ["|cffff7b7b%s出錯：|r%s　請把這行回報給開發者"] = "|cffff7b7b%s: Fehler|r %s. Bitte melde diese Zeile dem Entwickler.",
    -- where an error happened
    ["滑鼠提示"] = "Tooltip", ["分析"] = "Analyse", ["比較表"] = "Vergleich", ["除錯指令"] = "Debugbefehl",
    ["掛上滑鼠提示"] = "Tooltip-Hook", ["小地圖按鈕"] = "Minikartenbutton",
    -- spell rows (Data.lua labels)
    ["聖光術"] = "Heiliges Licht", ["聖光閃現"] = "Lichtblitz", ["神聖震擊"] = "Heiliger Schock",
    ["聖光戒備→震擊"] = "Lichtwacht > Schock",
    ["次級治療術"] = "Geringes Heilen", ["治療術"] = "Heilen", ["快速治療"] = "Blitzheilung", ["強效治療術"] = "Große Heilung",
    ["恢復"] = "Erneuerung", ["真言術：盾"] = "Machtwort: Schild", ["治療禱言"] = "Gebet der Heilung", ["懺悟"] = "Sühne",
    ["癒合禱言"] = "Gebet der Besserung", ["神聖新星（治療）"] = "Heilige Nova (Heilung)",
    ["治療之觸"] = "Heilende Berührung", ["回春術"] = "Verjüngung", ["癒合（不含HoT）"] = "Nachwachsen (direkt)", ["癒合"] = "Nachwachsen",
    ["寧靜"] = "Gelassenheit", ["野性痊癒"] = "Wildwuchs",
    ["治療波"] = "Welle der Heilung", ["次級治療波"] = "Geringe Welle der Heilung", ["治療鍊"] = "Kettenheilung", ["激流"] = "Springflut",
    -- spell notes (Data.lua)
    ["CD 10s；永恆治療之光也乘震擊"] = "10 Sek. Abklingzeit. In Forever verstärkt Heilendes Licht auch den Schock.",
    ["戒備 CD 6s；只計小隊治療"] = "Lichtwacht: 6 Sek. Abklingzeit. Nur Gruppenheilung.",
    ["法術書可見 774–910；以降級計算器客戶端為準"] = "Das Zauberbuch zeigt 774–910. Maßgeblich sind die Werte niedrigerer Ränge aus dem Client.",
    ["HoT 總量／15秒"] = "HoT-Gesamtheilung über 15 Sek.",
    ["吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）"] = "Absorption. Grundabklingzeit: 4 Sek. Geschwächte Seele: 15 Sek. pro Ziel (für Forever ungeprüft).",
    ["目標及其小隊每人此量"] = "Heilt jedes Mitglied der Gruppe des Ziels um den Betrag",
    ["3×133／跳；CD 12；係數待核"] = "3 × 133 pro Impuls. 12 Sek. Abklingzeit. Koeffizient ungeprüft.",
    ["每跳等量；最多5跳；CD 10"] = "Gleiche Menge pro Sprung; bis zu 5 Sprünge; 10 Sek. Abklingzeit",
    ["治療分量；係數待核"] = "Nur Heilanteil. Koeffizient ungeprüft.",
    ["Forever 確認總量／12秒"] = "In Forever bestätigt: Gesamtwert über 12 Sek.",
    ["僅直接；HoT 另列"] = "Nur direkte Heilung. HoT separat.",
    ["HoT 91/21s（客戶端）；直接 0.286、HoT 0.497"] = "HoT: 91 über 21 Sek. (Client). Koeffizient direkt 0,286, HoT 0,497.",
    ["引導；每人總量；長CD"] = "Kanalisiert. Gesamtwert pro Person. Lange Abklingzeit.",
    ["cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否"] = "3 Sek. Wirkzeit, 6 Sek. Abklingzeit (ForeverChanges). Kein Spontanzauber.",
    ["第1跳=基礎；總量1+0.5+0.25"] = "Erster Sprung = Grundwert. Gesamt: 1 + 0,5 + 0,25.",
    ["僅HoT；CD 12；無瞬發"] = "Nur HoT. 12 Sek. Abklingzeit. Keine direkte Heilung.",
    -- situational bonuses
    ["聖光誓約"] = "Eid des Lichts", ["誓約目標"] = "Eidziel",
    ["對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。"] =
      "Fester Bonus auf Heiliges Licht, Lichtblitz und Heiliger Schock beim Eidziel. Bei aktivem Bonus nutzt die Tabelle diese Werte.",
    ["聖光束縛"] = "Heilige Bindung", ["對他人施放（含自療）"] = "Auf andere (mit Selbstheilung)",
    ["快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。"] =
      "Blitzheilung auf andere heilt dich zusätzlich um 50 % des Betrags. Bei aktivem Bonus zählt die Selbstheilung mit.",
    ["激流加成"] = "Bonus von Springflut", ["目標有激流"] = "Ziel mit Springflut",
    ["目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。"] =
      "Kettenheilung auf ein Ziel mit deiner Springflut heilt beim ersten Sprung 25 % mehr. Bei aktivem Bonus nutzt die Tabelle diesen Wert.",
    ["綻放"] = "Blüte", ["含綻放"] = "Mit Blüte",
    ["回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。"] =
      "Wenn dein HoT von Verjüngung oder Nachwachsen abläuft, heilt er das Ziel um 100 % deiner Willenskraft (50 % bei Bannung). Bei aktivem Bonus zählt diese Heilung mit.",
    ["沒學"] = "Nicht gelernt", ["計入"] = "Berücksichtigt", ["不計入"] = "Nicht berücksichtigt",
    -- talents
    ["讀不到"] = "nicht gefunden", ["經典"] = "Classic",
    ["%s %d/%d（+%d%%）"] = "%s %d/%d (+%d%%)",
    ["天賦加成"] = "Talentboni", ["沒有偵測到治療加成天賦"] = "Keine Heiltalente erkannt.",
    ["治療加成 "] = "Heilbonus ", ["%（手動）"] = "% (manuell)",
    ["聖光誓約：讀不到加成量（請執行 /shps debug 回報）"] = "Eid des Lichts: Bonus nicht gefunden (führen Sie /shps debug aus und melden Sie es)",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d"] = "Eid des Lichts: Heiliges Licht +%d, Lichtblitz +%d, Heiliger Schock +%d",
    ["綻放：每次 HoT 結束 +"] = "Blüte pro HoT-Ablauf: +",
    -- shared bits (symbols: Latin-1 and plain punctuation only, other glyphs turn into boxes)
    ["…"] = "...", ["▼"] = "v ", ["★"] = "*",
    ["："] = ": ", ["、"] = ", ", ["＋"] = " + ", ["（"] = " (", ["）"] = ")", [" ／ "] = " / ",
    [" 等級"] = " Rang ", [" 秒"] = " Sek.", ["開"] = "An", ["關"] = "Aus",
    ["單補"] = "Einzelziel", ["群補"] = "Gruppe", ["冷卻"] = "Abklingzeit", ["救命"] = "Notfall",
    -- analysis names
    ["保持"] = "Aufrechterhalten: ", ["鋪"] = "Verteilen: ", ["，救命 "] = ", im Notfall ",
    ["（停到 %d%%）"] = " (bis %d%% warten)", ["（救命 %s）"] = " (im Notfall %s)",
    ["，坦克快倒時改放 %s"] = ", %s bei niedriger Tankgesundheit",
    ["戰鬥中不分析"] = "Nicht verfügbar im Kampf", ["讀不到回藍"] = "Manaregeneration nicht abrufbar",
    -- breakdown lines
    ["%d 秒內補完；冷卻 %s 秒"] = "Heilt über %d Sek., %s Sek. Abklingzeit",
    ["冷卻 %s 秒"] = "%s Sek. Abklingzeit",
    ["直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%"] = "Direkt %s (%s/Sek.) + %d Sek. HoT %s. Bei %d Zielen läuft jeder HoT zu %d%% aus.",
    ["直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s"] = "Direkt %s (%s/Sek.) + %d Sek. HoT %s (%s/Sek.)\nBei Zielwechsel: %s/Sek.",
    ["%d 秒內補完；鋪 %d 人"] = "Heilt über %d Sek., verteilt auf %d Ziele",
    ["%d 秒內補完；輪流掛不同目標時每秒 %s"] = "Heilt über %d Sek. Bei Zielwechsel: %s/Sek.",
    ["同一目標 15 秒一次；輪流上不同目標時每秒 %s"] = "Pro Ziel einmal in 15 Sek. Bei Zielwechsel: %s/Sek.",
    -- spell tooltip
    ["（吸收）"] = " (Absorption)", ["（%d人）"] = " (%d Ziele)", ["|cffd9b25fHPS ／ HPM|r"] = "|cffd9b25fHPS / HPM|r",
    ["降級"] = "Niedrigerer Rang", ["治療效果只算 %d%%"] = "%d%% der Bonusheilung",
    ["★ %s HPS最高"] = "* Bestes HPS (%s)", ["★ %s HPM最高"] = "* Bestes HPM (%s)",
    -- window
    ["拖曳調整視窗大小"] = "Zum Skalieren ziehen",
    ["設定"] = "Einstellungen",
    ["技能"] = "Zauber", ["等級"] = "Rang", ["有效量"] = "Heilung", ["法力"] = "Mana", ["秒"] = "Sek.",
    ["%d 級 · 治療效果 %d"] = "Stufe %d · Bonusheilung %d", [" · 精神 %d"] = " · Willenskraft %d",
    [" · 回藍 停手 %d／施法 %d（每 5 秒）"] = " · Mana/5 s: %d ruhend / %d zaubernd",
    ["技能提示："] = "Zauber-Tooltip: ", ["精簡"] = "Kurz", ["標準"] = "Standard", ["完整"] = "Ausführlich",
    ["群補人數 "] = "Ziele der Gruppenheilung ",
    ["HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r"] =
      "HPS = Heilung ÷ Wirkzeit\n|cff9a9282Spontanzauber zählen als 1,5 Sek.\nHoTs nutzen ihre Dauer. „Gruppe“ zählt die gleichzeitig versorgten Ziele.\nZauber mit Abklingzeit werden auf einem eigenen Reiter pro Einsatz berechnet.|r",
    ["（吸收）|r"] = " (Absorption)|r",
    ["這一頁沒有你學會的技能。"] = "Keine erlernten Zauber auf diesem Reiter.",
    ["|cffffd100★ HPS最高|r %s 等級%d"] = "|cffffd100* Höchste HPS|r %s Rang %d", ["|cff66ff66★ HPM最高|r %s 等級%d"] = "|cff66ff66* Höchste HPM|r %s Rang %d",
    ["目前沒有可比較的治療技能（吸收盾不參加比較）"] = "Keine Heilzauber zum Vergleichen (ohne Absorption).",
    ["（滾輪看更多）"] = "(Scrollen für mehr)",
    ["吸收量不是治療量，不參加 HPS／HPM 最高的比較"] = "Absorption zählt bei den HPS-/HPM-Bestwerten nicht als Heilung.",
    ["學習等級"] = "Erlernt auf Stufe", ["（%d%%）"] = " (%d%%)",
    ["部分數值來自資料表（遊戲讀不到）"] = "Einige Werte stammen aus der Datentabelle (im Spiel nicht lesbar)",
    -- analysis tab
    ["單坦"] = "Tank", ["團刷"] = "Gruppe",
    ["小怪"] = "Trash", ["王戰"] = "Boss", ["單練"] = "Solo", ["省水"] = "Leicht",
    ["群怪"] = "Trash", ["全團技"] = "Raid-AoE", ["範圍"] = "AoE", ["點名"] = "Gezielt",
    ["詳細"] = "Details",
    ["坦克生命 %d"] = "Tank-TP %d", ["每次傷害 %d"] = "Schaden pro Treffer %d", ["受傷間隔 %.1f 秒"] = "Trefferintervall %.1f Sek.",
    ["戰鬥長度 %d 秒"] = "Kampflänge %d Sek.", ["人數 %d"] = "Gruppengröße %d", ["成員生命 %d"] = "Gruppenmitglied-TP %d",
    ["坦克每次傷害 %d"] = "Tanktreffer %d", ["坦克每次傷害 無"] = "Kein Tanktreffer", ["坦克間隔 %.1f 秒"] = "Tanktreffer alle %.1f Sek.",
    ["範圍每次傷害 %d"] = "Flächenschaden pro Treffer %d", ["範圍每次傷害 無"] = "Kein Flächenschaden", ["範圍間隔 %.1f 秒"] = "Flächenschaden alle %.1f Sek.",
    ["範圍命中 隨機 %d 人"] = "AoE trifft %d zufällige Ziele", ["範圍命中 全員"] = "AoE trifft alle",
    ["最省藍"] = "Am effizientesten", ["最穩定"] = "Am stabilsten", ["撐最久"] = "Hält am längsten",
    ["沒有可以補的技能"] = "Keine Heilzauber verfügbar", ["沒有可以單補的技能"] = "Keine Einzelzielheilung verfügbar",
    ["|cffffd100最省藍：|r%s"] = "|cffffd100Am effizientesten:|r %s", ["|cffffd100最穩定：|r%s"] = "|cffffd100Am stabilsten:|r %s",
    ["|cffff6b6b都撐不住：|r最好 %s（%s）"] = "|cffff6b6bKeiner überlebt:|r beste Option %s (%s)",
    ["%d 秒滅團"] = "Wipe nach %d Sek.", ["倒 %d 人"] = "%d Tote",
    ["|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）"] = "|cffff6b6bKeiner überlebt:|r längste Dauer %s (%d Sek.)",
    ["活"] = "Lebendig", ["倒下 %d 秒"] = "Tot nach %d Sek.", ["滅團 %d 秒"] = "Wipe nach %d Sek.", ["倒 %d 人 %d 秒"] = "%d Tote, erster Tod nach %d Sek.",
    ["沒藍 %d 秒"] = "Mana leer nach %d Sek.", ["補滿差 "] = "Es fehlen ", ["剩藍 "] = "Mana übrig ", ["最低 %d%%"] = "Minimum %d%%",
    ["每 "] = "Alle ", [" 秒一發"] = " Sek.", ["沒出手"] = "Keine Zauber gewirkt",
    ["不用喝水"] = "Keine Trinkpause", ["打完要喝水"] = "Danach trinken", ["可連打 %d 波"] = "%d Pulls in Folge",
    ["補到"] = "Geheilt", ["溢補"] = "Überheilung", ["施法"] = "Gewirkte Zauber", [" 次"] = "", ["、救命 "] = ", Notfall ",
    ["倒下"] = "Todesfälle", ["%d 人，第一人 %d 秒"] = "%d, erster Tod nach %d Sek.", ["，坦克或自己倒下"] = ", Tank oder du gestorben",
    ["低於 30%"] = "Unter 30 %", ["%d 人秒"] = "%d Spieler-Sek.", ["戰鬥結束"] = "Kampfende",
    ["不喝水連打"] = "Pulls in Folge", [" 波"] = "", ["救命 "] = "Notfall ",
    ["坦克 %d%%、剩藍 %s"] = "Tank %d%%, Mana übrig %s",
    -- minimap
    ["左鍵：開啟／關閉"] = "Linksklick: Öffnen/Schließen",
    ["右鍵：設定"] = "Rechtsklick: Einstellungen",
    ["拖曳：沿著小地圖移動"] = "Ziehen: auf der Minikarte verschieben",
    -- debug
    ["版本 %s　API：%s　法術書共 %d 個技能"] = "Version %s  API: %s  Zauberbuch: %d Zauber",
    ["新版 C_SpellBook"] = "neu C_SpellBook", ["舊版"] = "Alt",
    ["職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s"] = "Klasse %s  Stufe %d  Bonusheilung %d  Beschreibungswerte: %s  Talente: %s",
    ["已含治療效果"] = "inkl. Bonusheilung", ["基礎量"] = "nur Basiswert", ["沒找到"] = "keine",
    ["聖光誓約：讀不到加成量。天賦說明："] = "Eid des Lichts: Bonus nicht gefunden. Talenttext: ",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）"] = "Eid des Lichts: Heiliges Licht +%d, Lichtblitz +%d, Heiliger Schock +%d (%s)",
    ["比較表已計入"] = "in der Tabelle", ["比較表未計入"] = "Nicht in der Tabelle berücksichtigt",
    ["已點天賦："] = "Talente: ", ["有"] = "Ja",
    ["（比較表已計入）"] = " (in der Tabelle enthalten)", ["（比較表未計入）"] = " (nicht in der Tabelle enthalten)",
    ["沒偵測到"] = "Nicht erkannt",
    ["一個治療技能都沒對上。法術書前幾個技能："] = "Keine passenden Heilzauber. Erste Einträge im Zauberbuch: ",
    ["%s：法術書沒找到"] = "%s: nicht im Zauberbuch",
    ["%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s"] = "%s: Spielname „%s“ bis Rang %d (%d Ränge mit Zauber-ID). Ausgelesen: %s",
    ["不解析"] = "Nicht ausgelesen", ["失敗："] = "Fehler: ", ["說明未載入"] = "Beschreibung nicht geladen",
    -- slash commands
    ["這個職業沒有治療技能，插件不會運作。"] = "Diese Klasse hat keine Heilzauber. Das Addon bleibt inaktiv.",
    ["小地圖按鈕："] = "Minikartenbutton: ", ["隱藏（再輸入 /shps minimap 顯示）"] = "ausgeblendet (geben Sie /shps minimap ein, um es anzuzeigen)", ["顯示"] = "Sichtbar",
    ["治療加成 %："] = "Heilungsbonus %: ", ["（手動）"] = " (manuell)", ["依天賦自動"] = "automatisch nach Talenten",
    ["吸收加成 %："] = "Absorptionsbonus %: ", ["群補目標數："] = "Ziele der Gruppenheilung: ",
    ["滑鼠提示："] = "Tooltip: ", ["降級衰減："] = "Malus niedrigerer Ränge: ", ["視窗縮放："] = "Fensterskalierung: ",
    ["用法：/shps scale 1.2（0.5～2，目前 "] = "Verwendung: /shps scale 1.2 (0.5–2, jetzt ",
    ["技能說明數字："] = "Werte aus Zauberbeschreibung: ",
    ["已含治療效果（手動）"] = "inkl. Bonusheilung (manuell)", ["只有基礎量（手動）"] = "nur Basiswert (manuell)", ["自動判斷"] = "auto",
    ["　目前："] = "  Jetzt: ", ["直接採用說明數字"] = "Werte aus der Beschreibung", ["基礎＋治療效果×係數"] = "Basis + Bonusheilung × Koeffizient",
    ["介面語言：%s（/reload 後生效）"] = "UI-Sprache: %s (nach /reload)",
    ["設定已重設"] = "Einstellungen zurückgesetzt",
    ["/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset"] =
      "/shps Fenster umschalten  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = Layout-Stresstest, Englisch um 35% verlängert)  /shps debug  /shps reset",
    ["顯示小地圖按鈕"] = "Minikartenknopf anzeigen",
  },
}
