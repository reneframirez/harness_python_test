import app


def test_package_is_importable_and_versioned() -> None:
    assert app.__version__
