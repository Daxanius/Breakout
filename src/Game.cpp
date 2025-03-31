//-----------------------------------------------------------------
// Main Game File
// C++ Source - Game.cpp - version v8_01
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Include Files
//-----------------------------------------------------------------
#include "Game.h"
#include "Vector.h"
#include "Rectangle.h"
#include <filesystem>

//-----------------------------------------------------------------
// Game Member Functions																				
//-----------------------------------------------------------------

Game::Game()
{
	m_Lua.open_libraries(sol::lib::base, sol::lib::table, sol::lib::math, sol::lib::string, sol::lib::package);

	// Set the package.path to include the directory where your Lua files are located
	m_Lua["package"]["path"] = (std::filesystem::current_path() / "game/?.lua").string();

	Vector::RegisterLua(m_Lua);
	Ray::RegisterLua(m_Lua);
	HitInfo::RegisterLua(m_Lua);
	Rectangle::RegisterLua(m_Lua);
	Font::RegisterLua(m_Lua);
	GameEngine::RegisterLua(m_Lua);
	Audio::RegisterLua(m_Lua);

	m_Lua["print"] = [this](sol::variadic_args args) {
		std::wstring result;

		for (auto arg : args) {
			result += arg.as<std::wstring>();
		}

		m_LogMessages.emplace_front(result, TIME_PER_MESSAGE);

		// Limit the number of messages displayed at once
		if (m_LogMessages.size() > MAX_MESSAGES) {
			m_LogMessages.pop_back(); // Remove the oldest message if over limit
		}
	};

	m_Lua.script_file("./game/game.lua", [](lua_State*, sol::protected_function_result pfr) {
		if (!pfr.valid()) {
			sol::error err = pfr;
			throw std::runtime_error("Error running Lua script: " + std::string(err.what()));
		}
		return pfr; // Ensure the function result is returned unchanged
	});
}

Game::~Game()																						
{

}

void Game::Initialize()			
{
	// Define the settings table
	sol::table settings = m_Lua.create_table();
	settings["title"] = "Little Lua Engine";
	settings["width"] = 1024;
	settings["height"] = 768;
	settings["frameRate"] = 50;

	sol::function init = m_Lua["Init"];

	if (!init.valid()) {
		throw std::runtime_error("Invalid Init function");
	}

	init(settings);

	// Retrieve the modified settings from Lua
	try {
		std::wstring title = settings["title"];
		int width = settings["width"];
		int height = settings["height"];
		int frameRate = settings["frameRate"];

		AbstractGame::Initialize();
		GAME_ENGINE->SetTitle(title);
		GAME_ENGINE->SetWidth(width);
		GAME_ENGINE->SetHeight(height);
		GAME_ENGINE->SetFrameRate(frameRate);
	} catch (...) {
		throw std::runtime_error("Invalid settings");
	}


	// Set the keys that the game needs to listen to
	//tstringstream buffer;
	//buffer << _T("KLMO");
	//buffer << (char) VK_LEFT;
	//buffer << (char) VK_RIGHT;
	//GAME_ENGINE->SetKeyList(buffer.str());
}

void Game::Start()
{
	auto start{ m_Lua["Start"] };

	if (start.valid()) {
		start(GAME_ENGINE);
	}
}

void Game::End()
{
	auto end{ m_Lua["End"] };

	if (end.valid()) {
		end(GAME_ENGINE);
	}
}

void Game::Paint(RECT rect) const
{
	sol::function paint = m_Lua["Paint"];

	if (paint.valid()) {
		paint(GAME_ENGINE, rect);
	}

	PaintLogMessages(rect);
}

void Game::Tick()
{
	sol::function tick = m_Lua["Tick"];

	if (tick.valid()) {
		tick(GAME_ENGINE);
	}

	UpdateLastLogMessage();
}

void Game::MouseButtonAction(bool isLeft, bool isDown, int x, int y, WPARAM wParam)
{	
	// Insert code for a mouse button action

	/* Example:
	if (isLeft == true && isDown == true) // is it a left mouse click?
	{
		if ( x > 261 && x < 261 + 117 ) // check if click lies within x coordinates of choice
		{
			if ( y > 182 && y < 182 + 33 ) // check if click also lies within y coordinates of choice
			{
				GAME_ENGINE->MessageBox(_T("Clicked."));
			}
		}
	}
	*/
}

void Game::MouseWheelAction(int x, int y, int distance, WPARAM wParam)
{	
	// Insert code for a mouse wheel action
}

void Game::MouseMove(int x, int y, WPARAM wParam)
{	
	// Insert code that needs to execute when the mouse pointer moves across the game window

	/* Example:
	if ( x > 261 && x < 261 + 117 ) // check if mouse position is within x coordinates of choice
	{
		if ( y > 182 && y < 182 + 33 ) // check if mouse position also is within y coordinates of choice
		{
			GAME_ENGINE->MessageBox("Mouse move.");
		}
	}
	*/
}

void Game::CheckKeyboard()
{	
	// Here you can check if a key is pressed down
	// Is executed once per frame 

	/* Example:
	if (GAME_ENGINE->IsKeyDown(_T('K'))) xIcon -= xSpeed;
	if (GAME_ENGINE->IsKeyDown(_T('L'))) yIcon += xSpeed;
	if (GAME_ENGINE->IsKeyDown(_T('M'))) xIcon += xSpeed;
	if (GAME_ENGINE->IsKeyDown(_T('O'))) yIcon -= ySpeed;
	*/
}

void Game::KeyPressed(TCHAR key)
{	
	// DO NOT FORGET to use SetKeyList() !!

	// Insert code that needs to execute when a key is pressed
	// The function is executed when the key is *released*
	// You need to specify the list of keys with the SetKeyList() function

	/* Example:
	switch (key)
	{
	case _T('K'): case VK_LEFT:
		GAME_ENGINE->MessageBox("Moving left.");
		break;
	case _T('L'): case VK_DOWN:
		GAME_ENGINE->MessageBox("Moving down.");
		break;
	case _T('M'): case VK_RIGHT:
		GAME_ENGINE->MessageBox("Moving right.");
		break;
	case _T('O'): case VK_UP:
		GAME_ENGINE->MessageBox("Moving up.");
		break;
	case VK_ESCAPE:
		GAME_ENGINE->MessageBox("Escape menu.");
	}
	*/
}

void Game::CallAction(Caller* callerPtr)
{
	// Insert the code that needs to execute when a Caller (= Button, TextBox, Timer, Audio) executes an action
}

void Game::PaintLogMessages(RECT rect) const {
	GAME_ENGINE->SetColor(RGB(255, 0, 0));

	int top = 10;

	for (auto& log : m_LogMessages) {
		if (top >= (rect.top + rect.bottom) - MESSAGE_SPACING) {
			break;  // Stop drawing if we exceed the space
		}

		GAME_ENGINE->DrawString(log.message, 10, top);
		top += MESSAGE_SPACING;
	}
}

void Game::UpdateLastLogMessage() {
	float delta = 1.0f / GAME_ENGINE->GetFrameRate();

	// Update timeLeft for each message
	for (auto it = m_LogMessages.begin(); it != m_LogMessages.end();) {
		it->timeLeft -= delta;

		if (it->timeLeft <= 0) {
			it = m_LogMessages.erase(it); // Remove expired messages
		} else {
			++it;
		}
	}
}
