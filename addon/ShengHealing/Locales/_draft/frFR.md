# ShengHealing UI · frFR

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName frFR](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=frFR)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25fSoins|r 
阿聖治療幫手｜Sheng Healing｜Sheng Soins
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s : erreur|r %s. Merci de transmettre cette ligne au développeur.
滑鼠提示｜Tooltip｜Infobulle
分析｜Analysis｜Analyse
比較表｜Table｜Comparatif
除錯指令｜Debug command｜Commande de débogage
掛上滑鼠提示｜Tooltip hook｜Hook d’infobulle
小地圖按鈕｜Minimap button｜Bouton de minicarte
聖光術｜Holy Light｜Lumière sacrée
聖光閃現｜Flash of Light｜Eclair lumineux
神聖震擊｜Holy Shock｜Horion sacré
聖光戒備→震擊｜Light's Vigil > Shock｜Vigile de Lumière > Horion
次級治療術｜Lesser Heal｜Soins inférieurs
治療術｜Heal｜Soins
快速治療｜Flash Heal｜Soins rapides
強效治療術｜Greater Heal｜Soins supérieurs
恢復｜Renew｜Rénovation
真言術：盾｜Power Word: Shield｜Mot de pouvoir : Bouclier
治療禱言｜Prayer of Healing｜Prière de soins
懺悟｜Penance｜Pénitence
癒合禱言｜Prayer of Mending｜Prière de guérison
神聖新星（治療）｜Holy Nova (heal)｜Nova sacrée (soins)
治療之觸｜Healing Touch｜Toucher guérisseur
回春術｜Rejuvenation｜Récupération
癒合（不含HoT）｜Regrowth (direct)｜Rétablissement (soin direct)
癒合｜Regrowth｜Rétablissement
寧靜｜Tranquility｜Tranquillité
野性痊癒｜Wild Growth｜Croissance sauvage
治療波｜Healing Wave｜Vague de soins
次級治療波｜Lesser Healing Wave｜Vague de soins inférieurs
治療鍊｜Chain Heal｜Salve de guérison
激流｜Riptide｜Remous
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜Recharge de 10 s. Dans Forever, Lumière guérisseuse renforce aussi le Horion.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜Vigile : recharge de 6 s. Soins du groupe uniquement.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜Le grimoire affiche 774–910. Le calcul utilise les valeurs du client pour les rangs inférieurs.
HoT 總量／15秒｜HoT total over 15 sec｜Soins périodiques cumulés sur 15 s
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜Absorption. Recharge de base : 4 s. Ame affaiblie : 15 s par cible (à vérifier dans Forever).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜Soigne chaque membre du groupe de la cible pour ce montant
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3 impulsions de 133. Recharge de 12 s. Coefficient à vérifier.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜Même montant par saut ; jusqu'à 5 sauts ; Temps de recharge de 10 secondes
治療分量；係數待核｜Healing part only; coefficient unverified｜Soins uniquement. Coefficient à vérifier.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜Total sur 12 s, confirmé dans Forever.
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜Soin direct uniquement. Soins périodiques à part.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜Soins périodiques : 91 sur 21 s (client). Coefficients : 0,286 en direct, 0,497 en périodique.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜Canalisé. Total par personne. Recharge longue.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜Incantation de 3 s, recharge de 6 s (ForeverChanges). Pas instantané.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜Premier rebond = valeur de base. Total : 1 + 0,5 + 0,25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜Soins périodiques uniquement. Recharge de 12 s. Aucun soin direct.
聖光誓約｜Oath of Light｜Serment de lumière
誓約目標｜Oath target｜Cible du serment
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜Bonus fixe à Lumière sacrée, Eclair lumineux et Horion sacré sur la cible du serment. Si activé, le tableau utilise ces valeurs.
聖光束縛｜Holy Binding｜Lien sacré
對他人施放（含自療）｜On others (with self-heal)｜Sur autrui (avec soin personnel)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜Soins rapides sur autrui vous rend aussi 50 % du soin. Si activé, le tableau inclut ce soin personnel.
激流加成｜Riptide bonus｜Bonus de Remous
目標有激流｜Target has Riptide｜Cible sous Remous
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜Salve de guérison soigne 25 % de plus au premier rebond si votre Remous est sur la cible. Si activé, le tableau utilise cette valeur.
綻放｜Bloom｜Floraison
含綻放｜With Bloom｜Avec Floraison
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜À l’expiration du soin périodique de Récupération ou de Rétablissement, la cible récupère 100 % de votre Esprit (50 % si dissipé). Si activé, le tableau l’inclut.
沒學｜Not learned｜Non appris
計入｜Included｜Inclus
不計入｜Excluded｜Exclu
讀不到｜not found｜introuvable
經典｜Classic｜Classic
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜Bonus de talents
沒有偵測到治療加成天賦｜No healing talents detected｜Aucun talent de soin détecté.
治療加成 ｜Healing bonus ｜Bonus aux soins 
%（手動）｜% (manual)｜% (manuel)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜Serment de lumière : bonus introuvable (exécutez /shps debug et signalez-le)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜Serment de lumière : Lumière sacrée + %d, Eclair lumineux + %d, Horion sacré + %d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜Floraison à chaque fin de soin périodique : +
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
 秒｜ sec｜ s
