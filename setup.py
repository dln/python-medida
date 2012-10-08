#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""Python bindings to the Medida metrics library.
"""

from setuptools import Extension, setup
from Cython.Distutils import build_ext

from medida import __version__

setup(
    name='medida',
    version=__version__,
    url='https://dln.github.com/medida/',
    author='Daniel Lundin <dln@eintr.org>',
    description='libmedida python bindings',
    long_description=__doc__,
    platforms='any',
    install_requires=[],
    include_package_data=True,
    packages=['medida'],
    ext_modules = [
        Extension('medida._medida',
            ["medida/medida.pyx"],
            language="c++",
            libraries=["medida"],
            extra_compile_args=["-std=c++0x"],
        ),
    ],
    tests_require=[
        'nose>=0.11.1',
        'unittest2'
    ],
    test_suite='nose.collector',
    cmdclass = {'build_ext': build_ext},
    zip_safe=False,
)
