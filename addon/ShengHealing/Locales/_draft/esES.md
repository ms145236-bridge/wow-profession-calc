# ShengHealing UI · esES

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName esES](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=esES)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25fSanación|r 
阿聖治療幫手｜Sheng Healing｜Sheng Sanación
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s: error|r %s. Envía esta línea al desarrollador.
滑鼠提示｜Tooltip｜Descripción emergente
分析｜Analysis｜Análisis
比較表｜Table｜Comparativa
除錯指令｜Debug command｜Comando de depuración
掛上滑鼠提示｜Tooltip hook｜Gancho de descripción
小地圖按鈕｜Minimap button｜Botón del minimapa
聖光術｜Holy Light｜Luz Sagrada
聖光閃現｜Flash of Light｜Destello de Luz
神聖震擊｜Holy Shock｜Choque Sagrado
聖光戒備→震擊｜Light's Vigil > Shock｜Vigilia de la Luz > Choque
次級治療術｜Lesser Heal｜Curación inferior
治療術｜Heal｜Curar
快速治療｜Flash Heal｜Destello curativo
強效治療術｜Greater Heal｜Curación superior
恢復｜Renew｜Renovar
真言術：盾｜Power Word: Shield｜Palabra de poder: escudo
治療禱言｜Prayer of Healing｜Rezo de curación
懺悟｜Penance｜Penitencia
癒合禱言｜Prayer of Mending｜Rezo de alivio
神聖新星（治療）｜Holy Nova (heal)｜Nova Sagrada (sanación)
治療之觸｜Healing Touch｜Toque curativo
回春術｜Rejuvenation｜Rejuvenecimiento
癒合（不含HoT）｜Regrowth (direct)｜Recrecimiento (directa)
癒合｜Regrowth｜Recrecimiento
寧靜｜Tranquility｜Tranquilidad
野性痊癒｜Wild Growth｜Crecimiento salvaje
治療波｜Healing Wave｜Onda de curación
次級治療波｜Lesser Healing Wave｜Onda inferior de curación
治療鍊｜Chain Heal｜Curación en cadena
激流｜Riptide｜Mareas vivas
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜10 s de reutilización. En Forever, Luz curativa también potencia el Choque.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜Vigilia: 6 s de reutilización. Solo sana al grupo.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜El libro muestra 774–910. Se usan los valores del cliente para rangos inferiores.
HoT 總量／15秒｜HoT total over 15 sec｜Sanación periódica total en 15 s
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜Absorción. Reutilización base: 4 s. Alma debilitada: 15 s por objetivo (sin verificar en Forever).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜Cura a cada miembro del grupo objetivo por esta cantidad
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3 pulsos de 133. Reutilización: 12 s. Coeficiente sin verificar.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜Misma cantidad por salto; hasta 5 saltos; Reutilización de 10 segundos
治療分量；係數待核｜Healing part only; coefficient unverified｜Solo la parte de sanación. Coeficiente sin verificar.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜Total durante 12 s, confirmado en Forever.
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜Solo sanación directa. La periódica figura aparte.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜Periódica: 91 en 21 s (cliente). Coeficiente directo 0,286 y periódico 0,497.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜Canalizado. Total por persona. Reutilización larga.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜3 s de lanzamiento y 6 s de reutilización (ForeverChanges). No es instantáneo.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜Primer salto: valor base. Total: 1 + 0,5 + 0,25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜Solo sanación periódica. 12 s de reutilización. No tiene sanación directa.
聖光誓約｜Oath of Light｜Juramento de luz
誓約目標｜Oath target｜Objetivo del juramento
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜Bonificación fija a Luz Sagrada, Destello de Luz y Choque Sagrado sobre el objetivo del juramento. Si se incluye, la tabla usa esos valores.
聖光束縛｜Holy Binding｜Vinculación sagrada
對他人施放（含自療）｜On others (with self-heal)｜Sobre otros (con autosanación)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜Destello curativo sobre otro objetivo también te sana un 50 % de esa cantidad. Si se incluye, la tabla suma la autosanación.
激流加成｜Riptide bonus｜Bonificación de Mareas vivas
目標有激流｜Target has Riptide｜Objetivo con Mareas vivas
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜Curación en cadena sobre un objetivo con tu Mareas vivas sana un 25 % más en el primer salto. Si se incluye, la tabla usa ese valor.
綻放｜Bloom｜Floración
含綻放｜With Bloom｜Con Floración
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜Cuando termina la sanación periódica de Rejuvenecimiento o Recrecimiento, el objetivo recupera salud igual al 100 % de tu espíritu (50 % si se disipa). Si se incluye, la tabla la suma.
沒學｜Not learned｜No aprendido
計入｜Included｜Incluido
不計入｜Excluded｜Excluido
讀不到｜not found｜no encontrado
經典｜Classic｜Classic
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜Bonificaciones de talentos
沒有偵測到治療加成天賦｜No healing talents detected｜No se detectaron talentos de sanación.
治療加成 ｜Healing bonus ｜Bonificación de sanación 
%（手動）｜% (manual)｜% (manual)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜Juramento de luz: bonificación no encontrada (ejecute /shps debug e infórmelo)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜Juramento de luz: Luz Sagrada +%d, Destello de Luz +%d, Choque Sagrado +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜Floración al expirar cada sanación periódica: +
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ Rango 
 秒｜ sec｜ s
