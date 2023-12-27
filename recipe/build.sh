set -ex

# https://github.com/rust-lang/cargo/issues/10583#issuecomment-1129997984
export CARGO_NET_GIT_FETCH_WITH_CLI=true

pushd crates/ruff_cli
# Bundle all downstream library licenses
cargo-bundle-licenses \
  --format yaml \
  --output ${SRC_DIR}/THIRDPARTY.yml
popd

# maturin looks at all .gitignore files
# see https://github.com/conda-forge/conda-smithy/pull/1818
mv "${FEEDSTOCK_ROOT}/.gitignore" "${FEEDSTOCK_ROOT}/gitignore"

# Run the maturin build via pip which works for direct and
# cross-compiled builds.
$PYTHON -m pip install . -vv

mv "${FEEDSTOCK_ROOT}/gitignore" "${FEEDSTOCK_ROOT}/.gitignore"
