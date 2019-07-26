
const insertion_sort = function(v) {
    let n = v.length;
    if (n > 0) {
        for (let i = 1; i != n; i += 1) {
            for (let p = i - 1, q = i;
                     p >= 0 && v[p] > v[q]; p -= 1, q -= 1) {
                exchange(v, p, q);
            }
        }
    }
}

const bucket_sort = function(v) {
    let bucket = new Array();
    let n = v.length;
    for (let i = 0; i != n; i += 1) {
        bucket[i] = new Array();
    }

    for (element of v) {
        let index = Math.floor(n * element);
        bucket[index].push(element);
    }

    for (b of bucket) {
        insertion_sort(b);
    }

    let k = 0;
    for (b of bucket) {
        for (element of b) {
            v[k] = element;
            k += 1;
        }
    }
}

//--------------------------------------

const exchange = function(v, i, j) {
    let temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

const randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

const mkIntArray = function(size, min, max) {
    let v = new Array();
    for (let i = 0; i < size; i += 1) {
        v.push(randomInt(min, max));
    }
    return v;
}

const mkFloatArray = function(size) {
    let v = new Array();
    for (let i = 0; i < size; i += 1) {
        v.push(Math.random());
    }
    return v;
}

const printArray = function(v) {
    process.stdout.write("(Array #" + v.length + " [")
    for (element of v) {
        process.stdout.write(element + " ");
    }
    process.stdout.write("])\n");
}

let A = mkFloatArray(100);
printArray(A);
bucket_sort(A);
printArray(A);
