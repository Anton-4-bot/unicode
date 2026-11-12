A :: { raw : Str }.{
	from_quote : Str -> Try(A, [BadQuotedBytes(Str)])
	from_quote = |input|
		match parse(input) {
			Ok(a) => Ok(a)
			Err(_) => Err(BadQuotedBytes("bad"))
		}

	parse : Str -> Try(A, [Empty])
	parse = |input|
		if Str.is_empty(input) {
			Err(Empty)
		} else {
			Ok(A.{ raw: input })
		}

	to_str : A -> Str
	to_str = |a| a.raw
}

expect {
	a : A
	a = "en-US"
	A.to_str(a) == "en-US"
}
