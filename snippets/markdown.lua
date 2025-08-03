local ls = require("luasnip")
local snip = ls.s  -- Use ls.s directly
local text = ls.t  -- Use ls.t directly
local insert = ls.i  -- Use ls.i directly
local func = ls.function_node

local date = function()
    return { os.date "%Y-%m-%d" }
end

-- Return snippets directly for Lua loader
return {
    snip({
        trig = "metalua",
        namr = "Metadata", 
        dscr = "Yaml metadata format for markdown",
    }, {
        text { "---", "title: " },
        insert(1, "note_title"),
        text { "", "author: " },
        insert(2, "author"),
        text { "", "date: " },
        func(date, {}),
        text { "", "categories: [" },
        insert(3, ""),
        text { "]", "lastmod: " },
        func(date, {}),
        text { "", "tags: [" },
        insert(4),
        text { "]", "comments: true", "---", "" },
        insert(0),
    }),
    snip({
        trig = "summary",
        namr = "markdown_summary_callout",
        dscr = "Create markdown summary callout",
    }, {
        text "> [!SUMMARY]",
        insert(0),
    }),
    snip({
        trig = "link",
        namr = "markdown_link",
        dscr = "Create markdown link [txt](url)",
    }, {
        text "[",
        insert(1),
        text "](",
        func(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        text ")",
        insert(0),
    }),
    snip({
        trig = "codeempty",
        namr = "markdown_code_empty",
        dscr = "Create empty markdown code block",
    }, {
        text "``` ",
        insert(1, "Language"),
        text { "", "" },
        insert(2, "Content"),
        text { "", "```", "" },
        insert(0),
    }),
}
