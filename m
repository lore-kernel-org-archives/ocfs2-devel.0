Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ADF1CFA9;
	Thu, 12 Sep 2024 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726111942; cv=fail; b=SnyaGRqNnm6n5A1j1Lmk6YAYKdJfBgbS/3T79AJEqZnWdv9wt1roDfgNrsVQIaWxzB5Q8r94JgBysLIFIb+qv8UzdVfNUZ7oatkaF6CFHvAT4GmOP+kMFu1LCyaq9SJR+W8UmrwFcevvfE5O9/++B2g6YtFttPkF1/q0NcbfF7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726111942; c=relaxed/simple;
	bh=eziHNyHI5jA/k432LxXnfIb4TMk+gK1QBRp1hsLKBH0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NHBP5DtlI3VqjUH4rnVj3H3Bc252QnRMfTE/fLcXdyXrJX+WXDXSEDDpU489ocOrlCHjgyQw8RN9CXJEkgliz/6QeBBg+S+90blY5iAWisxEtlRNs3B1KsiMZWvvk8qkJFPBB80juV2cG2cGwn2PC3RQv+iwSeiza7t4REyhsf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i9VizcLE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B3uEkJkg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i9VizcLE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B3uEkJkg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BMfXY9020068;
	Thu, 12 Sep 2024 03:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=eziHNyHI5jA/k432LxXnfIb4TMk+gK1QBRp1hsLKBH0=; b=
	i9VizcLEqQ4EvHFobwL+9+TbZKVJ/zXqhb5/lktQY+36xm76g/aV+QW7P9UFvtZ4
	a3cKEdHiWSJfWO38GfTHmd2F7MxaGGwCR20aFdFms7MsHKg0O5sEzmrrAhactcKl
	wGto94k1rtCZy2q0Eg0kvvqsNSPHi9BWZv8Nqls6GoNhU4Tofg4GZbRdkw0Gp9qF
	QhmLXIm5Op63Cq+6bBotsXz7rW3ztNvvAlZByD/z5466kVcp3YtnAk7kr5bCC3f9
	Fc6yCFqTYt6AfA+Bu1OrydcoPZ2gqdgZbJzrnj5XEDnMtd6E49ZsWaiRnffHsNP7
	jXy+s4akVXlzEkFDKKkoLA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gde09pn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:32:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48C2YRux036194;
	Thu, 12 Sep 2024 03:32:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9are85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:32:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkSvIcMha40JdDYBs7g5XSdookm6qunWRAt2+NsUCY+D0rE4Qe86WaN/jg9e4CdVOKXg1YT7MnqZI+gZbynPk0yK04+fR82lE1fBx0CtB3ruL5VOoDgIlWXiF92hYPvplvLhlhdnrH52f6/64EVD/rpM4qBZJ9OGGV0r4RQI/9Tw9d0inVq2m31bOg9KCRQ8HYhBb0X86spKqlTxIF7fCWQq9lymYxh8nTuO/+pvMm5AXAxorclevvkt3TLcjJi7Ak4MMr7HnWJJVt8AYy16tsFSoKd7ca8/EzkcJHysc+7w2gMOSu4EBeO/B0avy/48x6DZ1/LSHtsM9VGPMAQR3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eziHNyHI5jA/k432LxXnfIb4TMk+gK1QBRp1hsLKBH0=;
 b=COlzKLkEiYlVqVnTb5ZmI3Eds2jK/LJFUCJzWarsGH9a4C2o3GE8TMIW0P5EOYiDwoI+S7JS36flWFONMogVs+QqiMT20kH7gouG8l4KVFYmAOj7hyLRVTsGmO8yGfQhPWCiERVmTuJVtcRIWpJ+t5MBfx8+gHq/GFP9SmN3WuCWcRSSHiIH9IJKPRl2YVZPcSKujMxA3s36m2krTnLmbg4yoOUUaFl5Uh/hFcxC+fSN4FzpbqIxYdHvL41Y+HuYfVwB+so5rdl73e43KYSP6JYMh/wBJQEU3p4CTyWhMH1b9pIjVXxFmID/sxqv/kAESCy1+v9kDUCgvPceV3YpTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eziHNyHI5jA/k432LxXnfIb4TMk+gK1QBRp1hsLKBH0=;
 b=B3uEkJkg+yME4PZFtlmKYwgHqCXHhtrFVcurn9OYXoZxDFtetXiY+jwfazNaPSTN6wsokg/TMHlexrhri+qpk+8X0w1sMgZjRd2QQF/qfyDxeObFRC8ORW8SOi7ylefC5ww7XW4V3Q3K7lQLihKevCG9goh4vPkGxK6ORYBusAg=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 LV3PR10MB8106.namprd10.prod.outlook.com (2603:10b6:408:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Thu, 12 Sep
 2024 03:32:11 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 03:32:11 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbAzuchhJs3uz9/0eQNZPcDSyJHLJSMd2AgAFHZYA=
Date: Thu, 12 Sep 2024 03:32:11 +0000
Message-ID:
 <DS7PR10MB487867341DD9F7939BCAA513F7642@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20240910044045.257958-1-gautham.ananthakrishna@oracle.com>
 <6b8f2dee-12a7-4a8d-a67f-e4c67277d230@linux.alibaba.com>
In-Reply-To: <6b8f2dee-12a7-4a8d-a67f-e4c67277d230@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|LV3PR10MB8106:EE_
x-ms-office365-filtering-correlation-id: 71848cfd-cc89-4724-e5f2-08dcd2db7cb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VFNOcWdjNmtxQTRvSjlza3J3VWI0RkxXajFPOWFKQ2lGVUNGWmNUcVlFVmV2?=
 =?utf-8?B?OHJxRCtERXZaWUk2VXFVeURDaDk4dVdTeFJJNjBCYXlRWHVGRi9lRllGOGdM?=
 =?utf-8?B?N2NINFRuMm5EQXd2aWYxQlowNUlEdDF6RTAxQndTaklrY2tzNXRQSmJJR0Vs?=
 =?utf-8?B?cUF5WkdvWXgvcDY2bzQ0Y2ExQXBnNG5FTHdOckpUeE9jVWRtNVJtVkIwNEow?=
 =?utf-8?B?N3ZObHB1c0kwZUp1dmE5ZHVtTThHRFlGS3VjNFpGeldNMEhOYUlsTyt6aDNC?=
 =?utf-8?B?SEtSMkFISm51SVAwOU5aQmQxVHpEVFYrZTVHelphUXFDSGVFZXdBYjJsK0JI?=
 =?utf-8?B?UVM1dXpJQ3BwSzRtTHgrandxQmR4cjhuZFIxeCtkenVOa0RhUkVTYzM3elVQ?=
 =?utf-8?B?Y2dKWDZwek5WUmhoMEZDMXcvd3ZCbkZVQUNpeUFTT2ZqSGZXWmlqRURZZTIr?=
 =?utf-8?B?NVhuWXRJbStvZFBNY21EWkFmWEZPY2txRldpMzlXN0s0MDdvTHFXYXpsVTRS?=
 =?utf-8?B?c0lHaEhxMlk0dUdkTUtBeUIwdDlPaDJWMHZaODgwTzZEQjJZNzhjY0lPNExC?=
 =?utf-8?B?Mm9NcWpPdGR5QlFuclA1eDJVbCtxNVJvcGJneVExeE5yVmM4ejU2K1pOcnNC?=
 =?utf-8?B?S0VhYnA3emQzcStpUCtUbmdCa1YwNzFyc2RTWmVLZS9jNXNFWmJIV3ZWenJ5?=
 =?utf-8?B?SmtuMGhKYXY4U3lDQ05jdnFGT1RjcTZ2Uk1YZTh3WC9QdUk2RlpCaUxDWHpw?=
 =?utf-8?B?dFBwMnR5aVc0QVFERVovRjBxSTNqRWhoVzNoYk9aMFI5M0VuZkNxR0dCOFQr?=
 =?utf-8?B?eWdwZ3UzUVJYZURmaDFISkI4OU50ZjNyOC90UGliVFd4Y2VsYzFva3hLci8r?=
 =?utf-8?B?aW85VmJkQXhPR0dEMVllZjB3M2RSblY3bnhGa3VhS2x2aEpOU3E3M2pxQ3dH?=
 =?utf-8?B?ZlNOd2JUUHdEVzZtWjNDenlodENHTy9WNzRxMC8yRGlaY010dlh3LzhiNmRN?=
 =?utf-8?B?MG9FOXFvc3p6aFpqblBtQThJbVR1M3BwWHZ6a1pJS0tTRjhMVzlPVWJwZjUx?=
 =?utf-8?B?MENGcnVEc1NEWGxESFE5TUpvZ3N1OFBvT1kvYXVKWG9yVUxTZFVqdFloK1FD?=
 =?utf-8?B?MDJtVFEvV0VVZ0EwTndlRUphSGJQa1VsRGh2TUxTc3hydjE3anpWV0FTTzRU?=
 =?utf-8?B?eUV6ek9OVmdhVDJLT0ZsaFd1cUNYNnpjYnZHV3hMcDFoMHk3Q2gxUmVsa2dN?=
 =?utf-8?B?TThZcFlQN0tOUUc4SmhqelYvZUVqdGN1dmMxT3ZPQWdicTRIYkdEaUluODNQ?=
 =?utf-8?B?d1NLRWl1SmEwR0xkWHpmdHdiUnRUY2w4NU1ZaUloaWw2ZWFGRW0xelJ2ckZI?=
 =?utf-8?B?TG9qNFQ1T3BkeFFHRWJsVUQ5SE1sQzA5dThaNk50WjE2Nlo2T3RJcDFsZUJO?=
 =?utf-8?B?eWMxRkVHa3VjLzVCRDZyYld1M2x2V2pteGJXUHRVSjM5Yk9LUlhad2RMZEdW?=
 =?utf-8?B?bHFDYW5tVURmeU4xaUh2TlEwM0FmTlVpbEVCd2orZDZHR2o2bm9vdHpaYkpW?=
 =?utf-8?B?OEF5MTNBWFJrSU1qUnpVcC80S1ZGeWltRlZKT1RqK3ZrUldwNEorMWJ1c1pt?=
 =?utf-8?B?NWZmZGxodDc2U0VSUUMxazAxYWhWYVNxQ0VsMUsrWkY4cnd4dkVFNEZhc3pv?=
 =?utf-8?B?dEs1eTVYVVp6bHBGa1JxWVN5eTBUdTdaV2pxSXAzRjg5VTU2VlU1ZnRGcTZU?=
 =?utf-8?B?b2tJVTh2Y3graGVHb0ZxMStFK3lZMlBkdE5aZlFtOS9qdDVpVGdlNGFDQVda?=
 =?utf-8?B?cVVpU3RSSE9sMkZHR0N2R1B5ZEh1VTVOUDFsMjBSekxvOXhKMUt3OGN0a0xm?=
 =?utf-8?B?dmVEcmNtRUlIbUtoZy9lRlNHOGNCdzdic1A4T1VKT0kwdGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZzZGZ3VJcXpKZDJHTGk3ZW40OFErZnlOdy8rbWx0ZlpkWms5ZGV4VjZmWHh5?=
 =?utf-8?B?b1lEWjIwS3ZXb3FDRDI4TXZzUWJDcU9xUzE4UzRsQnkwSjk3RkpzTFBSczMw?=
 =?utf-8?B?TnRHMXBuakdETm1iR0tNMTRJU2EzeWN2SUp4RmVYdGF3b3pwczdqOEVIQTR6?=
 =?utf-8?B?SUI2MWRZM05VWUYwODcwRnZEQ3p4U2xlUm5WL0tsdVhTakU1alZaN1QvYzZy?=
 =?utf-8?B?Ky9lWngxc1NlbkdESk9oTGNUMFQyc0E3bXU3K3lUdHpoNk1FbGdyVFBtNTN3?=
 =?utf-8?B?RzcvbEl1L25LdzVNbHduVHZkbmxFV1NpVVg1RHBESHNqR2h6YmRkeG00Z1dz?=
 =?utf-8?B?MFJTNHdraHo2N3NHV3UrOWlHaWFsVGkyQlEyTGRSZ1ViUFpIUCtQbjVUVGJj?=
 =?utf-8?B?d2l6Uit3OFRLOWZxQUN6Zkh5cXJxbG13SEh4K2krcmtaU2pSOVQra1g4SDZE?=
 =?utf-8?B?ekZ5OFczM3p6bFpnbi91Z3o3SzVsUlpUR3pMZ2g5YTExS1RLUEhlM0o3emJF?=
 =?utf-8?B?bVkxV1NOWEx1SmRKblZyVlRMU2gxNFZyVmd3VEk1c1AwYU1SNDcrRWFuQVJ6?=
 =?utf-8?B?bjFxd0dxcWl5YTFUa1lkL09aMmMyWEp0NDR5Ynd6VnJKS29qWi9NdnRWQ2RV?=
 =?utf-8?B?aHpsVUtWQWlyc3FXc0UveTNpOVNIZGlpYlc1TTNhL1BwdG1SMUJZb0Noa0Rv?=
 =?utf-8?B?Wm9NN0FWYUhVTEpqNkx5OUNLd3Y0dzN5ak1kMldPS0oxcVZYUzROandaZDRJ?=
 =?utf-8?B?ZFNHOC9UZW1iSTFSS3RyZ2h5Mzg5YUlCWHFwdDhTZUU1SzhKNjA5LzYxektB?=
 =?utf-8?B?RHhaSXRZZWREYjhObWdmSWR4Z1FjY1Y2TmNURHBpc3ZMUUk1Rk9qaHRPVHZn?=
 =?utf-8?B?RnVkTWdBWURvTzQ0eTI5cmN5WGtadFY0djc4dmFyb3hGVmxmMzNqUVZQRTBQ?=
 =?utf-8?B?d3IrWWVZcDRpSmhVYzg5UmFJNGZsZmFNbUVqYU9mMkhYK3kxMjlPK1NzQ3ho?=
 =?utf-8?B?NjFyeEg0U3VRZUNJd3RuS2RUZzBlYUJiTjhvV1phQlowM09sTnVCcnVjdG5R?=
 =?utf-8?B?aDY5cXRDZHllZEJ5TzZaV0JXRnFReGcwL1B6RThNcjFEVDA1QkZwWTFPUlZN?=
 =?utf-8?B?VnVGbjlkTXl0dlVPNzYySHAzUFBpWU1WRzhxeTNnMzJKd2lac3VzVmVSeG9X?=
 =?utf-8?B?UG5kbllHTm5wLzhralFuU1AwdVRINmEyLzg2VWlBRW9TbEMvdU9yTXFKRm5y?=
 =?utf-8?B?RmtERXkya2cyekdpVVlxU2Y0RS9IQmdmWnJxaEZ6RWM1REtHZ3RySU4zR2Fz?=
 =?utf-8?B?MVY2QjhwZzNISHl0ZGFLMTdqcHh2TWRlTHNTdXhyRTBiSWlPN25VbmoxNk9W?=
 =?utf-8?B?VVM4U2VnWUVSaVU4RGZIZ2M2WEs3UlA5aWZ5ZXJYTlZuUFc0NEdUMkU3bEE5?=
 =?utf-8?B?SEZlY1loWEs2Z29RcXN0eXlWSCtpTnQ5SEhNcG9WZGlSYnB4alhyODlWcEU1?=
 =?utf-8?B?VVQ1SXhxc3ZibFl6dFV2eE1TQVNyUi9LSVlZWTBhUWxZYkpHTzhpTU03eE8w?=
 =?utf-8?B?YUZTZWRFRzU1V212ZEl3NVNyL2pmY3BJaXpuVmdQbEl1dlJqYnUvaWVsT3Rh?=
 =?utf-8?B?MFRYTllaUTZSdWFuNmRkTmlscUgzRUt1RURBa1ZWZXdxTG5iZkQ5cTdYT1cw?=
 =?utf-8?B?NTJyMEZVWm1Lc1dNQTQ0cm80cXJxVExhOXJwa1NhVExIM0tiMEJIcnhRZkcy?=
 =?utf-8?B?VFZGOHNwenNFUzRwVmRsek8wYmF6dHFEZ29mYWg4UHMvSjJGZzlERXV2NkQ4?=
 =?utf-8?B?SExWbTVQZUVmSy8zM1ZFR2NjUDhPWUJCaGE0NHAvN0NObHpTSkhvSkFFM05o?=
 =?utf-8?B?eHdNNzdpYUhDeWowbW05SjNLTU5ZWnZKSzRyd0MwTWxDSTBZK0lsTVI2Y0FB?=
 =?utf-8?B?UFQ5dEhGV2lIQjhsN0QrY3J5Zlk5SVdoNzlnYndOSVRkRVd0dnVJNzRaalJh?=
 =?utf-8?B?dkRpcXVFUVZJVnpBeElkZXFwaUV0Sy9EOU4yQ2JRdlNkOFZkRkkwSzFmT2Fn?=
 =?utf-8?B?Z3lqUjgyNDl2dVRSY2pWbDI2R1lzN3RsTFNKVHg5MU8wSHdYSkd1YnNTU2gv?=
 =?utf-8?B?bjVtRHE4RFp6bUV5VDFReHM1TnlHYVN0S3gvT0toR3BMRGRPekU1SmpBRDRu?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wohQ+DlyWcY+3hH+WMhDYk4iO6PYBrEyuTISYkfWvvEstB6pPLiygons9NLnpM5wqPd++jFIy8s2MDMoo3IOe/J9/oZQNhnPwUAnOntwodyhkBtmkG7m5dB+CD+lGG48Z36/sg68i9nYNg6xUCTuOWbwpAER+bhvCqORdSMEKNJ3elQUdUBMYqMyQcbLqiTLzToS4r4f7XZWanT6czKV1JiaBhfzKEKJlX6gfaVMXJUMmXugmarU1zvJtO2iazwO8QDxogW4La/TvOB19xEOIeciQRJudiBbuK/sG4iDMsRzqM8dPXpT13v3O4lRuWMxYAuqdENmh1Qp1nQBDZz3iEfoBnVNcgTjT1ZYSxbaLxTibMg0Z/kfPz5Gad2MGnTJjSrv7b6xKk16V6xUATlXgIuDmws0ujFUbj9aSrJQ5il3EHmvvYYBgTdMuST6zzDnOXO3IcxzPzI16n23FAJb6rRiC5tk2cAM6qVbG8EkMtuIn+dE2/qSSqhk6+kvTLka4CGtNO8LUDvpvlXZGj85Gxydv2xAvvt3HqL6Ze84fsA4KiKLzp3dX2WR+wFVFV381w+OxFV3FqsFd8J1PlY59ZIfXULiLWEPHsWmdnlEvT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71848cfd-cc89-4724-e5f2-08dcd2db7cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 03:32:11.0864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uit71n9GNAzzo2bkpVx/hfHeLjEwmMzur9vseAbtUPTuC56hHtHfSXsXkcxtSWe1TrHvXwCEdxwLXHk6Gjdvv+4mxTyivZdKV+PjFrOM/pvgM5wbs0cY7aBfk2JVsc6/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409120023
X-Proofpoint-ORIG-GUID: aaJs7fhniTXy17F9-XpyJwGn8r2uty_j
X-Proofpoint-GUID: aaJs7fhniTXy17F9-XpyJwGn8r2uty_j

SEkgSm9zZXBoLA0KDQpUaGFuayB5b3UgZm9yIHByb3ZpZGluZyBjb21tZW50cy4gSSBoYXZlIGFk
ZHJlc3NlZCB0aGVtIGFuZCBzZW50IGEgVjIgdmVyc2lvbiBmb3IgcmV2aWV3Lg0KDQpUaGFua3Ms
DQpHYXV0aGFtLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9zZXBoIFFp
IDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1i
ZXIgMTEsIDIwMjQgMTI6NTggUE0NClRvOiBHYXV0aGFtIEFuYW50aGFrcmlzaG5hIDxnYXV0aGFt
LmFuYW50aGFrcmlzaG5hQG9yYWNsZS5jb20+DQpDYzogSnVueGlhbyBCaSA8anVueGlhby5iaUBv
cmFjbGUuY29tPjsgUmFqZXNoIFNpdmFyYW1hc3VicmFtYW5pb20gPHJhamVzaC5zaXZhcmFtYXN1
YnJhbWFuaW9tQG9yYWNsZS5jb20+OyBvY2ZzMi1kZXZlbEBsaXN0cy5saW51eC5kZXY7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggUkZDIDEvMV0gb2Nm
czI6IHJlc2VydmUgc3BhY2UgZm9yIGlubGluZSB4YXR0ciBiZWZvcmUgYXR0YWNoaW5nIHJlZmxp
bmsgdHJlZQ0KDQoNCg0KT24gOS8xMC8yNCAxMjo0MCBQTSwgR2F1dGhhbSBBbmFudGhha3Jpc2hu
YSB3cm90ZToNCj4gT25lIG9mIG91ciBjdXN0b21lcnMgcmVwb3J0ZWQgYSBjcmFzaCBhbmQgYSBj
b3JydXB0ZWQgb2NmczIgZmlsZXN5c3RlbS4NCj4gVGhlIGNyYXNoIHdhcyBkdWUgdG8gdGhlIGRl
dGVjdGlvbiBvZiBjb3JydXB0aW9uLiBVcG9uIA0KPiB0cm91Ymxlc2hvb3RpbmcsIHRoZSBmc2Nr
IC1mbiBvdXRwdXQgc2hvd2VkIHRoZSBiZWxvdyBjb3JydXB0aW9uDQo+IA0KPiBbRVhURU5UX0xJ
U1RfRlJFRV0gRXh0ZW50IGxpc3QgaW4gb3duZXIgMzMwODA1OTAgY2xhaW1zIDIzMCBhcyB0aGUg
DQo+IG5leHQgZnJlZSBjaGFpbiByZWNvcmQsIGJ1dCBmc2NrIGJlbGlldmVzIHRoZSBsYXJnZXN0
IHZhbGlkIHZhbHVlIGlzIA0KPiAyMjcuICBDbGFtcCB0aGUgbmV4dCByZWNvcmQgdmFsdWU/IG4N
Cj4gDQo+IFRoZSBzdGF0IG91dHB1dCBmcm9tIHRoZSBkZWJ1Z2ZzLm9jZnMyIHNob3dlZCB0aGUg
Zm9sbG93aW5nIGNvcnJ1cHRpb24gDQo+IHdoZXJlIHRoZSAiTmV4dCBGcmVlIFJlYzoiIGhhZCBv
dmVyc2hvdCB0aGUgIkNvdW50OiIgaW4gdGhlIHJvb3QgDQo+IG1ldGFkYXRhIGJsb2NrLg0KPiAN
Cj4gICAgICAgICBJbm9kZTogMzMwODA1OTAgICBNb2RlOiAwNjQwICAgR2VuZXJhdGlvbjogMjYx
OTcxMzYyMiAoMHg5YzI1YTg1NikNCj4gICAgICAgICBGUyBHZW5lcmF0aW9uOiA5MDQzMDk4MzMg
KDB4MzVlNmFjNDkpDQo+ICAgICAgICAgQ1JDMzI6IDAwMDAwMDAwICAgRUNDOiAwMDAwDQo+ICAg
ICAgICAgVHlwZTogUmVndWxhciAgIEF0dHI6IDB4MCAgIEZsYWdzOiBWYWxpZA0KPiAgICAgICAg
IER5bmFtaWMgRmVhdHVyZXM6ICgweDE2KSBIYXNYYXR0ciBJbmxpbmVYYXR0ciBSZWZjb3VudGVk
DQo+ICAgICAgICAgRXh0ZW5kZWQgQXR0cmlidXRlcyBCbG9jazogMCAgRXh0ZW5kZWQgQXR0cmli
dXRlcyBJbmxpbmUgU2l6ZTogMjU2DQo+ICAgICAgICAgVXNlcjogMCAocm9vdCkgICBHcm91cDog
MCAocm9vdCkgICBTaXplOiAyODEzMjAzNTc4ODgNCj4gICAgICAgICBMaW5rczogMSAgIENsdXN0
ZXJzOiAxNDE3MzgNCj4gICAgICAgICBjdGltZTogMHg2NjkxMWI1NiAweDMxNmVkY2I4IC0tIEZy
aSBKdWwgMTIgMDY6MDI6MzAuODI5MzQ5MDQ4IDIwMjQNCj4gICAgICAgICBhdGltZTogMHg2Njkx
MWQ2YiAweDdmN2EyOGQgLS0gRnJpIEp1bCAxMiAwNjoxMToyMy4xMzM2Njk1MTcgMjAyNA0KPiAg
ICAgICAgIG10aW1lOiAweDY2OTExYjU2IDB4MTJlZDc1ZDcgLS0gRnJpIEp1bCAxMiAwNjowMjoz
MC4zMTc1NTIwODcgMjAyNA0KPiAgICAgICAgIGR0aW1lOiAweDAgLS0gV2VkIERlYyAzMSAxNzow
MDowMCAxOTY5DQo+ICAgICAgICAgUmVmY291bnQgQmxvY2s6IDI3NzczNDYNCj4gICAgICAgICBM
YXN0IEV4dGJsazogMjg4Njk0MyAgIE9ycGhhbiBTbG90OiAwDQo+ICAgICAgICAgU3ViIEFsbG9j
IFNsb3Q6IDAgICBTdWIgQWxsb2MgQml0OiAxNA0KPiAgICAgICAgIFRyZWUgRGVwdGg6IDEgICBD
b3VudDogMjI3ICAgTmV4dCBGcmVlIFJlYzogMjMwDQo+ICAgICAgICAgIyMgT2Zmc2V0ICAgICAg
ICBDbHVzdGVycyAgICAgICBCbG9jayMNCj4gICAgICAgICAwICAwICAgICAgICAgICAgIDIzMTAg
ICAgICAgICAgIDI3NzYzNTENCj4gICAgICAgICAxICAyMzEwICAgICAgICAgIDIxMzkgICAgICAg
ICAgIDI3NzczNzUNCj4gICAgICAgICAyICA0NDQ5ICAgICAgICAgIDEyMjEgICAgICAgICAgIDI3
NzgzOTkNCj4gICAgICAgICAzICA1NjcwICAgICAgICAgIDczMSAgICAgICAgICAgIDI3Nzk0MjMN
Cj4gICAgICAgICA0ICA2NDAxICAgICAgICAgIDU2NiAgICAgICAgICAgIDI3ODA0NDcNCj4gICAg
ICAgICAuLi4uLi4uICAgICAgICAgIC4uLi4gICAgICAgICAgIC4uLi4uLi4NCj4gICAgICAgICAu
Li4uLi4uICAgICAgICAgIC4uLi4gICAgICAgICAgIC4uLi4uLi4NCj4gDQo+IFRoZSBpc3N1ZSB3
YXMgaW4gdGhlIHJlZmxpbmsgd29ya2ZvdyB3aGlsZSByZXNlcnZpbmcgc3BhY2UgZm9yIGlubGlu
ZSB4YXR0ci4NCj4gVGhlIHByb2JsZW1hdGljIGZ1bmN0aW9uIGlzIG9jZnMyX3JlZmxpbmtfeGF0
dHJfaW5saW5lKCkuIEJ5IHRoZSB0aW1lIA0KPiB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCB0aGUg
cmVmbGluayB0cmVlIGlzIGFscmVhZHkgcmVjcmVhdGVkIGF0IHRoZSANCj4gZGVzdGluYXRpb24g
aW5vZGUgZnJvbSB0aGUgc291cmNlIGlub2RlLiBBdCB0aGlzIHBvaW50LCB0aGlzIGZ1bmN0aW9u
IA0KPiByZXNlcnZlcyBzcGFjZSBzcGFjZSBpbmxpbmUgeGF0dHJzIGF0IHRoZSBkZXN0aW5hdGlv
biBpbm9kZSB3aXRob3V0IA0KPiBldmVuIGNoZWNraW5nIGlmIHRoZXJlIGlzIHNwYWNlIGF0IHRo
ZSByb290IG1ldGFkYXRhIGJsb2NrLiBJdCBzaW1wbHkgDQo+IHJlZHVjZXMgdGhlIGxfY291bnQg
ZnJvbSAyNDMgdG8gMjI3IHRoZXJlYnkgbWFraW5nIHNwYWNlIG9mIDI1NiBieXRlcyANCj4gZm9y
IGlubGluZSB4YXR0ciB3aGVyZWFzIHRoZSBpbm9kZSBhbHJlYWR5IGhhcyBleHRlbnRzIGJleW9u
ZCB0aGlzIA0KPiBpbmRleCAoaW4gdGhpcyBjYXNlIHVwdG8gMjMwKSwgdGhlcmVieSBjYXVzaW5n
IGNvcnJ1cHRpb24uDQo+IA0KPiBUaGUgZml4IGZvciB0aGlzIGlzIHRvIHJlc2VydmUgc3BhY2Ug
Zm9yIGlubGluZSBtZXRhZGF0YSBiZWZvcmUgdGhlIGF0IA0KPiB0aGUgZGVzdGluYXRpb24gaW5v
ZGUgYmVmb3JlIHRoZSByZWZsaW5rIHRyZWUgZ2V0cyByZWNyZWF0ZWQuIFRoZSANCj4gY3VzdG9t
ZXIgaGFzIHZlcmlmaWVkIHRoZSBmaXguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHYXV0aGFtIEFu
YW50aGFrcmlzaG5hIA0KPiA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBvcmFjbGUuY29tPg0KDQpG
aXhlczogZWY5NjJkZjA1N2FhICgib2NmczI6IHhhdHRyOiBmaXggaW5saW5lZCB4YXR0ciByZWZs
aW5rIikNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCg0KPiAtLS0NCj4gIGZzL29jZnMy
L3JlZmNvdW50dHJlZS5jIHwgMTggKysrKysrKysrKysrKysrKysrDQo+ICBmcy9vY2ZzMi94YXR0
ci5jICAgICAgICB8IDExICstLS0tLS0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL3Jl
ZmNvdW50dHJlZS5jIGIvZnMvb2NmczIvcmVmY291bnR0cmVlLmMgaW5kZXggDQo+IDNmODBhNTZk
MGQ2MC4uYzBlZGIzMmE3ZmY2IDEwMDY0NA0KPiAtLS0gYS9mcy9vY2ZzMi9yZWZjb3VudHRyZWUu
Yw0KPiArKysgYi9mcy9vY2ZzMi9yZWZjb3VudHRyZWUuYw0KPiBAQCAtMjUsNiArMjUsNyBAQA0K
PiAgI2luY2x1ZGUgIm5hbWVpLmgiDQo+ICAjaW5jbHVkZSAib2NmczJfdHJhY2UuaCINCj4gICNp
bmNsdWRlICJmaWxlLmgiDQo+ICsjaW5jbHVkZSAic3ltbGluay5oIg0KPiAgDQo+ICAjaW5jbHVk
ZSA8bGludXgvYmlvLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+DQo+IEBAIC00MTgy
LDYgKzQxODMsMjMgQEAgc3RhdGljIGludCBfX29jZnMyX3JlZmxpbmsoc3RydWN0IGRlbnRyeSAq
b2xkX2RlbnRyeSwNCj4gIAkJZ290byBvdXRfdW5sb2NrOw0KPiAgCX0NCj4gIA0KPiArCWlmICgo
T0NGUzJfSShpbm9kZSktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0hBU19YQVRUUl9GTCkgJiYN
CiAgICAgICAgICAgIF4gYWxpZ24gaXQgaGVyZSwgcGxlYXNlLg0KDQo+ICsJCShPQ0ZTMl9JKGlu
b2RlKS0+aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5FX1hBVFRSX0ZMKSkgew0KPiArCQkv
Kg0KPiArCQkgKiBBZGp1c3QgZXh0ZW50IHJlY29yZCBjb3VudCB0byByZXNlcnZlIHNwYWNlIGZv
ciBleHRlbmRlZCBhdHRyaWJ1dGUuDQo+ICsJCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVu
IGFkanVzdGVkIGluIG9jZnMyX2R1cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KPiArCQkgKi8NCj4g
KwkJaWYgKCEoT0NGUzJfSShuZXdfaW5vZGUpLT5pcF9keW5fZmVhdHVyZXMgJiBPQ0ZTMl9JTkxJ
TkVfREFUQV9GTCkgDQo+ICsmJg0KICAgICAgICAgICAgICAgICAgICBeIGRpdHRvLg0KDQpBbmQg
c2luY2UgdGhlcmUgYXJlIG1hbnkgcGxhY2VzIGFjY2VzcyBPQ0ZTMl9JKG5ld19pbm9kZSksIEkn
ZCBsaWtlIGRlZmluZSBhIHZhcmlhYmxlIGZvciBpdC4gVGhpcyBjYW4gYWxzbyBtYWtlIGNvZGUg
aW4gb25lIGxpbmUgbXVjaCBzaG9ydGVyLiBlLmcuDQpzdHJ1Y3Qgb2NmczJfaW5vZGVfaW5mbyAq
b2kgPSBPQ0ZTMl9JKGlub2RlKTsNCg0KPiArCQkJIShvY2ZzMl9pbm9kZV9pc19mYXN0X3N5bWxp
bmsobmV3X2lub2RlKSkpIHsNCj4gKwkJCXN0cnVjdCBvY2ZzMl9kaW5vZGUgKm5ld19kaSA9IG5l
d19iaC0+Yl9kYXRhOw0KPiArCQkJc3RydWN0IG9jZnMyX2Rpbm9kZSAqb2xkX2RpID0gb2xkX2Jo
LT5iX2RhdGE7DQo+ICsJCQlzdHJ1Y3Qgb2NmczJfZXh0ZW50X2xpc3QgKmVsID0gJm5ld19kaS0+
aWQyLmlfbGlzdDsNCj4gKwkJCWludCBpbmxpbmVfc2l6ZSA9IGxlMTZfdG9fY3B1KG9sZF9kaS0+
aV94YXR0cl9pbmxpbmVfc2l6ZSk7DQpBZGQgYSBibGFuayBsaW5lIGhlcmUuDQoNCkJUVywgYWxz
byBjYyBsa21sLg0KDQpUaGFua3MsDQpKb3NlcGgNCg0KPiArCQkJbGUxNl9hZGRfY3B1KCZlbC0+
bF9jb3VudCwgLShpbmxpbmVfc2l6ZSAvDQo+ICsJCQkJCXNpemVvZihzdHJ1Y3Qgb2NmczJfZXh0
ZW50X3JlYykpKTsNCj4gKwkJfQ0KPiArCX0NCj4gKw0KPiAgCXJldCA9IG9jZnMyX2NyZWF0ZV9y
ZWZsaW5rX25vZGUoaW5vZGUsIG9sZF9iaCwNCj4gIAkJCQkJbmV3X2lub2RlLCBuZXdfYmgsIHBy
ZXNlcnZlKTsNCj4gIAlpZiAocmV0KSB7DQo+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi94YXR0ci5j
IGIvZnMvb2NmczIveGF0dHIuYyBpbmRleCANCj4gM2I4MTIxM2VkN2I4Li5hOWY3MTZlYzg5ZTIg
MTAwNjQ0DQo+IC0tLSBhL2ZzL29jZnMyL3hhdHRyLmMNCj4gKysrIGIvZnMvb2NmczIveGF0dHIu
Yw0KPiBAQCAtNjUxMSwxNiArNjUxMSw3IEBAIHN0YXRpYyBpbnQgb2NmczJfcmVmbGlua194YXR0
cl9pbmxpbmUoc3RydWN0IG9jZnMyX3hhdHRyX3JlZmxpbmsgKmFyZ3MpDQo+ICAJfQ0KPiAgDQo+
ICAJbmV3X29pID0gT0NGUzJfSShhcmdzLT5uZXdfaW5vZGUpOw0KPiAtCS8qDQo+IC0JICogQWRq
dXN0IGV4dGVudCByZWNvcmQgY291bnQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgZXh0ZW5kZWQgYXR0
cmlidXRlLg0KPiAtCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVuIGFkanVzdGVkIGluIG9j
ZnMyX2R1cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KPiAtCSAqLw0KPiAtCWlmICghKG5ld19vaS0+
aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5FX0RBVEFfRkwpICYmDQo+IC0JICAgICEob2Nm
czJfaW5vZGVfaXNfZmFzdF9zeW1saW5rKGFyZ3MtPm5ld19pbm9kZSkpKSB7DQo+IC0JCXN0cnVj
dCBvY2ZzMl9leHRlbnRfbGlzdCAqZWwgPSAmbmV3X2RpLT5pZDIuaV9saXN0Ow0KPiAtCQlsZTE2
X2FkZF9jcHUoJmVsLT5sX2NvdW50LCAtKGlubGluZV9zaXplIC8NCj4gLQkJCQkJc2l6ZW9mKHN0
cnVjdCBvY2ZzMl9leHRlbnRfcmVjKSkpOw0KPiAtCX0NCj4gKw0KPiAgCXNwaW5fbG9jaygmbmV3
X29pLT5pcF9sb2NrKTsNCj4gIAluZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyB8PSBPQ0ZTMl9IQVNf
WEFUVFJfRkwgfCBPQ0ZTMl9JTkxJTkVfWEFUVFJfRkw7DQo+ICAJbmV3X2RpLT5pX2R5bl9mZWF0
dXJlcyA9IGNwdV90b19sZTE2KG5ld19vaS0+aXBfZHluX2ZlYXR1cmVzKTsNCg0K
