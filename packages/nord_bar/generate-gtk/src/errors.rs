use proc_macro::TokenStream;

pub enum MarcroErrors {
    InternalParsingStateError(usize), //usize used as id
    ParsingStateError(String, String),
    ObjDeepthError(usize), //usize used for diffrent types or errors 
}

pub type MacroResult = Result<TokenStream, MarcroErrors>;
