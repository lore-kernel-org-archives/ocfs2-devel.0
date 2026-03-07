Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012071.outbound.protection.outlook.com [52.103.72.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF702F1FEF
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 07:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772868789; cv=fail; b=LVpRl4u8xWJkOGPR+Q0A33eYi77M1P/jfg1nt4XOeaqiXihGGqdQOXQFeLQUHUNfOkzYNRP8sz14ZV9fsWOm+G+efrnVEvTsy8eJlEP6oZpfpP1jVCjTaOvudxJ3I2KopwDHl/AGsoxzZk8A8zMhgJqhFbJaSe6fQiiVAxG/joU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772868789; c=relaxed/simple;
	bh=fmfwDh300zxvspQhbdmY5kEqy6pBnYQI1Ncus/xm/mI=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:Cc:MIME-Version; b=eb0t1B2JMi+k293Q2w1FJU+xxJzihWG43/f5CbRMrmCKUXe6xuKmXmpnAmIyKSvAmzz2ciGxIazz2tWYDdB0OxxBe0xke4JcECXe36WXCwCjuzzzVuj/9WQ2Vo3C3CjVcofIjegMuPIoxJTKh/6nU/G4rxlO9v6l7tLyJibx85s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=nNRNuPXl; arc=fail smtp.client-ip=52.103.72.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="nNRNuPXl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZeBwxSe5h35TFC9YKmkunQ1JLMZ418rVVoECbyxzISz1naAiaP1Smr4l7U8MprrQp97cavfDWxdzFjxYapdyzrdJ+OmJKXWYWkfabbNzdMLJfCMlPIOuNCQ6LZlbeSbIxe9UQJtPZwj2vNtOv1CcCFJYClkBx/+IczNwRSRZEPvR2Sf8/pFfXDOeQovB+jEREWf4ha40VaBlEXCIqnzLqAlr/x4X7v6WXzBkuknMiOOSnvp86KQ5WnM4vGAAyiYIsclhMvKXF91/FRGFCk6dQ5ephuHO3LJ0/4zQJij6K28jWtII6B8pKJZOoBslxSRUcq2B+ss5TX2LgQMBwdSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xe2tJncjKgTIFE95vmbW1gLXk18zSrvwTBGbH46ze3I=;
 b=TQv2hxfwnZuS3npPAFQ/aeE5AuWaPEEn6fWfomDVqPwb3f4iuPucj5ptMKNICGJyGj03DcqJrAHJwNXP27RGTFTsb9FGhgozywnGUFKUtMviOuGZ9X3Sk9ABX1KjZ/2Ue1lbm9AmaYMPeBZcZykqdYlQno41Q/tj4Hagg1OLNUdEYhT7pu8dB+sV0v/87j9btdeXO318yrtIQJdFuGc7nPzOv0603Gp/UMoN6KP/mz3kZxpRqLx8Tvz9FfX3qYRi1NPp3H8aJOx6w6flCRAkpR5pwpw0kNiUpn2pWjQ4+4/mobY4Dp16FjUVj3y0QffMCnO+UW+I5rulTpCUG1h0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe2tJncjKgTIFE95vmbW1gLXk18zSrvwTBGbH46ze3I=;
 b=nNRNuPXlrtpNm6kLuzPjR/quIjroD1nxvwfzGqORCxFLFSxEWwtHNJVz9v9HJCPsUs5wAPBJMCsVtvFAuBhOckvemUDoRcAsJTZUo7zgingPAL6gX+/7PsplmmsSt0nufhWlzNPH23xWx2Y/D2k0s/RtVkvmYeepayZ8CQzltC1yi3Z9rfNMj+Qy67ScTN5yRW7Giwn87MBxR6fuqMTKTKj+h2Tl7lUBVQB5DX0yYSY+azl/F8akRURQyyXzQndtX88Dce1K7Og+Zr0/7M6LN6cV3Kj22HVRFNww/S+WcKQ6XuMMOCEDxFd92VGMte4N57BejS1MzdmZcacdNZsnYQ==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY4PR01MB5610.ausprd01.prod.outlook.com (2603:10c6:10:fb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 07:33:03 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 07:33:03 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sat, 07 Mar 2026 15:21:09 +0800
Subject: [PATCH 2/2] ocfs2/dlm: fix off-by-one in dlm_match_regions()
 region comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
References: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
In-Reply-To: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>, Yuhao Jiang <danisjiang@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1028;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=fmfwDh300zxvspQhbdmY5kEqy6pBnYQI1Ncus/xm/mI=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhszVF58zfFJUWmF9hFcoWl78qjJTvnHNnyZ/Gee2lhNPr
 h+Zpjuzo5SFQYyLQVZMkeV4waVvFr5bdLf4bEmGmcPKBDaEi1MAJvJlFiPD0yb9qFono/SjzJ9+
 P1ripHfp7rET+u+2VkTKl27hZtr2jeGfwv3Y7JaKrM3Nzz/dEm+7FfLbgO/81Q/yKuLvvUVm3zv
 KDAA=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCPR01CA0148.jpnprd01.prod.outlook.com
 (2603:1096:400:2b7::7) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260307-fixes-v1-2-4cd10aa68bb7@outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY4PR01MB5610:EE_
X-MS-Office365-Filtering-Correlation-Id: ae0ce656-f164-4db0-cfc9-08de7c1bc44a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|51005399006|22091999003|24121999003|15080799012|8060799015|23021999003|6090799003|461199028|5072599009|40105399003|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWZBYnZWMWlxOG1vY3VhS21IWS96ekgwZzZEbmJ3UytlSE1zY1h3VVBqdHNS?=
 =?utf-8?B?bkhiN0xLcHJJZ01UR2JocW5JRW9hQ3VldGY4R05aN1Ara2pFYU45VjRUZjV1?=
 =?utf-8?B?VlBsZnM2OElyejF3SG4wNS9nZTVDeXR2bFJHTW9Zak9wazQzK2s3YjlVdzZo?=
 =?utf-8?B?THA3T1R2RlpLM3lxdzAweXZRYmd4c2haTFh5Vkhsd3ZmZHhUdkVPaHplTXVX?=
 =?utf-8?B?YkE0c3I3a0ZPOGY2eGRzUzRwV2htenc0SlR1YkJkSHd4U1BvcWpTa1lxUjFR?=
 =?utf-8?B?T1Rkc0NwMmlrQlRmL0pwTHBqU09mb3ljT2RYMzNGem1sd2xRS1hYL0IvNmRZ?=
 =?utf-8?B?NHVxdFZmbGVZbkw3ZU4xT042bi9Ibk1SM1lCKzAvSVNzWGtGMG5XdlRwalZi?=
 =?utf-8?B?RlZGc3NUYUFPazR6c0pHMVhQQk1QVm1kSHRtM0xCbCswR2JwTGRmNFd0ZU45?=
 =?utf-8?B?OWl0S3JYSnB2bUcvN0FFcEpZRkJ0TzBScUtjNHZYcEx1YUNjSENad3BueUpN?=
 =?utf-8?B?ZmtnbjR5cVg4TVozNDM4T2NUVmtGRlpLU244OVBpeVRoNm1GMHErZDlGdUpr?=
 =?utf-8?B?UitFczRGSjdtRmZiSXBjeTZ5UGtWSmU1dXREZnA4Ly9GRTBWK0I3N0tLbzg0?=
 =?utf-8?B?bVY4UjlLeEcxVm5CTWJwTThSbTRyT2NUdUQvd01KVTI2anNaeTNRK3pRYXNa?=
 =?utf-8?B?LzcvQ3hRNjBYU3pnNjdGYktPMnpTL0VkamJPRU1NYjZ5eGtqaFZoUmNBN2Jp?=
 =?utf-8?B?WVRxSkNPRjBuS3NHdE80VzV2cEhiTXd3d2dWNzgxeVc1VDZpSncwZzJvWjl2?=
 =?utf-8?B?YVZiNTdJSjBBVlpvdDVaL1ViZXZRaCtGZTJpNXRwUUFlY1JjQ1JwTXdsQ2Q2?=
 =?utf-8?B?QjZOL2pWOWxkTk5SelZuNjZPNmMxdVVrWURzaDRkSGhjUktCUklpNVRZOVkr?=
 =?utf-8?B?Z3VrSzh4TWkyUWw4T09BZnBKOUpWQ01YL3NqWFhrQlJOTktYd3h2T0VNK05V?=
 =?utf-8?B?TVRXV004d3JVMjlXRnBPcVZBcEQ5cDJSNnp4RmxXTjJBdkxpNGpQOGx6TTF2?=
 =?utf-8?B?ckNUTlBYVWNQZHZ5dFB4WlpsTUxEWWhCQjA0TFRKK2QxcWhkSVozTEJ5UU93?=
 =?utf-8?B?azJJbjdsMDR2MWVJLzhpZmtTMkNRMElTVUxsTmhvUExxdGh0T29KU0p1VXhk?=
 =?utf-8?B?N3VSSlRUdXRidys4b1ZPTzlVL1J4TVRpUXlFWFF5QytmNkI2dHF6L1FoaTFZ?=
 =?utf-8?B?Vmh2RlBGRngyMDc1MU1IMGNUNW43U0IyL2NKUUp3ZE5aak9QU2dxRnlDY1BI?=
 =?utf-8?B?eFhSYW5xNE9sTktIczJxSFhSK0dVV082R1NROGhCOU00OVNDVzk3djVybUhR?=
 =?utf-8?B?OVRLa2VKZlpDNHc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDNRbGRxajJCMnBGN3hRdVpTbGZDcEMzZ0x4TitkMmVIOTdmV2JzY0lkdHRz?=
 =?utf-8?B?WDZjamdNMjNLelJ6QWh2V2c4RUM1c3JHRUUxYkNlSlc5Sk1KSWZqbVNqc0F6?=
 =?utf-8?B?N29rUm44bzB4YnVvYVUxRTZhYXlxSjdWdXlqNUlXVzU1TDc4cE5zVGZaelVi?=
 =?utf-8?B?c0RmeVF4eEVWbkVFWkt2VE9IMExwTkNCbGlSWTFxbEFvRC81cExMRlpGOFll?=
 =?utf-8?B?T29WUWV4MkR1b2pRams4bVlCTE9LaTdXWVhkc3ZkZEFCWHVoU2lSWkpnZ0pS?=
 =?utf-8?B?WkJVVURleTkxaEVWdVFhSGpkTXNYeWM0aUNaMWxacjgrMVRlY2V2N2V0azhD?=
 =?utf-8?B?dXNkaWlwcEVRMlJPYmpXbkVKdlRjZk1pVU1WWStuWmpXWE1LakJBQVE5cHJJ?=
 =?utf-8?B?VklMOVhmY0t6ZWVrT21NcENwUlp2b3lFL0prbTlrRnZ0YUZ6TkVOd1ZhOW05?=
 =?utf-8?B?TVM1dkh3cU5QU2Z2eXJsRHdkcmlTQmpuanJPT05qVE1tN1pHT3l6SzdtcDg2?=
 =?utf-8?B?WnVac05lS1pLbkIwRkowalNBVlBuSXc4RzVTa1RiSzVOdjRwUW5NeTJmT0tB?=
 =?utf-8?B?MExzVjB5cnhSTWdFSHR3NkM5UmVORC9JbGlZTWdsU1haVFNLK0F2K0E4VmJJ?=
 =?utf-8?B?YXNiRVJFZnB2L1dCeUozQlQrYkQyRWlVWlZSRmdRZzZqWW1RU2NNZ3JmYklQ?=
 =?utf-8?B?WjN1NnhlMmFrOXB0TStkSFFQV0hpS2RLK2lHbm5yZENGWThaNjJCb1BBVjQ2?=
 =?utf-8?B?QTZ6U25BVlROcWlNTTV4MnJ6Q2wxdnFzNk9QQ2dCby9GY0ZGZmgzYzk5Ui9T?=
 =?utf-8?B?NjNlV0toY0JJbUcxcUwyVHBzSGV6cDI2UVVwT1Q4SUhBYW9kOGdFWHV5WGJl?=
 =?utf-8?B?RGRkOThpOE45aWJ2YWpMcXRlTDlGeVFxbnhJNys4Tk9GSVZxSGZ3c0tZTUdQ?=
 =?utf-8?B?YzBkS0pnV1JsOWo4cmlxbmg3UXpqL1kweW13Vk5Dakc3cllBMEcydVdHSEhS?=
 =?utf-8?B?UG1jYisvWE9NeXhBQTBoYnRBN0oxNEhIb2FTY2t6c3hLNW44YmNQQmVodlNs?=
 =?utf-8?B?STg1SWVMNHI2eVlCeGh5TDVKR0tWYUlTMGpuTm5mNTVib0xjVkxld1V2RlZw?=
 =?utf-8?B?WC8rUlNDaHFRY1IvZTZDazBHOGk5L3B6Qkk3dHNlSjZYSXdkRFVEMGcyRnFu?=
 =?utf-8?B?UzBta0dMS3BYRnBrbjR2ZE9KYUxKbU43TTJJMm9WbUNJenZrK1pHdThEZXND?=
 =?utf-8?B?S0doL3NTOXZnSVpWMnhJN3BiNE9IZ0taakNhZ285Y3JERWtaekM5ZFRaNW1l?=
 =?utf-8?B?Q1RXY1A2RmRwR1hHSkVMV3lDZENxVThzWmhWaFFXK2lZM3BRTVpvNk04a2Rx?=
 =?utf-8?B?Wi9uQnplYXJRaFMzenl6U2FyQTRGaHpLVUdtRm14em8wbUdmZ2JzamFMNlRK?=
 =?utf-8?B?MXkwbnlIOTEzaXU0NUJTVnhGNy9hSTc4WmlTcGEyc0EyK2xTOUVOQU5QVDJv?=
 =?utf-8?B?NURndW1tMnhmVnJnY1loWFVJdHRxRWpUUGNNMHhXNUhiUDNHWUxCU2lvc1By?=
 =?utf-8?B?YXdGUkcxQUhLYXlmV29UdkV0azg3NmZGaHRGSDJMazBWQUpmYjhVeEpCbHFF?=
 =?utf-8?B?bWJVbDIrQW1mVGdiSjhHeitFRk9PbEtIbFg3bzZFdnFkcndtL3FxM2lZb3lk?=
 =?utf-8?B?eURHV3lqZUJtMDBkME9sUEdTNnp3VWpGbi9kVCt3ME5id3pqNlBybHhtYnp5?=
 =?utf-8?B?SWMyWGNYRXBYZ3FPc0V2d25oOFdSczh3RXpWejVDY3pFSlRjRXBoZUhkLzBz?=
 =?utf-8?B?VWpIQmJQZjh4Z2I1ODlXYStyWlh2TXl5ZXRscU5GTzJWeDZ5RnV5TmR6L3RL?=
 =?utf-8?B?QU5QZmVHTU80L05sRExyVThtcTJBMVhSOEtNQ3ZrTENEYlE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0ce656-f164-4db0-cfc9-08de7c1bc44a
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 07:33:03.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4PR01MB5610

The local-vs-remote region comparison loop uses '<=' instead of '<',
causing it to read one entry past the valid range of qr_regions. The
other loops in the same function correctly use '<'.

Fix the loop condition to use '<' for consistency and correctness.

Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 0a28cb5ded2a..dc9da9133c8e 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1002,7 +1002,7 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 	for (i = 0; i < localnr; ++i) {
 		foundit = 0;
 		r = remote;
-		for (j = 0; j <= qr->qr_numregions; ++j) {
+		for (j = 0; j < qr->qr_numregions; ++j) {
 			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
 				foundit = 1;
 				break;

-- 
2.52.0