開｜On｜Sí
關｜Off｜No
單補｜Single｜Individual
群補｜Group｜Grupo
冷卻｜Cooldown｜Reutilización
救命｜Emergency｜Emergencia
保持｜Keep ｜Mantén 
鋪｜Spread ｜Reparte 
，救命 ｜, emergency ｜, de emergencia 
（停到 %d%%）｜ (hold until %d%%)｜ (espera hasta el %d%%)
（救命 %s）｜ (emergency %s)｜ (%s de emergencia)
，坦克快倒時改放 %s｜, %s when the tank is low｜, %s si el tanque tiene poca salud
戰鬥中不分析｜Not available in combat｜No disponible en combate
讀不到回藍｜Can't read mana regen｜No se pudo leer la regeneración de maná
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜Sana en %d s, reutilización de %s s
冷卻 %s 秒｜%s sec cooldown｜%s s de reutilización
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜Sanación directa: %s (%s/s) + %d s de sanación periódica %s. Al alternar entre %d objetivos, cada efecto dura el %d%%.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜Sanación directa %s (%s/s) + %d s de sanación periódica %s (%s/s)\nAl alternar objetivos: %s/s
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜Sana en %d s, repartido entre %d objetivos
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜Sana en %d s. Al alternar objetivos: %s/s
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜Una vez cada 15 s por objetivo. Al alternar: %s/s
（吸收）｜ (absorb)｜ (absorción)
（%d人）｜ (%d targets)｜ (%d objetivos)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜Rango inferior
治療效果只算 %d%%｜%d%% of Bonus Healing｜%d%% de la bonificación de sanación
★ %s HPS最高｜* Best HPS (%s)｜* Mejor HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* Mejor HPM (%s)
拖曳調整視窗大小｜Drag to resize｜Arrastra para ajustar el tamaño
設定｜Settings｜Ajustes
技能｜Spell｜Hechizo
等級｜Rank｜Rango
有效量｜Heal｜Sanación
法力｜Mana｜Maná
秒｜Sec｜s
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜Nivel %d · Bonificación de sanación %d
 · 精神 %d｜ · Spirit %d｜ · Espíritu %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · Reg. de maná: %d sin lanzar / %d al lanzar (cada 5 s)
