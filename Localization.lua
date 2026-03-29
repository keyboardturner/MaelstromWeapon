local addonName, MaelstromWeapon = ...

local L = {};
MaelstromWeapon.L = L;

local function defaultFunc(L, key)
 -- If this function was called, we have no localization for this key.
 -- We could complain loudly to allow localizers to see the error of their ways, 
 -- but, for now, just return the key as its own localization. This allows you to—avoid writing the default localization out explicitly.
 return key;
end
setmetatable(L, {__index=defaultFunc});

local LOCALE = GetLocale()


if LOCALE == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.
	L["TOC_Title"] = "Maelstrom Weapon"
	L["TOC_Notes"] = "Displays a widget for Enhancement Shaman that tracks the Maelstrom Weapon buff charges in a style similar to Combo Points."
	L["SLASH_MW1"] = "/maelstromweapon"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Show Duration Text"
	L["Setting_TextRight"] = "Duration Text on Right Side"
	L["Setting_PulseGlow"] = "Pulse Glow at Max Charges"
	L["Setting_BurstAnim"] = "Enable Charge Gain Animations"
	L["Setting_DecorAnim"] = "Enable Max Charge Animations"
	L["Setting_BackdropTex"] = "Show Backdrop Texture"
	L["Setting_BackdropColor"] = "Backdrop Color"
	L["Setting_BackdropGlowColor"] = "Backdrop Glow Color"
	L["Setting_CoverTexColor"] = "Charge Cover Texture Color"
	L["Setting_ChargeFill1_5TexColor"] = "Charge Fill Color (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Charge Fill Color (6-10)"

return end

if LOCALE == "esMX" then
	-- Spanish (Mexico) translations go here

	L["TOC_Title"] = "Arma vorágine"
	L["TOC_Notes"] = "Muestra un widget para Chaman Mejora que rastrea las cargas del beneficio Arma vorágine en un estilo similar a los Puntos de Combo."
	L["SLASH_MW1"] = "/armavorágine"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Mostrar duración"
	L["Setting_TextRight"] = "Duración a la derecha"
	L["Setting_PulseGlow"] = "Brillo pulsante al máximo de cargas"
	L["Setting_BurstAnim"] = "Activar animaciones de ganancia de cargas"
	L["Setting_DecorAnim"] = "Activar animaciones de carga máxima"
	L["Setting_BackdropTex"] = "Mostrar textura de fondo"
	L["Setting_BackdropColor"] = "Color de fondo"
	L["Setting_BackdropGlowColor"] = "Color de brillo del fondo"
	L["Setting_CoverTexColor"] = "Color de textura de cobertura"
	L["Setting_ChargeFill1_5TexColor"] = "Color de relleno (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Color de relleno (6-10)"

return end

if LOCALE == "esES" then
	-- Spanish translations go here

	L["TOC_Title"] = "Arma vorágine"
	L["TOC_Notes"] = "Muestra un widget para Chaman Mejora que rastrea las cargas del beneficio Arma vorágine en un estilo similar a los Puntos de Combo."
	L["SLASH_MW1"] = "/armavorágine"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Mostrar duración"
	L["Setting_TextRight"] = "Duración a la derecha"
	L["Setting_PulseGlow"] = "Brillo pulsante al máximo de cargas"
	L["Setting_BurstAnim"] = "Activar animaciones de ganancia de cargas"
	L["Setting_DecorAnim"] = "Activar animaciones de carga máxima"
	L["Setting_BackdropTex"] = "Mostrar textura de fondo"
	L["Setting_BackdropColor"] = "Color de fondo"
	L["Setting_BackdropGlowColor"] = "Color de brillo del fondo"
	L["Setting_CoverTexColor"] = "Color de textura de cobertura"
	L["Setting_ChargeFill1_5TexColor"] = "Color de relleno (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Color de relleno (6-10)"

return end

if LOCALE == "deDE" then
	-- German translations go here
	L["TOC_Title"] = "Waffe des Mahlstroms"
	L["TOC_Notes"] = "Zeigt ein Widget für Verstärkungs-Schamanen an, das die Stapel des Mahlstrom-Waffen-Buffs in einem Stil ähnlich der Combopunkte verfolgt."
	L["SLASH_MW1"] = "/waffedesmahlstroms"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Dauertext anzeigen"
	L["Setting_TextRight"] = "Dauertext rechts anzeigen"
	L["Setting_PulseGlow"] = "Pulsierendes Leuchten bei maximalen Aufladungen"
	L["Setting_BurstAnim"] = "Animation bei Aufladungsgewinn aktivieren"
	L["Setting_DecorAnim"] = "Animation bei maximalen Aufladungen aktivieren"
	L["Setting_BackdropTex"] = "Hintergrundtextur anzeigen"
	L["Setting_BackdropColor"] = "Hintergrundfarbe"
	L["Setting_BackdropGlowColor"] = "Hintergrund-Leuchteffektfarbe"
	L["Setting_CoverTexColor"] = "Farbe der Abdeckungstextur"
	L["Setting_ChargeFill1_5TexColor"] = "Füllfarbe (1–5)"
	L["Setting_ChargeFill6_10TexColor"] = "Füllfarbe (6–10)"

