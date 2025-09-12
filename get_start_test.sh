#!/usr/bin/env bash

set -e
set -x

outdir=$1
if [ -z "$outdir" ]; then
  echo "Usage: $0 <output-directory>"
  exit 1
fi
rm -rf "$outdir"
mkdir -p "$outdir"
outdir=$(realpath "$outdir")

temp_dir=$(mktemp -d)
pushd "$temp_dir"

rm -rf chapel-sparse
git clone -n --depth=1 --filter=tree:0 \
  -b main --single-branch \
  https://github.com/chapel-lang/chapel.git chapel-sparse
pushd chapel-sparse
git sparse-checkout set --no-cone /util /third-party/chpl-venv
git checkout
popd ..
mv $temp_dir/chapel-sparse/util $outdir
mv $temp_dir/chapel-sparse/third-party/chpl-venv/test-requirements.txt $outdir
rm -rf chapel-sparse
popd

export CHPL_TEST_VENV_DIR="$outdir/venv"
python3 -m venv "$CHPL_TEST_VENV_DIR"
source "$CHPL_TEST_VENV_DIR/bin/activate"
pip install --upgrade pip
pip install -r "$outdir/test-requirements.txt"
deactivate


