Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010079.outbound.protection.outlook.com [52.103.72.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25641B4257
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 07:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772868682; cv=fail; b=AOiCJ1XtwSZIzB4gklSQPxoy5u4jtTqPeFsgKbj3KrAbW83wdnzwuBEO9pJGOhhJSjZFmrdheKEUtRa7uKOPdzRw6ZdjzEZtPvH11sQ2atQjJHkbdBEzKNfCjAu/zPeaGprvEsHjxFSzF3dJzEg8/l7x3qzKEHFsLO2UBsv3MCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772868682; c=relaxed/simple;
	bh=GsBuRcFh0h0z33jNkFCFFHGLz5wRMf3G9AilEJwIuJA=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:Cc:MIME-Version; b=VRt3qj9ihpMPYmklyllR7V4U7dJq0irg2OmvXkgTNkfZ82yuL3Heex2ghESHl0BiwwPy+us3uezzjtWZmSogqawcLSjR33PoU8Wl0IBjwi5V9T7oQ89z2q8LA0qP9zcb9L0NBt4FZAfPzsLJSpT4H5bHzJKWfLuWtHQwmi3Lzqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=rL/pdkqo; arc=fail smtp.client-ip=52.103.72.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rL/pdkqo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gksj80lo8pD2c5x6QfykIYiOVezKjAIbHkGjBp4LbHbF6u+5upoBJ6Zl3gu5IgVdYgjk9L4HIXdqxSlLemcLMvfcTI5XvknTmCgbHVVfMZCUwBXdgfmcxHXkmoOdfCHgb+IQEl9klIxC1ukzsB3MV8TVnP4H6sCDIg7RbjPm4XbavKVqd+3DSB95UDoCHpC7okkAL9i6gh0ztpvs4fxtP+7g4OKESjkfZrWwQ+SXqXDZzskcpoxdc2LLjNywWMl+uL6Gs+GEsDXlCk1P9yn1zlBej9SKEiApbqJUVURE/duPsPCo4B573DZFIvH1gHlWcp5mh6LD8MYAQa0teaa7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5niN4fhSenD1nHoFDbyqQFWlJ0QiCZph1YDsyf7rVDU=;
 b=ul8XoSrgFpr4dm71FNhB2R2ZbWHHx8ZD/g6irXZLIV+ruCYjuBiQDQDHy0s+DhwYvjNfwGn7ZU9+5kVo0242xIfFk5vqne7mLPJ0lKhlMKjKlL1FjaKWyCmoM1LpA7MEwCu9CqhZWS5ncAtpaUmenzGrHUhLc6crnOQgKp8R4wBvd7Z2u2RMDf2gohFIQJHAIlug/F44E0nhgiGj56V4ByvYeVbDAndEPoKEawsVhiFO9PfCXoUjojuIyTHIlhPGBusHRV3+iykZ+MHP5zip/Kozcd8V0c9qLrm+1/EhY6X9kpUUAPY+XfLMo8A9hDQe3wlhBS74NFauLsblC1gv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5niN4fhSenD1nHoFDbyqQFWlJ0QiCZph1YDsyf7rVDU=;
 b=rL/pdkqo8ewIahMYHcnN4ke4iKa5GdRVbBEuSY+LI7ohPHSGP11bBKle1O96vZjMhbVJ+Y1xxyv0rXUS3XqFgzL0dR+PfPKv3IZFYVkqPpih3U4ZjWlweARIJV1RNODyQqMQeOhlHs5hjF2opC9YRUgBbMtEGaDvnHGKC9xP2hJEKd9j/Trp0yhsbQo+ah337dJYWQs71Ee4qBWxrLQwdGv9P1GODAwcmFG6wgy2IEWwwfyFt7irdsarVnWYyyOc2zdRj3SXMuphvQDORhCCQktyDncX/rkkyNvINe4Nh4DZkvWeyOzDabWLo//kCE33h8KQHjKMtGHQgQuZ6wm6Eg==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY8PR01MB9314.ausprd01.prod.outlook.com (2603:10c6:10:263::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Sat, 7 Mar
 2026 07:31:04 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 07:31:04 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sat, 07 Mar 2026 15:21:08 +0800
Subject: [PATCH 1/2] ocfs2/dlm: validate qr_numregions in
 dlm_match_regions()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB788166F524AD04E262E174BEAF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
References: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
In-Reply-To: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>, Yuhao Jiang <danisjiang@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=GsBuRcFh0h0z33jNkFCFFHGLz5wRMf3G9AilEJwIuJA=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhszVF58nTpgRn5jQrGBv9cWI7dG/cAPXXRuad+ovP/IqP
 3OTp/WXjlIWBjEuBlkxRZbjBZe+Wfhu0d3isyUZZg4rE8gQBi5OAZiIUBkjw2v5w6pK/5hz9pev
 f+R9OVpX6BF76l1JgSUqHvM++7HtfsDIcIu9X756lyHzDocA8926Z3h/XZr+bI7RfDmxGVFhfLv
 zuQE=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCP286CA0090.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::19) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260307-fixes-v1-1-4cd10aa68bb7@outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY8PR01MB9314:EE_
