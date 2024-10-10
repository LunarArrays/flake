use proc_macro::TokenTree; 

pub enum ParsingState {
    DeepthLevel,
    ObjName,
    Colon,
    Type,
    InitInfo,

    VarName,
    Value,

}

pub fn next_state(current_state :&ParsingState, tt :&TokenTree) -> ParsingState
{
    match current_state {

        ParsingState::DeepthLevel => match tt {
            TokenTree::Punct(punct) => 
            if punct.to_string() == "-" {return ParsingState::DeepthLevel;}
            else {punct_panic(tt, current_state)}
            TokenTree::Ident(_) => return ParsingState::ObjName,
            _ => panic!("expected either '-' or a obj name (Ident) got: '{}'", tt.to_string()),
        },

        ParsingState::ObjName => match tt {
            TokenTree::Punct(punct) =>
            if punct.to_string() == ":" {return ParsingState::Colon;} 
            else {punct_panic(tt, current_state)}
            _ => panic!("expected ':' got: '{}'", tt.to_string()),
        },

        ParsingState::Colon => match tt {
            TokenTree::Ident(_) => return ParsingState::Type, 
            _ => panic!("expected Obj Type (Ident) got: '{}'", tt.to_string()),
        },

        ParsingState::Type => match tt {
            TokenTree::Group(_) => return ParsingState::InitInfo, 
            _ => panic!("expected init Info for Obj can be () but not '' (Group) got: '{}'", tt.to_string()),
        },

        ParsingState::InitInfo => match tt {
            TokenTree::Punct(punct) => 
            if punct.to_string() == "-" {return ParsingState::DeepthLevel;}
            else {punct_panic(tt, current_state)}
            TokenTree::Ident(_) => return ParsingState::VarName,
            _ => panic!("expected '-' (Punct) or Var name (Ident) but got: '{}'", tt.to_string()),
        },



        ParsingState::VarName => match tt {
            TokenTree::Group(_) => return ParsingState::Value, 
            _ => panic!("expected Value (Group) got: '{}'", tt.to_string()), 
        },

        ParsingState::Value => match tt {
            TokenTree::Punct(punct) => 
            if punct.to_string() == "-" {return ParsingState::DeepthLevel}
            else {punct_panic(tt, current_state)}
            TokenTree::Ident(_) => return ParsingState::VarName,
            _ => panic!("expected '-' (Punct) or Var name (Ident) but got: '{}'", tt.to_string()),
        }
    }
}

fn punct_panic(tt :&TokenTree, ps :&ParsingState) -> ParsingState
{
    let right_punct = match ps {
        ParsingState::VarName     => "=",
        ParsingState::DeepthLevel => "-",
        ParsingState::Value       => "-",
        ParsingState::InitInfo    => "-",
        ParsingState::ObjName     => ":",
        ParsingState::Type        => "( ... )",
        _ => panic!("err while panicing because of wrong punct ")
    };
    panic!("replace '{}' with '{}' or remove it", tt.to_string(), right_punct)
}
