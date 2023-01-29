set -ex

# https://github.com/rust-lang/cargo/issues/10583#issuecomment-1129997984
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Bundle all downstream library licenses
pushd ruff_cli
cargo-bundle-licenses \
  --format yaml \
  --output ${SRC_DIR}/THIRDPARTY.yml
popd

# Apply PEP517 to install the package
maturin build --no-default-features --release -i $PYTHON

cd target/wheels

# Install wheel manually
$PYTHON -m pip install *.whl
