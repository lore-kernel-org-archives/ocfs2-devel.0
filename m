Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C17F80B;
	Thu, 12 Sep 2024 05:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726117741; cv=fail; b=iora5ukvVV/bk6wX5FgEIh3fboBcq44bR3tYEBfqiWS0rEIkvllmyegu0es4abiwlBNZWkI65Nh94eCFuImQOBBJDD6IRvQbAF3KTDK6uZrt9LmnmnlA750Z25FzkCpVepM9g4O61Ph4usrDq2eMr5e60Pvq0L4hXHdg/WhZaes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726117741; c=relaxed/simple;
	bh=XwHB0v/7ScBDSvuhOUZEC+EROtA89aOmudvTDkLN8DM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C3iFQ7Fj8noJZ+KhAZ5ahr1aU9vmTDTKjHxnVshO3oJN0PJCXwO13Ht+ZKCdBi/nvjy/ZX7U4U9Mryr3yj1zo5od6v8xJIWg2r46yy0Ism/eZxsNGynAOhbY1rtwewnVNoMzpK7Hn+vBL1RZK1u0G8b85zkP0vYrgT+Aeprfb5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WvQcTEzZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kzleJgNQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvQcTEzZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kzleJgNQ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BMfrcF007335;
	Thu, 12 Sep 2024 05:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=XwHB0v/7ScBDSvuhOUZEC+EROtA89aOmudvTDkLN8DM=; b=
	WvQcTEzZBX6vLpSsqDYaNoL/NHxxHtOGbC79no+zLNFiYeI+FjPRwOWADnlx5F7p
	08lv6NAr12F5fue0iv/lfGghEd9R2ofqMxAdZytuY6AROR37+l0/WWmIqw+dQsj/
	hn9UL3+qJBit9wySSEwypoHcFSRNhHcggPI/kt56/DfqiKejUw7VCVOwdWv/1Sqq
	VTXfh10erc7xL9NI4FJTAkq79m8U1OzmE69E2aDl1bEt/pmCCgZZR+XkR66IffEZ
	+y2GqLtrZBb2CU54Q38+vqruWA3rkXZh7kojpomN4bh/WL51MI6uVaA/xjUh04r1
	Tj5efQvJNJO3DQz38juavQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9spre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 05:08:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48C4kXdg031622;
	Thu, 12 Sep 2024 05:08:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9b9ymj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 05:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xX9HpbbAVexDvAr6maPicloU29jUJgAYJHoB6y2VwMmZ2m9cAnXR9+Xk8lLup7ODy7Gnxu2CM2Rr/78mM+QSXqqGkTwQkLb/GmNoAS595rItlb0Y5gxMfu39qk0E1ty6W9dXWo8TzdTDREREKpFNKuHTxUC8LV1ssRB/KFxzuJsJ8I8lyHHKnfbvpN7tRLC9VOCUMNzFNP2NzMX5BV48ieLn9mnD9hJafopM/BfIDULX7/zKatvPWAU3IUNvF9fb+pl+iOhLMXRfMZqqP8QsJ8luHPuWJrdWT//63lE3cajLamsSatahiuVrre7QePMhdgpD5H3BQ0N7qyEiIAdNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwHB0v/7ScBDSvuhOUZEC+EROtA89aOmudvTDkLN8DM=;
 b=mjZ9ggc4IZDg8EqqP29l4FTYJXhHH5hIohjAq5qmJip6vqTbSh6KrcPe+BUXhgzvyrmTXg3lwds17xzOIQFiesQsRd27wBytIK10kfOsB6ytzRC40s1Mig0PxtYFy1LcFUycYQT5t1ONWv9T5FX/4PsdTwhYnbDtZKDLO91aqM6oJtMIATwUiG+l0c4ntdpEXHFykOWYL+VBVtl34CCmK2qFEJ4ZDBhPA9UxXCxgXZzwgeJiw1yrGH7LJSA73tMTCTBH1oNKFXCeoR8dwIaSEPs0toC5+P2YmPU+DDSIvNvET3oy1vCGPIjYwiUsRV1L8dzkdBz169FepEj+2xvIYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwHB0v/7ScBDSvuhOUZEC+EROtA89aOmudvTDkLN8DM=;
 b=kzleJgNQqYwagVvL7e3WupjwqWMQHfjaxwpdmT9Xc28aAsSNW7QDyIqi9UXYQQkB1TSVyEkSsGmrf6LzDv4t6Xx9HUd2MWkHJlTBHTnJbuBZOMymuzxM6DGZte8W65Dgy3vXi7zOxmJwlekFMJe/ha+kgqVq0M/0SWvTwK8zt/w=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 IA1PR10MB6687.namprd10.prod.outlook.com (2603:10b6:208:419::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.17; Thu, 12 Sep 2024 05:08:50 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 05:08:41 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC V2 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC V2 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbBMHgUCu8aJ1f3kmZhWF/HpIqNLJTgXGAgAAYfUA=
Date: Thu, 12 Sep 2024 05:08:41 +0000
Message-ID:
 <DS7PR10MB487833CE179F18AAB5CFFF53F7642@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20240912031421.853017-1-gautham.ananthakrishna@oracle.com>
 <ec511307-c8ae-4551-a716-e3096ba604df@linux.alibaba.com>
In-Reply-To: <ec511307-c8ae-4551-a716-e3096ba604df@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|IA1PR10MB6687:EE_
x-ms-office365-filtering-correlation-id: e2d4e8d9-6d4f-48df-b508-08dcd2e8f7f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q0dTVVl1cDRGUnZiaXZHalVmMmJxY0x4dXRCWWJycTB4UkF0K1J3cGNGUnVa?=
 =?utf-8?B?TDhWQXpPa1RGNisyWlpqYjNxUGw0aHh1cnZockF5NjErRC9IcXlKdlhUL2Z2?=
 =?utf-8?B?TlNLeWVrd2hJdVd5eDQxUXMyVWZTU2VDUnZLQ3lqK0VxSHBwNE5FZEhXUDlu?=
 =?utf-8?B?Si8zVlZiT2pVeU9IN1J2aDlIdEJObFBvb1BpMEllbkY4eWQzS1BwU0FXcC93?=
 =?utf-8?B?LzZmMS9qY245Rkl1RlNiUEZtdlVXNE9GQjFXbHBZMUE1amh3TkV5aS9GcWdJ?=
 =?utf-8?B?MGszSk5HOWVNVzNCSlBMcjFhY0NTR1JpeVcvYndjcDBaL1Y4ZGRQQ2ZXeHh1?=
 =?utf-8?B?OFV0aVZhTVhkK0JWTnlaTGYyK2hCZ1Z2QXZwQVUrOU5ocjA3M21XSjRQUmhK?=
 =?utf-8?B?bjVYZ0VRVklZNUJPNHNKUDNwbWxRUDlTbDNMMmd2UzJqanBVNGRHeXk2SjQw?=
 =?utf-8?B?RmtudVJrb1lKMWNrTk1Ybm10RUlLckk4Tm5kd3l4dlJQTWxnbnk3bk5mOTRu?=
 =?utf-8?B?WXVraWgxa3p2QzkzRFBZZFkwUXVJQUlHZDBtRXhoZmF4dlZnVlhaYktFNU5k?=
 =?utf-8?B?R25CcHI4U1RvMVZrZ05Tb3NyUlN0QzZBa0pZNG55c2xFU0hUYXhXbUttSDFG?=
 =?utf-8?B?Skx1OGtkY2djVXBSaFpjVGRDUHFIa0N0Y0JmZGxkQUpWSzhyTGY0cTZYaWRV?=
 =?utf-8?B?RFU1dnd5NnZGTDlQd001SjlkamVMZlM0ODBPa0RkWm4rQXYwQ0RWem10YzRZ?=
 =?utf-8?B?R2lBUE14NG5Yc2RyV0pTSWVsK1VrbVBTQUNqMVRzZEoyTExJdTZ2WGYyQ29W?=
 =?utf-8?B?YkYvV1lQM3RsbnQyV1FGTW81bVo5bFJHcnh1U3RHdDhmbnVHV0tJcitXSnAx?=
 =?utf-8?B?S3BHcEZRYm1rZTcxOXFORUxYUFM5Rnd6WUpUWWJXUEcydU5PNTE5ZnF1Z2dv?=
 =?utf-8?B?N3k4TDl4bTlUU1ZkbTdGN2FmUStQVWorVExlM3Z1bHJQMWZHb3BxM1puYjVN?=
 =?utf-8?B?ZXAyZnJmSnM3Q0VYWDRlS2Y2NHlWY1lFMnBwMUllRnJHV2ZVbGZlUlM0dXM3?=
 =?utf-8?B?YlNyL3Fpb0xBSm5IdHAyTU4zZXp2ZE5VUzd6Qy9vekxOalZsREl0MkVHZ2Uw?=
 =?utf-8?B?d3pSNlhNL0ZlMjVzOEdwVXhIQ3dtcm42OFgxZ3ZKbnR5MHp4d2pIaWY0Y2dP?=
 =?utf-8?B?TkdkNU9Ud1NJcFJNblRkREpkQ3RtTVFSYjZWYndpMFZ6MWNtcHA4eGYya015?=
 =?utf-8?B?VGg0ZFVEVHRwTU4wQ25OZ09LVmVSWTRqT0Z0Q2tsNnR1dHFEbmZoR3c5M1NV?=
 =?utf-8?B?SEdaM0puM2JNZ1ZOZnppeHYxNDJWcXMrSzlpM3FVa2d0S05oOWtMbDNjVGRv?=
 =?utf-8?B?K2xZbzA3a2xab0dvUk9hZnlJQWlubVdiOEo0d2V2K09iVy8wR3ZTVDh4OXNr?=
 =?utf-8?B?VHhMUkc3N3Y2eU41TnhwR1FnYi93aTM2L1dCcjB3V0x5by9VYjlUTjA1Z0g4?=
 =?utf-8?B?WFZ4NGNkTEE3Vmwra1RQSGRCRTZLLzdvZUc4c09rTmIyU1RxQTlDVCtnaXJ2?=
 =?utf-8?B?MW1OV1JYUk96UW9hL3RtZ3RDMkhwUXQ2UHJSSHE3cUlEa3krU0JyT1FFMHBC?=
 =?utf-8?B?SmtQODZiajMxcWJhNncrVHI4aXYrZFV5ZEo4TlJVMUFmNTZGYTFGWW96dmR2?=
 =?utf-8?B?aU8wYlN5Y29EZEVpOHV5QkEreGhvL3BrNEZxOCtTYmVqdFdNVkpCNkcxZkRx?=
 =?utf-8?B?VytSSHZmV0NjN0tTcEJONDM4cEd2a1lGbm9GUU1oeUl6TUpsSUt6bU9OVnFU?=
 =?utf-8?B?OXJ3eWUzVGhNRk9BSGRXSzRic09KMDdkUWNPNS94TTRwZkRwYW9qU1hTV3dv?=
 =?utf-8?B?bHVnbVk1Z3NtNzRVVm9BRUl5NXhwbU9TbmExa2IzUjRSdVE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V2pBaVRxeDQ1cU55YVJpMFlXQUpySjBFWUc1TkQvZ2FxM0tTODVwbXFWSVV3?=
 =?utf-8?B?MmVsLzNJcnVaaFoxbEkvbFlXWlpnYjgrMi94TFphL1JaWHVFMDEwazBHTTJW?=
 =?utf-8?B?U1dzTkgrc0NLYU5rb2VoaklIM2Q0N2dTTm1pdnBOSUZ1eUFLVVd5c3ZaSnhC?=
 =?utf-8?B?dHAveTJGLyt2T0ZFZG1jRzJpMTg1NW9ZRmpNYjQyRUMvYWx0aXJNKzdpSkFJ?=
 =?utf-8?B?cFVReWlMNjU3cmQ1aHZmTzlSYTAyTnkwMjBxa3N4Sm4zRVduY1kwRU54ZWNO?=
 =?utf-8?B?ZW5IcWFxMzR1ZXd3bWY4TlRMQnkyOXlYdEN2bEt0eVF0c3BEdXYyejVYK1FU?=
 =?utf-8?B?Y2h3Nk5lYnpsc1BiUWJBcEVQY2I2dnoxL2FsNHZtK2VyOFJFaUU1Wlk5L0Zq?=
 =?utf-8?B?bVI0WjByay9nK2t1NzFtTUZSc0R4SS83L1owRUxLNlZUZWNUWldoemVsWDhG?=
 =?utf-8?B?Nk5JNTl5NmdKVVJtZUxOeEwwMjJIUW1YZVFVT25nc2tKaVZ6T3A5Y05YdUMy?=
 =?utf-8?B?VE1LMWIzSDdUVjRnTXlOeTR4c2w1L3Mramxndk9ZbXlmOGR3TEQ1NDZiRkR6?=
 =?utf-8?B?RkVCelJQMVJicFlGTkN5VWRHWkpCWFlWNy9QNVJ0MU1OdnBqaUhUMUxBOXN6?=
 =?utf-8?B?WjZTOVZ3cEdxT200L3BmMDQ5K0dQWGRTUEhqQ01EZVI3RmJmYndNb0o0UUxT?=
 =?utf-8?B?cERPdy9SS2daUFVScXpVWTJxMnhQUVdnOWt1K0NYSytjd2g1U1FpbG0xTnhJ?=
 =?utf-8?B?Z2xTMEF4aFQvbkU1eDRxTk9aemI2aDkvMC9hSjRBamJHMGFyV1ZTZDU4MXE1?=
 =?utf-8?B?MzdpcWxCQWh1dW5DTVpxSzg0bDZTTUpqdkJ4K2J0ei9RWXJQUURWSnVqTk0x?=
 =?utf-8?B?Nmg3eUNLV2UzTG4vYWpKYmE2Sm1TbTVMblkyNHVLRXBlTkpwSGEvQTFjTVQ3?=
 =?utf-8?B?WmlRNmtvZkJWb2pDZ0R5TFVDREhsMlYzeXdBN1VkOWdaQlpCU2VrTXZQck9K?=
 =?utf-8?B?YUtwbjdvdW9Ic0FjM1lLL3FlcnhPN1d2QUYyalRmZmhTYWZqd0dBOGhLZ3BT?=
 =?utf-8?B?d0huUUNacWhzdjMrRnY3cm0zYUVaMjlrYVlKY29CSWZCcDdOdjY0WUJzdWJ0?=
 =?utf-8?B?bkpSME9YRHR5K1pwd3Y2K3pHVjdGbnprMVdJZXpGeGxwaHVpNmRpc0RvazV4?=
 =?utf-8?B?KzZMNm1zWGdsOWpURE1mVU9qMDR0eXg0cEZ2UzR3cVY2cXpycFNnd2NjZFlu?=
 =?utf-8?B?dmxDODk0MVBib0lTWVE1MlZyZ1M1WTVOQXRQekZoL0ZLU01NN3A1TnYwSUtv?=
 =?utf-8?B?Wm9lSE0rQUxXNzlJS3R3d3ZhOXd5MUd4dm41U25wZTlTT0oxZjluQnhDRTZN?=
 =?utf-8?B?ckNKRFltSDJ3emNUZjZxRWp0NnYwSW4xSWhMblY3OHlEOGJVa2JkbTc1TDVr?=
 =?utf-8?B?eHZ5NDd4YmlSYW1BamZPRXB6dlZGM3dKUXpOY3M1OGZxOTZUWUc2b1Z2bkRn?=
 =?utf-8?B?WEYwU3pzMTNuN1YrdGp6L1NtaVdVNkhML3J0Z3ArNDZzbG0yTzhRR0xsOWpz?=
 =?utf-8?B?VHJuWHdIL0tsTnQ5d2M5cFRRSmFmSUpmY3JOT1IrZ3YvRnJnU0dZNCt6ZDFC?=
 =?utf-8?B?QVpuc096SjZKazUvUHFQNXBvNmo1ZTlka2I4dW1KcXRyd29mcTAveE1JMitz?=
 =?utf-8?B?eTFGV1g1L3hjU3ZsQW9LRk51Rm4vZHdQVnk4UkNuRFJ4M21mVkpjakNtNjNI?=
 =?utf-8?B?SzZ5b0MvVlNJQlpBZkJ5MlVza2hybmloWTZuRitOd0xtcldxQllRaGxWYk01?=
 =?utf-8?B?NXdCZ1d1SXp2eGhnZWVxU1l5akJZdkdDMVpSajNDUE9Ed3k5M09FMUVKeGx6?=
 =?utf-8?B?Wk1SQ2lERmxIZkFHakNKd0doNWU5bzAxeFhCanBQeXVaeVp4emxoQWhoQTZh?=
 =?utf-8?B?WENaRmY5eFlBODZlTDlnMks5cno5NGQ0RU12VVZGK0hTZyt4d2dWcUFrYk12?=
 =?utf-8?B?eDh4TmJqYmpaK0RBOWo3Vy8yQm54ZlFGbFJNVnJSN0tpN0lWaTZ2aHhFcTlz?=
 =?utf-8?B?aEo3cmhvd1JLTE5UYlJpZjZBcWpSZlV3Ym1mRTlsVnpiTGtnREFsdzhhZkNY?=
 =?utf-8?B?OVlCWXZ1WVd0dE44NmY2Tm44MlY4OVhlRWVZMGlTbXZ2NkRiVWdkdDNkVVdP?=
 =?utf-8?B?akE9PQ==?=
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
	pI6li2I0Twc42svzfm0Nxn0t8CKsfCmd2QkRkDfLb1fAQmaeOiV/yULgWcmvVa6oinSvwF5FW2yJnXMjql62nFQSHX3VR4cj1D/yv2XuLefN9LBals87FbQG/N+KkYk3ejD7yxV3tJlTDTzIXAFlpkafsgwikjsUbOKDwVOAkbOqp/2im74yYhse7cKpiaYNkzu/z0tdiUo4pdO605Guq0QPnsEnTZqmCYnNDi7q6qS4Fre/8TlH7Z6yJauqX/9NYwfGjneNg87TVFFKiI50nwIzeiO8KWf/EuagehSvvP5n8tnvZ/eArfQMVb3TrRdYRvDAh1+syS0L8F1VReORfsTY+8VJN1L/oMaLgPyLbgsd0YDXv/C+3gUSsI7pinJbmqRoBq7MbNPxesQlM9kLfrgjqNq/HnIVs1GLGzY631xVeEWdOZBa6NjKszrhwM5Jwq8XX1otMYET5VMKwKfrrr+ORe/9IXUUm3NnLzLdBjkp333fG0GGaoJiZ3Hva+Mo4l2fvwbNzpL0Y6O2UXMKVmJDx+iBuAPg3HUr4KS2Ln9X01iigYzPb54EYbFlCXJ5Y++NyZYbbz3jf5xiJtVvbCRZV48oQbCEvitSYREjtRU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d4e8d9-6d4f-48df-b508-08dcd2e8f7f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 05:08:41.3646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6j5zoPVIi/zUsEjkHQDqTGfnBu/Sm3X9tZXg0FCV++jTsZgrCsNlRynyXZLPWmQFnZfd6h4G2Kjf4XtvJHw0z4M3ufl8dzshkRkrnCJFtDhCEkiKpiUSV8vtA5/m5PN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6687
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409120036
X-Proofpoint-ORIG-GUID: -mc67OKNCqLSGfcWEDMsPUrrvnoG4KMi
X-Proofpoint-GUID: -mc67OKNCqLSGfcWEDMsPUrrvnoG4KMi

SEkgSm9zZXBoLA0KDQpBZGRyZXNzZWQgeW91ciBjb21tZW50cyBhbmQgc2VudCBWMw0KDQpUaGFu
a3MsDQpHYXV0aGFtLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9zZXBo
IFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IA0KU2VudDogVGh1cnNkYXksIFNlcHRl
bWJlciAxMiwgMjAyNCA5OjEwIEFNDQpUbzogR2F1dGhhbSBBbmFudGhha3Jpc2huYSA8Z2F1dGhh
bS5hbmFudGhha3Jpc2huYUBvcmFjbGUuY29tPg0KQ2M6IEp1bnhpYW8gQmkgPGp1bnhpYW8uYmlA
b3JhY2xlLmNvbT47IFJhamVzaCBTaXZhcmFtYXN1YnJhbWFuaW9tIDxyYWplc2guc2l2YXJhbWFz
dWJyYW1hbmlvbUBvcmFjbGUuY29tPjsgb2NmczItZGV2ZWxAbGlzdHMubGludXguZGV2OyBzdGFi
bGVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0
OiBSZTogW1BBVENIIFJGQyBWMiAxLzFdIG9jZnMyOiByZXNlcnZlIHNwYWNlIGZvciBpbmxpbmUg
eGF0dHIgYmVmb3JlIGF0dGFjaGluZyByZWZsaW5rIHRyZWUNCg0KDQoNCk9uIDkvMTIvMjQgMTE6
MTQgQU0sIEdhdXRoYW0gQW5hbnRoYWtyaXNobmEgd3JvdGU6DQo+IE9uZSBvZiBvdXIgY3VzdG9t
ZXJzIHJlcG9ydGVkIGEgY3Jhc2ggYW5kIGEgY29ycnVwdGVkIG9jZnMyIGZpbGVzeXN0ZW0uDQo+
IFRoZSBjcmFzaCB3YXMgZHVlIHRvIHRoZSBkZXRlY3Rpb24gb2YgY29ycnVwdGlvbi4gVXBvbiAN
Cj4gdHJvdWJsZXNob290aW5nLCB0aGUgZnNjayAtZm4gb3V0cHV0IHNob3dlZCB0aGUgYmVsb3cg
Y29ycnVwdGlvbg0KPiANCj4gW0VYVEVOVF9MSVNUX0ZSRUVdIEV4dGVudCBsaXN0IGluIG93bmVy
IDMzMDgwNTkwIGNsYWltcyAyMzAgYXMgdGhlIA0KPiBuZXh0IGZyZWUgY2hhaW4gcmVjb3JkLCBi
dXQgZnNjayBiZWxpZXZlcyB0aGUgbGFyZ2VzdCB2YWxpZCB2YWx1ZSBpcyANCj4gMjI3LiAgQ2xh
bXAgdGhlIG5leHQgcmVjb3JkIHZhbHVlPyBuDQo+IA0KPiBUaGUgc3RhdCBvdXRwdXQgZnJvbSB0
aGUgZGVidWdmcy5vY2ZzMiBzaG93ZWQgdGhlIGZvbGxvd2luZyBjb3JydXB0aW9uIA0KPiB3aGVy
ZSB0aGUgIk5leHQgRnJlZSBSZWM6IiBoYWQgb3ZlcnNob3QgdGhlICJDb3VudDoiIGluIHRoZSBy
b290IA0KPiBtZXRhZGF0YSBibG9jay4NCj4gDQo+ICAgICAgICAgSW5vZGU6IDMzMDgwNTkwICAg
TW9kZTogMDY0MCAgIEdlbmVyYXRpb246IDI2MTk3MTM2MjIgKDB4OWMyNWE4NTYpDQo+ICAgICAg
ICAgRlMgR2VuZXJhdGlvbjogOTA0MzA5ODMzICgweDM1ZTZhYzQ5KQ0KPiAgICAgICAgIENSQzMy
OiAwMDAwMDAwMCAgIEVDQzogMDAwMA0KPiAgICAgICAgIFR5cGU6IFJlZ3VsYXIgICBBdHRyOiAw
eDAgICBGbGFnczogVmFsaWQNCj4gICAgICAgICBEeW5hbWljIEZlYXR1cmVzOiAoMHgxNikgSGFz
WGF0dHIgSW5saW5lWGF0dHIgUmVmY291bnRlZA0KPiAgICAgICAgIEV4dGVuZGVkIEF0dHJpYnV0
ZXMgQmxvY2s6IDAgIEV4dGVuZGVkIEF0dHJpYnV0ZXMgSW5saW5lIFNpemU6IDI1Ng0KPiAgICAg
ICAgIFVzZXI6IDAgKHJvb3QpICAgR3JvdXA6IDAgKHJvb3QpICAgU2l6ZTogMjgxMzIwMzU3ODg4
DQo+ICAgICAgICAgTGlua3M6IDEgICBDbHVzdGVyczogMTQxNzM4DQo+ICAgICAgICAgY3RpbWU6
IDB4NjY5MTFiNTYgMHgzMTZlZGNiOCAtLSBGcmkgSnVsIDEyIDA2OjAyOjMwLjgyOTM0OTA0OCAy
MDI0DQo+ICAgICAgICAgYXRpbWU6IDB4NjY5MTFkNmIgMHg3ZjdhMjhkIC0tIEZyaSBKdWwgMTIg
MDY6MTE6MjMuMTMzNjY5NTE3IDIwMjQNCj4gICAgICAgICBtdGltZTogMHg2NjkxMWI1NiAweDEy
ZWQ3NWQ3IC0tIEZyaSBKdWwgMTIgMDY6MDI6MzAuMzE3NTUyMDg3IDIwMjQNCj4gICAgICAgICBk
dGltZTogMHgwIC0tIFdlZCBEZWMgMzEgMTc6MDA6MDAgMTk2OQ0KPiAgICAgICAgIFJlZmNvdW50
IEJsb2NrOiAyNzc3MzQ2DQo+ICAgICAgICAgTGFzdCBFeHRibGs6IDI4ODY5NDMgICBPcnBoYW4g
U2xvdDogMA0KPiAgICAgICAgIFN1YiBBbGxvYyBTbG90OiAwICAgU3ViIEFsbG9jIEJpdDogMTQN
Cj4gICAgICAgICBUcmVlIERlcHRoOiAxICAgQ291bnQ6IDIyNyAgIE5leHQgRnJlZSBSZWM6IDIz
MA0KPiAgICAgICAgICMjIE9mZnNldCAgICAgICAgQ2x1c3RlcnMgICAgICAgQmxvY2sjDQo+ICAg
ICAgICAgMCAgMCAgICAgICAgICAgICAyMzEwICAgICAgICAgICAyNzc2MzUxDQo+ICAgICAgICAg
MSAgMjMxMCAgICAgICAgICAyMTM5ICAgICAgICAgICAyNzc3Mzc1DQo+ICAgICAgICAgMiAgNDQ0
OSAgICAgICAgICAxMjIxICAgICAgICAgICAyNzc4Mzk5DQo+ICAgICAgICAgMyAgNTY3MCAgICAg
ICAgICA3MzEgICAgICAgICAgICAyNzc5NDIzDQo+ICAgICAgICAgNCAgNjQwMSAgICAgICAgICA1
NjYgICAgICAgICAgICAyNzgwNDQ3DQo+ICAgICAgICAgLi4uLi4uLiAgICAgICAgICAuLi4uICAg
ICAgICAgICAuLi4uLi4uDQo+ICAgICAgICAgLi4uLi4uLiAgICAgICAgICAuLi4uICAgICAgICAg
ICAuLi4uLi4uDQo+IA0KPiBUaGUgaXNzdWUgd2FzIGluIHRoZSByZWZsaW5rIHdvcmtmb3cgd2hp
bGUgcmVzZXJ2aW5nIHNwYWNlIGZvciBpbmxpbmUgeGF0dHIuDQo+IFRoZSBwcm9ibGVtYXRpYyBm
dW5jdGlvbiBpcyBvY2ZzMl9yZWZsaW5rX3hhdHRyX2lubGluZSgpLiBCeSB0aGUgdGltZSANCj4g
dGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgdGhlIHJlZmxpbmsgdHJlZSBpcyBhbHJlYWR5IHJlY3Jl
YXRlZCBhdCB0aGUgDQo+IGRlc3RpbmF0aW9uIGlub2RlIGZyb20gdGhlIHNvdXJjZSBpbm9kZS4g
QXQgdGhpcyBwb2ludCwgdGhpcyBmdW5jdGlvbiANCj4gcmVzZXJ2ZXMgc3BhY2Ugc3BhY2UgaW5s
aW5lIHhhdHRycyBhdCB0aGUgZGVzdGluYXRpb24gaW5vZGUgd2l0aG91dCANCj4gZXZlbiBjaGVj
a2luZyBpZiB0aGVyZSBpcyBzcGFjZSBhdCB0aGUgcm9vdCBtZXRhZGF0YSBibG9jay4gSXQgc2lt
cGx5IA0KPiByZWR1Y2VzIHRoZSBsX2NvdW50IGZyb20gMjQzIHRvIDIyNyB0aGVyZWJ5IG1ha2lu
ZyBzcGFjZSBvZiAyNTYgYnl0ZXMgDQo+IGZvciBpbmxpbmUgeGF0dHIgd2hlcmVhcyB0aGUgaW5v
ZGUgYWxyZWFkeSBoYXMgZXh0ZW50cyBiZXlvbmQgdGhpcyANCj4gaW5kZXggKGluIHRoaXMgY2Fz
ZSB1cHRvIDIzMCksIHRoZXJlYnkgY2F1c2luZyBjb3JydXB0aW9uLg0KPiANCj4gVGhlIGZpeCBm
b3IgdGhpcyBpcyB0byByZXNlcnZlIHNwYWNlIGZvciBpbmxpbmUgbWV0YWRhdGEgYmVmb3JlIHRo
ZSBhdCANCj4gdGhlIGRlc3RpbmF0aW9uIGlub2RlIGJlZm9yZSB0aGUgcmVmbGluayB0cmVlIGdl
dHMgcmVjcmVhdGVkLiBUaGUgDQo+IGN1c3RvbWVyIGhhcyB2ZXJpZmllZCB0aGUgZml4Lg0KPiAN
Cj4gRml4ZXM6IGVmOTYyZGYwNTdhYSAoIm9jZnMyOiB4YXR0cjogZml4IGlubGluZWQgeGF0dHIg
cmVmbGluayIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBHYXV0aGFtIEFuYW50aGFrcmlzaG5hIA0KPiA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBv
cmFjbGUuY29tPg0KPiAtLS0NCj4gIGZzL29jZnMyL3JlZmNvdW50dHJlZS5jIHwgMjYgKysrKysr
KysrKysrKysrKysrKysrKysrLS0NCj4gIGZzL29jZnMyL3hhdHRyLmMgICAgICAgIHwgMTEgKy0t
LS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvcmVmY291bnR0cmVlLmMgYi9mcy9v
Y2ZzMi9yZWZjb3VudHRyZWUuYyBpbmRleCANCj4gM2Y4MGE1NmQwZDYwLi4xZDQyN2RhMDZiZWUg
MTAwNjQ0DQo+IC0tLSBhL2ZzL29jZnMyL3JlZmNvdW50dHJlZS5jDQo+ICsrKyBiL2ZzL29jZnMy
L3JlZmNvdW50dHJlZS5jDQo+IEBAIC0yNSw2ICsyNSw3IEBADQo+ICAjaW5jbHVkZSAibmFtZWku
aCINCj4gICNpbmNsdWRlICJvY2ZzMl90cmFjZS5oIg0KPiAgI2luY2x1ZGUgImZpbGUuaCINCj4g
KyNpbmNsdWRlICJzeW1saW5rLmgiDQo+ICANCj4gICNpbmNsdWRlIDxsaW51eC9iaW8uaD4NCj4g
ICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4NCj4gQEAgLTQxNTUsOCArNDE1Niw5IEBAIHN0YXRp
YyBpbnQgX19vY2ZzMl9yZWZsaW5rKHN0cnVjdCBkZW50cnkgKm9sZF9kZW50cnksDQo+ICAJaW50
IHJldDsNCj4gIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZF9pbm9kZShvbGRfZGVudHJ5KTsNCj4g
IAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKm5ld19iaCA9IE5VTEw7DQo+ICsJc3RydWN0IG9jZnMyX2lu
b2RlX2luZm8gKm9pID0gT0NGUzJfSShpbm9kZSk7DQo+ICANCj4gLQlpZiAoT0NGUzJfSShpbm9k
ZSktPmlwX2ZsYWdzICYgT0NGUzJfSU5PREVfU1lTVEVNX0ZJTEUpIHsNCj4gKwlpZiAob2ktPmlw
X2ZsYWdzICYgT0NGUzJfSU5PREVfU1lTVEVNX0ZJTEUpIHsNCj4gIAkJcmV0ID0gLUVJTlZBTDsN
Cj4gIAkJbWxvZ19lcnJubyhyZXQpOw0KPiAgCQlnb3RvIG91dDsNCj4gQEAgLTQxODIsNiArNDE4
NCwyNiBAQCBzdGF0aWMgaW50IF9fb2NmczJfcmVmbGluayhzdHJ1Y3QgZGVudHJ5ICpvbGRfZGVu
dHJ5LA0KPiAgCQlnb3RvIG91dF91bmxvY2s7DQo+ICAJfQ0KPiAgDQo+ICsJaWYgKChvaS0+aXBf
ZHluX2ZlYXR1cmVzICYgT0NGUzJfSEFTX1hBVFRSX0ZMKSAmJg0KPiArCSAgICAob2ktPmlwX2R5
bl9mZWF0dXJlcyAmIE9DRlMyX0lOTElORV9YQVRUUl9GTCkpIHsNCj4gKwkJLyoNCj4gKwkJICog
QWRqdXN0IGV4dGVudCByZWNvcmQgY291bnQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgZXh0ZW5kZWQg
YXR0cmlidXRlLg0KPiArCQkgKiBJbmxpbmUgZGF0YSBjb3VudCBoYWQgYmVlbiBhZGp1c3RlZCBp
biBvY2ZzMl9kdXBsaWNhdGVfaW5saW5lX2RhdGEoKS4NCj4gKwkJICovDQo+ICsJCXN0cnVjdCBv
Y2ZzMl9pbm9kZV9pbmZvICpuaSA9IE9DRlMyX0kobmV3X2lub2RlKTsNCg0KQ291bGQgeW91IHBs
ZWFzZSByZW5hbWUgaXQgdG8gJ25ld19vaSc/DQpPdGhlciBsb29rcyBnb29kIHRvIG1lLg0KDQpK
b3NlcGgNCj4gKw0KPiArCQlpZiAoIShuaS0+aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5F
X0RBVEFfRkwpICYmDQo+ICsJCSAgICAhKG9jZnMyX2lub2RlX2lzX2Zhc3Rfc3ltbGluayhuZXdf
aW5vZGUpKSkgew0KPiArCQkJc3RydWN0IG9jZnMyX2Rpbm9kZSAqbmV3X2RpID0gbmV3X2JoLT5i
X2RhdGE7DQo+ICsJCQlzdHJ1Y3Qgb2NmczJfZGlub2RlICpvbGRfZGkgPSBvbGRfYmgtPmJfZGF0
YTsNCj4gKwkJCXN0cnVjdCBvY2ZzMl9leHRlbnRfbGlzdCAqZWwgPSAmbmV3X2RpLT5pZDIuaV9s
aXN0Ow0KPiArCQkJaW50IGlubGluZV9zaXplID0gbGUxNl90b19jcHUob2xkX2RpLT5pX3hhdHRy
X2lubGluZV9zaXplKTsNCj4gKw0KPiArCQkJbGUxNl9hZGRfY3B1KCZlbC0+bF9jb3VudCwgLShp
bmxpbmVfc2l6ZSAvDQo+ICsJCQkJCXNpemVvZihzdHJ1Y3Qgb2NmczJfZXh0ZW50X3JlYykpKTsN
Cj4gKwkJfQ0KPiArCX0NCj4gKw0KPiAgCXJldCA9IG9jZnMyX2NyZWF0ZV9yZWZsaW5rX25vZGUo
aW5vZGUsIG9sZF9iaCwNCj4gIAkJCQkJbmV3X2lub2RlLCBuZXdfYmgsIHByZXNlcnZlKTsNCj4g
IAlpZiAocmV0KSB7DQo+IEBAIC00MTg5LDcgKzQyMTEsNyBAQCBzdGF0aWMgaW50IF9fb2NmczJf
cmVmbGluayhzdHJ1Y3QgZGVudHJ5ICpvbGRfZGVudHJ5LA0KPiAgCQlnb3RvIGlub2RlX3VubG9j
azsNCj4gIAl9DQo+ICANCj4gLQlpZiAoT0NGUzJfSShpbm9kZSktPmlwX2R5bl9mZWF0dXJlcyAm
IE9DRlMyX0hBU19YQVRUUl9GTCkgew0KPiArCWlmIChvaS0+aXBfZHluX2ZlYXR1cmVzICYgT0NG
UzJfSEFTX1hBVFRSX0ZMKSB7DQo+ICAJCXJldCA9IG9jZnMyX3JlZmxpbmtfeGF0dHJzKGlub2Rl
LCBvbGRfYmgsDQo+ICAJCQkJCSAgIG5ld19pbm9kZSwgbmV3X2JoLA0KPiAgCQkJCQkgICBwcmVz
ZXJ2ZSk7DQo+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi94YXR0ci5jIGIvZnMvb2NmczIveGF0dHIu
YyBpbmRleCANCj4gM2I4MTIxM2VkN2I4Li5hOWY3MTZlYzg5ZTIgMTAwNjQ0DQo+IC0tLSBhL2Zz
L29jZnMyL3hhdHRyLmMNCj4gKysrIGIvZnMvb2NmczIveGF0dHIuYw0KPiBAQCAtNjUxMSwxNiAr
NjUxMSw3IEBAIHN0YXRpYyBpbnQgb2NmczJfcmVmbGlua194YXR0cl9pbmxpbmUoc3RydWN0IG9j
ZnMyX3hhdHRyX3JlZmxpbmsgKmFyZ3MpDQo+ICAJfQ0KPiAgDQo+ICAJbmV3X29pID0gT0NGUzJf
SShhcmdzLT5uZXdfaW5vZGUpOw0KPiAtCS8qDQo+IC0JICogQWRqdXN0IGV4dGVudCByZWNvcmQg
Y291bnQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgZXh0ZW5kZWQgYXR0cmlidXRlLg0KPiAtCSAqIElu
bGluZSBkYXRhIGNvdW50IGhhZCBiZWVuIGFkanVzdGVkIGluIG9jZnMyX2R1cGxpY2F0ZV9pbmxp
bmVfZGF0YSgpLg0KPiAtCSAqLw0KPiAtCWlmICghKG5ld19vaS0+aXBfZHluX2ZlYXR1cmVzICYg
T0NGUzJfSU5MSU5FX0RBVEFfRkwpICYmDQo+IC0JICAgICEob2NmczJfaW5vZGVfaXNfZmFzdF9z
eW1saW5rKGFyZ3MtPm5ld19pbm9kZSkpKSB7DQo+IC0JCXN0cnVjdCBvY2ZzMl9leHRlbnRfbGlz
dCAqZWwgPSAmbmV3X2RpLT5pZDIuaV9saXN0Ow0KPiAtCQlsZTE2X2FkZF9jcHUoJmVsLT5sX2Nv
dW50LCAtKGlubGluZV9zaXplIC8NCj4gLQkJCQkJc2l6ZW9mKHN0cnVjdCBvY2ZzMl9leHRlbnRf
cmVjKSkpOw0KPiAtCX0NCj4gKw0KPiAgCXNwaW5fbG9jaygmbmV3X29pLT5pcF9sb2NrKTsNCj4g
IAluZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyB8PSBPQ0ZTMl9IQVNfWEFUVFJfRkwgfCBPQ0ZTMl9J
TkxJTkVfWEFUVFJfRkw7DQo+ICAJbmV3X2RpLT5pX2R5bl9mZWF0dXJlcyA9IGNwdV90b19sZTE2
KG5ld19vaS0+aXBfZHluX2ZlYXR1cmVzKTsNCg0K
