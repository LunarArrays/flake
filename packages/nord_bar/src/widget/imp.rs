use std::cell::Cell;
use std::cell::RefCell;
use std::sync::OnceLock;

use glib::subclass::Signal;
use glib::Properties;
use gtk4::glib;
use gtk4::prelude::*;
use gtk4::subclass::prelude::*;

// Object holding the state
#[derive(Properties, Default)]
#[properties(wrapper_type = super::CustomButton)]
pub struct CustomButton {
    #[property(get, set)]
    info: RefCell<String>,
}

// The central trait for subclassing a GObject
#[glib::object_subclass]
impl ObjectSubclass for CustomButton {
    const NAME: &'static str = "infoButton";
    type Type = super::CustomButton;
    type ParentType = gtk4::Button;
}

#[glib::derived_properties]
impl ObjectImpl for CustomButton {
    fn signals() -> &'static [Signal] {
        static SIGNALS: OnceLock<Vec<Signal>> = OnceLock::new();
        SIGNALS.get_or_init(|| {
            vec![Signal::builder("yay-i-dont-have-to-kms")
                .param_types([i32::static_type()])
                .build()]
        })
    }
    fn constructed(&self) {
        self.parent_constructed();
        let obj = self.obj();
        obj.bind_property("info", obj.as_ref(), "label")
            .sync_create()
            .build();
    }
}
impl WidgetImpl for CustomButton {}
impl ButtonImpl for CustomButton {
    fn clicked(&self) {
        self.obj().emit_by_name::<()>("yay-i-dont-have-to-kms", &[&8.to_value()]);
    }
}
