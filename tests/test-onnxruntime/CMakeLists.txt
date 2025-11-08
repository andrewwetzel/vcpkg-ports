cmake_minimum_required(VERSION 3.18)
project(onnxruntime-test CXX)

find_package(onnxruntime CONFIG REQUIRED)

add_executable(test_runner main.cpp)

target_link_libraries(test_runner PRIVATE onnxruntime::onnxruntime)