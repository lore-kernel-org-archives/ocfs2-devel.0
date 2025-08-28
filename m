Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01222A4E1
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756387456; cv=fail; b=HyVYB/UQVXoqUeSm40Azv2FKsXXbcyTRi2vkcCQ2K+S+FQhrVgauSLhrkfZQ87TuEXEaeUoRyfK73x6MNMC9a23hu5yHfKGJc/FI9+edPJMUoWs5hL0h9bPl+T82cl2KlvQNplLEIyQTWTwmvWc8agAw13DbWlBi7ih72AuCMrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756387456; c=relaxed/simple;
	bh=C4ZxXgAhbjitFq/9bc99DD2tD86QqmNPNa5aYTHTegA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SGWmT0Dt+dKCiQweRyliyhUAjCmx17pvLLlmwFfx6NasJZK7kf8FwbmNHcEbkyLEuK1I9VPpgJyuVL+Vaous6h/WS5gEnt6Y3MYzvQ1N6XHPA8cM98l3Zx5LvVqq19xLFn5s7VjQm3HUBZ/af2oEr5N99TIjYBmrFpEuETeMdNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KzA5NBcq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FV3tsMtv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KzA5NBcq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FV3tsMtv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCj6tj009474;
	Thu, 28 Aug 2025 13:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T4cIq/jduiWRzIub0BdKjeAAIGEBgSeIcIOTlUs1Dnc=; b=
	KzA5NBcqdJ0QOSSX+sDOX78DP3isbncjKe/dMtAL90WP5X0j6AeosZdMZ+SIDqrh
	eQah6qe7DEkkpFyr5h74ddWjzzzj8eRRE4KBmHSD/pz8jxgAfecA4RMN7KH8vbTj
	0wtfylVF0GAqstZz8eAdZ0aqIC6bUs4tm+RAbKe9BkbVrjCLlEdRntkInhH5JzkH
	obKJfanlYdLasBkQnAozl63Jr2lKfRbsyb+CbkJ3/shkqSWiYJZ97pikn60h8DSM
	S3Teoe8ogB17CorPGd3LdnMKa969HcTBVpfE0pno2U9N5sBwfuY1++BSiN/81rPM
	MCZXfjbjoQ+H9WATHxyaBg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twf7ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 13:24:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SBvJwv005318;
	Thu, 28 Aug 2025 13:24:07 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c4uk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 13:24:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=phVREWUiyGuOzAvjL/mmM8Shv02CFUr2rMZr57BGbHhp1QOmd4ZUWD2zyK/Pp9sWvOiuAHVgGryqiUDmKTJvK24rrHyUfLfpP95G8Qf0ZVOQeYoVSq2F21aVQwJ8KZ4Cj93/e/cuhvfsLnijFgg2WJXpCwUm9koljcDq3lJZ6GksRHGEdH7fyWTiZWckJBiQaTw6tWtym4zNSjTBQSdtXTNZjTfak7NDINbHB9KN9jIDvs6Blml5uabnp8SM7zpGEuinv3eIiTz5CXWcy3HtAzyn8kvPfycKSq5DX0TKhARMr2rDrBZLlfKmB40fgo0nj/vXofr3InaOFAiMPkHd8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4cIq/jduiWRzIub0BdKjeAAIGEBgSeIcIOTlUs1Dnc=;
 b=coX06ouov9c1Az3qdG5BLN+gi0gRcejeNsDNfZJuug8mlbd88CbSoemU2eW5NnJlcYAx+YmqVrjBTSvtWVExxoRmeo3XH/wJ8ali4XmznJxsDwOsRnIn17kQ7gV8zy2bAWMbqQBIUeUpyCEU7yJOn6SDs6bSfCQk0G09EuXl0gJe17IieBYkZq7+Izh0v0jNt772ncoUSDR4KU3JTrqRNv/MeNH5OrM+MwBD1p0jDYG4QUhjUXmXEK5uRXAV7SSOQqFEyScLZS8J8KbUfnUGDSVKkEvuye0NplRBmlT6fWyloMwbwiQHSuu+KNmgK889azXtF6uTQ7zQ0J/3vQ4Trw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4cIq/jduiWRzIub0BdKjeAAIGEBgSeIcIOTlUs1Dnc=;
 b=FV3tsMtvSSePbM956VFqq0wtLlx4OyqDF2MmRxv8y1ro6M0M43l4/rf9G7ULHYs02vBG4DJYAh5HzraxCB379v8GiJ/xaq3E599yEw8l2dEw6rhWQifz5exWAzadPQoimMroKOdRY32U18Od4gjsnI2MHGqW5CLqEyutWncD+aw=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 LV8PR10MB7870.namprd10.prod.outlook.com (2603:10b6:408:1e8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.15; Thu, 28 Aug 2025 13:23:59 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9073.017; Thu, 28 Aug 2025
 13:23:58 +0000
Message-ID: <72bef530-65cd-4450-9003-182139695a79@oracle.com>
Date: Thu, 28 Aug 2025 08:23:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [v2 PATCH] ocfs2: fix recursive semaphore
 deadlock in fiemap call
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        Mark Fasheh <mark@fasheh.com>,
        syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com,
        Heming Zhao <heming.zhao@suse.com>
References: <20250827145919.30162-1-mark.tinguely@oracle.com>
 <bc1472a7-493e-4696-ba72-d6b8686bea88@oracle.com>
 <c01b031c-8cde-4c9b-ab28-c2eff0b06fce@linux.alibaba.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <c01b031c-8cde-4c9b-ab28-c2eff0b06fce@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::15) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|LV8PR10MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: bc618ae8-18eb-45f2-a146-08dde6362553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDl5dnhZbmh3bCtaRUxKZ3BtcjRwZjFBYVlFR1daczdPMDRXcmV1cmdRTVY1?=
 =?utf-8?B?VnpxdXFaZmh1TUFmckhucldOVjgxcDQwM0doalFNQjVUYkNTQUtyNTRNMk40?=
 =?utf-8?B?ckVLY1o4RUoybVo5dEtvZE9IemJRbnM1NWJRbFBNNVhDdERZazh6YWRmVzkv?=
 =?utf-8?B?NmNlbjJxU0dsM3h2S2ljd1hqcTFSZUpUcmIzY3VOMmV0ZEIyUFZIalFvVGdz?=
 =?utf-8?B?Q21JRUNoV2hzZ3pMcmk3N1BVQzdDOUkzMjdwZk1hb1g3U2JDM3NJOXVpYkdZ?=
 =?utf-8?B?cDZTcEZmanczL0EvZGc3NTdKM2RURGJyajZXNnFQZmNKR3VEWCtvYjExZGp1?=
 =?utf-8?B?dytQTVRsS3pJK0NJRDNUbVIrR1ljMHFQYjI3Vzhnckl6Mi9TRGlFWHJHM0x2?=
 =?utf-8?B?T29VcDNkUVp0YmJ5MDJlczV0Qm1LcGZHOVI3V3FIUXZNRlZ0emtFRDNWY201?=
 =?utf-8?B?bnhSVllWOSt5R1pITFQwOVdMb3pXZ2h5LzVMWTRDaUxWVFdKdHV2OG9CblhR?=
 =?utf-8?B?Y0RLTittWDI1VzVkNjQ5cEp6N0FrWVN5Qjk2VHZ0TUQrMjR5UWp5dnp0YXMw?=
 =?utf-8?B?RldxdVp0NnVtZVFqc0dla1lEdWQrbGtBMkM4SWhDR3ZldWZBVWFGWVdTVXNP?=
 =?utf-8?B?NkZjSFNtYkJFT3FRZHBvaFhjTGlhem1lNEZaMnlySTFUR1N4RC80VTZDVG9h?=
 =?utf-8?B?aEl1NUZKY3d0WG0rMW94anN6VGRodE5Od3NlK2p2SzZqejRNelFwV1l6NzdK?=
 =?utf-8?B?OVVZQ2x0NzN0SmE5cVdhMk51VkdXYThDVEZ0NlpFMVNadEdIWTF6dVlUcDIr?=
 =?utf-8?B?ZUZpbUV3OFl3RkNuMFkraVB4UDVFMlVmSDQzQVBJU1lLQ2JjVDVlSjJkbFp5?=
 =?utf-8?B?TEdwNDh0TUZMaWJHcURCenlzbStUUHRqVXBYdG1SYmt0cGYySm91VXRqbkZz?=
 =?utf-8?B?ZVNRN280RkxxbzJaNHFDblNvUHovNWR3OGlKaXZCYVY3U05keG4rMHo4U0lj?=
 =?utf-8?B?cCs2VzRHcGhzZytYUFJVV0sxQ3JYRjRrbWF1a0RnakZJRWliTFRmaU5OMzVP?=
 =?utf-8?B?Wk1McUJvQ2hqOXFHb2dIM1JtZExGK2JkZGYxOVdLb0lCbk5qdkpQZ1Vxc0RV?=
 =?utf-8?B?K3JvdHlWL2pDVjFzWXJEYWgxMVJ4eGltTmhYS3k2aXJQaW15VHdwRVNoZmM3?=
 =?utf-8?B?SVNhM2huNEhybWRnbklNdkVKNEVjRmhPM0xDTFE2eFNOd25pZTVQV3BKeENV?=
 =?utf-8?B?OWpvRU5CTnJNaVZQNjI3Q05uZTRSN2xMNzZBUXY0ZWVCQkNzZDlqb2kzOVVK?=
 =?utf-8?B?bHFJL2xsOHVSQ3VFbjd3M0oyWUtCdnNjMG84MmltV1J6VFdZZitweUZaeDUv?=
 =?utf-8?B?cjUwNURIOFpLT3E5cjhJZ29aYlNzT01PYXRrMHQ2dUt5a0lmZmZxVVB1Wm5K?=
 =?utf-8?B?Vnl6MGhPTmlZT3B0bnBsa3c4TlRwQzJCSzBoN3g2UDJUQit1Wlk0Rk02S2lL?=
 =?utf-8?B?NU15MVVkRlBtUyt1bUhGYUNwZFBHTDFQQis5Z3lscXZNZzliZHNlY1FjdVBz?=
 =?utf-8?B?ZDZkYTQ0SnptNzJUK3VBZHNPTU9Pek9kaU5oWlNpYWJYMkcwdGtDUE5NaXRv?=
 =?utf-8?B?Wm8zOXMwV3JUWXJhQ1o1N1dmaUptK2NzcURYRE8wRkE3MENtbVNEL1VTN0l2?=
 =?utf-8?B?WWVBM3U5Q1RXVGFQcjA5a1dwOTRIVXoyTnkrR1lhVXZuOFhoREJ6VmtheHBm?=
 =?utf-8?B?OG1sTG9TME5yWEdpT2k2dU9JV1ZIY0hoTTk3THhMZkRaQnZ0cTVhdHYweXdr?=
 =?utf-8?Q?phCE5JA2E5W1kPoI/krsY0lt+Bkhs4Sz1bLbE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mlg1cjkwbVI4aXNObkNyZjlqQU82aVE0d29iRDhkWTBDWHZBeCtDOUkvOUVq?=
 =?utf-8?B?eDBLd2FmdzNObUd5NXJHdzZtdXUxU0ZLYmIwdWg1VzN5alRHeHZXdTFDVDNa?=
 =?utf-8?B?Q244MGNQdlZEbzg5S1NoWURVUnhXeW9VTlllNzZIc1RlU2NpUmtsM08vWFJE?=
 =?utf-8?B?dXdtNG5IWVQ1bDhaVW95WTFVdWdDQUN2M01HY0J6SmNTL0kyeS9jWFJEdHhv?=
 =?utf-8?B?NmtqaWNZTHJhRnRMajFjUkV6TDBEOTFqaGx1ZWxpUFhBN0RWRWhoVFpxbDA0?=
 =?utf-8?B?Vm9FLzMvZ0lQOTVPd0FGM1dyUGtDRW5hMzNVQ2hNWUxMSzlrSFZvdzdiWmY1?=
 =?utf-8?B?Tzhuci8vaGlpbVBnc0pRL3NobVdCU0tRRnp2UDV2OGpJRExlc1RUTlJ6ZnRY?=
 =?utf-8?B?RXJZcHV2MGV2K2krWXNNVldsL2hvZmJBeDhZaVU4a3ZVdGNvc1BveWN6WnR3?=
 =?utf-8?B?dUw5WUthTFQyaGx0eWlTbkpKNStmYXkvcXduZ3g3dit3NDk2ZzhGVkd4ZkM3?=
 =?utf-8?B?bUZTNDBBL0orUHptTlpHL00ybUl4NVVWalp2WWZVRm4xZi9iOG5MSytKOFRD?=
 =?utf-8?B?blNDekwvekhHYTFhTXU1NTl2NlUwMGJXS2VsWEY2MFJQNFB4MGY3L2o4TjhV?=
 =?utf-8?B?bG4yTE04UVJobk1kcVVKcHVoR2JsZkp3N1JDcktiK1pRSzZ4OGUwV0dyUzk4?=
 =?utf-8?B?VU5mUFg5czQveWloR25OVityMFA4RWRUejJUQnEvd1FYRnk0VVRVRWpYbWdq?=
 =?utf-8?B?b1R1M3dtR05oaXg3c3pjYndqOUk2RzlIUXZSbWFVUHJSRDZsWGhEaXZFZ1NS?=
 =?utf-8?B?bDc5YkJJcjV5OHZqNmdJZDhQdTM1SW53bVgzVERLTDhvS0tXYzVwMXpjYW1l?=
 =?utf-8?B?UjNwVmtvU0RxTGlzeGs5elZJNUt6MEdNNDErRzJkRGJUbUF3eGFuRlhVVGt5?=
 =?utf-8?B?MitRNzFqbnJEenhWaGpjWitPVkM2VG1RWk5EZ2pZbE8wdDBlaGNLcTFMTGxl?=
 =?utf-8?B?Y1Y3N3NYeE5TNlpnaThodkJVbkxFYVNQUm1URktnNUFxZ3luMyt1MzQyNXVE?=
 =?utf-8?B?WlpOOU05MnNHL3llR1Yzb1JUeHN0Rngra201MUFFc1NqOGFCYlVreXBYUWVO?=
 =?utf-8?B?MlVYOVhSd0JmclU4SXhsbHl5MjN6R0tHM3RRZkdhOXE2dnliSmR3KzhzbVBv?=
 =?utf-8?B?MFRGWVJIMFNjRHc5b2kwaVFOQXZtSFVTUzNwQ1dLV1JQWFcwSWgycEV5NTcw?=
 =?utf-8?B?Uzd1bTU3VDYzQTdueUJEY1JTL2p5T25CWmRidVl2SWoyTDFnNVZSNXIrTzdz?=
 =?utf-8?B?RWJRbm1reER4bEQzNS9kVjRscjJyTkI3Nk9KSXY2Tmpia2RhOWxGN1hQNTkw?=
 =?utf-8?B?RlMzUkVrZy9aVlZGK2J2ME1pbDBXWmVFcEVsdlNiRWVXR2JPbnJyM1JlNHJK?=
 =?utf-8?B?TFh1ZG9Fb1BkMDBEcUdkdE16N2NxQXZjMDdoelB4QmNhTWZDVXhqenpPL2lu?=
 =?utf-8?B?M21qN0g5WEV2dmJIMVVpczhsNW4vNWFLMTduR2UvaFk2RHJRSnhNVWhxMm5m?=
 =?utf-8?B?UWt1WmY1MC9RMEhkelZqTlF5N0RiNWU5RWJhZ2JuR256WVU2Y1YycHhrYkVM?=
 =?utf-8?B?N1RaOFJKcUxhUHdZQ0gyQmxsaGkrc2hYcnBXaThRTEJYNElIOUdxSjE0clJL?=
 =?utf-8?B?Wmd1c1RONkIyZW9uNG9kdXF1N3JLSzA3QjRKOE82VFFTTkw4UlZTOFZBbWpx?=
 =?utf-8?B?by9SVkVEcjJ1NVVtWEp3S21JTG1NT1hSczVrWXpCVkFtMG5vY2gzRm9WUWtS?=
 =?utf-8?B?cFNlaVYyZUltbnZiYitXd2RLR0grZmd4VjA5bzQzUDlvbmZiaXVndmNWdW5h?=
 =?utf-8?B?Y2FiWmIxMHdySjRQbE1wM0w0aWJIeWpaRlYwaFI3RFhqeTVNUFpRT1dWREk3?=
 =?utf-8?B?ZEFkZEMyNEdMUDZwQTlnWXpUSUpQY0RuU2RZbEsyRjN2MEFoaTNBOUthbnZK?=
 =?utf-8?B?WjRKVytEY1lCMmR2ZlBQYVRZVzEvS1p3Z0xUZVRxOEx3OTJEcUlWYVc3dGxx?=
 =?utf-8?B?QXBnenhnZDI2Q09OaW9HQ3V0RnJ1UHRmZEFUUGF5Kys1M2xyK1psaUVDM2Fp?=
 =?utf-8?B?YW5qSlIwRmlpdjN6NnBuenRodnR3elowRGVKK2YxVnFZZENqcDlHTnBKNDV4?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sEum8+JBXyZ48r9jTyMkJVqCCXcFAr5Z3VHSuacPiZh8SrrScLjDsOvAsiyaOxohL2euLcAm6fHDU81vzHrRxiqkw0gQkhy5E48OXq8ACcqPgOTFg26tdqlcdNRLQ8VgFvHjAPdsgmoxAa7WtrdzPkEsYkIQ1JTP1NE0VZSYnj6wUPlVQyqcwT257bd481/ZSMP/xyHTnj5YMfGSQbIZhTr0axA17ZeHyXgSWf0NrG4WBorcXZedfvl6yB5x2dax9e/0efxAOjTJPonyjvRoT/dwaHqysp05lD3Kx5t1kUGhwCHRz08bJjbNqVhL/3udDoPsWUhoynEcy7SYTZGMu2RNDRvFUPygY4eNo30+2OTBZYqaI8FjwYoMKBTFIQmO132O77BeeqNt5awoTLuWh4Gd0xIyKwnm+ML+IyABT1tjFz0LnUzq+YHjyDMhKkG1GVC6FJnIRYx8dgqR5kbNIZpBCxrFus1xSZD9Ld1st5JeDq5zNSe4JmK3n26rI2OVa/EnaDskFEw1AxnJnToUeK8tNyq0TbTdSPyBI9VBBDqsXJx1rY+KkDDLYjOj8Jkq0A1Tvd84csUmMs3D+XMD3Y97ZUdrODIJPLh5Tl41e4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc618ae8-18eb-45f2-a146-08dde6362553
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 13:23:58.7478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6V+NqCYZdNDdJ5tRIvLPf+T+s4+O3UG0At1m/XK0cn6m12OoYXTBytAMDwb6RdhyHbcE9oaJgI3xZC6Eyeu1tOv4bXEoHY+sCsExqjLRaN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7870
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280112
X-Proofpoint-ORIG-GUID: umDcxVx-_P6XQK8UMnuKxsnHZFtOtZtv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX7lJjv3ENHHUS
 8sa4kvV6Q7k38sddY+2yvoLojNeWW/djCFTjopTLuz7+NBQ1YgV3dvyl5uuPZ3koHyTxoSL/KaR
 CO8fO1iBpp2kSDPFqP3P0jiXJ0q2UbSw0rJZsATCLnFMSGx0bnfqQXYgqLmxD9vTa53z0fmhT5o
 IkudbNDE+vJQMjobMWOQ7zFVcehMAfwkucDQcFWnJtSyp/mkpDfw7lLi9vEcIlmOUc/h/lsP8G1
 oLsyqowchHJoL6HGzQAz2maHj16F49wRfWaklnekxxdtCQIzHvF49f2CV/jAHRX1r8hr7YwmkaG
 UupRsMyFiuXurUqRUuU55NCOtl4xPbP2Vg+8Pj2bKgR/uG6WJZqBv4NPJ6s0bxNMPNs/X49q8TR
 seXPB1cudgALyEe/LaxF3gbpFcJN8Q==
