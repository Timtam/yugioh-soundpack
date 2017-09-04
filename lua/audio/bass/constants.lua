-- Error codes returned by BASS_ErrorGetCode
local error = {
  ok = 0, -- all is OK
  memory = 1, -- memory error
  file_open = 2, -- can't open the file
  driver = 3, -- can't find a free/valid driver
  buffer_lost = 4, -- the sample buffer was lost
  handle = 5, -- invalid handle
  format = 6, -- unsupported sample format
  position = 7, -- invalid position
  init = 8, -- BASS_Init has not been successfully called
  start = 9, -- BASS_Start has not been successfully called
  ssl = 10, -- SSL/HTTPS support isn't available
  already = 14, -- already initialized/paused/whatever
  no_channel = 18, -- can't get a free channel
  illegal_type = 19, -- an illegal type was specified
  illegal_parameter = 20, -- an illegal parameter was specified
  no_3d = 21, -- no 3D support
  no_eax = 22, -- no EAX support
  device = 23, -- illegal device number
  not_playing = 24, -- not playing
  frequency = 25, -- illegal sample rate
  no_file = 27, -- the stream is not a file stream
  no_hardware_voices = 29, -- no hardware voices available
  empty = 31, -- the MOD music has no sequence data
  no_internet = 32, -- no internet connection could be opened
  create = 33, -- couldn't create the file
  no_fx = 34, -- effects are not available
  not_available = 37, -- requested data is not available
  decode = 38, -- the channel is/isn't a "decoding channel"
  directx = 39, -- a sufficient DirectX version is not installed
  timeout = 40, -- connection timedout
  file_format = 41, -- unsupported file format
  speaker = 42, -- unavailable speaker
  version = 43, -- invalid BASS version (used by add-ons)
  codec = 44, -- codec is not available/supported
  ended = 45, -- the channel/file has ended
  busy = 46, -- the device is busy
  unknown = -1 -- some other mystery problem
}

-- BASS_SetConfig options
local config = {
  buffer = 0,
  update_period = 1,
  global_volume_sample = 4,
  global_volume_stream = 5,
  global_volume_music = 6,
  curve_volume = 7,
  curve_pan = 8,
  float_dsp = 9,
  algorithm_3d = 10,
  net_timeout = 11,
  net_buffer = 12,
  pause_not_playing = 13,
  net_prebuffer = 15,
  net_passive = 18,
  recording_buffer = 19,
  net_playlist = 21,
  music_virtual = 22,
  verify = 23,
  update_threads = 24,
  device_buffer = 27,
  vista_true_position = 30,
  ios_mix_audio = 34,
  device_default = 36,
  net_read_timeout = 37,
  vista_speakers = 38,
  ios_speaker = 39,
  mf_disable = 39,
  handles = 41,
  unicode = 42,
  source = 43,
  source_sample = 44,
  asynchronous_file_buffer = 45,
  ogg_prescan = 47,
  mf_video = 48,
  airplay = 49,
  device_nonstop = 50,
  ios_no_category = 51,
  verify_net = 52,
  device_period = 53,
  float = 54,
  net_seek = 56,
  net_agent = 16,
  net_proxy = 17,
  ios_notify = 46
}

-- BASS_Init flags
local device = {
  eight_bit = 1, -- 8 bit
  mono = 2, -- mono
  three_d = 4, -- enable 3D functionality
  sixteen_bit = 8, -- limit output to 16 bit
  latency = 0x100, -- calculate device latency (BASS_INFO struct)
  cp_speakers = 0x400, -- detect speakers via Windows control panel
  speakers = 0x800, -- force enabling of speaker assignment
  no_speaker = 0x1000, -- ignore speaker arrangement
  dmix = 0x2000, -- use ALSA "dmix" plugin
  frequency = 0x4000, -- set device sample rate
  stereo = 0x8000 -- limit output to stereo
}

-- BASS_DEVICEINFO flags
local device_info = {
  enabled = 1,
  default = 2,
  init = 4,
  type_mask = 0xff000000,
  type_network = 0x01000000,
  type_speakers = 0x02000000,
  type_line = 0x03000000,
  type_headphones = 0x04000000,
  type_microphone = 0x05000000,
  type_headset = 0x06000000,
  type_handset = 0x07000000,
  type_digital = 0x08000000,
  type_spdif = 0x09000000,
  type_hdmi = 0x0a000000,
  type_displayport = 0x40000000
}

local sample = {
  eight_bit = 1, -- 8 bit
  float = 256, -- 32 bit floating-point
  mono = 2, -- mono
  loop = 4, -- looped
  three_d = 8, -- 3D functionality
  software = 16, -- not using hardware mixing
  mute_max = 32, -- mute at max distance (3D only)
  voice_allocation_management = 64, -- DX7 voice allocation & management
  fx = 128, -- old implementation of DX8 effects
  override_volume = 0x10000, -- override lowest volume
  override_position = 0x20000, -- override longest playing
  override_distance = 0x30000 -- override furthest from listener (3D only)
}

