Server = {
	PRIMARY_IDENTIFIER = GetConvar('ox:primaryIdentifier', 'discord'),
}

SetRoutingBucketEntityLockdownMode(0, 'relaxed')

SetConvarReplicated('inventory:framework', 'ox')
SetConvarReplicated('inventory:trimplate ', 'false')
