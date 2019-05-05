from adafruit_crickit import crickit
import os
import time

greeting = ['awesomeness_you_bring_yes.mp3',
            'seeking_professor_g_you_are.mp3',
            'hungry_are_you_skittles_you_may_have.mp3']
currentGreeting = 0

bcPhrase = ["bc_we_are.mp3",
            "a_true_eagle_to_become_kind_you_must_be_mmm.mp3",
            "taught_baldwin_to_fly_i_have.mp3",
            "trust_in_the_one_who_is_bald_and_wears_a_beard_wise_he_is.mp3",
            "wonder_i_am_a_person_for_others_are_you.mp3"]
currentBcPhrase = 0

os.system('mpg123 /home/pi/yoda_mp3s/yes.mp3 &')

while True:
#    print(crickit.touch_1.raw_value, crickit.touch_2.raw_value, crickit.touch_3.raw_value, crickit.touch_4.raw_value)
    if crickit.touch_1.raw_value > 650:
        playString = "mpg123 /home/pi/yoda_mp3s/" + greeting[currentGreeting] + " &"
        os.system(playString)
        time.sleep(4.0)
        currentGreeting = currentGreeting + 1
        if currentGreeting >= len(greeting):
            currentGreeting = 0

    if crickit.touch_4.raw_value > 650:
        playString = "mpg123 /home/pi/yoda_mp3s/" + bcPhrase[currentBcPhrase] + " &"
        os.system(playString)
        time.sleep(4.0)
        currentBcPhrase = currentBcPhrase + 1
        if currentBcPhrase >= len(bcPhrase):
            currentBcPhrase = 0
