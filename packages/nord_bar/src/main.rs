use core::str;
use std::collections::HashMap;
use std::process::Command;
use std::sync::{Arc, Mutex};
use std::thread::{self, sleep};
use std::time::Duration;

use gtk4::{prelude::*, CssProvider, Orientation};
use gtk4_layer_shell::{Edge, Layer};
use gtk4_layer_shell::LayerShell;
use glib::{ControlFlow, Receiver, Sender};
use gtk4::gdk::Display;
use generate_gtk::gtk;

mod music_player;
mod events;

use events::data;
use events::hypr;

fn activate(application: &gtk4::Application) {
    let window = gtk4::ApplicationWindow::new(application);
    window.init_layer_shell();

    window.set_layer(Layer::Bottom);

    window.set_margin(Edge::Left  , 15  );
    window.set_margin(Edge::Right , 15  );
    window.set_margin(Edge::Top   , 5    );
    window.set_anchor(Edge::Left  , true);
    window.set_anchor(Edge::Right , true);
    window.set_anchor(Edge::Top   , true);
    window.set_anchor(Edge::Bottom, false);
 
    let music_window = music_player::get_music_window(&application);


    gtk!(
        - left_bar_box :Box(Orientation::Horizontal, 0)
                css_classes(&["workspace_preview"])
            -- workspace_0 :Box(Orientation::Horizontal, 0)
                --- workspace_l_0 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_1 :Box(Orientation::Horizontal, 0)
                --- workspace_l_1 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_2 :Box(Orientation::Horizontal, 0)
                --- workspace_l_2 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_3 :Box(Orientation::Horizontal, 0)
                --- workspace_l_3 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_4 :Box(Orientation::Horizontal, 0)
                --- workspace_l_4 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_5 :Box(Orientation::Horizontal, 0)
                --- workspace_l_5 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_6 :Box(Orientation::Horizontal, 0)
                --- workspace_l_6 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_7 :Box(Orientation::Horizontal, 0)
                --- workspace_l_7 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_8 :Box(Orientation::Horizontal, 0)
                --- workspace_l_8 :Label(Some(""))
                css_classes(&["workspace_preview"])
            -- workspace_9 :Box(Orientation::Horizontal, 0)
                --- workspace_l_9 :Label(Some(""))
                css_classes(&["workspace_preview"])

        - window_title :Button()
            margin_start(8)
            margin_end(8)

        - mid_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 0.0, 0.0)))
            size_request(300,20)
            css_classes(&["big_scale"])

        - mid_bar_box :Box(Orientation::Horizontal, 10)
            css_classes(&["barpart"])
            --mid_overlay :Overlay()
                halign(gtk4::Align::Center)
                child(Some(&mid_scale))


        - right_bar_box :Box(Orientation::Horizontal, 15)
            css_classes(&["barpart"])

            -- sound_box :Box(Orientation::Horizontal, 5)
                margin_start(12)
                --- sound_label :Label(Some(""))
                --- sound_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 1.0, 1.0)))
                    css_classes(&["small_scale"])
                    size_request(45,0)

            -- ram_box :Box(Orientation::Horizontal, 5)
                --- ram_lable :Label(Some("")) 
                --- ram_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 0.0, 0.0)))
                    css_classes(&["small_scale"])
                    size_request(45,0)

            -- time_label :Label(Some(""))

            -- power_button :Button()
            label(&" ")
            css_classes(&["power_button"])

        - music_widget :Box(Orientation::Vertical, 0)
            css_classes(&["barpart"])
        - bar_box :CenterBox()
            start_widget(Some(&left_bar_box))
            center_widget(Some(&mid_bar_box))
            end_widget(Some(&right_bar_box))
        -music_box :CenterBox()
        center_widget(Some(&music_widget))
    );

   mid_overlay.add_overlay(&window_title);

    let (tx , rx) :(Sender<events::Event>, Receiver<events::Event>)= glib::MainContext::channel(glib::Priority::DEFAULT);
    hypr::send_active_window(tx.clone()); 
    hypr::send_window_icons(tx.clone()); 
    events::timed_send!(tx, data::get_time_event, 999); 
    events::timed_send!(tx, data::get_mem_event, 3000); 
    events::timed_send!(tx, data::get_vol_event, 1500); 
    let open_sender = tx.clone();

    sound_scale.connect_change_value(move |_ , _, value| {
        let value = value.round();
        let _ = &Command::new("pamixer")
            .arg("--set-volume")
            .arg(&value.round().to_string()).output().unwrap();
        open_sender.send(events::Event::VolUpdate(Some((value, format!("{}", value)))));

        glib::Propagation::Proceed
    });
 
    let mwin_ref = music_window.downgrade(); 
    window_title.connect_clicked(move |_| {
        if let Some(mwin_upref) = mwin_ref.upgrade() {
            mwin_upref.show();
        }
    });

    let tick = move|| {
        let hypr_workspaces = hypr::get_formated_workspace();
        workspace_l_0.set_label(&hypr::to_icon(&hypr_workspaces[1]));
        workspace_l_1.set_label(&hypr::to_icon(&hypr_workspaces[2]));
        workspace_l_2.set_label(&hypr::to_icon(&hypr_workspaces[3]));
        workspace_l_3.set_label(&hypr::to_icon(&hypr_workspaces[4]));
        workspace_l_4.set_label(&hypr::to_icon(&hypr_workspaces[5]));
        workspace_l_5.set_label(&hypr::to_icon(&hypr_workspaces[6]));
        workspace_l_6.set_label(&hypr::to_icon(&hypr_workspaces[7]));
        workspace_l_7.set_label(&hypr::to_icon(&hypr_workspaces[8]));
        workspace_l_8.set_label(&hypr::to_icon(&hypr_workspaces[9]));
        workspace_l_9.set_label(&hypr::to_icon(&hypr_workspaces[10]));

        let song_cmd = &Command::new("rmpc")
             .arg("get").output().unwrap();
        let song_data = str::from_utf8(&song_cmd.stdout).expect("rmpc get is not utf8")
             .split("\n").map(|x| x).collect::<Vec<&str>>();
        match song_data[0] {
            "playing" => {
                let song_progress = song_data[3].parse::<f32>().unwrap()  / song_data[2].parse::<f32>().unwrap();
                mid_scale.set_value((song_progress * 100.0).into());
                //window_title.set_label(song_data[1]);
            },
            "paused"  => {mid_scale.set_value(0.0)},
            _ => {panic!("rmpc get changed wtf did u do u idiot");}
        };
        ControlFlow::Continue
    };

   glib::timeout_add_local(Duration::from_millis(200), tick);
    
    rx.attach(None, move|msg| {
        match msg {
            events::Event::TimeUpdate(time) => {time_label.set_label(&time);},
            events::Event::RamUpdate(pre_perc) => {
               let perc = pre_perc;
                ram_scale.set_value(perc.0);
                ram_lable.set_text(&format!(" {}%",perc.1));
            },
            events::Event::VolUpdate(pre_perc) => {
               let perc = pre_perc.unwrap();
                sound_scale.set_value(perc.0);
                sound_label.set_text(&format!(" {}%",perc.1));
            },
            events::Event::ActiveWindowUpdate(title) => {
                window_title.set_label(&title);
            },
            _ => (),
        }
        ControlFlow::Continue
    });

    window.set_child(Some(&bar_box));
    window.show();
   }


fn main() { 
    let application = gtk4::Application::new(Some("net.custom.nord-bar"), Default::default());
    
    application.connect_startup(|_| {
        load_css();
    });

    application.connect_activate(move |app| {
        activate(app);
    });
    application.run();
}

fn load_css() {
    let provider = CssProvider::new();
    provider.load_from_data(include_str!("style.css"));
    
    gtk4::style_context_add_provider_for_display(
        &Display::default().expect("no gtk display"),
        &provider,
        gtk4::STYLE_PROVIDER_PRIORITY_APPLICATION,
    );
}
