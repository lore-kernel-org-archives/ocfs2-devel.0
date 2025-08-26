Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079CD1A5B8D
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Aug 2025 13:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213310; cv=fail; b=BjZOEou5ZJECV2pi1cEJZlUw3V0v/I8o5gP910W/pB5PxWD6NjuGYRLOWSiE40gztOJebYyjgtnUxWxykwokVfcO2eEs2G0SUni5Bdx3rQZLnvTdpBgjOllXuoHGn0/cOCweYn/WjA5IFG3KI8QDlmFF0fs/ES6axeLyAuFaJjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213310; c=relaxed/simple;
	bh=9BWBGv3v5/mxK2TaYmMyPgkPiqYVoOqjhmB88nU+u0M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m91zoEaRzQ70MJ9kPuWdd3JfXZ81zJ1iIQPZp8SnRcNE6cv2Zrh6xYKBVGfIb04vdPuRiIXWBqpXGeo+BXZN7Oa44O11F8HqLlnftbE+F6J2sqGdf+p+HLAHL3c4SSD/SYeXEIFqh+CKyioL3qTvXJRPriWQvTeEVFFgZAbN0sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TUJeq2Gl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MSPJUQVG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TUJeq2Gl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MSPJUQVG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCILSr025981;
	Tue, 26 Aug 2025 13:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rK21vNelyuVoe72/zTC7bqM44dI/5jN9i3PklPc7N8k=; b=
	TUJeq2GlAtPRhblbHd/eGltxkoom5rtSog5RXRlFcyPuNtogB6xcaHlq/PSLcHSr
	pJ2LpHrMbWCbhUk6/voBUeHsaLu4x4wiIUNeIOgAmJEIrVlJY4UXOoqfd8E4O4QH
	/OSBV5AXAeGvB562ZJ1JU02vEm6+UecFeJxztgjK4bCld/cKY2IU8pn9h53Q1e+P
	2T0NCn4pXXvJpRNhU6itm3YXKJ+756/DHHza9TF9hj3kJoa0nVGdLPOpXDznlgXP
	CuwWOrxRAYN1HyZcv3BHDw4gft5no2Lh4L/cyzgdznM0pJK4G5+MNVEWqfVwQAFS
	Fn4ii3TurqB5nZyjsG7Q/A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt4egg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 13:01:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCBDRg005063;
	Tue, 26 Aug 2025 13:01:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439pcqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 13:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWuewm7b7umSjhoJmlyRSCdYFr0W0+xppMz1lp0bnHWpmmoZ936R/YUT0Z5ZFN3ug8WzOAtTo/PBIPNLH7TNbGvW8z4Y3ln8LrTl0OriZQdQTK2iPEl0OEUx9PG76bV8aPYtAcoND1WWNbfPCjVDzPG50EYpVdGMLABUHJ15/OOvYgQihjwREIYeAKuO6m6B5lh1o2NO4t7QWUVNDdjkWhjPMpR//NqkLssHHfk/6YIojyRj+KD/wccE5JRsb6cuZjjQzTUKn6UPuyAS2gvGIX5oBCiDnHwiG4RSwsB5rsiIeRzkze3+uJqQlgM/OtotM4BX/5Vak9V+paeB/2Ferg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rK21vNelyuVoe72/zTC7bqM44dI/5jN9i3PklPc7N8k=;
 b=GdobbbZ/+aeboAzBOmCYaZwC5mwMHa92IWzlOZ67XSbzWQsZbztOCybxowrSIH+9nU2DYlVz3pAz1KwkO3MoQQq+ulLv5HWG06cG5RAjciilY4VgSlwWGRb/rFLU9lg6wUbdnO8L84rCO0aJKrMEr+Y4FJ1xxcMcymr4T0Mko/cV7VUnM4wxnjXv/78NYdf6AmLnoauaLtuO3ncQ/R7nxA7bYx4tSxSWCTRu6hWxkfP6+0wMQXfS0sH4iWfpgqdlnenssN9Z8xYMJEIgehBgfWr2GseEV3wSxHbLqxgr/4srxzl8e6w5cW0/xC+kC+1JbPGKMDXBCK5cYfC4YmIa0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rK21vNelyuVoe72/zTC7bqM44dI/5jN9i3PklPc7N8k=;
 b=MSPJUQVGlSHrNGqfZ2SJigwRt4jz//72NVdakoIq0fLJ2PCostDceKbe4QpahpfTyXlSh22BR8ZrDrF6kPMBKMwmicv3ZTDfSOmJ7DejVjOqPtZQjTE+Z9GjIEO2/nyCEtoZQlP6vo3rbOJXjp6yhELUGjzvYwikzzfAqw9Y7lA=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 MW6PR10MB7688.namprd10.prod.outlook.com (2603:10b6:303:246::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Tue, 26 Aug
 2025 13:01:36 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 13:01:36 +0000
