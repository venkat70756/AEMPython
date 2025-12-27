# Python Environment Validation for AEM Maven Build

## Overview
This documentation outlines the process for validating the Python environment during the Maven build lifecycle for AEM projects. The validation ensures that the required Python version and dependencies are present on the system before any build artifacts are generated or deployment steps are executed.

## Maven Integration
The Python environment validation is integrated into the Maven build lifecycle via the `pom.xml` file. The validation is executed during the **validate phase**, ensuring that all necessary Python components are verified before proceeding with any build or deployment operations.

## OS-Specific Profile Activation
The `pom.xml` defines OS-specific Maven profiles that are automatically activated based on the operating system in use. This automatic activation eliminates the need for manual profile selection:

- **Windows Profile**: Activated when running the build on a Windows environment.
- **Unix Profile**: Activated for macOS, Linux, Docker, or CI/CD pipeline environments.

The correct validation script is invoked automatically based on the OS profile.

## Validation Script Execution

Each profile utilizes the `exec-maven-plugin` to run the appropriate validation script:

### 1. **Windows Environment**
- **Script**: `check-python.bat`
- **Execution**: Runs using the Windows command shell (`cmd`)
- **Validation checks**:
    - Presence of Python
    - Exact Python version
    - Exact pip version
    - Required Python dependencies

### 2. **macOS/Linux Environment**
- **Script**: `check-python.sh`
- **Execution**: Runs using the shell (`sh`)
- **Validation checks**:
    - Same checks as the Windows script, ensuring consistency across all Unix-based systems.

## Python Version and Dependency Management

### Python Version
Developers must ensure that the exact Python version specified in the respective validation script is installed:

- **Windows**: `check-python.bat`
- **macOS/Linux**: `check-python.sh`

The Maven build will fail if a different Python version is detected during the validation.

### Python Dependencies
The required Python dependencies are managed through the `check_deps.py` file, which serves as the single source of truth for Python package versions across all environments.

- **Dependency Validation**: The build will fail if any required dependencies are missing or mismatched.
- **Dependency Management**: Developers must ensure that all necessary dependencies are added to `check_deps.py` to maintain consistency across environments.

## Adding New Python Dependencies
To add a new Python package or update existing dependencies:

1. Modify the `check_deps.py` file to include the new package name and required version.
2. The validation scripts will automatically enforce these changes across all environments, ensuring that the new dependency is validated during future builds.

## Benefits of this Approach
- **Environment Consistency**: Ensures all environments (local development, CI/CD, production) are aligned.
- **Reproducible Builds**: Guarantees that builds are consistent and will behave the same regardless of where they are executed.
- **Early Detection of Configuration Issues**: Identifies environment mismatches or missing dependencies early in the build process.
- **Alignment with CI/CD and Production Standards**: Enforces the same Python environment configuration across all stages of development and deployment.

## Conclusion
This approach provides a streamlined, automated method to ensure that Python dependencies and versions are consistently validated across different operating systems and environments. By integrating Python environment validation into the Maven build lifecycle, developers can avoid common configuration issues and ensure smooth, reproducible builds.

---

### Author
**Yeti Venkatrao**  
AEM Developer
