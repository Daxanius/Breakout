#include "Vector.h"

void Vector::RegisterLua(sol::state& m_Lua) {
	m_Lua.new_usertype<Vector>("Vector", sol::constructors<Vector(float, float), Vector()>(),
														 "lengthSquared", &Vector::LengthSquared,
														 "length", &Vector::Length,
														 "normalized", &Vector::Normalized,
														 "distance", &Vector::Distance,
														 "reflection", &Vector::Reflection,
														 "dot", &Vector::Dot,
														 sol::meta_function::addition, &Vector::operator+,
														 sol::meta_function::multiplication, &Vector::operator*,
														 sol::meta_function::subtraction, &Vector::operator-,
														 "x", &Vector::x,
														 "y", &Vector::y
	);
}

Vector::Vector(float x, float y) : x(x), y(y) {
}

Vector::Vector() : x(0.f), y(0.f) {

}

float Vector::LengthSquared() const {
	return x * x + y * y;
}

float Vector::Length() const {
	return sqrtf(LengthSquared());
}

float Vector::Distance(const Vector& other) const {
	return std::hypot(x - other.x, y - other.y);
}

Vector Vector::Normalized() const {
	const float length{ Length() };
	return Vector(x / length, y / length);
}

Vector Vector::Reflection(const Vector& normal) const {
	Vector res{ (normal * Dot(normal)) * 2 };
	return Vector(x - res.x, y - res.y);
}

float Vector::Dot(const Vector& other) const {
	return x * other.x + y * other.y;
}

//Vector& Vector::operator*=(float scalar) {
//	x *= scalar;
//	y *= scalar;
//	return *this;
//}

Vector Vector::operator*(float scalar) const {
	return Vector(x * scalar, y * scalar);
}

//Vector& Vector::operator+=(const Vector& other) {
//	x += other.x;
//	y += other.y;
//	return *this;
//}

Vector Vector::operator+(const Vector& other) const {
	return Vector(x + other.x, y + other.y);
}

Vector Vector::operator-(const Vector& other) const {
	return Vector(x - other.x, y - other.y);
}
