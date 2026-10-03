-- yo, this code was written by golden
-- please do something with it
-- or don't

local primes_root_2 = {
	-- the first 32 fractional bits of the square roots of the first 8 primes
	0x6a09e667, -- math.sqrt(0x02) == 0x01.6a09e667
	0xbb67ae85, -- math.sqrt(0x03) == 0x01.bb67ae85
	0x3c6ef372, -- math.sqrt(0x05) == 0x02.3c6ef372
	0xa54ff53a, -- math.sqrt(0x07) == 0x02.a54ff53a
	0x510e527f, -- math.sqrt(0x0b) == 0x03.510e527f
	0x9b05688c, -- math.sqrt(0x0d) == 0x03.9b05688c
	0x1f83d9ab, -- math.sqrt(0x11) == 0x04.1f83d9ab
	0x5be0cd19, -- math.sqrt(0x13) == 0x04.5be0cd19
}


local primes_root_3 = {
	-- the first 32 fractional bits of the cube roots of the first 64 primes
	-- it'd be extremely cluttered if I listed all the cube roots' originating numbers
	-- just extrapolate from the primes_root_2 table if you dont understand
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

-- fills a table
-- not much to say here
function table.fill(t, value, length, start)
	start = (start == nil) and 1 or start
	length = (length == nil) and #table or length

	for i = start, start + length - 1 do
		t[i] = value
	end

	return t
end

-- Some constants that are used a lot.

local bitsInByte = 8 -- bits in a byte
local bitsInWord = bitsInByte << 1 -- words contain twice as much
local bitsInLong = bitsInWord << 1 -- long-words contain twice as much

local log2_bitsInByte = 3 -- amount to shift to convert byte length to bit length
local maskByte = (1 << bitsInByte) - 1 -- bitmask for a byte

local bytesInWord = bitsInWord >> log2_bitsInByte -- bytes-to-word factor
local bytesInLong = bitsInLong >> log2_bitsInByte -- bytes-to-longword factor

-- rotates a number's bits right
local function uint32_rotateright(int, shift)
    return (int >> shift) | (int << (bitsInLong - shift))
end

-- Note: editing these constants is not enough to convert the hashing algorithm to SHA-224, SHA-512, etc.

local chunkLen = 512 -- All SHA-256 chunks are 512 bits
local chunkLenBytes = chunkLen >> log2_bitsInByte -- and this amount of bits

local maskChunk = chunkLenBytes - 1 -- fun bitmasking
local maskChunkBits = chunkLen - 1 -- more fun bitmasking

-- This is SHA-256, to be precise.
local function sha2(message)
	-- The amount of bytes the message takes up.
	-- All messages are byte-aligned.
	local length = #message

	-- get the modulo of the message length to prevent overflow trickery when converted to bits
	local lengthmod = length & maskChunk
	local lengthmodbits = lengthmod << log2_bitsInByte -- length in bits.

	-- CALCULATE PADDING LENGTH --

	-- get the minimum bits required to pad our message plus a 1 bit to chunkLen bits.
	local k = chunkLen - ((lengthmodbits + 1 + chunkLenBytes) & maskChunkBits)

	-- APPEND SINGLE 1 BIT --

	message = $ .. string.char(1 << (bitsInByte - 1)) -- set highest bit

	-- also in the process we added the first 7 padding bits
	k = $ - (bitsInByte - 1)

	-- APPEND PADDING BITS --

	while k do -- if and until we have characters left,
		message = $ .. "\0" -- pad with bytes.
		k = $ - bitsInByte
	end

	-- APPEND UNSIGNED 64-BIT BIG-ENDIAN LENGTH IN BYTES --

	-- yes i know this lua engine only supports 32-bit integers
	-- just doing the 64-bit math for the sake of completeness
	message = $ .. string.char(
		-- length is actually in bytes, so we convert it to bits by multiplying by bitsInByte
		(length >> (56 - log2_bitsInByte)) & maskByte, -- bits 60 - 53
		(length >> (48 - log2_bitsInByte)) & maskByte, -- bits 52 - 45
		(length >> (40 - log2_bitsInByte)) & maskByte, -- bits 44 - 37
		(length >> (32 - log2_bitsInByte)) & maskByte, -- bits 36 - 29
		(length >> (24 - log2_bitsInByte)) & maskByte, -- bits 28 - 21
		(length >> (16 - log2_bitsInByte)) & maskByte, -- bits 20 - 13
		(length >> ( 8 - log2_bitsInByte)) & maskByte, -- bits 12 -  5
		(length <<       log2_bitsInByte)  & maskByte  -- bits  4 - -3
	)

	-- current hash values
	local hashval = {unpack(primes_root_2)}

	-- string that matches chunkLenBytes of any character
	local match = string.rep(".", chunkLenBytes)

	-- APPLY ACTUAL HASHING --

	for chunk in message:gmatch(match) do
		local msgSchedArr = table.fill({}, 0, chunkLenBytes)

		-- Fill the beginning of msgSchedArr with the chunk's data
		for i = 1, chunkLenBytes/bytesInLong do
			local index = ((i - 1) * bytesInLong) + 1

			-- Get the next 4 chunk characters, shift them into a big endian order,
			-- logically OR them with msgSchedArr[i] to copy a long-word.
			msgSchedArr[i] = $ | (string.byte(chunk:sub(index + 0, index + 0)) << 24)
			msgSchedArr[i] = $ | (string.byte(chunk:sub(index + 1, index + 1)) << 16)
			msgSchedArr[i] = $ | (string.byte(chunk:sub(index + 2, index + 2)) <<  8)
			msgSchedArr[i] = $ | (string.byte(chunk:sub(index + 3, index + 3)) <<  0)
		end

		-- SHUFFLE BYTES TO SPREAD CHUNK ACROSS 3x THE LENGTH --

		for i = chunkLenBytes/bytesInLong + 1, chunkLenBytes do
			local v15 = msgSchedArr[i - 15]
			local v2 = msgSchedArr[i - 2]

			-- Small Sigma 0
			local ssig0 = uint32_rotateright(v15, 7)
				^^ uint32_rotateright(v15, 18)
				^^ (v15 >> 3)

			-- Small Sigma 1
			local ssig1 = uint32_rotateright(v2, 17)
				^^ uint32_rotateright(v2, 19)
				^^ (v2 >> 10)


			msgSchedArr[i] = ssig1 + msgSchedArr[i - 7] + ssig0 + msgSchedArr[i - 16]
		end

		-- INITIALISE HASHING TEMP VARS -- 

		local a, b, c, d, e, f, g, h = unpack(hashval)

		-- APPLY HASHING ALGORITHM --

		for i, v in ipairs(msgSchedArr) do
			-- Big Sigma 1
			local bsig1 = uint32_rotateright(e, 6)
				^^ uint32_rotateright(e, 11)
				^^ uint32_rotateright(e, 25)

			local ch = (e & f) ^^ (~e & g)
			local temp1 = h + bsig1 + ch + primes_root_3[i] + v

			-- Big Sigma 0
			local bsig0 = uint32_rotateright(a, 2)
				^^ uint32_rotateright(a, 13)
				^^ uint32_rotateright(a, 22)

			local major = (a & b) ^^ (a & c) ^^ (b & c)

			-- Apply avalanche effect, and transformations.

			h = g
			g = f
			f = e
			e = d + temp1
			d = c
			c = b
			b = a
			a = temp1 + bsig0 + major
		end

		-- apply transformations to hashval
		hashval[1] = $ + a
		hashval[2] = $ + b
		hashval[3] = $ + c
		hashval[4] = $ + d
		hashval[5] = $ + e
		hashval[6] = $ + f
		hashval[7] = $ + g
		hashval[8] = $ + h
	end

	local hash = ""
	local hexhash = ""

	for i, v in ipairs(hashval) do
		-- the :sub(-8) is here because SRB2's Lua likes
		-- to assume our numbers are INT64 when printing
		-- negative numbers, causing preceding "ffffffff".
		-- per long-word.

		hexhash = $ .. string.format("%08x", v):sub(-8)
	end

	return hexhash
end

rawset(_G, "sha2", sha2)
