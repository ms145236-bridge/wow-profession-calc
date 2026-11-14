# ShengHealing UI · deDE

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName deDE](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=deDE)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25fHeilung|r 
阿聖治療幫手｜Sheng Healing｜Sheng Heilung
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s: Fehler|r %s. Bitte melde diese Zeile dem Entwickler.
滑鼠提示｜Tooltip｜Tooltip
分析｜Analysis｜Analyse
比較表｜Table｜Vergleich
除錯指令｜Debug command｜Debugbefehl
掛上滑鼠提示｜Tooltip hook｜Tooltip-Hook
小地圖按鈕｜Minimap button｜Minikartenbutton
聖光術｜Holy Light｜Heiliges Licht
聖光閃現｜Flash of Light｜Lichtblitz
神聖震擊｜Holy Shock｜Heiliger Schock
聖光戒備→震擊｜Light's Vigil > Shock｜Lichtwacht > Schock
次級治療術｜Lesser Heal｜Geringes Heilen
治療術｜Heal｜Heilen
快速治療｜Flash Heal｜Blitzheilung
強效治療術｜Greater Heal｜Große Heilung
恢復｜Renew｜Erneuerung
真言術：盾｜Power Word: Shield｜Machtwort: Schild
治療禱言｜Prayer of Healing｜Gebet der Heilung
懺悟｜Penance｜Sühne
癒合禱言｜Prayer of Mending｜Gebet der Besserung
神聖新星（治療）｜Holy Nova (heal)｜Heilige Nova (Heilung)
治療之觸｜Healing Touch｜Heilende Berührung
回春術｜Rejuvenation｜Verjüngung
癒合（不含HoT）｜Regrowth (direct)｜Nachwachsen (direkt)
癒合｜Regrowth｜Nachwachsen
寧靜｜Tranquility｜Gelassenheit
野性痊癒｜Wild Growth｜Wildwuchs
治療波｜Healing Wave｜Welle der Heilung
次級治療波｜Lesser Healing Wave｜Geringe Welle der Heilung
治療鍊｜Chain Heal｜Kettenheilung
激流｜Riptide｜Springflut
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜10 Sek. Abklingzeit. In Forever verstärkt Heilendes Licht auch den Schock.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜Lichtwacht: 6 Sek. Abklingzeit. Nur Gruppenheilung.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜Das Zauberbuch zeigt 774–910. Maßgeblich sind die Werte niedrigerer Ränge aus dem Client.
HoT 總量／15秒｜HoT total over 15 sec｜HoT-Gesamtheilung über 15 Sek.
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜Absorption. Grundabklingzeit: 4 Sek. Geschwächte Seele: 15 Sek. pro Ziel (für Forever ungeprüft).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜Heilt jedes Mitglied der Gruppe des Ziels um den Betrag
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3 × 133 pro Impuls. 12 Sek. Abklingzeit. Koeffizient ungeprüft.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜Gleiche Menge pro Sprung; bis zu 5 Sprünge; 10 Sek. Abklingzeit
治療分量；係數待核｜Healing part only; coefficient unverified｜Nur Heilanteil. Koeffizient ungeprüft.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜In Forever bestätigt: Gesamtwert über 12 Sek.
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜Nur direkte Heilung. HoT separat.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜HoT: 91 über 21 Sek. (Client). Koeffizient direkt 0,286, HoT 0,497.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜Kanalisiert. Gesamtwert pro Person. Lange Abklingzeit.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜3 Sek. Wirkzeit, 6 Sek. Abklingzeit (ForeverChanges). Kein Spontanzauber.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜Erster Sprung = Grundwert. Gesamt: 1 + 0,5 + 0,25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜Nur HoT. 12 Sek. Abklingzeit. Keine direkte Heilung.
聖光誓約｜Oath of Light｜Eid des Lichts
誓約目標｜Oath target｜Eidziel
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜Fester Bonus auf Heiliges Licht, Lichtblitz und Heiliger Schock beim Eidziel. Bei aktivem Bonus nutzt die Tabelle diese Werte.
聖光束縛｜Holy Binding｜Heilige Bindung
對他人施放（含自療）｜On others (with self-heal)｜Auf andere (mit Selbstheilung)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜Blitzheilung auf andere heilt dich zusätzlich um 50 % des Betrags. Bei aktivem Bonus zählt die Selbstheilung mit.
激流加成｜Riptide bonus｜Bonus von Springflut
目標有激流｜Target has Riptide｜Ziel mit Springflut
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜Kettenheilung auf ein Ziel mit deiner Springflut heilt beim ersten Sprung 25 % mehr. Bei aktivem Bonus nutzt die Tabelle diesen Wert.
綻放｜Bloom｜Blüte
含綻放｜With Bloom｜Mit Blüte
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜Wenn dein HoT von Verjüngung oder Nachwachsen abläuft, heilt er das Ziel um 100 % deiner Willenskraft (50 % bei Bannung). Bei aktivem Bonus zählt diese Heilung mit.
沒學｜Not learned｜Nicht gelernt
計入｜Included｜Berücksichtigt
不計入｜Excluded｜Nicht berücksichtigt
讀不到｜not found｜nicht gefunden
經典｜Classic｜Classic
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜Talentboni
沒有偵測到治療加成天賦｜No healing talents detected｜Keine Heiltalente erkannt.
治療加成 ｜Healing bonus ｜Heilbonus 
%（手動）｜% (manual)｜% (manuell)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜Eid des Lichts: Bonus nicht gefunden (führen Sie /shps debug aus und melden Sie es)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜Eid des Lichts: Heiliges Licht +%d, Lichtblitz +%d, Heiliger Schock +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜Blüte pro HoT-Ablauf: +
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ Rang 
 秒｜ sec｜ Sek.
