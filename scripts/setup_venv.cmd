@echo off
python -m venv .venv
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
echo.
echo Phase 1 Python environment is ready.
echo Activate later with: .venv\Scripts\activate
pause
