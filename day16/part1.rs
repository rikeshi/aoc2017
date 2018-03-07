use std::fs::File;
use std::io::BufReader;
use std::io::Read;

fn read_input(fname: &str) -> String {
    let f = File::open(fname).expect("no such file");
    let mut reader = BufReader::new(f);
    let mut contents = String::new();
    reader.read_to_string(&mut contents).expect("read failed");
    contents
}

fn spin(line: u64, mut n: u8) -> u64 {
    n = n << 2;
    line >> n | line << 64 - n
}

fn exchange(mut line: u64, mut i: u8, mut j: u8) -> u64 {
    i = 15 - i << 2;
    j = 15 - j << 2;
    let a = line >> i & 0xf;
    let b = line >> j & 0xf;
    line = line & !(0xf << i) & !(0xf << j);
    line | a << j | b << i
}

fn partner(mut line: u64, a: u8, b: u8) -> u64 {
    let mut copy = line;
    let mut i = 0;
    let mut j = 0;
    let mut k = 0;
    let mut found = 0;
    while found != 2 {
        if (copy & 0xf) as u8 ^ a == 0 {
            i = k;
            found += 1;
        } else if (copy & 0xf) as u8 ^ b == 0 {
            j = k;
            found += 1;
        }
        copy >>= 4;
        k += 4;
    }
    line = line & (!(0xf << i) & !(0xf << j));
    line | (a as u64) << j | (b as u64) << i
}

fn main() {
    let input = read_input("input");
    let split = input.split(",");
    let mut line = 0x0123456789abcdef;

    for s in split {
        line = match &s[..1] {
            "s" => {
                let n = s[1..].parse::<u8>().unwrap();
                spin(line, n)
            },
            "x" => {
                let mut split = s[1..].split("/");
                let i = split.next().unwrap().parse::<u8>().unwrap();
                let j = split.next().unwrap().parse::<u8>().unwrap();
                exchange(line, i, j)
            },
            "p" => {
                let mut bytes = s.bytes();
                let a = bytes.nth(1).unwrap() - 97;
                let b = bytes.nth(1).unwrap() - 97;
                partner(line, a, b)
            },
            _ => 0
        };
    }
    let mut res = Vec::new();
    while line > 0 {
        res.push((((line & 0xf)+ 97) as u8) as char);
        line >>= 4;
    }
    println!("{}", res.iter().rev().collect::<String>());
}
