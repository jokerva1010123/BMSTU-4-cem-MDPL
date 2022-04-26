char src[] = "String, to copy from...";
    char dest[MAX_BUFFER_LEN] = "Here is just cringe...";
    strcopy(dest, src, strlen(src));
    cout << "Test1 (simple test, copy from source to destination different memory addresses at all):\n";
    cout << "Src: " << src << "\nDest: " << dest << endl;

    char special_check[] = "abcdefghijklmnopqrstuvwxyz";

    cout << "Test2: Destination = Source + 4, copysize: 8\n";
    cout << "Start: " << special_check << endl;
    strcopy(special_check + 4, special_check, 8);
    cout << "Mine:  " << special_check << endl;

    cout << "Test3: Source = Destination + 4, copysize: 8\n";
    cout << "Start: " << special_check << endl;
    strcopy(special_check, special_check + 4, 8);
    cout << "Mine:  " << special_check << endl;