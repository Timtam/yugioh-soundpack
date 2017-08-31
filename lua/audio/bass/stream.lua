local channel = require("audio.bass.channel")
local class = require("pl.class")

class.Stream(channel)

function Stream:Free()

  self.bass.BASS_StreamFree(self.id)

  return self.bass.BASS_ErrorGetCode()

end

return Stream