return end

if LOCALE == "frFR" then
	-- French translations go here

	L["TOC_Title"] = "Arme du Maelström"
	L["TOC_Notes"] = "Affiche un widget pour le Chaman Amélioration qui suit les charges du buff Arme du Maelström dans un style similaire aux Points de Combo."
	L["SLASH_MW1"] = "/armedumaelström"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Afficher la durée"
	L["Setting_TextRight"] = "Texte de durée à droite"
	L["Setting_PulseGlow"] = "Lueur pulsante à charges max"
	L["Setting_BurstAnim"] = "Activer les animations de gain de charges"
	L["Setting_DecorAnim"] = "Activer les animations de charges max"
	L["Setting_BackdropTex"] = "Afficher la texture de fond"
	L["Setting_BackdropColor"] = "Couleur de fond"
	L["Setting_BackdropGlowColor"] = "Couleur de lueur du fond"
	L["Setting_CoverTexColor"] = "Couleur de la texture de couverture"
	L["Setting_ChargeFill1_5TexColor"] = "Couleur de remplissage (1–5)"
	L["Setting_ChargeFill6_10TexColor"] = "Couleur de remplissage (6–10)"

return end

if LOCALE == "itIT" then
	-- Italian translations go here

	L["TOC_Title"] = "Arma del Maelstrom"
	L["TOC_Notes"] = "Mostra un widget per Sciamano Potenziamento che traccia le cariche del buff Arma del Maelstrom in uno stile simile ai Punti Combo."
	L["SLASH_MW1"] = "/armadelmaelstrom"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Mostra durata"
	L["Setting_TextRight"] = "Testo durata a destra"
	L["Setting_PulseGlow"] = "Bagliore pulsante a cariche massime"
	L["Setting_BurstAnim"] = "Abilita animazioni guadagno cariche"
	L["Setting_DecorAnim"] = "Abilita animazioni cariche massime"
	L["Setting_BackdropTex"] = "Mostra texture sfondo"
	L["Setting_BackdropColor"] = "Colore sfondo"
	L["Setting_BackdropGlowColor"] = "Colore bagliore sfondo"
	L["Setting_CoverTexColor"] = "Colore texture copertura"
	L["Setting_ChargeFill1_5TexColor"] = "Colore riempimento (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Colore riempimento (6-10)"

return end

if LOCALE == "ptBR" then
	-- Brazilian Portuguese translations go here

	L["TOC_Title"] = "Arma da Voragem"
	L["TOC_Notes"] = "Exibe um widget para Xamã Aperfeiçoamento que rastreia as cargas do buff Arma da Voragem em um estilo semelhante aos Pontos de Combo."
	L["SLASH_MW1"] = "/armadavoragem"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Mostrar duração"
	L["Setting_TextRight"] = "Texto de duração à direita"
	L["Setting_PulseGlow"] = "Brilho pulsante no máximo de cargas"
	L["Setting_BurstAnim"] = "Ativar animações de ganho de cargas"
	L["Setting_DecorAnim"] = "Ativar animações de carga máxima"
	L["Setting_BackdropTex"] = "Mostrar textura de fundo"
	L["Setting_BackdropColor"] = "Cor do fundo"
	L["Setting_BackdropGlowColor"] = "Cor do brilho do fundo"
	L["Setting_CoverTexColor"] = "Cor da textura de cobertura"
	L["Setting_ChargeFill1_5TexColor"] = "Cor de preenchimento (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Cor de preenchimento (6-10)"

-- Note that the EU Portuguese WoW client also
-- uses the Brazilian Portuguese locale code.
return end

