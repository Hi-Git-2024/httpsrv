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
	local ssid ="BSCC"
    local passwords ="Bscc123456789."
    --local ssid ="Gn"
	--local passwords ="123456789."
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
            return 200, {}, "1ok"
        elseif uri == "/ledA/0" then
            LEDA(0)
            return 200, {}, "2ok"
        end
        if uri == "/ledB/1" then
            LEDB(1)
            return 200, {}, "3ok"
        elseif uri == "/ledB/0" then
            LEDB(0)
            return 200, {}, "4ok"
        end
        if uri == "/ledB/2" then
            LEDB(1)
            LEDA(1)
            return 200, {}, "5ok"
        elseif uri == "/ledB/3" then
            LEDB(0)
            LEDA(0)
            return 300, {}, "6ok"
        end
        return 404, {}, "7Not Found" .. uri
    end)
    log.info("web", "pls open url http://" .. _G.wlan_ip .. "/")
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