技能提示：｜Spell tooltip: ｜Descripción del hechizo: 
精簡｜Brief｜Breve
標準｜Standard｜Estándar
完整｜Full｜Completo
群補人數 ｜Group targets ｜Objetivos de grupo 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = sanación ÷ tiempo de lanzamiento\n|cff9a9282Los hechizos instantáneos cuentan como 1,5 s.\nLa sanación periódica usa su duración. «Grupo» cuenta cuántos objetivos puedes mantener cubiertos.\nLos hechizos con reutilización tienen su propia pestaña y se calculan por lanzamiento.|r
（吸收）|r｜ (absorb)|r｜ (absorción)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜No hay hechizos aprendidos en esta pestaña.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* Mejor HPS|r %s rango %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* Mejor HPM|r %s rango %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜No hay hechizos de sanación para comparar (se excluye la absorción).
（滾輪看更多）｜(scroll for more)｜(desplázate para ver más)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜La absorción no cuenta para los mejores valores de HPS/HPM.
學習等級｜Learned at｜Se aprende al nivel
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜Algunos valores provienen de la tabla de datos (no legible en el juego)
單坦｜Tank｜Tanque
團刷｜Group｜Grupo
小怪｜Trash｜Enemigos
王戰｜Boss｜Jefe
單練｜Solo｜En solitario
省水｜Easy｜Fácil
群怪｜Trash｜Enemigos
全團技｜Raid AoE｜Área de banda
範圍｜AoE｜Área
點名｜Targeted｜Dirigido
詳細｜Details｜Detalles
坦克生命 %d｜Tank HP %d｜Salud del tanque %d
每次傷害 %d｜Damage per hit %d｜Daño por golpe %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜Intervalo de acierto %.1f seg.
戰鬥長度 %d 秒｜Fight length %d sec｜Duración de la pelea %d seg
人數 %d｜Group size %d｜Tamaño del grupo %d
成員生命 %d｜Member HP %d｜Salud por miembro %d
坦克每次傷害 %d｜Tank hit %d｜Golpe al tanque %d
坦克每次傷害 無｜Tank hit: none｜Sin golpes al tanque
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜Golpe al tanque cada %.1f s
範圍每次傷害 %d｜AoE hit %d｜Daño de área por golpe %d
範圍每次傷害 無｜AoE hit: none｜Sin daño de área
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜Daño de área cada %.1f s
範圍命中 隨機 %d 人｜AoE hits %d random｜El área alcanza a %d objetivos aleatorios
範圍命中 全員｜AoE hits everyone｜El área alcanza a todos
最省藍｜Most efficient｜Más eficiente
最穩定｜Most stable｜Más estable
撐最久｜Lasts longest｜Dura más
沒有可以補的技能｜No healing spells to use｜No hay hechizos de sanación disponibles
沒有可以單補的技能｜No single-target heals to use｜No hay sanación individual disponible
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100Más eficiente:|r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100Más estable:|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6bNadie sobrevive:|r mejor opción %s (%s)
%d 秒滅團｜wipe at %d sec｜derrota a los %d s
倒 %d 人｜%d dead｜%d bajas
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6bNadie sobrevive:|r mayor duración %s (%d s)
活｜Alive｜Vivo
倒下 %d 秒｜Dead at %d sec｜Muerte a los %d s
滅團 %d 秒｜Wipe at %d sec｜Derrota a los %d s
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d bajas, la primera a los %d s
沒藍 %d 秒｜OOM at %d sec｜Sin maná a los %d s
補滿差 ｜Short by ｜Faltan 
剩藍 ｜Mana left ｜Maná restante 
最低 %d%%｜Low %d%%｜Mínimo %d%%
每 ｜Every ｜Cada 
 秒一發｜ sec｜ s
沒出手｜No casts｜Sin lanzamientos
不用喝水｜No drinking｜No hace falta beber
打完要喝水｜Drink after｜Bebe al terminar
可連打 %d 波｜%d pulls in a row｜%d grupos seguidos
補到｜Healed｜Sanación efectiva
溢補｜Overheal｜Sobresanación
施法｜Casts｜Lanzamientos
 次｜｜
