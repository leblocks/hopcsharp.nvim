local BufferedWriter = {}
BufferedWriter.__index = BufferedWriter

---@class BufferedWriter
---TODO finish

---@param db sqlite_db db object
---@param buffer_size number size of the buffer
function BufferedWriter:new(db, buffer_size)
    local obj = {
        db = db,
        buffer = {},
        current_size = 0,
        buffer_size = buffer_size or 100,
    }

    setmetatable(obj, self)

    return obj
end

-- Method to write buffered data to the database
function BufferedWriter:write_buffer_to_db()
    for table_name, entries in pairs(self.buffer) do
        self.db:insert(table_name, entries)
    end

    self.buffer = {}
    self.current_size = 0
end

-- Method to add data to the buffer
function BufferedWriter:add_to_buffer(table_name, data)
    -- group buffer entries by table name
    self.buffer[table_name] = self.buffer[table_name] or {}
    self.current_size = self.current_size + 1
    table.insert(self.buffer[table_name], data)

    if self.current_size >= self.buffer_size then
        self:write_buffer_to_db()
    end
end

-- Ensure any remaining data in the buffer is written to the database
function BufferedWriter:flush()
    if self.current_size > 0 then
        self:write_buffer_to_db()
    end
end

return BufferedWriter
