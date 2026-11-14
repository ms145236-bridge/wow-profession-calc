# ShengHealing UI · koKR

鍵｜英文｜譯文

比對 enUS.lua Git blob 899ce9e09a06d5f75c002322fbeb7b095da76ae9，共 253 個鍵。

下列資料保留 Lua 色碼及格式佔位符。字面 `\n` 表示原字串內換行。第三欄空白代表介面用的空字串。

技能與天賦名稱按 Forever 1.60.1.70938 的法術 ID 核對。 [SpellName koKR](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=koKR)

```text
|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r ｜|cff4fc3f7Sheng|r|cffd9b25fHealing|r ｜|cff4fc3f7Sheng|r|cffd9b25f치유 도우미|r 
阿聖治療幫手｜Sheng Healing｜Sheng 치유 도우미
|cffff7b7b%s出錯：|r%s　請把這行回報給開發者｜|cffff7b7b%s error:|r %s  Please report this line to the developer.｜|cffff7b7b%s 오류:|r %s. 이 줄을 개발자에게 알려 주세요.
滑鼠提示｜Tooltip｜툴팁
分析｜Analysis｜분석
比較表｜Table｜비교표
除錯指令｜Debug command｜디버그 명령어
掛上滑鼠提示｜Tooltip hook｜툴팁 연결
小地圖按鈕｜Minimap button｜미니맵 버튼
聖光術｜Holy Light｜성스러운 빛
聖光閃現｜Flash of Light｜빛의 섬광
神聖震擊｜Holy Shock｜신성 충격
聖光戒備→震擊｜Light's Vigil > Shock｜빛의 경계 > 충격
次級治療術｜Lesser Heal｜하급 치유
治療術｜Heal｜치유
快速治療｜Flash Heal｜순간 치유
強效治療術｜Greater Heal｜상급 치유
恢復｜Renew｜소생
真言術：盾｜Power Word: Shield｜신의 권능: 보호막
治療禱言｜Prayer of Healing｜치유의 기원
懺悟｜Penance｜회개
癒合禱言｜Prayer of Mending｜회복의 기원
神聖新星（治療）｜Holy Nova (heal)｜신성한 폭발 (치유)
治療之觸｜Healing Touch｜치유의 손길
回春術｜Rejuvenation｜회복
癒合（不含HoT）｜Regrowth (direct)｜재생 (직접 치유)
癒合｜Regrowth｜재생
寧靜｜Tranquility｜평온
野性痊癒｜Wild Growth｜급속 성장
治療波｜Healing Wave｜치유의 물결
次級治療波｜Lesser Healing Wave｜하급 치유의 물결
治療鍊｜Chain Heal｜연쇄 치유
激流｜Riptide｜성난 해일
CD 10s；永恆治療之光也乘震擊｜10 sec cooldown; Healing Light also boosts it in Forever｜재사용 대기시간 10초. 영원에서는 치유의 빛도 충격 치유량을 높입니다.
戒備 CD 6s；只計小隊治療｜Vigil 6 sec cooldown; party heal only｜경계 재사용 대기시간 6초. 파티 치유만 계산합니다.
法術書可見 774–910；以降級計算器客戶端為準｜Spellbook shows 774–910; client downrank values used｜마법책에는 774–910으로 표시됩니다. 하위 등급은 클라이언트 수치를 사용합니다.
HoT 總量／15秒｜HoT total over 15 sec｜15초 동안의 지속 치유량
吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）｜Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)｜피해 흡수. 기본 재사용 대기시간 4초. 약화된 영혼: 대상당 15초 (영원 미검증).
目標及其小隊每人此量｜Heals each member of the target's party for this amount｜이 양만큼 대상 파티의 각 구성원을 치유합니다.
3×133／跳；CD 12；係數待核｜3 × 133 per bolt; 12 sec cooldown; coefficient unverified｜133씩 3회. 재사용 대기시간 12초. 계수 미검증.
每跳等量；最多5跳；CD 10｜Same amount per jump; up to 5 jumps; 10 sec cooldown｜점프당 동일한 양; 최대 5번 점프; 쿨타임 10초
治療分量；係數待核｜Healing part only; coefficient unverified｜치유량만 계산합니다. 계수 미검증.
Forever 確認總量／12秒｜Total over 12 sec, confirmed in Forever｜12초 총 치유량 (영원에서 확인됨).
僅直接；HoT 另列｜Direct heal only; HoT listed separately｜직접 치유만 표시합니다. 지속 치유는 별도입니다.
HoT 91/21s（客戶端）；直接 0.286、HoT 0.497｜HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT｜지속 치유: 21초 동안 91 (클라이언트). 계수는 직접 0.286, 지속 0.497.
引導；每人總量；長CD｜Channeled; total per person; long cooldown｜정신 집중 주문입니다. 1인당 총량이며 재사용 대기시간이 깁니다.
cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否｜3 sec cast + 6 sec cooldown (ForeverChanges); not instant｜시전 3초, 재사용 대기시간 6초 (ForeverChanges). 즉시 시전이 아닙니다.
第1跳=基礎；總量1+0.5+0.25｜First jump = base; total 1 + 0.5 + 0.25｜첫 도약은 기본 치유량입니다. 총량: 1 + 0.5 + 0.25.
僅HoT；CD 12；無瞬發｜HoT only; 12 sec cooldown; no direct heal｜지속 치유만 적용됩니다. 재사용 대기시간 12초. 직접 치유는 없습니다.
聖光誓約｜Oath of Light｜빛의 서약
誓約目標｜Oath target｜서약 대상
對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。｜Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.｜서약 대상에게 성스러운 빛, 빛의 섬광, 신성 충격 시전 시 고정 보너스가 적용됩니다. 포함하면 비교표에 반영됩니다.
聖光束縛｜Holy Binding｜신성 결속
對他人施放（含自療）｜On others (with self-heal)｜다른 대상에게 사용 (자가 치유 포함)
快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。｜Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.｜다른 대상에게 순간 치유 시전 시 해당 치유량의 50%만큼 자신도 치유합니다. 포함하면 비교표에 반영됩니다.
激流加成｜Riptide bonus｜성난 해일 보너스
目標有激流｜Target has Riptide｜대상에 성난 해일 적용됨
目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。｜Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.｜내 성난 해일이 걸린 대상에게 연쇄 치유을 시전하면 첫 도약 치유량이 25% 증가합니다. 포함하면 비교표에 반영됩니다.
綻放｜Bloom｜피워내기
含綻放｜With Bloom｜피워내기 포함
回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。｜When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.｜회복 또는 재생의 지속 치유가 끝나면 대상이 내 정신력의 100%만큼 치유됩니다 (해제 시 50%). 포함하면 비교표에 반영됩니다.
沒學｜Not learned｜배우지 않음
計入｜Included｜포함
不計入｜Excluded｜제외
讀不到｜not found｜찾을 수 없음
經典｜Classic｜클래식
%s %d/%d（+%d%%）｜%s %d/%d (+%d%%)｜%s %d/%d (+%d%%)
天賦加成｜Talent Bonuses｜특성 보너스
沒有偵測到治療加成天賦｜No healing talents detected｜치유량을 높이는 특성이 감지되지 않았습니다.
治療加成 ｜Healing bonus ｜치유 보너스 
%（手動）｜% (manual)｜% (수동)
聖光誓約：讀不到加成量（請執行 /shps debug 回報）｜Oath of Light: bonus not found (run /shps debug and report it)｜빛의 서약: 보너스를 찾을 수 없습니다(/shps debug를 실행하고 보고하세요)
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d｜빛의 서약: 성스러운 빛 +%d, 빛의 섬광 +%d, 신성 충격 +%d
綻放：每次 HoT 結束 +｜Bloom per HoT expiry: +｜피워내기: 지속 치유 종료 시 +
…｜...｜...
▼｜v ｜v 
★｜*｜*
：｜: ｜: 
、｜, ｜, 
＋｜ + ｜ + 
（｜ (｜ (
）｜)｜)
 ／ ｜ / ｜ / 
 等級｜ Rank ｜ 등급 
 秒｜ sec｜초
開｜On｜켜짐
關｜Off｜꺼짐
單補｜Single｜단일 대상
群補｜Group｜파티
冷卻｜Cooldown｜재사용 대기시간
救命｜Emergency｜긴급
保持｜Keep ｜유지: 
鋪｜Spread ｜여러 대상에게 적용: 
，救命 ｜, emergency ｜, 긴급 
（停到 %d%%）｜ (hold until %d%%)｜ (%d%%까지 대기)
（救命 %s）｜ (emergency %s)｜ (긴급 %s)
，坦克快倒時改放 %s｜, %s when the tank is low｜, 방어 담당 생명력이 낮으면 %s
戰鬥中不分析｜Not available in combat｜전투 중에는 사용할 수 없습니다.
讀不到回藍｜Can't read mana regen｜마나 회복량을 읽을 수 없음
%d 秒內補完；冷卻 %s 秒｜Heals over %d sec; %s sec cooldown｜%d초 동안 치유, 재사용 대기시간 %s초
冷卻 %s 秒｜%s sec cooldown｜재사용 대기시간 %s초
直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%｜Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%｜직접 치유 %s (초당 %s) + %d초 지속 치유 %s. 대상 %d명에게 번갈아 쓰면 각 효과가 %d%%만 유지됩니다.
直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s｜Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s｜직접 치유 %s (초당 %s) + %d초 지속 치유 %s (초당 %s)\n대상 교대 시 초당 %s
%d 秒內補完；鋪 %d 人｜Heals over %d sec; spread on %d targets｜%d초 동안 치유, 대상 %d명에게 적용
%d 秒內補完；輪流掛不同目標時每秒 %s｜Heals over %d sec; rotating targets: %s/s｜%d초 동안 치유. 대상 교대 시 초당 %s
同一目標 15 秒一次；輪流上不同目標時每秒 %s｜Once per 15 sec per target; rotating targets: %s/s｜대상당 15초에 한 번. 대상 교대 시 초당 %s
（吸收）｜ (absorb)｜ (흡수)
（%d人）｜ (%d targets)｜ (대상 %d명)
|cffd9b25fHPS ／ HPM|r｜|cffd9b25fHPS / HPM|r｜|cffd9b25fHPS / HPM|r
降級｜Downrank｜하위 등급
治療效果只算 %d%%｜%d%% of Bonus Healing｜추가 치유량의 %d%%
★ %s HPS最高｜* Best HPS (%s)｜* 베스트 HPS(%s)
★ %s HPM最高｜* Best HPM (%s)｜* 베스트 HPM(%s)
拖曳調整視窗大小｜Drag to resize｜드래그하여 크기 조절
設定｜Settings｜설정
技能｜Spell｜주문
等級｜Rank｜등급
有效量｜Heal｜치유량
法力｜Mana｜마나
秒｜Sec｜초
%d 級 · 治療效果 %d｜Level %d · Bonus Healing %d｜레벨 %d · 추가 치유량 %d
 · 精神 %d｜ · Spirit %d｜ · 정신력 %d
 · 回藍 停手 %d／施法 %d（每 5 秒）｜ · Mana regen: %d idle / %d casting (per 5 s)｜ · 마나 회복: 비시전 %d / 시전 중 %d (5초당)
技能提示：｜Spell tooltip: ｜주문 툴팁: 
精簡｜Brief｜간단
標準｜Standard｜표준
完整｜Full｜전체
群補人數 ｜Group targets ｜파티 치유 대상 수 
HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r｜HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r｜HPS = 치유량 ÷ 시전 시간\n|cff9a9282즉시 시전은 1.5초로 계산합니다.\n지속 치유는 지속 시간을 사용합니다. 파티 탭은 효과를 유지할 수 있는 대상 수를 셉니다.\n재사용 대기시간이 있는 주문은 별도 탭에서 1회 시전 단위로 계산합니다.|r
（吸收）|r｜ (absorb)|r｜ (흡수)|r
這一頁沒有你學會的技能。｜No learned spells on this tab.｜이 탭에는 배운 주문이 없습니다.
|cffffd100★ HPS最高|r %s 等級%d｜|cffffd100* Best HPS|r %s Rank %d｜|cffffd100* 최고 HPS|r %s 등급 %d
|cff66ff66★ HPM最高|r %s 等級%d｜|cff66ff66* Best HPM|r %s Rank %d｜|cff66ff66* 최고 HPM|r %s 등급 %d
目前沒有可比較的治療技能（吸收盾不參加比較）｜No healing spells to compare (absorbs are excluded)｜비교할 치유 주문이 없습니다 (흡수 효과 제외).
（滾輪看更多）｜(scroll for more)｜(스크롤하여 더 보기)
吸收量不是治療量，不參加 HPS／HPM 最高的比較｜Absorbs aren't healing and are excluded from best HPS / HPM｜흡수 효과는 최고 HPS/HPM 비교에서 제외됩니다.
學習等級｜Learned at｜습득 레벨
（%d%%）｜ (%d%%)｜ (%d%%)
部分數值來自資料表（遊戲讀不到）｜Some values come from the data table (not readable in game)｜일부 값은 데이터 테이블에서 가져옵니다(게임에서는 읽을 수 없음)
單坦｜Tank｜방어 담당
團刷｜Group｜파티
小怪｜Trash｜일반 몹
王戰｜Boss｜우두머리
單練｜Solo｜혼자
省水｜Easy｜쉬움
群怪｜Trash｜일반 몹
全團技｜Raid AoE｜공격대 광역 피해
範圍｜AoE｜광역
點名｜Targeted｜지정 대상
詳細｜Details｜상세
坦克生命 %d｜Tank HP %d｜방어 담당 생명력 %d
每次傷害 %d｜Damage per hit %d｜적중당 데미지 %d
受傷間隔 %.1f 秒｜Hit interval %.1f sec｜히트 간격 %.1f 초
戰鬥長度 %d 秒｜Fight length %d sec｜전투 길이 %d 초
人數 %d｜Group size %d｜그룹 크기 %d
成員生命 %d｜Member HP %d｜파티원 생명력 %d
坦克每次傷害 %d｜Tank hit %d｜방어 담당 피격 피해 %d
坦克每次傷害 無｜Tank hit: none｜방어 담당 피격 없음
坦克間隔 %.1f 秒｜Tank interval %.1f sec｜방어 담당 피격 간격 %.1f초
範圍每次傷害 %d｜AoE hit %d｜광역 피해량 %d
範圍每次傷害 無｜AoE hit: none｜광역 피해 없음
範圍間隔 %.1f 秒｜AoE interval %.1f sec｜광역 피해 간격 %.1f초
範圍命中 隨機 %d 人｜AoE hits %d random｜무작위 대상 %d명에게 광역 피해
範圍命中 全員｜AoE hits everyone｜광역 피해가 모두에게 적용됨
最省藍｜Most efficient｜가장 효율적
最穩定｜Most stable｜가장 안정적
撐最久｜Lasts longest｜가장 오래 버팀
沒有可以補的技能｜No healing spells to use｜사용할 수 있는 치유 주문 없음
沒有可以單補的技能｜No single-target heals to use｜사용할 수 있는 단일 대상 치유 없음
|cffffd100最省藍：|r%s｜|cffffd100Most efficient:|r %s｜|cffffd100가장 효율적:|r %s
|cffffd100最穩定：|r%s｜|cffffd100Most stable:|r %s｜|cffffd100가장 안정적인:|r %s
|cffff6b6b都撐不住：|r最好 %s（%s）｜|cffff6b6bNone survive:|r best %s (%s)｜|cffff6b6b전원 생존 실패:|r 최선 %s (%s)
%d 秒滅團｜wipe at %d sec｜%d초에 전멸
倒 %d 人｜%d dead｜%d명 사망
|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）｜|cffff6b6bNone survive:|r longest %s (%d sec)｜|cffff6b6b전원 생존 실패:|r 최장 %s (%d초)
活｜Alive｜살아있는
倒下 %d 秒｜Dead at %d sec｜%d초에 사망
滅團 %d 秒｜Wipe at %d sec｜%d초에 전멸
倒 %d 人 %d 秒｜%d dead, first at %d sec｜%d명 사망, 첫 사망 %d초
沒藍 %d 秒｜OOM at %d sec｜%d초에 마나 고갈
補滿差 ｜Short by ｜부족한 양: 
剩藍 ｜Mana left ｜남은 마나: 
最低 %d%%｜Low %d%%｜최저 %d%%
每 ｜Every ｜매 
 秒一發｜ sec｜초
沒出手｜No casts｜시전 없음
不用喝水｜No drinking｜음료 불필요
打完要喝水｜Drink after｜전투 후 음료 사용
可連打 %d 波｜%d pulls in a row｜%d 무리 연속 전투
補到｜Healed｜유효 치유량
溢補｜Overheal｜초과 치유
施法｜Casts｜시전 횟수
 次｜｜
、救命 ｜, emergency ｜, 긴급 
倒下｜Deaths｜사망자
%d 人，第一人 %d 秒｜%d, first at %d sec｜%d명, 첫 사망 %d초
，坦克或自己倒下｜, tank or you died｜, 방어 담당 또는 본인 사망
低於 30%｜Below 30%｜30% 이하
%d 人秒｜%d player-sec｜%d 플레이어·초
戰鬥結束｜Fight end｜전투 종료
不喝水連打｜Pulls in a row｜연속 전투 무리 수
 波｜｜
救命 ｜emergency ｜긴급 
坦克 %d%%、剩藍 %s｜Tank %d%%, mana left %s｜방어 담당 %d%%, 남은 마나 %s
技能提示的 HPS：｜Spell tooltip HPS: ｜주문 툴팁 HPS: 
左鍵：開關比較表｜Left-click: toggle the table｜좌클릭: 비교표 표시 전환
右鍵：開關技能提示的 HPS（目前｜Right-click: toggle tooltip HPS (now ｜우클릭: 툴팁 HPS 표시 전환 (현재 
拖曳：沿著小地圖移動｜Drag: move around the minimap｜드래그: 미니맵을 따라 이동
版本 %s　API：%s　法術書共 %d 個技能｜Version %s  API: %s  Spellbook: %d spells｜버전 %s  API: %s  마법책: 주문 %d개
新版 C_SpellBook｜new C_SpellBook｜새로운 C_SpellBook
舊版｜legacy｜이전 방식
職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s｜Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s｜직업 %s  레벨 %d  추가 치유량 %d  설명 수치: %s  특성: %s
已含治療效果｜include Bonus Healing｜추가 치유량 포함
基礎量｜base only｜기본 수치만
沒找到｜none｜없음
聖光誓約：讀不到加成量。天賦說明：｜Oath of Light: bonus not found. Talent text: ｜빛의 서약: 보너스를 찾지 못했습니다. 특성 설명: 
聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）｜Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)｜빛의 서약: 성스러운 빛 +%d, 빛의 섬광 +%d, 신성 충격 +%d (%s)
比較表已計入｜included in the table｜테이블에 포함됨
比較表未計入｜not included in the table｜비교표에 미포함
已點天賦：｜Talents: ｜특성: 
有｜Yes｜예
（比較表已計入）｜ (included in the table)｜ (표에 포함)
（比較表未計入）｜ (not included in the table)｜ (표에 포함되지 않음)
沒偵測到｜Not detected｜감지되지 않음
一個治療技能都沒對上。法術書前幾個技能：｜No healing spells matched. First spellbook entries: ｜일치하는 치유 주문이 없습니다. 마법책의 첫 항목: 
%s：法術書沒找到｜%s: not in spellbook｜%s: 마법책에서 찾을 수 없음
%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s｜%s: game name "%s" up to rank %d (%d ranks with spell IDs)  Parsed: %s｜%s: 게임 내 이름 「%s」, 최고 등급 %d (주문 ID가 있는 등급 %d개). 분석: %s
不解析｜not parsed｜분석하지 않음
失敗：｜failed: ｜실패: 
說明未載入｜description not loaded｜설명을 불러오지 못함
這個職業沒有治療技能，插件不會運作。｜This class has no healing spells; the addon is inactive.｜이 직업에는 치유 주문이 없어 애드온이 비활성 상태입니다.
小地圖按鈕：｜Minimap button: ｜미니맵 버튼: 
隱藏（再輸入 /shps minimap 顯示）｜hidden (type /shps minimap to show it)｜숨김(표시하려면 /shps minimap 입력)
顯示｜shown｜표시됨
治療加成 %：｜Healing bonus %: ｜치유 보너스 %: 
（手動）｜ (manual)｜ (수동)
依天賦自動｜auto from talents｜특성으로 자동 계산
吸收加成 %：｜Absorb bonus %: ｜흡수 보너스 %: 
群補目標數：｜Group targets: ｜파티 치유 대상 수: 
滑鼠提示：｜Tooltip: ｜툴팁: 
降級衰減：｜Downrank penalty: ｜하위 등급 보정: 
視窗縮放：｜Window scale: ｜창 배율: 
用法：/shps scale 1.2（0.5～2，目前 ｜Usage: /shps scale 1.2 (0.5–2, now ｜사용법: /shps scale 1.2 (0.5–2, 현재 
技能說明數字：｜Spell description values: ｜주문 설명 수치: 
已含治療效果（手動）｜include Bonus Healing (manual)｜추가 치유량 포함 (수동)
只有基礎量（手動）｜base only (manual)｜기본 수치만 (수동)
自動判斷｜auto｜자동
　目前：｜  Now: ｜  현재: 
直接採用說明數字｜using description values｜설명 수치를 사용
基礎＋治療效果×係數｜base + Bonus Healing × coefficient｜기본 수치 + 추가 치유량 × 계수
介面語言：%s（/reload 後生效）｜UI language: %s (applies after /reload)｜인터페이스 언어: %s (/reload 후 적용)
設定已重設｜Settings reset｜설정이 초기화되었습니다
/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset｜/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset｜/shps 창 켜기/끄기  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = 배치 스트레스 테스트, 영어 문구를 35% 늘림)  /shps debug  /shps reset
```
