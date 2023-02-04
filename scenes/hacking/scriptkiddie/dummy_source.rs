#[doc = include_str!("panic.md")]
#[macro_export]
#[rustc_builtin_macro(core_panic)]
#[allow_internal_unstable(edition_panic)]
#[stable(feature = "core", since = "1.6.0")]
#[rustc_diagnostic_item = "core_panic_macro"]
macro_rules! panic {
    // Expands to either `$crate::panic::panic_2015` or `$crate::panic::panic_2021`
    // depending on the edition of the caller.
    ($($arg:tt)*) => {
        /* compiler built-in */
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "assert_eq_macro")]
#[allow_internal_unstable(core_panic)]
macro_rules! assert_eq {
    ($left:expr, $right:expr $(,)?) => {
        match (&$left, &$right) {
            (left_val, right_val) => {
                if !(*left_val == *right_val) {
                    let kind = $crate::panicking::AssertKind::Eq;
                    // The reborrows below are intentional. Without them, the stack slot for the
                    // borrow is initialized even before the values are compared, leading to a
                    // noticeable slow down.
                    $crate::panicking::assert_failed(kind, &*left_val, &*right_val, $crate::option::Option::None);
                }
            }
        }
    };
    ($left:expr, $right:expr, $($arg:tt)+) => {
        match (&$left, &$right) {
            (left_val, right_val) => {
                if !(*left_val == *right_val) {
                    let kind = $crate::panicking::AssertKind::Eq;
                    // The reborrows below are intentional. Without them, the stack slot for the
                    // borrow is initialized even before the values are compared, leading to a
                    // noticeable slow down.
                    $crate::panicking::assert_failed(kind, &*left_val, &*right_val, $crate::option::Option::Some($crate::format_args!($($arg)+)));
                }
            }
        }
    };
}

#[macro_export]
#[stable(feature = "assert_ne", since = "1.13.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "assert_ne_macro")]
#[allow_internal_unstable(core_panic)]
macro_rules! assert_ne {
    ($left:expr, $right:expr $(,)?) => {
        match (&$left, &$right) {
            (left_val, right_val) => {
                if *left_val == *right_val {
                    let kind = $crate::panicking::AssertKind::Ne;
                    // The reborrows below are intentional. Without them, the stack slot for the
                    // borrow is initialized even before the values are compared, leading to a
                    // noticeable slow down.
                    $crate::panicking::assert_failed(kind, &*left_val, &*right_val, $crate::option::Option::None);
                }
            }
        }
    };
    ($left:expr, $right:expr, $($arg:tt)+) => {
        match (&($left), &($right)) {
            (left_val, right_val) => {
                if *left_val == *right_val {
                    let kind = $crate::panicking::AssertKind::Ne;
                    // The reborrows below are intentional. Without them, the stack slot for the
                    // borrow is initialized even before the values are compared, leading to a
                    // noticeable slow down.
                    $crate::panicking::assert_failed(kind, &*left_val, &*right_val, $crate::option::Option::Some($crate::format_args!($($arg)+)));
                }
            }
        }
    };
}

