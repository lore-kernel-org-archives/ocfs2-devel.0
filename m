Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525B8322A38
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756398532; cv=fail; b=BzOBPo57vWBr9dmT8IasEIiWqu9lwNnTHRGP0grpIJXMQX/jiSUO232vVBgUWqElDuitTCXQUQ+ggXv7pZSpCQe1IzBDeDNW4AcypuVcFy9sXb+6FlLZRgFKS+YFuA1i6k9gVfGIhG+6oXxB9bRFjpAzD9UcrpoR5/WbGQqvRDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756398532; c=relaxed/simple;
	bh=PYl0a55mkSJMF8HLvio7nGELC31QOXXP3foDoLhn50E=;
	h=Message-ID:Date:Subject:References:To:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d4IVuY7MtcOm9wNuNqlHwzZNCc3WfIEMgTvb2J/beLT863eAFTQfcZIn5xgrc35swtRUB3W5e5iuk50bgL9IPtru8kFtNXrlUqks7yEGxjRjXgtFWIH/PMylf8pgaMG2mjQJB2kRWYM/t03ESBASn3jDA+sZPLt9UN5a6c9N1ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=em4uzZdS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZM5XS6xp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="em4uzZdS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZM5XS6xp"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENkf7025499
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 16:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6BG+vOHzX2c++U74vPHcCs9Nx/lFhDBFdLE3XiqO77o=; b=
	em4uzZdSAJ+tChdDXEpJ4MvhIe+0gyryloeYaclqQFNx5LFFo0g2HX4u8RT/TVcs
	b7NtDu2m2b4DdEujEszqJ9n+eo5qRdZteh96p2Bnam3q1XLcLPAMvhLS/6oFOGKz
	BSZnv8AhTdVgObijODEXT8ubDivyyQKRJeYly7+3Hb+in5XVZS/l1bOR7CD8qa0N
	SbP6CHavV38l/arBoZV42fcizkFDYByGs/LpQ3Pm5CFDSEjvBXI/7bPryrJBj2aO
	60NeMxAJifoDMNRNTbC2RwQFfqK7ME/r/vJqdI9SO+VL6Q8y+iD2lQp0vdeDsXYL
	B0BKq2EQjXr6kc4SVQ6SQg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jarx14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 16:28:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SG9ukp019585
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 16:28:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c6qk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 16:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/YYxwJ+53+CZa7V+0Knz0rlryDkPZujwOMe7kxfqJNaCUlQkGryBxD4ioxiVlcObebV35Gm7Ng/FWLQm7ZkX/TNm5ka++GclaD9VA74WMgy35OrHJVt5ZrMFq1RjUOOk9xt6PyGErZNq5FHTqkijYT8f8YUrl1XH3hgn8hqPlG+LVyEFSYk8gblJajm/TM6d+Jj3i1KjB/PqqT1LfSsWu9iwqfNMN0y8g+ieVJ1eCID3hUkOINSLwBvK6dwsZNDCsMUhSgqaIrESbSU4j9kfaRCQ3b5zktkZieXJRboc4U83J4L+gjJqaL2NgZhrQxfkqJ4hMnVZ+aolZHXvDiqlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BG+vOHzX2c++U74vPHcCs9Nx/lFhDBFdLE3XiqO77o=;
 b=AS4dAyVf70WNtnrcMKKf8+29SPNl1aGdQxtVMjeoG61UzMqvBLUqM78Oiz8bdE2tkB+PuR0+v3jaaVyug85rtiEjwEpqIPpEjNmkdOcCm7IbB4c0APLbG+XDsmTv4rs12QzA/9R/E53PoxrUMTG36orDbGnxuCV/1efldM2CvE4toxwwO47eXPkzx8CLkC8sxEqEHY5QOQmw1WRWtX/d0TxJMLuiTy8swseG5st5NyCK8W5DBSWrGYOzQawgxzulGxlA//FL1e7GW9Q0aLA5RI950qhNH9RebNCWjKaAyloI61lUkOnDXjQOFqtU5O80RCd2EaUoABWiFArqbqBRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BG+vOHzX2c++U74vPHcCs9Nx/lFhDBFdLE3XiqO77o=;
 b=ZM5XS6xpEJFOJOZO11hodzNpF7OShOF2H9cSZKvG4wyG1I01o5WdCZYNisDG1CGjHkS5eLxrnB77qYnMi9CROKQ9c6sKvqD50IXBDw06YcnkZxp8vU+GtQOq4Zr4CCmIW9R8U379FRq2JGbNdc6g5k06xq5lBjhSzPuind2ULC8=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.25; Thu, 28 Aug 2025 16:28:42 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9073.017; Thu, 28 Aug 2025
 16:28:42 +0000