開｜On｜An
關｜Off｜Aus
單補｜Single｜Einzelziel
群補｜Group｜Gruppe
冷卻｜Cooldown｜Abklingzeit
救命｜Emergency｜Notfall
保持｜Keep ｜Aufrechterhalten: 
鋪｜Spread ｜Verteilen: 
，救命 ｜, emergency ｜, im Notfall 
（停到 %d%%）｜ (hold until %d%%)｜ (bis %d%% warten)
（救命 %s）｜ (emergency %s)｜ (im Notfall %s)
，坦克快倒時改放 %s｜, %s when the tank is low｜, %s bei niedriger Tankgesundheit
戰鬥中不分析｜Not available in combat｜Nicht verfügbar im Kampf
讀不到回藍｜Can't read mana regen｜Manaregeneration nicht abrufbar
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜Heilt über %d Sek., %s Sek. Abklingzeit
冷卻 %s 秒｜%s sec cooldown｜%s Sek. Abklingzeit
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜Direkt %s (%s/Sek.) + %d Sek. HoT %s. Bei %d Zielen läuft jeder HoT zu %d%% aus.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜Direkt %s (%s/Sek.) + %d Sek. HoT %s (%s/Sek.)\nBei Zielwechsel: %s/Sek.
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜Heilt über %d Sek., verteilt auf %d Ziele
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜Heilt über %d Sek. Bei Zielwechsel: %s/Sek.
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜Pro Ziel einmal in 15 Sek. Bei Zielwechsel: %s/Sek.
（吸收）｜ (absorb)｜ (Absorption)
（%d人）｜ (%d targets)｜ (%d Ziele)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜Niedrigerer Rang
治療效果只算 %d%%｜%d%% of Bonus Healing｜%d%% der Bonusheilung
★ %s HPS最高｜* Best HPS (%s)｜* Bestes HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* Bestes HPM (%s)
拖曳調整視窗大小｜Drag to resize｜Zum Skalieren ziehen
設定｜Settings｜Einstellungen
技能｜Spell｜Zauber
等級｜Rank｜Rang
有效量｜Heal｜Heilung
法力｜Mana｜Mana
秒｜Sec｜Sek.
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜Stufe %d · Bonusheilung %d
 · 精神 %d｜ · Spirit %d｜ · Willenskraft %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · Manareg.: %d außerhalb / %d beim Zaubern (je 5 Sek.)
