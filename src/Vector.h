#pragma once

#include <sol/sol.hpp>

struct Vector {
	static void RegisterLua(sol::state& m_Lua);

	Vector(float x, float y);
	Vector();

	float LengthSquared() const;
	float Length() const;

	float Distance(const Vector& other) const;

	Vector Normalized() const;

	Vector Reflection(const Vector& normal) const;

	float Dot(const Vector& other) const;

	// Vector& operator*=(float scalar);
	Vector operator*(float scalar) const;

	// Vector& operator+=(const Vector& other);
	Vector operator+(const Vector& other) const;

	Vector operator-(const Vector& other) const;

	float x;
	float y;
};