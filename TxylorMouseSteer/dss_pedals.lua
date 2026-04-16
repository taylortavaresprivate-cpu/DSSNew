-- ========================================================================
-- DSS PEDALS MODULE
-- ========================================================================
-- Função approach() + lógica de gas, brake e handbrake
-- ========================================================================

local cfg = require "dss_config"

local pedals = {}

pedals.gasValue       = 0
pedals.brakeValue     = 0
pedals.handbrakeValue = 0

function pedals.approach(current, target, speed, dt)
	if current < target then
		return math.min(current + speed * dt, target)
	else
		return math.max(current - speed * dt, target)
	end
end

function pedals.updateGas(dt, gasTarget)
	local speed = gasTarget > pedals.gasValue and cfg.GAS_PRESS_SPEED or cfg.GAS_RELEASE_SPEED
	pedals.gasValue = pedals.approach(pedals.gasValue, gasTarget, speed, dt)
	return pedals.gasValue
end

function pedals.updateBrake(dt, brakeTarget)
	local speed = brakeTarget > pedals.brakeValue and cfg.BRAKE_PRESS_SPEED or cfg.BRAKE_RELEASE_SPEED
	pedals.brakeValue = pedals.approach(pedals.brakeValue, brakeTarget, speed, dt)
	return pedals.brakeValue
end

function pedals.updateHandbrake(dt, handbrakeTarget)
	local speed = handbrakeTarget > pedals.handbrakeValue and cfg.HANDBRAKE_PRESS_SPEED or cfg.HANDBRAKE_RELEASE_SPEED
	pedals.handbrakeValue = pedals.approach(pedals.handbrakeValue, handbrakeTarget, speed, dt)
	return pedals.handbrakeValue
end

return pedals