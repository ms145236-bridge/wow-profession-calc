-- Español de España (esES)
-- ui: interface text, keyed by the original Chinese text in Core.lua / Data.lua (same keys as enUS.lua)
-- game: patterns for reading this client's spell descriptions (tools/tooltips-esES.md, tested by tools/test-healing-locales.mjs),
--       and this client's names of the spells and talents in Data.lua / Core.lua (used only when the spell ID lookup returns nothing)
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.esES = {
  game = {
    rangeSeps = { "al" },                       -- "en 42 al 50 p."
    damageAfter = "^%s*p%.%s*de da",            -- "129 al 139 p. de daño Sagrado" is damage, not healing
    hot = "(%d+)%s*p%.",                        -- "Cura el objetivo en 32 p. durante 12 s."
    absorb = "absorbe%D-(%d+)",                 -- "absorbe 48 p. de daño"
    single = "(%d+)%s*p%.",                     -- "que lo sanará 172 p." (Prayer of Mending)
    tick = "(%d+)%s*p%..-cada%s+(%d+)", tickAmountFirst = true, -- "Regenera 91 p. ... cada 2 s"
    tickDur = "cada%s+%d+%s*s%.?%s+durante%s+(%d+)", -- "cada 2 s durante 10 s."
    extra = "otros?%D-(%d+)",                   -- "y otro en 91 p."
    dur = "durante%s+(%d+)%s*s",                -- "durante 21 s."
    thousands = { "%." },                       -- "1.111"
    spells = {
      ["聖光術"] = "Luz Sagrada", ["聖光閃現"] = "Destello de Luz", ["神聖震擊"] = "Choque Sagrado", ["聖光戒備"] = "Vigilia de la Luz",
      ["聖光守望"] = "Vigilia de la Luz", ["次級治療術"] = "Curación inferior", ["治療術"] = "Curar", ["快速治療"] = "Destello curativo",
      ["強效治療術"] = "Curación superior", ["恢復"] = "Renovar", ["真言術：盾"] = "Palabra de poder: escudo", ["治療禱言"] = "Rezo de curación",
      ["懺悟"] = "Penitencia", ["苦修"] = "Penitencia", ["癒合禱言"] = "Rezo de alivio", ["愈合禱言"] = "Rezo de alivio",
      ["神聖新星"] = "Nova Sagrada", ["治療之觸"] = "Toque curativo", ["回春術"] = "Rejuvenecimiento", ["癒合"] = "Recrecimiento",
      ["愈合"] = "Recrecimiento", ["寧靜"] = "Tranquilidad", ["野性痊癒"] = "Crecimiento salvaje", ["野性成長"] = "Crecimiento salvaje",
      ["治療波"] = "Onda de curación", ["次級治療波"] = "Onda inferior de curación", ["治療鍊"] = "Curación en cadena", ["治療鏈"] = "Curación en cadena",
      ["激流"] = "Mareas vivas", ["治療之光"] = "Luz curativa", ["精神治療"] = "Curación espiritual", ["強化真言術：盾"] = "Poder de la palabra mejorado: escudo",
      ["自然賜福"] = "Regalo de la Naturaleza", ["淨化"] = "Purificación", ["聖光誓約"] = "Juramento de luz", ["聖光誓言"] = "Juramento de luz",
    },
  },
  ui = {
    -- product, chat
    ["|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r "] = "|cff4fc3f7Sheng|r|cffd9b25fSanación|r ",
    ["阿聖治療幫手"] = "Sheng Sanación",
    ["|cffff7b7b%s出錯：|r%s　請把這行回報給開發者"] = "|cffff7b7b%s: error|r %s. Envía esta línea al desarrollador.",
    -- where an error happened
    ["滑鼠提示"] = "Descripción emergente", ["分析"] = "Análisis", ["比較表"] = "Comparativa", ["除錯指令"] = "Comando de depuración",
    ["掛上滑鼠提示"] = "Gancho de descripción", ["小地圖按鈕"] = "Botón del minimapa",
    -- spell rows (Data.lua labels)
    ["聖光術"] = "Luz Sagrada", ["聖光閃現"] = "Destello de Luz", ["神聖震擊"] = "Choque Sagrado",
    ["聖光戒備→震擊"] = "Vigilia de la Luz > Choque",
    ["次級治療術"] = "Curación inferior", ["治療術"] = "Curar", ["快速治療"] = "Destello curativo", ["強效治療術"] = "Curación superior",
    ["恢復"] = "Renovar", ["真言術：盾"] = "Palabra de poder: escudo", ["治療禱言"] = "Rezo de curación", ["懺悟"] = "Penitencia",
    ["癒合禱言"] = "Rezo de alivio", ["神聖新星（治療）"] = "Nova Sagrada (sanación)",
    ["治療之觸"] = "Toque curativo", ["回春術"] = "Rejuvenecimiento", ["癒合（不含HoT）"] = "Recrecimiento (directa)", ["癒合"] = "Recrecimiento",
    ["寧靜"] = "Tranquilidad", ["野性痊癒"] = "Crecimiento salvaje",
    ["治療波"] = "Onda de curación", ["次級治療波"] = "Onda inferior de curación", ["治療鍊"] = "Curación en cadena", ["激流"] = "Mareas vivas",
    -- spell notes (Data.lua)
    ["CD 10s；永恆治療之光也乘震擊"] = "10 s de reutilización. En Forever, Luz curativa también potencia el Choque.",
    ["戒備 CD 6s；只計小隊治療"] = "Vigilia: 6 s de reutilización. Solo sana al grupo.",
    ["法術書可見 774–910；以降級計算器客戶端為準"] = "El libro muestra 774–910. Se usan los valores del cliente para rangos inferiores.",
    ["HoT 總量／15秒"] = "Sanación periódica total en 15 s",
    ["吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）"] = "Absorción. Reutilización base: 4 s. Alma debilitada: 15 s por objetivo (sin verificar en Forever).",
    ["目標及其小隊每人此量"] = "Cura a cada miembro del grupo objetivo por esta cantidad",
    ["3×133／跳；CD 12；係數待核"] = "3 pulsos de 133. Reutilización: 12 s. Coeficiente sin verificar.",
    ["每跳等量；最多5跳；CD 10"] = "Misma cantidad por salto; hasta 5 saltos; Reutilización de 10 segundos",
    ["治療分量；係數待核"] = "Solo la parte de sanación. Coeficiente sin verificar.",
    ["Forever 確認總量／12秒"] = "Total durante 12 s, confirmado en Forever.",
    ["僅直接；HoT 另列"] = "Solo sanación directa. La periódica figura aparte.",
    ["HoT 91/21s（客戶端）；直接 0.286、HoT 0.497"] = "Periódica: 91 en 21 s (cliente). Coeficiente directo 0,286 y periódico 0,497.",
    ["引導；每人總量；長CD"] = "Canalizado. Total por persona. Reutilización larga.",
    ["cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否"] = "3 s de lanzamiento y 6 s de reutilización (ForeverChanges). No es instantáneo.",
    ["第1跳=基礎；總量1+0.5+0.25"] = "Primer salto: valor base. Total: 1 + 0,5 + 0,25.",
    ["僅HoT；CD 12；無瞬發"] = "Solo sanación periódica. 12 s de reutilización. No tiene sanación directa.",
    -- situational bonuses
    ["聖光誓約"] = "Juramento de luz", ["誓約目標"] = "Objetivo del juramento",
    ["對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。"] =
      "Bonificación fija a Luz Sagrada, Destello de Luz y Choque Sagrado sobre el objetivo del juramento. Si se incluye, la tabla usa esos valores.",
    ["聖光束縛"] = "Vinculación sagrada", ["對他人施放（含自療）"] = "Sobre otros (con autosanación)",
    ["快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。"] =
      "Destello curativo sobre otro objetivo también te sana un 50 % de esa cantidad. Si se incluye, la tabla suma la autosanación.",
    ["激流加成"] = "Bonificación de Mareas vivas", ["目標有激流"] = "Objetivo con Mareas vivas",
    ["目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。"] =
      "Curación en cadena sobre un objetivo con tu Mareas vivas sana un 25 % más en el primer salto. Si se incluye, la tabla usa ese valor.",
    ["綻放"] = "Floración", ["含綻放"] = "Con Floración",
    ["回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。"] =
      "Cuando termina la sanación periódica de Rejuvenecimiento o Recrecimiento, el objetivo recupera salud igual al 100 % de tu espíritu (50 % si se disipa). Si se incluye, la tabla la suma.",
    ["沒學"] = "No aprendido", ["計入"] = "Incluido", ["不計入"] = "Excluido",
    -- talents
    ["讀不到"] = "no encontrado", ["經典"] = "Classic",
    ["%s %d/%d（+%d%%）"] = "%s %d/%d (+%d%%)",
    ["天賦加成"] = "Bonificaciones de talentos", ["沒有偵測到治療加成天賦"] = "No se detectaron talentos de sanación.",
    ["治療加成 "] = "Bonificación de sanación ", ["%（手動）"] = "% (manual)",
    ["聖光誓約：讀不到加成量（請執行 /shps debug 回報）"] = "Juramento de luz: bonificación no encontrada (ejecute /shps debug e infórmelo)",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d"] = "Juramento de luz: Luz Sagrada +%d, Destello de Luz +%d, Choque Sagrado +%d",
    ["綻放：每次 HoT 結束 +"] = "Floración al expirar cada sanación periódica: +",
    -- shared bits (symbols: Latin-1 and plain punctuation only, other glyphs turn into boxes)
    ["…"] = "...", ["▼"] = "v ", ["★"] = "*",
    ["："] = ": ", ["、"] = ", ", ["＋"] = " + ", ["（"] = " (", ["）"] = ")", [" ／ "] = " / ",
    [" 等級"] = " Rango ", [" 秒"] = " s", ["開"] = "Sí", ["關"] = "No",
    ["單補"] = "Individual", ["群補"] = "Grupo", ["冷卻"] = "Reutilización", ["救命"] = "Emergencia",
    -- analysis names
    ["保持"] = "Mantén ", ["鋪"] = "Reparte ", ["，救命 "] = ", de emergencia ",
    ["（停到 %d%%）"] = " (espera hasta el %d%%)", ["（救命 %s）"] = " (%s de emergencia)",
    ["，坦克快倒時改放 %s"] = ", %s si el tanque tiene poca salud",
    ["戰鬥中不分析"] = "No disponible en combate", ["讀不到回藍"] = "No se pudo leer la regeneración de maná",
    -- breakdown lines
    ["%d 秒內補完；冷卻 %s 秒"] = "Sana en %d s, reutilización de %s s",
    ["冷卻 %s 秒"] = "%s s de reutilización",
    ["直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%"] = "Sanación directa: %s (%s/s) + %d s de sanación periódica %s. Al alternar entre %d objetivos, cada efecto dura el %d%%.",
    ["直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s"] = "Sanación directa %s (%s/s) + %d s de sanación periódica %s (%s/s)\nAl alternar objetivos: %s/s",
    ["%d 秒內補完；鋪 %d 人"] = "Sana en %d s, repartido entre %d objetivos",
    ["%d 秒內補完；輪流掛不同目標時每秒 %s"] = "Sana en %d s. Al alternar objetivos: %s/s",
    ["同一目標 15 秒一次；輪流上不同目標時每秒 %s"] = "Una vez cada 15 s por objetivo. Al alternar: %s/s",
    -- spell tooltip
    ["（吸收）"] = " (absorción)", ["（%d人）"] = " (%d objetivos)", ["|cffd9b25fHPS ／ HPM|r"] = "|cffd9b25fHPS / HPM|r",
    ["降級"] = "Rango inferior", ["治療效果只算 %d%%"] = "%d%% de la bonificación de sanación",
    ["★ %s HPS最高"] = "* Mejor HPS (%s)", ["★ %s HPM最高"] = "* Mejor HPM (%s)",
    -- window
    ["拖曳調整視窗大小"] = "Arrastra para ajustar el tamaño",
    ["設定"] = "Ajustes",
    ["技能"] = "Hechizo", ["等級"] = "Rango", ["有效量"] = "Sanación", ["法力"] = "Maná", ["秒"] = "s",
    ["%d 級 · 治療效果 %d"] = "Nivel %d · Bonificación de sanación %d", [" · 精神 %d"] = " · Espíritu %d",
    [" · 回藍 停手 %d／施法 %d（每 5 秒）"] = " · Reg. de maná: %d sin lanzar / %d al lanzar (cada 5 s)",
    ["技能提示："] = "Descripción del hechizo: ", ["精簡"] = "Breve", ["標準"] = "Estándar", ["完整"] = "Completo",
    ["群補人數 "] = "Objetivos de grupo ",
    ["HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r"] =
      "HPS = sanación ÷ tiempo de lanzamiento\n|cff9a9282Los hechizos instantáneos cuentan como 1,5 s.\nLa sanación periódica usa su duración. «Grupo» cuenta cuántos objetivos puedes mantener cubiertos.\nLos hechizos con reutilización tienen su propia pestaña y se calculan por lanzamiento.|r",
    ["（吸收）|r"] = " (absorción)|r",
    ["這一頁沒有你學會的技能。"] = "No hay hechizos aprendidos en esta pestaña.",
    ["|cffffd100★ HPS最高|r %s 等級%d"] = "|cffffd100* Mejor HPS|r %s rango %d", ["|cff66ff66★ HPM最高|r %s 等級%d"] = "|cff66ff66* Mejor HPM|r %s rango %d",
    ["目前沒有可比較的治療技能（吸收盾不參加比較）"] = "No hay hechizos de sanación para comparar (se excluye la absorción).",
    ["（滾輪看更多）"] = "(desplázate para ver más)",
    ["吸收量不是治療量，不參加 HPS／HPM 最高的比較"] = "La absorción no cuenta para los mejores valores de HPS/HPM.",
    ["學習等級"] = "Se aprende al nivel", ["（%d%%）"] = " (%d%%)",
    ["部分數值來自資料表（遊戲讀不到）"] = "Algunos valores provienen de la tabla de datos (no legible en el juego)",
    -- analysis tab
    ["單坦"] = "Tanque", ["團刷"] = "Grupo",
    ["小怪"] = "Enemigos", ["王戰"] = "Jefe", ["單練"] = "En solitario", ["省水"] = "Fácil",
    ["群怪"] = "Enemigos", ["全團技"] = "Área de banda", ["範圍"] = "Área", ["點名"] = "Dirigido",
    ["詳細"] = "Detalles",
    ["坦克生命 %d"] = "Salud del tanque %d", ["每次傷害 %d"] = "Daño por golpe %d", ["受傷間隔 %.1f 秒"] = "Intervalo de acierto %.1f seg.",
    ["戰鬥長度 %d 秒"] = "Duración de la pelea %d seg", ["人數 %d"] = "Tamaño del grupo %d", ["成員生命 %d"] = "Salud por miembro %d",
    ["坦克每次傷害 %d"] = "Golpe al tanque %d", ["坦克每次傷害 無"] = "Sin golpes al tanque", ["坦克間隔 %.1f 秒"] = "Golpe al tanque cada %.1f s",
    ["範圍每次傷害 %d"] = "Daño de área por golpe %d", ["範圍每次傷害 無"] = "Sin daño de área", ["範圍間隔 %.1f 秒"] = "Daño de área cada %.1f s",
    ["範圍命中 隨機 %d 人"] = "El área alcanza a %d objetivos aleatorios", ["範圍命中 全員"] = "El área alcanza a todos",
    ["最省藍"] = "Más eficiente", ["最穩定"] = "Más estable", ["撐最久"] = "Dura más",
    ["沒有可以補的技能"] = "No hay hechizos de sanación disponibles", ["沒有可以單補的技能"] = "No hay sanación individual disponible",
    ["|cffffd100最省藍：|r%s"] = "|cffffd100Más eficiente:|r %s", ["|cffffd100最穩定：|r%s"] = "|cffffd100Más estable:|r %s",
    ["|cffff6b6b都撐不住：|r最好 %s（%s）"] = "|cffff6b6bNadie sobrevive:|r mejor opción %s (%s)",
    ["%d 秒滅團"] = "derrota a los %d s", ["倒 %d 人"] = "%d bajas",
    ["|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）"] = "|cffff6b6bNadie sobrevive:|r mayor duración %s (%d s)",
    ["活"] = "Vivo", ["倒下 %d 秒"] = "Muerte a los %d s", ["滅團 %d 秒"] = "Derrota a los %d s", ["倒 %d 人 %d 秒"] = "%d bajas, la primera a los %d s",
    ["沒藍 %d 秒"] = "Sin maná a los %d s", ["補滿差 "] = "Faltan ", ["剩藍 "] = "Maná restante ", ["最低 %d%%"] = "Mínimo %d%%",
    ["每 "] = "Cada ", [" 秒一發"] = " s", ["沒出手"] = "Sin lanzamientos",
    ["不用喝水"] = "No hace falta beber", ["打完要喝水"] = "Bebe al terminar", ["可連打 %d 波"] = "%d grupos seguidos",
    ["補到"] = "Sanación efectiva", ["溢補"] = "Sobresanación", ["施法"] = "Lanzamientos", [" 次"] = "", ["、救命 "] = ", emergencia ",
    ["倒下"] = "Muertes", ["%d 人，第一人 %d 秒"] = "%d, primera baja a los %d s", ["，坦克或自己倒下"] = ", tú o el tanque murió",
    ["低於 30%"] = "Por debajo del 30 %", ["%d 人秒"] = "%d jugador-s", ["戰鬥結束"] = "Fin de la pelea",
    ["不喝水連打"] = "Grupos seguidos", [" 波"] = "", ["救命 "] = "emergencia ",
    ["坦克 %d%%、剩藍 %s"] = "Tanque %d%%, maná restante %s",
    -- minimap
    ["技能提示的 HPS："] = "HPS en la descripción del hechizo: ",
    ["左鍵：開關比較表"] = "Clic izq.: mostrar u ocultar la tabla",
    ["右鍵：開關技能提示的 HPS（目前"] = "Clic der.: alternar HPS en descripciones (ahora ",
    ["拖曳：沿著小地圖移動"] = "Arrastra para moverlo por el minimapa",
    -- debug
    ["版本 %s　API：%s　法術書共 %d 個技能"] = "Versión %s  API: %s  Libro: %d hechizos",
    ["新版 C_SpellBook"] = "nuevo C_SpellBook", ["舊版"] = "Version anterior",
    ["職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s"] = "Clase %s  Nivel %d  Bonificación de sanación %d  Valores de la descripción: %s  Talentos: %s",
    ["已含治療效果"] = "incluye bonificación de sanación", ["基礎量"] = "solo valor base", ["沒找到"] = "ninguno",
    ["聖光誓約：讀不到加成量。天賦說明："] = "Juramento de luz: no se encontró la bonificación. Texto del talento: ",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）"] = "Juramento de luz: Luz Sagrada +%d, Destello de Luz +%d, Choque Sagrado +%d (%s)",
    ["比較表已計入"] = "incluido en la tabla", ["比較表未計入"] = "No incluido en la tabla",
    ["已點天賦："] = "Talentos: ", ["有"] = "Sí",
    ["（比較表已計入）"] = " (incluido en la tabla)", ["（比較表未計入）"] = " (no incluido en la tabla)",
    ["沒偵測到"] = "No detectado",
    ["一個治療技能都沒對上。法術書前幾個技能："] = "No se encontró ningún hechizo de sanación. Primeras entradas del libro: ",
    ["%s：法術書沒找到"] = "%s: no está en el libro de hechizos",
    ["%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s"] = "%s: nombre en el juego «%s», hasta el rango %d (%d rangos con ID). Análisis: %s",
    ["不解析"] = "Sin analizar", ["失敗："] = "Error: ", ["說明未載入"] = "descripción sin cargar",
    -- slash commands
    ["這個職業沒有治療技能，插件不會運作。"] = "Esta clase no tiene hechizos de sanación. El addon queda inactivo.",
    ["小地圖按鈕："] = "Botón del minimapa: ", ["隱藏（再輸入 /shps minimap 顯示）"] = "oculto (escriba /shps minimap para mostrarlo)", ["顯示"] = "Visible",
    ["治療加成 %："] = "% de bonificación de curación: ", ["（手動）"] = " (manual)", ["依天賦自動"] = "auto según los talentos",
    ["吸收加成 %："] = "Bonificación de absorción %: ", ["群補目標數："] = "Objetivos de grupo: ",
    ["滑鼠提示："] = "Descripción emergente: ", ["降級衰減："] = "Penalización por rango inferior: ", ["視窗縮放："] = "Escala de la ventana: ",
    ["用法：/shps scale 1.2（0.5～2，目前 "] = "Uso: /shps scale 1.2 (0.5–2, actual: ",
    ["技能說明數字："] = "Valores de la descripción: ",
    ["已含治療效果（手動）"] = "incluye bonificación de sanación (manual)", ["只有基礎量（手動）"] = "solo valor base (manual)", ["自動判斷"] = "automático",
    ["　目前："] = "  Ahora: ", ["直接採用說明數字"] = "usa valores de la descripción", ["基礎＋治療效果×係數"] = "Base + bonificación de sanación × coeficiente",
    ["介面語言：%s（/reload 後生效）"] = "Idioma de la interfaz: %s (tras /reload)",
    ["設定已重設"] = "Ajustes restablecidos",
    ["/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset"] =
      "/shps mostrar u ocultar la ventana  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = prueba de diseño, inglés un 35 % más largo)  /shps debug  /shps reset",
  },
}
