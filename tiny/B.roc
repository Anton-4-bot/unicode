B :: { bytes : List(U8) }.{
	from_quote : Str -> Try(B, [BadQuotedBytes(Str)])
	from_quote = |input|
		match parse(input) {
			Ok(b) => Ok(b)
			Err(_) => Err(BadQuotedBytes("bad"))
		}

	parse : Str -> Try(B, [Empty])
	parse = |input| {
		bytes = Str.to_utf8(input)
		if count(bytes, 0) == 0 {
			Err(Empty)
		} else {
			Ok(B.{ bytes })
		}
	}

	to_str : B -> Str
	to_str = |b| Str.from_utf8_lossy(b.bytes)
}

count : List(U8), U64 -> U64
count = |bytes, acc|
	match bytes {
		[] => acc
		[_, .. as rest] => count(rest, acc + 1)
	}

expect {
	b : B
	b = "https://example.com"
	B.to_str(b) == "https://example.com"
}
