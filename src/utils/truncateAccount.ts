const maxLength = '0x0000…0000'.length;

export default function truncateAccount(account: string): string {
  if (!account.startsWith('0x') || account.length < maxLength) {
    return account;
  }
  return `${account.substr(0, 6)}…${account.substr(account.length - 4)}`;
}
