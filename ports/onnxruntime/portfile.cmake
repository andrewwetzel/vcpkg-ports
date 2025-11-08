# This is a basic portfile for a static, CPU-only build.
include(${VCPKG_ROOT_DIR}/scripts/ports/vcpkg-port-helpers.cmake)
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# 1. Get the source code
#    UPDATE THE REF AND SHA512
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/onnxruntime
    # --- !! UPDATE THIS !! ---
    REF "v1.19.2" # <-- Put your project's submodule commit hash here
    # --- !! UPDATE THIS !! ---
    SHA512 3bf25e431d175c61953d28b1bf8f6871376684263992451a5b2a66e670768fc66e7027f141c6e3f4d1eddeebeda51f31ea0adf4749e50d99ee89d0a26bec77ce
    HEAD_REF main
)

# 2. Configure the CMake build
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/cmake" # onnxruntime's CMakeLists.txt is in a subfolder
    OPTIONS
        # --- Build Configuration ---
        -Donnxruntime_BUILD_SHARED_LIB=OFF
        -Donnxruntime_BUILD_UNIT_TESTS=OFF
        -Donnxruntime_ENABLE_TRAINING=OFF
        -Donnxruntime_ENABLE_PYTHON=OFF
        -Donnxruntime_BUILD_CSHARP=OFF

        # --- Explicitly Disable ALL GPU providers ---
        -Donnxruntime_USE_CUDA=OFF
        -Donnxruntime_USE_TENSORRT=OFF
        -Donnxruntime_USE_DML=OFF
        -Donnxruntime_USE_OPENVINO=OFF
        -Donnxruntime_USE_ROCM=OFF
)

# 3. Build and install
vcpkg_cmake_install()

# 4. Clean up unnecessary files
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# 5. Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" 
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" 
     RENAME copyright)