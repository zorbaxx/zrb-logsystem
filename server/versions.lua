local name = "[^3ZRB-LogSystem^7]"
CreateThread(function()
    function checkVersion(error, latestVersion, headers)
        local currentVersion = 1.0          
        
        if tonumber(currentVersion) < tonumber(latestVersion) then
            print(name .. " ^1is outdated.\nCurrent version: ^1" .. currentVersion .. "\n^1Newest version: ^2" .. latestVersion .. "\n^5Update available in^7: https://github.com/zorbaxx/zrb-logsystem")
        elseif tonumber(currentVersion) > tonumber(latestVersion) then
            print(name .. " has skipped the latest version ^2" .. latestVersion .. "Github is offline or the version couldn't be checked")
        else
            print("^5ZRB-LogSystem ^7|^2 UPDATED ^7|^5 Version: "..latestVersion.."^0")
        end
    end
    PerformHttpRequest("https://raw.githubusercontent.com/zorbaxx/versions/main/logsystem.txt", checkVersion, "GET")
end)