#[unstable(feature = "assert_matches", issue = "82775")]
#[allow_internal_unstable(core_panic)]
#[rustc_macro_transparency = "semitransparent"]
pub macro assert_matches {
    ($left:expr, $(|)? $( $pattern:pat_param )|+ $( if $guard: expr )? $(,)?) => {
        match $left {
            $( $pattern )|+ $( if $guard )? => {}
            ref left_val => {
                $crate::panicking::assert_matches_failed(
                    left_val,
                    $crate::stringify!($($pattern)|+ $(if $guard)?),
                    $crate::option::Option::None
                );
            }
        }
    },
    ($left:expr, $(|)? $( $pattern:pat_param )|+ $( if $guard: expr )?, $($arg:tt)+) => {
        match $left {
            $( $pattern )|+ $( if $guard )? => {}
            ref left_val => {
                $crate::panicking::assert_matches_failed(
                    left_val,
                    $crate::stringify!($($pattern)|+ $(if $guard)?),
                    $crate::option::Option::Some($crate::format_args!($($arg)+))
                );
            }
        }
    },
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[rustc_diagnostic_item = "debug_assert_macro"]
#[allow_internal_unstable(edition_panic)]
macro_rules! debug_assert {
    ($($arg:tt)*) => {
        if $crate::cfg!(debug_assertions) {
            $crate::assert!($($arg)*);
        }
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "debug_assert_eq_macro")]
macro_rules! debug_assert_eq {
    ($($arg:tt)*) => {
        if $crate::cfg!(debug_assertions) {
            $crate::assert_eq!($($arg)*);
        }
    };
}

#[macro_export]
#[stable(feature = "assert_ne", since = "1.13.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "debug_assert_ne_macro")]
macro_rules! debug_assert_ne {
    ($($arg:tt)*) => {
        if $crate::cfg!(debug_assertions) {
            $crate::assert_ne!($($arg)*);
        }
    };
}

#[macro_export]
#[unstable(feature = "assert_matches", issue = "82775")]
#[allow_internal_unstable(assert_matches)]
#[rustc_macro_transparency = "semitransparent"]
pub macro debug_assert_matches($($arg:tt)*) {
    if $crate::cfg!(debug_assertions) {
        $crate::assert_matches::assert_matches!($($arg)*);
    }
}

#[macro_export]
#[stable(feature = "matches_macro", since = "1.42.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "matches_macro")]
macro_rules! matches {
    ($expression:expr, $(|)? $( $pattern:pat_param )|+ $( if $guard: expr )? $(,)?) => {
        match $expression {
            $( $pattern )|+ $( if $guard )? => true,
            _ => false
        }
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[deprecated(since = "1.39.0", note = "use the `?` operator instead")]
#[doc(alias = "?")]
macro_rules! r#try {
    ($expr:expr $(,)?) => {
        match $expr {
            $crate::result::Result::Ok(val) => val,
            $crate::result::Result::Err(err) => {
                return $crate::result::Result::Err($crate::convert::From::from(err));
            }
        }
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "write_macro")]
macro_rules! write {
    ($dst:expr, $($arg:tt)*) => {
        $dst.write_fmt($crate::format_args!($($arg)*))
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "writeln_macro")]
#[allow_internal_unstable(format_args_nl)]
macro_rules! writeln {
    ($dst:expr $(,)?) => {
        $crate::write!($dst, "\n")
    };
    ($dst:expr, $($arg:tt)*) => {
        $dst.write_fmt($crate::format_args_nl!($($arg)*))
    };
}

#[macro_export]
#[rustc_builtin_macro(unreachable)]
#[allow_internal_unstable(edition_panic)]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "unreachable_macro")]
macro_rules! unreachable {
    // Expands to either `$crate::panic::unreachable_2015` or `$crate::panic::unreachable_2021`
    // depending on the edition of the caller.
    ($($arg:tt)*) => {
        /* compiler built-in */
    };
}

#[macro_export]
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "unimplemented_macro")]
#[allow_internal_unstable(core_panic)]
macro_rules! unimplemented {
    () => {
        $crate::panicking::panic("not implemented")
    };
    ($($arg:tt)+) => {
        $crate::panic!("not implemented: {}", $crate::format_args!($($arg)+))
    };
}

#[macro_export]
#[stable(feature = "todo_macro", since = "1.40.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "todo_macro")]
#[allow_internal_unstable(core_panic)]
macro_rules! todo {
    () => {
        $crate::panicking::panic("not yet implemented")
    };
    ($($arg:tt)+) => {
        $crate::panic!("not yet implemented: {}", $crate::format_args!($($arg)+))
    };
}

pub(crate) mod builtin {

    #[stable(feature = "compile_error_macro", since = "1.20.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! compile_error {
        ($msg:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[cfg_attr(not(test), rustc_diagnostic_item = "format_args_macro")]
    #[allow_internal_unsafe]
    #[allow_internal_unstable(fmt_internals)]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! format_args {
        ($fmt:expr) => {{ /* compiler built-in */ }};
        ($fmt:expr, $($args:tt)*) => {{ /* compiler built-in */ }};
    }

