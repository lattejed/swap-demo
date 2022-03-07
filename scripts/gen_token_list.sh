cat ../../uniswap-default-token-list/build/uniswap-default.tokenlist.json \
  | jq '[.tokens[] | select(.chainId | tostring | test("^(1|4)$"))]' \
  > ../src/constants/token-list.json
