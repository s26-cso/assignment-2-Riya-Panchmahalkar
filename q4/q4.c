#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[16];
    int a,b;
    void *handle = NULL;
    int (*operation_func)(int,int);
    while (scanf("%15s %d %d",op,&a,&b) == 3) {
      
        char lib_name[32];
        snprintf(lib_name,sizeof(lib_name),"./lib%s.so",op);

        if (handle != NULL) {
            dlclose(handle);
            handle = NULL;
        }
        handle = dlopen(lib_name,RTLD_NOW);
        if (!handle) continue;

        dlerror();
        operation_func = (int (*)(int, int))dlsym(handle,op);

        if (operation_func) printf("%d\n",operation_func(a,b));
    }
    if (handle) dlclose(handle);
    return 0;
}