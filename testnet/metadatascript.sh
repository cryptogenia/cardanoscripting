export TESTNET="--testnet-magic 2"

cardano-cli query utxo \
 --address $(cat addr01.addr) \
 $TESTNET


cardano-cli transaction build \
--babbage-era \
$TESTNET \
--tx-in "5a53949137060c08b0919a431eb9539ece85f11d72617bf48c6371092a658d38#1" \
--change-address "$(cat addr01.addr)" \
--metadata-json-file metadata.json \
--protocol-params-file metadataprotocol.params \
--out-file metadatatx.draft

cardano-cli transaction sign \
--tx-body-file metadatatx.draft \
--signing-key-file addr01.skey \
$TESTNET \
--out-file metadatatx.signed

cardano-cli transaction submit \
--tx-file metadatatx.signed \
$TESTNET