、救命 ｜, emergency ｜, emergencia 
倒下｜Deaths｜Muertes
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d, primera baja a los %d s
，坦克或自己倒下｜, tank or you died｜, tú o el tanque murió
低於 30%｜Below 30%｜Por debajo del 30 %
%d 人秒｜%d player-sec｜%d jugador-s
戰鬥結束｜Fight end｜Fin de la pelea
不喝水連打｜Pulls in a row｜Grupos seguidos
 波｜｜
救命 ｜emergency ｜emergencia 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜Tanque %d%%, maná restante %s
技能提示的 HPS：｜Spell tooltip HPS: ｜HPS en la descripción del hechizo: 
左鍵：開關比較表｜Left-click: toggle the table｜Clic izq.: mostrar u ocultar la tabla
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜Clic der.: alternar HPS en descripciones (ahora 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜Arrastra para moverlo por el minimapa
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜Versión %s  API: %s  Libro: %d hechizos
新版 C_SpellBook｜new C_SpellBook｜nuevo C_SpellBook
舊版｜legacy｜Version anterior
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜Clase %s  Nivel %d  Bonificación de sanación %d  Valores de la descripción: %s  Talentos: %s
已含治療效果｜include Bonus Healing｜incluye bonificación de sanación
基礎量｜base only｜solo valor base
沒找到｜none｜ninguno
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜Juramento de luz: no se encontró la bonificación. Texto del talento: 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜Juramento de luz: Luz Sagrada +%d, Destello de Luz +%d, Choque Sagrado +%d (%s)
比較表已計入｜included in the table｜incluido en la tabla
比較表未計入｜not included in the table｜No incluido en la tabla
已點天賦：｜Talents: ｜Talentos: 
有｜Yes｜Sí
（比較表已計入）｜ (included in the table)｜ (incluido en la tabla)
（比較表未計入）｜ (not included in the table)｜ (no incluido en la tabla)
沒偵測到｜Not detected｜No detectado
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜No se encontró ningún hechizo de sanación. Primeras entradas del libro: 
%s：法術書沒找到｜%s: not in spellbook｜%s: no está en el libro de hechizos
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s: nombre en el juego «%s», hasta el rango %d (%d rangos con ID). Análisis: %s
不解析｜not parsed｜Sin analizar
失敗：｜failed: ｜Error: 
說明未載入｜description not loaded｜descripción sin cargar
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜Esta clase no tiene hechizos de sanación. El addon queda inactivo.
小地圖按鈕：｜Minimap button: ｜Botón del minimapa: 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜oculto (escriba /shps minimap para mostrarlo)
顯示｜shown｜Visible
治療加成 %：｜Healing bonus %: ｜% de bonificación de curación: 
（手動）｜ (manual)｜ (manual)
依天賦自動｜auto from talents｜auto según los talentos
吸收加成 %：｜Absorb bonus %: ｜Bonificación de absorción %: 
群補目標數：｜Group targets: ｜Objetivos de grupo: 
滑鼠提示：｜Tooltip: ｜Descripción emergente: 
降級衰減：｜Downrank penalty: ｜Penalización por rango inferior: 
視窗縮放：｜Window scale: ｜Escala de la ventana: 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜Uso: /shps scale 1.2 (0.5–2, actual: 
技能說明數字：｜Spell description values: ｜Valores de la descripción: 
已含治療效果（手動）｜include Bonus Healing (manual)｜incluye bonificación de sanación (manual)
只有基礎量（手動）｜base only (manual)｜solo valor base (manual)
自動判斷｜auto｜automático
　目前：｜  Now: ｜  Ahora: 
直接採用說明數字｜using description values｜usa valores de la descripción
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜Base + bonificación de sanación × coeficiente
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜Idioma de la interfaz: %s (tras /reload)
設定已重設｜Settings reset｜Ajustes restablecidos
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps mostrar u ocultar la ventana  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = prueba de diseño, inglés un 35 % más largo)  /shps debug  /shps reset
```
