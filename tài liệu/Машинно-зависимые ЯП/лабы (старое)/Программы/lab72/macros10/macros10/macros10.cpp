//������� ����� ���������

extern "C" void __stdcall main_asm (void);	//��������� ������� �� ���� ������������� �����������

int main (void)
{
	main_asm();
	return 0;
}