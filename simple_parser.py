prt_list = list()
all_list = list()
while (text := input()) != "</html>":
    all_list.append(text)

flag = False
some_str = ""
for text in all_list:
    if "<p>" in text:
        flag = True
    if "</p>" in text:
        some_str += text
        prt_list.append(some_str[3:-4])
        some_str = ""
        flag = False
    if flag:
        some_str += text + " "
    

for text in prt_list[::-1]:
    print(text)
