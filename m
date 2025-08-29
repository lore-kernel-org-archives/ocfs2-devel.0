Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C7E2853EA
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 Aug 2025 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756474144; cv=fail; b=HrcgcHKH2vn44xVTTZKRn9W7TAq/Ey97FasNjtJxTKFIFkzsXLi0wN2D4IkoMctcbKmU2TsxGJZPhw0AK6j+5ybPXmtfQlCIuLsoGRFY1ig93O5iWdtEh5YlG9avzGpwaMUowdIlGqtnfTjwmKq287Xx0Yu5yTaBY02RXDwanxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756474144; c=relaxed/simple;
	bh=yIz42VtVRkv5y5dngmn7+6zPodnW8cIbrPLif3SvgXw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EBwoqFRPQyLdQ1XBZCYXwNPXiA83bl+B70qLxT4FhFZrbxBVj6uF6uG4pbz7Jgn/xKVBAR4Ile970GeDhdJ2XGk94dgVvzDn3G4X/Gz4+TWj4EXlN1tGQgSjrjPko4mMKkvA9aO7Ljvqdl4txuPV+Hl0owc8s7XUcvBvohwRTkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FW2RhLO8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NNZ/3YzR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FW2RhLO8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NNZ/3YzR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCtlHJ032011;
	Fri, 29 Aug 2025 13:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qVEh1C46yVxRgLjoiPLEvOJ7RqDakRo98VIufOVZ3bE=; b=
	FW2RhLO8aIw1v5suZxZ5+SmwTo24uTdnUAE5wWF6fOK23hTegLg5Z/gpAmLcAJzU
	BZiXdnCSCyJlj7FprYZ4DC0B1mxGERSlcMaEuK2YBZhT8Tt5Ra2/KmTkvqTACPQb
	56PIf8soe6BnJnQQ+qk9wN6BImb6nQXp3VOZsMqXhoH7i14oVmFVvwLkqbdvr+/I
	EQ86+dJIFRoRmyBgQecSBRDp5Otb4xuLAkRLkCYvjI4M3wGF4KE5v8d8M05tc+zc
	uGd183uH3C2fDuxgmMdzpqvtSTiKnkQTnAldsVBfdLBE1mmmQhfrpObY4NPIOLKR
	dOpx8gBAn7rhR2pZ5SjUrQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5ptap9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 13:28:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TBhxk0018999;
	Fri, 29 Aug 2025 13:28:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d7rkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 13:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=puHhW6mOcKA7LCjffvEZ+iMMl2lKm5EwiqWAni1SvNC1OE+o6TxBR5noVhJsfXzmprjmkADuMLipZEEAl5tYJ1t7TLMAsE9cN1JXsrneoz2A3ew2xEoG5ZaMUg7HGt7+KvseKRMhLhD6WwONL6xbu4AovHAkGqy0Sl/jzhRvYHC1Q2x9pkFOJbWJ61kQEmoknstFmjhjMpW1jkjwAStJ2N28mZj+9/kx/OHLQeP2C32K5p/fKYQsb9blwgnXTjHDoqP62+YqL7pvxO6wYfQwvkbxjypqfdxsSJ7IFzq0yGnNtW5QoOI3Rsk1GeLzxrjAMoWT8p5Or252om82aTXzMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVEh1C46yVxRgLjoiPLEvOJ7RqDakRo98VIufOVZ3bE=;
 b=JXO2DZFfbPjJAJ5gX6V+2Q/J7KaHs8P8ZFdr3sjQZADV9pGjZxDo4iHfNe9bPkhrQDyd2MxBkVFK35w5Ecytp4MXc6opDVogM01fBTIbD/pDYwgpaJTcJBwCCPotpEwspZbvVnb1J8lqNbdRGGCkUtFrNmCB1x41cA7B+9EH0Qs0ynUOvfJ529mtcB6KZqeaJJWSM83A5sh/QmIoZK2PMQXUFqPYUMNhSDePqIZ0E74JNby9SnqELXSXlmB3ib9lJQGONZmTLnIE1p/ympU7DIniAtecoPBirwTfmZ47XKYO4+iu4eZoWzKsd8grD8EFUjanRwDTMUskeDNdQwSqKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVEh1C46yVxRgLjoiPLEvOJ7RqDakRo98VIufOVZ3bE=;
 b=NNZ/3YzRrvJ3YiYvT9yS8zezMLz9ENKQtGS2UDNIzeb8aDEwqSln4mUPKN0ljkYxyGROq8O1ZOwQS//F2PFQr95BCTSJMW/GLD4Uuxb3kgmGwHBU0uSBtqe1EPSdZmDyYZ+PbHR99jA3U5i2/+kg/XFFjT3zF0IhQ78AfMRrorQ=
