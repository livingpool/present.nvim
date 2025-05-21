---@diagnostic disable: undefined-field

local parse = require("present")._parse_slides

local eq = assert.are.same

describe("present.parse_slides", function()
  it("should parse an emtpy file", function()
    eq({
      slides = {
        {
          title = "",
          body = {},
          blocks = {},
        },
      },
    }, parse({}))
  end)

  it("should parse a file with one slide", function()
    eq(
      {
        slides = {
          {
            title = "# This is the first slide",
            body = { "This is the body" },
            blocks = {},
          },
        },
      },
      parse({
        "# This is the first slide",
        "This is the body",
      })
    )
  end)

  it("should parse a file with one slide with one block", function()
    local results = parse({
      "# This is the first slide",
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    })

    eq(1, #results.slides)

    local slide = results.slides[1]
    eq("# This is the first slide", slide.title)
    eq({ "This is the body", "```lua", "print('hi')", "```" }, slide.body)

    eq({
      language = "lua",
      body = "print('hi')",
    }, slide.blocks[1])
  end)
end)
