cardano-cli address key-hash --payment-verification-key-file addr01.vkey --out-file Addre01.pkh
cardano-cli address key-hash --payment-verification-key-file addr02.vkey --out-file Addre02.pkh
cardano-cli transaction policyid --script-file Nativetokenpolicy.script

export TESTNET="--testnet-magic 2"

cardano-cli query tip $TESTNET

cardano-cli query utxo \
 --address $(cat addr01.addr) \
 $TESTNET

cardano-cli query protocol-parameters $TESTNET --out-file metadataprotocol.params


utxoin="571b76e984084ca391e9c164fc438d5d3a6c4c12d3606244185534b55104c29d#1"
policyid=$(cat Nativetokenpolicy.id)
address=$(cat addr01.addr)
output="70000001"
tokenname=$(echo -n "tokentest2" | xxd -ps | tr -d '\n')
tokenamount="100"

cardano-cli transaction build \
--babbage-era \
$TESTNET \
--tx-in $utxoin \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
--change-address $address \
--mint "$tokenamount $policyid.$tokenname" \
--mint-script-file Nativetokenpolicy.script \
--invalid-before 13107768 \
--protocol-params-file metadataprotocol.params \
--out-file NativetokenSminting2.unsigned

cardano-cli transaction sign \
--tx-body-file NativetokenSminting2.unsigned \
--signing-key-file addr01.skey \
--signing-key-file addr02.skey \
$TESTNET \
--out-file NativetokenSminting2.signed

cardano-cli transaction submit \
--tx-file NativetokenSminting2.signed \
$TESTNET


