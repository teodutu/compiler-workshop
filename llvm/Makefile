BUILD_DIR=build/

build-pass:	CMakeLists.txt FunctionPass.cpp
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake ..
	cd $(BUILD_DIR) && make

$(BUILD_DIR)/libFunctionPass.so: build-pass

sample_edited.ll: run-pass

run-pass: $(BUILD_DIR)/libFunctionPass.so generate-llvmir
	opt -load $< sample.ll -S -o sample_edited.ll

generate-llvmir: sample.c
	clang -c -S -emit-llvm $<

link-llvm: sample_edited.ll
	llc $<
	clang sample_edited.s -o sample_edited

interpret: sample_edited.ll
	lli $<

run: link-llvm
	./sample_edited

clean:
	rm -rf *.ll *.s *.o sample_edited*

clean-pass:
	rm -rf build/
