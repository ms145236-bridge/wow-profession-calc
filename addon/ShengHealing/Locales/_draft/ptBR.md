# ShengHealing UI · ptBR

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName ptBR](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=ptBR)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25fCura|r 
阿聖治療幫手｜Sheng Healing｜Sheng Cura
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s: erro|r %s. Envie esta linha ao desenvolvedor.
滑鼠提示｜Tooltip｜Tooltip
分析｜Analysis｜Análise
比較表｜Table｜Comparativo
除錯指令｜Debug command｜Comando de depuração
掛上滑鼠提示｜Tooltip hook｜Hook do tooltip
小地圖按鈕｜Minimap button｜Botão do minimapa
聖光術｜Holy Light｜Luz Sagrada
聖光閃現｜Flash of Light｜Clarão de Luz
神聖震擊｜Holy Shock｜Choque Sagrado
聖光戒備→震擊｜Light's Vigil > Shock｜Luz Zelosa > Choque
次級治療術｜Lesser Heal｜Cura Inferior
治療術｜Heal｜Cura
快速治療｜Flash Heal｜Cura Célere
強效治療術｜Greater Heal｜Cura Maior
恢復｜Renew｜Renovar
真言術：盾｜Power Word: Shield｜Palavra de Poder: Escudo
治療禱言｜Prayer of Healing｜Prece de Cura
懺悟｜Penance｜Penitência
癒合禱言｜Prayer of Mending｜Prece da Recomposição
神聖新星（治療）｜Holy Nova (heal)｜Nova Sagrada (cura)
治療之觸｜Healing Touch｜Toque de Cura
回春術｜Rejuvenation｜Rejuvenescer
癒合（不含HoT）｜Regrowth (direct)｜Recrescimento (cura direta)
癒合｜Regrowth｜Recrescimento
寧靜｜Tranquility｜Tranquilidade
野性痊癒｜Wild Growth｜Crescimento Silvestre
治療波｜Healing Wave｜Onda Curativa
次級治療波｜Lesser Healing Wave｜Onda Curativa Menor
治療鍊｜Chain Heal｜Cura Encadeada
激流｜Riptide｜Contracorrente
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜Recarga de 10 s. Em Forever, Luz Curativa também reforça o Choque.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜Recarga da Luz Zelosa: 6 s. Só conta a cura do grupo.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜O grimório mostra 774–910. O cálculo usa os valores do cliente para graus inferiores.
HoT 總量／15秒｜HoT total over 15 sec｜Cura periódica total em 15 s
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜Absorção. Recarga base: 4 s. Alma Enfraquecida: 15 s por alvo (a verificar em Forever).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜Cura cada membro do grupo do alvo nesta quantia
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3 pulsos de 133. Recarga de 12 s. Coeficiente a verificar.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜Mesma quantidade por salto; até 5 saltos; Tempo de espera de 10 segundos
治療分量；係數待核｜Healing part only; coefficient unverified｜Só a cura. Coeficiente a verificar.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜Total em 12 s, confirmado em Forever.
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜Só cura direta. A cura periódica é exibida à parte.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜Cura periódica: 91 em 21 s (cliente). Coeficiente direto 0,286, periódico 0,497.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜Canalizado. Total por pessoa. Recarga longa.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜Lançamento de 3 s e recarga de 6 s (ForeverChanges). Não é instantâneo.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜Primeiro salto: valor base. Total: 1 + 0,5 + 0,25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜Apenas cura periódica. Recarga de 12 s. Sem cura direta.
聖光誓約｜Oath of Light｜Juramento de Luz
誓約目標｜Oath target｜Alvo do juramento
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜Bônus fixo de Luz Sagrada, Clarão de Luz e Choque Sagrado no alvo do juramento. Se ativo, o comparativo usa esses valores.
聖光束縛｜Holy Binding｜Vínculo Sagrado
對他人施放（含自療）｜On others (with self-heal)｜Em outros (com autocura)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜Cura Célere em outra pessoa também cura você em 50% do valor. Se ativo, o comparativo soma a autocura.
激流加成｜Riptide bonus｜Bônus de Contracorrente
目標有激流｜Target has Riptide｜Alvo com Contracorrente
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜Cura Encadeada em um alvo com sua Contracorrente cura 25% a mais no primeiro salto. Se ativo, o comparativo usa esse valor.
綻放｜Bloom｜Florir
含綻放｜With Bloom｜Com Florir
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜Ao expirar a cura periódica de Rejuvenescer ou Recrescimento, o alvo recebe cura igual a 100% do seu Espírito (50% se dissipada). Se ativa, o comparativo inclui essa cura.
沒學｜Not learned｜Não aprendido
計入｜Included｜Incluído
不計入｜Excluded｜Excluído
讀不到｜not found｜não encontrado
經典｜Classic｜Classic
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜Bônus de talentos
沒有偵測到治療加成天賦｜No healing talents detected｜Nenhum talento de cura detectado.
治療加成 ｜Healing bonus ｜Bônus de cura 
%（手動）｜% (manual)｜% (manual)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜Juramento de Luz: bônus não encontrado (execute /shps debug e relate)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜Juramento de Luz: Luz Sagrada +%d, Clarão de Luz +%d, Choque Sagrado +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜Florir ao expirar cada cura periódica: +
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ Grau 
 秒｜ sec｜ s
