use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;


fn read_lines(fname: &str) -> Vec<String> {
    let f = File::open(fname).expect("no such file");
    let mut lines: Vec<String> = Vec::new();
    for line in BufReader::new(f).lines().map(|l| l.unwrap()) {
        lines.push(line);
    }
    lines
}

fn main() {
    let mut result: i64 = 0;
    let mut sound: i64 = 0;
    // lines must be allocated before regs
    // because regs will contain references to lines as keys.
    // deallocation happens in reverse order,
    // so if lines is declared after regs it will be deallocated first
    // and leave regs with invalid references
    let lines = read_lines("input");
    let mut regs: Vec<(&str, i64)> = Vec::new();
    let mut pc: i64 = 0;

    loop {
        if pc < 0 || pc as usize >= lines.len() { break; }
        let line = &lines[pc as usize];

        let inst = &line[..3];
        let arg1 = &line[4..5];
        let arg2 = if line.len() > 5 { &line[6..] } else { "" };

        if arg2.is_empty() {
            // instructions with one arg
            let optx = arg1.parse::<i64>();
            let x = match optx {
                Ok(x) => x,
                _ => match regs.binary_search_by_key(&arg1, |&(k, _v)| k) {
                    Ok(i) => regs[i].1,
                    _ => { panic!("accessing undefined register") }
                }
            };
            match inst {
                "snd" => sound = x,
                "rcv" => if x != 0 { result = sound; break },
                _ => panic!("invalid instruction")
            };
        } else {
            // instructions with 2 args
            let optx = arg1.parse::<i64>();
            let opty = arg2.parse::<i64>();
            let x = match optx {
                Ok(x) => x,
                _ => match regs.binary_search_by_key(&arg1, |&(k, _v)| k) {
                    Ok(i) => i as i64,
                    Err(i) => {
                        regs.insert(i, (arg1, 0));
                        i as i64
                    }
                }
            };
            let y = match opty {
                Ok(y) => y,
                _ => match regs.binary_search_by_key(&arg2, |&(k, _v)| k) {
                    Ok(i) => regs[i as usize].1,
                    _ => { panic!("accessing undefined register") }
                }
            };
            match inst {
                "set" => regs[x as usize].1 = y,
                "add" => regs[x as usize].1 += y,
                "mul" => regs[x as usize].1 *= y,
                "mod" => regs[x as usize].1 %= y,
                "jgz" => {
                    let x = match optx {
                        Ok(x) => x,
                        _ => regs[x as usize].1
                    };
                    if x > 0 { pc += y; continue }
                }
                _ => panic!("invalid instruction")
            };
        }
        pc += 1;
    }

    println!("{}", result);
}

