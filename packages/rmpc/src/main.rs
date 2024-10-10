use crossterm::{
    event::Event, terminal, ExecutableCommand 
};
use std::fmt::Result;
use std::process::exit;
use std::thread;
use std::env;
use std::io;
use std::time;

use std::net::TcpStream;
use std::io::prelude::*;

use std::fs;

use mpd;


use crossterm::event::{read, KeyCode};


fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect(); 

    let mut conn = mpd::Client::connect("127.0.0.1:6600").unwrap();
    let mut tui = false;
    match args[1].as_str()
    {
        "volume" | "v" =>{
            match args[2].parse::<i8>()
            {
                Ok(num) => { conn.volume(num).unwrap()},
                Err(_) => {println!("volume is NaN")}
            }
        },
        "pause" | "s" => {conn.pause(true).unwrap();},
        "play"  | "p" => {conn.play().unwrap();},
        "clear" | "c" => {conn.clear().unwrap();},
        "get"   | "g" => {let song = conn.currentsong().expect("").expect(""); 
            println!("{}\n{}\n{}\n{}\n{}\n{}", 
                ( if conn.status().unwrap().state == mpd::status::State::Play
                    {"playing"} else 
                    {"paused"}
                ),
                song.title.unwrap_or("untitled".to_string()), 
                song.duration.unwrap().as_secs(), 
                conn.status().unwrap().time.unwrap().0.as_secs(),
                song.artist.unwrap_or("".to_string()),
                song.tags[1].1
                ); 
        },
        "active" => {
            if conn.status().unwrap().state == mpd::status::State::Play
            {println!("true");} else {println!("false");}
            },
        "next" | "+" => {conn.next().unwrap();},
        "prev" | "-"=> {conn.prev().unwrap();},
        "playlist" | "pl" => {
            let playlists = conn.playlists().unwrap();
            let out = playlists.into_iter()
                .map(|x| x.name)
                .collect::<Vec<String>>()
                .join("\n");
            println!("{}", out);
        },
        "queue" | "q" => 'queue: {
            if &args.len() < &3
            { list_current_pl(&mut conn); break 'queue;}
            let pre_name = &args[2];
            let name :String; 
            if pre_name.starts_with("\"")
            { 
               let mut chars = pre_name.chars();
               chars.next();
               chars.next_back();
               name =chars.as_str().to_owned();
            } else {
                name = pre_name.clone();
            }
            println!("{}", name);
            let mut pl_found = false;
            for playlist in conn.playlists().unwrap_or(Vec::new())
            {
                if playlist.name == name
                {pl_found = true;}
            }
            if pl_found
            {
                conn.load(name, ..).unwrap();
            } else {
                let mut query = mpd::Query::new();
                query.and(mpd::Term::Tag(std::borrow::Cow::Borrowed("title")), name);
                if conn.find(&query, (0, 1)).unwrap().len() == 0 {println!("no song or PL with name found");}
                let _ = conn.findadd(&query);
            }
        },
        "file" => { println!("{}", conn.currentsong().unwrap().unwrap().file); }
        "tui" => tui = true,
        _ => (),
    };

    if !tui 
    {
        return Ok(());
    }
    let mut stdout = io::stdout();

    stdout.execute(terminal::Clear(terminal::ClearType::All))?;
    stdout.execute(terminal::EnterAlternateScreen)?;
    terminal::enable_raw_mode()?;

    let mut volume = 50;
    let mut is_paused = false;

    conn.play().unwrap();
loop{
    match read()? {
        Event::Key(key) => 
        {
            let key_code = key.code;
            match key_code {
                KeyCode::Char('+') => {if volume != 100 {volume += 1; conn.volume(volume).unwrap()}},
                KeyCode::Char('-') => {if volume != 0 {volume -= 1; conn.volume(volume).unwrap()}},
                KeyCode::Char('p') => {is_paused = !is_paused; conn.pause(is_paused).unwrap();},
                KeyCode::Char('q') => {return Ok(());},
                _ => {},
                }
            }
            _ => {},
        }
    thread::sleep(time::Duration::from_millis(10));
    }
}

fn list_current_pl(conn :&mut mpd::Client)
{
    let current_playlist = conn.queue().unwrap();
    let out = current_playlist.into_iter()
        .map(|x| x.title.unwrap())
        .collect::<Vec<String>>()
        .join("\n");
    println!("{}", out);
}

fn test_tcp(args :&str) -> io::Result<String> 
{
    let mut stream = TcpStream::connect("127.0.0.1:6600")?;
    let mut buf = vec![0u8; 8192];
    stream.write_all(b"albumart /home/user/music/voxel_winds.mp3 0\n")?;
    println!("hi1");
    let n = stream.read(&mut buf)?;
    let n = stream.read(&mut buf)?;
    println!("hi2");
    Ok(String::from_utf8(buf).unwrap())
}
