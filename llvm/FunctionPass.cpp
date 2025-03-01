#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

using namespace llvm;

namespace {
    struct FunctionNamePass : public ModulePass {
        static char ID;
        FunctionNamePass() : ModulePass(ID) {}

        bool runOnModule(Module &m) override {
            errs() << "Function Names in Module:\n";

            for (Function &f : m) {
                if (!f.isDeclaration()) { // Ignore external functions
                    errs() << " - " << f.getName() << "\n";
                }

                // Iterate the function body
                for (BasicBlock &bb : f) {
                    std::vector<Instruction*> toErase;

                    for (Instruction &i : bb) {
                        errs() << "\t Instruction" << i << '\n';
                        if (i.getOpcode() == Instruction::Add) {
                            IRBuilder<> builder(&i);

                            Value *lhs = i.getOperand(0);
                            Value *rhs = i.getOperand(1);

                            Instruction *sub = BinaryOperator::Create(Instruction::Sub, lhs, rhs);
                            builder.Insert(sub);

                            i.replaceAllUsesWith(sub);
                            toErase.push_back(&i);
                        }
                    }

                    for (Instruction* i : toErase) {
                        i->eraseFromParent();
                    }
                }
            }
            return false;
        }
    };
}

char FunctionNamePass::ID = 0;
static RegisterPass<FunctionNamePass> X("function-pass", "Print Function Names", false, false);
