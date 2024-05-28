--[[
	Lua学习笔记
	2022-3-16
]]
--局部变量
local 变量1    --局部变量只在被声明的那个代码块内有效





--输出数据
a = 1
print("打印变量a",a)

--[[算数运算符
+ 加法
- 减法
* 乘法
/ 除法
% 取余，求出除法的余数_可以用于求奇数偶数
^ 乘幂，计算次方
- 负号，取负值
]]





--转义字符
--[[
\n 换行(LF),将当前位置移到下一行开头
\r 回车(CR),将当前位置移到本行开头
\| 反斜杠字符\
‘ 单引号
“ 双引号
\0 空字符(NULL)
\ddd 1到3位八进制数所代表的任意字符
\xhh 1到2位十六进制所代表的任意字符
]] --双引号间的一串字符
str1 = "\x32" --单引号间的一串字符
str2 = 'Lua' --[[和]]--间的一串字符
str3 = [[使用双括号时，甚至能包含换行数据
换行了
最后一行]]
str4 = "ab\\cd\"df\'g\\h]]" --打印转义字符
--输出所有字符串
print(str1)
print(str2)
print(str3)
print(str4)





--数据类型转换——数字与字符转换
--number转string
tostring(number)
--string转number
tonumber(string)






--逻辑运算
==   --等于
~=   --不等于
>    --大于
<    --小于
>=   --大于等于
<=   --小于等于

布尔型（boolean）只有两个可选值：true（真） 和 false（假）

and  --逻辑与
or   --逻辑或
not  --逻辑非

A and B  --逻辑与操作符。 若 A 为 false，则返回 A，否则返回 B
A or B   --逻辑或操作符。 若 A 为 true， 则返回 A，否则返回 B
not A    --逻辑非操作符。与逻辑运算结果相反，如果条件为 true，逻辑非为 false




--分支判断
if 条件 then
    符合条件的代码
end

if 条件1 then
    满足条件1
elseif 条件2 then
    不满足条件1，但是满足条件2
else
    前面条件全都不满足
end
--注意：else和elseif都是可选的，可有可无，但是end不能省略







--函数
function 函数名(参数1,参数2,...)
    代码内容
	return 参数a,参数b
end
--例子
function rectangle(a,b)
    return a*b,(a+b)*2
end
area,len = rectangle(1,2)
print(area,len)







--数组——table  万物基于table,所有的数据都在table中。包含：字符、数字、函数...
t = {
    --function(a,b) return a+b end,--函数
    "abc",223,",..a",123123,     --字符、数字
    [5]=65,                      --下标
    abc="HHH",                   --下标
    ["apple"] = 10,              --下标
     banana = {                  --数组
        price = 8.31,
        weight = 1.4, 
        year = '2018'
    },

}

--第一行才可以用这个
--print(t[1](3,2))

--屏蔽第一行才运行下面
print(t[1])
print(t.abc)
print(t.banana.weight)
print(table.concat(t))               --table.concat(t)每个元素连接起来变成字符串并返回
print(table.concat(t, "|"))          --table.concat(t,"|")每个元素   之间用 |   连接起来变成字符串并返回

table.insert(t, 1, 3)                --在表索引为1处插入3
table.insert(t, 10)                  --在表的最后插入10
print(table.concat(t, "|"))

print(table.remove(t, 1))            --删除速索引为1的元素
print(table.remove(t))               --删除最后一个元素
print(table.concat(t, "|"))











--循环
while 继续循环判断依据 do
    执行的代码
end
--例子
local result = 0
local num = 1
while num <= 100 do
    result = result + num
    num = num + 1
end
print(result)

for 临时变量名=开始值,结束值,步长 do
    循环的代码
end
--其中，步长可以省略，默认为1

--临时变量名可以直接在代码区域使用（但不可更改），每次循环会自动加步长值，并且在到达结束值后停止循环

--例子
local result = 0
for i=1,100 do
    result = result + i
end
print(result)

  --break跳出本次循环
--例子
result = 0
c = 1
while true do
    result = result + c
    c = c + 1
    if result > 100 then
        result = result - c
        break                        --break跳出本次循环
    end
end
print(result)















--string---字符串函数
string.sub(s, i , j)       --返回字符串 s 中，从索引 i 到索引 j 之间的子字符串
--例子					   	--提取字符串中的字符
s = "12345"
s1 = string.sub(s, 4, 7)
s2 = s:sub(4, 7)
--两种写法是等价关系
print(s1,s2)

string.rep(s, n)          --返回字符串 s 的 n 次拷贝
--示例代码：
print(string.rep("abc", 3))
--输出结果：
--abcabcabc

string.len(s)            --接收一个字符串，返回它的长度
--示例代码：
s = "hello lua"
print(string.len(s))
--输出结果：9
--同时也可以使用简便语法
print(s:len())

string.lower(s)         --接收一个字符串 s，返回一个把所有大写字母变成小写字母的字符串
string.upper(s)         --接收一个字符串 s，返回一个把所有小写字母变成大写字母的字符串
--示例代码：
s = "hello lua"
print(string.upper(s))
print(string.lower(s))
--输出结果：
--HELLO LUA
--hello lua
--同时也可以使用简便语法
print(s:upper())
print(s:lower())

