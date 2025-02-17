-- init.lua: Initialization hooks for yazi

function Status:render(area)
  self.area = area

  local line = ui.Line({ self:percentage(), self:position() })
  return {
    ui.Paragraph(area, { line }):align(ui.Paragraph.CENTER),
  }
end

-- init.lua ends here
