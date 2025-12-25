local hop = require('hopcsharp.hop')

describe('hop_to', function()
    it('__hop_to calls providers that can handle hop', function()
        local called_can_handle = false
        local called_get_hops = false

        local provider = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle = true
                    return true
                end,

                get_hops = function()
                    called_get_hops = true
                    return {}
                end,
            }
        end

        hop.__hop_to({ provider('test', nil) }, {})

        assert(called_can_handle)
        assert(called_get_hops)
    end)

    it("__hop_to calls providers that can handle hop and won't call other providers", function()
        local called_can_handle1 = false
        local called_get_hops1 = false
        local called_can_handle2 = false
        local called_get_hops2 = false

        local provider1 = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle1 = true
                    return true
                end,

                get_hops = function()
                    called_get_hops1 = true
                    return { { row = 10, column = 10, path = 'dummy', name = 'dummy_name' } }
                end,
            }
        end

        local provider2 = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle2 = true
                    return false
                end,

                get_hops = function()
                    called_get_hops2 = true
                    return {}
                end,
            }
        end

        hop.__hop_to({
            provider1('test', nil),
            provider2('test', nil),
        }, {})

        assert(called_can_handle1)
        assert(called_get_hops1)

        assert(not called_can_handle2)
        assert(not called_get_hops2)
    end)

    it('__hop_to passes call to the next provider that can handle hop', function()
        local called_can_handle1 = false
        local called_get_hops1 = false
        local called_can_handle2 = false
        local called_get_hops2 = false

        local provider1 = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle1 = true
                    return true
                end,

                get_hops = function()
                    called_get_hops1 = true
                    return false
                end,
            }
        end

        local provider2 = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle2 = true
                    return true
                end,

                get_hops = function()
                    called_get_hops2 = true
                    return {}
                end,
            }
        end

        hop.__hop_to({
            provider1('test', nil),
            provider2('test', nil),
        }, {})

        assert(called_can_handle1)
        assert(called_get_hops1)

        assert(called_can_handle2)
        assert(called_get_hops2)
    end)

    it('__hop_to will not call user callback if there are not any hops', function()
        local called_can_handle = false
        local called_get_hops = false
        local called_callback = false

        local provider = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle = true
                    return true
                end,

                get_hops = function()
                    called_get_hops = true
                    return {}
                end,
            }
        end

        hop.__hop_to({ provider('test', nil) }, {
            callback = function()
                called_callback = true
            end,
        })

        assert(called_can_handle)
        assert(called_get_hops)
        assert(not called_callback)
    end)

    it('__hop_to will call user callback if there are hops', function()
        local called_can_handle = false
        local called_get_hops = false
        local called_callback = false

        local provider = function(current_word, node)
            return {
                can_handle = function()
                    called_can_handle = true
                    return true
                end,

                get_hops = function()
                    called_get_hops = true
                    return { { row = 10, column = 10, path = 'dummy', name = 'dummy_name' } }
                end,
            }
        end

        hop.__hop_to({ provider('test', nil) }, {
            callback = function()
                called_callback = true
            end,
        })

        assert(called_can_handle)
        assert(called_get_hops)
        assert(called_callback)
    end)
end)
