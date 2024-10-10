use std::{collections::HashMap, rc::Weak, sync::{Arc, Mutex}, thread::sleep};

pub mod hypr;
pub mod data;

#[derive(Clone)]
pub enum Event {
    TimeUpdate(String),
    RamUpdate((f64, String)),
    VolUpdate(Option<(f64, String)>),
    ActiveWindowUpdate(String),
    IconUpdate(usize, String),

    TextUpadae(String, Option<String>),
    NumberUpdate(String, Option<i32>)
}


use std::stringify;

macro_rules! timed_send {
    ($sender :tt, $path :path, $time :tt) => {
    let clone_sender = $sender.clone();
   std::thread::spawn(move || {
       loop {
            let evnt = $path().expect(&format!("can't get data from module: {}", stringify!($path)));
            clone_sender.send(evnt);      
            sleep(Duration::from_millis($time));
        }
   }); 
};
}

pub(crate) use timed_send;