X-MS-Office365-Filtering-Correlation-Id: ecbb4ea9-7297-472c-149c-08de7c1b7d95
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|23021999003|15080799012|461199028|51005399006|24121999003|8060799015|12121999013|5072599009|22091999003|19110799012|440099028|3412199025|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eE5DeTRKbzNpa0hsVzlHYzVVeEFXaDEyenNxMk8yR0Z0QkFXZUtDbXNmekxG?=
 =?utf-8?B?LytxTGRlZ2wvbk5tQ1VOb011R3JkeG95QUVzazh4dzEvdUxFKzl2RGpNakda?=
 =?utf-8?B?TnJ5Yjh6YzY0N1JYWVF3Q2ZOanZSbzhJMFpxUDV1bXFNL3BOUys3dEhhU1dm?=
 =?utf-8?B?OE1KS0tMZnlQQjh1ZzVxTks1K1VDZEFlUGU2RjJ4WHdvOGFGYStZbjYwd3Bz?=
 =?utf-8?B?RzJydWZpdlVWMzhKQytmQW5RUVNJVS9JdjBnWWtJNERISUhtbS9ISnJsZktZ?=
 =?utf-8?B?dkY0UGY1bitWSHBHZlNBdWU1aVBxSE5SVnFPYyt6VFR4WFNlcisvSGQvQ2J3?=
 =?utf-8?B?d28wTHYwVFhObVY1SUk2ZzUrMU56ZGxXY29zNnc2TGJleUFtMzVWQTVUSEp2?=
 =?utf-8?B?bVRmb0FxbEF0QjlBYlBQcTN6QTVLbkVSTGd6SEpTWVVISGo0VThSb0lna1dJ?=
 =?utf-8?B?ZzBYQXYvVnRPVFNmZGUzUDQvQW5taFRhS3pHOVp6a29jNnhpNGxtZnVYK1Zs?=
 =?utf-8?B?c2I0SFhCeHZITlJobjRFL3hNR2JLZks5aUdBMGVEL0gzenE4YTZ4K2MyNWpt?=
 =?utf-8?B?a09qeFFRMUpEVE9lbk1nblRBWjIvRmUxU05JSGdtMjhHTmNTZkVJSGxHR0Ni?=
 =?utf-8?B?T3Iyb2cwUW11WUxxVmNqaUxGOHFvaDdqUUJ4ZkJQOVBJVWV5RXpxOVdkMkZt?=
 =?utf-8?B?anFQMHNLQVNUWm1CQ1hsNVNINlB6Z0hOaDdlV3l1c1gzRHMrOFpFZnF4WkNz?=
 =?utf-8?B?cFN6UXF6c09scjFpKzVPZHF2SGFLeDVNdURRMFVXUm1zZjZUc0ZqbUQ1T2FL?=
 =?utf-8?B?bm9BbnRxUGpjOEFGZTlqa2lsb2JEQlV1MXFJMC94Vmxma0svYXloQ3RzUnhN?=
 =?utf-8?B?MngySGZUd0hpb0poT2FIcjdMNTFRVnJPZU5QWkN1NHJKaDJVbEVONnFoVE84?=
 =?utf-8?B?cnE1ajQzQkhLZ0lLRVVvNnVEbzd3Z1E2MTJ2VWlzcDZqZWorTW5QcGtNODls?=
 =?utf-8?B?c2ZDbDE4TFFZS1JhSGdCeWtXbDZURnhkODBlSVhGa2E0VnhJSGFvcnk0RVVw?=
 =?utf-8?B?YjJJcjljeEFRc2hjeU41UHRwTEd2ejdYUUJOR0cxN1dSL1BtTWFDOE9Ialh2?=
 =?utf-8?B?cVRlS1dyOHA5RWtHL0ZZZ0xuZFd4RHlGUXFBaFo3bmk1UG10N0w3UUlrVlJI?=
 =?utf-8?B?Z0VLWXNxVGcvVExRdGVKQVpWTXp6U1BKUXladmxCYVdRZ3JUNEc5eGVNQUhX?=
 =?utf-8?B?ZFduT3V1S0kvYmxGeHUvTVpxbVQ4MCtyWUxmTnNQRkJNeE9TNUhrZ1plTUFX?=
 =?utf-8?B?Y1htRjhUQUkyTWhGYUc2aTdqbXRrM1BxZlNRTWtpZ1A3VUYzUTVqWFdWVGIy?=
 =?utf-8?B?WWd2TXhzOHZYUFVCQ0tEbzc0TTd5eUU0L1YvYzdhSDdRZWRoWUpvRVM4UjR4?=
 =?utf-8?Q?FmMtNDaO?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vm4rZDNFd0dSUDBTQW5FRkNNc0E2OGNFcUl4d3EyVDVLd0N0WS8zTGhQQ29q?=
 =?utf-8?B?S3J4aDhGdGx2ODVKN3VLWnNJa0lvYlVYZFg3N3hDR1kyNzdzbXg0RUdTRWov?=
 =?utf-8?B?OWxBWlBVaUZUSHZMbFpZM1g1UFFpK3ZoeFVqTmVuV2kvbWV2MGdPOHNpWnhn?=
 =?utf-8?B?R256TDFIODZORjNzOURMQlErR09PNkVFVjlvL1RqeWowTnE1N1IvOGNlY3M0?=
 =?utf-8?B?TnQyMmFKcU54K0VuL3NtMk1QMWF2dGVRRnpUaFNySXlEcGdlRWJlMzRlVnFN?=
 =?utf-8?B?Z01JSG9BYVN6MkV4QzV2Y2Q3VUFtU3dHQ2g2am1xUzdDdlZWYkFXK3F1VzBP?=
 =?utf-8?B?K3ZUcFYzWWhhV2plVjI2S0JzeUlIdTFnL0tpalJFejdnY1lzZDRLRExyVytY?=
 =?utf-8?B?dnVnUmhIM0padUp4NkZQNk02VDhqc09UM0ZFczBYMkFjWVZscEdBNU1ISWEr?=
 =?utf-8?B?cE9oaDZLUm8vOExXWnFvSUFNRzM5bERPTE8wNnpGVDhCbnhUK3FHZlR6N3M3?=
 =?utf-8?B?SkVuZllkZmxLRFpSU0VxZHI0SlZYYVUzNXR4ZlF2eHhqWVlKRkRFd0d1Y1Nx?=
 =?utf-8?B?OHQxRzQrVkU4TUd3aFhBWHJZZmtiSDNHUjRYcDFVaW9ibW9OMTJ5WWw5UktF?=
 =?utf-8?B?c2h2b3JxMG94RUNrbm5CMmgzMVNwWG1Id3laWEg4d0lFOGdocWRIWjYwUHF6?=
 =?utf-8?B?NWtWRSszaFlEK0NxZ25yTFptRldrZGx4R3RTVHhGeUJucVRJcWdFZG5oUGo5?=
 =?utf-8?B?cnI2b1RhZi8vU3I4RTVVUEp3Mk1WSmlOOWxraXZ4aVB4Q2VSMXZDeHZNNGcr?=
 =?utf-8?B?OUR5OUsydE1sMm94MDI3cnlHWmZ1SXlTV2FZaGJPNzQzNkZGc21YQUVicThJ?=
 =?utf-8?B?ZGRXemdmbFBwbTA4S3pHVXRBMm5vNlRINUJodldSZzZWQURGR3lwR0ZwOXRE?=
 =?utf-8?B?aVlkVzFqNW9JUWVHTFpENHRpY3JmZTJ5MUMxM2g0K3NRSDlzc0VnT0V1YVpW?=
 =?utf-8?B?VjdnUHFBSDRxblA4YkQ0dWFLdysxOTRHajRGMTFWNzAzTzl6ejZHYytQbjhB?=
 =?utf-8?B?R2YyeDl2SGdZcFpwRGkyN3lKVUJyUmpBOHIzbmhmWUV0TnJCUHpaZzhQZng3?=
 =?utf-8?B?Y1lkeFY4ek1hemN2aGcvaUpXVkhJRDZoQXZMN3JWTGlPOWFoWDNGSEZyS0Zv?=
 =?utf-8?B?T3dENW1EelZ5QmhOTTU1Z01NZmhjT3VneVlhcmxXY2UxMEdySFFXOENiNndF?=
 =?utf-8?B?NWdxNFRLWjFMYzJ3OTBBcGpYSEt3VVZ6WXFCeUZpdWtHWEh4aTNNZE5nbnU5?=
 =?utf-8?B?aHVpbE1xZU90TVgxa2JKazRmNzV2eGttWk5mZnZocVdPd1BsWWZIWHNzSzlw?=
 =?utf-8?B?ei9EWHFpaUhybi9vOWR5cE9TakxaUEhSSXZsM20yMVJtNmJ4bHFEeGNLajgx?=
 =?utf-8?B?T0ZKbFMrVnZCMnRaS2ZxcTBMUnhLZ09FN0lYK295elJKZm03Z2ZkVEtLek9R?=
 =?utf-8?B?ZndyTUZvclUxakp1dVB6dWhpYVk5bU9ZU3krYnF3SUdka1hSQ3IrU0dFZjdw?=
 =?utf-8?B?OEM3dEliSEthM2E0NWVsVFNRVTczQk1IVnVXamF3cmFZRk83eURzemkrbkZB?=
 =?utf-8?B?OTFnYlQ4aUozR2VWRW5WWXdhY0pLaERQUjE2RnlGSDFRR2JXUlFjNHZydjZY?=
 =?utf-8?B?bE92NzQvS0cvQWR1L2RvYXhidjRlMklpLzZWN3RNcGlTaCt0OHFmalI4Y2N4?=
 =?utf-8?B?ZVNvU1U4L1MrQnl2YmpIMG1TcTdiSnFocHJRRHB5ODE0TlYzdWlxWEhBM3lq?=
 =?utf-8?B?QUJyZ0ErWUd5YjBoSUpwOHBWa0IzWUl0OGJlRGFpSVdhUlZLcUtpbk9vcHRV?=
 =?utf-8?B?K2NIMldxMlJZN2hlS1RpbDIvdXJnVytnMkI3RnVJeTNoZ3c9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbb4ea9-7297-472c-149c-08de7c1b7d95
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 07:31:04.8129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY8PR01MB9314

The qr_numregions field from a DLM_QUERY_REGION network message is used
directly as loop bounds in dlm_match_regions() without checking against
O2NM_MAX_REGIONS. Since qr_regions is sized for at most O2NM_MAX_REGIONS
(32) entries, a crafted message with qr_numregions > 32 causes
out-of-bounds reads past the qr_regions buffer.

Add a bounds check for qr_numregions before entering the loops.

Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 70ca79e4bdc3..0a28cb5ded2a 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -980,6 +980,14 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 		goto bail;
 	}
 
+	if (qr->qr_numregions > O2NM_MAX_REGIONS) {
+		mlog(ML_ERROR, "Domain %s: Joining node %d has invalid "
+		     "number of heartbeat regions %u\n",
+		     qr->qr_domain, qr->qr_node, qr->qr_numregions);
+		status = -EINVAL;
+		goto bail;
+	}
+
 	r = remote;
 	for (i = 0; i < qr->qr_numregions; ++i) {
 		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);

-- 
2.52.0