開｜On｜Oui
關｜Off｜Non
單補｜Single｜Monocible
群補｜Group｜Groupe
冷卻｜Cooldown｜Recharge
救命｜Emergency｜Urgence
保持｜Keep ｜Maintenir : 
鋪｜Spread ｜Répartir : 
，救命 ｜, emergency ｜, en urgence 
（停到 %d%%）｜ (hold until %d%%)｜ (attendre %d%%)
（救命 %s）｜ (emergency %s)｜ (%s en urgence)
，坦克快倒時改放 %s｜, %s when the tank is low｜, %s si le tank est bas en vie
戰鬥中不分析｜Not available in combat｜Non disponible en combat
讀不到回藍｜Can't read mana regen｜Régénération de mana indisponible
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜Soigne sur %d s, recharge de %s s
冷卻 %s 秒｜%s sec cooldown｜Recharge de %s s
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜Soin direct %s (%s/s) + %d s de soins périodiques %s. Sur %d cibles, chaque effet atteint %d%% de sa durée.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜Soin direct %s (%s/s) + %d s de soins périodiques %s (%s/s)\nEn alternant les cibles : %s/s
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜Soigne sur %d s, réparti sur %d cibles
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜Soigne sur %d s. En alternant les cibles : %s/s
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜Une fois toutes les 15 s par cible. En alternant : %s/s
（吸收）｜ (absorb)｜ (absorption)
（%d人）｜ (%d targets)｜ (%d cibles)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜Rang inférieur
治療效果只算 %d%%｜%d%% of Bonus Healing｜%d%% du bonus aux soins
★ %s HPS最高｜* Best HPS (%s)｜* Meilleur HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* Meilleur HPM (%s)
拖曳調整視窗大小｜Drag to resize｜Faites glisser pour redimensionner
設定｜Settings｜Paramètres
技能｜Spell｜Sort
等級｜Rank｜Rang
有效量｜Heal｜Soins
法力｜Mana｜Mana
秒｜Sec｜s
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜Niveau %d · Bonus aux soins %d
 · 精神 %d｜ · Spirit %d｜ · Esprit %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · Régén. du mana : %d hors incant. / %d en incant. (par 5 s)
