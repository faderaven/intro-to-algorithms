
const counting_sort = function(v, n_max) {

    let record = new Array();
    for (let i = 0; i != n_max; i += 1) {
        record.push(0);
    }

    for (let i = 0; i != v.length; i += 1) {
        let e = v[i];
        record[e] = record[e] + 1;
    }

    for (let i = 1; i != record.length; i += 1) {
        record[i] = record[i] + record[i - 1];
    }

    let out = new Array();
    for (let i = 0; i != v.length; i += 1) {
        out.push(0);
    }
    for (let i = 0; i != v.length; i += 1) {
        let e = v[i];
        let index = record[e] - 1;
        out[index] = e;
        record[e] = index;
    }

    return out;
}

//--------------------------------------

const randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

const setRandomArray = function(size, bound) {
    let v = new Array();
    for (let i = 0; i < size; i = i+1) {
        v.push(randomInt(0, bound));
    }
    return v;
}

let count = 100;
let n_max = 100;

let A = setRandomArray(count, n_max);
let B = counting_sort(A, n_max);
console.log(A);
console.log(B);
