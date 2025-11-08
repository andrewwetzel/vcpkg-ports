# --- Configuration ---
# Get the absolute path to this Makefile's directory
ROOT_DIR := $(CURDIR)

# Define the local vcpkg clone directory
VCPKG_DIR := $(ROOT_DIR)/.vcpkg

# Define the canonical path to the vcpkg toolchain file
VCPKG_TOOLCHAIN := $(VCPKG_DIR)/scripts/buildsystems/vcpkg.cmake

# --- Targets ---
# Define phony targets (targets that aren't files)
.PHONY: all test-onnxruntime clean $(VCPKG_DIR)

# Default target: running 'make' will run 'test-onnxruntime'
all: test-onnxruntime

# Define the vcpkg executable path
VCPKG_EXE := $(VCPKG_DIR)/vcpkg

# Target to automatically clone and bootstrap vcpkg
# This now checks for the EXECUTABLE, not just the directory.
$(VCPKG_EXE):
	@echo "--- vcpkg executable not found, bootstrapping... ---"
	@rm -rf $(VCPKG_DIR) # Remove any partial clone
	@echo "--- Cloning vcpkg into $(VCPKG_DIR) ---"
	@git clone https://github.com/microsoft/vcpkg.git $(VCPKG_DIR)
	@$(VCPKG_DIR)/bootstrap-vcpkg.sh
	@echo "--- vcpkg bootstrap complete ---"

# Target to test the onnxruntime port
test-onnxruntime: $(VCPKG_EXE) # <-- NOTE: This dependency has changed
	@echo "--- [TEST] Configuring test build for onnxruntime ---"

# Target to test the onnxruntime port
test-onnxruntime: $(VCPKG_EXE)
	@echo "--- [TEST] Configuring test build for onnxruntime ---"
	$(eval TEST_DIR := $(ROOT_DIR)/tests/test-onnxruntime)
	$(eval BUILD_DIR := $(TEST_DIR)/build)
	
	# Clean and create the build directory
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)
	
	@echo "--- [TEST] Running CMake... ---"
	@cmake -S $(TEST_DIR) -B $(BUILD_DIR) \
		-DCMAKE_TOOLCHAIN_FILE=$(VCPKG_TOOLCHAIN)
		
	@echo "--- [TEST] Building test project... ---"
	@cmake --build $(BUILD_DIR)
	
	@echo "--- [TEST] Build complete! ---"

# Target to clean up all test builds
clean:
	@echo "--- Cleaning test builds ---"
	@rm -rf $(ROOT_DIR)/tests/test-onnxruntime/build