X-Proofpoint-GUID: umDcxVx-_P6XQK8UMnuKxsnHZFtOtZtv
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b05879 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=dhObolFH-ahQT-CUFNUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12068

On 8/27/25 9:59 PM, Joseph Qi wrote:
> 
> 
> On 2025/8/27 23:08, Mark Tinguely wrote:
>> syzbot detected a OCFS2 hang due to a recursive semaphore on a
>> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
>>
>> context_switch kernel/sched/core.c:5357 [inline]
>>   __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>>   __schedule_loop kernel/sched/core.c:7043 [inline]
>>   schedule+0x165/0x360 kernel/sched/core.c:7058
>>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>>   rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>>   __down_write_common kernel/locking/rwsem.c:1317 [inline]
>>   __down_write kernel/locking/rwsem.c:1326 [inline]
>>   down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>>   ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>>   do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>>   wp_page_shared mm/memory.c:3762 [inline]
>>   do_wp_page+0x268d/0x5800 mm/memory.c:3981
>>   handle_pte_fault mm/memory.c:6068 [inline]
>>   __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>>   handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>>   do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>   exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
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
>>   copy_to_user include/linux/uaccess.h:225 [inline]
>>   fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>>   ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>>   ioctl_fiemap fs/ioctl.c:220 [inline]
>>   do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>>   __do_sys_ioctl fs/ioctl.c:596 [inline]
>>   __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
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
>> Release the read semphore before calling fiemap_fill_next_extent().
>>
>> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
>> Closes: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7__;!!ACWV5N9M2RV99hQ!NQWZn6ZfHJBzrwNzQIIax4inwXItCl67GJFyzS6z7xrb6Wc7MTpNAI0jS7HQ3wnRRIOCSOQZEeWWreyni6I3lCKHlVER$
>>
>> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
>> ---
>> v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the read semaphore before calling fiemap_fill_next_extent().
>> Add a Closes: line
>> ---
>>   fs/ocfs2/extent_map.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index 930150ed5db1..c9e19ce73976 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -762,14 +762,14 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>           goto out;
>>       }
>> -    down_read(&OCFS2_I(inode)->ip_alloc_sem);
>> -
>>       /*
>>        * Handle inline-data and fast symlink separately.
>>        */
>>       if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>>           ocfs2_inode_is_fast_symlink(inode)) {
>> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>           ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, map_start);
>> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);
> 
> ocfs2_fiemap_inline() will also call fiemap_fill_next_extent(), then may fault.
> So could we keep the original down_read() as it is, and do up_read() before
> fiemap_fill_next_extent()?
> 
> Thanks,
> Joseph


