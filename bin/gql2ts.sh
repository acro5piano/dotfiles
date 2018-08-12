#!/usr/bin/env bash

cat "$1" \
    | perl -pe 's/^(\s*)#/\1\/\//' \
    | perl -pe 's/!//g' \
    | perl -pe 's/^input /export interface /g' \
    | perl -pe 's/^enum /export enum /g' \
    | perl -pe 's/^type /export interface /g' \
    | perl -pe 's/^union /export type /g'\
    | perl -pe 's/^schema /export interface schema /g' \
    | perl -pe 's/^(\s+[a-zA-Z0-9_-]+\s*)\([^\)]+\)(\s*:\s*)/\1\2/g' \
    | perl -pe 's/([:\=\|]\s*)\[ID!?\]!?($|\s+|\))/\1string\[\]\2/g' \
    | perl -pe 's/([:\=\|]\s*)ID!?($|\s+|\))/\1string\2/g' \
    | perl -pe 's/([:\=\|]\s*)\[String!?\]!?($|\s+|\))/\1string\[\]\2/g' \
    | perl -pe 's/([:\=\|]\s*)String!?($|\s+|\))/\1string\2/g' \
    | perl -pe 's/([:\=\|]\s*)\[Int!?\]!?($|\s+|\))/\1number\[\]\2/g' \
    | perl -pe 's/([:\=\|]\s*)Int!?($|\s+|\))/\1number\2/g' \
    | perl -pe 's/([:\=\|]\s*)\[Float!?\]!?($|\s+|\))/\1number\[\]\2/g' \
    | perl -pe 's/([:\=\|]\s*)Float!?($|\s+|\))/\1number\2/g' \
    | perl -pe 's/([:\=\|]\s*)\[Boolean!?\]!?($|\s+|\))/\1boolean[\]\2/g' \
    | perl -pe 's/([:\=\|]\s*)Boolean!?($|\s+|\))/\1boolean\2/g' \
    | perl -pe 's/\[([a-zA-Z0-9_-]+)!?\]!?/\1\[\]/'
