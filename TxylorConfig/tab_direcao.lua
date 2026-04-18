-- ========================================================================
-- DSS TAB: DIREÇÃO
-- ========================================================================

local data = require "cfg_data"
local cfg  = data.cfg
local u    = require "cfg_ui"

local M = {}

function M.draw()
	u.header('FORCE FEEDBACK')
	u.cfgCheckbox('FFB Ativado', 'ffb_enabled')
	if cfg.ffb_enabled then
		ui.offsetCursorY(4)
		u.cfgSlider('FFB Gain', 'ffb_gain', 0.0, 10.0, '%.1f',
			'Intensidade da resistência do volante.\n0.0 = sem FFB | 1.0 = padrão | 10.0 = máximo')
		u.hint('Intensidade da resistência do volante.')
		u.cfgSlider('Gyro Gain', 'gyro_gain', 0.0, 20.0, '%.1f',
			'Influência da rotação do carro no volante.\nValores altos = reage mais.')
		u.hint('Influência da rotação do carro no volante.')
		u.cfgSlider('Counter Steer', 'steer_counter_steer', 0.0, 2.0, '%.2f',
			'Contra-esterço do volante.\n2.0 = sem limite | 0.0 = desativado')
		u.hint('Contra-esterço do volante.')
		u.cfgSlider('FFB Damper', 'ffb_damper', 0.0, 3.0, '%.2f',
			'Amortece oscilações bruscas do volante.\n0.0 = sem amortecimento | 0.5 = recomendado | 3.0 = máximo')
		u.hint('Amortece oscilações bruscas do volante.')
		u.cfgSlider('FFB Lateral', 'ffb_lateral', 0.0, 2.0, '%.2f',
			'Força G lateral no volante.\n0.0 = desativado | 0.3 = sutil | 2.0 = intenso')
		u.hint('Força lateral nas curvas.')
		u.cfgSlider('FFB Gamma', 'ffb_gamma', 0.5, 2.5, '%.2f',
			'Curva do sinal de FFB.\n1.0 = linear | >1.0 = suave no centro | <1.0 = agressivo')
		u.hint('Curva de resposta do FFB.')
	else
		ui.offsetCursorY(4)
		u.info('FFB desativado — volante controlado apenas pelo mouse.')
	end

	u.header('SENSIBILIDADE')
	u.cfgSlider('Sensibilidade', 'steer_sensi', 10.0, 150.0, '%.0f',
		'Velocidade de resposta do volante ao mouse.')
	u.hint('Velocidade de resposta do volante ao mouse.')

	u.header('LIMITE DE ESTERÇO')
	u.cfgSlider('Steer Limit', 'steer_limit', 0.3, 1.0, '%.2f',
		'Limita a rotação máxima do volante.\n1.0 = 900° | 0.5 = 450°')
	local deg = math.floor(cfg.steer_limit * 900 + 0.5)
	u.hint('Rotação máxima: '..deg..'°')

	u.header('CURVA DE RESPOSTA')
	u.cfgSlider('Gamma', 'steer_gamma', 0.5, 2.5, '%.2f',
		'1.0 = linear\n>1.0 = suave no centro\n<1.0 = agressivo no centro')

	u.header('SUAVIZAÇÃO')
	u.cfgSlider('Filter', 'steer_filter', 0.0, 0.95, '%.2f',
		'0.0 = sem filtro | 0.6 = moderado | 0.8+ = lento')
	u.header('VELOCIDADE DO VOLANTE')
	u.cfgSlider('Max Rate', 'steer_max_rate', 0.5, 10.0, '%.1f',
		'Velocidade máxima de inversão do volante.\nBaixo = restringe movimentos bruscos | Alto = mais livre')
	u.hint('Velocidade máxima de giro ao inverter o esterço.')

	u.header('SENSIBILIDADE POR VELOCIDADE')
	u.cfgSlider('Speed Sensi', 'speed_sensi', 0.0, 1.0, '%.2f',
		'Reduz sensibilidade em alta velocidade.\n1.0 = sem redução')
	if cfg.speed_sensi < 1.0 then
		ui.offsetCursorY(4)
		u.cfgSlider('Vel. início', 'speed_sensi_start', 20.0, 200.0, '%.0f km/h',
			'Velocidade onde a redução começa.')
		u.cfgSlider('Vel. máxima', 'speed_sensi_end', 100.0, 350.0, '%.0f km/h',
			'Velocidade onde a redução atinge o mínimo.')
	end
end

return M
