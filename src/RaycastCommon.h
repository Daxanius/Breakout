#pragma once

#include <sol/sol.hpp>
#include "Vector.h"

struct Ray {
	static void RegisterLua(sol::state& m_Lua);

	Ray(const Vector& origin, const Vector& direction, float length);

	Vector origin;
	Vector direction;
	float length;
};

struct HitInfo {
	static void RegisterLua(sol::state& m_Lua);

	Vector hitPoint;
	Vector normal;
	float t;
	bool hit;
};