Message-ID: <67993b6e-d162-4a56-8b2e-3a40cd1f9111@oracle.com>
Date: Tue, 26 Aug 2025 08:01:32 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: PATCH] ocfs2: fix recursive semaphore deadlock
 in fiemap call
To: Heming Zhao <heming.zhao@suse.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        Mark Fasheh <mark@fasheh.com>,
        "syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com"
 <syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20250825145825.3596-1-mark.tinguely@oracle.com>
 <d05b1d06-3b03-45b3-aa5f-97b5e8366c5e@oracle.com>
 <6641daab-022b-424f-9b06-068e21e1adb3@suse.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <6641daab-022b-424f-9b06-068e21e1adb3@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:510:e::10) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|MW6PR10MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: c0981b7e-5cfa-44f4-3ebb-08dde4a0b05b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTZvaEVhYUNFMkJwZitOMmtiNjYvMDZpY2FTWXpOTmExUmN6akJWWWZTdy95?=
 =?utf-8?B?ZDZEWUF4ZXhMeEQ1cE1JakQyS0J4SWhacHBvWWpaZEhaMytRb3gwQnltZG9D?=
 =?utf-8?B?Z3hEczdYVkVTTzMrbENJTGNUZHc4Rlh0SkxWQkRINUtiSlNzeWVGaWxubDUx?=
 =?utf-8?B?Z3BqK3QyT01HT29FcWtncEY2Wk9SdXlndmRVdlYralI4V3AvV09Fa0lPd3Nq?=
 =?utf-8?B?aXMzZGtmK3N6MVNaUDB2VEMrNFl1RmR2YkkyTmsxS3ltdGk2ckZweHBuelMw?=
 =?utf-8?B?cGtyOVg0TWhic1Nyd2xUQ01zSFNuZXpnQ0hIeWcrV0Y4K0N3ZUQ3SUw3S3lP?=
 =?utf-8?B?ZEtxUFpsWlBJNTRaTjRzWThLRjllTktBcEdYRTJPbEFQUnVNZVBySk5MOHdY?=
 =?utf-8?B?cjJzbFNIaW5YcVkwbTQvOW41TEFGSWQvUjd0dWU0U0pBcnJGWHozZnA1Vk1P?=
 =?utf-8?B?WWlpVllVcHlNQjVSbkNMeDVFVWhqVG5OYUFBM0dWQ2xmdlU2SCtwVlB2L21q?=
 =?utf-8?B?eXVZSjdteG9IUG9qYm1qWDdPc0kwRzk1SzY0TENKWXRTZ3VjU3RiSDl1ckMw?=
 =?utf-8?B?U0dHLytWaGkvSWRJbWRFVUgzVHBCSUtFek5zUHNMb2tjMUxETENRNFYwNFFx?=
 =?utf-8?B?K05uOWhQaXprd2lyVUFIQzJjV2dRZ1J5d0JBRXlHSm1FYjUvZUZFUU1JVGd0?=
 =?utf-8?B?UVZud0JxN3lWd0ZzaS9mZUxQVVV0d3lBbDd1RktEb1o2eWJINmdvMDRna1N1?=
 =?utf-8?B?ekZGNnB0YUtTODljMldxS01TWlM1L2RSQXY5eURDUE10eDd4d05JRGJtK280?=
 =?utf-8?B?Um5meE1WWXRMSDlwMis3WUxQNHNRdTNueXQvQkEvZW5aaHZ0SjN2MjF2ekN3?=
 =?utf-8?B?REtSdlV5ZmlYeFY1dFMxcWU4dWpoNXVnWG1wREJGenZaMng5bjVsTjVpb0JS?=
 =?utf-8?B?RXhKVHNZRzhtaUZkOWd3VDI2VDgzZXh2Y3BmaUpVT01JVllkU0loNXY5Mlph?=
 =?utf-8?B?VE5MdzNqWFV1Rjk4TDF1U01VN1RTVXF2K3dsTllhdzJadGJEZU9zVDhLRG1N?=
 =?utf-8?B?VzBoT2x5TzlveUxXZUVJdXNxd3dQN0F6Yi9NQ3hUaEhVaDNFM1c4SDlMdzlS?=
 =?utf-8?B?eHd4VmFIQTBXUzcxQU10TjJFOG92cGdSTFFsL3Q4TVE4Y3g5bUFyQ2R0WHh2?=
 =?utf-8?B?SU5yZEFvMms3VG13Y25TOVZ6VlBXZ1phbFJmd0k0ZTJmR1RyN2x2d2pWSHhx?=
 =?utf-8?B?UElaZzN2RVNFNWFIeUdJY3ZMNmlVYlg2Lzl5Y2xXS1ZldFluNXdtLzg4bm9Z?=
 =?utf-8?B?U1NiVE4ySCtKUmhDOEVISU83bG5UL1pLRTlKczFkdSt2T1pCQ3FkL3psV3Ir?=
 =?utf-8?B?UWJxWTgxM25GV3lKaWZoWXFQMVQ4M3E2bFcrc0FvRGpMRThQanU4cDBRcFN4?=
 =?utf-8?B?ZGVaNDVZNm9oelptTHkzZk80THd3UlA4WThvYXB3d0ExTkJ1UE84MW5LL0J1?=
 =?utf-8?B?NEQxaUJDNkFVK3FpODZwdFpLVmJIYVZ3RjdXMUJyUlRFc0lkaFl4TzhjcFMy?=
 =?utf-8?B?aWtKc3hjUHRybGtkVm9BVFBJNzU0aGtFUzBpQldIMGZmRzVaVzFEL1MvNi9B?=
 =?utf-8?B?QkZ4cG5OZXdzSW9hUE9JTDZpeGpEVkJlV1dhMFZTVk5rZHFHcWNxbHNuL2Jt?=
 =?utf-8?B?MWVQQzBHUS9YNTJGaFJ3ZGo3Q0dTbDN2ak9teTM4eFpvZzB0SzJVeHpnV1Mv?=
 =?utf-8?B?aUxvRkREZU1kUmFPTU1rdjFlMlluRDJJTm02ZU1aYS9sQW8vVUg2cGdqOFNz?=
 =?utf-8?B?R2JrdFFDd21EYlZEVjEzWTNtZ1dqMFg2VzJDbDlld3ZUVmNzVU5CL0pRUFlI?=
 =?utf-8?B?c1lzYW8wRHdoZW1GTnhmT2x2U3dEamNxTWI1dmJ4Z2JCV3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjJCWVNDOFFxZkxMdnFhUWJrWmNsK0cxUVlna1N4S2FTdHRocGE0eTR5TWpZ?=
 =?utf-8?B?MU1QMTVzSXp1UGc2QVkrVU15NnRmbldZeWkzRTVnUXZiZnhvUDBmdGtBY3BK?=
 =?utf-8?B?aUc0UGpEVTZCNHE0OVFkM2V6MUZpdTQ0d2xhMDVINmlGMlNaUi8xcVp5MkNm?=
 =?utf-8?B?VlZJRFhZdVcyeDhCMyttWS90UmVEeXh3TE9rK0RtcHhjQXMyN3FFdEdVcnNV?=
 =?utf-8?B?djZuTVpSYlVFQkRKLzhzNjAxRXVOUVY3M00raFNYdjdvYXdrcWVjU25odHBy?=
 =?utf-8?B?aml5UVR2dVJDaEdpbDBrbXNqbk1qd0ZGdWJlTURHSGozV0lpVk5PR3EyS3lY?=
 =?utf-8?B?Lzh5eC9ROEFsOVowL2FtbmJDSkpDdE9FWm5HY2hPRitLWlh4Y0lqRUpMMjB4?=
 =?utf-8?B?VTdzcGU1d2tNUVkrQVpxVC9iV042V0lMNnFZbXJsVDc0S1dRN0tSZnBWSDlT?=
 =?utf-8?B?YjdJT0VRbnczYTBWbkM1UlNaTUhCTjZ5VWUybktsN3B5eXRRRWxWSUJTRjhF?=
 =?utf-8?B?RjlOS29oUUdVTklkaHFQcUdGby9oUW12Rlhqeis1RWpLY1UrY0s2WFFwMEZL?=
 =?utf-8?B?dEVJaWdhZW9LbjF6aHJEWlNPT3hMWTlMM0lIVU9RZXNEOTVOdFQ2cUlSeHlo?=
 =?utf-8?B?TVNmTGRzS051dW41UHdHODZOVEFHTVYzanBlS0pCdVUzU0NOcHNDS0tkQklW?=
 =?utf-8?B?amVnSE1teWkzZlF5aEZWaGZCb25qZjZneWtndU1EY2F4NHRza0Q5a0tocXI2?=
 =?utf-8?B?K3lETmRYMDdtMGJSRm4rOUdSaTRuTVMyOHh3M2tDTHo3ZEQ4dGZ5bWx0Tldo?=
 =?utf-8?B?QjZGSlk3cTFiOThRNUVEbTljRm1jRlVtdktRV1JzU0t3OUxCUjZreDNFbGda?=
 =?utf-8?B?VnRLamJQeHp0MmJrQnJIeE0zbmZmWXFxZzc1L3J0TjRJdWM1WmFHQllQMjlx?=
 =?utf-8?B?UUQrMTdWc0d2dWZMeUNqeGJXUzZtTWFzVkJNWjlMT1FTaEEyMmlQV2RVcExs?=
 =?utf-8?B?YUp6NXhWeTJucG1EUW5ldWxmR3BCaktmOUFIbVYzdExOTjJ6T0RTb3J0UUda?=
 =?utf-8?B?NGE5NTlNeHVrN21GU1ZrSVZsOWw4elJsSUJ2emNLVWVYaEMycENGT0Ztbk5j?=
 =?utf-8?B?OGF1Uk1QVWJ5cEF4NkFnSlBTNlFzd0NqRlpWRHV5QWFWZ3ovaHB1ODBXNUtO?=
 =?utf-8?B?djYxNGpNVmNRZTNoRXJ4NlFOTElqTEJGcEhzVkpFZmxXZDRwK0dzakExa3Vx?=
 =?utf-8?B?WnRjdmRlZEpCdjZKU0JDRGtUTExESFh2QzJySTRZWjhPOXEvL0NFMEVSTmxQ?=
 =?utf-8?B?a1hQTUJtUVNSY29TNDFHTU1JamhQMU1UbXU1czNjbnRIZVdROWp6UUhNUU9u?=
 =?utf-8?B?Z3k2dngrdG5RMzBLZmFNYWM2bHpXZ0JETzZEd0ZlWFFZUzJVdm9RcUFudWZa?=
 =?utf-8?B?cFRzcmxYNFdhb1lkMVRhelNvVGprT2RHRjBwbVRyVk5IWHorNkhpOVFEWTNG?=
 =?utf-8?B?U0dhbW9UeW44Sjd0VzE0VmpiZ0cyc0xOcFpTa2d0anNDNDJXQjUvaFBVQW0z?=
 =?utf-8?B?ZmxaOW5GSFBXYS94WVlqT3V3TGptekhPY05JWkZXYVN2MTIydmEzc1I3YlR4?=
 =?utf-8?B?bnNJWG9aQWxiaE1tUGY3MVkwS3BqR1V6QUZNZlBXOG5SSkVYOGx5aDlvS3Nq?=
 =?utf-8?B?Nm1OMUJaSlViL3lwVmtXUWVEd1VuN1lESmdMSFhiRG9razRENnJaMllJdjFn?=
 =?utf-8?B?UUJvZ2NvOHYxNkpvM2ZKNlhZUGxleEJEWnlsQVpVWTlhQ3VDOGh1a3BGaFk0?=
 =?utf-8?B?REtBQ2swcjNJcTZHaWJtdGt2d3dNY1FNV2lDd3loU0ZocDhYUDJQRnBtTktS?=
 =?utf-8?B?YXk2WGl2eTZjNHdWdnBmWHJOTU02OTVDRFdWTmE5a0dpUVpnSXhGOFhGOVIw?=
 =?utf-8?B?dXN0L0NadjN2MC81RWI1VSsyRDEyZjZUYTBOTGNxa2k2dVJieW03dHczbjBJ?=
 =?utf-8?B?bVJ6dkVBdUpLMGltdHY1Z3NoOUhpanhubkM5TzV2ZG85ZXpDU01HMEJSTGFj?=
 =?utf-8?B?OXM0dTZTQUdDeEwxQ2lNNkRlUlZ1Nk9RR2M4YlhMaTBFNHpnazRyZWFCUktF?=
 =?utf-8?B?dmVsLzZGZ3haZkh0WWlnMTVrZ0hhR3Y2aWdVYzVOeEpGRitRd2pPVHZKQ2JP?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	35FvA4XVZRVR0XHAG6WXrROqZZGMngf/E8zJoigEb7gN1rZMpkZVEiFaWCKWhJj/Ax5z3Wu4XjlN/Br9HlGCkN3sp7ClOt+REw973jHzijCUNKSV2rcqXUKNQGjJEa37kzUHaJBEn0u/Cpk9H98wnlbi9mKtf/ndTshxpm8g17+xP0uK1qQzyL4KFSiKI2PauBJDqdh0lgWvv6wkAsqEoduGqRD+PbNCRR2N6D/3S8QVdPA9bAaE0WQxUIrGrDnskd6MFJlvg3Jr5Hw5M6c7df32u02zuAaWeTOPKB/77LSMzzyt4N5cjzBKJmMG1s++GvpY/rSILD85SDOGpPFDORnmkBnjR0WqIcyf3u75ZW9BvSFkH4Am8SoMs3Ims/HTANiFW+RkamH3Opxp3dgAcLywrG//0haFz2oWmmPKxIsdRIzPWCDZLRhlBQartYgZyN07xXhh6eePdAChpXFC1Lloa+SGh60e5Bvlxawa4o3B/o2aUZT8L6eKLR+1aX4Mjl2C7jTnkoUgVe9xDEeFlheEJGWR+9rKEfXi0phVvUgl7noP64a8oHD1LLs5DgVWUO6IL2206vXge837q8458ZGjwAfzubclGPs30L574gY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0981b7e-5cfa-44f4-3ebb-08dde4a0b05b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 13:01:36.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m49JH/QHxnQ2Ki3wyS5NBs7GZq13N48uSALqCvxnZqOtpgGfRcmvHAU4Fz1Mr8swZsiNcOD1PSkKx7Lf+leDy8dyjAYpPr2PAyt8/nC9Nuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260114
