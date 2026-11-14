# ShengHealing UI · ruRU

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName ruRU](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=ruRU)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25fИсцеление|r 
阿聖治療幫手｜Sheng Healing｜Sheng: Исцеление
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s: ошибка|r %s. Передайте эту строку разработчику.
滑鼠提示｜Tooltip｜Подсказка
分析｜Analysis｜Анализ
比較表｜Table｜Сравнение
除錯指令｜Debug command｜Команда отладки
掛上滑鼠提示｜Tooltip hook｜Обработчик подсказки
小地圖按鈕｜Minimap button｜Кнопка мини-карты
聖光術｜Holy Light｜Свет небес
聖光閃現｜Flash of Light｜Вспышка Света
神聖震擊｜Holy Shock｜Шок небес
聖光戒備→震擊｜Light's Vigil > Shock｜Дозор Света > Шок
次級治療術｜Lesser Heal｜Малое исцеление
治療術｜Heal｜Исцеление
快速治療｜Flash Heal｜Быстрое исцеление
強效治療術｜Greater Heal｜Великое исцеление
恢復｜Renew｜Обновление
真言術：盾｜Power Word: Shield｜Слово силы: Щит
治療禱言｜Prayer of Healing｜Молитва исцеления
懺悟｜Penance｜Исповедь
癒合禱言｜Prayer of Mending｜Молитва восстановления
神聖新星（治療）｜Holy Nova (heal)｜Кольцо Света (исцеление)
治療之觸｜Healing Touch｜Целительное прикосновение
回春術｜Rejuvenation｜Омоложение
癒合（不含HoT）｜Regrowth (direct)｜Восстановление (прямое лечение)
癒合｜Regrowth｜Восстановление
寧靜｜Tranquility｜Спокойствие
野性痊癒｜Wild Growth｜Буйный рост
治療波｜Healing Wave｜Волна исцеления
次級治療波｜Lesser Healing Wave｜Малая волна исцеления
治療鍊｜Chain Heal｜Цепное исцеление
激流｜Riptide｜Быстрина
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜Восстановление: 10 сек. В Forever Исцеляющий Свет также усиливает шок.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜Дозор: восстановление 6 сек. Только исцеление группы.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜В книге указано 774–910. Для низких рангов берутся значения клиента.
HoT 總量／15秒｜HoT total over 15 sec｜Суммарное периодическое исцеление за 15 сек.
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜Поглощение. Базовое восстановление: 4 сек. Ослабленная душа: 15 сек. на цель (в Forever не проверено).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜Исцеляет каждого члена группы цели на сумму
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜3 импульса по 133. Восстановление: 12 сек. Коэффициент не проверен.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜Та же сумма за прыжок; до 5 прыжков; Время восстановления: 10 секунд
治療分量；係數待核｜Healing part only; coefficient unverified｜Только исцеление. Коэффициент не проверен.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜Суммарно за 12 сек., проверено в Forever.
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜Только прямое исцеление. Периодическое указано отдельно.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜Периодическое: 91 за 21 сек. (клиент). Коэффициент: 0,286 для прямого и 0,497 для периодического.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜Потоковое. Сумма на игрока. Долгое восстановление.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜Применение 3 сек., восстановление 6 сек. (ForeverChanges). Не мгновенно.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜Первый скачок — базовое значение. Всего: 1 + 0,5 + 0,25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜Только периодическое исцеление. Восстановление 12 сек. Прямого исцеления нет.
聖光誓約｜Oath of Light｜Клятва Света
誓約目標｜Oath target｜Цель клятвы
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜Фиксированная прибавка к «Свет небес», «Вспышка Света» и «Шок небес» на цели клятвы. При включении таблица учитывает её.
聖光束縛｜Holy Binding｜Священная связь
對他人施放（含自療）｜On others (with self-heal)｜На других (с самоисцелением)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜«Быстрое исцеление» на другой цели также лечит вас на 50 % от этой суммы. При включении таблица учитывает самоисцеление.
激流加成｜Riptide bonus｜Бонус «Быстрина»
目標有激流｜Target has Riptide｜На цели есть «Быстрина»
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜Если применить «Цепное исцеление» к цели с вашим эффектом «Быстрина», первый скачок лечит на 25 % больше. При включении таблица учитывает это значение.
綻放｜Bloom｜Цветение
含綻放｜With Bloom｜С эффектом «Цветение»
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜Когда периодическое исцеление «Омоложение» или «Восстановление» заканчивается, цель восстанавливает здоровье в размере 100 % вашего духа (50 % при рассеивании). При включении таблица учитывает этот эффект.
沒學｜Not learned｜Не изучен
計入｜Included｜Учтено
不計入｜Excluded｜Не учтено
讀不到｜not found｜не найден
經典｜Classic｜Classic
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜Бонусы талантов
沒有偵測到治療加成天賦｜No healing talents detected｜Не обнаружено талантов, усиливающих исцеление.
治療加成 ｜Healing bonus ｜Бонус к исцелению 
%（手動）｜% (manual)｜% (вручную)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜Клятва Света: бонус не найден (запустите /shps debug и сообщите об этом)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜Клятва Света: Свет небес +%d, Вспышка Света +%d, Шок небес +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜«Цветение» за окончание каждого периодического исцеления: +
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ Ранг 
 秒｜ sec｜ сек.
