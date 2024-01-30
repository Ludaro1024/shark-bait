function Locale(msg)
    return Translation[Config.Locale][msg] or msg .. ' not found'
end