技能提示：｜Spell tooltip: ｜Infobulle du sort : 
精簡｜Brief｜Court
標準｜Standard｜Standard
完整｜Full｜Complet
群補人數 ｜Group targets ｜Cibles des soins de groupe 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = soins ÷ temps d’incantation\n|cff9a9282Les sorts instantanés comptent pour 1,5 s.\nLes soins périodiques utilisent leur durée. « Groupe » compte les cibles sur lesquelles ils peuvent être maintenus.\nLes sorts à recharge ont leur onglet et se calculent par lancement.|r
（吸收）|r｜ (absorb)|r｜ (absorption)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜Aucun sort appris dans cet onglet.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* Meilleur HPS|r %s rang %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* Meilleur HPM|r %s rang %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜Aucun sort de soin à comparer (hors absorptions).
（滾輪看更多）｜(scroll for more)｜(faites défiler pour voir la suite)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜Les absorptions sont exclues du classement HPS/HPM.
學習等級｜Learned at｜Niveau requis
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜Certaines valeurs proviennent de la table de données (non lisible en jeu)
單坦｜Tank｜Tank
團刷｜Group｜Groupe
小怪｜Trash｜Ennemis
王戰｜Boss｜Boss
單練｜Solo｜Solo
省水｜Easy｜Facile
群怪｜Trash｜Ennemis
全團技｜Raid AoE｜Zone de raid
範圍｜AoE｜Zone
點名｜Targeted｜Ciblé
詳細｜Details｜Détails
坦克生命 %d｜Tank HP %d｜PV du tank %d
每次傷害 %d｜Damage per hit %d｜Dégâts par coup %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜Intervalle de frappe %.1f sec
戰鬥長度 %d 秒｜Fight length %d sec｜Durée du combat %d sec
人數 %d｜Group size %d｜Taille du groupe %d
成員生命 %d｜Member HP %d｜PV par membre %d
坦克每次傷害 %d｜Tank hit %d｜Dégâts par coup sur le tank %d
坦克每次傷害 無｜Tank hit: none｜Aucun coup sur le tank
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜Coups sur le tank toutes les %.1f s
範圍每次傷害 %d｜AoE hit %d｜Dégâts de zone par coup %d
範圍每次傷害 無｜AoE hit: none｜Aucun dégât de zone
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜Dégâts de zone toutes les %.1f s
範圍命中 隨機 %d 人｜AoE hits %d random｜La zone touche %d cibles aléatoires
範圍命中 全員｜AoE hits everyone｜La zone touche tout le monde
最省藍｜Most efficient｜Le plus efficace
最穩定｜Most stable｜Le plus stable
撐最久｜Lasts longest｜Tient le plus longtemps
沒有可以補的技能｜No healing spells to use｜Aucun sort de soin disponible
沒有可以單補的技能｜No single-target heals to use｜Aucun soin monocible disponible
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100Le plus efficace :|r %s 
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100Le plus stable :|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6bPersonne ne survit :|r meilleure option %s (%s)
%d 秒滅團｜wipe at %d sec｜wipe à %d s
倒 %d 人｜%d dead｜%d morts
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6bPersonne ne survit :|r meilleur temps %s (%d s)
活｜Alive｜Vivant
倒下 %d 秒｜Dead at %d sec｜Mort à %d s
滅團 %d 秒｜Wipe at %d sec｜Wipe à %d s
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d morts, premier décès à %d s
沒藍 %d 秒｜OOM at %d sec｜À court de mana à %d s
補滿差 ｜Short by ｜Il manque 
剩藍 ｜Mana left ｜Mana restant 
最低 %d%%｜Low %d%%｜Minimum %d%%
每 ｜Every ｜Toutes les 
 秒一發｜ sec｜ s
沒出手｜No casts｜Aucun sort lancé
不用喝水｜No drinking｜Pas besoin de boire
打完要喝水｜Drink after｜Boire après
可連打 %d 波｜%d pulls in a row｜%d groupes d’affilée
補到｜Healed｜Soins effectifs
溢補｜Overheal｜Soins excédentaires
施法｜Casts｜Sorts lancés
 次｜｜