開｜On｜Вкл.
關｜Off｜Выкл.
單補｜Single｜Одна цель
群補｜Group｜Группа
冷卻｜Cooldown｜Восстановление
救命｜Emergency｜Экстренно
保持｜Keep ｜Поддерживать: 
鋪｜Spread ｜Распределять: 
，救命 ｜, emergency ｜, экстренно 
（停到 %d%%）｜ (hold until %d%%)｜ (ждать до %d%%)
（救命 %s）｜ (emergency %s)｜ (экстренно: %s)
，坦克快倒時改放 %s｜, %s when the tank is low｜, %s при низком здоровье танка
戰鬥中不分析｜Not available in combat｜Не доступен в бою
讀不到回藍｜Can't read mana regen｜Не удалось получить восстановление маны
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜Исцеление за %d сек., восстановление %s сек.
冷卻 %s 秒｜%s sec cooldown｜Восстановление %s сек.
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜Прямое исцеление: %s (%s/сек.) + %d сек. периодического исцеления %s. При смене %d целей каждый эффект длится %d%%.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜Прямое исцеление %s (%s/сек.) + %d сек. периодического исцеления %s (%s/сек.)\nПри смене целей: %s/сек.
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜Исцеление за %d сек. на %d целях
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜Исцеление за %d сек. При смене целей: %s/сек.
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜Раз в 15 сек. на цель. При смене целей: %s/сек.
（吸收）｜ (absorb)｜ (поглощение)
（%d人）｜ (%d targets)｜ (целей: %d)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜Низший ранг
治療效果只算 %d%%｜%d%% of Bonus Healing｜%d%% от бонуса к исцелению
★ %s HPS最高｜* Best HPS (%s)｜* Лучший HPS (%s)
★ %s HPM最高｜* Best HPM (%s)｜* Лучший HPM (%s)
拖曳調整視窗大小｜Drag to resize｜Перетащите, чтобы изменить размер
設定｜Settings｜Настройки
技能｜Spell｜Заклинание
等級｜Rank｜Ранг
有效量｜Heal｜Исцеление
法力｜Mana｜Мана
秒｜Sec｜Сек.
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜Уровень %d · Бонус к исцелению %d
 · 精神 %d｜ · Spirit %d｜ · Дух %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · Восст. маны: %d вне произнесения / %d при произнесении (за 5 сек.)