X-Proofpoint-ORIG-GUID: K5vxWtxYQQBAGGef481a6ls_n2wgZ0Z0
X-Proofpoint-GUID: K5vxWtxYQQBAGGef481a6ls_n2wgZ0Z0
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68adb034 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8
 a=Eot0jJAFVSSYS4_hJ2EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX8Gm1XXE3j9rO
 0ajFTq5Yc/KKD29b747cq5wrBDfbfSWcT3LZyhJsgyEYG0NGKiHCYoOFKxfIR/sdaPLZE2faYcg
 z5MXKlE6K1rOFzFDzgyey8aqiYWl5hYBR4TvWfqebfT/j9KgmFCuGtC7RMNteNbfNh50zGDQIZt
 n2jUrCPM282oSimu1e2PC/V291/mX4N/bfvRyCc9zvm+RV4JIDhnhXfFsAZF5M4KYKXGGE27m2d
 jRXRZu8qICed5qPzsQS1v3wRkbqWiIcR/9A0AEr43q9i47KlSV1/AXbH1UjDZ2JVhzyBmFxWBt6
 rgnosQUGHxhekkaDcXn+w+b3CtdGfNs1xKbJ0e1o6aeH1d/vvcCcJVeEtwOAdV/8yt+drM7Oik1
 13vWIorZ

