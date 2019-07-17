
const quick_sort = function(part) {
    return function f(v, l, r) {
        if (l < r) {
            let q = part(v, l, r);
            f(v, l, q - 1);
            f(v, q + 1, r);
        }
    }
}

const partition = function(compare) {
    return function(v, l, r) {
        let i = l - 1;
        for (let j = l; j < r; j = j+1) {
            if (compare(v[j], v[r])) {
                i = i + 1;
                exchange(v, i, j);
            }
        }
        exchange(v, i + 1, r);
        return i + 1;
    }
}

const random_partition = function(compare) {
    return function(v, l, r) {
        let q = randomInt(l, r);
        exchange(v, q, r);
        return partition(compare)(v, l, r);
    }
}

const exchange = function(v, i, j) {
    let temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

const randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

const greater = function(n, m) { return n > m; }
const less = function(n, m) { return n < m; }

const quick_sort_asc = function(v) {
    quick_sort(partition(less))(v, 0, v.length - 1);
}

const quick_sort_desc = function(v) {
    quick_sort(partition(greater))(v, 0, v.length - 1);
}

const random_quick_sort_asc = function(v) {
    quick_sort(random_partition(less))(v, 0, v.length - 1);
}

const random_quick_sort_desc = function(v) {
    quick_sort(random_partition(greater))(v, 0, v.length - 1);
}

//-----------------------------------

const setArray = function(size, bound) {
    let v = new Array();
    for (let i = 0; i < size; i = i+1) {
        v.push(randomInt(0, bound));
    }
    return v;
}

let v = setArray(100, 1000);
console.log(v);

quick_sort_asc(v);
console.log(v);
quick_sort_desc(v);
console.log(v);
random_quick_sort_asc(v);
console.log(v);
random_quick_sort_desc(v);
console.log(v);
