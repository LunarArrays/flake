mod info;
use rand::{random, Rng};

struct Quote 
{
    first_line :&'static str,
    second_line :&'static str,
}

fn main() {

    let os = info::format_len(info::get_os());
    let cpu = info::format_len(info::get_proc_name());
    let ram = info::format_len(info::get_mem());
    let storage = info::format_len(info::get_root_usage());
    let wm = info::format_len(info::get_wm());
    let quote = get_random_quote();

    println!(
"╭────────────────────╮ ╭───────────────────────────────────────────────────────────╮
│{}│ │Linux         >       {}│
│{}│ │Cpu           >       {}│
╰────────────────────╯ │Ram           >       {}│
      V ╱|、           │Storage       >       {}│
       (ﾟ､ 。7         │WM            >       {}│
        |、˜〵         │              \x1b[30m\x1b[0m    \x1b[31m\x1b[0m    \x1b[32m\x1b[0m    \x1b[33m\x1b[0m    \x1b[34m\x1b[0m    \x1b[35m\x1b[0m    \x1b[36m\x1b[0m              │
        U U c )ノ      ╰───────────────────────────────────────────────────────────╯", quote.first_line, os, quote.second_line, cpu, ram, storage, wm);

    /*
       へ      ♡   ╱|、
    ૮  -  ՛ )     (`   -7
     / ⁻  ៸|       |、⁻〵
 乀 (ˍ, ل ل        じしˍ,)ノ
    */
}

fn get_random_quote() -> Quote
{
    match rand::thread_rng().gen_range(0..7)
    {
        1 => Quote {first_line :"    G A T Z E N     ", second_line :"      sind toll     "},
        2 => Quote {first_line :"       ello         ", second_line :"                    "},
        3 => Quote {first_line :"    I am the one    ", second_line :"     who knocks     "},
        4 => Quote {first_line :"    fear is the     ", second_line :"     mind killer    "},
        5 => Quote {first_line :"       be gay       ", second_line :"      do crime      "},
        6 => Quote {first_line :"   don't you have   ", second_line :"anything else to do?"},
        7 => Quote {first_line :"      you can       ", second_line :"      do this       "},
        _ => Quote {first_line :"      miauuuu       ", second_line :"                    "},
    };
    Quote {first_line :"        fck         ", second_line :"        Afd         "}
}