string.format(formatstring, …)        --按照格式化参数formatstring，返回后面...内容的格式化版本
--[[formatstring用下面的表示
%d	十进制数
%x	十六进制数
%o	八进制数
%f	浮点数
%s	字符串
]]
--示例代码：
print(string.format("%.4f", 3.1415926))     -- 保留4位小数
print(string.format("%d %x %o", 31, 31, 31))-- 十进制数31转换成不同进制
d,m,y = 29,7,2015
print(string.format("%s %02d/%02d/%d", "today is:", d, m, y))
--控制输出2位数字，并在前面补0

-->输出
-- 3.1416
-- 31 1f 37
-- today is: 29/07/2015

string.char (…)		--返回这些整数所对应的 ASCII 码字符组成的字符串。当参数为空时，默认是一个 0。
--示例代码：
str1 = string.char(0x30,0x31,0x32,0x33)
str2 = string.char(0x01,0x02,0x30,0x03,0x44)
print(str1)
print(str2)
-->输出（不可见字符用�代替）
--0123
--��0�D

string.byte(s,i )		--返回字符s[i]所对应的 ASCII 码
--示例代码：
str = "12345"
print(string.byte(str,2))
print(str:byte(2))--也可以这样
print(str:byte())--不填默认是1
-->输出（十进制数据）
--50
--50
--49


--这个函数会在字符串s中，寻找匹配p字符串的数据。如果成功找到，那么会返回p字符串在s字符串中出现的开始位置和结束位置；如果没找到，那么就返回nil
string.find(s, p , init , plain)		--
--示例代码：
--只会匹配到第一个
print(string.find("abc abc", "ab"))
-- 从索引为2的位置开始匹配字符串：ab
print(string.find("abc abc", "ab", 2))
-- 从索引为5的位置开始匹配字符串：ab
print(string.find("abc abc", "ab", -3))
-->输出
--1  2
--5  6
--5  6


string.gsub(s, p, r , n)  		--将目标字符串s中所有的子串p替换成字符串r,可选参数n，表示限制替换次数
--返回值有两个，第一个是被替换后的字符串，第二个是替换了多少次
--示例代码：
print(string.gsub("Lua Lua Lua", "Lua", "hello"))
print(string.gsub("Lua Lua Lua", "Lua", "hello", 2)) --指明第四个参数
-->打印的结果：
-- hello hello hello   3
-- hello hello Lua     2












--LuaTask框架		--利用协程，在Lua中实现了多任务功能

--多任务

sys = require("sys")
--第一个任务
sys.taskInit(function()
    while true do
        log.info("task1","wow")
        sys.wait(1000) --延时1秒，这段时间里可以运行其他代码
    end
end)

--第二个任务
sys.taskInit(function()
    while true do
        log.info("task2","wow")
        sys.wait(500) --延时0.5秒，这段时间里可以运行其他代码
    end
end)

sys.run()



--多任务之间互相等待

sys = require("sys")
--第一个任务
sys.taskInit(function()
    while true do
        log.info("task1","wow")
        sys.wait(1000) --延时1秒，这段时间里可以运行其他代码
        sys.publish("TASK1_DONE")--发布这个消息，此时所有在等的都会收到这条消息
    end
end)

--第二个任务
sys.taskInit(function()
    while true do
        sys.waitUntil("TASK1_DONE")--等待这个消息，这个任务阻塞在这里了
        log.info("task2","wow")
    end
end)

--第三个任务
sys.taskInit(function()
    while true do
        local result = sys.waitUntil("TASK1_DONE",500)--等待超时时间500ms，超过就返回false而且不等了
        log.info("task3","wait result",result)
    end
end)

--单独订阅，可以当回调来用
sys.subscribe("TASK1_DONE",function()
    log.info("subscribe","wow")
end)

sys.run()





--多任务之间互相等待并传递数据
sys = require("sys")
--第一个任务
sys.taskInit(function()
    while true do
        log.info("task1","wow")
        sys.wait(1000) --延时1秒，这段时间里可以运行其他代码
        sys.publish("TASK1_DONE","balabala")--发布这个消息，并且带上一个数据
    end
end)

--第二个任务
sys.taskInit(function()
    while true do
        local _,data = sys.waitUntil("TASK1_DONE")--等待这个消息，这个任务阻塞在这里了
        log.info("task2","wow receive",data)
    end
end)

--第三个任务
sys.taskInit(function()
    while true do
        local result,data = sys.waitUntil("TASK1_DONE",500)--等待超时时间500ms，超过就返回false而且不等了
        log.info("task3","wait result",result,data)
    end
end)

--单独订阅，可以当回调来用
sys.subscribe("TASK1_DONE",function(data)
    log.info("subscribe","wow receive",data)
end)

sys.run()


--传统定时器
sys = require("sys")

--一秒后执行某函数，可以在后面传递参数
sys.timerStart(function()					--sys.timerStart开启一个一次性定时器
    log.info("定时器结束后，执行1次该语句")
end,1000)

--每秒执行，永久循环，返回定时器编号
local loopId = sys.timerLoopStart(function()   --sys.timerLoopStart开启一个循环定时器
    log.info("loop定时器结束后，永久循环该语句")
end,1000)

--10秒后手动停止上面的无限循环定时器
sys.timerStart(function()				--sys.timerStart开启一个一次性定时器
    sys.timerStop(loopId)				--sys.timerStop关闭定时器loopId
    log.info("将loopId定时器停止")
end,10000)

sys.run()




vscode注释代码的快捷键
使用Alt + Shift + A

-- sys库是Luat的核心支撑库, 基本上是必备的
local sys = require"sys"



