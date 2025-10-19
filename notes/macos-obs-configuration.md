## Output / Recording
- Recording Path: `$HOME/Documents/Captures`.
- Generate File Name w/o Spaces: ✅.
- Recording Format: Hybrid MP4.
- Video Encoder
  - Intel Mac: Apple VT H264 Hardware Encoder.
  - Intel Mac w/ T2 chip: Apple VT HEVC T2 Hardware Encoder.
  - Apple Silicon: Apple VT HEVC Hardware Encoder.
- Audio Encoder: CoreAudio AAC.
- Rate Control: ABR.
- Bitrate:
  - 2880x1800: 4000 Kbps.
  - 3072x1920: 5000 Kbps.
  - 3456x2234: 6000 Kbps.
  - 5120x2880: 9000 Kbps.
- Limit Bitrate: ✅ (2x Bitrate).
- Maximum Birate Window: 10s.
- Keyframe Interval: 20s.
- Profile: main.
- Use B-Frames: ✅.
- Spatial AQ: Automatic.

## Video
- Base (Canvas) Resolution: Native.
- Base (Canvas) Resolution: Native.
- FPS: 24 NTSC.

## Profiles and Scenes
- Profile(s):
  - One per each single Output resolution. Ex: One profile for the laptop's
    screen and another for an external one.
  - Name them according w/ the source name. Ex: `mbp16`, `4K27inch`, `5K27inch`, ...
- Scene(s):
  - One per each profile and scale the sources accordingly.
  - Name them like `<profile_name> - <scene_name>`. Ex: `mbp16 - Desktop + Webcam`
  - If recording the Desktop, lock its position and don't hide OBS from the
    capture.
  - If recording the Webcam:
    - Use a lower resolution present than the native one, keeping quality in mind.
    - Set both Show/Hide transitions to a Fade of 150ms.
    - Use a PNG mask to render the source as a solid circle.
    - Lock its position.
  - Name sources w/ obvious names. Ex: `Desktop`, `Webcam`, ...
  - Noise Suppression:
    - Use macOS's Voice Isolation filter.
    - Use OBS's Noise Suppression filter when macOS's Voice Isolation isn't available.
