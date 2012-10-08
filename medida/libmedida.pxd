from libc.stdint cimport *
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp cimport bool as cppbool


cdef extern from "medida/medida.h" namespace "medida" nogil:
    cdef cppclass _MetricName "medida::MetricName":
        _MetricName(string, string, string, string)

    cdef enum _SampleType "medida::SamplingInterface::SampleType":
        UNIFORM_SAMPLE "medida::SamplingInterface::kUniform"
        BIASED_SAMPLE "medida::SamplingInterface::kBiased"

    cdef cppclass _Counter "medida::Counter":
        void inc(int64_t) nogil
        void dec(int64_t) nogil
        int64_t count() nogil
        void clear() nogil

    cdef cppclass _Histogram "medida::Histogram":
        double sum() nogil
        double max() nogil
        double min() nogil
        double mean() nogil
        double std_dev() nogil
        void Update(int64_t) nogil
        uint64_t count() nogil
        double variance() nogil
        void Clear() nogil

    cdef cppclass _Timer "medida::Timer":
        double sum() nogil
        double max() nogil
        double min() nogil
        double mean() nogil
        double std_dev() nogil
        uint64_t count() nogil
        void Clear() nogil

    cdef cppclass _MetricsRegistry "medida::MetricsRegistry":
        _MetricsRegistry()
        _Counter& NewCounter(_MetricName, int64_t) nogil
        _Histogram& NewHistogram(_MetricName, _SampleType) nogil
        _Timer& NewTimer(_MetricName) nogil

