-- ========================================================================
-- DSS TAB: TRANSMISSÃO
-- ========================================================================

local data     = require "cfg_data"
local cfg      = data.cfg
local defaults = data.defaults
local u        = require "cfg_ui"

local M = {}

function M.draw()
	-- AutoClutch
	u.header('AUTOCLUTCH')
	u.cfgCheckbox('AutoClutch', 'autoclutch_enabled')
	if cfg.autoclutch_enabled then
		ui.offsetCursorY(4)
		u.hint('Pressiona a embreagem ao trocar de marcha.')
		ui.offsetCursorY(4)
		ui.setNextItemWidth(u.getSliderWidth())
		local newDepth = ui.slider('##autoclutch_depth',
			cfg.autoclutch_depth * 100, 0, 100, 'Profundidade:  %.0f%%')
		if ui.itemEdited() then cfg.autoclutch_depth = newDepth / 100.0; data.dirty = true end
		if cfg.autoclutch_depth ~= defaults.autoclutch_depth then
			ui.sameLine(0,4)
			ui.pushStyleColor(ui.StyleColor.Text, u.colChanged); ui.text('●'); ui.popStyleColor()
		end
		ui.sameLine(0,4)
		ui.pushStyleColor(ui.StyleColor.Text, u.getColAccent()); ui.text('?'); ui.popStyleColor()
		if ui.itemHovered() then ui.setTooltip('100% = totalmente pisada.\n50% = pisada pela metade.') end
		ui.offsetCursorY(4)
		u.cfgSlider('Vel. Pressionar', 'autoclutch_press_speed', 0.5, 20.0, '%.1f',
			'Velocidade do AutoClutch ao pressionar.')
		u.cfgSlider('Vel. Soltar', 'autoclutch_release_speed', 0.5, 20.0, '%.1f',
			'Velocidade do AutoClutch ao soltar.')
	else
		ui.offsetCursorY(4); u.hint('AutoClutch desativado.')
	end

	-- Anti-Stall
	u.header('ANTI-STALL')
	u.cfgCheckbox('Anti-Stall', 'antistall_enabled')
	if cfg.antistall_enabled then
		ui.offsetCursorY(4)
		u.hint('Gerencia a embreagem usando velocidade + acelerador.')
		ui.offsetCursorY(4)
		u.cfgSlider('Vel. engate total', 'antistall_full_speed', 10.0, 80.0, '%.0f km/h',
			'Acima disso, embreagem 100%% solta.')
		u.cfgSlider('Vel. mínima', 'antistall_min_speed', 0.0, 10.0, '%.1f km/h',
			'Abaixo disso (sem gás), embreagem pisada.')
		ui.offsetCursorY(4)
		ui.setNextItemWidth(u.getSliderWidth())
		local newBite = ui.slider('##antistall_bite_point',
			cfg.antistall_bite_point * 100, 10, 90, 'Bite Point:  %.0f%%')
		if ui.itemEdited() then cfg.antistall_bite_point = newBite / 100.0; data.dirty = true end
		if cfg.antistall_bite_point ~= defaults.antistall_bite_point then
			ui.sameLine(0,4)
			ui.pushStyleColor(ui.StyleColor.Text, u.colChanged); ui.text('●'); ui.popStyleColor()
		end
		ui.sameLine(0,4)
		ui.pushStyleColor(ui.StyleColor.Text, u.getColAccent()); ui.text('?'); ui.popStyleColor()
		if ui.itemHovered() then ui.setTooltip('Quanto a embreagem solta ao acelerar parado.\n50%% = suave | 70%% = agressivo') end
		ui.offsetCursorY(4)
		u.cfgSlider('Vel. engatar', 'antistall_engage_speed', 0.5, 15.0, '%.1f',
			'Rapidez ao soltar embreagem.')
		u.cfgSlider('Vel. desengatar', 'antistall_disengage_speed', 0.5, 15.0, '%.1f',
			'Rapidez ao pisar embreagem.')
		u.cfgSlider('Gamma', 'antistall_gamma', 0.3, 3.0, '%.2f',
			'1.0 = linear | >1.0 = segura mais em baixa vel.')
		u.cfgSlider('Suavização', 'antistall_target_smooth', 0.0, 0.99, '%.2f',
			'0.0 = reativo | 0.92 = suave')
		ui.offsetCursorY(4)
		ui.setNextItemWidth(u.getSliderWidth())
		local newPress = ui.slider('##antistall_max_press',
			cfg.antistall_max_press * 100, 0, 100, 'Prof. máx:  %.0f%%')
		if ui.itemEdited() then cfg.antistall_max_press = newPress / 100.0; data.dirty = true end
		if cfg.antistall_max_press ~= defaults.antistall_max_press then
			ui.sameLine(0,4)
			ui.pushStyleColor(ui.StyleColor.Text, u.colChanged); ui.text('●'); ui.popStyleColor()
		end
	else
		ui.offsetCursorY(4)
		u.hint('Anti-Stall desativado.')
		u.hint('Cuidado: o motor pode morrer em baixa velocidade!')
	end

	-- No-Lift Shift
	u.header('NO-LIFT SHIFT')
	u.cfgCheckbox('No-Lift Shift', 'nls_enabled')
	if cfg.nls_enabled then
		ui.offsetCursorY(4)
		u.hint('Corta o acelerador ao trocar de marcha.')
		ui.offsetCursorY(4)
		u.cfgSlider('Duração do corte', 'nls_cut_duration', 30, 300, '%.0f ms',
			'Tempo de corte ao trocar.')
		ui.setNextItemWidth(u.getSliderWidth())
		local newCutAmt = ui.slider('##nls_cut_amount',
			cfg.nls_cut_amount * 100, 0, 80, 'Gás residual:  %.0f%%')
		if ui.itemEdited() then cfg.nls_cut_amount = newCutAmt / 100.0; data.dirty = true end
		if cfg.nls_cut_amount ~= defaults.nls_cut_amount then
			ui.sameLine(0,4)
			ui.pushStyleColor(ui.StyleColor.Text, u.colChanged); ui.text('●'); ui.popStyleColor()
		end
		ui.sameLine(0,4)
		ui.pushStyleColor(ui.StyleColor.Text, u.getColAccent()); ui.text('?'); ui.popStyleColor()
		if ui.itemHovered() then ui.setTooltip('0%% = corte total.\n50%% = mantém metade.') end
		ui.offsetCursorY(4)
		u.cfgCheckbox('Só ao subir marcha', 'nls_only_upshift')
		u.cfgSlider('RPM mínimo', 'nls_min_rpm', 1000, 8000, '%.0f',
			'Abaixo disso, NLS não ativa.')
	else
		ui.offsetCursorY(4); u.hint('No-Lift Shift desativado.')
	end

	-- Auto-Blip
	u.header('AUTO-BLIP (REV MATCH)')
	u.cfgCheckbox('Auto-Blip', 'blip_enabled')
	if cfg.blip_enabled then
		ui.offsetCursorY(4)
		u.hint('Puxada no acelerador ao reduzir marcha.')
		ui.offsetCursorY(4)
		u.cfgSlider('Intensidade', 'blip_intensity', 0.1, 1.0, '%.2f',
			'Quanto de gás o blip aplica.')
		u.cfgSlider('Duração', 'blip_duration', 50, 300, '%.0f ms',
			'Tempo do blip.')
		ui.offsetCursorY(4)
		u.cfgCheckbox('Só ao frear', 'blip_only_braking')
	else
		ui.offsetCursorY(4); u.hint('Auto-Blip desativado.')
	end
end

return M