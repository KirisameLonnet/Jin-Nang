const toHex = (buffer: Uint8Array) =>
  Array.from(buffer).map(byte => byte.toString(16).padStart(2, '0')).join('')

function fromHex(hex: string): Uint8Array | null {
  if (hex.length === 0 || hex.length % 2 !== 0 || !/^[0-9a-f]+$/i.test(hex)) return null
  const pairs = hex.match(/.{2}/g)
  if (!pairs) return null
  return new Uint8Array(pairs.map(pair => Number.parseInt(pair, 16)))
}

function constantTimeEqual(left: Uint8Array, right: Uint8Array): boolean {
  if (left.length !== right.length) return false
  let difference = 0
  for (let index = 0; index < left.length; index++) {
    difference |= left[index] ^ right[index]
  }
  return difference === 0
}

async function derive(password: string, salt: Uint8Array): Promise<Uint8Array> {
  const key = await crypto.subtle.importKey(
    'raw', new TextEncoder().encode(password), 'PBKDF2', false, ['deriveBits'],
  )
  const bits = await crypto.subtle.deriveBits(
    { name: 'PBKDF2', salt, iterations: 100_000, hash: 'SHA-256' }, key, 256,
  )
  return new Uint8Array(bits)
}

export async function hashPassword(password: string): Promise<string> {
  const salt = crypto.getRandomValues(new Uint8Array(16))
  const hash = await derive(password, salt)
  return `${toHex(salt)}:${toHex(hash)}`
}

export async function verifyPassword(password: string, stored: string): Promise<boolean> {
  const parts = stored.split(':')
  if (parts.length !== 2) return false
  const salt = fromHex(parts[0])
  const expected = fromHex(parts[1])
  if (!salt || !expected) return false
  const actual = await derive(password, salt)
  return constantTimeEqual(actual, expected)
}
