extern crate proc_macro;
use proc_macro::{Ident, TokenStream, TokenTree};

mod parsingstate;
use parsingstate::*;

mod errors;
use errors::MacroResult;

#[proc_macro]
pub fn gtk(info: TokenStream) -> TokenStream 
{
    let mut state    = ParsingState::InitInfo;

    let mut var_name :Option<Ident> = None;

    let mut depth    = 0;
    let mut obj_name :Option<Ident> = None;
    let mut obj_type :Option<Ident> = None;

    let mut obj_stack :Vec<Ident> = Vec::new();

    let mut out = "".to_string();

    for tt in info.into_iter()
    {
        state = next_state(&state, &tt);
        let mut err = None; 
        match state {

            ParsingState::DeepthLevel => depth += 1,

            ParsingState::ObjName => 
                obj_name = match &tt 
                {
                    TokenTree::Ident(name) => Some(name.to_owned()),
                    _ => {err = Some("Parsing state error (1)"); break}
                },

            ParsingState::Type    => 
                obj_type = match &tt 
                {
                    TokenTree::Ident(in_obj_type) => Some(in_obj_type.to_owned()), 
                    _ => {err = Some("Parsing state error (2)"); break}
                },

            ParsingState::VarName => 
                var_name = match &tt 
                {
                    TokenTree::Ident(name) => Some(name.to_owned()), 
                    _ => {err = Some("Parsing state error (3)"); break}
                },

            ParsingState::InitInfo => {
                let obj_init = match &tt {
                    TokenTree::Group(init) => {init.to_owned()},
                    _ => {out = r#"compile_error!("Parsing state error (4)")"#.to_owned(); break},
                };
                let out_name;
                let out_type;

                match obj_name.as_ref() {Some(name) => out_name = name, 
                    None => {err = Some("reached end of obj without name"); break }}
                match obj_type.as_ref() {Some(o_type) => out_type = o_type, 
                    None => {err = Some("reached end of obj without type"); break }}

                let temp_out = format!("let {} = gtk4::{}::new{};\n"
                    ,out_name
                    ,out_type
                    ,obj_init.to_string());
                out.push_str(&temp_out);

                handle_obj_deepth(&mut obj_stack,&mut out, depth, out_name.clone());
                depth = 0;

                obj_name = None;
                obj_type = None;
            },

            ParsingState::Value => {
                let var_val = match &tt {
                    TokenTree::Group(val) => val,
                    _ => panic!("Pasring state error (5)")
                };
                let temp_out :String;
                if var_name.as_ref().expect("reached end of var without name").to_string() == "active"
                {
                temp_out = format!("{}.{}{};\n"
                    ,obj_stack.last().expect("Value given without any obj to appened to")
                    ,var_name.expect("reached end of var without name (err reached with magic)")
                    ,var_val.to_string());
                } else {
                temp_out = format!("{}.set_{}{};\n"
                    ,obj_stack.last().expect("Value given without any obj to appened to")
                    ,var_name.expect("reached end of var without name (err reached with magic)")
                    ,var_val.to_string());
                }
                out.push_str(&temp_out);
                var_name = None;
            },
            _ => {}
        }
    }
    match state {
      ParsingState::Value | ParsingState::InitInfo => (),
      ParsingState::DeepthLevel  => {let err = Some("expected '-' or obj name got end of marco");},
      ParsingState::ObjName => {let err = Some("expected ':' got end of token stream");},
      _ => {
        panic!("macro finished unexpectedly");
      },
    }

    return out.parse::<TokenStream>().unwrap();
}

fn gen_macro(ts :TokenStream) -> MacroResult
{
    Ok(TokenStream::new())
}




fn handle_obj_deepth(obj_stack :&mut Vec<Ident>, out :&mut String, depth :usize, obj_name :Ident) -> MacroResult
{
    if depth > 1
    {
        out.push_str(&format!("{}.append(&{});\n"
            ,obj_stack[depth - 2].to_string()
            ,obj_name));
    }
    let stack_len = obj_stack.len();

    if depth == 0 {panic!("reached end of obj eval without any deepth")}
    else if depth > stack_len + 1 {panic!("deepth increased to quick")}
    else if depth == stack_len + 1 
    {
        obj_stack.push(obj_name);
    }
    else if depth == stack_len
    {
        obj_stack.pop();
        obj_stack.push(obj_name);
    }
    else
    {
        let mut to_sub_len = (stack_len - depth) + 1;
        while to_sub_len != 0
    {
        obj_stack.pop();
        to_sub_len -= 1;
    }
        obj_stack.push(obj_name)        
    }
    Ok(TokenStream::new())
}
