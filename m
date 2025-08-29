Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591A2313529
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 Aug 2025 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756480716; cv=fail; b=jHJ9oUGlXTnOdgf5vgKbkoHFcFDj1LZfzXTFkvqKHcMltYa87XXsd/aBsbd0oq+99H2CJKBtPWgZ85xlSf/97XJTBBh6U1n7jeCS5Ss2OXt0xBWC949WW94UcWv2NX5Z3qnA0dntdnU8tEvGBcpMSGqCN06zwUsJOqoHu90DdK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756480716; c=relaxed/simple;
	bh=SzuMvBGuJNKLTQg/pyge4BmLdfRf8xJ7Vkfg6e33GqI=;
	h=Message-ID:Date:Subject:References:To:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AiZt3WkxMm7aYaNv9p82mWm9yJ5OU5TA1PYpjRzZ95CSdX1i3h1ZMN/cLGULUHCfQTEnYfn4tz8I4KOX51/xk+4lfqCn82RNQKm95VSvoeOW5y7WcCLFSuCIVwEuZfpShLaZ+8MBvmd8CgISCDr0448hZwLwvA7t5OQiCOL/i2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YIZnn5eX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ocSejFho; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YIZnn5eX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ocSejFho"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEtrgJ009874;
	Fri, 29 Aug 2025 15:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/y1XlQXfOORP4CHx5UpPVrc8mn4e33HZj2yqpTMPMt4=; b=
	YIZnn5eXQNUMkQwP6G8lEVuLSG6BYjgY/cHarlLfer0SjyMceEFGtDUoYI6y57Jw
	O6w6L4Z6TDrgXMJn1Gaa+25QThr2SzsPs+m6zmwJE9xKEnSYfwKzvgJmuo4Xi0lH
	qw8vB+FyFs5L2/er/dm1Drr6dpz5vxlfkQji0KtB+iunCBlGhD+SzfqbDFwV6Q8z
	xVpWgvVb3zYDTif6OH3bOvsKRUxbjkD3hnh5r8qpL4DOnOcuh50vvOSMZ4hrnlPx
	o5MQIQO0fMBPKkQUVg1hiYXjKpWLXj+VWAmoHZSEWXCFDXmcvtrTXNVrMUEDNUxC
	aT9QS6R5wX7IgvD0NQ8Odw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twhda9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:18:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEeIEG018956;
	Fri, 29 Aug 2025 15:18:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dbj9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:18:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WP9gOmRzCBqiH9AH03/Q/bTj6Ws/w1J5Yeh+0z22p+9ei5XGBlK+QLnZSjdbpPhQBPlPcaV9RkuBk7iBe4JrPFvK85NG/odQYCFTbej/qccPEnDkdfdG6m/CYLulWZhWBNSpurothbfRo+xj6CKNWJ4yX3zv/t0lKuvULxVjP+WccV6ikogJPHCJ4+gQJdxFof12d8fmBPEHhh4v2yyzU0HBWYI2II9FooD8MGcYm4cWXC6fsVI3Ogewmi7xR9yJbaTvmSpVqWlAuY8P0Re1r82UA9El+bgsxrIYaBU1hmoQwGeaQTWjZmbtH7bWfIudPA6vBRlCgXxUBtT7t3gTGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/y1XlQXfOORP4CHx5UpPVrc8mn4e33HZj2yqpTMPMt4=;
 b=oNUvcSHpHhq0REhXRuhTNZCENjtfN9HBRXjNMTBUjl2GT7O00b/cKlUlhzmdwRpZFnE+qWpouDAC27WkoJmmrN+OmnNSv1KHtnfClYSuIrt3Y81BAP4reZaMQp6smowXGrFIqkPd59ghlMRzkM5vrdBvlk4uFFKTRqeCkCPqjoJtnVj3jht3aOwxFu+Dp+V7KfXkpXzYTbLX6990M8YUh+y0wC7Mn8ti/kku8r26BlNUsu1dA2qkREj+YMQri18yTxrv9gDrpbGuCJkpllGg7KUEE2VQgo7pSbeNXboD9qLj7AAc0S1aQfrXkBgQAL4XUcPUE83XmHY/+5RGg5JCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y1XlQXfOORP4CHx5UpPVrc8mn4e33HZj2yqpTMPMt4=;
 b=ocSejFhohgLi8gt916rcPVCnzYUBRqAbn5Vc4VPAyyQQtjxnOBdkCh7WYYPkBKGmud1aZ8CsaAILHsL/exm8GsrOyWFiwgkGQ7cgpLRpgn09vSfph2IkbTYWlBGxJEY6mvdbZ52ChB/r9sI5TUhBQuDBbsMwssfnNohWvOtO2Pg=
