use std::process::Command;
use std::io::{self, BufRead};
use std::path::Path;
use std::fs::File;
use std::env::var_os;

pub fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

pub fn get_proc_name() -> String
{
    if let Ok(info) = read_lines("/proc/cpuinfo")
    {
        let mut iterator = 0;
        for info_split in info
        {
            if iterator == 4 
            {
                if let Ok(cpu_info) = info_split 
                {
                    let out = &cpu_info[13..]; //etting max size so that box dosen't overflow
                    return out.to_string();
                }
            }
            if iterator == 5 {panic!("loop err in grt_proc_name()")};
            iterator += 1;
        }
    }
    return "big err".to_string(); 
}

pub fn get_mem() -> String
{
    let mut mem_info :[f64;3] = [0.0; 3];
    if let Ok(info) = read_lines("/proc/meminfo")
    {
        let mut i = 0; 
        for info_split in info
        {
            if let Ok(ip) = info_split 
            {
                let mut ipc = ip.chars();
                for _ in 0..3 {
                ipc.next_back();
                }
                match ipc.as_str().split(" ").last()
                {
                    Some(mem) => mem_info[i] = mem.parse::<f64>().expect("memory cant be read corectly")/1000000.0,
                    None => println!("memory cant be read")
                }
                if i == 2 {break;}
                i += 1;
            }
        }
    }
    let in_use_mem = mem_info[0] - mem_info[2];
    let perc_mem_used= (1.0-(mem_info[2]/mem_info[0]))*100.0;

    format!("{}/{}GB using {}%"
            ,(in_use_mem).round().to_string()
            ,(mem_info[0]).round().to_string()
            ,(perc_mem_used).round().to_string()
        )
}

pub fn get_root_usage() -> String
{
    let info = std::str::from_utf8(&Command::new("df")
                        .arg("-h")
                        .output().expect("no GNU system (no df)").stdout
    ).expect("output of df is not utf8").to_string();
    let root_line = info
            .split_once("/\n").expect("no root partition").0.chars().rev().collect::<String>()
            .split_once("\n").expect("df dosn't work right").0.chars().rev().collect::<String>();
    let mut iterator = 0;
    let mut total = "";
    for info in root_line.split(" ")
    {
        if iterator == 2 {total = info}
        if iterator == 4 
        {
            return format!("/: {}B/{}B",info,total);
        }
        iterator += 1;
    }
    return "big err".to_string();
}

pub fn get_os() -> String
{
    if let Ok(info) = read_lines("/etc/os-release")
    {
        let mut i = 0; 
        for info_split in info
        {
            if i == 10
            {
                if let Ok(pre_out) = info_split {
                    let mut out = pre_out[13..].to_string();
                    out.pop();
                    return out;
                    }
            }
            i += 1
        }
    }
    return "big err".to_string();
}

pub fn get_wm() -> String
{
    match var_os("XDG_CURRENT_DESKTOP")
    {
        Some(out) => return out.to_str().unwrap().to_string(),
        _ => panic!("not called with XDG_CURRENT_DESKTOP set")
    }
}

pub fn format_len(in_str: String) -> String
{
    let length = in_str.as_bytes().len();
    let mut out_str = in_str; 
    for _ in length..37
    {
        out_str.push(' ')
    }
    out_str 
}



