Tag :: { raw : Str }.{
	from_quote : Str -> Try(Tag, [BadQuotedBytes(Str)])
	from_quote = |input|
		if Str.is_empty(input) {
			Err(BadQuotedBytes("empty"))
		} else {
			Ok(Tag.{ raw: input })
		}

	to_str : Tag -> Str
	to_str = |tag| tag.raw
}

quoted : Tag
quoted = "en-US"

expect Tag.to_str(quoted) == "en-US"
