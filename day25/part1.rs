use std::collections::HashMap;
use std::collections::VecDeque;

struct State {
    value: [u32; 2],
    direction: [i32; 2],
    next: [char; 2]
}

struct TuringMachine {
    tape: VecDeque<u32>,
    cursor: i64,
    states: HashMap<char, State>,
    state: char
}

impl TuringMachine {
    fn step(&mut self) {
        if self.cursor < 0 {
            self.tape.push_front(0);
            self.cursor = 0;
        } else if self.cursor as usize >= self.tape.len() {
            self.tape.push_back(0);
        }
        let val = self.tape[self.cursor as usize] as usize;
        let state = self.states.get(&self.state).unwrap();
        self.tape[self.cursor as usize] = state.value[val];
        self.cursor += state.direction[val] as i64;
        self.state = state.next[val];
    }
}

fn main() {
    let mut machine = TuringMachine {
        tape: VecDeque::new(),
        cursor: 0,
        states: HashMap::new(),
        state: 'A' };
    machine.states.insert('A', State { value: [1, 0], direction: [ 1, 1], next: ['B', 'C'] });
    machine.states.insert('B', State { value: [0, 0], direction: [-1, 1], next: ['A', 'D'] });
    machine.states.insert('C', State { value: [1, 1], direction: [ 1, 1], next: ['D', 'A'] });
    machine.states.insert('D', State { value: [1, 0], direction: [-1,-1], next: ['E', 'D'] });
    machine.states.insert('E', State { value: [1, 1], direction: [ 1,-1], next: ['F', 'B'] });
    machine.states.insert('F', State { value: [1, 1], direction: [ 1, 1], next: ['A', 'E'] });
    for _i in 0..12368930 { machine.step(); }
    println!("{}", machine.tape.into_iter().sum::<u32>());
}
