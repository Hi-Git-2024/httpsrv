
-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "sfuddemo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

sys = require("sys")

--添加硬狗防止程序卡死
if wdt then
    wdt.init(90000)--初始化watchdog设置为9s
    sys.timerLoopStart(wdt.feed, 30000)--3s喂一次狗
end

-- spi_id,pin_cs
local function sfud_spi_pin()
    local rtos_bsp = rtos.bsp()
    if rtos_bsp == "AIR101" then
        return 0,pin.PB04
    elseif rtos_bsp == "AIR103" then
        return 0,pin.PB04
    elseif rtos_bsp == "AIR105" then
        return 5,pin.PC14
    elseif rtos_bsp == "ESP32C3" then
        return 2,7
    elseif rtos_bsp == "ESP32S3" then
        return 2,14
    elseif rtos_bsp == "EC618" then
        return 0,8
    elseif rtos_bsp == "EC718P" then
        return 0,8
    else
        log.info("main", "bsp not support")
        return
    end
end

sys.taskInit(function()
    -- log.info("等5秒")
    sys.wait(1000)
    local spi_id,pin_cs = sfud_spi_pin() 
    if not spi_id then
        while 1 do
            sys.wait(1000)
            log.info("main", "bsp not support yet")
        end
    end

    log.info("sfud", "SPI", spi_id, "CS PIN", pin_cs)
    spi_flash = spi.deviceSetup(spi_id,pin_cs,0,0,8,20*1000*1000,spi.MSB,1,0)
    log.info("sfud", "spi_flash", spi_flash)
    local ret = sfud.init(spi_flash)
    if ret then
        log.info("sfud.init ok")
    else
        log.info("sfud.init Error")
        return
    end
    log.info("sfud.getDeviceNum",sfud.getDeviceNum())
    local sfud_device = sfud.getDeviceTable()

    if sfud.getInfo then
        log.info("sfud.getInfo", sfud.getInfo(sfud_device))
    end

    local test_sfud_raw = false
    local test_sfud_mount = true

    if test_sfud_raw then
        log.info("sfud.eraseWrite",sfud.eraseWrite(sfud_device,1024,"luatos-sfud1234567890123456789012345678901234567890"))
        log.info("sfud.read",sfud.read(sfud_device,1024,4))
    end
    
    if test_sfud_mount then
        local ret = sfud.mount(sfud_device,"/sfud")
        log.info("sfud.mount", ret)
        if ret then
            log.info("sfud", "挂载成功")
            log.info("fsstat", fs.fsstat("/sfud"))--获取文件系统信息

            
            -- 挂载成功后，可以像操作文件一样操作
            local f = io.open("/sfud/test", "w")
            f:write(0123456789)
            f:close()

            log.info("sfud", io.readFile("/sfud/test"))

            -- 文件追加
            os.remove("/sfud/test2")
            io.writeFile("/sfud/test2", "LuatOS")
            local f = io.open("/sfud/test2", "a+")
            f:write(" - " .. string.char(0x30))
            f:close()--关闭之前打开的文件，否则无法追加内容

            log.info("sfud", io.readFile("/sfud/test2"))

            -- 文件追加
            os.remove("/sfud/test3")
            --io.writeFile("/sfud/test3", "Hello")
            local f = io.open("/sfud/test3", "a+")
            --[[ 经过测试，写入10万个字节，需要10秒左右 ]]
            for i=1,100000 do
                f:write(string.char(0x31))
            end
            f:close()
            

            --log.info("test3文件追加测试", io.readFile("/sfud/test3"))--最大读取10000字节，超过无法打印
            log.info("fsstat", fs.fsstat("/sfud"))--获取文件系统信息
            log.info("fsize", fs.fsize("/sfud/test3"))-- 打印文件的大小



        else
            log.info("sfud", "挂载失败")
        end


    end
end)


-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
