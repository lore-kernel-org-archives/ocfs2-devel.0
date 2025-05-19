Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2461F5433
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 May 2025 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747665383; cv=fail; b=OepfJix0SexzPmzBl2Y4DQKYWiweOSk8UF/Pk8jNHKhRGmgheNaPWTpM7SahD35q3UOps6vq/70eBYxBmx9jYEnB01EQwL69Fv4YQADEQjW+1OFMfiFQ/hn0x8s8r5X/9+Bm+rtiiPHFU0VPax1kaB+NcUsS19Lvot72K6i1mwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747665383; c=relaxed/simple;
	bh=nIXXJ4Zdh2zE/CxX2wvtoCdVlkIeA+2BvYwhTSRAPxs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D4lnDlA4C6eJn8vPLkuKmbbpcQt1Jpwb3N9AckKSxhT7for0TUVmRjpXxFBmniW2wstLyXLtkdzJ2xvVb8GOPGlcNOUKHjXlwdzPSN7pHyYE5lbm6ZcWfNVF3ez+Ok3IZMIWjNjQ1jFA8R7MX16uyVGpJlcVOKlSQksguaFOIyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CFi8w8/f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f3IzRZul; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CFi8w8/f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f3IzRZul"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JETS97014741;
	Mon, 19 May 2025 14:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aw6xAkWSo1Pg5BoJNZalzAfsSL++Od2XxOhFTL1l074=; b=
	CFi8w8/ffS8W0pkR7PRUzYMffmC6qaKSvs8MzFkaWka7K4rBKaorQcl08zG34Zz1
	hua68DUO2aucNdmFWguEi3T93Uv3RBwnUknY7gINUv0Q2gPMOnVQVxeX/y7gO2bU
	LTq6c6mbtnvRtltcLZaG+9RTkL7EI6IqRuHV96JZlLAf8iD+9EMXh5FgTuqZMKA4
	nFVPzudxUi3lGgNgt4Vwo6vcGYlQMGdm+dJuk/hVdTHZLSSWhP+lqeWWAKxtrQ9a
	Q9hdDyiQCYEfvGGWN0bU84lHYxgspAFblQcQf0TuEQv647HJiyHvvNWXw8CZwrxT
	W/xxcycX43BxvTtnWI0gPQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pjge364g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:36:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDktR9002447;
	Mon, 19 May 2025 14:36:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw6hra0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:36:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=In3rau6mrBZyfb0XDTXgPSihAffFpYRDf++DYlQdUvqPmzFFW1JqGx/eFlTKpBbhIvj/FOJLg59kuAQ9C+pz85q+XAcYjcDHUfbx/PdiiZyukFMVI+PnmE/07Lnlo7Y+R1jmjAx6TRQb6/masjHKD5O3qXtj4IVF7zYZ6KnhUD1iFd0/BQBz1RH22R6aVy+obUKDFHCfHTp53+WiPdNMl9+IPRUzCn+WV5elIRav3x8QNWgHpASNT/9VRhinixGmOTqBT9kUdwKaX2mSR7UqmkWIPXtZcPtt0NSiXOqiP7J1RUk4X+d/03aEAcTdmc6lufdAYegORioaerX9+5EGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw6xAkWSo1Pg5BoJNZalzAfsSL++Od2XxOhFTL1l074=;
 b=uJT6yRnwg+Gr9ocCxb3/Bk6lkxxkiIA0VS+adhX1jP9F7VC16lImDZltZDefZwRQsJjVWLZ0up84XofVQijVXfRgj/bk+doVye+FgnIZQM+ljuhAnlvrDLg4/bCuTEcqMiXQNIj29qQU98zpHUrX+JqNzgMssCnl1RnUa+3WgUa2eOYTM7ru5lIOv2MNpl+2and6TuIwETfYsUUCN+PN3aj86ZCeyXGamQHGVAhjeBgGBofyDJphFbq0nP77sSEfdVybx5c8xLb3Kfr3zFddmJpSHIaezl9hjggwXRDY4+WcEdye9RkLU6WiPdWrXMwPOWaMpmUkMIrfIgBrgBDiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw6xAkWSo1Pg5BoJNZalzAfsSL++Od2XxOhFTL1l074=;
 b=f3IzRZuld18Lir7CWGb3VPU+ayvR97ROswfbJrTB4lmob/gB/By3vMFnFWvUVz9LolIb8odUGmAIpFVJYgP/yHhnAH55uOj52gMNfhSg1ihWa0Sd26qL+CydPu3ubExWl7NwjX08hgyUSyASUajzIIfA4C8Nk0mRMdMUN+eokMA=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Mon, 19 May
 2025 14:36:01 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 14:36:01 +0000
