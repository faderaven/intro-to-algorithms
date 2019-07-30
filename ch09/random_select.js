
const partition = function(v, left, right) {
    let i = left - 1;
    for (let j = left; j != right; j += 1) {
        if (v[j] < v[right]) {
            i += 1;
            exchange(v, i, j);
        }
    }
    i += 1;
    exchange(v, i, right);
    return i;
}

const random_partition = function(v, left, right) {
    let p = randomInt(left, right + 1);
    exchange(v, p, right);
    return partition(v, left, right);
}

const random_select_b = function(index, v, left, right) {
    let rs_help = function(l, r) {
        if (l < r) {
            let p = random_partition(v, l, r);
            if (index < p) {
                rs_help(l, p - 1);
            } else if (index > p) {
                rs_help(p + 1, r);
            } //else {
                return v[index];
            //}
        } else {
            return v[index];
        }
    }

    return rs_help(left, right);
}

const random_select = function(index, v, left, right) {
    if (left < 0) {
        throw new IllegalArgumentError("left");
    } else if (right >= v.length) {
        throw new IllegalArgumentError("right");
    } else if (index < left || index > right) {
        throw new IllegalArgumentError("index");
    } else {
        return random_select_b(index, v, left, right);
    }
}

//--------------------------------------

class IllegalArgumentError extends Error {
  constructor(message) {
    super(message);
    this.message = message;
    this.name = 'IllegalArgumentError';
  }
}

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

const printArray = function(v) {
    process.stdout.write("(Array #" + v.length + " [")
    for (element of v) {
        process.stdout.write(element + " ");
    }
    process.stdout.write("])\n");
}

let A = mkIntArray(100, 0, 100);
printArray(A);
console.log(random_select(95, A, 0, 99));
insertion_sort(A);
printArray(A);