、救命 ｜, emergency ｜, urgence 
倒下｜Deaths｜Décès
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d, premier décès à %d s
，坦克或自己倒下｜, tank or you died｜, vous ou le tank êtes mort
低於 30%｜Below 30%｜inférieur à 30 %
%d 人秒｜%d player-sec｜%d joueur-s
戰鬥結束｜Fight end｜Fin du combat
不喝水連打｜Pulls in a row｜Groupes d’affilée
 波｜｜
救命 ｜emergency ｜urgence 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜Tank %d%%, mana restant %s
技能提示的 HPS：｜Spell tooltip HPS: ｜HPS dans l’infobulle du sort : 
左鍵：開關比較表｜Left-click: toggle the table｜Clic gauche : afficher/masquer le comparatif
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜Clic droit : HPS dans l’infobulle (actuellement 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜Glisser : déplacer sur la minicarte
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜Version %s  API : %s  Grimoire : %d sorts
新版 C_SpellBook｜new C_SpellBook｜nouveau C_SpellBook
舊版｜legacy｜Ancienne
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜Classe %s  Niveau %d  Bonus aux soins %d  Valeurs des descriptions : %s  Talents : %s
已含治療效果｜include Bonus Healing｜bonus aux soins inclus
基礎量｜base only｜base uniquement
沒找到｜none｜aucun
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜Serment de lumière : bonus introuvable. Texte du talent : 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜Serment de lumière : Lumière sacrée + %d, Eclair lumineux + %d, Horion sacré + %d (%s)
比較表已計入｜included in the table｜inclus dans le tableau
比較表未計入｜not included in the table｜Non inclus dans le comparatif
已點天賦：｜Talents: ｜Talents : 
有｜Yes｜Oui
（比較表已計入）｜ (included in the table)｜ (inclus dans le tableau)
（比較表未計入）｜ (not included in the table)｜ (non inclus dans le tableau)
沒偵測到｜Not detected｜Non détecté
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜Aucun sort de soin correspondant. Premières entrées du grimoire : 
%s：法術書沒找到｜%s: not in spellbook｜%s : absent du grimoire
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s : nom en jeu « %s », rang max. %d (%d rangs avec ID). Analyse : %s
不解析｜not parsed｜Non analysé
失敗：｜failed: ｜Échec : 
說明未載入｜description not loaded｜description non chargée
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜Cette classe n’a pas de sort de soin. L’addon reste inactif.
小地圖按鈕：｜Minimap button: ｜Bouton de minicarte : 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜caché (tapez /shps minimap pour l'afficher)
顯示｜shown｜Affiché
治療加成 %：｜Healing bonus %: ｜% de bonus de guérison : 
（手動）｜ (manual)｜ (manuel)
依天賦自動｜auto from talents｜auto selon les talents
吸收加成 %：｜Absorb bonus %: ｜Bonus d’absorption % : 
群補目標數：｜Group targets: ｜Cibles des soins de groupe : 
滑鼠提示：｜Tooltip: ｜Infobulle : 
降級衰減：｜Downrank penalty: ｜Pénalité de rang inférieur : 
視窗縮放：｜Window scale: ｜Échelle de la fenêtre : 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜Utilisation : /shps scale 1.2 (0.5–2, actuel : 
技能說明數字：｜Spell description values: ｜Valeurs des descriptions de sort : 
已含治療效果（手動）｜include Bonus Healing (manual)｜bonus aux soins inclus (manuel)
只有基礎量（手動）｜base only (manual)｜base uniquement (manuel)
自動判斷｜auto｜automatique
　目前：｜  Now: ｜  Maintenant : 
直接採用說明數字｜using description values｜selon les valeurs de description
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜Base + bonus aux soins × coefficient
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜Langue de l’interface : %s (après /reload)
設定已重設｜Settings reset｜Paramètres réinitialisés
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps afficher ou masquer la fenêtre  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = test de mise en page, anglais allongé de 35 %)  /shps debug  /shps reset
```
