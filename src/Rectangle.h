#pragma once

#include "Vector.h"
#include "RaycastCommon.h"

class Rectangle {
public:
	static void RegisterLua(sol::state& m_Lua);

	// Potentially takes ownership of the vectors
	Rectangle(const Vector& position, const Vector& size);

	HitInfo Intersect(const Ray& ray) const;

	void SetPosition(const Vector& position);
	void SetSize(const Vector& size);

	Vector GetPosition() const;
	Vector GetSize() const;
	Vector GetCenter() const;
	Vector GethalfSize() const;
private:
	void CalculateHalfSize();
	void CalculateCenter();

	Vector m_Position;
	Vector m_Size;
	Vector m_Center;
	Vector m_HalfSize;
};