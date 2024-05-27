-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "wifidemo"
VERSION = "1.0.0"

-- 引入必要的库文件(lua编写), 内部库不需要require
sys = require("sys")
require("sysplus")


-- function meminfo()
--     log.info("lua", rtos.meminfo())
--     log.info("sys", rtos.meminfo("sys"))
-- end

-- 初始化LED灯, 开发板上左右2个led分别是gpio12/gpio13
local LEDA= gpio.setup(12, 0, gpio.PULLUP)
local LEDB= gpio.setup(13, 0, gpio.PULLUP)

sys.taskInit(function()
    sys.wait(1000)
    wlan.init()
	local ssid ="Gn"
	local passwords ="123456789."
    -- 修改成自己的ssid和passwords
    wlan.connect(ssid, passwords)--作为STATION时,连接到指定AP[789E2.4]
    -- wlan.connect("uiot", "")
    log.info("wlan", "wait for IP_READY")

    while not wlan.ready() do
        local ret, ip = sys.waitUntil("IP_READY", 30000)
        -- wlan连上之后, 这里会打印ip地址
        log.info("ip", ret, ip)
        if ip then
            _G.wlan_ip = ip
        end
    end
    log.info("wlan", "ready !!", wlan.getMac())
    sys.wait(1000)
    httpsrv.start(80, function(fd, method, uri, headers, body)
        log.info("httpsrv", method, uri, json.encode(headers), body)
        -- meminfo()
        print("服务器接收测试","fd=",fd)
        print("服务器接收测试","method=",method)
        print("服务器接收测试","uri=",uri)
        print("服务器接收测试","json.encode(headers)=",json.encode(headers))
        print("服务器接收测试","headers=",headers)
        print("服务器接收测试","body=",body)

        if uri == "/ledA/1" then
            LEDA(1)
            return 200, {}, "ok"
        elseif uri == "/ledA/0" then
            LEDA(0)
            return 200, {}, "ok"
        end
        if uri == "/ledB/1" then
            LEDB(1)
            return 200, {}, "ok"
        elseif uri == "/ledB/0" then
            LEDB(0)
            return 200, {}, "ok"
        end
        if uri == "/ledB/2" then
            LEDB(1)
            LEDA(1)
            return 200, {}, "ok"
        elseif uri == "/ledB/3" then
            LEDB(0)
            LEDA(0)
            return 200, {}, "ok"
        end
        if uri == "/write.php" then
            LEDB(1)
            LEDA(1)
            return 200, {}, "ok"
        end
        return 404, {}, "7Not Found" .. uri
    end)
    log.info("web", "pls open url http://" .. _G.wlan_ip .. "/")
end)


--添加硬狗防止程序卡死
if wdt then
    wdt.init(9000)--初始化watchdog设置为9s
    sys.timerLoopStart(wdt.feed, 3000)--3s喂一次狗
end

local function fs_test()

    -- 根目录/是可写
    local f = io.open("/boot_time", "rb")
    local c = 0
    if f then
        local data = f:read("*a")
        log.info("fs", "data", data, data:toHex())
        c = tonumber(data)
        f:close()
    end
    log.info("fs", "boot count", c)
    c = c + 1
    f = io.open("/boot_time", "wb")
    --if f ~= nil then
    log.info("fs", "write c to file", c, tostring(c))
    f:write(tostring(c))
    f:close()
    --end

    log.info("io.writeFile", io.writeFile("/demo_test.txt", "ABCDEFG"))

    log.info("io.readFile", io.readFile("/demo_test.txt"))
    local f = io.open("/demo_test.txt", "rb")
    local c = 0
    if f then
        local data = f:read("*a")
        log.info("fs", "data2", data, data:toHex())
        f:close()
    end

    -- seek和tell测试
    local f = io.open("/demo_test.txt", "rb")
    local c = 0
    if f then
        f:seek("end", 0)
        f:seek("set", 0)
        local data = f:read("*a")
        log.info("fs", "data3", data, data:toHex())
        f:close()
    end
    

    if fs then
        -- 根目录是可读写的
        log.info("fsstat", fs.fsstat("/"))
        -- /luadb/ 是只读的
        log.info("fsstat", fs.fsstat("/luadb/"))
    end

    local ret, files = io.lsdir("/")
    log.info("fatfs", "lsdir", json.encode(files))


    -- 读取刷机时加入的文件, 并演示按行读取
    -- 刷机时选取的非lua文件, 均存放在/luadb/目录下, 单层无子文件夹
    local f = io.open("/luadb/demo_test.txt", "rb")
    if f then
        while true do
            local line = f:read("l")
            if not line or #line == 0 then
                break
            end
            log.info("fs", "read line", line)
        end
        f:close()
        log.info("fs", "close f")
    else
        log.info("fs", "pls add demo_test.txt!!")
    end

    -- 文件夹操作
    sys.wait(3000)
    io.mkdir("/iot/")
    f = io.open("/iot/1.txt", "w+")
    if f then
        f:write("hi, LuatOS " .. os.date())
        f:close()
    else
        log.info("fs", "open file for write failed")
    end
    f = io.open("/iot/1.txt", "r")
    if f then
        local data = f:read("*a")
        f:close()
        log.info("fs", "writed data", data)
    else
        log.info("fs", "open file for read failed")
    end
    
end




sys.taskInit(function()
    -- 为了显示日志,这里特意延迟一秒
    -- 正常使用不需要delay
    sys.wait(1000)
    fs_test()
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