    #[unstable(feature = "const_format_args", issue = "none")]
    #[allow_internal_unstable(fmt_internals, const_fmt_arguments_new)]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! const_format_args {
        ($fmt:expr) => {{ /* compiler built-in */ }};
        ($fmt:expr, $($args:tt)*) => {{ /* compiler built-in */ }};
    }

    #[unstable(
        feature = "format_args_nl",
        issue = "none",
        reason = "`format_args_nl` is only for internal \
                  language use and is subject to change"
    )]
    #[allow_internal_unstable(fmt_internals)]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! format_args_nl {
        ($fmt:expr) => {{ /* compiler built-in */ }};
        ($fmt:expr, $($args:tt)*) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! env {
        ($name:expr $(,)?) => {{ /* compiler built-in */ }};
        ($name:expr, $error_msg:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! option_env {
        ($name:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[unstable(
        feature = "concat_idents",
        issue = "29599",
        reason = "`concat_idents` is not stable enough for use and is subject to change"
    )]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! concat_idents {
        ($($e:ident),+ $(,)?) => {{ /* compiler built-in */ }};
    }

    #[unstable(feature = "concat_bytes", issue = "87555")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! concat_bytes {
        ($($e:literal),+ $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! concat {
        ($($e:expr),* $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! line {
        () => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! column {
        () => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! file {
        () => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! stringify {
        ($($t:tt)*) => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    #[cfg_attr(not(test), rustc_diagnostic_item = "include_str_macro")]
    macro_rules! include_str {
        ($file:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    #[cfg_attr(not(test), rustc_diagnostic_item = "include_bytes_macro")]
    macro_rules! include_bytes {
        ($file:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! module_path {
        () => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! cfg {
        ($($cfg:tt)*) => {
            /* compiler built-in */
        };
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! include {
        ($file:expr $(,)?) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    #[macro_export]
    #[rustc_diagnostic_item = "assert_macro"]
    #[allow_internal_unstable(core_panic, edition_panic)]
    macro_rules! assert {
        ($cond:expr $(,)?) => {{ /* compiler built-in */ }};
        ($cond:expr, $($arg:tt)+) => {{ /* compiler built-in */ }};
    }

    #[unstable(
        feature = "log_syntax",
        issue = "29598",
        reason = "`log_syntax!` is not stable enough for use and is subject to change"
    )]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! log_syntax {
        ($($arg:tt)*) => {
            /* compiler built-in */
        };
    }

    #[unstable(
        feature = "trace_macros",
        issue = "29598",
        reason = "`trace_macros` is not stable enough for use and is subject to change"
    )]
    #[rustc_builtin_macro]
    #[macro_export]
    macro_rules! trace_macros {
        (true) => {{ /* compiler built-in */ }};
        (false) => {{ /* compiler built-in */ }};
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[rustc_builtin_macro]
    pub macro derive($item:item) {
        /* compiler built-in */
    }

    #[unstable(feature = "derive_const", issue = "none")]
    #[rustc_builtin_macro]
    pub macro derive_const($item:item) {
        /* compiler built-in */
    }

    #[stable(feature = "rust1", since = "1.0.0")]
    #[allow_internal_unstable(test, rustc_attrs)]
    #[rustc_builtin_macro]
    pub macro test($item:item) {
        /* compiler built-in */
    }

    #[unstable(
        feature = "test",
        issue = "50297",
        soft,
        reason = "`bench` is a part of custom test frameworks which are unstable"
    )]
    #[allow_internal_unstable(test, rustc_attrs)]
    #[rustc_builtin_macro]
    pub macro bench($item:item) {
        /* compiler built-in */
    }

    #[unstable(
        feature = "custom_test_frameworks",
        issue = "50297",
        reason = "custom test frameworks are an unstable feature"
    )]
    #[allow_internal_unstable(test, rustc_attrs)]
    #[rustc_builtin_macro]
    pub macro test_case($item:item) {
        /* compiler built-in */
    }

    #[stable(feature = "global_allocator", since = "1.28.0")]
    #[allow_internal_unstable(rustc_attrs)]
    #[rustc_builtin_macro]
    pub macro global_allocator($item:item) {
        /* compiler built-in */
    }

    #[unstable(feature = "alloc_error_handler", issue = "51540")]
    #[allow_internal_unstable(rustc_attrs)]
    #[rustc_builtin_macro]
    pub macro alloc_error_handler($item:item) {
        /* compiler built-in */
    }

    #[unstable(
        feature = "cfg_accessible",
        issue = "64797",
        reason = "`cfg_accessible` is not fully implemented"
    )]
    #[rustc_builtin_macro]
    pub macro cfg_accessible($item:item) {
        /* compiler built-in */
    }

    #[unstable(
        feature = "cfg_eval",
        issue = "82679",
        reason = "`cfg_eval` is a recently implemented feature"
    )]
    #[rustc_builtin_macro]
    pub macro cfg_eval($($tt:tt)*) {
        /* compiler built-in */
    }

    #[rustc_builtin_macro]
    #[unstable(
        feature = "type_ascription",
        issue = "23416",
        reason = "placeholder syntax for type ascription"
    )]
    pub macro type_ascribe($expr:expr, $ty:ty) {
        /* compiler built-in */
    }

    #[rustc_builtin_macro]
    #[stable(feature = "rust1", since = "1.0.0")]
    #[allow_internal_unstable(core_intrinsics, libstd_sys_internals, rt)]
    #[deprecated(since = "1.52.0", note = "rustc-serialize is deprecated and no longer supported")]
    #[doc(hidden)] // While technically stable, using it is unstable, and deprecated. Hide it.
    pub macro RustcDecodable($item:item) {
        /* compiler built-in */
    }

    #[rustc_builtin_macro]
    #[stable(feature = "rust1", since = "1.0.0")]
    #[allow_internal_unstable(core_intrinsics, rt)]
    #[deprecated(since = "1.52.0", note = "rustc-serialize is deprecated and no longer supported")]
    #[doc(hidden)] // While technically stable, using it is unstable, and deprecated. Hide it.
    pub macro RustcEncodable($item:item) {
        /* compiler built-in */
    }
}

