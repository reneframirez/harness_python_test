import app


def test_package_is_importable_and_versioned() -> None:
    assert app.__version__


def test_double() -> None:
    assert app.double(2) == 4
