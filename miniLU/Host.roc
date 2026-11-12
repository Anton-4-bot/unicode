Host :: [].{
	locale_get! : () => Try(Str, [NotAvailable])
	locale_all! : () => List(Str)
}