開｜On｜Sim
關｜Off｜Não
單補｜Single｜Individual
群補｜Group｜Grupo
冷卻｜Cooldown｜Recarga
救命｜Emergency｜Emergência
保持｜Keep ｜Manter: 
鋪｜Spread ｜Espalhar: 
，救命 ｜, emergency ｜, em emergência 
（停到 %d%%）｜ (hold until %d%%)｜ (aguarde até %d%%)
（救命 %s）｜ (emergency %s)｜ (%s em emergência)
，坦克快倒時改放 %s｜, %s when the tank is low｜, %s quando o tanque estiver com pouca vida
戰鬥中不分析｜Not available in combat｜Não disponível em combate
讀不到回藍｜Can't read mana regen｜Não foi possível ler a regeneração de mana
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜Cura em %d s, recarga de %s s
冷卻 %s 秒｜%s sec cooldown｜Recarga de %s s
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜Cura direta %s (%s/s) + %d s de cura periódica %s. Alternando entre %d alvos, cada efeito dura %d%%.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜Cura direta %s (%s/s) + %d s de cura periódica %s (%s/s)\nAo alternar alvos: %s/s
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜Cura ao longo de %d s em %d alvos
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜Cura ao longo de %d s. Alternando alvos: %s/s
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜Uma vez a cada 15 s por alvo. Alternando: %s/s
（吸收）｜ (absorb)｜ (absorção)
（%d人）｜ (%d targets)｜ (%d alvos)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜Grau inferior
治療效果只算 %d%%｜%d%% of Bonus Healing｜%d%% do bônus de cura
★ %s HPS最高｜* Best HPS (%s)｜* Melhor HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* Melhor HPM (%s)
拖曳調整視窗大小｜Drag to resize｜Arraste para redimensionar
設定｜Settings｜Configurações
技能｜Spell｜Feitiço
等級｜Rank｜Grau
有效量｜Heal｜Cura
法力｜Mana｜Mana
秒｜Sec｜s
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜Nível %d · Bônus de cura %d
 · 精神 %d｜ · Spirit %d｜ · Espírito %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · Regen. de mana: %d fora / %d lançando (por 5 s)
技能提示：｜Spell tooltip: ｜Tooltip do feitiço: 
精簡｜Brief｜Breve
標準｜Standard｜Padrão
完整｜Full｜Completo
群補人數 ｜Group targets ｜Alvos da cura em grupo 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = cura ÷ tempo de lançamento\n|cff9a9282Feitiços instantâneos contam como 1,5 s.\nA cura periódica usa sua duração. O grupo conta quantos alvos podem manter o efeito.\nFeitiços com recarga têm aba própria e são calculados por lançamento.|r
（吸收）|r｜ (absorb)|r｜ (absorção)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜Nenhum feitiço aprendido nesta aba.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* Melhor HPS|r %s grau %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* Melhor HPM|r %s grau %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜Nenhum feitiço de cura para comparar (absorções não entram).
（滾輪看更多）｜(scroll for more)｜(role para ver mais)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜Absorção não conta na comparação de melhores HPS/HPM.
學習等級｜Learned at｜Nível de aprendizado
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜Alguns valores vêm da tabela de dados (não legível no jogo)
單坦｜Tank｜Tanque
團刷｜Group｜Grupo
小怪｜Trash｜Inimigos
王戰｜Boss｜Chefe
單練｜Solo｜Solo
省水｜Easy｜Fácil
群怪｜Trash｜Inimigos
全團技｜Raid AoE｜Área de raide
範圍｜AoE｜Área
點名｜Targeted｜Direcionado
詳細｜Details｜Detalhes
坦克生命 %d｜Tank HP %d｜Vida do tanque %d
每次傷害 %d｜Damage per hit %d｜Dano por acerto %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜Intervalo de acertos %.1f seg
戰鬥長度 %d 秒｜Fight length %d sec｜Comprimento da luta %d seg
人數 %d｜Group size %d｜Tamanho do grupo %d
成員生命 %d｜Member HP %d｜Vida por membro %d
坦克每次傷害 %d｜Tank hit %d｜Golpe no tanque %d
坦克每次傷害 無｜Tank hit: none｜Sem golpes no tanque
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜Golpe no tanque a cada %.1f s
範圍每次傷害 %d｜AoE hit %d｜Dano em área por golpe %d
範圍每次傷害 無｜AoE hit: none｜Sem dano em área
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜Dano em área a cada %.1f s
範圍命中 隨機 %d 人｜AoE hits %d random｜Área atinge %d alvos aleatórios
範圍命中 全員｜AoE hits everyone｜A área atinge todos
最省藍｜Most efficient｜Mais eficiente
最穩定｜Most stable｜Mais estável
撐最久｜Lasts longest｜Dura mais
沒有可以補的技能｜No healing spells to use｜Nenhum feitiço de cura disponível
沒有可以單補的技能｜No single-target heals to use｜Nenhuma cura individual disponível
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100Mais eficiente:|r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100Mais estável:|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6bNinguém sobrevive:|r melhor opção %s (%s)
%d 秒滅團｜wipe at %d sec｜derrota aos %d s
倒 %d 人｜%d dead｜%d mortes
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6bNinguém sobrevive:|r maior duração %s (%d s)
活｜Alive｜Vivo
倒下 %d 秒｜Dead at %d sec｜Morte aos %d s
滅團 %d 秒｜Wipe at %d sec｜Derrota aos %d s
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d mortes, a primeira aos %d s
沒藍 %d 秒｜OOM at %d sec｜Sem mana aos %d s
補滿差 ｜Short by ｜Faltam 
剩藍 ｜Mana left ｜Mana restante: 
最低 %d%%｜Low %d%%｜Mínimo %d%%
每 ｜Every ｜A cada 
 秒一發｜ sec｜ s
