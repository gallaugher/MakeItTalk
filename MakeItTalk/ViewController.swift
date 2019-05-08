//
//  ViewController.swift
//  PiBot
//
//  Created by John Gallaugher on 2/9/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    
    var soundFiles: [String] = [ "clear_your_mind_must_be_if_you_are_to_find_the_villains_behind_this_plot.mp3",
                                 "a_geek_you_will_become_study_hard_you_must.mp3",
                                 "a_true_eagle_to_become_kind_you_must_be_mmm.mp3",
                                 "afraid_i_am_not_it_is.mp3",
                                 "already_you_know_that_which_you_need.mp3",
                                 "awesomeness_you_bring_yes.mp3",
                                 "bc_we_are.mp3",
                                 "certain_of_this_i_am.mp3",
                                 "chosen_a_difficult_path_you_have_rise_to_the_challenge_you_must.mp3",
                                 "cloudy_your_future_is_as_an_eagle_you_must_be.mp3",
                                 "difficult_question_you_ask.mp3",
                                 "do_or_do_not_there_is_no_try.mp3",
                                 "find_you_will_only_what_you_bring_in.mp3",
                                 "hmm_this_even_yoda_does_not_know.mp3",
                                 "hungry_are_you_skittles_you_may_have.mp3",
                                 "just_the_beginning_this_is.mp3",
                                 "may_the_4th_be_with_you.mp3",
                                 "may_the_force_be_with_you.mp3",
                                 "mind_what_you_have_learned_save_you_it_can.mp3",
                                 "much_to_learn_you_have.mp3",
                                 "no_i_fear.mp3",
                                 "no_i_sense_this_is.mp3",
                                 "not_of_anything_to_say_about_it_i_have.mp3",
                                 "prepared_for_the_answer_are_you.mp3",
                                 "questions_for_me_have_you_answer_them_I_will.mp3",
                                 "seek_inside_yourself_you_must_in_there_the_answer_is.mp3",
                                 "seeking_advice_are_you_young_padawan.mp3",
                                 "seeking_professor_g_you_are.mp3",
                                 "simple_question_you_ask.mp3",
                                 "taught_baldwin_to_fly_i_have.mp3",
                                 "the_answer_you_seek_is_yes.mp3",
                                 "the_dark_side_clouds_everything_impossible_to_see_the_future_is.mp3",
                                 "troubling_question_you_ask_clear_the_answer_is_not.mp3",
                                 "trust_in_the_one_who_is_bald_and_wears_a_beard_wise_he_is.mp3",
                                 "uncertain_this_is_mmm.mp3",
                                 "unknown this is.mp3",
                                 "use_the_force_teach_you_it_will.mp3",
                                 "use_the_force_wisely_its_power_for_good_you_must_use.mp3",
                                 "wonder_i_am_a_person_for_others_are_you.mp3",
                                 "yes.mp3"]
    
    
    let mqttclient = CocoaMQTT(clientID: "TalkApp", host: "talkpi.local", port: 1883)
    // *** IMPORTANT NOTE: Make sure your host name is entered properly, below ***
    // let mqttClient = CocoaMQTT(clientID: "TalkApp", host: "talkpi.local", port: 1883)
    // If you still have problems, make sure spelling is exactly as you've named your Pi
    // and is what you use when you ssh log in.
    // If that still doesn't work, try removing .local from the name.
    // And if that still doesn't work, try putting your Pi's IP address in between the quotes
    // instead of pibot.local.
    // ** REMEMBER: You'll have to click the "Play" Build/Run button in the upper left corner
    // each time you modify this code, so that you're running the code with your latest changes.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        slider.isEnabled = false // don't allow the user to set volume until device is connected
        soundFiles.sort()
    }
    
    @IBAction func slideValueChanged(_ sender: UISlider) {
        let volume = "vol-\(sender.value)"
        mqttclient.publish("talkpi/talk", withString: volume)
    }
    
    @IBAction func connectButtonPressed(_ sender: UIButton) {
        slider.isEnabled = true
        mqttclient.connect()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = soundFiles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mqttclient.publish("talkpi/talk", withString: soundFiles[indexPath.row])
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
