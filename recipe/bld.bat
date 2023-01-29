REM https://github.com/rust-lang/cargo/issues/10583#issuecomment-1129997984
set CARGO_NET_GIT_FETCH_WITH_CLI=true
REM Create temp folder
mkdir tmpbuild_%PY_VER%
set TEMP=%CD%\tmpbuild_%PY_VER%
REM Bundle all downstream library licenses
pushd ruff_cli
cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY.yml ^
    || goto :error
popd
REM Use PEP517 to install the package
maturin build --no-default-features --release -i %PYTHON% -o dist
REM Install wheel
cd dist
REM set UTF-8 mode by default
chcp 65001
set PYTHONUTF8=1
set PYTHONIOENCODING="UTF-8"
set TMPDIR=tmpbuild_%PY_VER%
FOR %%w in (*.whl) DO %PYTHON% -m pip install %%w --no-clean