Message-ID: <925336b7-b62c-49e6-aa97-e9a417374a6f@oracle.com>
Date: Mon, 19 May 2025 09:35:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: v2 [PATCH] ocfs2: fix panic in failed foilio allocation
To: ocfs2-devel@lists.linux.dev
Cc: stable@vger.kernel.org, Changwei Ge <gechangwei@live.cn>,
        Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>,
        Mark Fasheh <mark@fasheh.com>, Matthew Wilcox <willy@infradead.org>
References: <20250411160213.19322-1-mark.tinguely@oracle.com>
 <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0051.prod.exchangelabs.com (2603:10b6:208:23f::20)
 To DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab0155f-6115-42f6-2abf-08dd96e27a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmVnQkpJODhZb1NhOWhrWkZwSmwyTW1ReWdVOGwySTkxMGRFMHltdVJIS1Bw?=
 =?utf-8?B?WVIwTGxiWDlROWF0L2ZYamhLUk5rbXNLMU52bGNkUlE4ZEtac0UwQmFpUWtz?=
 =?utf-8?B?N3pma3N4UEFZTWZmd3JRcWZFRE03a0hwRW8xN0R3Sk9XSHJOQ2pUU0ZiQkNY?=
 =?utf-8?B?VkNhN3ZkcENjL2szNXlocC9xRVpGY0YzS0Y4M1k0OHY4UTJKK1JnN2FQemht?=
 =?utf-8?B?czBDSnhvUFQySFEvY1R1V1JYRlVqd1JFSU45ZXdxOTY3cUMzcHVOSWtYVlVT?=
 =?utf-8?B?SWpId0hldXBPQmV3VXhEUnlLaDNLT0FQckN1Y0YvS2ZsTGxKbVlaSDRUYXRk?=
 =?utf-8?B?SUZPZVV6MUdVTWprMUQvVXlKTysrcHN5eUszZjdqd04xSFVDdVF5a3VJdUpH?=
 =?utf-8?B?UTAzRmYxMFNycy9iNmNrUVRaWk9COTZJd0hFeWZiU282eHhYZCtkOEd3QlhB?=
 =?utf-8?B?OGhTdWpIUUkyV0RFZHFUTHpVa04yWWtNMU5qKzd6R1VmUXo1Z1laVTNtWDF5?=
 =?utf-8?B?YVRCb05HeUhKd09XNnU3aDMwd1ZOQ3p6SlU0aUc1S0RJK3VSVU5oNUpzcEJo?=
 =?utf-8?B?ZlFOQllBT3ZuZm5FQXk2M2R0Z0NsZUs4NUpkSFAyS2tPVm1MWlNQdUgxYTV0?=
 =?utf-8?B?bzVqY2RyR3VYSVZLekFnTHJ4Y05mYzJIaENabHV2L1dONHVrZjIwZ3hZNXVo?=
 =?utf-8?B?Q05vZjMvWm02M1lvOHlkTTQxL3gzOFVUa3RGbE9YdG1RYXNRajZJN2hYTTBB?=
 =?utf-8?B?YUlmcG0vcXpOS3AwY1NJTk5RaTd5TFVzQ0RUOUFiMDdGS1N4b0hMVkNDZm9y?=
 =?utf-8?B?cUVGeW5GQXNseE5SUXg0ZS9xQVh3ZUdhTGd6OWFTd0RLaVczUWVFcnhvQXNt?=
 =?utf-8?B?QmFYTVk2YlR3Q0VtV1RlLzFESmRpM2hMb1lVSUN0WHV3a2tucEsrdHdsMVhD?=
 =?utf-8?B?MkJmUkVaVmpZSFZqQ0VKeXh1NStERXdYa1FrSGJPUkxmRnR0ZmZtZ01XVDBU?=
 =?utf-8?B?elo5QjArSm51TUl2M3dNR1pQTFdHWldyVDNjTkhpNzh0SFFpN1JOSWJxT245?=
 =?utf-8?B?UVo0RS9lUWJDWGFxZTBXUG0xclBoZnYwV3lvWlBVVVU3UFJWQVlYb2w2UHUr?=
 =?utf-8?B?aVN5SDJDREVpd0RHOVlUcjFPcWhJUTlHTEtKb0hUTFNPREhPajEyRHppbnNG?=
 =?utf-8?B?MmRkSC9KMkczU2VrNkZzYWlCVTZ6K0tqM0ZjZm9lamx5dWdyQW5SdTA0d1pC?=
 =?utf-8?B?UzVRQkJKcS9Ed3hvSDhwdDFHQTZjblliakQ3NUk3YXl3RkxJUlJyL1ZSalZ1?=
 =?utf-8?B?OFRSc0g2Slh0YzlPLzdxb0RqWHBMSDBJYUozaUU0eVJvQVl2WTN5YnZ0WDJr?=
 =?utf-8?B?QVFyNzEwNzNMVnUrdmcrR2ozN0ltVDg5K3lTMWxSNklkb0x5MWZyVUEzeDJS?=
 =?utf-8?B?ZmFHUHlHYTBTOGNxWEZNMTVpaWFWK2c1TmRnS1VpNUtBZW9wbG5RSllzK1dV?=
 =?utf-8?B?dDMwMm85azhDbks0dDJYSkt2TCtWUGRtZXUyazc4ZmsrRlFSTWMrb1Urbnor?=
 =?utf-8?B?SzRKY1NUaGxBUCtWSkxJTnBnTHJYOHRIZjZXT1lLYm1xdFlBMStCVE1zclR5?=
 =?utf-8?B?eVlxOXppRnR5NTdaOFBFUHhXUTdLTVZpQmVyQ3FMWEZyYU5YRnVmeG9Ndmdx?=
 =?utf-8?B?ZFhRV2dKNEJrTFlnR3MvRXBpaTgrM2lQMFdac1FRcWlsdVRhTlVwTUx3ZXB3?=
 =?utf-8?B?SGlDbHpwOC9iako1aFpFdnRVNDFhR1FNbm9QQWM0NlJZeUlhZTFvb2JjcmRx?=
 =?utf-8?B?cVFBWVBFcEtNUUI5d21jZm1HdUorQWVpZkdrVDJzUEpucHVVamVVa0pNZUJC?=
 =?utf-8?B?UVJGYkZOMlRJV3daUmpTT1RwMDc0b3ZMZGdlZEc5N0t1YkUrRFBBSWhCMXRh?=
 =?utf-8?Q?/AZK9FrPT88=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXdJZDFoVUlrcjNrbFhBVkIzU3ZVcVZRRUJtZm0zckVmVS85c0JsaDVOaGM3?=
 =?utf-8?B?UVlxeElhZzRpVWJhcCtZWUhnR2c0a0VLd2JUdy9zbEZhTkF2V04ybzZpZ2ZB?=
 =?utf-8?B?SEFnVWpDZG84SGJOV0dnclkrb3kwWXUvaXJqVEhJSElmOTFXS3VaaUM3a3Vh?=
 =?utf-8?B?TE5NdGkzc1dWSzl3NitzUkVnQlRlejlBOXZ1cy85WSt2YUQ4ekRMY3BiYnBr?=
 =?utf-8?B?Y2VqZEdhNE91K2ZRTldpdFVKVHp3ODM3OEVDL1FVcVVmUTc1VVVjcFJQVVpw?=
 =?utf-8?B?aTNWNjFIUG43azJGUDFEa0tyU2JrUno4a1RBK05nK2ttbERNTnU3QURsV3hw?=
 =?utf-8?B?RVBiWmxWQTZIUVY1MzF3OVVIR3ZjV3hQQzllNDh4amFMOHMxdytWd1pTZmhx?=
 =?utf-8?B?MFFLZU9IMFZ6c1FVQkhmbFJFMWRKSnpQZFRoVWZGaEhrNmY1VW8rVkkrWEtB?=
 =?utf-8?B?d1RMZ0llanJEV3RYSzFwUUpGZitvemhXOVYwQTN4UkhWUGpya1dGdHlXWTcx?=
 =?utf-8?B?SmdjcmNId1QyL3lzZGhhNXlsNTdQWXFCUGtVUXFNQW8zR1FaMzdnQ0JoN2Zt?=
 =?utf-8?B?T2VpZ0dZWlRTQWd0T2hrQ0cxSXpnYTBKdVVDTW05bVRxcDZjcEovNlRSMnMr?=
 =?utf-8?B?THRLa01ZQkx4SFhuTFlpOVoraG1WbEpxVjhQZ05nN1dRZEcwMHdUNzlyTDFv?=
 =?utf-8?B?bHBDTE4xdnJWUU5FSVVQakZmQkg4b0MxS2U0QWNtNXd4VEQ5ZWNjNEtCbnpt?=
 =?utf-8?B?bXNzalU3NzdwWGF4UWYzcEZrN0EvWnN1Q0l1bnFySGdEZ2xNNEczZS9nTjQ3?=
 =?utf-8?B?VnpZV1liRmNyemJmTDVWWVZMaFAvQUc0OStUTTVjREM4SGZwNUZic2pDcFBL?=
 =?utf-8?B?N2NobkdOL01jMmN2VVFHNVRJeEM3enRYdjZwb1BRYWd6NzMvZDJvZ3poZjI1?=
 =?utf-8?B?Y05wbVVlSzk5aFVsL2F5V3pqbGlkcTc5UGNPYm5jNmh5UnlIeFJ6ZitzWU1G?=
 =?utf-8?B?cWNFY1pSbmxTa01KODRnQ3JrS2dlaUI0bXA0dUNoTk9GZlJsMVFRTTc4QkU3?=
 =?utf-8?B?MWxJTEkrZ2M0eXROV0tGRzFtdDhOSXZPRjNKMTh1Ri9hTk1OdnNkakp2dEUr?=
 =?utf-8?B?eGcyODlPdEc2ZUU5M2J0TnZCTUwyUk1rWWFjT2xhOEhicEdVYkVxT0hoUnk4?=
 =?utf-8?B?L0twdUlGYjU4SFB4RER4UEhHd3VudGpXSFpYV2lCaXVibThIandWU3hqWkJC?=
 =?utf-8?B?Vkx6bFhLUGduRzY1OGJQaXdvKytFS2NpcVBuTnBjKzgyNHpJVXpteSszYUpW?=
 =?utf-8?B?M3M0TDhnb2JtOStBM3NBcXh2dHNjQUducW1POUVxMlNKRHZ5VGxqR3VjWXk0?=
 =?utf-8?B?dCt6YXllaForM292dFVsOFRvNmswRlZZSngrRS9tSllUT2dSYVhIN01lcVA3?=
 =?utf-8?B?dXF6eHNJU2VsUDlCVkJoTjFZM0llMlVHWThKUUJTSXhFMVdqN1lDMmkyWDZR?=
 =?utf-8?B?c0pldXNaTFdYSDcxRGRhd2VVV2l6ZndYVmJEMmUvR3AwQ3owUFJuMGdnV1d2?=
 =?utf-8?B?bll0LzhrR1oxOTFrVDEveEdLSE5TY2k2VFVzV29lSzRYNUNQelB5ZzhnZEZF?=
 =?utf-8?B?UGtRaFZnT21SZjl2Qi9MdmNkU2NKTmk0WlNRUWF5Z2t5bHJCL1BOT3ZGZG5l?=
 =?utf-8?B?ZXBJVWFFVU9qS3ZLa0JOa0dRNkR3Q2tlK0RvLysxdnZZMXVlMEtHam80YWhH?=
 =?utf-8?B?OStWcTAyM1l0Q0R2Z1VVL0NrQWU4MEN0bTd6bFhvMldMSWlpa1dNcEpEMGRW?=
 =?utf-8?B?dXdVMWdXQ3Nxdk0wd2JTN3g1eFZDM2ZXNFNFU3FWVWlLMEZpZ1ppOGNJTkky?=
 =?utf-8?B?M0VpWGlRbldwRjN4eUlkcG1EekFvbjlmVEh3R1ZyT1M5ckUvWlV3WEpuZkg5?=
 =?utf-8?B?RFBnUTJxR0dpeG44VHg5citkRkFGVnRsb3hid0RIZ2VQM3VRUmJ6NkxBSjFU?=
 =?utf-8?B?T2pYUEZRbnJ5L3N5UWl1ZFhKbi9CdmNEZnZMS2N5QVVKMi9aMERWMHc3SGg5?=
 =?utf-8?B?WXJIQjBMRG93ZklmUHc5UGlIcVF2R0VtdW1KcC9iTFNKNkdsc3FzZDdqQmd3?=
 =?utf-8?B?Q1AycEJrYUlXblZOVVRzcmRQRS9kMk1HR1pkbUhIaDZ2SW90VVNMR1ZRMEp3?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+Z3xV37n1yDrJC+IaSgGYNcB0SQdDzP8UfGeTMlOjcMIqegXl/7hR8Noy1ZxWZBnS9cxtwRA6Yv/i0gJDvckftFIgLiY2Kq8+tLchrSqmlkvE4XuWthMrvxfN8m/AwSozMWirW2QMq6GV8Zj4SxDgw3sGvv28HEJ0LrdbEm9DIGk7xjUkfrbSXPvsa2csGCD7m23UKz/udktu2Kx7u4ZDJpGBh9TB8GKWTcufFjVtzo2YM+VWnmQQTXdKRwOnMfitXIMA32EwUI5KcFIR5T4DqG4LRFeUiLeAskFIP8cNdh3JfqdAAafQOFkXZfLE43NBJ0bzWRS5CyyS3eD0HtFYgsVd4bwaeOMxTFnqji7sDPf5OkzRtlLloA07lMmwy/nvTkAvCul3eOktLvNxj/D/pkiNxfO0jcAzOQxSw2bZSOiUVTfMJyBauy+wtBcaEq7fjSi10Qro9+Ms7ZxajHzzuJOVHgov5AwGKYR6MZbZLY2xq2e5AJa4vLIvqeyT7dMgF6Gr/Qzqz40J0w9AZM7owqi8E5mHtZIRaSPALyt26+VPWbYvA5MeiB1Dojoh6C2BxNQ9OYu/rfC1VgeeUl+1xzdUJE17JnwI5cmtP3mJkI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab0155f-6115-42f6-2abf-08dd96e27a09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 14:36:01.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTyZAEgKI2BFkHKP6rLSnddBejwYVPCCll6K+RiJKdyRJjecs0/sruNS+yyv6iVe9n0or3qp3Uvwek24ca2QEEZJVJ2s0XeLyq1LVYVNKn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505190135
