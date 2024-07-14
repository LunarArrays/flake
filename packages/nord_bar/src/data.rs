use std::str::FromStr;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::process::Command;
use std::time::{UNIX_EPOCH, SystemTime};

pub enum Sound {
    Level(i32),
    Mute
}

pub fn get_time() -> String
{
    let now = SystemTime::now();
    let time = now.duration_since(UNIX_EPOCH).unwrap().as_secs() % 86400;
    let hours = time / 3600;
    let min = (time - hours * 3600) / 60;
    let sec = time - (hours * 3600 + min * 60);

    let mut h_out   = ((hours + 2) % 24).to_string();
    let mut min_out = min.to_string();
    let mut sec_out = sec.to_string();

    if h_out.len() == 1{h_out = "0".to_string() + &h_out}
    if min   < 10{min_out = "0".to_string() + &min_out}
    if sec   < 10{sec_out = "0".to_string() + &sec_out}

    format!("{}:{}:{}", h_out, min_out ,sec_out)
}

pub fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

pub fn get_mem() -> [f64; 3]
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
    }
    mem_info
}

const T_ASCI :u8 = 116;
pub fn get_audio() -> Sound
{
    let mute = &Command::new("pamixer").arg("--get-mute")
        .output()
        .expect("can't find pamixer (maybe your fault)")
        .stdout[0] == &T_ASCI;
    if mute 
    { 
        return Sound::Mute; 
    }         
    let mut level =  std::str::from_utf8(&Command::new("pamixer").arg("--get-volume").output()
            .expect("no date command").stdout)
            .expect("not date").to_string();
    level.pop().unwrap();
    let sound_level = level.parse().expect("volume is not a u8 (how ????)");
    return Sound::Level(sound_level);
}
