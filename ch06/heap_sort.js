
function denary(n) {
    let bound;
    if (n < 0) {
        console.error("denary(n): n is positive numbers.");
        return bound;
    }
    else if (n > 1) {
        bound = 10;
        for (n = n/10; n > 1; n = n/10) {
            bound = bound*10;
        }
        return bound;
    } else {
        bound = 1;
        let i = 0;
        do {
            bound = bound/10;
            n = n * 10 % 1;
            i = i + 1;
        } while (n > 0 && i < 4);
        return bound;
    }
}

// return a 0 < x < 1 float
function randomFloat(bound) {
    return Math.random() % bound;
}

// return a x > 0 integer
function randomInt(bound, grand) {
    return Math.floor(Math.random() * grand % bound);
}

function setRandom(v, min, max) {
    let bound = max - min;

    if (bound > 1) {
        let grand = denary(bound);
        for (let i = 1; i < v.length; i = i+1) {
            v[i] = Math.floor(min + randomInt(bound, grand));
        }
    } else if (bound > 0) {
        for (let i = 1; i < v.length; i = i+1) {
            v[i] = min + randomFloat(bound);
        }
    } else {
        console.error("setRandom(v, min, max): the result of [max - min] is positive number");
    }
}

//----------------------------------

function left(i) { return i*2; }
function right(i) { return i*2+1; }
function parent(i) { return Math.floor(i/2); }

function greater(x, y) { return x > y; }
function less(x, y)  { return x < y; }

function exchange(v, i, j) {
    let temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

// if compareF is >, same as heapifyMax
// if compareF is <, same as heapifyMin
function heapify(v, _b, _e, compareF) {
    let l = left(_b);
    let r = right(_b);
    let most = _b;

    if (l <= _e && compareF(v[l], v[_b])) {
        most = l;
    }
    if (r <= _e && compareF(v[r], v[most])) {
        most = r;
    }
    if (most != _b) {
        exchange(v, most, _b);
        heapify(v, most, _e, compareF);
    }
}

// if compareF is >, same as buildMax
// if compareF is <, same as buildMin
function build(v, compareF) {
    let _e = v.length - 1;
    for (let i = parent(_e); i >= 1; i = i-1) {
        heapify(v, i, _e, compareF);
    }
}

// if compareF is >, same as isMax
// if compareF is <, same as isMin
function isMost(v, compareF) {
    for (let i = v.length - 1; i >= 2; i = i-1) {
        if (compareF(v[i], v[parent(i)])) {
            return false;
        }
    }
    return true;
}

// if compareF is >, sort ABC...
// if compareF is <, sort ZYX...
function heapSort(v, compareF) {
    build(v, compareF);

    let _e = v.length - 1;
    do {
        exchange(v, 1, _e);
        _e = _e - 1;
        heapify(v, 1, _e, compareF);
    } while (_e >= 1);
}

function getPriorityTop(v) {
    if (isMost(v, greater) || isMost(v, less)) {
        return v[1];
    } else {
        return undefined;
    }
}

function popPriorityMax(v) {
    if (isMost(v, greater)) {
        let _e = v.length - 1;
        exchange(v, 1, _e);
        let top = v.pop();
        heapify(v, 1, _e - 1, greater);
        return top;
    } else {
        return undefined;
    }
}

function popPriorityMin(v) {
    if (isMost(v, less)) {
        let _e = v.length - 1;
        exchange(v, 1, _e);
        let top = v.pop();
        heapify(v, 1, _e - 1, less);
        return top;
    } else {
        return undefined;
    }
}

function insertPriorityMax(v, value) {
    if (isMost(v, greater)) {
        v.push(value);
        for (let i = v.length - 1; i >= 2; i = parent(i)) {
            if (v[i] > v[parent(i)]) {
                exchange(v, i, parent(i));
            }
        }
        return true;
    } else {
        return false;
    }
}

function insertPriorityMin(v, value) {
    if (isMost(v, less)) {
        v.push(value);
        for (let i = v.length - 1; i >= 2; i = parent(i)) {
            if (v[i] < v[parent(i)]) {
                exchange(v, i, parent(i));
            }
        }
        return true;
    } else {
        return false;
    }
}

//----------------------------------

let length = 10
let v = new Array(length + 1);
setRandom(v, 0, 1000);
console.log(v);
heapSort(v, greater);
console.log(v);
heapSort(v, less);
console.log(v);

build(v, greater);
console.log(v);
popPriorityMax(v);
console.log(v);
insertPriorityMax(v, 999);
console.log(v);

build(v, less);
console.log(v);
popPriorityMin(v);
console.log(v);
insertPriorityMin(v, -1);
console.log(v);
