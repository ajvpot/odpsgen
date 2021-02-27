#!/bin/bash
set -euox pipefail

OPDS_VERSION="1.2"

mkdir deps || true
pushd deps
[[ -d opds-specs ]] || git clone https://github.com/opds-community/specs.git opds-specs
[[ -d ogc-schemas ]] || git clone https://github.com/highsource/ogc-schemas ogc-schemas
[[ -f trang.zip ]] || wget -O trang.zip https://github.com/relaxng/jing-trang/releases/download/V20181222/trang-20181222.zip
[[ -d trang ]] || (unzip trang.zip; mv trang-* trang; rm trang.zip)
popd 

rm -r rnc || true
mkdir rnc
rm -r xsd || true
mkdir xsd

cp deps/opds-specs/schema/$OPDS_VERSION/opds.rnc rnc
cp deps/ogc-schemas/schemas/src/main/resources/ogc/opensearchgeo/1.0/schemas/*.rnc rnc
sed -ie 's|include "atom.rnc"|include "osatom.rnc"|' rnc/opds.rnc

java -jar deps/trang/trang.jar -I rnc -O xsd rnc/opds.rnc xsd/opds.xsd
