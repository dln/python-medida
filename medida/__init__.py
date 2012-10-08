__version__ = '0.1.0-beta'

try:
    from _medida import MetricsRegistry
except ImportError:
    import warnings
    warnings.warn("Cannot import '_medida' extension module."), UserWarning

