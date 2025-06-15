Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BC182C60
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Jun 2025 19:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750015248; cv=fail; b=IFBlDR0/cQWupU98XwDQlpsL0s2toVkV5exjHwDau5tguSwA9unES9wmIsAngBR+7I4FECUDstSVnABiao7h5KKSD4XpJTsw0xeeblvgKzOqCz0+UwBhalpiwaipFGOsydEg/CsQWZ/mxptmJdAa4s6txqvVkUF/F+spvjLUp/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750015248; c=relaxed/simple;
	bh=ho8JUUEl+jGctGtc690vH01V4RTzwDsfpYHqrrOOvFA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mUd++HnQiS9Tg3Z7nPYieplL5Rkkb+cupXROQKWFkj5mGuCC2S+oOza0WJZofRjK911qw8KWEtPF9oDxJb94f5VgYzWPCjo6KP8Go28FvIk+Tqp8KsL1XQSB0dWE4b85MOkIzErlcfGiPQqTWEEgB6GtxKVKJ2nDB/c9ft0WAC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H4nYiUa+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jOWIUHi3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H4nYiUa+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jOWIUHi3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55FIsj0H014744;
	Sun, 15 Jun 2025 19:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JSQnX8Mnv1Q/VU/AO3gnq9R2H+fb8KChgs3HsJiV1YU=; b=
	H4nYiUa+C3mW4IaNkGvkszrbmpkMECUrsqmLKs7M3O0j/5eYgs/ZlIOWtmZSIYDC
	emBT4DIQmmLMdGcWw1qj03TRpveasna4wUhJFrYFUHhicHNWvGVKqhpo1Fv6TlFu
	auaPeMROw06MrfrlFSpFT34LE/PGhH+kqmrtSl0wR29Qh9V3GB3JjKYdRG1cKN+I
	PACz8si+fEoIufMHvowQOqNBEiHqjYjMkvZJv8ht8H3i9ylBAajatrIdcI5smFva
	jUhzT0DeKLt6zd85EEVSLcEw4h6cBIVKMr9Zovd06OOg8K29do1SSaP9V7rg81yI
	yIRdSbS0UyIVo/T27wITgA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900esax9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Jun 2025 19:20:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55FGe9OO031735;
	Sun, 15 Jun 2025 19:20:26 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh6xk99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Jun 2025 19:20:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lG/fiSGzrsCj07sjhwlSc4BzfK/Sjhzq+pTYFa4nZMktAXr6Z0XupUA7Dm7b5zZG8Zp978CIhruLWB6lNvsvkFL07iSOoudOneK2v1opj3B+eMk8VGCucJnDGLFN6jjunIY9mfenW12q7Jz2JWhEPrvyeW6kZ1Z20Sc7oUfeQ6HM1aNPcEic/92T5XFNsRqxUzB5BEAni7lZuH8isAtBapbm71bd0PC93PxbVu9+dmsJ2NIKwZml8Ep8ia+NF0BBw9F/eQu8kf9PNuoj7akfHPsSYOey9V39J9eS8d/ZggPJyvXTstIIGVRs7WcyhZl/ptwGUtHIPKwG82XKyl7ACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSQnX8Mnv1Q/VU/AO3gnq9R2H+fb8KChgs3HsJiV1YU=;
 b=nNnRha3ikyS9WWgW/iMAINGlQwgaPuWUiV8jtyfUK7e+lxoYKdNtav6b+DCH07hH/98wi+PoGpkUeJ40IPzR6ICVRBfayEYBMHzFaE8PB80Vh0ybSKeOVAccranlF5XvMNopVKMPnj0f6g7qQ23Xpok1vuwspYkv9IeHQQS9MYU91PzopTrt/Apv6DJGVOgb/kc+2AEWkyWaDacsrNGciq9otDTOJKBpsFW1sDOXVNGEtKE5VGPloFu6teS30VRDgU0GhzwqgD2zi8948uB6pZOgQ24DXlTLCJEu54gB5qpzezwzH+EjDtk36bUW+xcKoScRKoC2CjaYTpEBZ32WMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSQnX8Mnv1Q/VU/AO3gnq9R2H+fb8KChgs3HsJiV1YU=;
 b=jOWIUHi3QdodbSPTXVT8hhZoW7787PZmIvJExm6WpKq3QNNtf9GMy1DbORDiqiAjyfYVu1y+dU16JI0Qu0nLcAWQJSH2YFo5Pl8o71cU4jJkiECPd9t6ykOZVhhvf2nOaeeXR4xkp8q4oJHwHcsJ8vg1qYlYD3Jow/Ru0y8f7Cw=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 SA1PR10MB7789.namprd10.prod.outlook.com (2603:10b6:806:3ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Sun, 15 Jun
 2025 19:20:23 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.8835.025; Sun, 15 Jun 2025
 19:20:22 +0000
Message-ID: <b92b26e0-e6d9-49e2-b46f-b855831a86fc@oracle.com>
Date: Sun, 15 Jun 2025 14:20:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [syzbot] [ocfs2?] BUG: unable to handle kernel
 paging request in ocfs2_unlock_and_free_folios
To: syzbot <syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com>,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        linux-kernel@vger.kernel.org, mark@fasheh.com,
        ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <684efdcd.050a0220.be214.02c1.GAE@google.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <684efdcd.050a0220.be214.02c1.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:5:40::49) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|SA1PR10MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: 73e667de-e7bd-49d8-f000-08ddac41ac9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlBwaEhsUk5BTUxrL05la25aWXFIZWtiNllhaHUranc0MlFPYXdiejNDYXFp?=
 =?utf-8?B?Q09LSEgzMVltTjFzZDhGalRiMTRQMUpVRDFjK3NCb0RMTlBMckpkR1dOOVlB?=
 =?utf-8?B?aGNwMGo0TnVIVFlUanRMMTlDNXRDbCtXOE5CcjFrRUI5eksveUdWRGxSV2J5?=
 =?utf-8?B?NDcreFJGS0pKYkhndTlwMDZHNysxMm5sdjlCVG9SZ2ErR2RYZEdnb3lscm5I?=
 =?utf-8?B?enJFZURlbENyd1dHOFpPaHc5b2FvWnd2VjZnazhIWWdCUjM1eXpYTmM3QkRJ?=
 =?utf-8?B?Tk9teWZIcWZTUy9NeHlWdFZkNVFRL2E2dWExZnQvRExlR0Z6bVdwZHJKRWxV?=
 =?utf-8?B?U1ZpNkY4Yk5IU1FqQ052LzZpNE9SWGszN0hESVUyQzFxcGhjcno4cGtNNUlN?=
 =?utf-8?B?elNXNHdNME52ZU5OL01tcWtBUzVCQWxaMlFSajBKS3FyVFMwUjBYa2s1OEVT?=
 =?utf-8?B?KzluNDBTQ2FXamcvT3ZxdUp0UVFadDVjdFdqRUhsWmsxWTZoelBzS0s3VFZn?=
 =?utf-8?B?S1BYcFFIODU0aUpqSU82VjQvK2NyWU5EYnY1YnRUVXd2Q0k5eWxQMmZxaVVI?=
 =?utf-8?B?NXlhdkEzYW1BQXkzS2NIOWJOUnQ4bk56TVJCQkxqVDcvaWsxbmlwT0djOHJo?=
 =?utf-8?B?VVBldTR2R3hTK0Y4OFhFLzFaN1UvcW15RDdsNXlUNURjeVc1SFExM3VDTSt2?=
 =?utf-8?B?dzVZTHJ1OThxZmE4c2pJeHlQTDk3YllDQ2t4WlN2SEh1ZmloZlFSeExBT2oy?=
 =?utf-8?B?WVdxenorU3NIVy8wclpEZHRLTnZ4OE5YQmZSVHIweGVmUCtLTU8yM04wdEUw?=
 =?utf-8?B?QlZ2YTEzWjBWcDRIb2RxNTRWQkFtbEZwYTNaR08zcHdOYXNpaWpOWWE5UVdO?=
 =?utf-8?B?YkltTlRGNTZBMTA4VzNMaHN0UkptQXd3bFcyN3J1WkxFaTVsU0U0Rkh5WFdW?=
 =?utf-8?B?TGtFMWdDc3dPNURRY01KV0xwS1VwR0lQcGpFcG56cGhpZmhEd3k2UGhMcEF2?=
 =?utf-8?B?a1ZiLzNEaHpveVR6Uk9kVkNDSHVpT1doQTVkSU5UMU5GUG1YYkRYbnZ0SFMw?=
 =?utf-8?B?Vlp2YUJQWlRKOXhMM1BEbVhSNGRnVm40SmdDV0JXZzFUYjRUQVhrbUdQZERV?=
 =?utf-8?B?aGcrN0JDajYzVnphWkhDdFlxTG9OT2Z3WXJwd3A4MytScUhjekhBeUhBNXdp?=
 =?utf-8?B?OC9DS1pQWmppTENINWd1ekp0Rnh4WFF0UXpXc3NsSml2VzJSRktmMkZ5bXM0?=
 =?utf-8?B?OUFqVUhRR0pJVTBxSkY3U3F2NTJoVkIzVElzMDlveXpBVTg5SitrS0Y1Vy91?=
 =?utf-8?B?NTlNRUtsQ2JPUUVmZnE2OHlSNU1LR0Q2M280UVBOcmhqNTJkMkR2MVl0Sm9X?=
 =?utf-8?B?alQyWHVlRVdlQ05ieVhRR2cxaWZ5SDdsVUlaa3FJa1M0RXJiSUtjbUlOQzM0?=
 =?utf-8?B?L2w2SWZWb1h3dFJxRmNteUhEeXIrMVVxUmpVdFhJRUlsMXByR0IxSWhiRG1K?=
 =?utf-8?B?SmRVZHpRT0xXdzU3YVAzcXNxT2ZlalM5WCt1MzdZb280d09yWUdlVnJUaHht?=
 =?utf-8?B?NHphNVdSNFp6cWVmSkhKbGpSUnhyUDJoWVlpenlHU1VQWHFTVUxkL0RnSnhi?=
 =?utf-8?B?b2czS2VWRkovWWswajB2eVMvL25ER0I2eTZkWFZjaE5ESHBaK3Z1OGU2OWhj?=
 =?utf-8?B?MDlLTXBzcTRFVjFTTnVLc1pzU1A3ZzVIUXBZK05MU0ZuOCtrdGhyZktINngr?=
 =?utf-8?B?UUJFN0VoUENCRDM3SmFLT2J4enBZNXBCdlBPZDAvMHJNUTVSbjJHZkNleG1t?=
 =?utf-8?B?L2daTXFpajFYSjZzalZ0Tkl0YUhhYXhKRjRBM1pGSENlOVZ4S1JUM05HNEc5?=
 =?utf-8?Q?MR6LNZx9H487I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHhtaEN5aDU0bGxVSGZweXlydEtuNVFnNG5kNjhiVHVBeXRSWHBZSlM2V2pY?=
 =?utf-8?B?NmRad0NnbUQraWVpejBFTzREWndFOU0yV3RsRHc1bndaNlhJb1NMUmxkeXoz?=
 =?utf-8?B?TDZkVWJsMnkyaExuNWlsMkwxZ1lya2dFaFBGaUZIMXpJMGJ1WTN0VGUwS3Rx?=
 =?utf-8?B?eXBmQWhmRE5leXpIa3V4U2wzcXU3RG9aS2FFbDF2dXIweHhEU2E1TEVvbFdr?=
 =?utf-8?B?a3ZSbjlXT1N2Qm5nRjFsaXV5WldrQnErSWlCaVF1NmZld25VbWZZZUgxMzNr?=
 =?utf-8?B?NjJPdHA3eEpaei93VnI0QTZnUG0xb2Rxc0swQkhaV0NoalJHL09pVGRXS1NF?=
 =?utf-8?B?S3NFYzJtNkdRQzJyQTU2V3BhSGZuS3Fldy90YURaa0FYVDFlWWdhWmVZMTFX?=
 =?utf-8?B?dWJBNkJwcU4wUFFVL1dMaXhZdnZYNkovc2FVaThGeVFNSFBQTzFKLzhNRERI?=
 =?utf-8?B?WnE2d0o5YWlLLzdGT1hkdEs3SHpLM2hxNFRTR3cwZXRjcVlUbkdCSFRDYjRR?=
 =?utf-8?B?VW9xSndXNzZIdUMzWndKMHZDc24vUGdKU2xXWGRTcStzclZVVHNSWGNrOUVP?=
 =?utf-8?B?ZGliVUl5MkhKVUQwQytBeCtSM3dXZHh2Q2h1RWtkM3k1OFdnYSttbjRtdDBN?=
 =?utf-8?B?dEx4c3d0S0lFeHUwSkwyandadHBFTkFmT0lhWEJvbG5jTjZ4VmllQkxJZ3pF?=
 =?utf-8?B?VUIrbjlKMGhCdnBHSmx0U00zeFZzQ0ZhOGR1WDk0WkEyUThCOTdqRHNaVjF5?=
 =?utf-8?B?N1FwY0VDUzJIZDBWb3lQZVJhOWRNNy9YUnpKL2RFRitnTDNzQkZNdUI3UjZ1?=
 =?utf-8?B?c09UYkdFcVlhZ0pUbEhaWHlBZFNOU3gyMFNTVVR2VUtSd2lQQ01KdGhTWkJn?=
 =?utf-8?B?K0hSMlErL3VDdXZJUkY1blJNeERieHU2MG1Sc0NIYlU0VXVNVWppZEk2dGpr?=
 =?utf-8?B?ZSsxeFNmRkN0T2pSV2U1QVMrNm5oZU10blBYaEpQTktPcXM0RTZBUGx3aGFT?=
 =?utf-8?B?eXh0NlRlWVZnUHJ2Z3BUblZyWDF3TGpSYzFzUkNMRmNZV1YwMTNIRUxDeFJr?=
 =?utf-8?B?L0RXdTFRY3VoaTB1M1RRdUY2cHhDcGZvSFNPbEFaOFBsaUJQbDNkcXUxYnNE?=
 =?utf-8?B?SVNaVllRb2FhUFpYMi8xSFppcGtXWllhQnAyVmhYUkJDQ2s0NVZuNFZqQzdD?=
 =?utf-8?B?Y25PdjJ2TElpM1pabWVZRUUwZUhCeGd5REROZzJCeXZFYWdEcE90UjltQW5p?=
 =?utf-8?B?UHV1anRxdFQ4eGkzaENxdk5xdm56M3ZpNGRvYTlEUTVMS2Y3QjZqRUlSUnZS?=
 =?utf-8?B?eHZ5SzJiWGVhZjNYckdmNm5pVnZBTnVCSjIxYTB4cktwN01FNjltMElzNlhG?=
 =?utf-8?B?aXNUN3MrM1hxa0tDc0g4b0tJa2MwYVZBM2ZkaUdnbGthRVV1QXFic3dnVzJW?=
 =?utf-8?B?WU5JbFhQcGhzTTBPSXY4Z3lER0Y0S3Jtc0s4ZmFJZW9uNkxVdFlkYVVUSDJR?=
 =?utf-8?B?SlBTTjdvdjlFYlRpcjdBbXNlR09sZTRoT255bVNiVndsSnBMVDRYcVhyblJM?=
 =?utf-8?B?bjhUUlBPWmNISHZCK3F1OWowelUyVURRTXhVUnlLZHBRMmo3ckdySitXUWJl?=
 =?utf-8?B?bnVWOWUvaHJzL1JZbnE2QlZsa2NDQW5zYUcvSGtFMDUzTThQZEphZFZCQWFn?=
 =?utf-8?B?YnRNbUlzVUdKbkVZMHVNWU5KYW5PdEYzaGh1R0dUaklhQ2laTno1TG93b0pm?=
 =?utf-8?B?bExnOXhFZmlHNytDNDZwYWUzdW5XbnpSMDNjalFPUmJ6a1ZhYlhnZmpDVkNu?=
 =?utf-8?B?UWg5WVpwSkxicWVjbUprVzgySGhaZVErNk9UWlRrM1RWT1YvckU1YS95S3Mx?=
 =?utf-8?B?OFNSbytVemVtWVNtTHRwc2I5djZZalc5OFBwYzM1Z1h5YW1XUWdGbDVCbTRk?=
 =?utf-8?B?TEo4Ym9mVEthUW8zREc4TThiTDNPZHBzdlpRbUxtV0pDZi9EMEZ0TXFIUzZW?=
 =?utf-8?B?T3Q0Z3g4c0ZSN3lrVURQWUhmQllnRkJReW9HZHZNMjNLSFM3Y2ZBUTVQSEZq?=
 =?utf-8?B?dkxabWM4dHRtdXE0eURZaWxTU1hHQ01menVpaWo2OUp6SDlLRHNSZ2N6NGFt?=
 =?utf-8?B?cnUzTCtCcEsrYnVzNzBvcFdERmpscVJUK1JXbFBzVWwyMUJKQzcvSGdrczRk?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	faBEf5copWcsQBQTl9TC6MugNio1wAskZPLd44to2fEC9Bc0a9GxgiZlFcnAljCn1P6EZvk65iTBD59osUTND71hS45H/AdG9pewgMZqtZJT6dVBd+eLrei4rsM+pWGa8FjEeHI1uKUrUr8lrNZGwtRSSL3lzfn3KVwTgJwJmx5jiLBwxi5i8C8SrAHGUeWDJA7+xSAbIrbXmWdmtSsEkeLgnpxm0R777hOEQCyjBz/3xhAYW3oqHJJ4ueouj6/NAa0VPiKHpSFsVuAWC5ARGy4SdlnFsek+WcZ8fvgrQEy9OHrDJjzaATxGBswKhzzPwJqX/AhmMbfP1T+Ysld2/E7pVLwDuNhzyKduFlUM0vX0FLYigH55ehSQOq0yEVWTBst85XjLHwtkmsrv5/zB/3BzdvWAuvYTJSgys/pPEeUsy+Vfoi97LGsn693LEVx8R/thA/Esyd7WEiCIX/vo7iqiqOUpBUlXhiUWeWTMAV3nNgIHj2qqie9j6k+h4YfG3Zys3gWwChrSNsmYpfjpF8yqHUiqRZ7FhGJNxgLwgK1tGSwUGK9wLwaXFWNLIhGBzIAfJRTjN/f5rQgYAXJGq81PJgNViNXk2xePXtD3RTM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e667de-e7bd-49d8-f000-08ddac41ac9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2025 19:20:22.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDEwk3exBhnUKbyWCdNaagVkYWLQoieR18L28ILSjXB35CETCtpZaOOduJE1Z5oGTp3LHC7e2eue2w1kkmEBwcYQ0QXeXWzP/CfvF6D0bEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-15_08,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506150144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE1MDE0NCBTYWx0ZWRfX5HC2czm+rS/P xQ9lTPNx6IRTzwMYYqIGIT+bkFdZVv/4Y6DXeRnIy496FYKPyWL7EPdUz+CVw+sYDA8p4bU+KuW CZ1jpK+/jW96/hsp3baYP6IMeIaK3PAPEJd6pquhu5pSZf51Gn0a6Ne7VlnfUV+beupZ3wobadZ
 C/M7c/Ix7VhDfaDkxjNiP29leBvg83dxa+cviG/N8od4T7+IcPjnPuamivYFM0p+StI5H/wW7cO OJXGjBdZdmnGfIwQxlrxargctZUDKwHZ2Mc3PJvnba1tw9uEO9Pge0Pg9h6Eg9/cX6+agHSgyel jUjyiFUPej63GYgrXArQVc9FDG21H8s/LxZVvcVx4A6K8gDqXhzwzrBAHi8Fg0QVBbDdlgfneTc
 lZsCvHRBRgs5JhruOFUyaUShqeS6DHuqGd2nqqL+JT2oyUm5ha5vHDtQemiRTUIbc3r361ZP
