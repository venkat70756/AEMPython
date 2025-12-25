import sys
from importlib.metadata import version, PackageNotFoundError

REQUIRED = {
    "Pillow": "10.2.0",
    "requests": "2.31.0"
}

errors = []

for pkg, required_version in REQUIRED.items():
    try:
        installed = version(pkg)
        if installed != required_version:
            errors.append(
                f"{pkg}=={required_version} (installed: {installed})"
            )
    except PackageNotFoundError:
        errors.append(f"{pkg}=={required_version} (not installed)")

if errors:
    print("INVALID_DEPENDENCIES")
    for e in errors:
        print(e)
    sys.exit(1)

print("Python dependencies OK")
sys.exit(0)
