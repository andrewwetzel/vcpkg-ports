vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/onnxruntime
    REF "v${VERSION}"
    SHA512 0 # calculated later
    HEAD_REF main
)

# 3. Configure build options based on features
set(ONNXRUNTIME_CMAKE_OPTIONS "")
if("static-cpu" IN_LIST FEATURES)
    list(APPEND ONNXRUNTIME_CMAKE_OPTIONS
        -Donnxruntime_USE_OPENMP=ON
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -Donnxruntime_BUILD_TESTS=OFF
        -Donnxruntime_USE_CUDA=OFF
        -Donnxruntime_USE_TENSORRT=OFF
        -Donnxruntime_USE_DNNL=OFF
        -Donnxruntime_USE_OPENVINO=OFF
        -Donnxruntime_BUILD_SHARED_LIB=OFF
        -Donnxruntime_BUILD_UNIT_TESTS=OFF
    )
else()
    message(FATAL_ERROR "This onnxruntime port currently only supports the 'static-cpu' feature.")
endif()

# 4. Build and install with CMake
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/cmake"
    OPTIONS ${ONNXRUNTIME_CMAKE_OPTIONS}
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME onnxruntime)

# 5. Final cleanup.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
