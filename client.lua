local cmdName = "loadModel"
local modelsFolder = "models"

local function readFile(path)
    if fileExists(path) then
        local file = fileOpen(path, true)

        if file then
            local size = fileGetSize(file)
            local rawData = fileRead(file, size)
            fileClose(file)

            if not rawData then
                outputChatBox(string.format("Не удалось прочесть файл %q", path))
            end

            return rawData
        end

        outputChatBox(string.format("Не удалось открыть файл %q", path))
    end

    outputChatBox(string.format("Файл %q не существует", path))
end

local function replaceAsset(name, assetType, modelId)
    local path = string.format("%s/%s.%s", modelsFolder, name, assetType)
    local rawData = readFile(path)

    if rawData then
        local asset = (assetType == "txd") and engineLoadTXD(rawData) or engineLoadDFF(rawData)
        return (assetType == "txd") and engineImportTXD(asset, modelId) or engineReplaceModel(asset, modelId)
    end

    return false
end

local function loadModelCommand(cmd, modelName, modelId)
    if (type(modelName) == "string") and tonumber(modelId) then
        modelId = math.floor(modelId)

        local txd = replaceAsset(modelName, "txd", modelId)
        local dff = replaceAsset(modelName, "dff", modelId)

        if txd and dff then
            outputChatBox(string.format("Модель %q загружена на ID %i", modelName, modelId))
            return true
        else
            outputChatBox(string.format("Проблема загрузки модели %q. txd: %s dff: %s", modelName, tostring(txd), tostring(dff)))
            return false
        end
    end

    outputChatBox(string.format("Syntax: /%s [name] [ID]", cmdName))
end
addCommandHandler(cmdName, loadModelCommand, false, false)