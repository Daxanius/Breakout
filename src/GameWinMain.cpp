//-----------------------------------------------------------------
// Game Engine WinMain Function
// C++ Source - GameWinMain.cpp - version v8_01
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Include Files
//-----------------------------------------------------------------
#include "GameWinMain.h"
#include "GameEngine.h"

#include "Game.h"	

#include <string>
#include <stdexcept>

//-----------------------------------------------------------------
// Create GAME_ENGINE global (singleton) object and pointer
//-----------------------------------------------------------------
GameEngine myGameEngine;
GameEngine* GAME_ENGINE{ &myGameEngine };

//-----------------------------------------------------------------
// Main Function
//-----------------------------------------------------------------
int APIENTRY wWinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
{
	try {

		GAME_ENGINE->SetGame(new Game());					// any class that implements AbstractGame

		return GAME_ENGINE->Run(hInstance, nCmdShow);		// here we go
	} catch (std::runtime_error e) {
		GAME_ENGINE->MessageBox(GAME_ENGINE->ConvertToWString(e));
		return -1;
	}

	return 0;
}