local stream = {
  prescan = 0x20000, -- enable pin-point seeking/length (MP3/MP2/MP1)
  auto_free = 0x40000, -- automatically free the stream when it stop/ends
  restrict_rate = 0x80000, -- restrict the download rate of internet file streams
  block = 0x100000, -- download/play internet file stream in small blocks
  decode = 0x200000, -- don't play the stream, only decode (BASS_ChannelGetData)
  status = 0x800000 -- give server status info (HTTP/ICY tags) in DOWNLOADPROC
}

local music = {
  float = sample.float,
  mono = sample.mono,
  loop = sample.loop,
  three_d = sample.three_d,
  fx = sample.fx,
  auto_free = stream.auto_free,
  decode = stream.decode,
  prescan = stream.prescan,
  calculate_length = stream.prescan,
  ramp = 0x200, -- normal ramping
  ramp_sensitive = 0x400, -- sensitive ramping
  surround = 0x800, -- surround sound
  surround2 = 0x1000, -- surround sound (mode 2)
  fasttracker2_panning = 0x2000, -- apply FastTracker 2 panning to XM files
  fasttracker2_mod = 0x2000, -- play .MOD as FastTracker 2 does
  protracker1_mod = 0x4000, -- play .MOD as ProTracker 1 does
  non_interpolated = 0x10000, -- non-interpolated sample mixing
  sinc_interpolated = 0x800000, -- sinc interpolated sample mixing
  position_reset = 0x8000, -- stop all notes when moving position
  position_reset_ex = 0x400000, -- stop all notes and reset bmp/etc when moving position
  stop_backward = 0x80000, -- stop the music on a backwards jump effect
  no_sample = 0x100000 -- don't load the samples
}

-- 3D channel modes
local three_d_mode = {
  normal = 0, -- normal 3D processing
  relative = 1, -- position is relative to the listener
  off = 2 -- no 3D processing
}

-- software 3D mixing algorithms (used with BASS_CONFIG_3DALGORITHM)
local three_d_algorithm = {
  default = 0,
  off = 1,
  full = 2,
  light = 3
}

-- BASS_ChannelIsActive return values
local active = {
  stopped = 0,
  playing = 1,
  stalled = 2,
  paused = 3
}

-- Channel attributes
local attribute = {
  frequency = 1,
  volume = 2,
  pan = 3,
  eax_mix = 4,
  no_buffer = 5,
  vbr = 6,
  cpu = 7,
  sample_rate_conversion = 8,
  net_resume = 9,
  scan_info = 10,
  no_ramp = 11,
  bitrate = 12,
  music_amplify = 0x100,
  music_pan_separation = 0x101,
  music_position_scaler = 0x102,
  music_bpm = 0x103,
  music_speed = 0x104,
  music_global_volume = 0x105,
  music_active = 0x106,
  music_channel_volume = 0x200, -- + channel #
  music_instrument_volume = 0x300 -- + instrument #
}

-- BASS_ChannelGetLength/GetPosition/SetPosition modes
local position = {
  byte = 0, -- byte position
  music_order = 1, -- order.row position, MAKELONG(order,row)
  ogg = 3, -- OGG bitstream number
  inexact = 0x8000000, -- flag: allow seeking to inexact position
  decode = 0x10000000, -- flag: get the decoding (not playing) position
  decode_to = 0x20000000, -- flag: decode to the position instead of seeking
  scan = 0x40000000 -- flag: scan to the position
}

local fx = {
  dx8_chorus = 0,
  dx8_compressor = 1,
  dx8_distortion = 2,
  dx8_echo = 3,
  dx8_flanger = 4,
  dx8_gargle = 5,
  dx8_i3dl2reverb = 6,
  dx8_parameq = 7,
  dx8_reverb = 8
}

-- BASS_ChannelGetData flags
local data = {
  available = 0, -- query how much data is buffered
  fixed = 0x20000000, -- flag: return 8.24 fixed-point data
  float = 0x40000000, -- flag: return floating-point sample data
  fft256 = 0x80000000, -- 256 sample FFT
  fft512 = 0x80000001, -- 512 FFT
  fft1024 = 0x80000002, -- 1024 FFT
  fft2048 = 0x80000003, -- 2048 FFT
  fft4096 = 0x80000004, -- 4096 FFT
  fft8192 = 0x80000005, -- 8192 FFT
  fft16384 = 0x80000006, -- 16384 FFT
  fft32768 = 0x80000007, -- 32768 FFT
  fft_individual = 0x10, -- FFT flag: FFT for each channel, else all combined
  fft_nowindow = 0x20, -- FFT flag: no Hanning window
  fft_removedc = 0x40, -- FFT flag: pre-remove DC bias
  fft_complex = 0x80 -- FFT flag: return complex data
}

return {
  active = active,
  attribute = attribute,
  config = config,
  data = data,
  device = device,
  device_info = device_info,
  error = error,
  fx = fx,
  music = music,
  position = position,
  sample = sample,
  stream = stream,
  three_d_algorithm = three_d_algorithm,
  three_d_mode = three_d_mode
}