技能提示：｜Spell tooltip: ｜Zauber-Tooltip: 
精簡｜Brief｜Kurz
標準｜Standard｜Standard
完整｜Full｜Ausführlich
群補人數 ｜Group targets ｜Ziele der Gruppenheilung 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = Heilung ÷ Wirkzeit\n|cff9a9282Spontanzauber zählen als 1,5 Sek.\nHoTs nutzen ihre Dauer. „Gruppe“ zählt die gleichzeitig versorgten Ziele.\nZauber mit Abklingzeit werden auf einem eigenen Reiter pro Einsatz berechnet.|r
（吸收）|r｜ (absorb)|r｜ (Absorption)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜Keine erlernten Zauber auf diesem Reiter.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* Höchste HPS|r %s Rang %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* Höchste HPM|r %s Rang %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜Keine Heilzauber zum Vergleichen (ohne Absorption).
（滾輪看更多）｜(scroll for more)｜(Scrollen für mehr)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜Absorption zählt bei den HPS-/HPM-Bestwerten nicht als Heilung.
學習等級｜Learned at｜Erlernt auf Stufe
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜Einige Werte stammen aus der Datentabelle (im Spiel nicht lesbar)
單坦｜Tank｜Tank
團刷｜Group｜Gruppe
小怪｜Trash｜Trash
王戰｜Boss｜Boss
單練｜Solo｜Solo
省水｜Easy｜Leicht
群怪｜Trash｜Trash
全團技｜Raid AoE｜Schlachtzugs-AoE
範圍｜AoE｜Flächenschaden
點名｜Targeted｜Gezielt
詳細｜Details｜Details
坦克生命 %d｜Tank HP %d｜Tank-TP %d
每次傷害 %d｜Damage per hit %d｜Schaden pro Treffer %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜Trefferintervall %.1f Sek.
戰鬥長度 %d 秒｜Fight length %d sec｜Kampflänge %d Sek.
人數 %d｜Group size %d｜Gruppengröße %d
成員生命 %d｜Member HP %d｜Gruppenmitglied-TP %d
坦克每次傷害 %d｜Tank hit %d｜Tanktreffer %d
坦克每次傷害 無｜Tank hit: none｜Kein Tanktreffer
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜Tanktreffer alle %.1f Sek.
範圍每次傷害 %d｜AoE hit %d｜Flächenschaden pro Treffer %d
範圍每次傷害 無｜AoE hit: none｜Kein Flächenschaden
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜Flächenschaden alle %.1f Sek.
範圍命中 隨機 %d 人｜AoE hits %d random｜AoE trifft %d zufällige Ziele
範圍命中 全員｜AoE hits everyone｜AoE trifft alle
最省藍｜Most efficient｜Am effizientesten
最穩定｜Most stable｜Am stabilsten
撐最久｜Lasts longest｜Hält am längsten
沒有可以補的技能｜No healing spells to use｜Keine Heilzauber verfügbar
沒有可以單補的技能｜No single-target heals to use｜Keine Einzelzielheilung verfügbar
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100Am effizientesten:|r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100Am stabilsten:|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6bKeiner überlebt:|r beste Option %s (%s)
%d 秒滅團｜wipe at %d sec｜Wipe nach %d Sek.
倒 %d 人｜%d dead｜%d Tote
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6bKeiner überlebt:|r längste Dauer %s (%d Sek.)
活｜Alive｜Lebendig
倒下 %d 秒｜Dead at %d sec｜Tot nach %d Sek.
滅團 %d 秒｜Wipe at %d sec｜Wipe nach %d Sek.
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d Tote, erster Tod nach %d Sek.
沒藍 %d 秒｜OOM at %d sec｜Mana leer nach %d Sek.
補滿差 ｜Short by ｜Es fehlen 
剩藍 ｜Mana left ｜Mana übrig 
最低 %d%%｜Low %d%%｜Minimum %d%%
每 ｜Every ｜Alle 
 秒一發｜ sec｜ Sek.
沒出手｜No casts｜Keine Zauber gewirkt
不用喝水｜No drinking｜Keine Trinkpause
打完要喝水｜Drink after｜Danach trinken
可連打 %d 波｜%d pulls in a row｜%d Pulls in Folge
補到｜Healed｜Geheilt
溢補｜Overheal｜Überheilung
施法｜Casts｜Gewirkte Zauber
 次｜｜