Message-ID: <0d3e5061-47dc-449c-8aae-757c693218af@oracle.com>
Date: Thu, 28 Aug 2025 11:28:39 -0500
User-Agent: Mozilla Thunderbird
Subject: [v3 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
Content-Language: en-US
References: <DM4PR10MB7476AAACC3BCFAA61077E606893BA@DM4PR10MB7476.namprd10.prod.outlook.com>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <DM4PR10MB7476AAACC3BCFAA61077E606893BA@DM4PR10MB7476.namprd10.prod.outlook.com>
X-Forwarded-Message-Id: <DM4PR10MB7476AAACC3BCFAA61077E606893BA@DM4PR10MB7476.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:510:33d::29) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|PH0PR10MB4710:EE_
X-MS-Office365-Filtering-Correlation-Id: 68428ffc-51a8-400c-e3d4-08dde64ff381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWhLMGZwRVFjR2VBSkRVWW5Hd1BmRGI4RU9WTmJFODBzUTE1bGhvdGlSK0Zj?=
 =?utf-8?B?Z1czNWp1TkxxZUN2L3BjMWNWUm4yL1hLUGJkbE9QdGtrUm4zem5zWE4zVXpL?=
 =?utf-8?B?WGNIcU90WFZpUmNwUHZDcWVBSTR4RGRCa240OUJSOXNuKzc5SGNnVGJiYWJm?=
 =?utf-8?B?aWpHaW15c2pOZnY3eVFXU3hwVUVGclJjcGdsNzQ4YVp0RHJJcy8vWkFjVkNt?=
 =?utf-8?B?V3dGY3gra0hBZGhXUnRwQU0rUEJRWXFrZ0hXanQ5bEJBbjZLS0s5M0poSVJo?=
 =?utf-8?B?WTZ1bm1RSERoRlFEVnZ4endPc05SemtyM0d0TUtLU1UvRVVjMGdxQlBuZEha?=
 =?utf-8?B?S2xuNWhHb29nK05HbG5XellHUFhqSGt4NU1kYUJkdXdONUxvT244U0R5Sko3?=
 =?utf-8?B?dW02SzExUGpsVUFVM1pvZlZ1R2Q3cTdqclhPRUhwemNyUE1zNTZCTFRHSU5v?=
 =?utf-8?B?RmltWGVHK3dyU04xN3N5bkpaN01Da0FPcXpLZEI1bHo1V1ladkt1SERqOVlx?=
 =?utf-8?B?MnNod29XKzFWRWQvL3h4QzJSb3BmYjlSRC9GMjFZSDBhYVRod1pySkhKVmFL?=
 =?utf-8?B?Y1U0NVZ5L2xleDhQT1hKdHVSczdtNDhBOTBhczUyUnZ4Rm5EWi9OODVwbVhr?=
 =?utf-8?B?OVBIN0lFWTJ3Tm9zVUZJNHJ5bWdXdG9iUTRrYXlGRkg3S0xqWmQxODRxNEZa?=
 =?utf-8?B?aWJMWVBFWlRUeCtZaEhYelE3Q3FkZmFIOEpBdTBCN0pDamRFNDFBMHA4K2sz?=
 =?utf-8?B?VkdHTTBPM1JSMUtKa3kvMWljKy81cWNEcTJIRWJFRGRSV0pES2VVS2lDdFpT?=
 =?utf-8?B?UkFaK2dWYXNLKzVuNm1lenY3Z0N1RzlUdzZVQmt0MHpRcjVKb2JqVkNjM1FP?=
 =?utf-8?B?VHFDMUp0QzdlT05BZHZsQkIyWWNTUnF6anhTOUhYajhFRVM5d0ZNQU5LVTZZ?=
 =?utf-8?B?YlR4aTNQMDVldlMra0NvdnZsSXMyOFN4d05Ic1E2WkxKRGthWktPakE0ZGxj?=
 =?utf-8?B?aTh3YjFYc2VPaDRUeFhZdjRqTzZpQ2lBVmpZMlVrZ25sMFpPSnBONE9HMlky?=
 =?utf-8?B?cDlxOWdrT0xseURMM0ZSVzRyM1hsRWJSQ0tXTFkxQjNxbHlzZ2kvY3hrUWxz?=
 =?utf-8?B?WFlvWlVOSkZVUmJwSzRTTDhZRnhUVlJyeTRsZUVwTUJjK1Z5OE9MK1ZRa3Va?=
 =?utf-8?B?SEZKc1FwaWpnemgyMVFVVGMzSVRQNzlFRCtJakdkK0s4OTU4MlI1MEU2QXBn?=
 =?utf-8?B?dXkvMFlRSU1waFZCNXdJY0VYTk9xcFFGRC94YnN0SmYvaE9pa09lcWJFczlB?=
 =?utf-8?B?aTBzcW1pKzQ5UXFDN0tDbTlDbUxTT2p6MnZuZjN0MmdZSUF0YURDL3BoSGxC?=
 =?utf-8?B?bHNZbGRsbG1XVzRHZE4xbXdwNzd3dGt6YmhGRGhCT3RxZ0YzenF5MmhmKys0?=
 =?utf-8?B?UEorRE1EMTRzbGNrNndDb3I0MlppZkx2ODFMMUh5OTdqczE3Zk9mTXVKcWRj?=
 =?utf-8?B?NW9oNCtHc0NZNkphZjNEMVJ2bTE2RnhvcWdmQUtBR05UK0o2M0tuek1rZExH?=
 =?utf-8?B?ZEVCUDhObzU5NmdIT3B5VXFlRGlERHAxenZkWE9YZ0JuUm1obzF3dXUxU3Nx?=
 =?utf-8?B?ZTIzUUVRWEQ1SEY0eExHaG5pVVVVc3lOSzRzOHl2dXNxZWRHdDRucERqc0V3?=
 =?utf-8?B?eEo4TWhrMXllQmE5OVVUV2lXeENEcUdnUVdPSktjWHlnVnNxSXpKc3ZUcTl2?=
 =?utf-8?B?bmZ1RWI5U0U1QzhBWVY3c3RXZTJqNS9sTGhkUGM5TEg3SHkxdHhadEhwY25x?=
 =?utf-8?Q?nnys/2lYlGxUoBFiBJlI5KJVF92ffSMQEnAQY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjYrMFpGMFFYVUNNaTZvNDFpd1gwd21ZaWwyREF4UXY5dmE1dUF5R0tmTGln?=
 =?utf-8?B?ZUtmZ2tHL1YyQjNZM3JRZnUwRmRKZ1RXanFveml4NHlCS0FVMWY5OXJxVCtI?=
 =?utf-8?B?VFl5bGgyMXYyczdUMFEwMVJSclR3RTRYc1hyMWd1Q20zRXN1NEp3aGpCaHdm?=
 =?utf-8?B?bk16YTRYVG1md29FbFVkNE83RDN5TDg2OXQ3MDlOWVBTZTdSMEF2SC83NWJq?=
 =?utf-8?B?TVNqT3pBc0tGUXhkdUErSVNiK3U5dU1oRTdkN3pNYll6akVxTTI0UFlaNEpn?=
 =?utf-8?B?S3ZocjAwQTh0VVZyTCtDMTlpUkk4K1dKNko4L01waFpWY2NwTnF4THdHcGFF?=
 =?utf-8?B?OXk1T3B0WmZ2eExQOGZ1Y2VZM2ZjY3UxcExjcUN2Y2RRM0FJcythUlFIVGNj?=
 =?utf-8?B?eUp4Z3B6Vy9vRm1DMnUwWWRjd1ExRmxjS1VKcTVOVHlQWUdqbi80SDdVNDY4?=
 =?utf-8?B?YS9yTTBDbm9xSnNtUnNBaHBMcXFRZ2ZiQXJjc1JvaUdhd0I0Wnl5NGJHOXVZ?=
 =?utf-8?B?bnFsMnJWVjFOMlorSm9aSWpFZmRQcm5QakJoZTZITU9TSlVkZ1pyUGwzYUg5?=
 =?utf-8?B?cW1SMDhvS3N3S0JEdHJmbzlWZzMzSUFvbkZmek4zemlqMTVhcThSZEpvTTVj?=
 =?utf-8?B?ODVzUmJjblNHWmY3ZTMyQnpzdFRQY3paV3FSbHFOUDFKeVdmUmFXTW9LWHJh?=
 =?utf-8?B?YUJpTHhuN2xTdFdPODVRR3Q3VXplaTVzbWtOU0lJNUcwY3k2YzZvUlNsNVN6?=
 =?utf-8?B?NWFCYXR2K0pEWGhzU2QxejE1aE9YTktIVFNuenhjTG5odHlTeTdSTzgyalZw?=
 =?utf-8?B?QSt1SVo4eHBkZFhqUTB3VTJUY1RrNi8wNExqSnFtdjRuSHFhWnYvUld4U3RM?=
 =?utf-8?B?VHFxNVNXbUtOaVp4bVRhcFdNV0dEcUdmNGdWRVNSTGxDRGhQNDcyTEVsa2ZC?=
 =?utf-8?B?V0J6Zk5rWFFUS0xoeTU1VG13czRkdWJ2MERUY2ZXUlhyUTFDSDRTVkhsT2tH?=
 =?utf-8?B?LzNtcWU0aDdFOTRoRDZBcHNOMHNmVjdlVnV1QUhXdCtNZTJBbTBYZUdkNnJm?=
 =?utf-8?B?YVpHOVhScjU4U0Y2OGNuVkMxdEhRQ2VoeEJmK0pudTRUVFhGNEsrYWFndERk?=
 =?utf-8?B?YkozVTNVbnBqTGNma0RrWFFrTjFIQS9idVN5U0swZncrM1cySXp6cUlQWDdJ?=
 =?utf-8?B?RGxkR2VuYnNMVVdkdXI1MEVJdWxhZVoyRXRpNTJacTI2bGppb0wxdWFKTnI3?=
 =?utf-8?B?MlRCb1RpT3VuWEg4cXBvNG5VQkN6MnRRaWhQQlRqbXJiUmRpTi8vL0N4U0Q3?=
 =?utf-8?B?TlhydGkxZEZOZjA3bjA5R2lIVDI4TnppamdHcnhacjR0ZWIyVWhKaHBHcTZm?=
 =?utf-8?B?VmNMczNxU1VXRWpnc3pKaXlIb1lrWmFMQU5NMDh1WURBcy9SN0pab2xqTjFE?=
 =?utf-8?B?YkMvZXNJeDRhYWIyS2o2R21HdVNKOFhmbFNjNUc4SUhGejlxa0ZvbGpNWG1K?=
 =?utf-8?B?TnRwUGIvWGtsMzI2VStFQmd4am1XV2JHZmVsTFpFOWRzS1M4eXBlSFBuWG8y?=
 =?utf-8?B?bEU1S3N5VEd6NVJucUlTSGJVWDVXb01rK3FGdlp2ZHovd1JPVm40c3d0M2J1?=
 =?utf-8?B?Tm8xa3pSLzFwU1ZIbVdSTFRSa2JzaStSc3NmL0VyRUJITG1pN3QwL0FEZ2Rj?=
 =?utf-8?B?Vm1TbFZHK0V3SktPaU1uK29CYnZPdlVVV0MzdEhhZ2wwZGVScmRnOFhvVFBp?=
 =?utf-8?B?dDRiTnJwM0gzd0s0L3FGZHNNeUI2T2Naa1dVT1lCWUNoQXFMdGtnUGpRQXQz?=
 =?utf-8?B?RGpOWXc3blAwUDFMaVBzUzBoNTI4WG5MQkptbUZqUU9ma0s2c1ZrQ0g0aEtI?=
 =?utf-8?B?OUg3eWs4dG10ZjRMbkMvRW1BWlh2WXVHQ1dBdEpkSHgyNUdocWxlZDBLMzNs?=
 =?utf-8?B?b3E3aTE1c0NJQ2M2SU5TSGJKdFBsY1FFNG5lN05TVldaMTZrRCt3RTVVQ2x3?=
 =?utf-8?B?WDJNY0tTS3dXMGwrRG94OVpUdkdIdXNSYWVCYUJRU2l3NnFPZEdoQStXWGNX?=
 =?utf-8?B?S3BRQmE0bkVaZUpzWVBqZnBuVDNDSXdsNGt6b2VZSllYWm9qRDVHUTc0WlRJ?=
 =?utf-8?B?cDdEL2hMNWZMWjRyUjc4R1VXODI5YW5hVFo3dGQ5NGhZV2dldU0yOE5HZERH?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nFV3AzpQKNGiNDGAeg4yVmMJjMAuU+S95DNwUisNbCtTiUzhdNc8yqos0v8tp0FhMjoH37yarRqxZRt4K4Xu0mZPbfV3m5g/NZUesDFGfimCIBTZBgwVHaPCBbkDE9gzlnQyJut/2vjK3DL1G+wfyWofstg9hoB6yfPNhWHpouw+JJTkos+aMPPlhY1tZGx7b6vqgVy0oy4l4Z0lcd9BoiYl6O1qSp2NdHST31287Ghh4wzWM+obpitYm5RpFdLqTO+EZ9poCKAERNEMhFLbNKdRVCBUMOA7ecfLVKrtxVsyj/q4FHlYtoSEf/yhYBj4D8ssa3g7OuGaX0HcTDtlHyNeMVSRO2mpQgE5DyRzj3vUb+vsg+mSnTJGly8BGsU0ECYmn4biO/x3QsUtULFpcLf9+zJjyXtUbEvQwzOaq1Qg4WuwiuI5AQAgV/AgAuON5EduHCupgMrmOBTg6MU9w7J31bZzdNBwuErUHch+XZ3qEJsKBgWfhUtJDd33buCNrqdooF2Hu2pBIUm69YSRdeMhnfDHnBmF5PssSiZiBNMMbZ2H/LDbw+lot8nxa1Hv0Urx9LdFqWcyLvp5mTncHoymP0uRUa8kmZbySUslhkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68428ffc-51a8-400c-e3d4-08dde64ff381
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:28:42.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9teiZEMZ2IsmzEkYIa+F5Z2nUdj9EywuqJWgam5bxEQUDhYdSmjp4Wxlzt9Jqoz5ZyzkIePGVEfP+WR33myyQs+XnT2CVgZs0Uqb1pBDfeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX3UUfFe+IkHi2
 TX5TDShYSRPfpql7nVqfh63UbTj+fYB9O6N/4m6f6suTuvmJiLNpNjnVUmlGZKMWe120n6TEKLb
 OJl4HWXg8XIG5FozOBkMYZw067XqY6DYfZ31gv6RyH3jvAAIxEq28up39lmJwPOmkLsToU4y3+s
 j34m0A9nieHyixg5RtC3qnvJ+VYKYvpPhy01HDFm/1uZWO3EKjrQ/0/RmqUjyOrVWSe/dRYy7XA
 4WZhLdNWkZk6OcwTYRiV4BbxH1bCdhErJwNCme3KHVRiobRjACEGEhca8ApcDX6kTrqY6LaY/YL
 +MIcZH4sWxXpOV8L+rRhTUEmRWSw1TcZk4H9FPC16le1wHGfR82mI560m6a997oqB0tPsnL4QgO
 p8kvP1k/
