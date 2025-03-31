#include "Rectangle.h"

void Rectangle::RegisterLua(sol::state& m_Lua) {
	m_Lua.new_usertype<Rectangle>("Rectangle", sol::constructors<Rectangle(const Vector&, const Vector&)>(),
																"position", sol::property(&Rectangle::GetPosition, &Rectangle::SetPosition),
																"size", sol::property(&Rectangle::GetSize, &Rectangle::SetSize),
																"center", sol::readonly(&Rectangle::m_Center),
																"halfSize", sol::readonly(&Rectangle::m_HalfSize),
																"intersect", &Rectangle::Intersect
	);
}

Rectangle::Rectangle(const Vector& position, const Vector& size) : m_Position(position), m_Size(size), m_HalfSize(Vector()), m_Center(Vector()) {
	CalculateHalfSize();
	CalculateCenter();
}

HitInfo Rectangle::Intersect(const Ray& ray) const {
	float tMin = 0.0f, tMax = ray.length;
	Vector normals[2] = { {-1, 0}, {0, -1} }; // X-axis and Y-axis normals (signs adjusted as needed)

	Vector bounds[2] = {
			{m_Center.x - m_HalfSize.x, m_Center.y - m_HalfSize.y}, // Min corner
			{m_Center.x + m_HalfSize.x, m_Center.y + m_HalfSize.y}  // Max corner
	};

	Vector hitNormal{ 0, 0 };

	// X AXIS
	float invD = 1.0f / ray.direction.x;
	float t0 = (bounds[0].x - ray.origin.x) * invD;
	float t1 = (bounds[1].x - ray.origin.x) * invD;

	if (invD < 0.0f) std::swap(t0, t1); // Ensure t0 < t1

	if (t0 > tMin) {
		tMin = t0;
		hitNormal = { invD > 0.0f ? -1.0f : 1.0f, 0.0f }; // Left or Right normal
	}

	if (t1 < tMax) tMax = t1;

	if (tMin > tMax) return { Vector{0, 0}, Vector{0, 0}, -1, false }; // No intersection

	// Y AXIS
	invD = 1.0f / ray.direction.y;
	t0 = (bounds[0].y - ray.origin.y) * invD;
	t1 = (bounds[1].y - ray.origin.y) * invD;

	if (invD < 0.0f) std::swap(t0, t1); // Ensure t0 < t1

	if (t0 > tMin) {
		tMin = t0;
		hitNormal = { 0.0f, invD > 0.0f ? -1.0f : 1.0f }; // Bottom or Top normal
	}

	if (t1 < tMax) tMax = t1;

	if (tMin > tMax) return { Vector{0, 0}, Vector{0, 0}, -1, false }; // No intersection

	return { ray.origin + (ray.direction * tMin), hitNormal, tMin, true };
}


void Rectangle::SetPosition(const Vector& position) {
	m_Position = position;
	CalculateCenter();
}

void Rectangle::SetSize(const Vector& size) {
	m_Size = size;
	CalculateHalfSize();
	CalculateCenter();
}

Vector Rectangle::GetPosition() const {
	return m_Position;
}

Vector Rectangle::GetSize() const {
	return m_Size;
}

Vector Rectangle::GetCenter() const {
	return m_Center;
}

Vector Rectangle::GethalfSize() const {
	return m_HalfSize;
}

void Rectangle::CalculateHalfSize() {
	m_HalfSize = Vector(m_Size.x / 2, m_Size.y / 2);
}

void Rectangle::CalculateCenter() {
	m_Center = Vector(m_Position.x + m_HalfSize.x, m_Position.y + m_HalfSize.y);
}
