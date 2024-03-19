-- add_filename.lua

function Header(elem)
    if elem.level == 1 and elem.identifier == "filename" then
        -- Extract the filename from the input metadata
        local filename = pandoc.utils.stringify(elem.content)
        -- Create a header with the filename
        return pandoc.Header(1, filename)
    end
end