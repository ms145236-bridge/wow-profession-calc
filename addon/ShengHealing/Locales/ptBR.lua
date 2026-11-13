-- Português do Brasil (ptBR)
-- ui: interface text, keyed by the original Chinese text in Core.lua / Data.lua (same keys as enUS.lua)
-- game: patterns for reading this client's spell descriptions (tools/tooltips-ptBR.md, tested by tools/test-healing-locales.mjs),
--       and this client's names of the spells and talents in Data.lua / Core.lua (used only when the spell ID lookup returns nothing)
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.ptBR = {
  game = {
    rangeSeps = { "para" },                     -- "Cura 42 para 50 pontos de vida"
    damageAfter = "^%s*de dano",                -- "129 para 139 de dano Sagrado" is damage, not healing
    hot = "(%d+)%D-ao longo de",                -- "Cura 45 pontos de vida do alvo ao longo de 15 s."
    absorb = "absorv%D-(%d+)",                  -- "absorvendo 48 de dano"
    single = "cura de%s+(%d+)",                 -- "uma cura de 172" (Prayer of Mending)
    tick = "(%d+)%s*pontos de vida.-a cada%s+(%d+)", tickAmountFirst = true, -- "Regenera 91 pontos de vida ... a cada 2 s"
    tickDur = "a cada%s+%d+%s*s%.?%s+por%s+(%d+)", -- "a cada 2 s por 10 s."
    extra = "e mais%s+(%d+)",                   -- "e mais 91"
    dur = "ao longo de%s+(%d+)",                -- "ao longo de 21 s."
    thousands = { "%." },                       -- "1.111"
    spells = {
      ["聖光術"] = "Luz Sagrada", ["聖光閃現"] = "Clarão de Luz", ["神聖震擊"] = "Choque Sagrado", ["聖光戒備"] = "Luz Zelosa",
      ["聖光守望"] = "Luz Zelosa", ["次級治療術"] = "Cura Inferior", ["治療術"] = "Cura", ["快速治療"] = "Cura Célere",
      ["強效治療術"] = "Cura Maior", ["恢復"] = "Renovar", ["真言術：盾"] = "Palavra de Poder: Escudo", ["治療禱言"] = "Prece de Cura",
      ["懺悟"] = "Penitência", ["苦修"] = "Penitência", ["癒合禱言"] = "Prece da Recomposição", ["愈合禱言"] = "Prece da Recomposição",
      ["神聖新星"] = "Nova Sagrada", ["治療之觸"] = "Toque de Cura", ["回春術"] = "Rejuvenescer", ["癒合"] = "Recrescimento",
      ["愈合"] = "Recrescimento", ["寧靜"] = "Tranquilidade", ["野性痊癒"] = "Crescimento Silvestre", ["野性成長"] = "Crescimento Silvestre",
      ["治療波"] = "Onda Curativa", ["次級治療波"] = "Onda Curativa Menor", ["治療鍊"] = "Cura Encadeada", ["治療鏈"] = "Cura Encadeada",
      ["激流"] = "Contracorrente", ["治療之光"] = "Luz Curativa", ["精神治療"] = "Cura Espiritual", ["強化真言術：盾"] = "Palavra de Poder Aprimorada: Escudo",
      ["自然賜福"] = "Dom da Natureza", ["淨化"] = "Purificação", ["聖光誓約"] = "Juramento de Luz", ["聖光誓言"] = "Juramento de Luz",
    },
  },
  ui = {
    -- product, chat
    ["|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r "] = "|cff4fc3f7Sheng|r|cffd9b25fCura|r ",
    ["阿聖治療幫手"] = "Sheng Cura",
    ["|cffff7b7b%s出錯：|r%s　請把這行回報給開發者"] = "|cffff7b7b%s: erro|r %s. Envie esta linha ao desenvolvedor.",
    -- where an error happened
    ["滑鼠提示"] = "Tooltip", ["分析"] = "Análise", ["比較表"] = "Comparativo", ["除錯指令"] = "Comando de depuração",
    ["掛上滑鼠提示"] = "Hook do tooltip", ["小地圖按鈕"] = "Botão do minimapa",
    -- spell rows (Data.lua labels)
    ["聖光術"] = "Luz Sagrada", ["聖光閃現"] = "Clarão de Luz", ["神聖震擊"] = "Choque Sagrado",
    ["聖光戒備→震擊"] = "Luz Zelosa > Choque",
    ["次級治療術"] = "Cura Inferior", ["治療術"] = "Cura", ["快速治療"] = "Cura Célere", ["強效治療術"] = "Cura Maior",
    ["恢復"] = "Renovar", ["真言術：盾"] = "Palavra de Poder: Escudo", ["治療禱言"] = "Prece de Cura", ["懺悟"] = "Penitência",
    ["癒合禱言"] = "Prece da Recomposição", ["神聖新星（治療）"] = "Nova Sagrada (cura)",
    ["治療之觸"] = "Toque de Cura", ["回春術"] = "Rejuvenescer", ["癒合（不含HoT）"] = "Recrescimento (cura direta)", ["癒合"] = "Recrescimento",
    ["寧靜"] = "Tranquilidade", ["野性痊癒"] = "Crescimento Silvestre",
    ["治療波"] = "Onda Curativa", ["次級治療波"] = "Onda Curativa Menor", ["治療鍊"] = "Cura Encadeada", ["激流"] = "Contracorrente",
    -- spell notes (Data.lua)
    ["CD 10s；永恆治療之光也乘震擊"] = "Recarga de 10 s. Em Forever, Luz Curativa também reforça o Choque.",
    ["戒備 CD 6s；只計小隊治療"] = "Recarga da Luz Zelosa: 6 s. Só conta a cura do grupo.",
    ["法術書可見 774–910；以降級計算器客戶端為準"] = "O grimório mostra 774–910. O cálculo usa os valores do cliente para graus inferiores.",
    ["HoT 總量／15秒"] = "Cura periódica total em 15 s",
    ["吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）"] = "Absorção. Recarga base: 4 s. Alma Enfraquecida: 15 s por alvo (a verificar em Forever).",
    ["目標及其小隊每人此量"] = "Cura cada membro do grupo do alvo nesta quantia",
    ["3×133／跳；CD 12；係數待核"] = "3 pulsos de 133. Recarga de 12 s. Coeficiente a verificar.",
    ["每跳等量；最多5跳；CD 10"] = "Mesma quantidade por salto; até 5 saltos; Tempo de espera de 10 segundos",
    ["治療分量；係數待核"] = "Só a cura. Coeficiente a verificar.",
    ["Forever 確認總量／12秒"] = "Total em 12 s, confirmado em Forever.",
    ["僅直接；HoT 另列"] = "Só cura direta. A cura periódica é exibida à parte.",
    ["HoT 91/21s（客戶端）；直接 0.286、HoT 0.497"] = "Cura periódica: 91 em 21 s (cliente). Coeficiente direto 0,286, periódico 0,497.",
    ["引導；每人總量；長CD"] = "Canalizado. Total por pessoa. Recarga longa.",
    ["cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否"] = "Lançamento de 3 s e recarga de 6 s (ForeverChanges). Não é instantâneo.",
    ["第1跳=基礎；總量1+0.5+0.25"] = "Primeiro salto: valor base. Total: 1 + 0,5 + 0,25.",
    ["僅HoT；CD 12；無瞬發"] = "Apenas cura periódica. Recarga de 12 s. Sem cura direta.",
    -- situational bonuses
    ["聖光誓約"] = "Juramento de Luz", ["誓約目標"] = "Alvo do juramento",
    ["對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。"] =
      "Bônus fixo de Luz Sagrada, Clarão de Luz e Choque Sagrado no alvo do juramento. Se ativo, o comparativo usa esses valores.",
    ["聖光束縛"] = "Vínculo Sagrado", ["對他人施放（含自療）"] = "Em outros (com autocura)",
    ["快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。"] =
      "Cura Célere em outra pessoa também cura você em 50% do valor. Se ativo, o comparativo soma a autocura.",
    ["激流加成"] = "Bônus de Contracorrente", ["目標有激流"] = "Alvo com Contracorrente",
    ["目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。"] =
      "Cura Encadeada em um alvo com sua Contracorrente cura 25% a mais no primeiro salto. Se ativo, o comparativo usa esse valor.",
    ["綻放"] = "Florir", ["含綻放"] = "Com Florir",
    ["回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。"] =
      "Ao expirar a cura periódica de Rejuvenescer ou Recrescimento, o alvo recebe cura igual a 100% do seu Espírito (50% se dissipada). Se ativa, o comparativo inclui essa cura.",
    ["沒學"] = "Não aprendido", ["計入"] = "Incluído", ["不計入"] = "Excluído",
    -- talents
    ["讀不到"] = "não encontrado", ["經典"] = "Classic",
    ["%s %d/%d（+%d%%）"] = "%s %d/%d (+%d%%)",
    ["天賦加成"] = "Bônus de talentos", ["沒有偵測到治療加成天賦"] = "Nenhum talento de cura detectado.",
    ["治療加成 "] = "Bônus de cura ", ["%（手動）"] = "% (manual)",
    ["聖光誓約：讀不到加成量（請執行 /shps debug 回報）"] = "Juramento de Luz: bônus não encontrado (execute /shps debug e relate)",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d"] = "Juramento de Luz: Luz Sagrada +%d, Clarão de Luz +%d, Choque Sagrado +%d",
    ["綻放：每次 HoT 結束 +"] = "Florir ao expirar cada cura periódica: +",
    -- shared bits (symbols: Latin-1 and plain punctuation only, other glyphs turn into boxes)
    ["…"] = "...", ["▼"] = "v ", ["★"] = "*",
    ["："] = ": ", ["、"] = ", ", ["＋"] = " + ", ["（"] = " (", ["）"] = ")", [" ／ "] = " / ",
    [" 等級"] = " Grau ", [" 秒"] = " s", ["開"] = "Sim", ["關"] = "Não",
    ["單補"] = "Individual", ["群補"] = "Grupo", ["冷卻"] = "Recarga", ["救命"] = "Emergência",
    -- analysis names
    ["保持"] = "Manter: ", ["鋪"] = "Espalhar: ", ["，救命 "] = ", em emergência ",
    ["（停到 %d%%）"] = " (aguarde até %d%%)", ["（救命 %s）"] = " (%s em emergência)",
    ["，坦克快倒時改放 %s"] = ", %s quando o tanque estiver com pouca vida",
    ["戰鬥中不分析"] = "Não disponível em combate", ["讀不到回藍"] = "Não foi possível ler a regeneração de mana",
    -- breakdown lines
    ["%d 秒內補完；冷卻 %s 秒"] = "Cura em %d s, recarga de %s s",
    ["冷卻 %s 秒"] = "Recarga de %s s",
    ["直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%"] = "Cura direta %s (%s/s) + %d s de cura periódica %s. Alternando entre %d alvos, cada efeito dura %d%%.",
    ["直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s"] = "Cura direta %s (%s/s) + %d s de cura periódica %s (%s/s)\nAo alternar alvos: %s/s",
    ["%d 秒內補完；鋪 %d 人"] = "Cura ao longo de %d s em %d alvos",
    ["%d 秒內補完；輪流掛不同目標時每秒 %s"] = "Cura ao longo de %d s. Alternando alvos: %s/s",
    ["同一目標 15 秒一次；輪流上不同目標時每秒 %s"] = "Uma vez a cada 15 s por alvo. Alternando: %s/s",
    -- spell tooltip
    ["（吸收）"] = " (absorção)", ["（%d人）"] = " (%d alvos)", ["|cffd9b25fHPS ／ HPM|r"] = "|cffd9b25fHPS / HPM|r",
    ["降級"] = "Grau inferior", ["治療效果只算 %d%%"] = "%d%% do bônus de cura",
    ["★ %s HPS最高"] = "* Melhor HPS (%s)", ["★ %s HPM最高"] = "* Melhor HPM (%s)",
    -- window
    ["拖曳調整視窗大小"] = "Arraste para redimensionar",
    ["設定"] = "Configurações",
    ["技能"] = "Feitiço", ["等級"] = "Grau", ["有效量"] = "Cura", ["法力"] = "Mana", ["秒"] = "s",
    ["%d 級 · 治療效果 %d"] = "Nível %d · Bônus de cura %d", [" · 精神 %d"] = " · Espírito %d",
    [" · 回藍 停手 %d／施法 %d（每 5 秒）"] = " · Mana/5 s: %d parado / %d lançando",
    ["技能提示："] = "Tooltip do feitiço: ", ["精簡"] = "Breve", ["標準"] = "Padrão", ["完整"] = "Completo",
    ["群補人數 "] = "Alvos da cura em grupo ",
    ["HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r"] =
      "HPS = cura ÷ tempo de lançamento\n|cff9a9282Feitiços instantâneos contam como 1,5 s.\nA cura periódica usa sua duração. O grupo conta quantos alvos podem manter o efeito.\nFeitiços com recarga têm aba própria e são calculados por lançamento.|r",
    ["（吸收）|r"] = " (absorção)|r",
    ["這一頁沒有你學會的技能。"] = "Nenhum feitiço aprendido nesta aba.",
    ["|cffffd100★ HPS最高|r %s 等級%d"] = "|cffffd100* Melhor HPS|r %s grau %d", ["|cff66ff66★ HPM最高|r %s 等級%d"] = "|cff66ff66* Melhor HPM|r %s grau %d",
    ["目前沒有可比較的治療技能（吸收盾不參加比較）"] = "Nenhum feitiço de cura para comparar (absorções não entram).",
    ["（滾輪看更多）"] = "(role para ver mais)",
    ["吸收量不是治療量，不參加 HPS／HPM 最高的比較"] = "Absorção não conta na comparação de melhores HPS/HPM.",
    ["學習等級"] = "Nível de aprendizado", ["（%d%%）"] = " (%d%%)",
    ["部分數值來自資料表（遊戲讀不到）"] = "Alguns valores vêm da tabela de dados (não legível no jogo)",
    -- analysis tab
    ["單坦"] = "Tanque", ["團刷"] = "Grupo",
    ["小怪"] = "Inimigos", ["王戰"] = "Chefe", ["單練"] = "Solo", ["省水"] = "Fácil",
    ["群怪"] = "Inimigos", ["全團技"] = "Raide", ["範圍"] = "Área", ["點名"] = "Direcionado",
    ["詳細"] = "Detalhes",
    ["坦克生命 %d"] = "Vida do tanque %d", ["每次傷害 %d"] = "Dano por acerto %d", ["受傷間隔 %.1f 秒"] = "Intervalo de acertos %.1f seg",
    ["戰鬥長度 %d 秒"] = "Comprimento da luta %d seg", ["人數 %d"] = "Tamanho do grupo %d", ["成員生命 %d"] = "Vida por membro %d",
    ["坦克每次傷害 %d"] = "Golpe no tanque %d", ["坦克每次傷害 無"] = "Sem golpes no tanque", ["坦克間隔 %.1f 秒"] = "Golpe no tanque a cada %.1f s",
    ["範圍每次傷害 %d"] = "Dano em área por golpe %d", ["範圍每次傷害 無"] = "Sem dano em área", ["範圍間隔 %.1f 秒"] = "Dano em área a cada %.1f s",
    ["範圍命中 隨機 %d 人"] = "Área atinge %d alvos aleatórios", ["範圍命中 全員"] = "A área atinge todos",
    ["最省藍"] = "Mais eficiente", ["最穩定"] = "Mais estável", ["撐最久"] = "Dura mais",
    ["沒有可以補的技能"] = "Nenhum feitiço de cura disponível", ["沒有可以單補的技能"] = "Nenhuma cura individual disponível",
    ["|cffffd100最省藍：|r%s"] = "|cffffd100Mais eficiente:|r %s", ["|cffffd100最穩定：|r%s"] = "|cffffd100Mais estável:|r %s",
    ["|cffff6b6b都撐不住：|r最好 %s（%s）"] = "|cffff6b6bNinguém sobrevive:|r melhor opção %s (%s)",
    ["%d 秒滅團"] = "derrota aos %d s", ["倒 %d 人"] = "%d mortes",
    ["|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）"] = "|cffff6b6bNinguém sobrevive:|r maior duração %s (%d s)",
    ["活"] = "Vivo", ["倒下 %d 秒"] = "Morte aos %d s", ["滅團 %d 秒"] = "Derrota aos %d s", ["倒 %d 人 %d 秒"] = "%d mortes, a primeira aos %d s",
    ["沒藍 %d 秒"] = "Sem mana aos %d s", ["補滿差 "] = "Faltam ", ["剩藍 "] = "Mana restante: ", ["最低 %d%%"] = "Mínimo %d%%",
    ["每 "] = "A cada ", [" 秒一發"] = " s", ["沒出手"] = "Sem lançamentos",
    ["不用喝水"] = "Não precisa beber", ["打完要喝水"] = "Beba depois", ["可連打 %d 波"] = "%d grupos seguidos",
    ["補到"] = "Cura efetiva", ["溢補"] = "Sobrecura", ["施法"] = "Lançamentos", [" 次"] = "", ["、救命 "] = ", emergência ",
    ["倒下"] = "Mortes", ["%d 人，第一人 %d 秒"] = "%d, primeira morte aos %d s", ["，坦克或自己倒下"] = ", você ou o tanque morreu",
    ["低於 30%"] = "Abaixo de 30%", ["%d 人秒"] = "%d jogador-s", ["戰鬥結束"] = "Fim da luta",
    ["不喝水連打"] = "Grupos seguidos", [" 波"] = "", ["救命 "] = "emergência ",
    ["坦克 %d%%、剩藍 %s"] = "Tanque %d%%, mana restante %s",
    -- minimap
    ["左鍵：開啟／關閉"] = "Clique esquerdo: abrir/fechar",
    ["右鍵：設定"] = "Clique direito: opções",
    ["拖曳：沿著小地圖移動"] = "Arraste para mover pelo minimapa",
    -- debug
    ["版本 %s　API：%s　法術書共 %d 個技能"] = "Versão %s  API: %s  Grimório: %d feitiços",
    ["新版 C_SpellBook"] = "novo C_SpellBook", ["舊版"] = "Legado",
    ["職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s"] = "Classe %s  Nível %d  Bônus de cura %d  Valores da descrição: %s  Talentos: %s",
    ["已含治療效果"] = "inclui bônus de cura", ["基礎量"] = "só o valor base", ["沒找到"] = "nenhum",
    ["聖光誓約：讀不到加成量。天賦說明："] = "Juramento de Luz: bônus não encontrado. Texto do talento: ",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）"] = "Juramento de Luz: Luz Sagrada +%d, Clarão de Luz +%d, Choque Sagrado +%d (%s)",
    ["比較表已計入"] = "incluído na tabela", ["比較表未計入"] = "Não incluído na tabela",
    ["已點天賦："] = "Talentos: ", ["有"] = "Sim",
    ["（比較表已計入）"] = " (incluído na tabela)", ["（比較表未計入）"] = " (não incluído na tabela)",
    ["沒偵測到"] = "Não detectado",
    ["一個治療技能都沒對上。法術書前幾個技能："] = "Nenhum feitiço de cura corresponde. Primeiras entradas do grimório: ",
    ["%s：法術書沒找到"] = "%s: ausente no grimório",
    ["%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s"] = "%s: nome no jogo “%s”, até o grau %d (%d graus com ID). Leitura: %s",
    ["不解析"] = "Não analisado", ["失敗："] = "Falha: ", ["說明未載入"] = "descrição não carregada",
    -- slash commands
    ["這個職業沒有治療技能，插件不會運作。"] = "Esta classe não tem feitiços de cura. O addon fica inativo.",
    ["小地圖按鈕："] = "Botão do minimapa: ", ["隱藏（再輸入 /shps minimap 顯示）"] = "oculto (digite /shps minimap para mostrá-lo)", ["顯示"] = "Visível",
    ["治療加成 %："] = "% de bônus de cura: ", ["（手動）"] = " (manual)", ["依天賦自動"] = "auto pelos talentos",
    ["吸收加成 %："] = "Bônus de absorção %: ", ["群補目標數："] = "Alvos da cura em grupo: ",
    ["滑鼠提示："] = "Tooltip: ", ["降級衰減："] = "Penalidade de grau inferior: ", ["視窗縮放："] = "Escala da janela: ",
    ["用法：/shps scale 1.2（0.5～2，目前 "] = "Uso: /shps scale 1.2 (0.5–2, atual: ",
    ["技能說明數字："] = "Valores da descrição do feitiço: ",
    ["已含治療效果（手動）"] = "inclui bônus de cura (manual)", ["只有基礎量（手動）"] = "só o valor base (manual)", ["自動判斷"] = "automático",
    ["　目前："] = "  Agora: ", ["直接採用說明數字"] = "usa os valores da descrição", ["基礎＋治療效果×係數"] = "Base + bônus de cura × coeficiente",
    ["介面語言：%s（/reload 後生效）"] = "Idioma da interface: %s (após /reload)",
    ["設定已重設"] = "Configurações redefinidas",
    ["/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset"] =
      "/shps mostrar ou ocultar a janela  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = teste de layout, inglês 35% mais longo)  /shps debug  /shps reset",
  },
}