On 8/25/25 9:19 PM, Heming Zhao wrote:
> On 8/25/25 23:13, Mark Tinguely wrote:
>>
>> syzbot detected a OCFS2 hang due to a recursive semaphore on a
>> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
>>
>> context_switch kernel/sched/core.c:5357 [inline]
>>   __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>>   __schedule_loop kernel/sched/core.c:7043 [inline]
>>   schedule+0x165/0x360 kernel/sched/core.c:7058
>>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>>   rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>>   __down_write_common kernel/locking/rwsem.c:1317 [inline]
>>   __down_write kernel/locking/rwsem.c:1326 [inline]
>>   down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>>   ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>>   do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>>   wp_page_shared mm/memory.c:3762 [inline]
>>   do_wp_page+0x268d/0x5800 mm/memory.c:3981
>>   handle_pte_fault mm/memory.c:6068 [inline]
>>   __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>>   handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>>   do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>   exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 
>> [inline]
>> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
>> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
>> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
>> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 
>> 89 f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 
>> 0f 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
>> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
>> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
>> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
>> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
>> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
>> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>>   copy_to_user include/linux/uaccess.h:225 [inline]
>>   fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>>   ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>>   ioctl_fiemap fs/ioctl.c:220 [inline]
>>   do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>>   __do_sys_ioctl fs/ioctl.c:596 [inline]
>>   __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f5f13850fd9
>> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
>> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
>> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
>> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
>>
>> ocfs2_fiemap() takes read lock of the ip_alloc_sem semaphore (since
>> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
>> to read the extent list of this running mmap executable.
>> The user supplied buffer to hold the fiemap information page faults
>> calling ocfs2_page_mkwrite() which will take a write lock (since
>> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
>> semaphore will hold filesystem locks and causes a hang of the
>> fileystem.
>>
>> The ip_alloc_sem protects the inode extent list and size.
>> I read semphore could be use in ocfs2_page_mkwrite() and
>> prevent the recursive lock.
>>
>> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
>>
>> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
>> ---
>>   fs/ocfs2/mmap.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
>> index 50e2faf64c19..78513109b9b1 100644
>> --- a/fs/ocfs2/mmap.c
>> +++ b/fs/ocfs2/mmap.c
>> @@ -139,11 +139,11 @@ static vm_fault_t ocfs2_page_mkwrite(struct 
>> vm_fault *vmf)
>>        * ocfs2_truncate_file() changing i_size as well as any thread
>>        * modifying the inode btree.
>>        */
>> -    down_write(&OCFS2_I(inode)->ip_alloc_sem);
>> +    down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>        ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
>> -    up_write(&OCFS2_I(inode)->ip_alloc_sem);
>> +    up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>        brelse(di_bh);
>>       ocfs2_inode_unlock(inode, 1);
> 
> __ocfs2_page_mkwrite() performs a write operation, which should require 
> a write lock.

thanks for the feedback. IMO, mkwrite doesn't perform IO, add extents 
nor change the size. There is no IO in mmap here, the mutex is taken to 
protect changes while write_begin/write_end add the mmap page into the 
cluster of pages. Other filesystem use a shared/read lock in mkwrite.

> In my view, there are two ways to fix this:
> 1. split the big semphore lock for ocfs2_fiemap(), this involves 
> releasing the read lock after ocfs2_get_clusters_nocache(), and re- 
> acquiring it after fiemap_fill_next_extent().

yes, I tried this also and it works. It is not very pretty.

> 2. use try_down_write in ocfs2_remap_file_range().
> 
> Thanks,
> Heming
> 

This is a very contrived situation. It has never happened in the real 
world in 17 years so the urgency is extremely low. I understand if the 
risk/reward of the change is not worth the effort.

Mark

