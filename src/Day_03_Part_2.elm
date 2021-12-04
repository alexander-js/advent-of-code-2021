module Day_03_Part_2 exposing (..)

import Bitwise
import List.Extra as List

type alias Bits =
    List Int

bitsToDecimal : Bits -> Int
bitsToDecimal bits =
    bits
        |> List.reverse
        |> List.indexedFoldl
            (\i bit decimal ->
                case bit of
                    1 ->
                        decimal + Bitwise.shiftLeftBy i 1

                    _ ->
                        decimal
            )
            0

solution : Int
solution =
    let
        handleOxygenDivision : ( List Bits, List Bits ) -> List Bits
        handleOxygenDivision ( zeroes, ones ) =
            if List.length ones >= List.length zeroes then
                ones

            else
                zeroes

        handleScrubberDivision : ( List Bits, List Bits ) -> List Bits
        handleScrubberDivision ( zeroes, ones ) =
            if List.length zeroes <= List.length ones then
                zeroes

            else
                ones

        findBits : (( List Bits, List Bits ) -> List Bits) -> List Bits -> Int -> Bits
        findBits handleDivision remainingSeqs index =
            let
                divide : List Bits -> ( List Bits, List Bits ) -> List Bits
                divide list ( zeroes, ones ) =
                    let
                        ( maybeSeq, seqs ) =
                            case list of
                                x :: xs ->
                                    ( Just x, xs )

                                [] ->
                                    ( Nothing, [] )
                    in
                    case maybeSeq of
                        Just seq ->
                            case List.drop index seq of
                                0 :: _ ->
                                    divide seqs
                                        ( seq :: zeroes
                                        , ones
                                        )

                                1 :: _ ->
                                    divide seqs
                                        ( zeroes
                                        , seq :: ones
                                        )

                                wtf ->
                                    Debug.todo ("Malformed input data. Expected a sequence of bits; got " ++ Debug.toString wtf)

                        Nothing ->
                            handleDivision ( zeroes, ones )
            in
            case divide remainingSeqs ( [], [] ) of
                [ winningSeq ] ->
                    winningSeq

                nextRemainder ->
                    findBits
                        handleDivision
                        nextRemainder
                        ( index + 1 )

        generatorRating =
            findBits handleOxygenDivision input 0
                |> bitsToDecimal

        scrubberRating =
            findBits handleScrubberDivision input 0
                |> bitsToDecimal
    in
    generatorRating * scrubberRating