、救命 ｜, emergency ｜, Notfall 
倒下｜Deaths｜Todesfälle
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d, erster Tod nach %d Sek.
，坦克或自己倒下｜, tank or you died｜, Tank oder du gestorben
低於 30%｜Below 30%｜Unter 30 %
%d 人秒｜%d player-sec｜%d Spieler-Sek.
戰鬥結束｜Fight end｜Kampfende
不喝水連打｜Pulls in a row｜Pulls in Folge
 波｜｜
救命 ｜emergency ｜Notfall 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜Tank %d%%, Mana übrig %s
技能提示的 HPS：｜Spell tooltip HPS: ｜HPS im Zauber-Tooltip: 
左鍵：開關比較表｜Left-click: toggle the table｜Linksklick: Vergleich ein-/ausblenden
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜Rechtsklick: HPS im Tooltip umschalten (jetzt 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜Ziehen: auf der Minikarte verschieben
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜Version %s  API: %s  Zauberbuch: %d Zauber
新版 C_SpellBook｜new C_SpellBook｜neu C_SpellBook
舊版｜legacy｜Alt
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜Klasse %s  Stufe %d  Bonusheilung %d  Beschreibungswerte: %s  Talente: %s
已含治療效果｜include Bonus Healing｜inkl. Bonusheilung
基礎量｜base only｜nur Basiswert
沒找到｜none｜keine
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜Eid des Lichts: Bonus nicht gefunden. Talenttext: 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜Eid des Lichts: Heiliges Licht +%d, Lichtblitz +%d, Heiliger Schock +%d (%s)
比較表已計入｜included in the table｜in der Tabelle
比較表未計入｜not included in the table｜Nicht in der Tabelle berücksichtigt
已點天賦：｜Talents: ｜Talente: 
有｜Yes｜Ja
（比較表已計入）｜ (included in the table)｜ (in der Tabelle enthalten)
（比較表未計入）｜ (not included in the table)｜ (nicht in der Tabelle enthalten)
沒偵測到｜Not detected｜Nicht erkannt
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜Keine passenden Heilzauber. Erste Einträge im Zauberbuch: 
%s：法術書沒找到｜%s: not in spellbook｜%s: nicht im Zauberbuch
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s: Spielname „%s“ bis Rang %d (%d Ränge mit Zauber-ID). Ausgelesen: %s
不解析｜not parsed｜Nicht ausgelesen
失敗：｜failed: ｜Fehler: 
說明未載入｜description not loaded｜Beschreibung nicht geladen
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜Diese Klasse hat keine Heilzauber. Das Addon bleibt inaktiv.
小地圖按鈕：｜Minimap button: ｜Minikartenbutton: 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜ausgeblendet (geben Sie /shps minimap ein, um es anzuzeigen)
顯示｜shown｜Sichtbar
治療加成 %：｜Healing bonus %: ｜Heilungsbonus %: 
（手動）｜ (manual)｜ (manuell)
依天賦自動｜auto from talents｜automatisch nach Talenten
吸收加成 %：｜Absorb bonus %: ｜Absorptionsbonus %: 
群補目標數：｜Group targets: ｜Ziele der Gruppenheilung: 
滑鼠提示：｜Tooltip: ｜Tooltip: 
降級衰減：｜Downrank penalty: ｜Malus niedrigerer Ränge: 
視窗縮放：｜Window scale: ｜Fensterskalierung: 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜Verwendung: /shps scale 1.2 (0.5–2, jetzt 
技能說明數字：｜Spell description values: ｜Werte aus Zauberbeschreibung: 
已含治療效果（手動）｜include Bonus Healing (manual)｜inkl. Bonusheilung (manuell)
只有基礎量（手動）｜base only (manual)｜nur Basiswert (manuell)
自動判斷｜auto｜auto
　目前：｜  Now: ｜  Jetzt: 
直接採用說明數字｜using description values｜Werte aus der Beschreibung
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜Basis + Bonusheilung × Koeffizient
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜UI-Sprache: %s (nach /reload)
設定已重設｜Settings reset｜Einstellungen zurückgesetzt
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps Fenster umschalten  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = Layout-Stresstest, Englisch um 35% verlängert)  /shps debug  /shps reset
```
