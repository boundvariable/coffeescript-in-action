cassette =
  title: "Awesome songs. To the max!"
  duration: "10:34"
  released: "1988"
  track1: "Safety Dance - Men Without Hats"
  track2: "Funkytown - Lipps, Inc"
  track3: "Electric Avenue - Eddy Grant"
  track4: "We built this city - Starship"

# The music device was created from it:
musicDevice = Object.create cassette

# Creating another one from the first is the same:
secondMusicDevice = Object.create musicDevice
# Changes to either the original cassette or the music device will be visible on the second music device:
cassette.track5 = "Hello - Lionel Richie"

secondMusicDevice.track5
# "Hello - Lionel Richie"

musicDevice.track6 = "Mickey - Toni Basil"

secondMusicDevice.track6
# "Mickey - Toni Basil"