if LOCALE == "ruRU" then
	-- Russian translations go here

	L["TOC_Title"] = "Оружие Водоворота (Maelstrom Weapon)"
	L["TOC_Notes"] = "Отображает виджет для шамана со специализацией «Стихии», который отслеживает заряды эффекта «Оружие Водоворота» в стиле, похожем на очки серии."
	L["SLASH_MW1"] = "/оружиеводоворота"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "Показывать длительность"
	L["Setting_TextRight"] = "Текст длительности справа"
	L["Setting_PulseGlow"] = "Пульсирующее свечение при макс. зарядах"
	L["Setting_BurstAnim"] = "Анимация получения зарядов"
	L["Setting_DecorAnim"] = "Анимация максимальных зарядов"
	L["Setting_BackdropTex"] = "Показывать фон"
	L["Setting_BackdropColor"] = "Цвет фона"
	L["Setting_BackdropGlowColor"] = "Цвет свечения фона"
	L["Setting_CoverTexColor"] = "Цвет текстуры покрытия"
	L["Setting_ChargeFill1_5TexColor"] = "Цвет заполнения (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "Цвет заполнения (6-10)"

return end

if LOCALE == "koKR" then
	-- Korean translations go here

	L["TOC_Title"] = "소용돌이치는 무기 (Maelstrom Weapon)"
	L["TOC_Notes"] = "강화 주술사를 위한 위젯을 표시하며 소용돌이치는 무기 버프 충전을 연계 포인트와 유사한 스타일로 추적합니다."
	L["SLASH_MW1"] = "소용돌이치는무기"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "지속 시간 표시"
	L["Setting_TextRight"] = "오른쪽에 지속 시간 표시"
	L["Setting_PulseGlow"] = "최대 중첩 시 펄스 효과"
	L["Setting_BurstAnim"] = "중첩 획득 애니메이션 활성화"
	L["Setting_DecorAnim"] = "최대 중첩 애니메이션 활성화"
	L["Setting_BackdropTex"] = "배경 텍스처 표시"
	L["Setting_BackdropColor"] = "배경 색상"
	L["Setting_BackdropGlowColor"] = "배경 발광 색상"
	L["Setting_CoverTexColor"] = "커버 텍스처 색상"
	L["Setting_ChargeFill1_5TexColor"] = "충전 색상 (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "충전 색상 (6-10)"

return end

if LOCALE == "zhCN" then
	-- Simplified Chinese translations go here

	L["TOC_Title"] = "漩涡武器 (Maelstrom Weapon)"
	L["TOC_Notes"] = "为增强萨满显示一个小组件，用于以类似连击点的样式追踪漩涡武器增益层数。"
	L["SLASH_MW1"] = "/漩涡武器"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "显示持续时间"
	L["Setting_TextRight"] = "持续时间显示在右侧"
	L["Setting_PulseGlow"] = "满层时脉冲发光"
	L["Setting_BurstAnim"] = "启用层数获得动画"
	L["Setting_DecorAnim"] = "启用满层动画"
	L["Setting_BackdropTex"] = "显示背景纹理"
	L["Setting_BackdropColor"] = "背景颜色"
	L["Setting_BackdropGlowColor"] = "背景发光颜色"
	L["Setting_CoverTexColor"] = "覆盖纹理颜色"
	L["Setting_ChargeFill1_5TexColor"] = "填充颜色 (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "填充颜色 (6-10)"

return end

if LOCALE == "zhTW" then
	-- Traditional Chinese translations go here

	L["TOC_Title"] = "漩涡武器 (Maelstrom Weapon)"
	L["TOC_Notes"] = "為增強薩滿顯示一個小工具，用於以類似連擊點的樣式追蹤漩渦武器增益層數。"
	L["SLASH_MW1"] = "/漩涡武器"
	L["SLASH_MW2"] = "/maelweap"
	L["SLASH_MW3"] = "/mw"
	L["SLASH_MW4"] = "/maelstromweapon" -- do not localize
	L["SLASH_MW5"] = "/maelweap" -- do not localize
	L["SLASH_MW6"] = "/mw" -- do not localize

	L["Setting_CDText"] = "顯示持續時間"
	L["Setting_TextRight"] = "持續時間顯示在右側"
	L["Setting_PulseGlow"] = "滿層時脈衝發光"
	L["Setting_BurstAnim"] = "啟用層數獲得動畫"
	L["Setting_DecorAnim"] = "啟用滿層動畫"
	L["Setting_BackdropTex"] = "顯示背景材質"
	L["Setting_BackdropColor"] = "背景顏色"
	L["Setting_BackdropGlowColor"] = "背景發光顏色"
	L["Setting_CoverTexColor"] = "覆蓋材質顏色"
	L["Setting_ChargeFill1_5TexColor"] = "填充顏色 (1-5)"
	L["Setting_ChargeFill6_10TexColor"] = "填充顏色 (6-10)"

return end
