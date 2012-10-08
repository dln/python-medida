from libmedida cimport *


cdef inline _string2py(string s):
    return s.c_str()[:s.size()].decode('UTF-8')


cdef class Counter:
    cdef _Counter* thisptr   # KLUDGE: Owned by a MetricsRegistry

    property count:
        def __get__(self):
            return self.thisptr.count()

    def inc(self, int64_t n = 1):
        with nogil:
            self.thisptr.inc(n)

    def dec(self, int64_t n = 1):
        self.thisptr.dec(n)

    def clear(self):
        self.thisptr.clear()


cdef class Histogram:
    cdef _Histogram* thisptr   # KLUDGE: Owned by a MetricsRegistry

    property sum:
        def __get__(self):
            return self.thisptr.sum()

    property min:
        def __get__(self):
            return self.thisptr.min()

    property max:
        def __get__(self):
            return self.thisptr.max()

    property mean:
        def __get__(self):
            return self.thisptr.mean()

    property std_dev:
        def __get__(self):
            return self.thisptr.std_dev()

    property variance:
        def __get__(self):
            return self.thisptr.variance()

    property count:
        def __get__(self):
            return self.thisptr.count()

    def update(self, int64_t n):
        self.thisptr.Update(n)

    def clear(self):
        self.thisptr.Clear()


cdef class Timer:
    cdef _Timer* thisptr   # KLUDGE: Owned by a MetricsRegistry

    property sum:
        def __get__(self):
            return self.thisptr.sum()

    property min:
        def __get__(self):
            return self.thisptr.min()

    property max:
        def __get__(self):
            return self.thisptr.max()

    property mean:
        def __get__(self):
            return self.thisptr.mean()

    property std_dev:
        def __get__(self):
            return self.thisptr.std_dev()

    property count:
        def __get__(self):
            return self.thisptr.count()

    def clear(self):
        self.thisptr.Clear()


cdef class MetricsRegistry:
    cdef _MetricsRegistry *thisptr

    def __cinit__(self):
        self.thisptr = new _MetricsRegistry()

    def __dealloc__(self):
        if self.thisptr is not NULL:
            del self.thisptr

    def counter(self, char* domain, char* type, char* name, char* scope = "", int64_t init=0):
        counter = Counter()
        counter.thisptr = &self.thisptr.NewCounter(
            _MetricName(string(domain), string(type), string(name), string(scope))
            , init)
        return counter

    def histogram(self, char* domain, char* type, char* name, char* scope = "", cppbool biased=False):
        histogram = Histogram()
        histogram.thisptr = &self.thisptr.NewHistogram(
            _MetricName(string(domain), string(type), string(name), string(scope)),
            BIASED_SAMPLE if biased else UNIFORM_SAMPLE)
        return histogram

    def timer(self, char* domain, char* type, char* name, char* scope = ""):
        timer = Timer()
        timer.thisptr = &self.thisptr.NewTimer(
            _MetricName(string(domain), string(type), string(name), string(scope))
            )
        return timer
