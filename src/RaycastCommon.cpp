#include "RaycastCommon.h"

void Ray::RegisterLua(sol::state& m_Lua) {
	m_Lua.new_usertype<Ray>("Ray", sol::constructors<Ray(Vector, Vector, float)>(),
														 "direction", &Ray::direction,
														 "origin", &Ray::origin,
														 "length", &Ray::length
	);
}

Ray::Ray(const Vector& origin, const Vector& direction, float length) : origin(origin), direction(direction), length(length) {
}

void HitInfo::RegisterLua(sol::state& m_Lua) {
	m_Lua.new_usertype<HitInfo>("HitInfo", sol::no_constructor,
													"hitPoint", &HitInfo::hitPoint,
													"normal", &HitInfo::normal,
													"t", &HitInfo::t,
													"hit", &HitInfo::hit
	);
}
