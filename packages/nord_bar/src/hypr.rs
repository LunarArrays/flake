use std::process::Command;
use std::str::FromStr;

pub struct HyprWindow 
{
    pub class :Option<String>,
    pub title :Option<String>,
    pub pos :[i32;2],
    pub size :[i32; 2],
    pub workspace : i32
}

impl HyprWindow {
    pub fn new() -> HyprWindow
    {
        HyprWindow
        {
        class :None,
        title: None,
        pos: [0;2],
        size: [0;2],
        workspace: 0,
        }
    }
    
}


const ASCI_NUM_END :u8 = 57;
pub fn get_formated_workspace() -> [Vec<HyprWindow>; 11]
{
    let hyprctl_read = String::from_utf8(Command::new("hyprctl")
            .arg("clients")
            .output()
            .expect("hyprctl missing").stdout).expect("cant convert utf8 to string in hyprctl");
    let mut hypr_workspaces = [Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(),Vec::new(), Vec::new()] ;
    let clients = hyprctl_read.split("\n\n");
    for client in clients
    {
        let infos = client.split("\n");
        let mut new_hypr_window = HyprWindow::new();
        let mut is_mapped = false;
        for info in infos.skip(1)
        {
            if info == "" {break} else {is_mapped = true;}
            let info_split = info.split_at(info.find(":").expect("hyprctl ouput does not contain :"));
            match info_split.0
            {
                "   mapped" => {if info_split.1 == ": 0" {break;}}
                "	at" | "   size" => {
                    let str = info_split.1.strip_prefix(": ").unwrap();
                    let pos_str = str.split_once(",").expect("hyprctl input err 1: ,");
                    if info_split.0 == "   at"{ new_hypr_window.pos = [FromStr::from_str(pos_str.0).unwrap(), FromStr::from_str(pos_str.1).unwrap()];}
                    else {new_hypr_window.size = [FromStr::from_str(pos_str.0).unwrap(), FromStr::from_str(pos_str.1).unwrap()];}
                },
                "	class" | "	title" => {
                    let str = info_split.1.strip_prefix(": ").unwrap();
                    if info_split.0 == "	class" 
                    { 
                        new_hypr_window.class = Some(str.to_string()) 
                    } else { 
                        new_hypr_window.title = Some(str.to_string()); break;
                    }
                }

                "	workspace" => {
                    let str = info_split.1.split_once("(").expect("hypctl input err 1: (").1.split_once(")").expect("hypctl input err 1: )").0;
                    if str == "" {continue;}
                    if str.as_bytes()[0] < ASCI_NUM_END 
                    {
                        new_hypr_window.workspace = FromStr::from_str(str).expect("workspace not a number");
                    } 
                },
                _ => ()

            }
        }
        if !is_mapped || new_hypr_window.workspace < 0 {break;}
        hypr_workspaces[usize::try_from(new_hypr_window.workspace).unwrap()]
            .push(new_hypr_window);
    }
    return hypr_workspaces
}

pub fn get_selected_window() -> Option<HyprWindow>
{
let client = String::from_utf8(Command::new("hyprctl")
            .arg("activewindow")
            .output()
            .expect("hyprctl missing").stdout).expect("cant convert utf8 to string in hyprctl");

let infos = client.split("\n");
        let mut new_hypr_window = HyprWindow::new();
        for info in infos.skip(1)
        {
            if info == "" {return None;}
            let info_split = info.split_at(info.find(":").expect("hyprctl ouput does not contain :"));
            match info_split.0
            {
                "   mapped" => {if info_split.1 == ": 0" {break;}}
                "	at" | "   size" => {
                    let str = info_split.1.strip_prefix(": ").unwrap();
                    let pos_str = str.split_once(",").expect("hyprctl at not split by ,");
                    if info_split.0 == "   at"{ new_hypr_window.pos = [FromStr::from_str(pos_str.0).unwrap(), FromStr::from_str(pos_str.1).unwrap()];}
                    else {new_hypr_window.size = [FromStr::from_str(pos_str.0).unwrap(), FromStr::from_str(pos_str.1).unwrap()];}
                },
                "   class" | "	title" => {
                    let str = info_split.1.strip_prefix(": ").unwrap();
                    if info_split.0 == "   class" { new_hypr_window.class = Some(str.to_string()) } else { new_hypr_window.title = Some(str.to_string()); break;}
                }

                "	workspace" => {
                    let str = info_split.1.split_once("(").expect("hypctl input err 1: (").1.split_once(")").expect("hypctl input err 1: )").0;
                    if str == "" {continue;}
                    if str.as_bytes()[0] < ASCI_NUM_END 
                    {
                        new_hypr_window.workspace = FromStr::from_str(str).expect("workspace not a number");
                    } 
                },
                _ => ()

            }
        }
    Some(new_hypr_window)
}

pub fn get_icons_for_workspace(windows :&Vec<HyprWindow>) -> String
{
    let mut out = "".to_string();
    let mut check_map :Vec<(String, &str)>= Vec::new();

    check_map.push(("kitty".to_owned(), " "));
    check_map.push(("librewolf".to_owned(), "󰈹 "));
    check_map.push(("firefox".to_owned(), "󰈹 "));
    check_map.push(("org.prismlauncher.PrismLauncher".to_owned(), "󰍳 "));
    check_map.push(("org.keepassxc.KeePassXC".to_owned(), " "));
    check_map.push(("steam".to_owned(), " "));

    for window in windows
    {
        if let Some(class) = &window.class
        {
            for app_class in &check_map
            {
                if app_class.0 == *class
                {
                    out.push_str(app_class.1);
                    break;
                }
            }
        }
    }
//"󰈹  󰍳  󰂯   󰄛     ".to_owned()
out
}
