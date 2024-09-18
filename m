Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E24405;
	Wed, 18 Sep 2024 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726641646; cv=fail; b=SmVk7VD7MxEmsfYDIbgHoU+A3S+ncAlKSz/r0y5zY2g3pAg03tRKx9clWMHVBbYtGI41iBUcpHUic7xh8gMeRkSMuRBqp3RW6EErQgACB2Es7FmisG8lZ7x+TApJyyjsFrh5uabE/wd6m+bpMPzHNjom2ECBsax/QB8/T/Zl4aA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726641646; c=relaxed/simple;
	bh=tnMivFZ5nFl5Ql95Vez1WL7knEMkLAp2hbHX350HamA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JkalAqXBlVkgReBBnAq6L4Tt2m1NfMXIgus2ceiDuAWjmdhhw11D7sKxS8lG2vniX3XomBQhV4hIHOy3Xo6O+YJzgicMRS8SOjGKuVViheJIwtDUP1FJReVrHT8mm0B9jgQFNq/ubTwHnEy2iC/889cZKdzOZVRBAfJa26yhs7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bZnBNrtx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nh0UFu8u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bZnBNrtx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nh0UFu8u"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48I6MhZK026121;
	Wed, 18 Sep 2024 06:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=tnMivFZ5nFl5Ql95Vez1WL7knEMkLAp2hbHX350HamA=; b=
	bZnBNrtxVPhuz/x4rbyDOGW3ePGf5mUW/OX5RVtNvIwarESWLtMREwo7JUTGEXUi
	GVxqAwVW0fEdqxrQ1zB/VVwdDeJq8tCl3T6eL8Z81I4F7S+t0UJdNon9KrhECfGa
	g0chrba4K1XSxHnZemRMA16sQrHZQlWMBc8XygBrim8qaBhrHJchn7mDL8NcP2Lx
	NgrZxy4drQy+hWr+8Crlz4yNiNqcGcQpjR2CoBuNu3h4B1GoPvfDHsTBE5lHjvaw
	Qh9RJVltIrN1AG3/qHJxs3mkB71ax1/6zsPfaPOCPlDm5B0vMo1wqvqRhQgm6X4Q
	YEYDn1mDxyDAFjWvjEG3aA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rk0941-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 06:40:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48I69GJ3040408;
	Wed, 18 Sep 2024 06:40:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nydw4w94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 06:40:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkDpX1kcVWnafdtaww214Yu9NXcXnUeQNhg/2FYXmPeAJFauzyzi4n2LnCHL2bXBoru4RPaQHTKxkm+A94Lxpu4s9Pfd7eIbqnLcE1NPYlAW52JWDuTvSlGj0dTXWcTZmMVbZYBTucJOrydJzUB9vPYUoAbLvskeap4+SOPBtjIqf5GYP6d9nj8+VojTTEDN2HGIcKG90ptf4sRcafi01RsZNhKte1z5YQfWmu0aiCILX0ktvfddifyHsNn0akbDjeK+IHCHTLBNBwMXHEmNx6FEo0Hf0sYu77/+nVtGHXMpiDBHHaYrnPAJVxgQO1h8fnZAokGyaMETaPABapTtdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnMivFZ5nFl5Ql95Vez1WL7knEMkLAp2hbHX350HamA=;
 b=isNDnNnRbPf3GYtB/2scUJV3DH6kMlf0zUlGzP7Sz7F10uq1pshMHXxe8ysQmurOKzWVay0//54Wcod+i/otmoHQ2+8tmTAJ83WYngxnuSVUT75XbO9+Fijl3Is7RXyfOlaK95aCFG4m5RmoTepSxgarVlFcFDdQM56mQ9SIlfqXLtBO7rG2lYsJLLIj3hrcO+cnrSoIIN6Cv2kNo8tN0URvrbAflm781UAVaZWCrr2ifFyoE9l9Wvy5cMylhJxlz04R9IS9rcdNasdXguRw8QJSO6LQ1J/ug4CaeHcDIv/WUilBbnAnFBhqOqP+XkUK0VJexE2HwnVTvGKZecWWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnMivFZ5nFl5Ql95Vez1WL7knEMkLAp2hbHX350HamA=;
 b=nh0UFu8uxT7hs6+0d8+YqgMy6ge+PXM7ypN4I2QKluOiKe8qyiDSYSBum7U2QhK1JpevwMTYR0k13tsC8HAsIKZMavCDgs0sePImbWe/xugoqp0Z/ILKXU4U7xVGemZA4c4via8aDjOqxTNn2yUo7kjINTXWXHLpFk/z8GvYW6g=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 DM3PR10MB7945.namprd10.prod.outlook.com (2603:10b6:0:47::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.7; Wed, 18 Sep 2024 06:40:36 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7982.012; Wed, 18 Sep 2024
 06:40:35 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andrew Morton
	<akpm@linux-foundation.org>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC V4 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC V4 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbBN+gjc7BUy/wR0C+FH+IdU/pxrJaneiAgAI0d4CAAE7AMA==
Date: Wed, 18 Sep 2024 06:40:35 +0000
Message-ID:
 <DS7PR10MB48784A0B9F8CFCFEAC75DE51F7622@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20240912064720.898600-1-gautham.ananthakrishna@oracle.com>
 <20240916091647.dbcca9d29f081c7a4c5cd2ea@linux-foundation.org>
 <a4ff61ae-c83d-4a6d-837a-4e3c22c99a69@linux.alibaba.com>
In-Reply-To: <a4ff61ae-c83d-4a6d-837a-4e3c22c99a69@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|DM3PR10MB7945:EE_
x-ms-office365-filtering-correlation-id: a07da356-ab8d-495e-85d7-08dcd7accd4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TjVlY1dTSEZuMnRjK1VPQ09uck1HdWdBbXU4Y1V5emM0RGhEUFhzL29ZbEQy?=
 =?utf-8?B?RUJDYlRKclNLaVlQd3pWTmR6RFRlY2kySmZiaE03RGIzYnZBK2VoWjhlNDg4?=
 =?utf-8?B?WnVlQ2N6dFpnRVZ5clVUNzB5OXlPeVJVNDZMbkhMWUVaUEg0Njg2ak41M0pP?=
 =?utf-8?B?RTY0bkt4YkRURXIwWXVLZjdpVSsrck11eFhSNWJKdkVOaStJa3ozQXpmRllx?=
 =?utf-8?B?WEZpRy9OaUp2NnhBUFRFR0wrZkh4Nk5XcXo3Z3kzMWxqcUVmTCsxK2ltbnht?=
 =?utf-8?B?bXR1RzdoOWpUK3FvdWJFYzRNWW9EVkVsWTBoZE5oRHY1RnNXeUtGbWRTY05C?=
 =?utf-8?B?TkRVTjNpZjc1OFJNWFEyM3Z5VVNjb2hFSU5XRmg2a3R4V0dEMzg2RHZoMlkz?=
 =?utf-8?B?RTc1cTZ6V1MzSm14RUwzRUV5VHNhYXRWNFRKdDRIbUVweVBxT05ON1o5Y1lq?=
 =?utf-8?B?R2s5bFRpb0JVelFqWi93OVRyVEhwZXdRODYweFdtYTVQS0JYZWVVSVhBMGJS?=
 =?utf-8?B?b1h4eW5MSDlnMTdWZ2owN204OWtsY010N1JZUjV6UzdSc1Q1VDlXSm93eDJT?=
 =?utf-8?B?bUwxdTRNb3F2MmIxUjlGS0J4RWdoTkJMcHZIREJ3aGMybStnYjI1QmxaYmFn?=
 =?utf-8?B?Y3FrMXd4dXFONzgwK3o3YWMzOFVTcW9SVWV0M3hpVHZlcEd4R3VjbHlORlEw?=
 =?utf-8?B?cXhXUGx4NVJFblRxRHgxb1VmcHJCalIvM2NQM1RYOXI3cmJBdzFvRHhzOFFh?=
 =?utf-8?B?SGdybGluZHFhWGd4cTQrb1NtWGJEck5VVmFyeFBaT095QjkxMk1OSE5UQjdh?=
 =?utf-8?B?R3c1NkhUYi9ha0JSWjg3bFpZbk5iT3hJN0ZOdUhGbkMyUWxZZ3YxNHlPWllD?=
 =?utf-8?B?K3ZVcGJGcGMxTGZZYVZnSHloL3ZHdGgwUTFLVVFIZm53ektDQkpMcHRXZmJi?=
 =?utf-8?B?SGJMVHFyeS9WZHVsalI0ZmUvZmc4WHMvYVd1RkgyZmFoTkdXbWE4TWkwQ2NL?=
 =?utf-8?B?ODl0SzNxU2JUQjhVUkNIZ0d1SkU0TzJaN0owMVRhZFcyczVTcmZFYzRHWkFS?=
 =?utf-8?B?Z2I0aWtYTzU1SW5WNFp1MnFBU2hIOUpEUXRGZTgxcWxMcnNjYUlSNzRlRHZQ?=
 =?utf-8?B?ZnNwUVN1c1dydHE5ZHd1YzI5ZWo1WHRVOGkxYkdzRHIxMUo0TnNCMmRGMEM4?=
 =?utf-8?B?cUZHbGVTUGh2Y05uak5HcmpRUVplNVk4T0NqWEVUaCtuaUtuRnlnWXh0WVhB?=
 =?utf-8?B?VFI3aVlyMDNQYnpuTWtGT2NtZUpickNJbnp2b1lHV0JwenQ0VGJ6OUR1Q05q?=
 =?utf-8?B?WDBRL1pud0doNWFveWtFZmlUZVJ1RCtqRGZuWE1wT1VKK25jdGJsQ0FHUlFo?=
 =?utf-8?B?NFViVWp4R1hXQUp3KzVHMENvbmZZY2d2dzRhMU81Vm03QVkxOVFIVDVWTFc4?=
 =?utf-8?B?bGZVbHVERWtBWDFJUFB2d014emJ4bDlKUklqLzM3NDdYOTYrd296L2g1dmQ3?=
 =?utf-8?B?MjhIZVRoUE5zQ1dVWVdPVkRnT0tKUDl0YXlDRGQrYmVCVlNkbXdiaU1JK0dO?=
 =?utf-8?B?cEViNDFYdVNTQkkrNzU5Z2tqYXIxQlR4WTE4NnhVNnFWcU5kd2ZrT2VvVEpS?=
 =?utf-8?B?SWQ4THJ1dnJHdnorYmR2N0FiYjlESlBsZDJScG5EOTRtVkh1WFVKZE9OQ3lK?=
 =?utf-8?B?NnlmNnVlWStqZ3UyZVprQlMvdS82UzNaQlBYZFdiVE9zT2xuOC8rSFhYamlh?=
 =?utf-8?B?Zk04ekxnMURtaWN2ZGRycUVwMUhEYU90dUZ5TUJ2VkpHRWdLL3VSUDVXNjdQ?=
 =?utf-8?B?U0lIT2pXUURINGd4RlRHK0QvMVNhSm5QOThIQ3FqbVpmelJWdW0wcG5NYXFz?=
 =?utf-8?B?N3NJTDBERW1VeTQyV2hnVWdnTzFmMTNBUy9lTzVOcld5eUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S3hqS1NhV1BhTElvendFOWdmemh1UGgwNm9nNTl0MHl5dXlNWWdVZzZkWGwy?=
 =?utf-8?B?cDZocFdGSHhlek9vT29GMVhEY0xXYUh0TEZkR3FwOWRVeW4wSFBJd29CdjVP?=
 =?utf-8?B?emxGdkZNZk1naHpiT0lYcFJGZVZPaTAxS1Foelg2UGpqc1lCSFVFYTFVV3JB?=
 =?utf-8?B?YjBQdkVCbU9ZZ2hSWGlYdXR4VzhNZk1Wa2Z6TGxRaDdCNHF0VkpNcXpRZ1Fk?=
 =?utf-8?B?OGJEMXNna29VdTRoa05TWm5YRWUvRnloU0lsWFM4ZzVIUWhuZTBqdTVQYjV2?=
 =?utf-8?B?T1ptYTZnQjhWalZNTjdjdVpsTEpXYzJFYlRoWEwvOWFDbityS0o1SjNYLzIv?=
 =?utf-8?B?WDVaSFZWanV1UXgwSWlyNkFPTmFGWFNDOUJOcnlXbEFkMkFJVXB0NktjTzZB?=
 =?utf-8?B?UVd2K0l4VTFxbW5ZRU1oVExrNkxsTndYamU0NGpUNEJHbEF4QkE4U09SdmRT?=
 =?utf-8?B?M2Z5RENYL0g4VThXUm5pQzJ6UHZrRDRaQWpXbWI2cVVSV0NHMzlScUx4Nzd1?=
 =?utf-8?B?S2NndTNyY0JQaG9rMFVRd0FJSjBESkxLdTNXVTVMUDlWYzBiQlNGWExzVnhy?=
 =?utf-8?B?d2o2TFlMZ1dpYXk2endadDdDRlVNbXFBVkJYTG1oNnFOVk9SaEhPZkh4a1lK?=
 =?utf-8?B?bzdzLy9FUGZxb3dmOU1pL0dFL2p2YnBBNG45VThxZ2N1SEN5NUY4QmN1VFlJ?=
 =?utf-8?B?V2dlZ3FVTFM0MnA0aWNzQWhuMDBJOWpVWU9uWUdzVERJN2ljWmwrNFcxN0Ri?=
 =?utf-8?B?by9PejZ5UXJWaGxyVXNFWmRZcGo1OUFIWjdJOGtaK3ZPMGlYZXhrK0pneGl1?=
 =?utf-8?B?ZE8zYUpoS1dQUWxQSWpiU0x3cndmc1ZWZFc4emEwVG9ka3RtV3lXM1pQcFg1?=
 =?utf-8?B?WGRkRnpGTVZwZTNHSmdHZGRrQ0pZR3R1K05zUWtPczlnbENIMUYvWUdHMTQz?=
 =?utf-8?B?NFNDQ3UvNVVvQWRIVm1FeFpaVEpqdHJ1SXBRMGNodEorR09yWDdVSk5vVWtL?=
 =?utf-8?B?ZmhoUmFSaU1LSmoya1o2STdkVW9nbStpKzlSL1gxNDJJdDFtblZRUU4wa2d1?=
 =?utf-8?B?NHJwbkZYZ3Z2R3FKLzladWxKK05scnpjdHBTdyt0NzJnWGEwWjVoanM4VzdE?=
 =?utf-8?B?LytsUmtGKzZrNC9iMElTaUVPdXpPaTlNaWpZaEk0c0hOSHhDY3hDemkrKzhR?=
 =?utf-8?B?WFdTSjdpL0kwZXRRVXh3MlY5NU4xL255Ri9mN2Zzd2x6aUppODhOaXU5UXAz?=
 =?utf-8?B?bDZzRi9ZZ1JPdXoweUwxM2hUTVdMNWNLZjY5WmJLSGI2anhDaVJrc05Xd21a?=
 =?utf-8?B?bllPVFlvcmtrSXlUSGN6blZncFdTcWpUanZEaFlUSVUzb2huVUFldW9ZYlVl?=
 =?utf-8?B?bFdUSlhsYytNV2NGREFRNlNtT1A2Z1duc2pRUlF1ZjhVbHFwbXQ5aW5oelFR?=
 =?utf-8?B?Zk5UNEhDUHVaSTZGdmF2eld6bjRKRGZmVHhtV3dicEdkNFFHRituNFc0dHVz?=
 =?utf-8?B?VEk4QWwyZ1orcENzdU5QQTNJRjhaRVQrdEtjSFJzM0djTjNOcGk0RzJ2UVdp?=
 =?utf-8?B?RFdPZzYrckxqK1o3Q2phU1RlNDVUWlpVV3c5eURxbXhFY3ZSWkFINXRnWnhL?=
 =?utf-8?B?RVphTEFPOU1yVlYvWCtRRS92ampocVhjMW5EQzBXcUhRR1gwQzh3SHRSdDVV?=
 =?utf-8?B?WmxKem9paG5WN2dlSm1sZ2pmRTloazBTVlB4WHA3QlVpL211NmNPZXZMRmh3?=
 =?utf-8?B?ZVltYnVVSGhtbFVjNFJON1BUNllINDF2V2dnUVVPR1JydUdXTTlhNjlyTmdX?=
 =?utf-8?B?R1g3eGZ4aXU5cTMyUXpFaCtWMFpoRkVYb3Y1djZ4d1NxWmhheExid0lXWkxM?=
 =?utf-8?B?NzJ4UXZxSzA4UE5MYUZvMFhSZzUzbVhGMi9wYU56YUp6cEtWSksrUVhLVlBp?=
 =?utf-8?B?WEpMYnVqSEpEMlgrcUJ3TW51TWZHTXFNU1RHN2gwNkZXUTJJZkkyMFFWdUhy?=
 =?utf-8?B?U25qWE9uQ1dEYjJ3dE14SkQ2VkxNbE4vQnBReDAxS3RFM0kxK0VOWE5adWhS?=
 =?utf-8?B?TkJtRWFWVmJ5OEN3TDdWWHRja2VabnhPVzcySWswNGc2NEp6cHpEV0xFb016?=
 =?utf-8?B?ZnB1WVkxamNxNnRQK0hGaldjL3ltNFFKQVJmV1BnVytxOEtCNGNINWZBQUdm?=
 =?utf-8?B?eFE9PQ==?=
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
	TVUZap+e3TPXw+1GYtPanRplgQUTlp24PSSOrfZbvPS2rehrWfD5I+TrV4xJj+5H/fu9/SD9VYJp2BJ71Gubeb4FGCohu2ZPdbPkB30YfUaqVk/SKePIcyP2e0O/aegA/iP6ROs1+9ZWbwlMV1qeU2y0bWkHm0fPhznCCX83mtoFUa/ubDcA7MoolFLLRf37O1vrAk5KqAQDRLczgDQU6qdgeNjANzAqmEHh3idVNOC0AybxV3qTN5ohdzYEBuClrVbyQUSnB9OzMc1Yf2H73QzozRArqVtCuH/Eh8UmtHzn2DwKXo1Lmj2n9t8/RoWcTM1kdUzo00fhkhITtXBZtmS96U73GyZ2hpOXH+52Rs4z7rPregzXH2MN3SvTNmsJPLJiYzhzIiKqOvdJ05gx4T/FseoUWzQe1FjvTEW4cE4oy1e9OL0ccxUtIcSu6ZqiYdHaziIHGVNe8/OW3BFn7yvIvFTE2ilzWIgrY+C7wxO/m/ZJi2bDlhH3j5iUVhrryRTogN74zJ02z1rjHB1LS7Jzoj9j7ZXqPHYkcoDdjfAkAZyPxOlk6MupmrjmWFXhNyVEZE5WkOX4F48aGfxAbk2HTtdbfhEExSsGQZQjNe8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a07da356-ab8d-495e-85d7-08dcd7accd4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2024 06:40:35.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZGh7Vr80Weh/yXAbt4s6sji/Bu5iA0uxnzQ7zhUjqSvTdP73obwG9DuPFA0mnCYGgBM08CVf0tGQjzGgpuwR4WZHeD09W6OvooS8kNPyYaVepjtRHYm+PFUPjDKPSrp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_05,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409180038
X-Proofpoint-ORIG-GUID: xfenGbdDJPOxRUlTafojcvwTqFF2oqzr
X-Proofpoint-GUID: xfenGbdDJPOxRUlTafojcvwTqFF2oqzr

SSBoYXZlIHNlbnQgYSBWNSB2ZXJzaW9uIGFkZHJlc3NpbmcgdGhlIHdhcm5pbmdzLiBJIGJlbGll
dmUgdGhpcyByZXF1aXJlcyBhIG5ldyBSQiBhcyB0aGUgY29kZSBoYXMgY2hhbmdlZCAoZXZlbiB0
aG91Z2ggdHJpdmlhbCkuIENvdWxkIHlvdSBwbGVhc2UgcmV2aWV3IHRoaXMuDQoNClRoYW5rcywN
CkdhdXRoYW0uDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb3NlcGggUWkg
PGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJl
ciAxOCwgMjAyNCA3OjI3IEFNDQpUbzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0
aW9uLm9yZz47IEdhdXRoYW0gQW5hbnRoYWtyaXNobmEgPGdhdXRoYW0uYW5hbnRoYWtyaXNobmFA
b3JhY2xlLmNvbT4NCkNjOiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+OyBSYWpl
c2ggU2l2YXJhbWFzdWJyYW1hbmlvbSA8cmFqZXNoLnNpdmFyYW1hc3VicmFtYW5pb21Ab3JhY2xl
LmNvbT47IG9jZnMyLWRldmVsQGxpc3RzLmxpbnV4LmRldjsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSCBSRkMgVjQgMS8xXSBvY2ZzMjogcmVzZXJ2ZSBz
cGFjZSBmb3IgaW5saW5lIHhhdHRyIGJlZm9yZSBhdHRhY2hpbmcgcmVmbGluayB0cmVlDQoNCg0K
DQpPbiA5LzE3LzI0IDEyOjE2IEFNLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0KPiBPbiBUaHUsIDEy
IFNlcCAyMDI0IDA2OjQ3OjIwICswMDAwIEdhdXRoYW0gQW5hbnRoYWtyaXNobmEgPGdhdXRoYW0u
YW5hbnRoYWtyaXNobmFAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPj4gT25lIG9mIG91ciBjdXN0
b21lcnMgcmVwb3J0ZWQgYSBjcmFzaCBhbmQgYSBjb3JydXB0ZWQgb2NmczIgZmlsZXN5c3RlbS4N
Cj4+ICsrKyBiL2ZzL29jZnMyL3JlZmNvdW50dHJlZS5jDQo+PiBAQCAtMjUsNiArMjUsNyBAQA0K
Pj4gICNpbmNsdWRlICJuYW1laS5oIg0KPj4gICNpbmNsdWRlICJvY2ZzMl90cmFjZS5oIg0KPj4g
ICNpbmNsdWRlICJmaWxlLmgiDQo+PiArI2luY2x1ZGUgInN5bWxpbmsuaCINCj4+ICANCj4+ICAj
aW5jbHVkZSA8bGludXgvYmlvLmg+DQo+PiAgI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPg0KPj4g
QEAgLTQxNTUsOCArNDE1Niw5IEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9yZWZsaW5rKHN0cnVjdCBk
ZW50cnkgKm9sZF9kZW50cnksDQo+PiAgCWludCByZXQ7DQo+PiAgCXN0cnVjdCBpbm9kZSAqaW5v
ZGUgPSBkX2lub2RlKG9sZF9kZW50cnkpOw0KPj4gIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKm5ld19i
aCA9IE5VTEw7DQo+PiArCXN0cnVjdCBvY2ZzMl9pbm9kZV9pbmZvICpvaSA9IE9DRlMyX0koaW5v
ZGUpOw0KPj4gIA0KPj4gLQlpZiAoT0NGUzJfSShpbm9kZSktPmlwX2ZsYWdzICYgT0NGUzJfSU5P
REVfU1lTVEVNX0ZJTEUpIHsNCj4+ICsJaWYgKG9pLT5pcF9mbGFncyAmIE9DRlMyX0lOT0RFX1NZ
U1RFTV9GSUxFKSB7DQo+PiAgCQlyZXQgPSAtRUlOVkFMOw0KPj4gIAkJbWxvZ19lcnJubyhyZXQp
Ow0KPj4gIAkJZ290byBvdXQ7DQo+PiBAQCAtNDE4Miw2ICs0MTg0LDI2IEBAIHN0YXRpYyBpbnQg
X19vY2ZzMl9yZWZsaW5rKHN0cnVjdCBkZW50cnkgKm9sZF9kZW50cnksDQo+PiAgCQlnb3RvIG91
dF91bmxvY2s7DQo+PiAgCX0NCj4+ICANCj4+ICsJaWYgKChvaS0+aXBfZHluX2ZlYXR1cmVzICYg
T0NGUzJfSEFTX1hBVFRSX0ZMKSAmJg0KPj4gKwkgICAgKG9pLT5pcF9keW5fZmVhdHVyZXMgJiBP
Q0ZTMl9JTkxJTkVfWEFUVFJfRkwpKSB7DQo+PiArCQkvKg0KPj4gKwkJICogQWRqdXN0IGV4dGVu
dCByZWNvcmQgY291bnQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgZXh0ZW5kZWQgYXR0cmlidXRlLg0K
Pj4gKwkJICogSW5saW5lIGRhdGEgY291bnQgaGFkIGJlZW4gYWRqdXN0ZWQgaW4gb2NmczJfZHVw
bGljYXRlX2lubGluZV9kYXRhKCkuDQo+PiArCQkgKi8NCj4+ICsJCXN0cnVjdCBvY2ZzMl9pbm9k
ZV9pbmZvICpuZXdfb2kgPSBPQ0ZTMl9JKG5ld19pbm9kZSk7DQo+PiArDQo+PiArCQlpZiAoIShu
ZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0lOTElORV9EQVRBX0ZMKSAmJg0KPj4gKwkJ
ICAgICEob2NmczJfaW5vZGVfaXNfZmFzdF9zeW1saW5rKG5ld19pbm9kZSkpKSB7DQo+PiArCQkJ
c3RydWN0IG9jZnMyX2Rpbm9kZSAqbmV3X2RpID0gbmV3X2JoLT5iX2RhdGE7DQo+PiArCQkJc3Ry
dWN0IG9jZnMyX2Rpbm9kZSAqb2xkX2RpID0gb2xkX2JoLT5iX2RhdGE7DQo+IA0KPiBmcy9vY2Zz
Mi9yZWZjb3VudHRyZWUuYzogSW4gZnVuY3Rpb24gJ19fb2NmczJfcmVmbGluayc6DQo+IGZzL29j
ZnMyL3JlZmNvdW50dHJlZS5jOjQxOTA6NTU6IGVycm9yOiBpbml0aWFsaXphdGlvbiBvZiAnc3Ry
dWN0IG9jZnMyX2Rpbm9kZSAqJyBmcm9tIGluY29tcGF0aWJsZSBwb2ludGVyIHR5cGUgJ2NoYXIg
KicgWy1XZXJyb3I9aW5jb21wYXRpYmxlLXBvaW50ZXItdHlwZXNdDQo+ICA0MTkwIHwgICAgICAg
ICAgICAgICAgICAgICAgICAgc3RydWN0IG9jZnMyX2Rpbm9kZSAqbmV3X2RpID0gbmV3X2JoLT5i
X2RhdGE7DQo+ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXn5+fn5+DQo+IGZzL29jZnMyL3JlZmNvdW50dHJlZS5jOjQxOTE6NTU6
IGVycm9yOiBpbml0aWFsaXphdGlvbiBvZiAnc3RydWN0IG9jZnMyX2Rpbm9kZSAqJyBmcm9tIGlu
Y29tcGF0aWJsZSBwb2ludGVyIHR5cGUgJ2NoYXIgKicgWy1XZXJyb3I9aW5jb21wYXRpYmxlLXBv
aW50ZXItdHlwZXNdDQo+ICA0MTkxIHwgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG9j
ZnMyX2Rpbm9kZSAqb2xkX2RpID0gb2xkX2JoLT5iX2RhdGE7DQo+ICAgICAgIHwgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+DQo+IGNj
MTogYWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzDQo+IA0KPiBJIGNvdWxkIGp1
c3QgYWRkIHRoZSB0eXBlY2FzdHMsIGJ1dCB0aGF0IGRvZXNuJ3QgZ2l2ZSBtZSBhIHRlc3RlZCBw
YXRjaCA6KA0KPiANCg0KT29wcywgc29ycnkgZm9yIG1pc3NpbmcgdGhpcyB3aGVuIHJldmlld2lu
Zy4NCkhpIEdhdXRoYW0sIGNvdWxkIHlvdSBwbGVhc2UgYWRkIHRoZSBtaXNzaW5nIHR5cGVjYXN0
cyBhbmQgY29uZmlybSBpdD8NCg0KVGhhbmtzLA0KSm9zZXBoDQo=