技能提示：｜Spell tooltip: ｜Подсказка заклинания: 
精簡｜Brief｜Кратко
標準｜Standard｜Стандартно
完整｜Full｜Подробно
群補人數 ｜Group targets ｜Цели группового исцеления 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = исцеление ÷ время применения\n|cff9a9282Мгновенные заклинания считаются за 1,5 сек.\nДля периодических эффектов берётся длительность. «Группа» считает цели, на которых можно поддерживать эффект.\nЗаклинания с восстановлением вынесены в отдельную вкладку и считаются за применение.|r
（吸收）|r｜ (absorb)|r｜ (поглощение)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜В этой вкладке нет изученных заклинаний.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* Лучший HPS|r %s ранг %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* Лучший HPM|r %s ранг %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜Нет заклинаний для сравнения (поглощение не учитывается).
（滾輪看更多）｜(scroll for more)｜(прокрутите, чтобы увидеть больше)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜Поглощение не учитывается при выборе лучших HPS/HPM.
學習等級｜Learned at｜Уровень изучения
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜Некоторые значения берутся из таблицы данных (не читаются в игре)
單坦｜Tank｜Танк
團刷｜Group｜Группа
小怪｜Trash｜Мобы
王戰｜Boss｜Босс
單練｜Solo｜Соло
省水｜Easy｜Легко
群怪｜Trash｜Мобы
全團技｜Raid AoE｜Массовый урон по рейду
範圍｜AoE｜Массовый урон
點名｜Targeted｜По целям
詳細｜Details｜Подробности
坦克生命 %d｜Tank HP %d｜Здоровье танка %d
每次傷害 %d｜Damage per hit %d｜Урон за удар %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜Интервал попаданий %.1f сек
戰鬥長度 %d 秒｜Fight length %d sec｜Длина боя %d сек
人數 %d｜Group size %d｜Размер группы %d
成員生命 %d｜Member HP %d｜Здоровье участника %d
坦克每次傷害 %d｜Tank hit %d｜Удар по танку %d
坦克每次傷害 無｜Tank hit: none｜Нет ударов по танку
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜Интервал ударов по танку %.1f сек.
範圍每次傷害 %d｜AoE hit %d｜Массовый урон за удар %d
範圍每次傷害 無｜AoE hit: none｜Нет массового урона
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜Интервал массового урона %.1f сек.
範圍命中 隨機 %d 人｜AoE hits %d random｜Массовый урон по случайным целям: %d
範圍命中 全員｜AoE hits everyone｜Массовый урон по всем
最省藍｜Most efficient｜Самый экономичный
最穩定｜Most stable｜Самый стабильный
撐最久｜Lasts longest｜Держится дольше всех
沒有可以補的技能｜No healing spells to use｜Нет доступных исцеляющих заклинаний
沒有可以單補的技能｜No single-target heals to use｜Нет доступного исцеления одной цели
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100Наиболее эффективный: |r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100Самая стабильная: |r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6bНикто не выживает:|r лучший вариант %s (%s)
%d 秒滅團｜wipe at %d sec｜гибель группы через %d сек.
倒 %d 人｜%d dead｜Погибло: %d
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6bНикто не выживает:|r дольше всех %s (%d сек.)
活｜Alive｜Жив
倒下 %d 秒｜Dead at %d sec｜Гибель через %d сек.
滅團 %d 秒｜Wipe at %d sec｜Гибель группы через %d сек.
倒 %d 人 %d 秒｜%d dead, first at %d sec｜Погибло %d, первая гибель через %d сек.
沒藍 %d 秒｜OOM at %d sec｜Мана исчерпана через %d сек.
補滿差 ｜Short by ｜Не хватает 
剩藍 ｜Mana left ｜Осталось маны: 
最低 %d%%｜Low %d%%｜Минимум %d%%
每 ｜Every ｜Каждые 
 秒一發｜ sec｜ сек.
沒出手｜No casts｜Нет применений
不用喝水｜No drinking｜Можно не пить
打完要喝水｜Drink after｜Пить после боя
可連打 %d 波｜%d pulls in a row｜Групп подряд: %d
補到｜Healed｜Исцелено
溢補｜Overheal｜Избыточное исцеление
施法｜Casts｜Применения
 次｜｜