input : List Bits
input =
    [ [0,1,0,0,0,1,1,1,0,0,0,1],[1,1,0,1,0,0,0,0,0,0,0,1],[1,1,1,0,0,1,0,0,1,0,1,1],[1,1,1,1,0,0,0,0,1,0,0,0],[0,0,0,1,1,1,1,0,1,0,0,1],[1,0,1,1,1,1,0,0,1,0,0,1],[1,1,1,1,1,1,0,0,0,1,1,0],[0,0,0,1,0,1,1,1,0,0,1,0],[0,0,1,1,0,1,0,0,1,0,1,0],[0,0,0,1,1,0,0,0,1,1,0,1],[0,1,1,1,1,1,1,1,1,1,1,0],[1,0,1,1,0,0,0,1,0,0,0,1],[1,1,0,1,0,1,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,1,0],[0,1,0,0,1,1,0,0,0,0,1,1],[0,1,0,1,0,1,1,1,0,0,1,0],[0,1,1,0,0,1,0,0,1,0,0,1],[0,1,0,0,1,1,0,1,0,1,1,1],[0,0,1,1,0,1,0,1,0,1,1,0],[1,0,0,0,0,0,1,0,1,0,0,0],[0,1,1,1,0,0,1,1,0,0,1,0],[0,0,1,0,1,1,1,1,0,0,0,1],[1,0,1,1,1,0,1,1,0,0,1,1],[1,0,0,0,1,1,0,1,1,1,0,1],[0,0,0,1,0,1,1,1,1,0,1,1],[0,0,0,0,1,0,0,1,1,0,0,0],[1,1,0,1,0,1,1,0,1,1,1,1],[0,1,1,0,1,0,1,0,1,1,0,0],[1,1,1,0,0,1,0,1,1,0,1,0],[0,1,1,1,0,0,1,1,0,0,1,1],[0,0,0,1,0,1,0,0,0,1,1,1],[1,1,1,0,0,0,1,1,0,1,0,1],[1,1,0,1,1,1,0,1,0,0,0,0],[1,1,1,1,1,0,0,1,0,0,0,1],[0,1,0,1,0,0,1,0,0,1,1,0],[0,1,0,0,0,1,0,1,1,0,1,0],[1,0,1,1,0,0,1,0,0,0,0,1],[0,0,1,0,0,0,1,0,1,0,1,0],[0,1,1,1,1,1,0,1,0,0,1,0],[1,0,1,0,1,1,1,0,0,1,1,0],[1,0,0,1,1,1,0,1,0,1,1,0],[1,0,1,0,0,0,1,1,0,1,0,0],[0,1,1,0,1,0,1,1,0,0,0,1],[0,0,0,0,1,0,0,0,1,0,0,0],[1,0,0,0,0,1,1,1,0,1,1,1],[1,0,1,0,0,1,0,1,1,1,0,0],[1,0,0,1,0,0,0,0,1,0,1,1],[1,1,1,0,1,0,1,0,1,1,1,0],[0,0,1,1,0,1,1,0,1,0,0,1],[0,0,0,1,1,1,1,1,1,1,0,0],[0,1,1,0,1,1,1,1,1,0,0,0],[1,1,1,1,1,1,1,1,1,0,1,1],[1,0,1,1,0,0,0,1,1,0,1,0],[0,1,1,1,0,1,0,0,1,0,0,1],[1,1,1,0,0,1,0,0,1,0,0,0],[0,1,0,1,0,1,0,1,0,0,0,1],[1,0,0,0,0,0,0,1,1,0,1,1],[1,0,0,1,1,0,1,0,0,0,1,1],[0,1,0,1,0,1,1,1,0,1,1,1],[1,1,1,1,1,0,1,1,0,0,0,0],[0,0,0,0,0,1,0,1,1,1,1,1],[1,1,1,1,1,0,1,0,0,1,1,1],[0,0,0,1,0,0,1,0,1,0,0,0],[0,0,0,1,0,0,1,0,0,0,1,1],[0,0,0,0,1,1,1,1,0,0,0,1],[0,0,0,0,0,1,1,0,1,1,0,1],[0,1,1,0,0,0,0,0,1,0,0,0],[1,1,0,1,1,1,0,1,1,0,1,0],[0,1,0,0,0,0,0,1,1,0,1,0],[1,1,0,1,0,1,1,1,1,0,1,1],[1,1,0,1,1,0,0,0,0,0,0,1],[1,1,1,1,0,1,0,0,0,1,0,0],[1,0,1,0,1,0,1,0,0,1,1,1],[1,0,1,1,1,0,1,1,0,0,0,1],[0,0,0,1,1,1,1,1,0,1,0,1],[0,0,1,0,1,0,0,0,0,1,0,0],[0,1,0,1,0,0,0,0,0,1,0,1],[1,1,1,1,1,0,0,0,0,0,1,0],[1,1,0,0,1,1,0,0,1,0,1,1],[0,1,0,0,1,1,0,0,0,1,0,1],[0,1,0,0,0,1,1,0,1,1,1,0],[0,1,0,0,0,1,1,0,1,0,0,0],[1,1,0,1,1,1,0,0,0,1,0,0],[1,1,1,0,0,0,0,1,0,0,1,0],[0,1,0,0,0,0,0,0,0,1,0,1],[1,1,1,1,1,0,0,0,1,1,0,0],[1,0,0,1,1,0,0,0,0,1,1,0],[1,0,0,1,0,0,0,0,0,0,1,1],[0,1,1,1,0,1,1,0,1,0,1,1],[0,1,1,0,0,1,1,0,0,0,1,0],[1,1,0,0,1,1,1,1,1,0,1,1],[0,1,1,0,0,1,1,1,1,0,0,0],[1,1,0,0,0,1,0,0,1,1,1,0],[0,1,1,1,1,1,0,0,1,0,0,0],[1,0,0,0,1,0,0,0,1,0,1,1],[1,1,1,0,0,1,0,0,1,1,0,1],[1,0,0,0,0,0,1,1,0,0,0,0],[1,0,0,0,0,0,0,0,1,0,0,0],[0,1,1,0,0,1,0,1,1,0,1,0],[1,1,1,1,1,0,1,0,0,0,1,1],[1,0,0,1,1,1,0,0,0,1,0,0],[0,1,1,0,0,0,1,1,1,0,1,0],[0,1,1,1,0,1,0,0,1,1,0,0],[0,0,0,1,1,0,0,1,1,0,0,1],[1,0,1,1,0,1,1,1,1,0,1,1],[0,0,1,1,0,1,0,0,1,0,1,1],[1,0,0,1,0,1,1,1,1,1,0,0],[1,1,1,0,0,1,0,0,1,1,1,0],[0,1,0,1,0,0,0,1,1,1,1,0],[1,0,0,1,0,1,0,1,1,0,1,0],[1,1,0,1,0,1,1,1,0,0,0,0],[1,1,1,1,0,1,1,1,0,1,1,0],[0,0,1,0,1,0,1,0,1,1,0,0],[0,1,1,0,1,0,0,0,0,0,1,1],[1,1,0,0,0,1,0,1,0,0,1,1],[1,0,1,0,0,0,1,0,0,0,1,1],[1,1,0,0,1,0,1,1,1,1,1,0],[1,0,0,0,0,0,0,1,0,1,0,0],[1,0,1,0,1,1,1,0,0,0,0,0],[1,1,1,1,1,0,1,1,1,0,0,0],[0,0,0,0,0,0,1,0,0,0,1,1],[1,0,0,0,1,0,0,0,0,1,0,0],[0,1,1,1,1,1,0,0,1,1,0,0],[0,1,0,1,0,0,1,1,1,0,1,1],[1,0,1,1,1,0,0,0,1,1,0,0],[1,0,1,1,0,1,1,1,1,1,0,0],[0,1,1,0,0,0,1,0,1,1,1,0],[0,0,1,0,1,0,0,1,0,0,1,0],[0,1,1,0,0,1,0,1,1,0,0,0],[0,1,0,0,1,1,1,0,0,0,0,1],[0,1,1,1,1,1,1,1,1,1,0,1],[0,0,0,0,0,1,1,1,1,0,1,1],[0,1,1,0,1,0,1,1,0,1,0,0],[0,1,1,0,0,1,1,0,0,0,0,0],[1,1,1,1,0,1,0,0,0,1,1,0],[0,1,0,1,1,0,1,0,1,0,0,1],[0,1,1,1,0,0,0,0,1,1,1,1],[0,0,0,0,0,0,0,0,1,1,1,0],[1,1,0,0,1,0,1,1,0,1,1,1],[1,0,0,1,1,0,0,1,1,1,0,1],[1,0,1,0,1,0,0,0,0,0,0,0],[0,1,0,1,0,0,0,1,1,1,1,1],[1,1,0,1,1,1,0,0,1,1,1,0],[1,0,1,1,0,0,0,1,1,0,0,0],[1,0,1,1,0,1,1,0,1,1,1,1],[1,1,0,1,1,0,1,1,1,0,0,1],[1,0,1,1,1,1,1,1,1,0,1,0],[0,0,0,0,1,1,0,1,0,1,0,1],[0,0,0,0,0,0,0,0,1,0,0,0],[1,0,0,0,1,1,0,0,0,1,1,0],[0,0,0,0,0,0,1,1,0,1,1,0],[1,0,0,0,1,1,0,0,0,0,0,1],[1,1,0,0,1,1,1,1,1,1,1,0],[1,1,0,0,0,1,0,0,0,1,0,1],[1,1,0,1,1,0,1,0,0,1,0,0],[0,1,0,0,0,1,1,0,1,0,1,0],[1,1,0,1,0,0,0,0,0,0,1,1],[1,1,0,1,0,0,0,0,1,0,1,0],[0,0,0,0,1,0,1,1,0,1,1,1],[1,0,0,0,1,1,0,0,1,0,1,0],[0,0,1,1,1,1,1,1,1,0,1,1],[0,0,0,1,1,0,1,1,1,0,1,0],[0,1,1,1,1,0,0,0,1,1,0,0],[0,1,1,1,1,0,1,1,0,0,0,0],[1,0,0,1,0,0,1,1,0,0,0,0],[1,0,0,0,1,1,1,1,1,1,1,0],[1,0,0,0,0,0,0,0,0,0,1,1],[1,0,0,1,0,1,1,1,0,0,1,0],[1,0,1,0,1,0,1,1,0,1,1,0],[1,1,0,0,0,0,0,1,1,0,0,1],[1,0,1,1,1,0,1,1,1,1,0,1],[0,0,0,1,1,0,0,0,1,0,0,0],[0,0,1,1,1,0,1,1,1,1,1,1],[1,1,0,0,0,0,0,1,0,0,0,1],[1,0,0,1,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,0,0,1,0,0,1],[1,1,1,1,0,0,1,0,1,0,1,1],[1,1,1,1,1,0,1,0,1,1,1,0],[0,0,0,1,1,0,0,0,0,1,1,1],[0,0,0,0,0,0,0,0,0,0,0,1],[1,1,0,1,0,0,1,0,1,1,1,1],[0,1,1,0,1,0,1,0,0,1,1,0],[0,0,0,0,1,0,1,1,0,0,0,1],[0,1,1,0,0,0,1,0,0,1,1,1],[1,1,0,0,1,1,0,1,0,0,1,1],[0,0,1,1,0,1,1,0,1,0,1,0],[0,0,0,0,1,1,1,1,1,0,0,1],[0,1,0,1,1,0,0,0,1,1,1,1],[1,1,0,0,0,0,0,1,1,0,0,0],[1,1,1,0,1,0,1,0,0,0,0,0],[0,1,1,1,0,1,1,1,0,1,1,1],[0,1,0,0,0,1,1,1,1,0,0,1],[1,0,0,0,0,0,1,1,1,1,1,1],[1,0,1,1,1,0,1,0,0,1,1,1],[0,0,0,1,1,0,0,0,1,0,1,1],[0,1,1,1,1,0,0,0,1,1,1,0],[1,0,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,1,0,1,0,0,0,0,0],[1,0,0,1,1,1,1,0,0,1,0,0],[0,1,0,0,1,1,0,0,0,0,0,1],[1,0,0,1,0,0,0,1,1,1,0,0],[0,1,0,0,1,0,1,0,1,1,0,0],[1,0,0,0,1,0,1,0,1,0,0,1],[0,0,0,1,0,1,0,0,1,1,1,0],[0,0,1,1,0,1,0,1,1,0,1,0],[0,1,1,1,0,0,1,0,0,1,1,1],[0,0,1,0,1,0,1,0,0,1,0,0],[1,1,0,0,1,0,1,0,0,0,0,0],[1,0,0,1,1,1,1,1,0,0,0,1],[0,0,1,1,1,1,0,0,1,0,0,0],[1,1,1,0,0,0,1,0,1,0,1,1],[0,1,1,0,1,1,1,0,1,0,0,1],[1,1,0,0,0,1,0,1,1,0,0,1],[1,1,1,0,1,1,1,1,0,1,1,1],[1,1,0,0,1,0,0,0,0,0,0,1],[0,0,1,0,1,1,0,1,0,0,1,0],[0,0,1,0,1,1,0,1,1,1,0,0],[1,0,1,0,0,0,1,1,0,0,0,1],[0,1,1,0,0,0,0,1,0,0,1,0],[1,1,1,0,1,1,0,0,0,1,1,0],[0,0,1,0,1,1,1,1,0,1,0,1],[0,0,0,1,1,1,0,0,1,0,0,1],[1,1,0,1,1,0,1,0,0,1,1,0],[0,1,1,1,0,1,1,1,1,1,1,1],[1,1,1,0,0,1,1,0,1,1,0,1],[0,0,0,1,0,0,0,1,1,1,1,0],[1,0,0,0,1,1,1,0,1,0,1,0],[0,1,1,1,1,1,1,1,1,0,1,1],[0,1,1,1,1,0,1,1,0,0,0,1],[0,0,1,0,1,0,1,1,1,1,1,1],[1,0,0,1,0,1,0,0,1,0,1,1],[0,0,1,1,0,1,1,1,0,1,1,0],[1,0,0,1,0,0,0,0,0,0,0,1],[1,1,1,0,0,0,1,1,1,0,0,1],[0,0,0,1,0,1,1,0,0,1,0,0],[1,1,0,0,1,1,0,1,1,0,0,0],[1,0,1,0,1,0,0,1,1,0,1,1],[1,0,1,1,0,0,1,1,0,1,1,1],[1,1,1,0,1,1,0,1,1,1,0,0],[0,0,0,0,1,1,1,1,1,1,1,0],[1,0,1,0,0,1,1,0,1,0,1,0],[0,1,1,0,0,0,1,1,1,1,0,0],[0,0,1,1,0,1,0,1,0,0,0,0],[1,1,0,0,0,0,0,0,0,0,1,1],[1,0,0,1,1,0,0,1,1,0,0,0],[0,0,1,0,0,0,0,1,1,1,0,0],[0,1,0,1,1,0,1,0,0,1,0,1],[0,0,0,1,1,1,1,0,1,1,0,0],[1,1,0,0,1,0,1,1,1,1,0,1],[0,1,0,0,1,0,1,0,1,0,1,0],[0,0,1,0,0,1,0,0,1,0,1,1],[0,0,1,0,1,0,0,1,1,0,1,1],[1,1,1,0,1,0,1,0,1,0,1,1],[1,1,1,1,1,1,0,0,1,1,1,0],[0,1,1,0,1,1,1,1,0,0,0,1],[0,1,1,1,0,1,0,1,0,1,0,1],[0,1,1,1,1,1,1,1,0,0,1,0],[0,0,0,1,1,1,1,1,1,1,1,0],[0,0,0,1,1,0,1,1,0,0,1,1],[1,1,1,1,0,0,0,0,1,1,0,1],[0,0,0,0,0,0,1,0,0,1,0,1],[0,0,0,0,1,0,1,1,1,1,1,1],[1,1,1,0,1,0,1,0,0,1,0,1],[1,0,0,1,0,1,1,1,1,0,0,0],[0,0,0,1,0,0,1,0,1,1,0,0],[0,0,0,1,1,1,1,0,0,0,1,0],[0,0,1,0,1,0,0,1,0,0,0,0],[1,0,0,1,0,0,0,1,0,0,0,1],[1,0,0,0,1,1,0,0,0,1,0,1],[0,0,1,0,0,0,0,0,1,0,1,0],[0,0,1,0,0,0,0,0,0,0,1,1],[0,1,1,1,0,0,0,1,1,0,1,0],[1,0,1,1,1,0,0,1,1,1,1,1],[0,0,0,0,1,1,1,0,1,1,0,1],[1,1,1,0,1,1,0,1,0,1,1,0],[1,1,0,1,0,0,1,1,1,0,1,1],[1,0,1,1,1,0,1,1,0,1,1,0],[0,1,1,1,1,0,0,0,1,0,1,1],[1,1,1,1,0,1,0,0,1,1,1,1],[0,1,1,1,0,0,1,0,1,1,1,0],[1,0,1,1,1,0,1,0,1,0,0,0],[0,0,0,1,0,1,0,0,0,0,0,1],[1,0,0,0,1,0,1,1,0,1,1,0],[1,0,1,1,0,1,0,0,1,1,0,1],[1,1,0,0,0,0,0,0,1,0,1,0],[0,0,0,1,1,1,0,0,1,1,1,1],[0,0,0,0,0,0,0,1,0,0,0,1],[0,0,1,1,1,0,1,0,0,1,0,1],[1,0,0,1,0,0,0,0,1,0,0,1],[1,0,0,0,1,1,1,1,1,0,0,0],[1,1,0,0,1,1,0,0,0,1,0,1],[1,1,0,1,1,1,1,1,1,0,0,0],[1,0,1,1,0,0,1,0,1,1,1,1],[0,0,0,0,0,0,1,1,0,1,0,0],[1,0,1,1,1,1,1,1,1,0,1,1],[1,1,1,0,0,1,0,1,0,1,0,1],[1,1,0,1,1,0,0,1,0,1,1,1],[0,1,1,1,0,0,0,1,1,0,0,1],[1,1,1,1,0,0,1,1,0,0,1,0],[0,1,1,0,1,1,1,0,1,0,0,0],[1,1,0,1,1,0,0,1,0,0,1,0],[0,1,1,0,0,0,0,0,1,0,1,0],[1,1,0,1,0,1,0,0,0,1,1,0],[1,0,0,0,0,0,1,0,0,1,0,1],[0,1,0,0,1,0,1,0,1,1,0,1],[1,1,0,1,0,0,0,0,1,0,1,1],[1,1,0,0,0,0,0,1,0,0,1,1],[1,0,0,0,1,1,0,0,1,1,0,1],[0,0,1,1,0,0,0,1,1,0,0,0],[1,0,0,0,1,0,1,1,0,1,1,1],[1,1,0,1,0,0,1,1,0,0,0,0],[0,1,1,0,1,1,0,0,1,0,0,0],[1,1,0,1,1,0,1,0,0,0,0,0],[0,1,0,0,0,0,1,0,1,0,0,1],[1,1,1,1,0,0,0,1,1,0,1,0],[0,0,0,0,0,0,0,1,0,1,0,0],[0,1,0,1,1,0,0,0,0,0,0,0],[1,1,0,0,1,0,0,0,0,1,0,0],[1,0,0,0,0,1,0,1,0,1,1,0],[0,0,0,0,1,0,1,0,0,1,1,0],[1,1,0,0,1,1,1,1,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,0,1],[0,1,0,0,1,1,0,1,0,1,0,1],[1,1,1,1,0,1,1,0,0,0,1,1],[0,0,1,0,0,1,1,0,1,0,1,0],[1,1,1,1,1,0,0,1,0,1,1,0],[1,0,1,1,0,0,0,0,1,0,1,0],[0,0,0,0,0,1,0,0,0,1,1,0],[1,1,0,1,1,1,0,0,1,0,0,0],[0,0,0,1,0,0,1,1,1,0,0,0],[0,0,1,1,1,0,1,1,1,0,0,0],[0,1,0,0,1,0,1,1,0,1,0,1],[0,1,0,0,0,1,0,0,1,1,0,0],[1,0,0,1,0,1,1,0,0,0,0,1],[1,1,1,0,1,0,1,0,1,0,1,0],[1,1,1,1,0,1,0,0,0,0,0,0],[1,0,1,0,1,0,1,0,1,1,0,0],[0,0,1,0,0,0,0,0,1,1,0,0],[1,1,0,0,0,1,0,0,1,0,1,0],[1,0,1,1,0,0,1,1,1,1,0,0],[1,1,0,1,1,0,1,0,0,0,0,1],[0,1,1,1,1,0,0,0,0,0,0,1],[0,0,1,0,1,1,0,1,1,0,0,0],[1,0,1,1,0,1,1,0,1,1,0,0],[1,0,0,1,1,0,0,0,0,1,0,1],[0,1,0,1,0,1,1,1,0,0,0,0],[1,1,0,1,0,1,0,0,1,1,1,0],[1,0,0,0,1,1,0,1,1,0,0,1],[0,1,1,1,0,0,0,0,1,0,0,0],[0,0,0,1,1,0,1,1,1,0,0,1],[0,1,0,1,0,1,1,1,1,1,0,1],[1,0,1,1,0,1,1,0,0,0,1,0],[0,1,1,1,0,1,1,0,1,1,0,0],[0,0,1,0,1,1,1,1,0,1,1,1],[1,0,1,0,0,1,0,0,1,1,0,0],[1,0,1,0,0,1,1,1,0,1,0,0],[0,0,0,0,1,0,0,1,1,0,1,1],[1,1,0,0,0,1,1,0,1,1,1,1],[1,1,0,1,1,0,0,0,1,0,1,0],[1,0,0,1,0,1,1,0,1,0,1,0],[1,1,0,1,1,0,0,1,1,0,0,1],[0,0,1,0,1,1,1,1,0,0,0,0],[0,0,0,1,1,1,1,0,0,1,1,1],[1,1,0,1,1,1,1,0,0,0,0,1],[1,1,0,0,1,0,1,0,0,1,0,0],[1,1,0,0,1,0,0,0,1,0,0,1],[0,1,1,0,1,0,0,0,1,1,1,0],[0,1,0,1,0,0,1,1,0,1,0,1],[0,1,1,0,1,1,1,1,1,0,0,1],[1,1,1,1,1,1,1,0,1,1,0,1],[1,1,1,1,1,1,0,0,1,0,0,0],[1,1,0,0,0,1,0,0,0,1,0,0],[0,0,1,1,0,1,0,1,0,1,0,0],[0,1,0,0,1,0,0,0,1,1,1,1],[0,0,0,0,0,0,0,0,1,1,1,1],[1,1,1,0,0,0,1,0,1,0,1,0],[1,0,1,1,0,1,1,0,1,0,1,0],[0,1,1,0,1,0,0,1,0,1,0,0],[0,1,1,0,1,1,1,0,0,1,0,0],[1,1,1,0,0,1,1,1,0,1,0,1],[1,0,1,0,0,0,0,1,1,1,0,1],[1,1,1,1,0,0,0,0,1,1,0,0],[0,1,1,0,0,1,0,1,0,0,1,1],[1,1,1,0,0,1,1,0,0,1,1,1],[0,0,0,1,0,0,0,0,0,1,0,0],[1,0,0,0,1,1,0,0,0,1,1,1],[0,1,0,1,0,0,0,0,1,1,1,1],[1,1,0,0,1,0,1,1,1,1,0,0],[1,0,0,1,0,0,0,0,1,1,1,1],[1,1,0,1,0,1,1,1,0,1,1,0],[1,0,0,1,1,1,0,1,0,1,0,1],[0,0,1,1,0,0,1,1,0,1,1,1],[1,1,1,0,1,0,1,1,0,0,0,1],[0,1,1,0,0,0,0,1,1,1,0,0],[1,0,1,1,0,0,1,0,0,1,0,0],[0,1,1,1,0,0,0,1,0,1,1,1],[0,0,0,0,0,1,1,0,1,1,1,0],[0,1,1,1,0,1,0,0,0,1,1,1],[0,1,1,1,0,0,1,0,1,0,1,1],[0,0,1,1,1,1,0,1,1,0,1,0],[1,0,1,1,0,0,1,0,0,0,1,1],[0,0,1,0,0,0,1,0,1,1,1,0],[0,0,1,1,0,0,0,1,1,0,1,1],[0,1,0,0,1,0,0,1,1,1,1,1],[1,1,1,1,0,0,1,0,1,0,0,1],[1,1,0,1,1,1,1,1,1,0,0,1],[1,1,0,1,1,1,0,1,0,1,1,0],[1,1,1,0,0,0,1,1,0,0,1,0],[0,0,0,0,1,0,1,0,1,1,0,0],[0,1,0,1,0,1,1,0,1,1,0,1],[1,0,0,1,1,0,1,1,1,1,1,0],[0,1,0,1,1,0,0,1,1,0,0,1],[0,0,1,1,0,0,0,1,0,1,1,1],[0,1,0,1,0,1,1,1,1,0,0,1],[0,1,1,0,1,1,0,0,1,1,0,0],[1,1,1,1,0,0,1,1,0,0,0,0],[0,1,1,1,1,0,0,0,0,0,1,1],[1,0,1,0,1,0,1,1,1,1,1,0],[0,1,1,0,0,0,1,0,0,0,1,0],[0,0,0,0,0,1,1,1,0,1,0,0],[0,1,1,1,1,1,1,0,0,0,1,0],[1,1,1,0,1,1,1,1,0,0,1,1],[0,1,1,1,1,0,1,0,1,0,0,0],[0,0,0,1,1,0,0,1,1,0,1,0],[1,1,1,0,0,1,1,0,1,0,1,0],[0,1,1,0,0,0,1,0,1,0,0,0],[1,1,0,0,0,0,1,0,0,0,0,0],[1,0,0,1,0,1,1,1,1,0,0,1],[1,0,0,0,0,1,1,0,1,1,0,0],[1,0,1,1,0,0,1,0,0,1,1,1],[1,0,0,0,1,0,0,0,0,0,0,1],[0,1,0,1,0,0,0,1,0,0,0,1],[0,0,1,1,0,1,0,1,1,0,0,1],[1,1,0,1,0,1,1,0,1,0,0,0],[1,0,1,1,1,0,0,0,1,0,1,1],[1,0,1,1,0,1,0,0,0,0,0,0],[0,1,0,0,0,0,1,0,0,1,1,0],[0,0,1,1,0,1,0,0,0,0,1,0],[1,0,0,0,1,1,0,0,1,0,0,1],[0,0,0,0,1,0,1,0,0,0,0,1],[1,0,1,0,0,0,0,1,1,1,1,1],[1,1,0,0,0,0,1,0,1,0,0,1],[1,1,0,1,0,1,0,0,0,1,1,1],[1,0,1,1,0,1,0,0,0,0,1,1],[1,1,1,1,1,1,1,1,0,1,0,0],[1,1,1,0,0,0,1,0,0,0,1,0],[1,0,0,0,0,0,1,1,1,0,1,1],[0,0,0,1,0,0,0,1,0,0,1,0],[1,0,0,0,1,0,1,0,0,1,1,0],[1,0,0,1,1,0,1,1,0,1,1,0],[0,1,1,1,0,1,0,1,1,0,1,1],[1,0,1,1,0,1,0,0,0,0,1,0],[0,0,0,1,0,0,1,1,1,1,1,0],[1,1,1,1,0,1,1,1,1,1,1,0],[0,0,0,1,0,0,0,0,1,0,1,1],[0,1,1,1,0,0,1,0,1,0,0,1],[1,0,1,0,1,0,1,0,0,0,0,1],[1,1,0,1,1,0,0,0,1,0,1,1],[0,0,0,0,0,1,0,1,0,0,0,1],[0,0,1,0,0,0,1,0,0,1,1,0],[1,0,1,1,0,0,0,0,0,1,1,1],[1,0,0,0,1,0,1,1,1,1,1,1],[1,0,0,0,0,0,0,1,0,1,0,1],[1,1,1,1,0,0,0,1,0,1,0,0],[0,1,0,0,0,1,1,0,0,0,1,0],[1,1,0,0,0,1,0,0,1,0,0,1],[0,0,0,1,0,0,0,1,1,1,1,1],[0,1,0,1,1,0,1,1,1,1,0,1],[1,1,1,1,1,1,1,1,0,1,1,1],[1,0,0,0,1,1,0,1,1,1,1,0],[0,0,1,0,1,1,0,1,1,1,1,0],[0,1,0,1,1,0,0,0,1,0,1,1],[0,1,0,1,0,0,0,0,1,0,1,0],[0,0,1,1,0,1,1,0,1,0,1,1],[1,1,0,1,1,0,1,1,1,1,1,0],[1,1,0,1,0,1,0,1,0,0,1,0],[1,1,1,0,1,0,0,1,1,0,0,1],[0,0,0,0,0,1,0,0,0,0,1,0],[1,0,0,1,0,0,1,1,0,1,1,0],[1,0,0,1,1,0,1,0,0,0,1,0],[0,0,1,1,0,1,1,1,0,1,1,1],[0,0,1,1,1,0,1,0,1,0,1,0],[0,0,1,1,1,0,1,0,1,0,1,1],[0,1,1,1,0,1,1,0,0,0,1,0],[1,0,1,1,0,1,0,0,1,0,1,0],[1,1,0,1,0,0,0,1,1,1,0,1],[1,1,0,0,1,0,1,0,1,1,0,0],[0,1,0,0,1,0,0,1,1,1,0,1],[0,0,0,1,0,1,0,1,1,1,1,1],[0,1,0,1,1,1,1,0,0,0,1,1],[0,0,1,1,1,1,1,0,1,0,1,1],[1,0,0,0,0,0,1,1,0,0,0,1],[1,1,0,1,0,1,0,1,1,1,1,0],[0,0,0,0,0,0,0,1,0,1,1,1],[0,0,0,0,1,0,1,0,1,1,0,1],[0,0,0,1,1,1,0,1,0,1,0,0],[0,0,1,1,0,0,0,0,0,0,0,1],[1,1,1,0,1,1,0,1,1,1,0,1],[1,1,0,0,0,1,1,1,0,1,1,0],[1,1,1,0,1,0,1,0,1,1,1,1],[1,0,1,1,0,1,0,1,1,1,0,0],[0,1,0,0,0,0,1,0,1,0,1,0],[0,1,1,1,1,1,0,0,0,0,1,0],[0,0,0,1,0,0,1,0,0,1,1,0],[1,0,0,0,1,1,0,1,1,1,0,0],[0,1,0,1,1,0,0,1,1,1,0,1],[0,1,1,0,0,1,0,0,1,0,1,1],[0,0,1,0,0,1,0,1,0,1,1,1],[1,0,1,1,0,0,1,0,1,0,1,1],[1,0,1,0,0,0,1,1,0,1,1,1],[0,1,0,0,0,0,0,1,1,1,1,1],[1,0,1,0,1,1,1,1,1,1,0,0],[1,0,0,1,0,0,1,0,0,0,0,1],[1,1,1,0,1,1,1,1,0,0,0,0],[0,0,1,1,0,0,1,1,0,0,1,1],[1,1,0,0,1,1,1,0,0,0,0,0],[1,1,1,1,0,1,1,0,0,1,0,1],[0,1,1,1,0,0,0,1,0,0,1,0],[0,1,0,0,0,1,1,0,0,0,0,1],[1,1,0,0,0,1,1,0,0,0,1,1],[0,0,0,0,0,0,0,0,1,1,0,0],[0,1,0,1,0,1,1,1,0,1,0,0],[1,1,0,0,1,1,0,1,0,0,0,1],[0,0,0,1,1,0,0,0,1,1,0,0],[1,0,1,1,0,1,0,0,0,1,1,0],[0,0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,1,0,1,0,0,1,1,1],[0,0,1,1,1,1,1,1,1,1,0,0],[0,1,0,1,1,0,0,1,0,0,0,0],[0,0,0,1,1,0,0,0,0,0,0,0],[0,1,1,0,1,1,1,1,0,1,0,1],[0,0,0,1,0,1,0,0,0,1,1,0],[0,0,1,1,0,1,0,1,1,0,0,0],[1,0,0,0,1,1,1,0,0,0,1,0],[1,0,1,1,0,0,0,1,0,0,0,0],[0,0,1,0,1,1,0,0,1,1,0,0],[0,0,1,1,1,0,0,1,0,1,1,0],[0,0,0,1,0,0,0,0,0,1,1,0],[1,0,0,1,1,0,1,1,1,0,0,0],[1,1,0,1,0,1,1,1,0,0,0,1],[1,0,1,0,0,0,0,0,1,0,0,0],[1,0,0,1,0,1,0,0,0,0,1,1],[1,0,1,0,1,0,1,0,1,0,1,0],[1,0,1,1,1,1,0,0,1,1,0,1],[1,1,0,0,0,1,1,0,0,1,1,0],[0,1,1,1,1,0,1,0,1,1,1,0],[1,1,0,0,1,1,1,0,0,1,0,0],[0,1,1,1,0,1,1,0,1,0,0,1],[0,1,0,0,0,1,1,1,1,1,0,1],[1,1,0,1,0,1,0,0,0,1,0,1],[1,1,1,1,0,0,0,0,1,0,1,0],[1,0,1,0,0,1,0,0,1,0,1,1],[1,0,1,0,1,1,1,0,1,1,1,1],[1,1,0,0,1,1,1,0,1,1,1,0],[1,0,1,0,1,0,0,1,1,0,1,0],[0,0,1,0,1,0,0,1,1,1,0,1],[1,1,1,1,1,1,1,1,1,0,0,1],[0,1,1,0,0,0,0,1,0,0,1,1],[1,1,1,0,1,0,0,0,1,1,0,1],[0,0,1,0,1,0,1,1,0,1,0,1],[0,1,1,0,0,1,0,0,0,0,0,0],[0,1,0,0,1,0,1,1,0,0,1,0],[1,0,0,1,1,1,0,0,1,0,0,1],[0,1,0,0,1,0,0,0,0,1,1,1],[1,0,0,1,0,0,1,1,0,0,0,1],[0,0,0,1,1,0,0,1,0,1,1,1],[1,1,1,0,0,0,0,0,0,0,0,1],[1,0,0,1,1,1,1,1,1,1,1,1],[1,0,0,1,0,0,0,1,1,1,1,1],[0,1,1,0,1,1,1,0,1,0,1,1],[1,1,1,1,0,0,0,1,0,0,1,1],[0,0,1,0,1,0,0,1,0,1,0,1],[1,0,0,0,0,1,1,1,0,1,1,0],[0,0,0,1,0,1,0,1,0,0,1,1],[1,1,0,1,1,0,0,1,1,1,1,0],[1,1,0,0,1,0,1,1,0,0,0,0],[1,1,0,1,0,1,0,0,1,0,0,1],[1,1,0,1,1,1,1,0,1,0,0,1],[1,1,0,0,0,1,1,0,1,0,1,1],[1,0,1,1,1,0,1,1,1,0,1,1],[1,0,1,1,0,0,0,1,0,0,1,1],[1,1,1,0,0,0,1,0,1,1,0,1],[1,0,0,1,0,1,1,0,1,1,0,0],[1,1,1,0,0,0,1,0,1,0,0,0],[1,0,1,0,1,1,0,1,1,1,1,0],[0,1,1,0,0,0,1,0,0,0,0,0],[1,1,1,0,1,1,0,0,1,1,0,0],[0,1,0,1,1,0,1,1,0,1,1,1],[0,0,1,1,0,1,0,0,1,0,0,0],[0,1,1,0,1,1,0,0,0,1,1,0],[1,0,0,1,0,0,1,0,1,1,0,0],[0,1,1,0,1,1,1,0,1,1,1,1],[1,0,0,0,0,0,0,1,0,0,0,0],[1,1,0,1,1,0,1,0,1,1,0,0],[1,1,1,1,0,1,1,0,1,1,0,1],[1,0,1,1,1,1,0,1,1,0,0,0],[1,0,0,1,1,0,0,1,1,0,1,0],[1,1,0,1,0,1,0,1,0,1,1,0],[1,1,0,1,1,0,0,1,0,1,1,0],[0,0,0,1,0,1,0,0,0,0,1,0],[0,1,0,1,0,0,1,0,0,0,0,0],[1,0,0,1,1,0,0,1,1,1,1,1],[1,0,0,0,1,1,1,0,0,0,0,0],[1,1,1,0,0,0,0,0,0,0,1,1],[0,1,1,1,1,1,0,1,0,0,0,1],[1,1,1,0,1,1,1,1,0,1,0,1],[1,1,0,1,0,0,0,0,1,1,0,1],[0,0,0,0,0,1,0,0,1,1,0,1],[0,1,0,1,1,1,0,1,0,1,0,0],[1,1,0,1,1,0,0,1,1,0,0,0],[1,1,1,1,0,1,1,0,1,0,1,1],[1,0,1,0,1,1,1,1,0,0,1,0],[1,1,1,0,1,0,0,0,1,0,0,0],[0,0,1,1,1,1,1,1,0,1,1,1],[1,1,0,1,0,1,0,0,0,0,0,1],[1,0,1,1,0,1,1,0,1,0,0,1],[1,1,0,1,0,0,0,0,1,0,0,1],[1,1,0,1,0,0,1,1,1,1,1,1],[1,1,1,0,1,1,0,0,0,0,0,1],[0,0,1,0,0,0,1,1,0,0,0,0],[1,1,1,0,0,1,1,0,0,1,1,0],[0,0,0,1,0,0,1,1,1,1,0,0],[0,1,0,1,0,1,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0,0],[0,0,1,1,1,1,1,1,0,0,1,0],[0,1,1,0,1,0,0,0,1,0,1,0],[0,0,0,1,1,1,0,1,1,1,0,0],[0,0,1,0,0,0,0,0,0,1,1,1],[1,1,0,1,0,1,0,1,0,1,0,0],[0,1,0,1,1,0,0,1,0,1,1,1],[1,0,0,1,0,1,1,1,0,0,1,1],[0,0,0,1,0,1,0,0,0,1,0,0],[1,0,0,1,0,1,0,1,1,1,0,1],[0,1,0,1,0,0,1,0,0,0,0,1],[0,1,1,0,0,1,1,0,0,1,1,1],[0,1,0,1,0,1,0,0,1,1,1,1],[1,1,0,0,1,1,1,0,0,0,1,0],[0,1,0,1,0,0,0,0,1,1,1,0],[0,0,0,0,1,0,1,0,1,0,0,0],[0,0,1,0,1,1,1,0,1,0,0,0],[0,0,1,0,0,0,0,1,1,0,1,0],[0,0,1,1,0,0,1,0,1,0,1,1],[0,1,1,1,1,0,1,1,1,0,0,0],[1,1,0,1,0,0,0,0,0,1,0,0],[1,0,1,0,1,1,0,0,1,0,1,0],[1,1,1,0,1,1,0,1,0,1,0,1],[0,1,0,0,1,1,1,0,1,0,1,1],[0,0,1,1,1,1,1,1,1,0,0,1],[0,0,0,1,0,1,0,1,0,1,1,1],[0,1,1,1,0,0,1,0,0,0,1,0],[1,1,1,1,0,1,0,1,1,1,0,1],[0,1,1,0,1,0,1,1,1,0,0,1],[1,0,1,1,1,0,1,0,1,1,1,0],[1,0,1,0,1,1,1,1,1,1,1,1],[0,1,1,1,0,0,0,1,1,1,0,1],[0,1,1,0,0,1,0,1,1,1,1,0],[0,0,0,1,0,0,0,1,1,0,1,0],[0,1,0,1,0,0,1,0,1,1,1,0],[0,1,0,0,0,0,0,0,1,0,1,1],[1,0,0,0,0,1,0,1,1,1,1,0],[0,0,0,0,1,1,1,0,1,0,1,0],[0,1,0,1,0,1,1,0,0,0,0,0],[0,0,1,0,0,0,0,1,0,0,1,0],[0,0,1,1,0,0,0,1,1,1,1,1],[1,0,0,1,1,1,1,1,0,1,0,1],[0,1,1,1,0,1,1,0,0,1,0,0],[1,0,1,1,0,1,1,1,0,0,0,1],[0,0,0,1,1,0,0,1,0,0,0,1],[0,0,1,1,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,1,0,1,0],[1,0,1,1,0,1,0,1,0,1,0,0],[1,1,1,1,0,1,1,1,0,0,1,1],[0,1,0,0,1,1,0,0,1,0,0,0],[0,0,0,0,1,1,0,0,0,0,0,1],[1,1,0,1,1,0,0,0,0,1,1,0],[0,1,1,0,1,1,1,0,1,1,0,0],[0,1,0,0,1,1,1,1,1,0,1,1],[0,0,1,1,0,1,0,1,0,0,1,1],[1,1,1,0,0,0,0,0,1,1,0,0],[1,1,1,1,0,0,0,1,0,1,1,1],[1,1,1,0,0,0,1,0,0,1,0,0],[0,0,0,0,1,1,1,1,1,1,0,0],[0,0,0,0,1,1,1,1,1,0,0,0],[0,0,0,0,0,0,1,0,1,1,1,0],[0,0,1,0,0,1,0,0,0,0,1,0],[1,0,1,0,1,1,0,1,1,0,0,0],[0,1,0,1,1,0,1,1,1,1,1,1],[1,0,0,0,0,1,0,0,0,0,1,0],[1,1,1,0,0,1,0,1,0,0,1,0],[0,1,0,1,1,0,0,0,0,1,1,0],[0,1,0,0,0,1,1,1,1,1,1,1],[1,1,0,1,0,1,0,0,1,1,1,1],[1,0,0,0,0,1,1,0,0,1,0,0],[1,0,0,1,0,0,0,1,1,0,1,1],[1,0,0,1,0,0,1,0,0,0,1,0],[1,1,0,1,1,0,0,0,1,1,0,1],[1,0,1,0,0,1,0,1,1,0,0,0],[1,0,1,1,0,0,1,0,0,1,0,1],[1,1,1,0,0,1,0,0,0,0,0,1],[1,0,0,1,0,0,0,0,0,0,0,0],[1,0,1,0,0,1,0,1,1,1,1,0],[1,0,0,1,1,0,1,1,1,0,1,0],[1,1,1,1,0,1,0,1,1,0,1,0],[0,1,0,1,1,0,0,1,1,1,1,1],[0,0,0,0,0,1,0,1,0,1,1,1],[1,0,1,0,0,0,0,1,1,0,1,0],[0,0,0,1,1,1,0,1,1,0,1,1],[1,0,1,0,0,0,0,0,1,0,0,1],[0,1,0,0,1,0,0,0,0,0,1,0],[1,1,1,1,1,0,1,0,0,1,0,0],[0,0,0,1,0,0,1,1,0,0,0,1],[0,0,1,1,0,1,1,1,1,0,1,1],[0,0,0,1,1,0,1,1,0,0,0,1],[1,0,1,1,1,1,1,1,1,1,0,0],[1,1,1,1,1,0,1,1,0,1,0,1],[0,0,0,0,1,0,0,1,1,1,0,1],[1,0,0,0,0,1,1,0,0,1,1,0],[0,0,1,0,1,1,0,0,0,1,1,0],[1,1,1,1,0,0,0,0,0,0,0,1],[1,0,0,1,1,1,1,0,1,0,0,0],[0,0,1,0,0,1,1,0,1,0,1,1],[0,1,1,1,0,0,1,1,1,1,1,1],[1,1,0,0,0,1,0,1,0,1,0,0],[1,1,0,0,0,0,0,1,1,1,1,0],[1,0,0,1,0,1,1,1,1,1,0,1],[1,0,1,0,0,0,1,1,1,0,0,0],[0,1,0,1,1,0,0,0,1,0,1,0],[0,0,0,1,0,0,1,0,0,1,0,1],[0,0,1,0,1,1,0,1,1,1,0,1],[1,0,0,1,1,0,1,0,0,1,0,0],[0,0,0,0,1,1,0,1,1,1,1,0],[0,1,1,1,0,1,1,1,1,0,0,0],[0,0,1,1,1,0,1,0,1,0,0,0],[0,1,1,0,1,0,1,0,1,0,0,1],[0,1,0,0,0,0,1,0,0,1,0,0],[0,1,0,0,0,0,1,0,0,1,0,1],[1,1,1,1,1,0,0,1,1,1,0,0],[1,1,0,0,1,0,0,0,0,1,1,0],[0,0,0,1,0,0,1,1,1,1,0,1],[1,0,0,0,1,1,1,0,1,1,0,0],[1,1,1,1,0,1,1,1,1,0,1,0],[1,1,0,1,1,1,1,1,1,1,0,1],[0,1,0,1,0,0,0,0,0,0,1,1],[1,1,1,1,1,0,0,1,0,0,0,0],[1,0,1,0,0,1,0,1,1,1,0,1],[0,0,0,0,0,0,0,0,0,0,1,0],[1,0,0,1,0,0,0,0,1,0,1,0],[0,1,0,1,0,0,0,1,1,1,0,1],[0,1,1,1,1,1,1,1,0,0,0,1],[1,1,0,1,1,0,1,0,1,0,1,1],[0,0,1,1,0,0,1,0,1,1,0,0],[1,0,1,1,0,1,1,0,1,0,0,0],[1,0,0,0,0,1,0,0,0,0,0,0],[0,1,1,1,0,0,0,1,0,0,1,1],[0,0,1,0,1,1,1,1,1,1,1,1],[0,1,0,0,0,1,1,1,0,1,0,1],[0,0,0,1,0,0,0,0,0,1,0,1],[0,0,0,1,1,1,0,1,0,0,1,0],[0,0,0,0,1,1,1,0,1,1,1,1],[0,1,0,0,0,1,1,0,0,1,0,1],[0,0,0,1,1,0,0,1,0,1,0,0],[0,1,1,1,0,0,1,0,0,0,0,1],[1,1,1,1,1,0,1,1,0,1,0,0],[0,1,1,1,0,0,0,1,0,1,0,0],[0,1,1,1,1,1,1,0,0,1,0,0],[0,1,0,0,0,1,0,0,1,1,1,0],[0,1,1,0,0,0,0,1,1,0,0,1],[0,1,0,1,0,1,1,0,0,0,1,0],[1,0,0,1,1,0,0,0,0,1,0,0],[0,1,1,1,1,1,0,0,1,1,0,1],[0,0,1,1,0,1,0,0,1,1,1,1],[1,0,0,1,1,1,0,0,0,0,0,0],[0,0,1,0,1,1,1,1,0,0,1,0],[1,1,0,0,0,0,1,0,1,0,1,1],[0,1,0,0,0,1,1,0,0,1,1,0],[1,1,1,0,0,0,0,1,1,1,0,1],[1,0,0,0,1,0,1,1,0,0,1,0],[0,1,0,1,1,0,0,1,0,1,1,0],[0,0,0,0,1,0,1,1,0,1,1,0],[1,0,0,1,0,0,1,0,1,0,0,1],[0,1,1,0,1,0,0,1,0,1,1,0],[1,1,1,0,1,0,1,0,1,1,0,0],[1,1,1,0,0,1,1,1,0,0,1,1],[0,1,0,0,1,0,0,0,0,1,1,0],[0,1,0,1,1,1,1,1,1,0,0,0],[1,1,1,0,0,1,0,1,0,0,1,1],[0,0,1,1,0,0,1,0,0,0,1,1],[1,1,1,1,0,0,1,1,1,0,1,0],[1,1,1,0,1,1,1,1,1,1,1,0],[0,0,0,1,0,1,1,1,0,0,0,1],[0,0,0,1,0,1,1,1,1,0,1,0],[1,0,1,1,1,1,1,0,0,1,0,1],[0,0,0,1,0,0,0,0,1,0,1,0],[0,1,1,1,1,1,0,1,0,1,0,1],[1,0,0,1,0,0,0,1,1,1,1,0],[0,1,1,0,1,0,0,1,0,0,1,0],[1,0,1,1,1,1,1,0,0,1,1,1],[1,1,0,1,0,0,1,0,0,1,1,0],[0,0,1,0,0,1,0,1,0,1,0,0],[1,1,1,1,0,0,0,0,0,0,1,0],[0,0,0,0,1,0,0,1,1,1,0,0],[0,1,0,1,1,1,0,1,1,1,0,0],[1,1,1,1,0,1,0,0,1,0,0,1],[1,1,1,1,1,1,1,1,0,1,1,0],[0,0,0,0,1,0,1,1,1,0,0,1],[1,1,0,0,1,1,1,1,1,1,1,1],[0,0,1,0,0,0,1,0,1,1,0,0],[1,1,1,1,1,1,0,1,0,0,1,1],[1,0,1,0,1,0,1,1,0,0,1,0],[1,1,0,1,1,1,0,0,0,0,0,0],[0,1,1,0,1,0,1,0,0,1,0,0],[1,0,0,1,1,1,0,1,0,0,0,1],[1,0,0,1,0,0,1,1,0,0,1,1],[0,0,1,0,1,1,1,1,1,0,0,1],[1,1,1,1,0,0,1,0,0,0,1,1],[1,1,1,0,1,1,0,1,1,1,1,1],[1,1,0,0,0,0,0,0,0,1,1,0],[1,0,0,1,0,1,0,1,1,1,1,1],[1,0,0,0,0,1,0,1,1,1,1,1],[0,1,0,0,0,1,1,0,0,1,1,1],[0,0,0,0,0,1,1,1,0,0,1,0],[0,0,1,0,0,1,1,1,0,0,1,0],[0,1,0,0,0,0,1,1,0,1,1,1],[1,1,0,0,1,0,0,1,1,0,1,1],[1,0,1,1,1,0,1,1,1,1,1,1],[1,0,0,0,1,1,1,1,0,1,1,0],[1,0,0,1,1,0,0,1,0,1,1,0],[0,0,1,1,1,0,1,0,1,1,1,1],[1,1,1,1,1,0,0,1,0,0,1,1],[1,1,1,0,0,0,0,1,1,1,0,0],[1,0,1,1,0,1,0,1,1,0,0,1],[1,0,0,0,0,0,1,0,1,1,1,1],[0,1,1,0,0,1,0,0,0,0,0,1],[1,1,0,0,0,1,0,0,0,1,1,0],[1,0,1,0,1,1,1,0,1,1,0,1],[0,1,1,0,0,0,1,1,0,1,1,0],[0,0,1,1,1,0,0,0,1,1,1,0],[0,0,1,0,0,1,1,1,1,1,0,1],[1,1,1,1,1,1,1,1,1,1,1,1],[1,0,1,0,1,1,1,0,1,1,0,0],[0,0,0,0,0,1,0,1,1,1,0,1],[1,1,1,0,0,0,0,1,0,0,0,0],[0,0,1,1,1,0,0,1,0,0,1,1],[1,0,1,1,0,1,0,0,0,1,1,1],[0,0,1,1,0,1,0,1,1,1,0,1],[0,0,1,0,1,0,1,1,0,0,1,1],[0,1,1,1,0,1,1,1,0,0,1,1],[0,0,1,0,1,0,1,0,1,0,0,0],[0,0,0,1,0,0,0,0,1,1,0,1],[0,1,0,1,1,0,0,0,0,0,1,1],[0,0,0,0,0,1,0,1,0,1,0,1],[1,0,1,0,1,1,1,1,0,0,0,1],[1,1,1,0,1,0,0,1,0,1,0,1],[0,0,1,1,1,0,1,0,0,0,0,0],[0,0,0,0,1,1,1,0,0,0,0,1],[1,1,0,0,0,1,1,1,0,1,1,1],[0,1,1,0,1,1,1,1,0,1,1,1],[1,1,0,1,0,0,1,0,1,0,1,1],[1,1,0,1,1,1,0,1,1,1,1,0],[0,0,1,1,1,1,0,1,1,0,0,1],[0,0,1,1,1,1,0,0,0,1,1,1],[1,1,1,1,0,0,0,1,0,1,0,1],[1,1,0,0,0,0,0,1,1,0,1,0],[1,1,1,0,0,0,1,0,1,1,1,1],[0,1,1,1,0,0,0,0,1,1,0,0],[1,0,1,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,1,1,0,0,1,1],[1,0,1,0,0,1,1,1,1,1,0,1],[1,0,0,0,1,0,1,0,1,1,1,0],[0,1,0,0,0,1,0,1,0,1,0,0],[1,1,0,1,1,1,1,0,0,0,1,0],[0,0,1,1,0,0,1,0,0,1,0,0],[0,1,0,0,0,0,0,1,1,1,0,0],[1,1,1,0,1,0,1,1,1,1,1,1],[1,0,1,1,1,1,1,0,1,1,0,1],[1,0,1,0,1,0,0,1,1,0,0,0],[0,0,1,0,0,1,0,1,1,0,0,1],[1,0,0,1,0,0,0,0,1,1,1,0],[1,0,0,0,0,0,1,1,0,1,1,0],[1,0,0,1,1,0,0,0,1,0,1,0],[0,1,0,0,1,0,0,1,1,0,0,1],[0,1,0,1,0,1,1,0,1,0,1,1],[0,1,0,0,0,0,0,0,1,1,1,1],[1,0,1,1,1,1,1,0,1,1,1,1],[1,0,1,0,0,0,1,1,1,0,1,1],[1,1,1,1,0,0,1,1,1,1,1,1],[1,0,1,1,1,0,0,0,1,0,0,1],[0,0,1,0,1,1,0,0,0,0,1,1],[1,1,0,0,0,0,1,0,0,1,0,1],[0,1,1,1,0,0,1,0,0,1,1,0],[0,0,0,0,1,0,1,0,0,1,0,1],[0,1,1,0,0,1,1,1,0,1,1,0],[1,1,1,1,0,1,0,0,0,0,1,0],[0,1,0,0,1,1,1,1,1,1,1,0],[0,1,1,1,0,0,1,1,1,1,0,0],[1,0,1,1,1,1,0,0,0,0,0,1],[0,1,0,1,1,0,1,1,1,0,1,1],[0,1,1,0,1,0,1,1,0,0,1,0],[0,0,1,0,0,1,1,0,0,1,1,0],[0,1,1,1,0,1,1,0,0,1,1,0],[0,0,1,1,1,0,0,0,0,1,1,0],[1,1,1,0,1,1,1,1,1,1,1,1],[0,0,0,0,1,1,0,1,0,0,1,1],[0,0,0,1,1,0,0,0,1,1,1,0],[1,0,1,0,0,1,0,0,1,0,0,0],[1,1,0,1,1,1,0,1,0,0,0,1],[0,0,0,1,1,1,1,1,1,0,0,0],[1,1,1,1,1,1,1,0,1,0,1,1],[0,0,0,0,0,1,1,1,0,1,1,0],[1,0,1,0,1,1,0,1,0,1,0,0],[0,0,1,0,1,0,1,1,0,1,0,0],[0,1,1,0,0,0,1,0,1,0,1,1],[0,0,1,1,1,1,0,1,0,0,0,1],[1,1,0,0,1,1,0,1,0,1,0,0],[1,0,0,1,0,1,1,1,1,0,1,1],[1,0,0,1,1,0,0,1,0,1,0,0],[0,0,0,1,1,0,0,0,0,0,1,1],[1,1,1,1,1,1,0,0,0,0,0,0],[0,0,1,1,1,1,1,0,0,0,0,0],[0,0,0,1,0,1,1,0,1,0,1,0],[1,0,1,0,0,0,0,1,1,1,1,0],[0,1,1,1,0,1,0,1,0,1,0,0],[1,0,1,0,0,1,0,1,1,0,1,0],[1,0,1,0,1,0,1,0,0,0,0,0],[1,1,1,0,1,1,1,1,1,1,0,1],[1,0,0,1,0,1,0,0,1,0,0,0],[0,1,0,1,0,0,1,1,1,1,1,0],[1,1,0,1,0,0,0,1,0,1,0,1],[0,0,0,0,0,1,0,1,1,0,1,1],[1,1,0,1,0,1,0,0,0,0,1,0],[1,0,1,1,0,0,0,0,0,0,1,1],[1,0,0,1,0,1,0,0,0,1,0,0],[0,1,1,0,1,1,1,0,1,0,1,0],[1,1,1,1,1,0,0,1,0,1,0,0],[0,0,0,1,0,0,1,0,1,1,1,1],[0,1,1,1,1,1,1,0,1,0,1,0],[0,1,1,0,1,1,0,0,0,1,1,1],[0,1,1,0,0,1,1,0,0,1,0,0],[1,0,1,1,1,0,1,1,1,0,0,0],[1,1,1,1,0,0,0,0,1,1,1,1],[0,0,0,1,1,1,1,1,0,0,1,0],[0,0,0,0,1,0,0,1,0,1,1,1],[0,0,1,0,1,0,0,0,1,0,1,0],[0,1,0,0,1,0,0,0,1,1,0,1],[1,1,0,0,1,1,1,0,1,0,0,0],[0,0,0,1,1,0,1,1,1,1,0,0],[1,1,0,1,0,1,1,0,1,0,0,1],[1,0,1,0,0,0,0,0,0,1,0,0],[1,1,0,0,0,0,0,0,1,1,0,1],[1,0,0,1,0,0,1,1,1,0,0,0],[1,0,1,1,0,0,0,0,0,1,0,1],[1,1,0,0,1,1,0,0,1,1,1,1],[0,1,0,0,1,1,0,0,1,1,0,1],[1,0,0,1,1,1,0,0,0,1,1,0],[0,0,1,1,1,1,1,1,1,0,1,0],[0,0,0,0,0,0,0,0,0,1,0,1],[0,0,0,0,1,1,0,0,0,0,0,0],[1,1,1,0,1,1,1,0,1,1,1,0],[1,1,1,1,1,0,1,0,1,0,0,1],[1,1,0,0,0,0,1,0,1,0,1,0],[1,1,0,1,1,1,1,0,1,1,0,1],[0,1,0,1,1,1,1,1,0,0,1,1],[0,0,0,1,0,1,1,1,0,1,1,1],[0,1,0,1,1,1,0,1,0,1,1,1],[0,1,1,0,1,1,1,1,1,1,1,0],[1,0,1,1,0,1,0,0,0,0,0,1],[1,0,1,0,0,0,1,0,1,1,0,1],[1,0,1,1,0,0,1,0,0,0,0,0],[1,0,0,1,0,0,0,0,0,1,0,0],[0,0,1,0,0,0,0,1,0,1,0,1],[1,1,0,0,0,0,0,0,1,0,0,1],[0,1,0,1,1,1,1,1,1,1,0,1],[1,0,0,0,0,1,1,0,1,0,1,1],[1,1,0,0,1,1,1,1,0,1,1,0],[1,0,0,1,1,0,1,0,1,0,1,1],[0,1,1,0,0,1,1,1,1,0,1,0],[1,0,1,0,0,0,0,0,1,0,1,1],[0,1,1,0,0,1,1,0,1,1,1,1],[1,0,1,0,1,1,1,0,0,1,1,1],[0,0,1,0,1,1,0,1,0,0,0,0],[1,1,1,1,0,0,1,1,1,0,0,0],[1,1,1,0,0,1,0,0,1,0,0,1],[0,1,0,0,0,1,0,1,1,0,0,0],[1,0,1,0,1,0,1,1,0,1,0,1],[0,0,1,1,1,1,0,0,1,1,0,1],[0,0,0,0,0,0,1,1,1,0,0,0],[0,1,0,1,1,1,0,0,1,1,1,0],[1,1,0,1,0,0,0,1,0,0,0,0],[1,1,1,1,0,1,1,1,1,1,0,0],[0,0,0,0,0,0,0,0,1,1,0,1],[1,1,0,0,1,0,0,0,1,0,1,1],[1,1,0,0,0,0,1,1,1,1,0,0],[1,0,1,0,1,0,0,0,0,1,1,0],[1,0,1,0,1,1,0,1,1,1,1,1],[1,0,1,0,0,0,0,1,1,0,1,1],[0,0,1,0,0,1,1,1,0,0,1,1],[0,0,1,0,1,1,1,1,1,1,0,0],[1,0,0,1,1,0,0,0,1,0,0,1],[1,0,1,0,0,0,0,1,1,0,0,0],[0,1,1,1,0,0,1,1,0,1,0,1]
    ]
