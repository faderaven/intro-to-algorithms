

const extract_b = function(n, digit) {
    let p1 = 10 ** digit;
    let p2 = 10 ** (digit - 1);
    return ((n % p1) - (n % p2)) / p2;
}

const extract = function(n, digit) {
    if (n < 0) {
        throw new Error("n must be a positive integer");
    } else if (digit < 1) {
        throw new Error("digit at least 1");
    } else {
        return extract_b(n, digit);
    }
}

const counting_stable = function(A, d) {
    let record = new Array();
    for (let i = 0; i != 10; i += 1) {
        record.push(0);
    }

    for (let i = 0; i != A.length; i += 1) {
        let n = extract(A[i], d);
        record[n] += 1;
    }

    for (let i = 1; i != record.length; i += 1) {
        record[i] = record[i] + record[i - 1];
    }

    let out = new Array(A.length);
    for (let i = A.length - 1; i >= 0; i -= 1) {
        let n = extract(A[i], d);
        let index = record[n] - 1;
        out[index] = A[i];
        record[n] = index;
    }

    return out;
}

const radix_sort = function(A, digits) {
    let temp = A;
    for (let i = 1; i <= digits; i += 1) {
        temp = counting_stable(temp, i);
    }
    array_copy(temp, A);
}

const array_copy = function(src, des) {
    for (let i = 0; i != src.length; i += 1) {
        des[i] = src[i];
    }
}

//--------------------------------------

const randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

const setRandomArray = function(size, min, max) {
    let v = new Array();
    for (let i = 0; i < size; i = i+1) {
        v.push(randomInt(min, max));
    }
    return v;
}

let count = 100;
let n_min = 10;
let n_max = 10000;
let digits = 4;

let A = setRandomArray(count, n_min, n_max);
console.log(A);
radix_sort(A, digits);
console.log(A);
