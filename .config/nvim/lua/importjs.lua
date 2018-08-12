local function import(search, lines)
    print(search)
    print(lines.insert)
    return 'hello world'
end

return {
    import = import
}