X-Proofpoint-GUID: gBlGuDK15iC4LP-p9jaX7DSfT-oovvep
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b083c1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=amgtdxY7VJ7HFpXEBS0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: gBlGuDK15iC4LP-p9jaX7DSfT-oovvep

syzbot detected a OCFS2 hang due to a recursive semaphore on a
FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.

context_switch kernel/sched/core.c:5357 [inline]
    __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
    __schedule_loop kernel/sched/core.c:7043 [inline]
    schedule+0x165/0x360 kernel/sched/core.c:7058
    schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
    rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
    __down_write_common kernel/locking/rwsem.c:1317 [inline]
    __down_write kernel/locking/rwsem.c:1326 [inline]
    down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
    ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
    do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
    wp_page_shared mm/memory.c:3762 [inline]
    do_wp_page+0x268d/0x5800 mm/memory.c:3981
    handle_pte_fault mm/memory.c:6068 [inline]
    __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
    handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
    do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
    handle_page_fault arch/x86/mm/fault.c:1476 [inline]
    exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
    asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89
f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f
1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
    copy_to_user include/linux/uaccess.h:225 [inline]
    fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
    ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
    ioctl_fiemap fs/ioctl.c:220 [inline]
    do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
    __do_sys_ioctl fs/ioctl.c:596 [inline]
    __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f13850fd9
RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b

ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
to read the extent list of this running mmap executable.
The user supplied buffer to hold the fiemap information page faults
calling ocfs2_page_mkwrite() which will take a write lock (since
v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
semaphore will hold filesystem locks and causes a hang of the
fileystem.

The ip_alloc_sem protects the inode extent list and size.
Release the read semphore before calling fiemap_fill_next_extent()
in ocfs2_fiemap() and ocfs2_fiemap_inline(). ocfs2_fiemap_inline()
now returns with semaphore released.

Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7 
<https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7>

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
---
v3: also release semaphore in ocfs2_fiemap_inline() with semaphore released
      move semaphore before calling fiemap_fill_next_extent()
      change the error path to release the semaphore to avoid an unnecessary
      semaphore down/up in the last loop..

v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the
      read semaphore before calling fiemap_fill_next_extent().
      Add a Closes: line
      review noted missing semaphore change to ocfs2_fiemap_inline()
             suggest moving locks to fiemap_fill_next_extent() call.

v1: change the ip_alloc_sem from write to read.
      rejected in review.
---
   fs/ocfs2/extent_map.c | 27 +++++++++++++++++++++------
   1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 930150ed5db1..20045fb1bb70 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, 
u64 v_blkno, u64 *p_blkno,
    * it not only handles the fiemap for inlined files, but also deals
    * with the fast symlink, cause they have no difference for extent
    * mapping per se.
+ *
+ * Called with ip_alloc_sem taken and returned with it released.
    */
   static int ocfs2_fiemap_inline(struct inode *inode, struct 
buffer_head *di_bh,
                                  struct fiemap_extent_info *fieinfo,
@@ -732,10 +734,16 @@ static int ocfs2_fiemap_inline(struct inode 
*inode, struct buffer_head *di_bh,
                           phys += offsetof(struct ocfs2_dinode,
                                            id2.i_data.id_data);

+               /* prevent deadlock to a mmap executable page fault */
+               up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
                   ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
                                                 flags);
                   if (ret < 0)
                           return ret;
+       } else {
+               /* return with the semaphore released */
+               up_read(&OCFS2_I(inode)->ip_alloc_sem);
           }

           return 0;
@@ -769,6 +777,7 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
            */
           if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
               ocfs2_inode_is_fast_symlink(inode)) {
+               /* ip_alloc_sem is released in ocfs2_fiemap_inline() */
                   ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, 
map_start);
                   goto out_unlock;
           }
