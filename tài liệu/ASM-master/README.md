# Ассемблер 4 семестр BMSTU(Bauman Moscow), IU7, 2018
---
### Автоперенос из GitLab(кафедры), если есть какие-то проблемы или недочеты- отпишите
---

<H3>Ссылка на видеокурс по ассемблеру(Евтихыч) от студента 2015 года: </H3>https://www.youtube.com/channel/UCrCco84KnzhtLEDE2LjMq7g/playlists

<h2>Лабораторные работы:</h2>

| Number | Issued | Status | On GitHub | Exercise |
|---------|---|------|----------|---|
| :one: | :white_check_mark: | :white_check_mark: | :white_check_mark: | <h3>Изучение отладчика AFD.</h3><h4>1.HАБРАТЬ ПРОГРАММУ</h4><h6>Примечание: Программа выводит на дисплей сообщение и ожидает  нажатия клавиши, код символа помещается в регистр AL</h6><h4>2.ТРАНСЛИРОВАТЬ ПРОГРАММУ</h4><h4>3.СОЗДАТЬ ИСПОЛНЯЕМЫЙ ФАЙЛ</h4><h4>4.ВЫПОЛНИТЬ ПРОГРАММУ ПОД УПРАВЛЕНИЕМ ОТЛАДЧИКА AFD</h4>|
| :two: | :white_check_mark: | :white_check_mark: | :white_check_mark: | <h3>ЗАДАНИЕ 1</h3><h4>отладка в CV (CodeView)</h4><h5>шаг 1- Подготовить приведенную ниже программу к отладке:</h5><h6>а) скопировать текст программы в файл KR_1.ASM;</h6><h6>б) выполнить трансляцию: MASM /Zi KR_1.ASM,,;</h6><h6>в) выполнить компоновку: LINK /CO KR_1.OBJ;</h6>|
| :three: | :white_check_mark: | :white_check_mark: | :white_check_mark: | <h4>ШАГ 1</h4>- Подготовить приведенную ниже программу к отладке в CV и выполнить работы, описанные в тексте программы. <h4>ШАГ 2</h4>- Проследить за выполнением команд от M1 до M6 и  изменением переменных   и регистров.  Сформулировать условие задачи, решаемой программой. Назначение некоторых команд: <h6>TEST A,B     ~    A&B и установка флагов по результату</h6><h6>LOOP M       ~    CX:=CX-1 и переход на М, если CX<>0.</h6><h4>ШАГ 3</h4>- Составить файл ЛР02-2.INP с командами CV так,  чтобы  его выполнение привело к созданию файла ЛР02-2.OUT, содержащего весь вывод в окно диалога.  Этот вывод должен содержать  на  метках M1 ... M6 следующую информацию: <h6>а) значения регистров, флагов и текущую команду программы,</h6><h6>б) значения переменной K.</h6>
| :four: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :five: | :white_check_mark: | :white_check_mark: |:white_check_mark: | |
| :six: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :seven: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :eight: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :nine: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :one::zero: | :white_check_mark: | :white_check_mark:| :white_check_mark: | |
| :one::one: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| :one::two: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |

<h2>Вопросы к экзамену:</h2>

1. Архитектура МП 8088 и 80386

2. Характеристики регистров.

3. Флаги.

4. Сегментные регистры по умолчанию.

5. Образование физического адреса.

6. Сегментный префикс.

7. Структура программы одномодульной MS DOS. Повторные описания сегментов.

8. Возможные структуры кодового сегмента.

9. Возможные способы начала выполнения и завершения программы MS DOS типа .exe.

10. Структура программы из нескольких исходных модулей MS DOS.

11. Переменные, метки, символические имена и их атрибуты.

12. Виды предложений языка Ассемблер.

13. Директивы (псевдооператоры): назначение и формы записи.

14. Стандартные директивы описания сегментов: формат записи заголовков директив и назначение параметров.

15. Возможные комбинации сегментов и умолчания.

16. Директива ASSUME.

17. Структура процедур.

18. Директива END.

19. Внешние имена.

20. Типы данных и задание начальных значений.

21. Способы описания меток, типы меток.

22. Команды условных переходов при работе с ЦБЗ и  ЦСЗ.

22. Команды организации циклов.

23. Директива ORG.

24. Способы адресаци.

25. Организация рекурсивных подпрограмм.

26. Арифметические команды (для ЦБЗ и ЦСЗ)

27. Связывание подпрограмм.

28. Команда CALL.  Использование прямой и косвенной адресации.

29. Способы передачи параметров подпрограмм.

30. Способы сохранения и восстановления состояния вызывающей программы (кто выполняет и в чьей памяти)

31. Соглашения о связях в Turbo Рascal, Turbo C, Delphi, VS C++

32. Команды сдвига.

33. Команды логических операций.

34. Команды обработки строк и префиксы повторения.

35. Команды пересылки строк.

36. Команды сравнения строк.

37. Команды сканирования строк.

38. Команды загрузки строк.

39. Команды сохранения строк.

40. Листинг программы.

41. Макросредства.

42. Описания макроопределений (макрофункций и макропроцедур) и макрокоманд.

43. Директива INCLUDE.

44. Рекурсия в макроопределениях.

45. Параметры в макросах.

46. Директива LOCAL.

47. Директивы условного ассемблирования IF, IFE, IF2, IFIDN/IFIDNI, IFDIF/IFDIFI, IFDEF, IFNDEF и связанные с ними конструкции.

48. Директивы  IFB и IFNB  в макроопределениях.

49. Директивы  IFIDN и IFDIF  в макроопределениях.

50. Операции ;;    %    &    < >    !  в макроопределениях.

51. Блок повторения REРT.

52. Блок повторения IRР/FOR.

53. Блок повторения IRРC/FORC.

54. Блок повторения WHILE.

55. Директива EQU в MASM.

56. Директива TEXTEQU в MASM32.

57. Директива = в MASM.

58. Типы макроданных text и number (см листинг)

59. Именованные макроконстанты MASM32 

60. Макроимена, числовые и текстовые макроконстанты  -  значения.

61. Директивы echo и %echo

62. Способы вывода значений макропеременных и макроконстант с пояснениями

63. Операций в выражениях MASM:
* Арифметические операции.
* Логические операции.
* Операции отношений.
* Операции, возвращающие значения.
* Операции присваивания атрибута.

64. Подготовка ассемблерных объектных модулей средствами командной строки для использования в Delphi и VS C++.

65. Добавление ассемблерных модулей в проект консольного приложения VS C++

66. Добавление ассемблерных модулей в проект консольного приложения Delphi

67. Использование ассемблерных вставок в модулях .cpp.

68. Вызов из ассемблерной подпрограммы C в VS C++.

69. Передача глобальных данных, определённых в консольной прогрпмме VS C++, в ассемблерный модыль.

70. Передача глобальных данных, определённых в ассемблерном модуле в консольнй модуль .cpp VS C++.

71. Средства отладки в CodeView. Примеры.

72. Средства отладки в VS C++. Примеры.

73. Получение дизассемблированного кода в VS C++
