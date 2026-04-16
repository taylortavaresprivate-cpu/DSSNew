-- ========================================================================
-- DSS AUTO-BLIP MODULE
-- ========================================================================
-- Auto-blip inteligente que calcula o RPM ideal da marcha inferior
-- ========================================================================

local cfg = require "dss_config"

local blip = {}

-- Estado interno
local prevGear = -999
local blipActive = false
local blipStartTime = 0
local targetRPM = 0

function blip.update(dt, data, currentGear, currentGas)
	
	-- ── 1. DETECTAR REDUÇÃO DE MARCHA ────────────────────────────────
	if cfg.BLIP_ENABLED and currentGear > 0 and prevGear > currentGear and prevGear ~= -999 then
		-- Redução detectada! Calcular RPM alvo
		
		-- Pegar dados do carro
		local currentRPM = car.rpm
		local speedKmh = math.abs(car.speedKmh)
		
		-- Calcular fator baseado na diferença de marchas
		local gearDiff = prevGear - currentGear
		local blipFactor = 1.0 + (gearDiff * 0.4)  -- cada marcha = +40% de RPM
		
		targetRPM = currentRPM * blipFactor
		
		-- Limitar ao RPM do limiter (segurança)
		if car.rpmLimiter and car.rpmLimiter > 0 then
			targetRPM = math.min(targetRPM, car.rpmLimiter * 0.95)  -- 95% do limiter
		else
			targetRPM = math.min(targetRPM, 9000)  -- fallback seguro
		end
		
		-- Só ativar se a diferença for significativa
		local rpmDiff = targetRPM - currentRPM
		if rpmDiff > cfg.BLIP_MIN_RPM_DIFF then
			blipActive = true
			blipStartTime = os.preciseClock()
			ac.log('[AUTO-BLIP] Ativado! Marcha: ' .. tostring(prevGear) .. ' -> ' .. tostring(currentGear) .. 
			       ' | RPM atual: ' .. tostring(math.floor(currentRPM)) .. 
			       ' | RPM alvo: ' .. tostring(math.floor(targetRPM)) .. 
			       ' | Diferença: ' .. tostring(math.floor(rpmDiff)))
		end
	end
	
	prevGear = currentGear
	
	-- *** FIX: Desativar se o blip foi desligado durante execução ***
	if not cfg.BLIP_ENABLED and blipActive then
		blipActive = false
		ac.log('[AUTO-BLIP] Cancelado - desativado manualmente')
		return currentGas
	end
	
	-- ── 2. PROCESSAR AUTO-BLIP ATIVO ─────────────────────────────────
	if blipActive then
		local currentRPM = car.rpm
		local elapsedTime = (os.preciseClock() - blipStartTime) * 1000  -- em ms
		
		-- Calcular erro de RPM
		local rpmError = targetRPM - currentRPM
		
		-- Calcular throttle proporcional ao erro
		local blipThrottle = 0
		if rpmError > 0 then
			-- Fórmula agressiva para dar mais gás
			blipThrottle = (rpmError / 2000.0) * cfg.BLIP_INTENSITY
			
			-- Garantir um mínimo de 30% de throttle sempre
			blipThrottle = math.max(blipThrottle, 0.3)
			
			-- Clamp entre 0 e 1
			blipThrottle = math.min(math.max(blipThrottle, 0), 1.0)
		end
		
		-- Condições para desativar o blip
		local rpmReached = math.abs(rpmError) < 100  -- tolerância de ±100 RPM
		local timeExpired = elapsedTime > cfg.BLIP_DURATION
		
		if rpmReached or timeExpired then
			blipActive = false
			ac.log('[AUTO-BLIP] Desativado! Tempo: ' .. tostring(math.floor(elapsedTime)) .. 
			       'ms | RPM final: ' .. tostring(math.floor(currentRPM)) .. 
			       ' | Alvo: ' .. tostring(math.floor(targetRPM)))
			return currentGas  -- retorna o gás normal
		end
		
		-- Retornar o maior entre o gás do jogador e o blip (blip tem prioridade)
		return math.max(currentGas, blipThrottle)
	end
	
	-- Sem blip ativo, retorna o gás normal
	return currentGas
end

return blip