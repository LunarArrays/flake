use std::process::Command;
use std::time::Duration;

use gtk4::{prelude::*, Orientation, CssProvider};
use gtk4_layer_shell::{Edge, Layer};
use gtk4_layer_shell::LayerShell;
use glib::{ControlFlow, ExitCode};
use gtk4::gdk::Display;

use generate_gtk::gtk;

mod hypr;
mod data;


fn activate(application: &gtk4::Application) {
    let window = gtk4::ApplicationWindow::new(application);
    window.init_layer_shell();

    window.set_layer(Layer::Overlay);
    window.auto_exclusive_zone_enable();

    window.set_margin(Edge::Left  , 15  );
    window.set_margin(Edge::Right , 15  );
    window.set_margin(Edge::Top   , 5    );
    window.set_anchor(Edge::Left  , true);
    window.set_anchor(Edge::Right , true);
    window.set_anchor(Edge::Top   , true);
    window.set_anchor(Edge::Bottom, false);

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


        - center_bar_box :Box(Orientation::Horizontal, 10)
            css_classes(&["barpart"])
            -- window_title :Label(Some(""))
                margin_start(8)
                margin_end(8)


        - right_bar_box :Box(Orientation::Horizontal, 15)
            css_classes(&["barpart"])

            -- sound_box :Box(Orientation::Horizontal, 5)
                margin_start(12)
                --- sound_label :Label(Some(""))
                --- sound_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 1.0, 1.0)))
                    size_request(45,0)

            -- ram_box :Box(Orientation::Horizontal, 5)
                --- ram_lable :Label(Some("")) 
                --- ram_scale :Scale(Orientation::Horizontal, Some(&gtk4::Adjustment::new(0.0, 0.0, 101.0, 1.0, 0.0, 0.0)))
                    size_request(45,0)

            -- time_label :Label(Some(""))

            -- power_button :Button()
            label(&" ")
            css_classes(&["power_button"])


        - bar_box :CenterBox()
            start_widget(Some(&left_bar_box))
            center_widget(Some(&center_bar_box))
            end_widget(Some(&right_bar_box))
    );

    window.set_child(Some(&bar_box));
    window.show();

    sound_scale.connect_change_value(|_ , _, value| {
        let _ = &Command::new("pamixer")
            .arg("--set-volume")
            .arg(&value.round().to_string()).output().unwrap();
        println!("{}", value.round());
        glib::Propagation::Proceed
    });

    match data::get_audio() 
    {
        data::Sound::Mute => {sound_label.set_text("mute")},
        data::Sound::Level(sound_level) => {
            sound_scale.set_value(sound_level.into())
        }  
    }

    let tick = move | | {

        let time = &data::get_time();
        time_label.set_text(&time);

        match hypr::get_selected_window() 
        {
            Some(window) => 
            {
                if window.title.is_some() {
                    window_title.set_text(&window.title.expect("active window has no title"));
                }
                else {
                    window_title.set_text("  ");
                }
            }
            None => (),
        }   

        match data::get_audio() 
        {
            data::Sound::Mute => {sound_label.set_text("mute")},
            data::Sound::Level(sound_level) => {
                sound_label.set_text(&format!(" {}%",sound_level.to_string()));
            }  
        }

        let memory = data::get_mem();
        let perc_mem_used :f64 = ((1.0-(memory[2]/memory[0]))*100.0).round();
        ram_scale.set_value(perc_mem_used);
        ram_lable.set_text(&format!(" {}%",&perc_mem_used));

        let hypr_workspaces = hypr::get_formated_workspace();
        workspace_l_0.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[1]));
        workspace_l_1.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[2]));
        workspace_l_2.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[3]));
        workspace_l_3.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[4]));
        workspace_l_4.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[5]));
        workspace_l_5.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[6]));
        workspace_l_6.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[7]));
        workspace_l_7.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[8]));
        workspace_l_8.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[9]));
        workspace_l_9.set_label(&hypr::get_icons_for_workspace(&hypr_workspaces[10]));

        ControlFlow::Continue
    };

    glib::timeout_add_seconds_local(1, tick);

}



fn main() {
    let application = gtk4::Application::new(Some("net.custom.nord-bar"), Default::default());
    
    application.connect_startup(|_| {
        load_css();
    });

    application.connect_activate(|app| {
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


