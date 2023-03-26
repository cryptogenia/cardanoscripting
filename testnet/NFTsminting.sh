#cardano-cli address key-hash --payment-verification-key-file addr01.vkey --out-file Addre01.pkh
#cardano-cli address key-hash --payment-verification-key-file addr02.vkey --out-file Addre02.pkh
#cardano-cli transaction policyid --script-file NFTpolicy.script

#cardano-cli address key-hash --payment-verification-key-file ../addr01.addr --out-file addr01.pkh

#export TESTNET="--testnet-magic 2"

#cardano-cli query tip $TESTNET

cardano-cli query utxo \
 --address $(cat addr01.addr) \
 $TESTNET 
 
#chmod +x fileeee

#cardano-cli query protocol-parameters $TESTNET --out-file metadataprotocol.params
utxoin="54d55781b2d3a0552a3a1ff4f29109fb2f1e9483278bf7e4846d57b3cf39db46#1"
policyid=$(cat NFTPolicy.id)
address="addr_test1qzp5a8hra5vev3k05e4yt4g3e0w5upznzv8sj0l5jxe2up9n8f7kulzums7pa9wtf42mr484j6w2227s4ktha8rwnrrqyv5z5t" 
#addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt   wallet de roberto
addressMine=$(cat addr01.addr)
output="10000000"
tokenname=$(echo -n "nft_03_zelda3" | xxd -ps | tr -d '\n')
tokenamount="1"
collateral="571b76e984084ca391e9c164fc438d5d3a6c4c12d3606244185534b55104c29d#0"
signerPKH="f019002f869a013721ac82d7288be0a4dcfa15bd96850fd73068d0a7"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $addressMine \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file NFTpolicy.script \
  --invalid-before 13136667 \
  --metadata-json-file NFTmetadata.json \
  --protocol-params-file protocol.params \
  --out-file NFTsminting.unsigned

cardano-cli transaction sign \
  --tx-body-file NFTsminting.unsigned \
  --signing-key-file addr01.skey \
  --signing-key-file addr02.skey \
  --testnet-magic 2 \
  --out-file NTFsminting.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file NTFsminting.signed