Received: from MN6PR10MB7491.namprd10.prod.outlook.com (2603:10b6:208:47c::19)
 by IA3PR10MB8042.namprd10.prod.outlook.com (2603:10b6:208:50c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.25; Fri, 29 Aug
 2025 13:28:46 +0000
Received: from MN6PR10MB7491.namprd10.prod.outlook.com
 ([fe80::4ae9:8d81:d500:ad76]) by MN6PR10MB7491.namprd10.prod.outlook.com
 ([fe80::4ae9:8d81:d500:ad76%4]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 13:28:45 +0000
Message-ID: <358141bf-cd0d-460e-a5e4-a4d3065a0d25@oracle.com>
Date: Fri, 29 Aug 2025 08:28:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [v3 PATCH] ocfs2: fix recursive semaphore
 deadlock in fiemap call
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
        "heming.zhao@suse.com"
 <heming.zhao@suse.com>,
        "syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com"
 <syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com>,
        "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20250828154733.13591-1-mark.tinguely@oracle.com>
 <DM4PR10MB7476AAACC3BCFAA61077E606893BA@DM4PR10MB7476.namprd10.prod.outlook.com>
 <93589648-9595-4fd1-a80f-5d1995c23fd6@linux.alibaba.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <93589648-9595-4fd1-a80f-5d1995c23fd6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::21) To MN6PR10MB7491.namprd10.prod.outlook.com
 (2603:10b6:208:47c::19)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR10MB7491:EE_|IA3PR10MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ae5589-3773-4b97-9290-08dde6fffad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHhPTHdhcU90d0gvR3pIa0xlRGFLYkFlL1k4eWlzcEdZbDhkaHV0bHRGQ2VT?=
 =?utf-8?B?TE9SRm9kdFZTOW5JSmEvbEVCanV2OGo0cG5qNnBtek1ySHd4NzkvRTdRaGhU?=
 =?utf-8?B?a24ydUM0LzZlWmVLSDAwdTRqZk11b2JsVjVDMDkvdEJFQUJxNVRXUGNtUzFi?=
 =?utf-8?B?SXp5VCthTnpUc2NRNnZkb2pZYzgxeFZLQmRTeHJOSVdSYVdEMXpSUTVLNVM1?=
 =?utf-8?B?TjFRaGIyemlBMXNabzdrOGovcEhSYzBuZWg3U0psMjNPT1BBWXZ3am9DWjZz?=
 =?utf-8?B?Yjdjbi9FU1NpMytzWWljZW8vU0Z6UlBsRWh2NjVOd2JRcXdwLzhqRUtvcWZF?=
 =?utf-8?B?dG9wQ0FjNytzckQ3TjBkUnBtbVhNbzB4WTlGZkVjcjQ5ZllEWHZzSytBS29S?=
 =?utf-8?B?Mmc3dVF2SFBEUEZCWkU1L21ORXB2NlNrUXZqbnZXWE9HSmRiUWRpRW9IWlRT?=
 =?utf-8?B?YVpqS1QxRE5mQk9Falh1b0VlSlFVOTQ0ek9oc1UrSTNiN2pUKzFSTlJOYlpR?=
 =?utf-8?B?L05OcG9wZlE0VFozWm1wUDg3azhPdlppZ3hEOEduQnBiY3dKUnFxNWwwRDh1?=
 =?utf-8?B?dGRsNldHUFFFMEZ3SFFNeUtLZEVjVHdPQVBDWE1SWC9IZGlPSGJUR2xMdDRZ?=
 =?utf-8?B?OExLNEduVGd0YzA1YUppNkI4b2hlUnJuMVpyY2EzOFhsQ3FlRGZWWTlkY2tO?=
 =?utf-8?B?a09UNVRtK2JzL3dtVHlTY1N0MDI1SmQ4TE9DazU5V1BDSUlQQnBNOHQyRWxj?=
 =?utf-8?B?ZFdkVXNkZXRTaGVLeVlOYUQrUHRUK1ZRZG1XQkd4ZE03UkNuQ2RINHV6d2tK?=
 =?utf-8?B?SDRXaUNnaXEvQXl3V2FUdTBJSm9VSW96ODVzZFZ5Z3dZVkErMWE2RkEwWmNZ?=
 =?utf-8?B?clVPbzRqaEJtd1JFVENkR2RRSlI4b0VkNUY2WU43cE51ZHFRc1REeC8yWVE1?=
 =?utf-8?B?SUs0dXBob0tzNGhIRDdoY0h0bWlGNWg0aWhxSTlKcGtJZG1mTlhBR0E0ajZF?=
 =?utf-8?B?UmQ4MzNsd2JzWUxQN2lndmgzQWR3ZDVQei82TXFlN2NuUXVIa1FGSWMzTjA3?=
 =?utf-8?B?RUJ6Q095cDJCbFJacklMV05YQ2hoQjgydG43elpGd3NROHJGT3Y1cHJuWVdC?=
 =?utf-8?B?aGlLLzNqblRhcDFKblFKd3lKU0Q2STg2bzB1U0piVHQ3dUNMdy9XQmNJN0g3?=
 =?utf-8?B?ZGtEQkM1Z1pVZGt3SWdnSnZqTWVMOXl6T2h4aUc2QmcrbVFydHRBK2pTdFU2?=
 =?utf-8?B?OTFQbjgzZkRmb21BTlN3RWFwaE9lTmZML3A1Yi9lMHhUTCtVanptZ1J4T25W?=
 =?utf-8?B?Y1NLMkNINTBZWFZ0RUpZdnZhYUlkcXBwQUlnT2p2bEtISCtscEt6ZTZ0eCtB?=
 =?utf-8?B?dy9WYkIwQnk2VFVzUVFSQXBoK1lMRnlKcHkwOE9WbTQwV0JZK3k4K3dvSHdN?=
 =?utf-8?B?QmUxcTI2QTFSdmFQMlAxOFQyU2xLTjVVbXRJSDc2cE5sWHczeE9TMDdEMnhy?=
 =?utf-8?B?UGVxS1huNWowQk5yaDQrR3ZXRzZYZU9yOVNYTnZqcTEvM2ZqbTdIRTNKNGxG?=
 =?utf-8?B?alNUQ0lvVlhNK2NHcjloNTNXQkpjZmFHeG9YaUdhdXc1MGw5eER0WitnS1FP?=
 =?utf-8?B?UnF5L1lyeWQ2WFVzZ01VM0VwcHFwd3d0VGpoNmtIbUxpNnFBaWtEOW9sZkZX?=
 =?utf-8?B?bHkvNVBReTNGbURucDUzY0JyYnh2enVGYVNvaUdZeEJoSzRiOC95L1VzQ3JW?=
 =?utf-8?B?MG94YmxwVi9wMTdIUTkwQXRSQksxQ1Y1cVNrRTAzaE1WWTJEa3ZZLzZVRm9C?=
 =?utf-8?Q?Vewxr6E7hkmt4dZoTSUqyooPrhDnR4qEEqXIA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR10MB7491.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDVPSjJLNnhGV2V0SFFqU0xmVnozSzRXcSticThXQWIvaXJ1Z3Q5MFB1a0Iz?=
 =?utf-8?B?SmkyWm43ajRmRktLRGF3L1R5WlVjQlM1V1dYQ1YwU2tzMTQxR29TcHMvVUoz?=
 =?utf-8?B?WEdOSWFGSzB1MEdCRlNWOHhvNk9RM2hOY2NQcUsrcjF6R2RmZ3VGM3hSMUFH?=
 =?utf-8?B?VlVhUnppcnVWT3hzR0lmMzlzV21CSHZDdVRlVWdFZEptM0U0WjNZWmUvKzZs?=
 =?utf-8?B?K3FEdW1UUTVhTndNRVp4NDJuLzdndHQwamZxWHlaQjArZHRHUUpOeldTNUJH?=
 =?utf-8?B?b3NxaEQrdnJnNzA2ZEFPZ3Zqcy8wVXYrQ0xSdVo2TjVYa1Q5WUwvZW5ZZDlI?=
 =?utf-8?B?cXplZXF5QWFIYjYwekpDYTBRcjJ6d0xScTM4SmlVTnR5QUxEUmlrZFpHS0ZF?=
 =?utf-8?B?dXNBMWRvSjRDTmJoWkhsOHRCbC9zcjdWMWE3ZmpQekdHUTBqd3pHcjYwakZL?=
 =?utf-8?B?Sk1jNXNUMmg3ZXRqOHpzWlRkbE11Z0hrcTNmZlJlMm9qWWVHdG5QbkI0bXI1?=
 =?utf-8?B?NzJuTUtGM25hWDBmalZ5QTJ4c3grVHlnQjM5a2wxRmROYUxWVjN5cUZDd0hN?=
 =?utf-8?B?bk43dVFxek1VVW9hb0NQbFFtNTdQb25uZG0wY0t1YjA5ZWJ6WVdCRkxqZm0x?=
 =?utf-8?B?ZFNaV3RKSkdyR3pRODlWYitBRFFabmZjYjdRUVQ1Z2s2QU5Bc28zMU80cFBa?=
 =?utf-8?B?UllrY3MzY3FoVWxVV1FlMzBWNzU5SUlpeVk5VWpkdUx3UGIrd0dhT3NpOU8x?=
 =?utf-8?B?L0RBTnpMc2ZtWE1nT0djZ1J4bVhxUC9OSWFaRDloYktIYWFDK0p2RlhRWHp0?=
 =?utf-8?B?V3J3YlhrRnpUR2tyYVNESWxMQjJ1ZEEyRFFVNG1aNzMvcjNraW9GdHE0c2Jv?=
 =?utf-8?B?YStoUWNOTEV0cUlWQjliVXVxSTd4Y2hDU084dGVFTTgrSWoyTHFFWFE4RVpv?=
 =?utf-8?B?TmFMaFd1c0dmelo1NzlIb3dMSXVxTUVvcmlmNDdyNElveDAwaHN5ak85T2wz?=
 =?utf-8?B?S0ZSTTdiRUtXWDBCQW1GM3NPMUFOb0N1aVQvR0xkQm1xZmt5TUROTytJNCtr?=
 =?utf-8?B?VWhjRXpQLzQ4Q3lBU0trMzIwcVk0WTFESmxOWk8zbkZvQXRPd2hSaHFkMlFR?=
 =?utf-8?B?NWJ5dEpmTkd3VUFnMG4yVGhqQWZPbHM2MkJpUXZHY3l1YVFDZ1ZmaFdoeEYw?=
 =?utf-8?B?bWxuQnpYOGF0OXdSa2M3V1hhLy9WQ3k5WWQ5ZjBKT1oyMEJXSEE2MzVBdHhq?=
 =?utf-8?B?dXVoNWdSWDZXWVBLdk9WazB0aWNJcGpScEV6RGFhNEtjRFo2WlcvQjJuT3My?=
 =?utf-8?B?anpvRUwyd0d5Y0k2RDhzNjlqWHl5ZXEyM2JmT2t1M0VxOVJEWnJ3MXJxa2Jz?=
 =?utf-8?B?TzNSZ2p5dGFVamQxVk00TVd2MVVJRy84NEtSNHQxWXp2Q3RSK0QyZlRKSFFD?=
 =?utf-8?B?R1dyK1hiR2wxQ3Y5aWd0V0NwQ0p4dGhrL1kyeHhBbmRBajNrYlFYa3c5VjhS?=
 =?utf-8?B?VjA4UGlaSDRWdSs1L2hjem1PajN3RFljMk43L2svQkNxZ3ZGYWZZeFRQZUpr?=
 =?utf-8?B?eEwvdThhdFlHNFgySzRQY2VHakVrWmRXQlo3OWVlVmpDa3FmMGtDcFFuWTBm?=
 =?utf-8?B?T0hKUEVPQjF0bjV1RkhWcFloNDZhU3h1bHc1bkI0dWd3VnorT3R1SWJXQlRV?=
 =?utf-8?B?K1lDZ0JXSEQ4cnBqd21pM1dzL1pkNEFPT01uUHViZTBIUjRzYi8rY095TGJn?=
 =?utf-8?B?NUE3d1Q2c1RqVTlSTlpMbjZlYWI0YzdSc2RFYWZTa2RoZ1ZKd0VFSDVDMjFp?=
 =?utf-8?B?ZUY3MUNobGEzNFZQU3g0blYybjlRODlCaytROWdkZmJSODBlN1IvblNBQkNi?=
 =?utf-8?B?eFM0Qy9EWnNhdVNYREhtS3hoeEkzNjFWWEdQT3Q4TThDUnRCZFN2cEhoQkw2?=
 =?utf-8?B?N3laMWplcEFZUTQycWxSb3phSDYxVVFXMVVPNWtvQlQweSttTWhxUWJZU2Rs?=
 =?utf-8?B?Skp3bU9LSXJxT2NRbGVHTVdIVHRlZEpGeWI5Q0ZLNnNyYUpybVBTdkNkVlVH?=
 =?utf-8?B?TVBHMTFXSFREdi9ldXc4U0pLUzZIZ29JNVkxUjlQZGNQTnptYWdONmprWS9p?=
 =?utf-8?B?aVBoQjlJcE13T0NnWHovaUV1OGFSRDRkclZBQVV1S0orQTBnRElzU0tiMzBZ?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y+97DFNPxLiRyNLgWyfUGKzfNzsYHfTH1wRToKO73zIy2mu+vf4/aMyOpQEyEm4YNjo/I0Edp1sMsWcPczquVlOz7jeRVbGIAfEcXRhDh9AZwlaHEI6pSPouzPc8lZpJIKRCH1dzuQC/iHcYivPeEww30Qy+GHC7t3al+rK61x9JXNfomCiBmR6PMNPeX0w5yZ+R1WR7Y+lON2P9ZfpK3/D5hQ3Fv4svvcYxDVIKSUQ1PCTLl5ReC2yfHB0uh21+kuZgCuINQGHtKHr4R/KZ4D7pVl6OXZRnUQ0Bx6M4+RYbgDStol4W1MvsVVPfMyyC/80YZHrBs13jCFshwCsIW1c56H0dT1/N+jLAJKvWbHDtTK2PJho3tOyJRBU59qYvZ95GTXD/lySgeVOtShnHZWkyWP3ZXLT9fVgPX+7NID81n28YCIL16PuuZIjeSWANqQnaPye5lGsSqxsHAGdlwKxQZAPhm3Vl8S5xX+Y4cVM2aShQwB3+RkCPcwuDThUCoAyHpfPwoT7Sv9/OJx4f2Aa5bUiG6GNvP6059hEBD+EMrIDsN3lsdQHKdd29cWIKiZesqZ+6skLmyVUpoJxJLLQ72J5EoLYQphzHo2N1GaU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ae5589-3773-4b97-9290-08dde6fffad5
X-MS-Exchange-CrossTenant-AuthSource: MN6PR10MB7491.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 13:28:45.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKaah1937OJ3UeDEJ1zK1Ge+WmXe9cD3WfNuu9esHjZ18TtSwNeEUl2lmjApOpH7pj9TKoqV35fQHfTz3SU6yLCWSYBatkzWFUY2682LjH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290113
X-Proofpoint-ORIG-GUID: NW2jKGE-YpEuCEUuWYcW70SyJFUNC4RP
X-Proofpoint-GUID: NW2jKGE-YpEuCEUuWYcW70SyJFUNC4RP
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b1ab16 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=_ybb-wMthbpQJprW7mIA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX1WK1bD7uQeJi
 VkXAiXE+8tvwMD5MpqpZCuGHBRInTstApEB1uyk/KifnvIjYsyvksTPZUlELdQD4SJfjLwMODNk
 8DK4ubX4v5Zp6Z9ywNDNjsXFc98JhskL6FvMEEa/nOXrhLF2X3shEVDTWVOGDbQbyI7MnDybVuZ
 PFllmHlJW+kU1xeEPbfUH3lzRX2UVDWXBLuH1PCxke+xxbP62rdrclP63nQJVYoPGCjSgaw4afZ
 Y5FbGMM9/BW0jdtpKbB3DwjguYXkeYqp8ppD08VIu9vCHYKz70atg353ecER+DUt2udsedbURiN
 M9RpELC1jpFpxzc/7SRzk4W3pjofF7l+64GQaC1rqpXVY9QLXDnjYP15ZjN/C1lpqctdOgZS8ls
 BHvuoFpR

On 8/28/25 9:10 PM, Joseph Qi wrote:
> 
> 
> On 2025/8/28 23:53, Mark Tinguely wrote:
>> syzbot detected a OCFS2 hang due to a recursive semaphore on a
>> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
>>
>> context_switch kernel/sched/core.c:5357 [inline]
>>    __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>>    __schedule_loop kernel/sched/core.c:7043 [inline]
>>    schedule+0x165/0x360 kernel/sched/core.c:7058
>>    schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>>    rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>>    __down_write_common kernel/locking/rwsem.c:1317 [inline]
>>    __down_write kernel/locking/rwsem.c:1326 [inline]
>>    down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>>    ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>>    do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>>    wp_page_shared mm/memory.c:3762 [inline]
>>    do_wp_page+0x268d/0x5800 mm/memory.c:3981
>>    handle_pte_fault mm/memory.c:6068 [inline]
>>    __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>>    handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>>    do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>>    handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>    exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>>    asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
>> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
>> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
>> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
>> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89
>> f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f
>> 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
>> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
>> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
>> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
>> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
>> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
>> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>>    copy_to_user include/linux/uaccess.h:225 [inline]
>>    fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>>    ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>>    ioctl_fiemap fs/ioctl.c:220 [inline]
>>    do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>>    __do_sys_ioctl fs/ioctl.c:596 [inline]
>>    __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>>    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>    do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f5f13850fd9
>> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
>> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
>> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
>> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
>>
>> ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
>> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
>> to read the extent list of this running mmap executable.
>> The user supplied buffer to hold the fiemap information page faults
>> calling ocfs2_page_mkwrite() which will take a write lock (since
>> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
>> semaphore will hold filesystem locks and causes a hang of the
>> fileystem.
>>
>> The ip_alloc_sem protects the inode extent list and size.
>> Release the read semphore before calling fiemap_fill_next_extent()
>> in ocfs2_fiemap() and ocfs2_fiemap_inline(). ocfs2_fiemap_inline()
>> now returns with semaphore released.
>>
>> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
>> Closes: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7__;!!ACWV5N9M2RV99hQ!NTMKVnLmJgrhlYd54LbJrSh-LYdJHOiPt6yBu8E6fL4ZIyBsfKWEPjK4RjXsQYcKPJyOSy5qkOZa9KpJyZhjl4WebbHI$
>>
>> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
>> ---
>> v3: also release semaphore in ocfs2_fiemap_inline() with semaphore released
>>      move semaphore before calling fiemap_fill_next_extent()
>>      change the error path to release the semaphore to avoid an unnecessary
>>      semaphore down/up in the last loop..
>>
>> v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the
>>      read semaphore before calling fiemap_fill_next_extent().
>>      Add a Closes: line
>>      review noted missing semaphore change to ocfs2_fiemap_inline()
>>             suggest moving locks to fiemap_fill_next_extent() call.
>>
>> v1: change the ip_alloc_sem from write to read.
>>      rejected in review.
>> ---
>>   fs/ocfs2/extent_map.c | 27 +++++++++++++++++++++------
>>   1 file changed, 21 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index 930150ed5db1..20045fb1bb70 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
>>    * it not only handles the fiemap for inlined files, but also deals
>>    * with the fast symlink, cause they have no difference for extent
>>    * mapping per se.
>> + *
>> + * Called with ip_alloc_sem taken and returned with it released.
> 
> This makes things complicated.
> 
>>    */
>>   static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>>                                  struct fiemap_extent_info *fieinfo,
>> @@ -732,10 +734,16 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>>                           phys += offsetof(struct ocfs2_dinode,
>>                                            id2.i_data.id_data);
>>
>> +               /* prevent deadlock to a mmap executable page fault */
>> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +
>>                   ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
>>                                                 flags);
>>                   if (ret < 0)
>>                           return ret;
>> +       } else {
>> +               /* return with the semaphore released */
>> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>           }
>>
>>           return 0;
>> @@ -769,6 +777,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>            */
>>           if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>>               ocfs2_inode_is_fast_symlink(inode)) {
>> +               /* ip_alloc_sem is released in ocfs2_fiemap_inline() */
>>                   ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, map_start);
>>                   goto out_unlock;
>>           }
>> @@ -784,6 +793,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>                                                    &hole_size, &rec, &is_last);
>>                   if (ret) {
>>                           mlog_errno(ret);
>> +                       up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>                           goto out_unlock;
>>                   }
>>
>> @@ -803,22 +813,27 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>                   phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
>>                   virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
>>
>> +               /* prevent deadlock to a mmap executable page fault */
>> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +
>>                   ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
>>                                                 len_bytes, fe_flags);
>> -               if (ret)
>> -                       break;
>> +               if (ret) {
>> +                       if (ret > 0)
>> +                               ret = 0;
>> +                       goto out_unlock;
>> +               }
>> +
>> +               down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>
>>                   cpos = le32_to_cpu(rec.e_cpos)+ le16_to_cpu(rec.e_leaf_clusters);
>>           }
>>
>> -       if (ret > 0)
>> -               ret = 0;
>> +       up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>
>>   out_unlock:
>>           brelse(di_bh);
>>
>> -       up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> -
>>           ocfs2_inode_unlock(inode, 0);
>>   out:
>>
>> --
>> 2.39.5 (Apple Git-154)
>>
> 
> Could we simplify it in the following way?
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 930150ed5db1..1ab4bfa6fc24 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
>    * it not only handles the fiemap for inlined files, but also deals
>    * with the fast symlink, cause they have no difference for extent
>    * mapping per se.
> + *
> + * Must be called with ip_alloc_sem read lock held.
>    */
>   static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>   			       struct fiemap_extent_info *fieinfo,
> @@ -718,6 +720,8 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>   	u32 flags = FIEMAP_EXTENT_DATA_INLINE|FIEMAP_EXTENT_LAST;
>   	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>   
> +	lockdep_assert_held_read(&oi->ip_alloc_sem);
> +
>   	di = (struct ocfs2_dinode *)di_bh->b_data;
>   	if (ocfs2_inode_is_fast_symlink(inode))
>   		id_count = ocfs2_fast_symlink_chars(inode->i_sb);
> @@ -732,8 +736,11 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>   			phys += offsetof(struct ocfs2_dinode,
>   					 id2.i_data.id_data);
>   
> +		/* Release ip_alloc_sem to prevent deadlock on fault */
> +		up_read(&oi->ip_alloc_sem);
>   		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
>   					      flags);
> +		down_read(&oi->ip_alloc_sem);
>   		if (ret < 0)
>   			return ret;
>   	}
> @@ -803,8 +810,11 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   		phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
>   		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
>   
> +		/* Release ip_alloc_sem to prevent deadlock on fault */
> +		up_read(&OCFS2_I(inode)->ip_alloc_sem);
>   		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
>   					      len_bytes, fe_flags);
> +		down_read(&OCFS2_I(inode)->ip_alloc_sem);
>   		if (ret)
>   			break;
> 
> Thanks,
> Joseph
> 

yes. I was being fancy to avoid an unnecessary semaphore lock/unlock 
rounnd trip for other writers. I suspected that this was going to be the 
next request.

Mark.
