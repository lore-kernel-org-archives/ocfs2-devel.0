Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011057.outbound.protection.outlook.com [52.103.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20CA1F9F7A
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 07:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772868216; cv=fail; b=pAPgvDVTXm4mWcHtDpqBibEOI4pzDBaGv+uWSViY79AKkIQGi0mcIznWgkU55JA9XRBGBdvTe9qDuTq5H1cLREVONXKlyKBoisFxhVTakjzrN2BDg9M/IEao8lYLiHKud2b0RrmykqF/7cnpMSTE19rgZs6eXMnSICXLfXaDncc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772868216; c=relaxed/simple;
	bh=P0kvmmOCW9JMSMXpMwYHSOYOBiKPiFyo9pNwivvisTo=;
	h=From:Subject:Date:Message-ID:Content-Type:To:Cc:MIME-Version; b=NndjYnOvq7OqdQV+8YJH0PyIOfLU7En96YTiChhwYA1aQx7P/vINX+jCE9YR1/QzCVy/QIoJ3eYeiSHgYpY9095BF7tfmwT8PekENPDbpmmQfBMBfQfBtPbe39u8a1kztOlCmPKj1EkE7KcsFU7mG8GVYsazQ936wZgl3p86E3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=BJ+va4gu; arc=fail smtp.client-ip=52.103.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="BJ+va4gu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOB4DEXlo5c/bxyEfou3RDrR8nKVE245GCGWuDI+xuQ0KLx4Z7L+iwksLZqoB0kLeDwmcZlI1NdHYfWXTW4OFhGNbdAJhrvqQOfvsvMM84c2Qpy/hSAh8Iqzus4xPM2+FayEUFg8fYBIB959ggFy5zJC5KYFvgR7mWT1WO9fUt7kcsVy6597bra9+GhOUVe4uthfuPDaf8Qbh210p52jV6RDVoXhDz78ytQ+Qiy5qRSBPaWecbr0iQ7SFqTHbIpedMXsuCDxFCHBczuk8HTy+NgNd+hpCb1Kl8i+OURWpf95LlbLC1bfaf350YOueZFmikKVxu4IAI8v/O7uP2+G9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU6Xy6m/6uiqJqMHroCc7UhvFK4tex+DFFKYEMqGrOM=;
 b=iL4Qv+3JmwLcIYtcaS9GemFOiPuaaosrHvltsaZoNexuiMHhYBPXoQVQ/k9pB3ZM2JGxex8MjcAWdv0ZWFxFD043deElAvqrbix1mSqwfvx33WH6abxheuhHhzS1DnXFJuHR1dG4/JQom741y78I/3zUcezGnZ46793ggeLEFSLhaXAYHbaI99AL+0Js33conal+13buzI1XEQmASG0/l/Od+iBSC5Mhw3KPA75KzvAt56ag3k5GREf7bpfdQFDGJXUDGXMyK1GecDzyJZruZxR8CFZCfJtDexIQWIwLRPr1tiI6PRcaIjhYCtbAfRc1/LmWM3Mda9h+9CI3vDmLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU6Xy6m/6uiqJqMHroCc7UhvFK4tex+DFFKYEMqGrOM=;
 b=BJ+va4gu5eISeKhyiQ9CuIknq1PwtooTU7YqSTJH3YuI294TrpWwP7bgL6ukxd4RWDYwzln5tEIQXWR2FYJf9u2j7e4Ic7gyt9tw66V5RM9Zp19+5lGnDsZG+IvSIhCdrq19eEwJXlxfAQIFnMisN17PO/dyORFIEH2HrZR6a80WRURzCQZ72eEwg2vKDs0hul5KRU/2HY4o/nl+z/mLJ5nhur7PH0NX6jTySohBeDVJqLPenbb13SbfteGah8JDZ/yhxTuzA1CKvGFBBDZWAfIhKOMTBNkWTHE2W98+r6V6NddRkiMJmEWlgv/pcwf0oc8RlzZIIgUlfDWwRjXTpw==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY7PR01MB8641.ausprd01.prod.outlook.com (2603:10c6:10:21e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Sat, 7 Mar
 2026 07:23:17 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 07:23:17 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 0/2] ocfs2/dlm: fix two bugs in dlm_match_regions()
Date: Sat, 07 Mar 2026 15:22:33 +0800
Message-ID:
 <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwNz3bTMitRiXcsUiyRLUwNDo0QTSyWg2oKiVLAEUGl0bG0tAOAul11
 XAAAA
X-Change-ID: 20260307-fixes-9d8b95012a49
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>, Yuhao Jiang <danisjiang@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1188;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=P0kvmmOCW9JMSMXpMwYHSOYOBiKPiFyo9pNwivvisTo=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhszVl+K17RP1Ze7YzuOY5708yE5+vcPu2wvus7gEVuvNV
 Ztyq+FfRykLgxgXg6yYIsvxgkvfLHy36G7x2ZIMM4eVCWQIAxenAEzEsIuR4UqXTOrctvppHt4L
 G4I45Ldaem4wem5VqsUW9U7e5swjBYa/wu1ms0/c19ZKqr9akhk3Y/0ct7tdCq82prtGvUhY/pu
 LFQA=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TP0P295CA0012.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::16) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260307-fixes-v1-0-4232c86f09b8@outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY7PR01MB8641:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b95a73f-6c07-45ee-a314-08de7c1a670a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|22091999003|24121999003|6090799003|5062599005|19110799012|12121999013|15080799012|5072599009|461199028|8060799015|53005399003|40105399003|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OC9DUlZzWmpoVU9UVjNKMFhjMmJwSVV5VTkxS2k0RXlJSGF3OFdHUlBNTzI1?=
 =?utf-8?B?TWF5N01NQitJbGxndzFRckg5anhQWGhMWEczNXNvRllEODN0dEV6TVBlL1Q4?=
 =?utf-8?B?Nm1nNnpNSUFmVVoxT1VZc0ZXT20rcmVUeW5jeml0ZUtnbFZJN1k2MVAycmlq?=
 =?utf-8?B?QTg4blpWRFZEbnJNanN3OFpjZGVBNnhyOWZwdnJTSXhEeThmNE5tWHdWS2Y0?=
 =?utf-8?B?SFdWUUtrb045Zys3cnpWcTlmQVdWTXAyUjFpbXQxOVprS29vbzlEMkxwVStq?=
 =?utf-8?B?SHdUS0l6TWVNTWdFWGhHS1YzRUlOdG95ZnRZU3lpdXh4T0Zrd2pZdzRQWFJM?=
 =?utf-8?B?bEczR1VFQlU2dDBWVFh5VGxaQ2x6Znh5N21kdFBzWFkvNk1DNkZlNTd0alNN?=
 =?utf-8?B?QzhvYU91d1pMWkpHUS83Z1JCMExXNTFLNy9Sb201WnZIWnp1UGNJTUxEeGZM?=
 =?utf-8?B?VzdvVjJObzRYVXJxS1JSYy9YR05sRG4zdlEvTnVnaVo0NVlYb2tic1FGY3g5?=
 =?utf-8?B?bkdwYWlYWGpyRlNYTHhIVzUxSEY4OGRyb0hPSEREN2hEOU9raFpzQkMxUmky?=
 =?utf-8?B?MmttU0QwOUp2MUhRWHBXZ2pGdlRreU1lT1F4azF6R0dqVlMrdWVBK0IzRjFs?=
 =?utf-8?B?WEZVSlJ4K2ZyZnFNU1JadkFnSGppNDBNZ1pkS003S0R6KzVkZC9yS29UekU0?=
 =?utf-8?B?YnRvV085V0Z2Rno5Umd2SXJwTUJkWlpyNXdCT0dWaE9HQTRPWlgvUVRmOG9t?=
 =?utf-8?B?ZGNqejcwbW1Fd3R6WTZBREszaStkM2NsZUhTMEtwREFRKzVrK2FHVXlvZmFQ?=
 =?utf-8?B?dUdva1RkVGt6S2dkZkNFM2VNZzQxT3g3OW5QcHVVakRMdVBWQ1dCeUV3NmRK?=
 =?utf-8?B?eENyZWxNR3Bja1k4cnRHL2d1WXR1UFQ1dW1vRi9LQXJ2VFdLcVVaQmgzNWR0?=
 =?utf-8?B?RWhxaXNkRzU3MEg3aTlSQXhaMnRrMUtRNUhtRWxONFpQL2tOOFA4NHowMmVE?=
 =?utf-8?B?ZXJidGthWjZFM0FjWFRITFRML25BWG1qQWhodE1obk8zc2p4OFg5b3N6OEhL?=
 =?utf-8?B?b0x6N21qZWdJSkluWmFKWVV0K1RRanVSOEVqTkU3YVFFdDlmdHFuOW9jcENT?=
 =?utf-8?B?UE1pRHVvR2tkSlp2bW9CTTNLRE5NVWxjcmJ3MFErMkFEUGlXQmp3dnBXblZE?=
 =?utf-8?B?cmE5eVkvRUVkTE9YNkpJY1I1WU4waVQ3TWlhQWNQcWlRR0hZQldwb1o2RzNY?=
 =?utf-8?B?QUpiRGZlQW1aaXlrWWt0QVNwK1BJMTg2RWoxMXJISW9TdThaMUpVaTQrM2hx?=
 =?utf-8?B?QUVuOWlwRTBrNldmdDVLWmFWUHRWT09ya05seExDKzhTeUxIWnNicmtDSTdG?=
 =?utf-8?B?bjMyaXRFMlVPQW9pZjlmVEt0Mkk1dks5eWZWTWt1Q2dUcUttYVZMS2JUYzdI?=
 =?utf-8?B?N3orUENOckZLOWhMWVFtYWJVQjVSMmdySTF4c2NnPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDNmSlZOZ3VvTXkrUVJScWpaMVIvbUdIUnNJYU1SQ25QVTNlVUNXNHpwZGZy?=
 =?utf-8?B?YWpucjROdmU5WkJ6SEZDUktZVERQT0x1d0NVbE1kM2N0R2g4SUxydUgxV2Jt?=
 =?utf-8?B?MlVTRi9yZVVTbnRvSXpXMWRvdjNlZWE3VDkxeEtpUEVpMlFENHJvaVlyMnlM?=
 =?utf-8?B?SCtDQXdUZGxDVTFtdldpYmxQRUJRZithc3VSV0JSRU4vaFdPQ1MwdXArY3Nn?=
 =?utf-8?B?c2hWcmliOE9DOEQyaWtjKzFLUlFoMmlGMmJnb1FWZGFrWG9rQkFBVmkzd2dz?=
 =?utf-8?B?dmxheGE1bWh2Y0RNUjNKYzRrZmh1ODA3MVcwSTRkYlQ0ZDVmL2dlTGVNN3Jk?=
 =?utf-8?B?Vy90ODBOYkEvRnBQZzZoREhhbkZGT1NPRWZoQ0o4bml6MGpYLy9oRi82SVJP?=
 =?utf-8?B?QTFBRlJyNU9SZzM1aFdsdzIyMldEK2t2QWhSVy95RXBNbW5JQVhGZFdLUjd0?=
 =?utf-8?B?Rk40Q1lpeTFVb1hsbjhxUTc3d0ZiNHgvcmljKzlqQXBaTVkrOTg1dkIyeElI?=
 =?utf-8?B?ekViSzZkZ2lLNlVUbXZHMkJFVkdDNTY5SjZhcDFPYWVBQ09GVDBTTEtuWkJa?=
 =?utf-8?B?OXRxU1MrenVocWpsVWdpWU1sbjRETHdJOFBweTNZYngxdXNpUkN3Z0JOT0ww?=
 =?utf-8?B?eEJUZ0pxTG5ESlo2cmk1ZHl6dTFDZVJnQ0ZEMDd3MmtsV3BtK0ZXdzhmY3Rv?=
 =?utf-8?B?UzM0Z3RQTkdXUm5BVWxnVUNVQUx0SU1oVWdiQU5jMm5sR2YwUUpwcndPbEM4?=
 =?utf-8?B?aVB2MXJQRzEyZXVoNExuNFRGNHNleUFORjlZempVNXRCV3M5bTNJb2VGUFF2?=
 =?utf-8?B?eUNaUTJURGtUanFRdHowK1JLQWRhbVBiT3ozOUVNMnNLZWNYNjJBWWtVbEFs?=
 =?utf-8?B?REROZHVjeXpTcDhBNy81cGF3SGlRbEFQbEFJM0hZWjFQaWVCNXpFR0FNM2JK?=
 =?utf-8?B?b2RwY2J1UjZhcy9aQkI0YnNrbWJUTTVZR0dvU0VXTU1ZRFpKS0tyL1hOTW1w?=
 =?utf-8?B?L3JIZldrZ3lrOGNCTWxaaHdacXFyQWRWYTVSUXhsUVJLVVdkRklsZ3k0eU1D?=
 =?utf-8?B?M2xoTDRIalZpcE9scGhRc0I1YjJmL3JXMlN6NWcvcDJzbWd4ZUYwb2gyTUZY?=
 =?utf-8?B?SW5oa2V2SEZlUmowVWh4ZWRlQW9EUHQyZ0hMSERiektoeGhDYWhRcituT0Nn?=
 =?utf-8?B?L3lJRittZnlyTXZMVk9SelhqL3RyRjhyeHNRVkJsL2dUZlZOOWdHZXF4dkFK?=
 =?utf-8?B?UFlic2ErV1FEZTA4T3VMVmhGNkhhZDJkbEJ2WFRXY3M1OEhYUnF1cFppcGRI?=
 =?utf-8?B?eTNzN0hJYXRTWGRqNlFBWVJLa1E0aHZBTkFkK2RFeXoydmI2Ri83T2ZKdnVw?=
 =?utf-8?B?cld1WWcvcHVsRmdtSlhlY2ozU1RhSGRmN0FJK1ArdEx6SnBJa3ZENXp4LzNS?=
 =?utf-8?B?UFZUWlppUDVuZ21ESnZTaWNMWWIzY0Q1MmJsbm11Z2Rjb3JBZFRBaUtGN3JE?=
 =?utf-8?B?SDdHbjBoS0U4NHpzajl5SGg5L2ZYWHpON0VyREU1RHhKSEJtMUp3MEF0bTBt?=
 =?utf-8?B?eWpNdkxtZmZRWkNyZ0pONTdhWDdqNWphdytKS1JjQjJCb000YjRVdG5GbHVi?=
 =?utf-8?B?cm1NZDY3TVQ5LzB2QnpZTnRIR3ExOXFNOWVycGwwL0piMUN3dDlabnVqdmZ3?=
 =?utf-8?B?WDkwbWpXWlE5QTRSNndCejNVMUQ0dE1rcHVRRHRjelhWSjRKRG9ySG9Ib0Rl?=
 =?utf-8?B?UlBMKzVpNWhINzdSVDR1MGNlUTRYWUZrVW9zQkFGb1hneFNEYng0MURVT0lx?=
 =?utf-8?B?UWtxRUc4cmJYL1ZYN2dUQXZiVTI5M1ZoWmtxWWl6Vm9iNnNyMTNHTGVrZVlW?=
 =?utf-8?B?L1ZMTjZ1Sk5EOU9SNlpPMUhZT3FRcHlJMWJLdDUwWkltSEE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b95a73f-6c07-45ee-a314-08de7c1a670a
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 07:23:17.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7PR01MB8641

In dlm_match_regions(), the qr_numregions field from a DLM_QUERY_REGION
network message is used to drive loops over the qr_regions buffer without
sufficient validation. This series fixes two issues:

- Patch 1 adds a bounds check to reject messages where qr_numregions
  exceeds O2NM_MAX_REGIONS. The o2net layer only validates message
  byte length; it does not constrain field values, so a crafted message
  can set qr_numregions up to 255 and trigger out-of-bounds reads past
  the 1024-byte qr_regions buffer.

- Patch 2 fixes an off-by-one in the local-vs-remote comparison loop,
  which uses '<=' instead of '<', reading one entry past the valid range
  even when qr_numregions is within bounds.

Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
Junrui Luo (2):
      ocfs2/dlm: validate qr_numregions in dlm_match_regions()
      ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison

 fs/ocfs2/dlm/dlmdomain.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
---
base-commit: 0031c06807cfa8aa51a759ff8aa09e1aa48149af
change-id: 20260307-fixes-9d8b95012a49

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

