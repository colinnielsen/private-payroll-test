#!/usr/bin/env bash

#
# Runs nargo build and compile before generating a proof.
# If Prover.toml is malformed, it will still generate the proof using the last valid build.
#

printf "Name your build file : "
read name_build

printf "Message to sign š : "
read message

echo "How do you wish to compile?"
select pipeline in "Nargo" "WASM"; do
    case $pipeline in
    Nargo)
        pipeline="Nargo"
        break
        ;;
    WASM)
        pipeline="WASM"
        break
        ;;
    esac
done

cd circuits/

printf "\nš» nargo build š»\n\n"
nargo build

printf "\nš» nargo compile š»\n\n"
nargo compile ${name_build}

printf "\nš» generateSigProof script š»\n\n"
npx ts-node ../scripts/generateProof.ts ${pipeline} ${name_build} ${message}

if [ $pipeline = "Nargo" ]; then
    printf "\nš» nargo prove š»\n\n"
    nargo prove ${name_build}

    printf "\nš» nargo verify š»\n\n"
    nargo verify ${name_build}
fi
