Magic 8 Ball (PySide6 + QML)
A sleek desktop Magic 8 Ball built with Python 3 and PySide6 (Qt Quick/QML). Features a modern dark UI, animated “Thinking…” spinner, 20 classic responses, and controls for Ask, Clear, Play Again, and Quit.

Preview
Type a yes/no question, click Ask (or press Enter), see “Thinking…”, then a randomized answer.

Clear or Play Again resets the state; Esc quits the app.

Project structure
app/main.py — Python backend exposing state and actions to QML

ui/Main.qml — UI layout, styles, and animations (no extra effects modules required)

assets/icons/ball.svg — Optional icon shown in the header (use PNG if preferred)

assets/fonts/Inter-Regular.ttf, Inter-SemiBold.ttf — Optional fonts (remove FontLoader lines if not used)

Recommended layout:

magic8/

app/main.py

ui/Main.qml

assets/icons/ball.svg

assets/fonts/Inter-Regular.ttf

assets/fonts/Inter-SemiBold.ttf

Requirements
Python 3.8+ (recommended 3.10+)

PySide6

Install
Optionally create a virtual environment:

python -m venv venv

Windows PowerShell: .\venv\Scripts\Activate.ps1

Windows CMD: venv\Scripts\activate.bat

macOS/Linux: source venv/bin/activate

Install dependency:

pip install pyside6

Run
From the project root (the folder containing app/ and ui/):

python app/main.py

If python invokes Python 2 on macOS/Linux, use python3.

Usage
Type a question in the text area.

Click Ask or press Enter to get a response after a short “Thinking…” animation.

Clear or Play Again resets the input and status.

Quit closes the window (Esc also works).

Configuration
Icon: ensure the icon file exists at assets/icons/ball.svg and the Image in Main.qml points to ../assets/icons/ball.svg. If SVG support is unavailable, use a PNG and update the path.

Fonts: if Inter isn’t included, remove the FontLoader lines in Main.qml to use system fonts.

Troubleshooting
Window doesn’t open / QML load error:

Run from project root so ui/Main.qml is found by the relative path used in Python.

Icon doesn’t show:

Confirm the relative path ../assets/icons/ball.svg from ui/Main.qml is correct and the file exists. Try a PNG if needed.

Module errors for “QtQuick.Effects” or “DropShadow”:

This app doesn’t use those modules. Ensure the provided Main.qml version (without Effects/DropShadow) is in use.

PySide6 not found:

Install it in the active environment with pip install pyside6 and ensure the venv is activated.

Packaging (optional)
Create a single executable using PyInstaller.

Install: pip install pyinstaller

Windows:

pyinstaller --noconsole --onefile --add-data "ui/Main.qml;ui" --add-data "assets/icons/ball.svg;assets/icons" --add-data "assets/fonts/Inter-Regular.ttf;assets/fonts" --add-data "assets/fonts/Inter-SemiBold.ttf;assets/fonts" app/main.py

macOS/Linux (use colons as separators):

pyinstaller --noconsole --onefile --add-data "ui/Main.qml:ui" --add-data "assets/icons/ball.svg:assets/icons" --add-data "assets/fonts/Inter-Regular.ttf:assets/fonts" --add-data "assets/fonts/Inter-SemiBold.ttf:assets/fonts" app/main.py

Output binary will be in dist/.

Tech stack
Python 3 + PySide6

QML (Qt Quick) for UI and animations
