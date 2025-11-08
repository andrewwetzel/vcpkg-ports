#include <onnxruntime_cxx_api.h>
#include <iostream>

int main() {
    std::cout << "Attempting to create Ort::Env..." << std::endl;
    Ort::Env env(ORT_LOGGING_LEVEL_WARNING, "test");
    std::cout << "Ort::Env created successfully!" << std::endl;
    return 0;
}