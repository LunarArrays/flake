use core::str;
use std::process::Command;
use std::thread::sleep;
use std::time::Duration;

use gio::ActionEntry;
use gtk4::{prelude::*, Orientation};
use gtk4_layer_shell::{Edge, Layer};
use gtk4_layer_shell::LayerShell;
use glib::{ControlFlow};

use gtk4::EventControllerMotion;
use gtk4::ApplicationWindow;

use generate_gtk::gtk;

pub fn get_music_window(app :&gtk4::Application) -> gtk4::ApplicationWindow
{
    let music_window = gtk4::ApplicationWindow::new(app);

    music_window.init_layer_shell();

    music_window.set_layer(Layer::Overlay);

    music_window.set_anchor(Edge::Left  , true);
    music_window.set_anchor(Edge::Right , true);
    music_window.set_anchor(Edge::Top   , true);
    music_window.set_anchor(Edge::Bottom, false);
 

    gtk!(
        - play_button :Button()
            label(&" ")
            css_classes(&["power_button"])
        - prev_song_button :Button()
            label("<")
            margin_start(15)
        - next_song_button :Button()
            label(">")
            margin_end(15)

        - music_title :Box(Orientation::Vertical, 0)
            -- music_title_name :Label(Some(""))
                css_classes(&["small_test"])
            -- music_title_info :Label(Some(""))
        - music_widget :Box(Orientation::Vertical, 0)
            css_classes(&["barpart"])

            -- title_header :CenterBox()
                start_widget(Some(&prev_song_button))
                center_widget(Some(&music_title))
                end_widget(Some(&next_song_button))

                margin_top(20)
                margin_top(15)

            -- img_box :Box(Orientation::Vertical, 0)
                css_classes(&["image"])

            -- music_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 1.0, 1.0)))
            size_request(250,20)
            css_classes(&["big_scale"])

            -- music_control :CenterBox()
                center_widget(Some(&play_button))

        -music_box :CenterBox()
        center_widget(Some(&music_widget))

    );
//----------------------------------------------------------

    let img = gtk4::Image::from_file("goober.png");

    img.set_size_request(300, 300);
    img_box.append(&img);
    music_window.set_child(Some(&music_box));

    prev_song_button.connect_clicked(|_|{
        let _ = &Command::new("rmpc")
            .arg("prev").output();
    });
    next_song_button.connect_clicked(|_|{
        let _ = &Command::new("rmpc")
           .arg("next").output();
    });

     let play_b_ref = play_button.downgrade();
    play_button.connect_clicked(move |_| {
        let song_cmd = &Command::new("rmpc")
             .arg("get").output().unwrap();
         let song_data = str::from_utf8(&song_cmd.stdout).expect("rmpc get is not utf8")
             .split("\n").map(|x| x).collect::<Vec<&str>>();
        if let Some(button_ref) = play_b_ref.upgrade()
        {
            match song_data[0] {
                "playing" => {Command::new("rmpc").arg("pause").output(); button_ref.set_label(" ")},
                "paused"  => {Command::new("rmpc").arg("play").output();  button_ref.set_label(" ")},
                _ => panic!("rmpc changed")
            };
        }
    });


    let mb_ec = EventControllerMotion::new();
    let mw_ref = music_window.downgrade();
    mb_ec.connect_leave(move |_|{
        if let Some(music_upref) = mw_ref.upgrade(){
            music_upref.hide();
        }
    });
    music_widget.add_controller(mb_ec);


//--------------------------------------------------------------

    let tick = move || {
        let song_cmd = &Command::new("rmpc")
             .arg("get").output().unwrap();

        let song_data = str::from_utf8(&song_cmd.stdout).expect("rmpc get is not utf8")
             .split("\n").map(|x| x).collect::<Vec<&str>>();

        music_title_info.set_text(song_data[1]);
        let artist = song_data[4].replace("&", "&amp;");
        music_title_info.set_markup(&format!(r#"<span foreground="white" size="small">by: {}</span>"#,artist));
        match song_data[0] {
            "playing" => {
                let song_progress = song_data[3].parse::<f32>().unwrap()  / song_data[2].parse::<f32>().unwrap();
                music_scale.set_value((song_progress * 100.0).into());
                music_title_name.set_label(song_data[1]);
            },
            "paused"  => {sleep(Duration::from_millis(500))},
            _ => {panic!("rmpc get changed wtf did u do u idiot");}
        };
    };
    let mw_ref = music_window.downgrade();
    let action_close = ActionEntry::builder("close")
        .activate(move |window: &ApplicationWindow, _, _| {
        if let Some(music_upref) = mw_ref.upgrade(){
            music_upref.close();
        }
        })
        .build();

    music_window.add_action_entries([action_close]);
    music_window
}