X-Authority-Analysis: v=2.4 cv=RamQC0tv c=1 sm=1 tr=0 ts=682b41d6 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=IXr_WNlcAAAA:8 a=x_RLF880AAAA:8 a=JfrnYn6hAAAA:8 a=cH9vYgcpEZFH9ryWaVEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=K24ECnMRWNUKRqF_MnsZ:22 a=jCPSC2jcP07J4OBJNHyf:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEzNSBTYWx0ZWRfXyL4NUlEa8dC2 NECsRId5D22E2SJrtXIF/BKd8rHjL+JGFWT3vUotlJOwTmcgt/FONz3QPJJiqJEc/2on2Yq6MaG UdAKomabPSJLObCvGsoVhjgcxInFh84htVqJcmqIURzHO3BgLSAGDrpyVo0fqk1UqEM8qjWckUU
 ZwwzQgQMIZHSJdXFqIZj/Ob2PVvYXSeJlEwyc2+DNh+m/XleOS8hR5TF+78TE+BaIhcJV19I1N9 /VEJ3nMurywu+aFUeQj1ID+8Tm9BFkFZ9XPAkFDrJw10YDqicrLuJVdkVibZOzmJUTi6TGRkoIT 3BQFUJ+b6xIWfU4GYKM/vXV6GatkY/UszVnPqtBCoIQeFG1FnCCe6A5ErBoR01vtkDn8U/SBmuZ
 AWYmOCYYXqdlfN1kJ3M1Soyc4DT8KX63Wq/S9Xtwu4Cf5by4KBwpaRpC2+Vw51yIPW63fh94