X-Proofpoint-ORIG-GUID: 9adXmJTeTUifdjuNLfr9sh9Pk_FRIavh
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=684f1cfa cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=8BHMiREs1QhTMHIffpgA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=QEXdDO2ut3YA:10 a=vVHabExCe68A:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-GUID: 9adXmJTeTUifdjuNLfr9sh9Pk_FRIavh

On 6/15/25 12:07 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2c4a1f3fe03e Merge tag 'bpf-fixes' of git://git.kernel.org..
> git tree:       upstream
> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=1422ee0c580000__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pUpt9V_Q$
> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=c07f08ee4bcfb276__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pSK8uLXU$
> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6ph-u8j00$
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=13ede60c580000__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6prbA_nYw$
> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=15aab682580000__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pYMulSYo$
> 
> Downloadable assets:
> disk image (non-bootable): https://urldefense.com/v3/__https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2c4a1f3f.raw.xz__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pe3aDXaI$
> vmlinux: https://urldefense.com/v3/__https://storage.googleapis.com/syzbot-assets/fe90e2ba373e/vmlinux-2c4a1f3f.xz__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pfEFNVhk$
> kernel image: https://urldefense.com/v3/__https://storage.googleapis.com/syzbot-assets/fdd4ddecb119/bzImage-2c4a1f3f.xz__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pdmAa8Bs$
> mounted in repro: https://urldefense.com/v3/__https://storage.googleapis.com/syzbot-assets/77e1eb294850/mount_0.gz__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6p9rdG3dc$
>    fsck result: OK (log: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/fsck.log?x=1727a10c580000__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6p3yBr4Vk$ )
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
> 
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000200000000180
> R13: 00007ffd0a9a15d0 R14: 431bde82d7b634db R15: 00007f06760c301d
>   </TASK>
> (syz-executor335,5312,0):ocfs2_grab_folios_for_write:1073 ERROR: status = -12
> (syz-executor335,5312,0):ocfs2_write_begin_nolock:1791 ERROR: status = -12
> BUG: unable to handle page fault for address: fffffffffffffffc
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD df3d067 P4D df3d067 PUD df3f067 PMD 0
> Oops: Oops: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5312 Comm: syz-executor335 Not tainted 6.16.0-rc1-syzkaller-00010-g2c4a1f3fe03e #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:const_folio_flags include/linux/page-flags.h:347 [inline]
> RIP: 0010:folio_test_locked include/linux/page-flags.h:547 [inline]
> RIP: 0010:folio_unlock+0x3a/0x160 mm/filemap.c:1498
> Code: fb 49 bf 00 00 00 00 00 fc ff df e8 20 df c8 ff 4c 8d 73 08 4d 89 f4 49 c1 ec 03 43 80 3c 3c 00 74 08 4c 89 f7 e8 76 56 2c 00 <4d> 8b 2e 4c 89 ee 48 83 e6 01 31 ff e8 d5 e3 c8 ff 49 83 e5 01 0f
> RSP: 0018:ffffc9000d517128 EFLAGS: 00010246
> RAX: ffffffff81f77fd0 RBX: fffffffffffffff4 RCX: ffff8880007fc880
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
> RBP: 0000000000000001 R08: ffff88803fedc07f R09: 1ffff11007fdb80f
> R10: dffffc0000000000 R11: ffffed1007fdb810 R12: 1fffffffffffffff
> R13: 0000000000000000 R14: fffffffffffffffc R15: dffffc0000000000
> FS:  000055557d696380(0000) GS:ffff88808d252000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 0000000042b50000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   ocfs2_unlock_and_free_folios+0x71/0x1a0 fs/ocfs2/aops.c:765
>   ocfs2_free_write_ctxt fs/ocfs2/aops.c:813 [inline]
>   ocfs2_write_begin_nolock+0x3078/0x4340 fs/ocfs2/aops.c:1830
>   ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1882
>   generic_perform_write+0x2c4/0x910 mm/filemap.c:4112
>   ocfs2_file_write_iter+0x157a/0x1d10 fs/ocfs2/file.c:2469
>   new_sync_write fs/read_write.c:593 [inline]
>   vfs_write+0x548/0xa90 fs/read_write.c:686
>   ksys_write+0x145/0x250 fs/read_write.c:738
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0676081af9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd0a9a1498 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007ffd0a9a14c0 RCX: 00007f0676081af9
> RDX: 00000000fffffec6 RSI: 0000200000000180 RDI: 0000000000000005
> RBP: 0000000000000001 R08: 00007ffd0a9a1237 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000200000000180
> R13: 00007ffd0a9a15d0 R14: 431bde82d7b634db R15: 00007f06760c301d
>   </TASK>
> Modules linked in:
> CR2: fffffffffffffffc
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:const_folio_flags include/linux/page-flags.h:347 [inline]
> RIP: 0010:folio_test_locked include/linux/page-flags.h:547 [inline]
> RIP: 0010:folio_unlock+0x3a/0x160 mm/filemap.c:1498
> Code: fb 49 bf 00 00 00 00 00 fc ff df e8 20 df c8 ff 4c 8d 73 08 4d 89 f4 49 c1 ec 03 43 80 3c 3c 00 74 08 4c 89 f7 e8 76 56 2c 00 <4d> 8b 2e 4c 89 ee 48 83 e6 01 31 ff e8 d5 e3 c8 ff 49 83 e5 01 0f
> RSP: 0018:ffffc9000d517128 EFLAGS: 00010246
> RAX: ffffffff81f77fd0 RBX: fffffffffffffff4 RCX: ffff8880007fc880
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
> RBP: 0000000000000001 R08: ffff88803fedc07f R09: 1ffff11007fdb80f
> R10: dffffc0000000000 R11: ffffed1007fdb810 R12: 1fffffffffffffff
> R13: 0000000000000000 R14: fffffffffffffffc R15: dffffc0000000000
> FS:  000055557d696380(0000) GS:ffff88808d252000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 0000000042b50000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>     0:	fb                   	sti
>     1:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
>     8:	fc ff df
>     b:	e8 20 df c8 ff       	call   0xffc8df30
>    10:	4c 8d 73 08          	lea    0x8(%rbx),%r14
>    14:	4d 89 f4             	mov    %r14,%r12
>    17:	49 c1 ec 03          	shr    $0x3,%r12
>    1b:	43 80 3c 3c 00       	cmpb   $0x0,(%r12,%r15,1)
>    20:	74 08                	je     0x2a
>    22:	4c 89 f7             	mov    %r14,%rdi
>    25:	e8 76 56 2c 00       	call   0x2c56a0
> * 2a:	4d 8b 2e             	mov    (%r14),%r13 <-- trapping instruction
>    2d:	4c 89 ee             	mov    %r13,%rsi
>    30:	48 83 e6 01          	and    $0x1,%rsi
>    34:	31 ff                	xor    %edi,%edi
>    36:	e8 d5 e3 c8 ff       	call   0xffc8e410
>    3b:	49 83 e5 01          	and    $0x1,%r13
>    3f:	0f                   	.byte 0xf
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://urldefense.com/v3/__https://goo.gl/tpsmEJ__;!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6pBY5u_TI$  for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*status__;Iw!!ACWV5N9M2RV99hQ!IgPSRxGUkIu81wjsrs1PEjg5XahZ6OCaEoVrFRGDQrtH2p3MFwalunoQnIXLF9PV2BUrFoNF-jydeFr8sJBdFnQ_9kMI9FNTCl6p8sdCeN0$  for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 


Only half of the following patch was committed:

  https://lore.kernel.org/ocfs2-devel/925336b7-b62c-49e6-aa97-e9a417374a6f@oracle.com/T/#t

Should the ocfs2_grab_folios()half be reposted?

--Mark Tinguely
