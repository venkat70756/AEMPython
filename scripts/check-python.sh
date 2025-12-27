#!/bin/sh

# =====================================================
# Locked environment
# =====================================================
REQUIRED_PYTHON_VERSION="3.12.0"
REQUIRED_PIP_VERSION="23.2.1"

echo "Validating Python environment (Unix)..."

# =====================================================
# 1. Check python exists
# =====================================================
if command -v python3 >/dev/null 2>&1; then
    PYTHON=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON=python
else
    echo "ERROR: Python not found"
    echo "Required: Python ${REQUIRED_PYTHON_VERSION}"
    exit 1
fi

# =====================================================
# 2. Python version check (exact)
# =====================================================
PY_VER=$($PYTHON --version 2>&1 | awk '{print $2}')
if [ "$PY_VER" != "$REQUIRED_PYTHON_VERSION" ]; then
    echo "ERROR: Python ${PY_VER} detected"
    echo "Required: Python ${REQUIRED_PYTHON_VERSION}"
    exit 1
fi
echo "Python ${PY_VER} detected."

# =====================================================
# 3. pip version check
# =====================================================
PIP_VER=$($PYTHON -m pip --version | awk '{print $2}')
if [ "$PIP_VER" != "$REQUIRED_PIP_VERSION" ]; then
    echo "ERROR: pip ${PIP_VER} detected"
    echo "Required: pip ${REQUIRED_PIP_VERSION}"
    exit 1
fi
echo "pip ${PIP_VER} detected."

# =====================================================
# 4. Python dependency check
# =====================================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

OUTPUT=$($PYTHON "$SCRIPT_DIR/check_deps.py" 2>&1)
STATUS=$?

echo "$OUTPUT"

if echo "$OUTPUT" | grep -q "INVALID_DEPENDENCIES"; then
    echo
    echo "ERROR: Missing or wrong Python dependencies detected"
    echo
    exit 1
fi

if [ $STATUS -ne 0 ]; then
    exit 1
fi

# =====================================================
# Success
# =====================================================
echo
echo "Python environment validated successfully"
exit 0