Received: from MN6PR10MB7491.namprd10.prod.outlook.com (2603:10b6:208:47c::19)
 by PH3PPFAF33AAF2A.namprd10.prod.outlook.com (2603:10b6:518:1::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Fri, 29 Aug
 2025 15:18:19 +0000
Received: from MN6PR10MB7491.namprd10.prod.outlook.com
 ([fe80::4ae9:8d81:d500:ad76]) by MN6PR10MB7491.namprd10.prod.outlook.com
 ([fe80::4ae9:8d81:d500:ad76%4]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 15:18:19 +0000
Message-ID: <61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
Date: Fri, 29 Aug 2025 10:18:15 -0500
User-Agent: Mozilla Thunderbird
Subject: [v4 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
References: <20250829150620.22710-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Heming Zhao <heming.zhao@suse.com>,
        syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250829150620.22710-1-mark.tinguely@oracle.com>
X-Forwarded-Message-Id: <20250829150620.22710-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::16) To MN6PR10MB7491.namprd10.prod.outlook.com
 (2603:10b6:208:47c::19)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR10MB7491:EE_|PH3PPFAF33AAF2A:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b7134b-f8b3-4c8a-de92-08dde70f490c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0lQSzRZS0ErTjRkbEdZMVlQbGJ0eHphR0FoQlB3U2RRQXA3U1B6LzVqYVoy?=
 =?utf-8?B?M3hUUmU3ZFlVTG14cWs1NkFkcW1JMnU3STNtamh5SHdnMkt0MTAxb2dnZk5Y?=
 =?utf-8?B?RjhTd01OWHp0TXBob292K29BWklFSEVJTWc1UXkyWk1OUFJtSTBuOE5EZVRv?=
 =?utf-8?B?cmFmNGd5NzRzY1BtQ21xSTZUV3NHcWpta29VUXFQT1ZseHIwbzJKZUtLZGhS?=
 =?utf-8?B?L042akhkdHpMdGhkcWREZ3RNbWp6Y0F1WGZxUU1IVHVjT2ZTYXpPek9oWHgw?=
 =?utf-8?B?MEpnMHdkVVpIdWRmU3lzMDdqc1FIOUZGdG41ZTVKVVdnYVpzS2lzNTlhaXNN?=
 =?utf-8?B?VHVJSkdqU0FqOEgwbVdsc2JVZVZXTjFHYjNqV0Z1ZEFnakxRa0pzOEJ3QlFG?=
 =?utf-8?B?MTdHRk1qeHZXSjFveDR5VWFwRHBrREFCOVJKK2p4M2FvNTZaamorK2pQS2Vx?=
 =?utf-8?B?bGltdXFMNitRak53OW5aNi84RDZNQmZ6OXZXaTloSWVPR2szTXZKYXVma0VE?=
 =?utf-8?B?L0NweE5IOXIzZU9QczV3SVNQdkxlNEorZ24zQlBWQUZSQTBXVmN0Z20yMFJK?=
 =?utf-8?B?L0o5YWpsR09saDYweCtTU2Q1a3JFaTVKc2dCa1Y5clBtUndyTG50bTdQdlNL?=
 =?utf-8?B?ZUZXbmgvSVVEdUZKSUt0S3RpVjBnTUdmQWhpY3p4Nk9qQjR5YVBDbCszMmZm?=
 =?utf-8?B?QVo5QUxlVk14dlZjVWZiRkkrOHpHVmxvOWZTV1BsY2tzZWxua0JxQXQ3OFla?=
 =?utf-8?B?M29VTEFTNDBjeFJNVGY1aFFTRU1FYjhudk1nM3hENE1BbU01R0xvVHRLbDhU?=
 =?utf-8?B?d2Z5a0VCMWl6S3pTWFhVTjgzVW9rVjAwRlRFMFZTYVhiZUV6WFdXTGlSdVEw?=
 =?utf-8?B?RFkrZ3lDTEQ2b0h6NCtuSDFCZWlzcXV5VHhKKy8vZjByK3llWE9PM3lnY0NS?=
 =?utf-8?B?ZFdGeUJaKys4YlA4eUpianRqdTIyWTlnRGJRaGZWbnhXM284MUdlRHByWWNs?=
 =?utf-8?B?NHhEUWRldWlEUjBJT29EWGVkOUNPOC9hUGhES210QTV2Q1lSVmVtNlpFY3NS?=
 =?utf-8?B?SEg1VWovQkFYZURpaEJWRjBSWC82QStDSHovVkk1NU12eXFKSW5kZXAwdURk?=
 =?utf-8?B?bGx4Z05NWXJVVzhtTTVlSUQrcFQzU013NEI3bzM3dmdCMXhsZ0dNblhmcGl2?=
 =?utf-8?B?OGhlNzBwNEppd2d3d21TWjd2VTlvUlFLUFl2YTdINTVkWWIxNGl3NXU2KzBI?=
 =?utf-8?B?NHZ0Zjd2SlA2OU4rV3ZWenFPK1RITU1iS3FhNWtDbjc1bllQbXpPQWdJdHNO?=
 =?utf-8?B?Ty96WlNHVE5ISXlNRWRvY29jNHR2Z1F1TXZFME1ZQWh5VjE4WkR5c0pNNFBZ?=
 =?utf-8?B?S1p5U3YzNW9NOGhvbEh1ak5Ydk9LS2tYM3hOUWhSdE9iaWJaN25tZ2w5S05q?=
 =?utf-8?B?UXE4MFlmQ1UxQU1EWXFHY3JTVVljbzRNTlY3TE1qTlQxL3d5NlVOTmZ4MDNF?=
 =?utf-8?B?RlBwaXY0cGg4OUp5dURLL2R2MjJqVEFnbk5DSjdJa3U5ZnU5bnU0Qktxa3Rl?=
 =?utf-8?B?ak1CVVBqVWY5THRiWUVpSkNNWHZaU1JnNlI5VTVZMFZJYzR4aFMraWRZYnph?=
 =?utf-8?B?TGhUZkN2RUhqZGRQMjZvaFM1ZGloV053LzJVdERpc015cDArRytrTnlQZFdZ?=
 =?utf-8?B?ajVBUmpFeCt5V2ZpYytHU29iRWtVdjlpNUx3MFMyR0huVU9kMFVBNXNNOW5p?=
 =?utf-8?B?TDZaRUdkenduTnp3bDQ4cUZCTDFSV0poNnV4ek5hNWRmNkZzVjhNRlB1NnBv?=
 =?utf-8?Q?LR5/Sf14u0Y5E40coyNv7mjvtf8pXm3wgsmVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR10MB7491.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzZXZytoTnVjbUtFbmMwNWpqSDQ3T0puV042b0JnOStwdkNRbzA3QUQyMFk2?=
 =?utf-8?B?T3pYUWdLbzJLV1FNSEFLQURuNE9DR0dlQ0E0NjVMaWRlblY3c0Y2ODN1M2dy?=
 =?utf-8?B?Vm54aEh6TzVGeHo1VkFkUWpwQVAyNXZjOXc3YzhJeUNkUktCTkdrbXZnUjBS?=
 =?utf-8?B?OVNySWM0RU9LaDhReWFWT0hGL3NjK0hPR1JnRDgvMjgxSTU2RThnNHE0UTVy?=
 =?utf-8?B?L1MrRUhUMEI2NUMyZkY4bWNET0gvNmNiRVdTdDhiNXRXSzkzcWYrSjc2aVIv?=
 =?utf-8?B?emNKQmtVTmo4bzNlWVNGWWpWTm1LMDZqZTRjRWJqZG5XUklTVXNNSEhtZ01l?=
 =?utf-8?B?RTkwQmVQb1RZR1VEWFVMUCtyZGVtRmZrazlTSC83TlRpZndyRG41dE9MSmlK?=
 =?utf-8?B?YllHTEkzOVVVcUFMaWxWVXNsc2twYmdWa0xtU2xQVUJEUFFmU3hpcXMzVnlN?=
 =?utf-8?B?NG05bTRjeEdCb0xHdUpkd1RLbWc0U0lMTXREM3ZTNFNFN0hqdFB4SVJ0c3Ix?=
 =?utf-8?B?SXhaT3pKdjRtcURtL2dERlBrUVlSangzUVpCbE1xekxzY3l0M0NUanVybVlj?=
 =?utf-8?B?bDZzV1ljSmZJc3E3OXl5MnFySUxYb2Mzb2hFTklhNVJtamd4N2JraVM0bjU1?=
 =?utf-8?B?dnhxMW82R3JaSmQ4V3JtNk92ZTRLWmV5UUxFbDdKSTdUaWNhZEdvczJQSURG?=
 =?utf-8?B?SzRpeVBIYXhaUW9hWTR6QWIzU1NoZGUrVzJsOTF6bVNSTGdlbzE0aVhRK3NQ?=
 =?utf-8?B?ekpjMlVQNWhrbW5TMFFlVWNiUEtUR3FFOUkweFEwWGw2NUxNMkRFNXBBR2d1?=
 =?utf-8?B?RCsrc3JMODBwWjhMOWwyME1sRnJPWnhQcTNueW5NMjh0VlFuMmR1aXdqNEFr?=
 =?utf-8?B?ZnZJclgyRGNKVjNDTmJYUEljcnhQSzJVL2ZlSWtiVHIvei9rMTJoMmYrWEZl?=
 =?utf-8?B?aXIvVVRMNXdHaGl4b1c2Ykw4UnFlMVNCVkNvdjNQWEJYU3ZvT2xzWVYxakU3?=
 =?utf-8?B?QnRkOHdwWUd3SjFXbHlIYWFOdmlxbEFkY0YrUWJodVdScW8vZXcwTWZsMzdF?=
 =?utf-8?B?cGJaQ1A4dUphajNDNmtIbUJ5eUtienU3d1JwSVI3RG9FdFVuVHhpUTRDWENV?=
 =?utf-8?B?RTAxSVI4cXJlb2lpbkdqeXB1ZHMvUzNmM2lGY2dhREdjcGNlUHF1NWVWcTdx?=
 =?utf-8?B?cmFCeFFiUWpPc2V4WXdWNStWZVhjNkNKRTdpcXl0MGE3N1QwcGM4SlNBSmo1?=
 =?utf-8?B?OHBVdVJwSXcyTWJQdGtnL0tTRWFpWnZCMmhjZ0tkVzc5Y2F1aTJWeTNHWXJJ?=
 =?utf-8?B?UWZvOHhHc2pLWnVxaG9LRXlIRmJza3FYOSsyY3hjd2M0NGdOVm9EenZiUlBl?=
 =?utf-8?B?RGw0eUhUVTRSR05sdkkrU0dNSC85SHE2VElUM053eDRXUWVGSFF1cEF2akR4?=
 =?utf-8?B?L2owcTFZWHpuTDV4RzVVbVNtUUs4cjYveHpHY05qdit3TVNidHhTRkZlbnRx?=
 =?utf-8?B?Z2xJeGliancrTFlqdmdEbzRURXFPazFoMkpaRVN6dDBIdFF0d0luUUZ0dDF1?=
 =?utf-8?B?aVI5c0ljQjB4d2dVTktmQ0tFbEFwMzk3eW93S3RKZEtTYlpjNG9LV1BQMjBB?=
 =?utf-8?B?VW5qSmtHM3pMZC8vRTR3R2ZsRHVHWlNpQnZzd3kyV2hTL09sY1hsRHRLYlI1?=
 =?utf-8?B?aGlJSFgwQktjZEpiaDZCYU5IUUU0bm1URVpiOTVYMkp5V0xaMEE2MFl4OXYy?=
 =?utf-8?B?bndDc2VZRHJJM2d6VWROMmdub1lzY216eWYzblR0MkFrdWx0K2lrTGVST3JL?=
 =?utf-8?B?dXRHdFdTUVNxSWlpUmllWGliR3V1L0Z6OGpONlQ2ZHZuVGIvQS9tL3VLeFRs?=
 =?utf-8?B?Mm9PTW1neTF1c013V3BqK2hWNFMrZUFqS1VlMnhXdmxCOC9EU3BNOUZPSzB4?=
 =?utf-8?B?L080eXRzWXJxNnpFVEk5bXR2SjJGeHc1aDJ4dFNmUXVWZnNkVkFtdnh3dWxI?=
 =?utf-8?B?VStFYzBJWkFQd2FRNGlocnp3dC93SXU5czVuNkJkY3YwUlRxMjU2WDBUbFk3?=
 =?utf-8?B?bEtKNm43YW0yYU1oUmRMVTdTWHRuNjVJbWRZY3hGRm5jaWttQWFYdndBenBm?=
 =?utf-8?B?SUN6eHkxc3BHUUkvWEhZSjNsdTIxeW1kemVUUUxDRUFOdmZ1cFUwZW80VHdT?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gVtRegZZq8XCuovVrCdrEiUAxXjhjeJKHMrTpMn8B2H6ZKgfpjxcCx8RmUkXyQvaocKOa+IJYXCO2uURtHKiO/0ASTzCB+H+XUtvkX3FaO6fRBZy/uo/Eaigg/lalHbcxt675MOFrPHVJvI1F3nMHkMhII7nZ+cEgSHi5zbBqvUHOh9e8vtjzdtwCbvL+z5vnKCEt0AN3rqNUJPKPYPv7gJzW5KO7PjFBVu92oFS8UD/sHK8EmGwwxEUIznOtruW5/Zad9jmFCsO1OyzgHs2TC2zLXQjJPy4e5ZO8rJUY/Q6oGiB9BHI4Bq4INc6AE+hIVJ01sgVdVDpEagqnBIhJpXVknVLYMKiTILz5iv4ew4SGyruXXLCFbGAu2C8DZLjgHIMLn82zS5o7Ni9v6ljNCQk+cXDrknlo3ByAj4QVYGgJvNpD1UspVhYMl0SBHZKu6FDkVNEmV4SDkJ4hPGw+CHf+IbvSLeJ9KSFNfFnSk1o90ulWPsZUxWiZT1+TxytIgewY7UqtEuJ4k4Q8p/Na1jQozJFfiqNDwyKAQexGOWUatfH5xVWr5clW1G0KxkxACQVBYPVbvfv0iDqlL64fzr430Y6LajdsU1de7/QcQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b7134b-f8b3-4c8a-de92-08dde70f490c
X-MS-Exchange-CrossTenant-AuthSource: MN6PR10MB7491.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 15:18:19.4753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Qnc1nKrT42g8GLLNR1k9DbMcObnVrbyhEDOBDg1+5DW0SGh2FJVKocahzjtH++j2GVATKI9O8pKKN7FMPFHpAjNLzr8VBgA3kKuMn5VZDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAF33AAF2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290131
X-Proofpoint-ORIG-GUID: kX6Qj46QgP2Y2rD4Edc7aLhwg34r2mor
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX7v7PCyWuhZcl
 WADsmugWFRzVGG2meNRIMWwiccIX8cGFoBx2ztKul0ztWR29fGB7AcyW/5D1Lw/0NJ2G2gynxgQ
 UbyW03miK8b4+DPr+5XaaNvjGuZ7XRgwf4yurNV7QYe4ahywmOJsQYW2t8TUdakpMIa2/dWpuhT
 +fWAmJSbKkKQzfxc+2xHNLy+lBHfUI4JUMwxiQn7qYUrDXRdj4Jpftm6WUDHU7qrXXKg42FKEy9
 5ee/l3Xl94quj6tX0v8InlHxSqjYBZORA9gbP63HEymL7Q3u5j1+8cmX/TSyB0oALIKNNPL31En
 Bj833cx8LtpXBtNn0YR1a5Gr4q5yIE9eoFZmluoeilyZuk9dPVF2wGeBTtfgtfLRhTXSgQZgfso
 O/3SgHiE
X-Proofpoint-GUID: kX6Qj46QgP2Y2rD4Edc7aLhwg34r2mor
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b1c4c6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=xisjCinVKgAkQnaEkKcA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22

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
in ocfs2_fiemap() and ocfs2_fiemap_inline(). This does an
unnecessary semaphore lock/unlock on the last extent but simplifies
the error path.

Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
---
v4: use Joseph Qi version. This was my original test case but v3 was
     done to remove the unnecessary semaphore lock/unlock round trip.
     This version simplifies the ocfs2_fiemap_inline() and error path.

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
  fs/ocfs2/extent_map.c | 10 ++++++++++
  1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 930150ed5db1..9ab22875bef9 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, 
u64 v_blkno, u64 *p_blkno,
   * it not only handles the fiemap for inlined files, but also deals
   * with the fast symlink, cause they have no difference for extent
   * mapping per se.
+ *
+ * Must be called with ip_alloc_sem semaphore held.
   */
  static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head 
*di_bh,
  			       struct fiemap_extent_info *fieinfo,
@@ -718,6 +720,8 @@ static int ocfs2_fiemap_inline(struct inode *inode, 
struct buffer_head *di_bh,
  	u32 flags = FIEMAP_EXTENT_DATA_INLINE|FIEMAP_EXTENT_LAST;
  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	lockdep_assert_held_read(&oi->ip_alloc_sem);
+
  	di = (struct ocfs2_dinode *)di_bh->b_data;
  	if (ocfs2_inode_is_fast_symlink(inode))
  		id_count = ocfs2_fast_symlink_chars(inode->i_sb);
@@ -732,8 +736,11 @@ static int ocfs2_fiemap_inline(struct inode *inode, 
struct buffer_head *di_bh,
  			phys += offsetof(struct ocfs2_dinode,
  					 id2.i_data.id_data);
+		/* Release the ip_alloc_sem to prevent deadlock on page fault */
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
  		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
  					      flags);
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
  		if (ret < 0)
  			return ret;
  	}
@@ -803,8 +810,11 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
  		phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
  		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
+		/* Release the ip_alloc_sem to prevent deadlock on page fault */
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
  		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
  					      len_bytes, fe_flags);
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
  		if (ret)
  			break;
  -- 2.39.5 (Apple Git-154)