、救命 ｜, emergency ｜, аварийная ситуация 
倒下｜Deaths｜Смерти
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d, первая гибель через %d сек.
，坦克或自己倒下｜, tank or you died｜, вы или танк погибли
低於 30%｜Below 30%｜Ниже 30%
%d 人秒｜%d player-sec｜%d игроко-сек.
戰鬥結束｜Fight end｜Конец боя
不喝水連打｜Pulls in a row｜Групп подряд
 波｜｜
救命 ｜emergency ｜аварийная ситуация 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜Танк %d%%, осталось маны %s
技能提示的 HPS：｜Spell tooltip HPS: ｜HPS в подсказке заклинания: 
左鍵：開關比較表｜Left-click: toggle the table｜ЛКМ: показать или скрыть таблицу
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜ПКМ: HPS в подсказке (сейчас 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜Перетащите кнопку по мини-карте
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜Версия %s  API: %s  Книга заклинаний: %d закл.
新版 C_SpellBook｜new C_SpellBook｜новый C_SpellBook
舊版｜legacy｜Старая
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜Класс %s  Уровень %d  Бонус к исцелению %d  Значения из описаний: %s  Таланты: %s
已含治療效果｜include Bonus Healing｜с бонусом к исцелению
基礎量｜base only｜только базовое значение
沒找到｜none｜нет
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜«Клятва Света»: бонус не найден. Описание таланта: 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜Клятва Света: Свет небес +%d, Вспышка Света +%d, Шок небес +%d (%s)
比較表已計入｜included in the table｜включен в таблицу
比較表未計入｜not included in the table｜Не учтено в таблице
已點天賦：｜Talents: ｜Таланты: 
有｜Yes｜Да
（比較表已計入）｜ (included in the table)｜ (включены в таблицу)
（比較表未計入）｜ (not included in the table)｜ (в таблицу не входит)
沒偵測到｜Not detected｜Не обнаружен
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜Подходящих исцеляющих заклинаний нет. Первые записи в книге: 
%s：法術書沒找到｜%s: not in spellbook｜%s: нет в книге заклинаний
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s: имя в игре «%s», до ранга %d (%d рангов с ID). Разбор: %s
不解析｜not parsed｜Не разобрано
失敗：｜failed: ｜Ошибка: 
說明未載入｜description not loaded｜описание не загружено
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜У этого класса нет исцеляющих заклинаний. Аддон неактивен.
小地圖按鈕：｜Minimap button: ｜Кнопка мини-карты: 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜скрыт (чтобы отобразить его, введите /shps minimap)
顯示｜shown｜Показано
治療加成 %：｜Healing bonus %: ｜Бонус к исцелению %: 
（手動）｜ (manual)｜ (ручной)
依天賦自動｜auto from talents｜авто по талантам
吸收加成 %：｜Absorb bonus %: ｜Бонус поглощения %: 
群補目標數：｜Group targets: ｜Цели группового исцеления: 
滑鼠提示：｜Tooltip: ｜Подсказка: 
降級衰減：｜Downrank penalty: ｜Штраф низкого ранга: 
視窗縮放：｜Window scale: ｜Масштаб окна: 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜Пример: /shps scale 1.2 (0.5–2, сейчас 
技能說明數字：｜Spell description values: ｜Значения из описаний: 
已含治療效果（手動）｜include Bonus Healing (manual)｜с бонусом к исцелению (вручную)
只有基礎量（手動）｜base only (manual)｜только базовое значение (вручную)
自動判斷｜auto｜авто
　目前：｜  Now: ｜  Сейчас: 
直接採用說明數字｜using description values｜используются значения из описания
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜Базовое значение + бонус к исцелению × коэффициент
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜Язык интерфейса: %s (после /reload)
設定已重設｜Settings reset｜Настройки сброшены
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps показать или скрыть окно  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = проверка вёрстки, английский текст удлинён на 35 %)  /shps debug  /shps reset
```
