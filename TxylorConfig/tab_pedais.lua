-- ========================================================================
-- DSS TAB: PEDAIS
-- ========================================================================

local data = require "cfg_data"
local cfg  = data.cfg
local u    = require "cfg_ui"

local M = {}

function M.draw()
	u.header('ACELERADOR')
	u.cfgSlider('Pressionar', 'gas_press', 0.5, 10.0, '%.1f',
		'Velocidade ao pisar o acelerador.')
	u.cfgSlider('Soltar', 'gas_release', 0.5, 10.0, '%.1f',
		'Velocidade ao soltar o acelerador.')

	u.header('FREIO')
	u.cfgSlider('Pressionar', 'brake_press', 0.5, 10.0, '%.1f',
		'Velocidade ao pisar o freio.')
	u.cfgSlider('Soltar', 'brake_release', 0.5, 10.0, '%.1f',
		'Velocidade ao soltar o freio.')

	u.header('EMBREAGEM MANUAL')
	u.hint('Controle via tecla C.')
	ui.offsetCursorY(2)
	u.cfgSlider('Pressionar', 'clutch_press', 0.5, 10.0, '%.1f',
		'Velocidade ao pisar a embreagem.')
	u.cfgSlider('Soltar', 'clutch_release', 0.5, 10.0, '%.1f',
		'Velocidade ao soltar a embreagem.')
	u.hint('C tem prioridade máxima sobre AutoClutch e Anti-Stall.')

	u.header('SCROLL GAS')
	u.cfgCheckbox('Acelerador por Scroll', 'scroll_gas_enabled')
	if cfg.scroll_gas_enabled then
		ui.offsetCursorY(4)
		u.hint('Scroll Up = mais gás | Scroll Down = menos gás.')
		u.hint('Coexiste com o botão do mouse (botão = 100%).')
		ui.offsetCursorY(4)
		u.cfgSlider('Step por tick', 'scroll_gas_step', 0.01, 0.30, '%.2f',
			'Quanto cada tick do scroll adiciona/remove.')
		u.cfgSlider('Decay /s', 'scroll_gas_decay', 0.0, 2.0, '%.2f',
			'0.0 = mantém (cruise control) | 1.0 = decai rápido')
		u.cfgCheckbox('Zerar ao frear', 'scroll_gas_reset_on_brake')
	else
		ui.offsetCursorY(4)
		u.hint('Ative para usar o scroll como acelerador analógico.')
	end
end

return M