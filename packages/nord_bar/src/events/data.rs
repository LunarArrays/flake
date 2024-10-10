use std::str::FromStr;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::process::Command;
use std::thread::sleep;
use std::time::{Duration, SystemTime, UNIX_EPOCH};
use crate::events::Event;

pub enum Sound {
    Level(i32),
    Mute
}

pub fn get_time_event() -> Option<Event>
{
        let now = SystemTime::now();
        let time = now.duration_since(UNIX_EPOCH).unwrap().as_secs() % 86400;
        let hours = time / 3600;
        let min = (time % 3600) / 60;
        let sec = time % 60;

        let mut h_out   = ((hours + 2) % 24).to_string();
        let mut min_out = min.to_string();
        let mut sec_out = sec.to_string();

        if h_out.len() == 1{h_out = "0".to_string() + &h_out}
        if min   < 10{min_out = "0".to_string() + &min_out}
        if sec   < 10{sec_out = "0".to_string() + &sec_out}

        return Some(Event::TimeUpdate(format!("{}:{}:{}", h_out, min_out ,sec_out)));
}

pub fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

pub fn get_mem_event() -> Option<Event>
{
    let mut mem_info :[f64;3] = [0.0; 3];
    if let Ok(info) = read_lines("/proc/meminfo")
    {
    let mut i = 0; 
    for info_split in info
    {
        if let Ok(ip) = info_split 
        {
            match ip.chars().next()
            { 
                Some('B') => 
                {
                    break;
                },
                Some(_) => 
                {
                    let mut ipc = ip.chars();
                    for _ in 0..3 {
                        ipc.next_back();
                    }
                    match ipc.as_str().split(" ").last()
                    {
                        Some(mem) => mem_info[i] = FromStr::from_str(mem).expect("memory cant be read corectly"),
                        None => println!("memory cant be read")
                    }
                },
                None => (),
            }
        }
        i += 1;
    }
    } else { return None }
    let perc_mem_used :f64= (1.0-(mem_info[2]/mem_info[0]))*100.0;
    let perc_used_str = format!("{}", perc_mem_used.round());

    return Some(Event::RamUpdate((perc_mem_used, perc_used_str)));
}

const T_ASCI :u8 = 116;
pub fn get_vol_event() -> Option<Event>
{
    
    let mute = &Command::new("pamixer").arg("--get-mute")
        .output()
        .expect("need pamixer") 
        .stdout[0] == &T_ASCI;
    if mute 
    { 
        return Some(Event::VolUpdate(None)); 
    }         
    let mut level =  std::str::from_utf8(&Command::new("pamixer").arg("--get-volume").output()
            .expect("no date command").stdout)
            .expect("not date").to_string();
    level.pop().unwrap();
    let sound_level :f64 = level.parse().expect("can't be cast to float");
    return Some(Event::VolUpdate(Some((sound_level, level))));
}
