#!/usr/bin/env node
const fs = require('fs');
const assert = require('assert');
const Decimal = require('decimal.js');

let global_state = {
  token_a_symbol: 'USDT',
  token_b_symbol: 'DAI',
  token_a: new Decimal(0),
  token_b: new Decimal(0),
  k: new Decimal(0),
  lp_tokens_issued: new Decimal(0),
  lp_token_holders: {},
}

function lp_deposit(account, token_a, token_b) {

  // Initial deposit
  if (global_state.k.equals(0)) {
    global_state.token_a = new Decimal(token_a)
    global_state.token_b = new Decimal(token_b)
    global_state.k = global_state.token_a.mul(global_state.token_b)
    global_state.lp_token_holders[account] = new Decimal(100)
    global_state.lp_tokens_issued = global_state.lp_token_holders[account]
    return {lp_tokens: global_state.lp_token_holders[account]}
  }
  else {
    // try % of k
    token_a = new Decimal(token_a)
    token_b = new Decimal(token_b)
    let lp_tokens = global_state.lp_tokens_issued.div(token_a.mul(token_b).div(global_state.k))
    global_state.token_a = global_state.token_a.add(token_a)
    global_state.token_b = global_state.token_b.add(token_b)
    global_state.k = global_state.token_a.mul(global_state.token_b)
    global_state.lp_token_holders[account] = (global_state.lp_token_holders[account] ?? new Decimal(0)).add(lp_tokens)
    global_state.lp_tokens_issued = global_state.lp_tokens_issued.add(lp_tokens)
    return {lp_tokens: lp_tokens}
  }
}

function lp_withdraw(account, lp_tokens) {
  assert(global_state.lp_token_holders[account] >= lp_tokens)

  
}

function swap(token_symbol, token) {
  assert(token_symbol === global_state.token_a_symbol
    || token_symbol === global_state.token_b_symbol)

  token = new Decimal(token)

  let fee = new Decimal(0.997) // 0.997

  if (token_symbol === global_state.token_b_symbol) {
    let token_a = global_state.token_a.sub(global_state.k.div(global_state.token_b.add(token.mul(fee))))
    global_state.token_a = global_state.token_a.sub(token_a)
    global_state.token_b = global_state.token_b.add(token)
    global_state.k = global_state.token_a.mul(global_state.token_b)
    return {token_a: token_a, slippage: new Decimal(1).sub(token_a.div(token)).mul(100)}
  }
  else {
    let token_b = global_state.token_b.sub(global_state.k.div(global_state.token_a.add(token.mul(fee))))
    global_state.token_b = global_state.token_b.sub(token_b)
    global_state.token_a = global_state.token_a.add(token)
    global_state.k = global_state.token_a.mul(global_state.token_b)
    return {token_b: token_b, slippage: new Decimal(1).sub(token_b.div(token)).mul(100)}
  }
}

function price(token_symbol) {
  assert(token_symbol === global_state.token_a_symbol
    || token_symbol === global_state.token_b_symbol)

  if (token_symbol === global_state.token_b_symbol) {
    let token_a = global_state.token_a.sub(global_state.k.div(global_state.token_b.add(1)))
    return token_a
  }
  else {
    let token_b = global_state.token_b.sub(global_state.k.div(global_state.token_a.add(1)))
    return token_b
  }
}

function dump() {
  return global_state
}

assert(process.argv.length === 3);
const lines = fs.readFileSync(`${__dirname}/${process.argv[2]}`).toString('utf8').split('\n')
let count = 0
for (let i=0; i<lines.length; i++) {
  let line = lines[i].split(' ')
  let repeat = 1
  if (line[0] === '#') {
    continue
  }
  else if (line[0] === '%') {
    repeat = parseInt(line[1], 10)
    line = line.slice(2)
  }
  let cmds = line.join(' ').split(';').map((c => c.trim().split(' ')))
  for (let j=0; j<repeat; j++) {
    for (let k=0; k<cmds.length; k++) {
      let cmd = cmds[k]
      let quiet = true
      if (cmd[0] === '!') {
        quiet = false
        cmd = cmd.slice(1)
      }
      const res = eval(cmd[0]).call(null, ...cmd.slice(1))
      if (!quiet) console.log(`[${ count++ }] Call: ${ cmd[0] }(${ cmd.slice(1).join(', ') }): ${JSON.stringify(res ?? null, null, 2)}`)
    }
  }
}