Thank you for finding the other fiemap_fill_next_extent() in 
ocfs2_fiemap_inline().

My first test I wrapped the fiemap_fill_next_extent() with the semaphore 
as you suggest. I was trying to simplify the error paths. We can release 
the semaphore in the first error path to avoid a unnecessary down/up 
round trip in second error path in ocfs2_fiemap().

I will send another version.

Mark.


> 
>>           goto out_unlock;
>>       }
>>   @@ -780,8 +780,19 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>       while (cpos < mapping_end && !is_last) {
>>           u32 fe_flags;
>> +        /*
>> +         * fiemap_fill_next_extent() can page fault on the user
>> +         * provided fiemap_extent if called on the running mmap
>> +         * executable file. The ip_alloc_sem cannot be held or
>> +         * result in recursive deadlock on ip_alloc_sem and a
>> +         * hung filesystem.
>> +         */
>> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +
>>           ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>>                            &hole_size, &rec, &is_last);
>> +
>> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>           if (ret) {
>>               mlog_errno(ret);
>>               goto out_unlock;
>> @@ -817,8 +828,6 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>   out_unlock:
>>       brelse(di_bh);
>> -    up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> -
>>       ocfs2_inode_unlock(inode, 0);
>>   out:
>>   -- 2.39.5 (Apple Git-154)
>>
> 

