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
        trig = "abstract",
        namr = "markdown_abstract_callout",
        dscr = "Create markdown abstract callout",
    }, {
        text { "> [!ABSTRACT]", "> " },
        insert(0),
    }),
   snip({
        trig = "summary",
        namr = "markdown_summary_callout",
        dscr = "Create markdown summary callout",
    }, {
        text { "> [!SUMMARY]", "> " },
        insert(0),
    }),

    snip({
        trig = "tldr",
        namr = "markdown_tldr_callout",
        dscr = "Create markdown tldr callout",
    }, {
        text { "> [!TLDR]", "> " },
        insert(0),
    }),

    snip({
        trig = "info",
        namr = "markdown_info_callout",
        dscr = "Create markdown info callout",
    }, {
        text { "> [!INFO]", "> " },
        insert(0),
    }),

    snip({
        trig = "todo",
        namr = "markdown_todo_callout",
        dscr = "Create markdown todo callout",
    }, {
        text { "> [!TODO]", "> " },
        insert(0),
    }),

    snip({
        trig = "hint",
        namr = "markdown_hint_callout",
        dscr = "Create markdown hint callout",
    }, {
        text { "> [!HINT]", "> " },
        insert(0),
    }),

    snip({
        trig = "success",
        namr = "markdown_success_callout",
        dscr = "Create markdown success callout",
    }, {
        text { "> [!SUCCESS]", "> " },
        insert(0),
    }),

    snip({
        trig = "check",
        namr = "markdown_check_callout",
        dscr = "Create markdown check callout",
    }, {
        text { "> [!CHECK]", "> " },
        insert(0),
    }),

    snip({
        trig = "done",
        namr = "markdown_done_callout",
        dscr = "Create markdown done callout",
    }, {
        text { "> [!DONE]", "> " },
        insert(0),
    }),

    snip({
        trig = "question",
        namr = "markdown_question_callout",
        dscr = "Create markdown question callout",
    }, {
        text { "> [!QUESTION]", "> " },
        insert(0),
    }),

    snip({
        trig = "help",
        namr = "markdown_help_callout",
        dscr = "Create markdown help callout",
    }, {
        text { "> [!HELP]", "> " },
        insert(0),
    }),

    snip({
        trig = "faq",
        namr = "markdown_faq_callout",
        dscr = "Create markdown faq callout",
    }, {
        text { "> [!FAQ]", "> " },
        insert(0),
    }),

    snip({
        trig = "attention",
        namr = "markdown_attention_callout",
        dscr = "Create markdown attention callout",
    }, {
        text { "> [!ATTENTION]", "> " },
        insert(0),
    }),

    snip({
        trig = "failure",
        namr = "markdown_failure_callout",
        dscr = "Create markdown failure callout",
    }, {
        text { "> [!FAILURE]", "> " },
        insert(0),
    }),

    snip({
        trig = "fail",
        namr = "markdown_fail_callout",
        dscr = "Create markdown fail callout",
    }, {
        text { "> [!FAIL]", "> " },
        insert(0),
    }),

    snip({
        trig = "missing",
        namr = "markdown_missing_callout",
        dscr = "Create markdown missing callout",
    }, {
        text { "> [!MISSING]", "> " },
        insert(0),
    }),

    snip({
        trig = "danger",
        namr = "markdown_danger_callout",
        dscr = "Create markdown danger callout",
    }, {
        text { "> [!DANGER]", "> " },
        insert(0),
    }),

    snip({
        trig = "error",
        namr = "markdown_error_callout",
        dscr = "Create markdown error callout",
    }, {
        text { "> [!ERROR]", "> " },
        insert(0),
    }),

    snip({
        trig = "bug",
        namr = "markdown_bug_callout",
        dscr = "Create markdown bug callout",
    }, {
        text { "> [!BUG]", "> " },
        insert(0),
    }),

    snip({
        trig = "example",
        namr = "markdown_example_callout",
        dscr = "Create markdown example callout",
    }, {
        text { "> [!EXAMPLE]", "> " },
        insert(0),
    }),

    snip({
        trig = "quote",
        namr = "markdown_quote_callout",
        dscr = "Create markdown quote callout",
    }, {
        text { "> [!QUOTE]", "> " },
        insert(0),
    }),

    snip({
        trig = "cite",
        namr = "markdown_cite_callout",
        dscr = "Create markdown cite callout",
    }, {
        text { "> [!CITE]", "> " },
        insert(0),
    }),
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
