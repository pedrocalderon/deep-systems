fn main() {
    let x = 42;           // Onde fica x?
    let y = Box::new(42); // Onde fica o 42 de y?
    let s = "hello";      // Onde fica "hello"?

    println!("x in stack: {:p}", &x);
    println!("y in heap: {:p}", Box::<_>::as_ptr(&y));
    println!("x in .data: {:p}", &s);

    loop {};
}
