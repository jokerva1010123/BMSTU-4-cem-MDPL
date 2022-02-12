//главная часть программы

extern "C" void __stdcall main_asm (void);	//экстерним функцию со всем ассемблерским содержанием

int main (void)
{
	main_asm();
	return 0;
}