X-Proofpoint-ORIG-GUID: N9aUgBP-hY26HXn6eE28LG95aHGmFPJB
X-Proofpoint-GUID: N9aUgBP-hY26HXn6eE28LG95aHGmFPJB

On 4/11/25 11:31 AM, Mark Tinguely wrote:
> In the page to order 0 folio conversion series, the commit
> 7e119cff9d0a, "ocfs2: convert w_pages to w_folios" and
> commit 9a5e08652dc4b, "ocfs2: use an array of folios
> instead of an array of pages", saves -ENOMEM in the
> folio array upon allocation failure and calls the folio
> array free code. The folio array free code expects either
> valid folio pointers or NULL. Finding the -ENOMEM will
> result in a panic. Fix by NULLing the error folio entry.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Cc: stable@vger.kernel.org
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> ---
> v2: sorry, ocfs2_grab_folios() needs the same change.
>      the other callers do not need the change.
> ---
>   fs/ocfs2/alloc.c | 1 +
>   fs/ocfs2/aops.c  | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index b8ac85b548c7..821cb7874685 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inode *inode, 
> loff_t start, loff_t end,
>           if (IS_ERR(folios[numfolios])) {
>               ret = PTR_ERR(folios[numfolios]);
>               mlog_errno(ret);
> +            folios[numfolios] = NULL;
>               goto out;
>           }
>   diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 40b6bce12951..89aadc6cdd87 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct 
> address_space *mapping,
>               if (IS_ERR(wc->w_folios[i])) {
>                   ret = PTR_ERR(wc->w_folios[i]);
>                   mlog_errno(ret);
> +                wc->w_folios[i] = NULL;
>                   goto out;
>               }
>           }


It appears the Linux commit:

commit 31d4cd4eb2f8d9b87ebfa6a5e443a59e3b3d7b8c
Author: Mark Tinguely <mark.tinguely@oracle.com>
Date:   Fri Apr 11 11:31:24 2025 -0500

     ocfs2: fix panic in failed foilio allocation

made only the alloc.c change.
