use std::io::{BufRead, BufReader};
use std::os::unix::net::UnixStream;
use std::process::Command;
use std::str::FromStr;

use std::thread::current;
use std::{env, thread};

use crate::events::Event;

pub struct HyprWindow 
{
    pub class :Option<String>,
    pub title :Option<String>,
    pub pos :[i32;2],
    pub size :[i32; 2],
    pub workspace : i32
}

pub struct SimpleHyprWidnow
{
    pub id :String,
    pub title: Option<String>,
    pub class: Option<String>,
}

pub struct IconSet 
{
    icons : String,
    main_active :Option<usize>,
    //None -> on no monitor
    //Some(False) -> not on main monitor 
    //Some(True) -> on main Monitor
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

impl SimpleHyprWidnow {
    pub fn new() -> SimpleHyprWidnow
    {
        SimpleHyprWidnow
        {
        id: "".to_owned(),
        class :None,
        title: None,
       }
    }

    pub fn to_icon(&self) -> String
    {
        let mut out = "".to_string();
        let mut check_map :Vec<(String, &str)>= Vec::new();

        check_map.push(("kitty".to_owned(), " "));
        check_map.push(("librewolf".to_owned(), "󰈹 "));
        check_map.push(("firefox".to_owned(), "󰈹 "));
        check_map.push(("org.prismlauncher.PrismLauncher".to_owned(), "󰍳 "));
        check_map.push(("org.keepassxc.KeePassXC".to_owned(), " "));
        check_map.push(("steam".to_owned(), " "));

        if let Some(class) = &self.class
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
    //"󰈹  󰍳  󰂯   󰄛     ".to_owned()
    out
    }
}

pub fn send_active_window(tx :glib::Sender<super::Event>)
{
    let xdk_dir = env::var("XDG_RUNTIME_DIR").unwrap();
    let hypr_instance = env::var("HYPRLAND_INSTANCE_SIGNATURE").unwrap();
    let stream = UnixStream::connect(format!("{}/hypr/{}/.socket2.sock", xdk_dir, hypr_instance)).unwrap();
    thread::spawn(move ||{
        let stream = BufReader::new(stream);
        for line in stream.lines()
        { 
            let line = &line.unwrap();
            if line.len() < 13 {continue;}
            let active_window= line[..13] == *"activewindow>"; 
            if active_window
            {
                let Some((class, name)) = line[14..].split_once(",") else {panic!("can't split hypr socket output")};
                let out = if name.len() < 40 {name} else {class};
                tx.send(super::Event::ActiveWindowUpdate(out.to_owned())).unwrap();
            }
        }
    });
}

const CLOSE_WORD_LEN :usize = 13;
const OPEN_WORD_LEN  :usize = 12;
pub fn send_window_icons (tx :glib::Sender<super::Event>)
{
    let xdk_dir = env::var("XDG_RUNTIME_DIR").unwrap();
    let hypr_instance = env::var("HYPRLAND_INSTANCE_SIGNATURE").unwrap();
    let stream = UnixStream::connect(format!("{}/hypr/{}/.socket2.sock", xdk_dir, hypr_instance)).unwrap();
    thread::spawn(move ||{
        let mut workspaces :[Vec<SimpleHyprWidnow>; 11] = get_simple_workspaces();
        let mut active_workspace= get_curren_workspace();
        let stream = BufReader::new(stream);

        for i  in 10 .. 1
        {
            let icons = get_icons_for_workspace(&workspaces[i]);
            tx.send(Event::IconUpdate(i, icons));
        }

        for line in stream.lines()
        { 
            let line = &line.unwrap();
            if line[..10] == *"workspace>" || line[..3] == *"foc"
            {
                active_workspace = usize::from(line[line.len() -1..].bytes().last().unwrap() - 48);
                println!("{}", active_workspace);
            }
            if line[..5] == *"openw" {
                let new_window = SimpleHyprWidnow::new();
                let (_, mut info) = line.split_at(OPEN_WORD_LEN);
                let segments :Vec<&str> = info.split(",").collect();
                let new_window = SimpleHyprWidnow {
                    id: segments[0].to_owned(),
                    class: Some(segments[2].to_owned()),
                    title: Some(segments[3].to_owned()),
                };
                let opend_in :usize = segments[1].parse().expect("hyprctl sock err");
                workspaces[opend_in].push(new_window);
                let icons= get_icons_for_workspace(&workspaces[opend_in]);
                tx.send(Event::IconUpdate(opend_in, icons));

            } 
            if line[..6] == *"closew"
            {
                let new_window = SimpleHyprWidnow::new();
                let (_, mut id) = line.split_at(CLOSE_WORD_LEN);
                let i  = 1;
                let mut emit :Option<super::Event> = None;
                let mut closed_on = 0;
                for workspace in &mut workspaces
                {
                    let mut quit = false;
                    let index = workspace.iter().position(|x| x.id == id);
                    if index.is_some() {
                        quit = true;
                        workspace.remove(index.unwrap());
                        let out = get_icons_for_workspace(workspace);
                        emit = Some(Event::IconUpdate(closed_on, out));
                    }
                    if quit {
                        tx.send(emit.unwrap()).unwrap();
                        break;
                    }
                    closed_on += 1;
                }
            }
        }
    });
}

fn find_id_in_workspace(workspaces :&[Vec<SimpleHyprWidnow>; 11])
{

}

fn get_icons_for_workspace(workspace :&Vec<SimpleHyprWidnow>) -> String
{ 
    let mut  out = "".to_owned();
    for window in workspace
    {
        out.push_str(&window.to_icon());
    }
    out
}

fn get_curren_workspace() -> usize
{
    let hyprctl_read = String::from_utf8(Command::new("hyprctl")
            .arg("activeworkspace")
            .output()
            .expect("hyprctl missing").stdout).expect("cant convert utf8 to string in hyprctl");

    let bytes = hyprctl_read.as_bytes();
    let mut out = 0;
    for byte in bytes 
    {
        if out == 1 && *byte == 48
        { out = 10; break; } else if out ==1 
        { break; }
        if 58 > *byte && *byte > 47
        {
            out = byte - 48;
            if out == 1 {
                continue;
            } else { break; }
        }
    }
    usize::from(out)
}
fn get_simple_workspaces() -> [Vec<SimpleHyprWidnow>; 11]
{
    let hyprctl_read = String::from_utf8(Command::new("hyprctl")
            .arg("clients")
            .output()
            .expect("hyprctl missing").stdout).expect("cant convert utf8 to string in hyprctl");
    let mut hypr_workspaces = [Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new(),Vec::new(), Vec::new()] ;
    let mut workspace = 0; 
    let clients = hyprctl_read.split("\n\n");
    for client in clients
    {
        let infos = client.split("\n");
        let mut new_hypr_window = SimpleHyprWidnow::new();
        let mut is_mapped = false;
        for info in infos
        {
            if info == "" {break} else {is_mapped = true;}
            let info_split = info.split_at(info.find(":").expect("hyprctl ouput does not contain :"));
            if info_split.0[0..1] == *"W"
            {
                let id = &info_split.0[7..14];
                new_hypr_window.id = id.to_owned();
            }
            match info_split.0
            {
                "	class" | "	title"=> {
                    let in_str = info_split.1.strip_prefix(": ").unwrap();
                    if info_split.0 == "	class" 
                    { 
                        new_hypr_window.class = Some(in_str.to_string()) 
                    } else { 
                        new_hypr_window.title = Some(in_str.to_string()); break;
                    }
                },

                "	workspace" => {
                    let str = info_split.1.split_once("(").expect("hypctl input err 1: (").1.split_once(")").expect("hypctl input err 1: )").0;
                    if str == "" {continue;}
                    if str.as_bytes()[0] < ASCI_NUM_END 
                    {
                        workspace = FromStr::from_str(str).expect("workspace not a number");
                    } 
                },
                _ => ()

            }
        }
        if !is_mapped || workspace < 0 {break;}
        hypr_workspaces[usize::try_from(workspace).unwrap()]
            .push(new_hypr_window);
    }
     return hypr_workspaces;
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
    Some(new_hypr_window)
}

pub fn to_icon(windows :&Vec<HyprWindow>) -> String
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

