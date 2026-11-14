-- Français (frFR)
-- ui: interface text, keyed by the original Chinese text in Core.lua / Data.lua (same keys as enUS.lua)
-- game: patterns for reading this client's spell descriptions (tools/tooltips-frFR.md, tested by tools/test-healing-locales.mjs),
--       and this client's names of the spells and talents in Data.lua / Core.lua (used only when the spell ID lookup returns nothing)
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.frFR = {
  game = {
    rangeSeps = { "à" },                        -- "Rend 42 à 50 points de vie"
    damageAfter = "^%s*points? de d",           -- "129 à 139 points de dégâts du sacré" is damage, not healing
    hot = "(%d+)%s*points de vie",              -- "Rend 45 points de vie à la cible en 15 sec."
    absorb = "absorbe%D-(%d+)",                 -- "absorbe 48 points de dégâts"
    single = "rend%s+(%d+)%s*points de vie",    -- "un sort qui lui rend 172 points de vie" (Prayer of Mending)
    tick = "de%s+(%d+)%s+les%s+points.-toutes les%s+(%d+)", tickAmountFirst = true, -- "Régénère de 91 les points de vie ... toutes les 2 s"
    tickDur = "toutes les%s+%d+%s*s%.?%s+pendant%s+(%d+)", -- "toutes les 2 s pendant 10 sec."
    extra = "(%d+)%s+points suppl",             -- "pour 91 points supplémentaires"
    dur = "(%d+)%s*sec",                        -- "pendant 21 sec." / "en 15 sec."
    thousands = { "%s" },                       -- "1 111" (Core.lua turns no-break spaces into spaces first)
    spells = {
      ["聖光術"] = "Lumière sacrée", ["聖光閃現"] = "Eclair lumineux", ["神聖震擊"] = "Horion sacré", ["聖光戒備"] = "Vigile de Lumière",
      ["聖光守望"] = "Vigile de Lumière", ["次級治療術"] = "Soins inférieurs", ["治療術"] = "Soins", ["快速治療"] = "Soins rapides",
      ["強效治療術"] = "Soins supérieurs", ["恢復"] = "Rénovation", ["真言術：盾"] = "Mot de pouvoir : Bouclier", ["治療禱言"] = "Prière de soins",
      ["懺悟"] = "Pénitence", ["苦修"] = "Pénitence", ["癒合禱言"] = "Prière de guérison", ["愈合禱言"] = "Prière de guérison",
      ["神聖新星"] = "Nova sacrée", ["治療之觸"] = "Toucher guérisseur", ["回春術"] = "Récupération", ["癒合"] = "Rétablissement",
      ["愈合"] = "Rétablissement", ["寧靜"] = "Tranquillité", ["野性痊癒"] = "Croissance sauvage", ["野性成長"] = "Croissance sauvage",
      ["治療波"] = "Vague de soins", ["次級治療波"] = "Vague de soins inférieurs", ["治療鍊"] = "Salve de guérison", ["治療鏈"] = "Salve de guérison",
      ["激流"] = "Remous", ["治療之光"] = "Lumière guérisseuse", ["精神治療"] = "Soins spirituels", ["強化真言術：盾"] = "Mot de pouvoir : Bouclier amélioré",
      ["自然賜福"] = "Don de la Nature", ["聖光誓約"] = "Serment de lumière", ["聖光誓言"] = "Serment de lumière",
    },
  },
  ui = {
    -- product, chat
    ["|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r "] = "|cff4fc3f7Sheng|r|cffd9b25fSoins|r ",
    ["阿聖治療幫手"] = "Sheng Soins",
    ["|cffff7b7b%s出錯：|r%s　請把這行回報給開發者"] = "|cffff7b7b%s : erreur|r %s. Merci de transmettre cette ligne au développeur.",
    -- where an error happened
    ["滑鼠提示"] = "Infobulle", ["分析"] = "Analyse", ["比較表"] = "Comparatif", ["除錯指令"] = "Commande de débogage",
    ["掛上滑鼠提示"] = "Hook d’infobulle", ["小地圖按鈕"] = "Bouton de minicarte",
    -- spell rows (Data.lua labels)
    ["聖光術"] = "Lumière sacrée", ["聖光閃現"] = "Eclair lumineux", ["神聖震擊"] = "Horion sacré",
    ["聖光戒備→震擊"] = "Vigile de Lumière > Horion",
    ["次級治療術"] = "Soins inférieurs", ["治療術"] = "Soins", ["快速治療"] = "Soins rapides", ["強效治療術"] = "Soins supérieurs",
    ["恢復"] = "Rénovation", ["真言術：盾"] = "Mot de pouvoir : Bouclier", ["治療禱言"] = "Prière de soins", ["懺悟"] = "Pénitence",
    ["癒合禱言"] = "Prière de guérison", ["神聖新星（治療）"] = "Nova sacrée (soins)",
    ["治療之觸"] = "Toucher guérisseur", ["回春術"] = "Récupération", ["癒合（不含HoT）"] = "Rétablissement (soin direct)", ["癒合"] = "Rétablissement",
    ["寧靜"] = "Tranquillité", ["野性痊癒"] = "Croissance sauvage",
    ["治療波"] = "Vague de soins", ["次級治療波"] = "Vague de soins inférieurs", ["治療鍊"] = "Salve de guérison", ["激流"] = "Remous",
    -- spell notes (Data.lua)
    ["CD 10s；永恆治療之光也乘震擊"] = "Recharge de 10 s. Dans Forever, Lumière guérisseuse renforce aussi le Horion.",
    ["戒備 CD 6s；只計小隊治療"] = "Vigile : recharge de 6 s. Soins du groupe uniquement.",
    ["法術書可見 774–910；以降級計算器客戶端為準"] = "Le grimoire affiche 774–910. Le calcul utilise les valeurs du client pour les rangs inférieurs.",
    ["HoT 總量／15秒"] = "Soins périodiques cumulés sur 15 s",
    ["吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）"] = "Absorption. Recharge de base : 4 s. Ame affaiblie : 15 s par cible (à vérifier dans Forever).",
    ["目標及其小隊每人此量"] = "Soigne chaque membre du groupe de la cible pour ce montant",
    ["3×133／跳；CD 12；係數待核"] = "3 impulsions de 133. Recharge de 12 s. Coefficient à vérifier.",
    ["每跳等量；最多5跳；CD 10"] = "Même montant par saut ; jusqu'à 5 sauts ; Temps de recharge de 10 secondes",
    ["治療分量；係數待核"] = "Soins uniquement. Coefficient à vérifier.",
    ["Forever 確認總量／12秒"] = "Total sur 12 s, confirmé dans Forever.",
    ["僅直接；HoT 另列"] = "Soin direct uniquement. Soins périodiques à part.",
    ["HoT 91/21s（客戶端）；直接 0.286、HoT 0.497"] = "Soins périodiques : 91 sur 21 s (client). Coefficients : 0,286 en direct, 0,497 en périodique.",
    ["引導；每人總量；長CD"] = "Canalisé. Total par personne. Recharge longue.",
    ["cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否"] = "Incantation de 3 s, recharge de 6 s (ForeverChanges). Pas instantané.",
    ["第1跳=基礎；總量1+0.5+0.25"] = "Premier rebond = valeur de base. Total : 1 + 0,5 + 0,25.",
    ["僅HoT；CD 12；無瞬發"] = "Soins périodiques uniquement. Recharge de 12 s. Aucun soin direct.",
    -- situational bonuses
    ["聖光誓約"] = "Serment de lumière", ["誓約目標"] = "Cible du serment",
    ["對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。"] =
      "Bonus fixe à Lumière sacrée, Eclair lumineux et Horion sacré sur la cible du serment. Si activé, le tableau utilise ces valeurs.",
    ["聖光束縛"] = "Lien sacré", ["對他人施放（含自療）"] = "Sur autrui (avec soin personnel)",
    ["快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。"] =
      "Soins rapides sur autrui vous rend aussi 50 % du soin. Si activé, le tableau inclut ce soin personnel.",
    ["激流加成"] = "Bonus de Remous", ["目標有激流"] = "Cible sous Remous",
    ["目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。"] =
      "Salve de guérison soigne 25 % de plus au premier rebond si votre Remous est sur la cible. Si activé, le tableau utilise cette valeur.",
    ["綻放"] = "Floraison", ["含綻放"] = "Avec Floraison",
    ["回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。"] =
      "À l’expiration du soin périodique de Récupération ou de Rétablissement, la cible récupère 100 % de votre Esprit (50 % si dissipé). Si activé, le tableau l’inclut.",
    ["沒學"] = "Non appris", ["計入"] = "Inclus", ["不計入"] = "Exclu",
    -- talents
    ["讀不到"] = "introuvable", ["經典"] = "Classic",
    ["%s %d/%d（+%d%%）"] = "%s %d/%d (+%d%%)",
    ["天賦加成"] = "Bonus de talents", ["沒有偵測到治療加成天賦"] = "Aucun talent de soin détecté.",
    ["治療加成 "] = "Bonus aux soins ", ["%（手動）"] = "% (manuel)",
    ["聖光誓約：讀不到加成量（請執行 /shps debug 回報）"] = "Serment de lumière : bonus introuvable (exécutez /shps debug et signalez-le)",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d"] = "Serment de lumière : Lumière sacrée + %d, Eclair lumineux + %d, Horion sacré + %d",
    ["綻放：每次 HoT 結束 +"] = "Floraison à chaque fin de soin périodique : +",
    -- shared bits (symbols: Latin-1 and plain punctuation only, other glyphs turn into boxes)
    ["…"] = "...", ["▼"] = "v ", ["★"] = "*",
    ["："] = ": ", ["、"] = ", ", ["＋"] = " + ", ["（"] = " (", ["）"] = ")", [" ／ "] = " / ",
    [" 等級"] = " Rang ", [" 秒"] = " s", ["開"] = "Oui", ["關"] = "Non",
    ["單補"] = "Monocible", ["群補"] = "Groupe", ["冷卻"] = "Recharge", ["救命"] = "Urgence",
    -- analysis names
    ["保持"] = "Maintenir : ", ["鋪"] = "Répartir : ", ["，救命 "] = ", en urgence ",
    ["（停到 %d%%）"] = " (attendre %d%%)", ["（救命 %s）"] = " (%s en urgence)",
    ["，坦克快倒時改放 %s"] = ", %s si le tank est bas en vie",
    ["戰鬥中不分析"] = "Non disponible en combat", ["讀不到回藍"] = "Régénération de mana indisponible",
    -- breakdown lines
    ["%d 秒內補完；冷卻 %s 秒"] = "Soigne sur %d s, recharge de %s s",
    ["冷卻 %s 秒"] = "Recharge de %s s",
    ["直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%"] = "Soin direct %s (%s/s) + %d s de soins périodiques %s. Sur %d cibles, chaque effet atteint %d%% de sa durée.",
    ["直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s"] = "Soin direct %s (%s/s) + %d s de soins périodiques %s (%s/s)\nEn alternant les cibles : %s/s",
    ["%d 秒內補完；鋪 %d 人"] = "Soigne sur %d s, réparti sur %d cibles",
    ["%d 秒內補完；輪流掛不同目標時每秒 %s"] = "Soigne sur %d s. En alternant les cibles : %s/s",
    ["同一目標 15 秒一次；輪流上不同目標時每秒 %s"] = "Une fois toutes les 15 s par cible. En alternant : %s/s",
    -- spell tooltip
    ["（吸收）"] = " (absorption)", ["（%d人）"] = " (%d cibles)", ["|cffd9b25fHPS ／ HPM|r"] = "|cffd9b25fHPS / HPM|r",
    ["降級"] = "Rang inférieur", ["治療效果只算 %d%%"] = "%d%% du bonus aux soins",
    ["★ %s HPS最高"] = "* Meilleur HPS (%s)", ["★ %s HPM最高"] = "* Meilleur HPM (%s)",
    -- window
    ["拖曳調整視窗大小"] = "Faites glisser pour redimensionner",
    ["設定"] = "Paramètres",
    ["技能"] = "Sort", ["等級"] = "Rang", ["有效量"] = "Soins", ["法力"] = "Mana", ["秒"] = "s",
    ["%d 級 · 治療效果 %d"] = "Niveau %d · Bonus aux soins %d", [" · 精神 %d"] = " · Esprit %d",
    [" · 回藍 停手 %d／施法 %d（每 5 秒）"] = " · Mana/5 s : %d au repos / %d en incant.",
    ["技能提示："] = "Infobulle du sort : ", ["精簡"] = "Court", ["標準"] = "Standard", ["完整"] = "Complet",
    ["群補人數 "] = "Cibles des soins de groupe ",
    ["HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r"] =
      "HPS = soins ÷ temps d’incantation\n|cff9a9282Les sorts instantanés comptent pour 1,5 s.\nLes soins périodiques utilisent leur durée. « Groupe » compte les cibles sur lesquelles ils peuvent être maintenus.\nLes sorts à recharge ont leur onglet et se calculent par lancement.|r",
    ["（吸收）|r"] = " (absorption)|r",
    ["這一頁沒有你學會的技能。"] = "Aucun sort appris dans cet onglet.",
    ["|cffffd100★ HPS最高|r %s 等級%d"] = "|cffffd100* Meilleur HPS|r %s rang %d", ["|cff66ff66★ HPM最高|r %s 等級%d"] = "|cff66ff66* Meilleur HPM|r %s rang %d",
    ["目前沒有可比較的治療技能（吸收盾不參加比較）"] = "Aucun sort de soin à comparer (hors absorptions).",
    ["（滾輪看更多）"] = "(faites défiler pour voir la suite)",
    ["吸收量不是治療量，不參加 HPS／HPM 最高的比較"] = "Les absorptions sont exclues du classement HPS/HPM.",
    ["學習等級"] = "Niveau requis", ["（%d%%）"] = " (%d%%)",
    ["部分數值來自資料表（遊戲讀不到）"] = "Certaines valeurs proviennent de la table de données (non lisible en jeu)",
    -- analysis tab
    ["單坦"] = "Tank", ["團刷"] = "Groupe",
    ["小怪"] = "Ennemis", ["王戰"] = "Boss", ["單練"] = "Solo", ["省水"] = "Facile",
    ["群怪"] = "Ennemis", ["全團技"] = "Zone de raid", ["範圍"] = "Zone", ["點名"] = "Ciblé",
    ["詳細"] = "Détails",
    ["坦克生命 %d"] = "PV du tank %d", ["每次傷害 %d"] = "Dégâts par coup %d", ["受傷間隔 %.1f 秒"] = "Intervalle de frappe %.1f sec",
    ["戰鬥長度 %d 秒"] = "Durée du combat %d sec", ["人數 %d"] = "Taille du groupe %d", ["成員生命 %d"] = "PV par membre %d",
    ["坦克每次傷害 %d"] = "Dégâts par coup sur le tank %d", ["坦克每次傷害 無"] = "Aucun coup sur le tank", ["坦克間隔 %.1f 秒"] = "Coups sur le tank toutes les %.1f s",
    ["範圍每次傷害 %d"] = "Dégâts de zone par coup %d", ["範圍每次傷害 無"] = "Aucun dégât de zone", ["範圍間隔 %.1f 秒"] = "Dégâts de zone toutes les %.1f s",
    ["範圍命中 隨機 %d 人"] = "La zone touche %d cibles aléatoires", ["範圍命中 全員"] = "La zone touche tout le monde",
    ["最省藍"] = "Le plus efficace", ["最穩定"] = "Le plus stable", ["撐最久"] = "Tient le plus longtemps",
    ["沒有可以補的技能"] = "Aucun sort de soin disponible", ["沒有可以單補的技能"] = "Aucun soin monocible disponible",
    ["|cffffd100最省藍：|r%s"] = "|cffffd100Le plus efficace :|r %s ", ["|cffffd100最穩定：|r%s"] = "|cffffd100Le plus stable :|r %s",
    ["|cffff6b6b都撐不住：|r最好 %s（%s）"] = "|cffff6b6bPersonne ne survit :|r meilleure option %s (%s)",
    ["%d 秒滅團"] = "wipe à %d s", ["倒 %d 人"] = "%d morts",
    ["|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）"] = "|cffff6b6bPersonne ne survit :|r meilleur temps %s (%d s)",
    ["活"] = "Vivant", ["倒下 %d 秒"] = "Mort à %d s", ["滅團 %d 秒"] = "Wipe à %d s", ["倒 %d 人 %d 秒"] = "%d morts, premier décès à %d s",
    ["沒藍 %d 秒"] = "À court de mana à %d s", ["補滿差 "] = "Il manque ", ["剩藍 "] = "Mana restant ", ["最低 %d%%"] = "Minimum %d%%",
    ["每 "] = "Toutes les ", [" 秒一發"] = " s", ["沒出手"] = "Aucun sort lancé",
    ["不用喝水"] = "Pas besoin de boire", ["打完要喝水"] = "Boire après", ["可連打 %d 波"] = "%d groupes d’affilée",
    ["補到"] = "Soins effectifs", ["溢補"] = "Soins excédentaires", ["施法"] = "Sorts lancés", [" 次"] = "", ["、救命 "] = ", urgence ",
    ["倒下"] = "Décès", ["%d 人，第一人 %d 秒"] = "%d, premier décès à %d s", ["，坦克或自己倒下"] = ", vous ou le tank êtes mort",
    ["低於 30%"] = "inférieur à 30 %", ["%d 人秒"] = "%d joueur-s", ["戰鬥結束"] = "Fin du combat",
    ["不喝水連打"] = "Groupes d’affilée", [" 波"] = "", ["救命 "] = "urgence ",
    ["坦克 %d%%、剩藍 %s"] = "Tank %d%%, mana restant %s",
    -- minimap
    ["左鍵：開啟／關閉"] = "Clic gauche : ouvrir/fermer",
    ["右鍵：設定"] = "Clic droit : options",
    ["拖曳：沿著小地圖移動"] = "Glisser : déplacer sur la minicarte",
    -- debug
    ["版本 %s　API：%s　法術書共 %d 個技能"] = "Version %s  API : %s  Grimoire : %d sorts",
    ["新版 C_SpellBook"] = "nouveau C_SpellBook", ["舊版"] = "Ancienne",
    ["職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s"] = "Classe %s  Niveau %d  Bonus aux soins %d  Valeurs des descriptions : %s  Talents : %s",
    ["已含治療效果"] = "bonus aux soins inclus", ["基礎量"] = "base uniquement", ["沒找到"] = "aucun",
    ["聖光誓約：讀不到加成量。天賦說明："] = "Serment de lumière : bonus introuvable. Texte du talent : ",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）"] = "Serment de lumière : Lumière sacrée + %d, Eclair lumineux + %d, Horion sacré + %d (%s)",
    ["比較表已計入"] = "inclus dans le tableau", ["比較表未計入"] = "Non inclus dans le comparatif",
    ["已點天賦："] = "Talents : ", ["有"] = "Oui",
    ["（比較表已計入）"] = " (inclus dans le tableau)", ["（比較表未計入）"] = " (non inclus dans le tableau)",
    ["沒偵測到"] = "Non détecté",
    ["一個治療技能都沒對上。法術書前幾個技能："] = "Aucun sort de soin correspondant. Premières entrées du grimoire : ",
    ["%s：法術書沒找到"] = "%s : absent du grimoire",
    ["%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s"] = "%s : nom en jeu « %s », rang max. %d (%d rangs avec ID). Analyse : %s",
    ["不解析"] = "Non analysé", ["失敗："] = "Échec : ", ["說明未載入"] = "description non chargée",
    -- slash commands
    ["這個職業沒有治療技能，插件不會運作。"] = "Cette classe n’a pas de sort de soin. L’addon reste inactif.",
    ["小地圖按鈕："] = "Bouton de minicarte : ", ["隱藏（再輸入 /shps minimap 顯示）"] = "caché (tapez /shps minimap pour l'afficher)", ["顯示"] = "Affiché",
    ["治療加成 %："] = "% de bonus de guérison : ", ["（手動）"] = " (manuel)", ["依天賦自動"] = "auto selon les talents",
    ["吸收加成 %："] = "Bonus d’absorption % : ", ["群補目標數："] = "Cibles des soins de groupe : ",
    ["滑鼠提示："] = "Infobulle : ", ["降級衰減："] = "Pénalité de rang inférieur : ", ["視窗縮放："] = "Échelle de la fenêtre : ",
    ["用法：/shps scale 1.2（0.5～2，目前 "] = "Utilisation : /shps scale 1.2 (0.5–2, actuel : ",
    ["技能說明數字："] = "Valeurs des descriptions de sort : ",
    ["已含治療效果（手動）"] = "bonus aux soins inclus (manuel)", ["只有基礎量（手動）"] = "base uniquement (manuel)", ["自動判斷"] = "automatique",
    ["　目前："] = "  Maintenant : ", ["直接採用說明數字"] = "selon les valeurs de description", ["基礎＋治療效果×係數"] = "Base + bonus aux soins × coefficient",
    ["介面語言：%s（/reload 後生效）"] = "Langue de l’interface : %s (après /reload)",
    ["設定已重設"] = "Paramètres réinitialisés",
    ["/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset"] =
      "/shps afficher ou masquer la fenêtre  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = test de mise en page, anglais allongé de 35 %)  /shps debug  /shps reset",
    ["顯示小地圖按鈕"] = "Afficher le bouton de minicarte",
  },
}
