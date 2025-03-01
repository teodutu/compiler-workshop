#include <stdio.h>

// This function uses the select LLVM instruction because it only has to merge 2 branches.
int use_selct_instruction(int x, int y)
{
    if (x < 2)
        return (x + y) * 3;
    else if (x )
        return (x - y) * 2;
}

// This function uses the phi LLVM instruction to merge the 3 branches.
int use_phi_instruction(int x) {
    int y;
    
    if (x > 2)
        y = x * 2 + 3;
    else if (x < -2)
        y = x - 9;
    else
        y = x * 3;

    return y;
}

int main()
{
    printf("%d\n", use_selct_instruction(2, 3));
    printf("%d\n", use_phi_instruction(69));

    return 0;
}