沒出手｜No casts｜Sem lançamentos
不用喝水｜No drinking｜Não precisa beber
打完要喝水｜Drink after｜Beba depois
可連打 %d 波｜%d pulls in a row｜%d grupos seguidos
補到｜Healed｜Cura efetiva
溢補｜Overheal｜Sobrecura
施法｜Casts｜Lançamentos
 次｜｜
、救命 ｜, emergency ｜, emergência 
倒下｜Deaths｜Mortes
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d, primeira morte aos %d s
，坦克或自己倒下｜, tank or you died｜, você ou o tanque morreu
低於 30%｜Below 30%｜Abaixo de 30%
%d 人秒｜%d player-sec｜%d jogador-s
戰鬥結束｜Fight end｜Fim da luta
不喝水連打｜Pulls in a row｜Grupos seguidos
 波｜｜
救命 ｜emergency ｜emergência 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜Tanque %d%%, mana restante %s
技能提示的 HPS：｜Spell tooltip HPS: ｜HPS no tooltip do feitiço: 
左鍵：開關比較表｜Left-click: toggle the table｜Clique esquerdo: mostrar/ocultar tabela
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜Clique direito: alternar HPS no tooltip (agora 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜Arraste para mover pelo minimapa
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜Versão %s  API: %s  Grimório: %d feitiços
新版 C_SpellBook｜new C_SpellBook｜novo C_SpellBook
舊版｜legacy｜Legado
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜Classe %s  Nível %d  Bônus de cura %d  Valores da descrição: %s  Talentos: %s
已含治療效果｜include Bonus Healing｜inclui bônus de cura
基礎量｜base only｜só o valor base
沒找到｜none｜nenhum
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜Juramento de Luz: bônus não encontrado. Texto do talento: 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜Juramento de Luz: Luz Sagrada +%d, Clarão de Luz +%d, Choque Sagrado +%d (%s)
比較表已計入｜included in the table｜incluído na tabela
比較表未計入｜not included in the table｜Não incluído na tabela
已點天賦：｜Talents: ｜Talentos: 
有｜Yes｜Sim
（比較表已計入）｜ (included in the table)｜ (incluído na tabela)
（比較表未計入）｜ (not included in the table)｜ (não incluído na tabela)
沒偵測到｜Not detected｜Não detectado
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜Nenhum feitiço de cura corresponde. Primeiras entradas do grimório: 
%s：法術書沒找到｜%s: not in spellbook｜%s: ausente no grimório
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s: nome no jogo “%s”, até o grau %d (%d graus com ID). Leitura: %s
不解析｜not parsed｜Não analisado
失敗：｜failed: ｜Falha: 
說明未載入｜description not loaded｜descrição não carregada
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜Esta classe não tem feitiços de cura. O addon fica inativo.
小地圖按鈕：｜Minimap button: ｜Botão do minimapa: 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜oculto (digite /shps minimap para mostrá-lo)
顯示｜shown｜Visível
治療加成 %：｜Healing bonus %: ｜% de bônus de cura: 
（手動）｜ (manual)｜ (manual)
依天賦自動｜auto from talents｜auto pelos talentos
吸收加成 %：｜Absorb bonus %: ｜Bônus de absorção %: 
群補目標數：｜Group targets: ｜Alvos da cura em grupo: 
滑鼠提示：｜Tooltip: ｜Tooltip: 
降級衰減：｜Downrank penalty: ｜Penalidade de grau inferior: 
視窗縮放：｜Window scale: ｜Escala da janela: 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜Uso: /shps scale 1.2 (0.5–2, atual: 
技能說明數字：｜Spell description values: ｜Valores da descrição do feitiço: 
已含治療效果（手動）｜include Bonus Healing (manual)｜inclui bônus de cura (manual)
只有基礎量（手動）｜base only (manual)｜só o valor base (manual)
自動判斷｜auto｜automático
　目前：｜  Now: ｜  Agora: 
直接採用說明數字｜using description values｜usa os valores da descrição
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜Base + bônus de cura × coeficiente
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜Idioma da interface: %s (após /reload)
設定已重設｜Settings reset｜Configurações redefinidas
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps mostrar ou ocultar a janela  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = teste de layout, inglês 35% mais longo)  /shps debug  /shps reset
```
