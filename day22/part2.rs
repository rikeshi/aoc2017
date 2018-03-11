use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;
use std::collections::VecDeque;

#[derive(Debug)]
enum State {
    Clean,
    Weakened,
    Infected,
    Flagged
}

#[derive(Debug)]
enum Side {
    Front,
    Back
}

#[derive(Debug)]
enum Direction {
    Left,
    Right,
    Up,
    Down
}

#[derive(Debug)]
struct Cluster {
    grid: VecDeque<VecDeque<State>>
}

impl Cluster {
    fn new() -> Cluster {
        Cluster { grid: VecDeque::new() }
    }

    fn load(&mut self, fname: &str) {
        let f = File::open(fname).expect("no such file");
        for line in BufReader::new(f).lines().map(|l| l.unwrap()) {
            let mut row = VecDeque::new();
            for ch in line.chars() {
                row.push_back(match ch {
                    '.' => State::Clean,
                    '#' => State::Infected,
                    _ => panic!("invalid char: {}", ch)
                });
            }
            self.grid.push_back(row);
        }
    }

    fn add_row(&mut self, side: Side) {
        let mut new = VecDeque::with_capacity(self.grid[0].len());
        for _i in 0..self.grid[0].len() {
            new.push_front(State::Clean);
        }
        match side {
            Side::Front => self.grid.push_front(new),
            Side::Back => self.grid.push_back(new)
        };
    }

    fn add_column(&mut self, side: Side) {
        match side {
            Side::Front => {
                for i in 0..self.grid.len() {
                    self.grid[i].push_front(State::Clean);
                }
            },
            Side::Back => {
                for i in 0..self.grid.len() {
                    self.grid[i].push_back(State::Clean);
                }
            }
        };
    }

    fn get(&mut self, x: i64, y: i64) -> &mut State {
        // add row if out of bounds
        if y < 0 {
            self.add_row(Side::Front);
        } else if y as usize >= self.grid.len() {
            self.add_row(Side::Back);
        }

        // add column if out of bounds
        if x < 0 {
            self.add_column(Side::Front) }
        else if x as usize >= self.grid[0].len() {
            self.add_column(Side::Back)
        }

        // get the row
        let row = if y < 0 {
            &mut self.grid[0]
        } else {
            &mut self.grid[y as usize]
        };

        // return the node's value
        if x < 0 { &mut row[0] } else { &mut row[x as usize] }
    }
}

#[derive(Debug)]
struct Virus {
    x: i64,
    y: i64,
    d: Direction
}

impl Virus {
    fn new(x: i64, y: i64, d: Direction) -> Virus {
        Virus { x: x, y: y, d: d }
    }

    fn turn_left(&mut self) {
        match self.d {
            Direction::Left => self.d = Direction::Down,
            Direction::Right => self.d = Direction::Up,
            Direction::Up => self.d = Direction::Left,
            Direction::Down => self.d = Direction::Right
        };
    }

    fn turn_right(&mut self) {
        match self.d {
            Direction::Left => self.d = Direction::Up,
            Direction::Right => self.d = Direction::Down,
            Direction::Up => self.d = Direction::Right,
            Direction::Down => self.d = Direction::Left
        };
    }

    fn turn_around(&mut self) {
        match self.d {
            Direction::Left => self.d = Direction::Right,
            Direction::Right => self.d = Direction::Left,
            Direction::Up => self.d = Direction::Down,
            Direction::Down => self.d = Direction::Up
        };
    }

    fn move_forward(&mut self) {
        // reset to index 0 after push_front
        if      self.x < 0 { self.x = 0 }
        else if self.y < 0 { self.y = 0 }
        match self.d {
            Direction::Left => self.x -= 1,
            Direction::Right => self.x += 1,
            Direction::Up => self.y -= 1,
            Direction::Down => self.y += 1
        };
    }

    fn burst(&mut self, cluster: &mut Cluster) -> usize {
        // get state
        let state = cluster.get(self.x, self.y);

        // turn, change state
        let became_infected = match *state {
            State::Clean => {
                self.turn_left();
                *state = State::Weakened;
                0
            },
            State::Weakened => {
                *state = State::Infected;
                1
            },
            State::Infected => {
                self.turn_right();
                *state = State::Flagged;
                0
            },
            State::Flagged => {
                self.turn_around();
                *state = State::Clean;
                0
            }
        };

        // move forward
        self.move_forward();

        became_infected
    }
}

fn main() {
    let mut cluster = Cluster::new();
    cluster.load("input");

    let center = cluster.grid.len() as i64 / 2;
    let mut virus = Virus::new(center, center, Direction::Up);

    let mut count: usize = 0;
    for _i in 0..10000000 {
        count += virus.burst(&mut cluster);
    }
    println!("{}", count);
}