@@ -784,6 +793,7 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
                                                    &hole_size, &rec, 
&is_last);
                   if (ret) {
                           mlog_errno(ret);
+                       up_read(&OCFS2_I(inode)->ip_alloc_sem);
                           goto out_unlock;
                   }

@@ -803,22 +813,27 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
                   phys_bytes = le64_to_cpu(rec.e_blkno) << 
osb->sb->s_blocksize_bits;
                   virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << 
osb->s_clustersize_bits;

+               /* prevent deadlock to a mmap executable page fault */
+               up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
                   ret = fiemap_fill_next_extent(fieinfo, virt_bytes, 
phys_bytes,
                                                 len_bytes, fe_flags);
-               if (ret)
-                       break;
+               if (ret) {
+                       if (ret > 0)
+                               ret = 0;
+                       goto out_unlock;
+               }
+
+               down_read(&OCFS2_I(inode)->ip_alloc_sem);

                   cpos = le32_to_cpu(rec.e_cpos)+ 
le16_to_cpu(rec.e_leaf_clusters);
           }

-       if (ret > 0)
-               ret = 0;
+       up_read(&OCFS2_I(inode)->ip_alloc_sem);

   out_unlock:
           brelse(di_bh);

-       up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
           ocfs2_inode_unlock(inode, 0);
   out:

-- 
2.39.5 (Apple Git-154)

