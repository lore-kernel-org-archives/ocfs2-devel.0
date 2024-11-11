Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A5E146D7F;
	Mon, 11 Nov 2024 07:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731308660; cv=fail; b=J0uXw1bspQ7ZkyCXsPUmuQVtVpm+FPF6RhALOm+5i2ggVsLHP6cdBijPrUhJkx3+NaSuKpN3HfkgVu9CqhFbwDRu2ZgDkwjoFWWEKdMTjsKu3iK6hJ7D753gKmXlMI/Qm9G2QmI4De09uRVDG/EPDcINsADtVM+/2jLnj+hBal8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731308660; c=relaxed/simple;
	bh=PK24hAbXIRSLn+QPFF+as7A0Ge+fYTbCWuT+hAu4WIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bnE0LFUgNrhjMCJACsOonhDTtLl5nD6uI/fGomT6+OzFE9R/ES7sQYQ8NxnldaNPZwboGRk9EniO62WcnGeeYzviUgxXWm3mS2r09SffZYcspnxu8RDviZ8WIaus+qZNZMvQJCOBq6y2x5h9Z96DsQGKIFe5HKYLPydw7oi6AUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ELUjCLgi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N0Mrxb1S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ELUjCLgi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N0Mrxb1S"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB6u3wR007990;
	Mon, 11 Nov 2024 07:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PK24hAbXIRSLn+QPFF+as7A0Ge+fYTbCWuT+hAu4WIg=; b=
	ELUjCLgivGa06tgc4LyRPGGyiRrxL6i//sG+Y0OgKuu7iowslXI0/qi7dvhkd474
	gQFiR6jd9bWxxs9rS8J3TcfYOt13XVJSESKdEriethpEdYNVCtIO1phVNjV/3zOo
	ACmkgBvvlDzpy4lkrMbnXl2eHGkuUC3BD0SitKSNYCFOV9uF4weubUXDwvBjZiAG
	XVSsdgp+DJbRtGNNQe+lMRAYZzR165UToTYVSAjHPGqIVkrFzbZAHCQKAE7vlvbd
	UosF9c6wtZAym2mLvdQwSeAYnA5p3SU8mVRu1mZc4gbWKyb1vAgnDww662ja5Idc
	YOny78K+IUnvvT1GkHvCkA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kbsurm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 07:04:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB64jYH024313;
	Mon, 11 Nov 2024 07:04:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66ev4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 07:04:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cj0KQKjA8co9p/QlWhpgVAaCmyHO5eWUVgBs+3j6+DjE64Fb0afaf5jWtPDOUJb8st5V/RU/8ptYVLY29jMzgBurL1OLiygWfjmL6voM6JbxGi/ZH/yR1Pyb4x3IbmIoOJju8B15PdQY0h6ggi7K4l8oo1+9nRkSvQTqPnCsHAJ4iuvt+K10ZAeuMUPYXxvG+r31KeViASSUlhocXxjjjCrD5ncO8SQTceFZG+IbxJNLP9zXBCo3b3YbyOuSJAk0hEFpzihyBoUZ+/G9BRQsf7YNpBYtGMy+Tds7ZQfKmf1cuIpHWAa9tFLUh4Eg/d/SWDcnDt/CNdfTJ9HIr4v+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PK24hAbXIRSLn+QPFF+as7A0Ge+fYTbCWuT+hAu4WIg=;
 b=OJ9yGdi343DW7+6hBGlkAflI0o16Z02jyR/DYFqpFz4/lOYFAsvD6QpLChrmY8UbJTikz/1Id8hlwS+FavC/FHHeFLFyCaczS/jJsWtzPMSE4GylEbyntP/UTpuX56nnxUWzYJWx7mKW12VqGsGPYYCT4J6smN4PsSnQ+QndBgNCQBlG4uoHLfSuXGAoUxZHP9MqPN3MPIzBcNVV4b+3VxpFxJCvJ4FakU21fGb+w+FHq7+A/sCERnAVL3ekT8rgL0M7OAQgeHud+Xo0qzu9CmwMQnnom2yymfj4zQ2zZAU3wATS5twWWc6+3F1k1IVhwwC8HMY/pVKkqX8dki7nMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PK24hAbXIRSLn+QPFF+as7A0Ge+fYTbCWuT+hAu4WIg=;
 b=N0Mrxb1SgXfFptd0OBbQNpWYUssWBdV4hVBd73tW+PVquuIFd5opjpa6/NtWVUNuXry7Y6wMPKJIrs/svgaJHt2oh8ObwTkueACBgMvg72pPhIRJ57nBfHq8Y+WRb7eCHcEfypzNddBelw89Gv5HjZC7Oo9IQhd7IrnMXcMtufE=
Received: from SN4PR10MB5800.namprd10.prod.outlook.com (2603:10b6:806:20f::19)
 by BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 07:04:09 +0000
Received: from SN4PR10MB5800.namprd10.prod.outlook.com
 ([fe80::5f15:3ed6:ec7d:1fdf]) by SN4PR10MB5800.namprd10.prod.outlook.com
 ([fe80::5f15:3ed6:ec7d:1fdf%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 07:04:03 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Thread-Topic: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Thread-Index: AQHbMhRmIl2WnC/U2kKXdnVmPLokAbKxUKaAgABa6wA=
Date: Mon, 11 Nov 2024 07:04:02 +0000
Message-ID: <72E849B5-ECE7-4304-AF90-A60784B4EEFF@oracle.com>
References: <20241108192829.58813-1-wen.gang.wang@oracle.com>
 <614f6304-f096-41f7-b0a4-05127904e601@linux.alibaba.com>
In-Reply-To: <614f6304-f096-41f7-b0a4-05127904e601@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51.11.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR10MB5800:EE_|BL3PR10MB6211:EE_
x-ms-office365-filtering-correlation-id: d5ffab79-fab3-481e-ab58-08dd021f0655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ckd1N3FaLzRreFF5NWlkR2p2dDUybWw1QWplcjFtU0YzYTZPd2tMNWdZNlJo?=
 =?utf-8?B?M3RuUmpPSm9xQXQ2bXo4TkhEUUNYbnZCN2ZhekZvdzlNVFZuTWRZbFNkeWRN?=
 =?utf-8?B?S0FEcnJHTnZ0bTFJN3k5Nlp5T2JvVXhENXRjcGZtaU50MjVjRktMSldLNmc3?=
 =?utf-8?B?SmdneUNVL2FjMnA0Q3dXUG5EK2lhcVdPbjJKYW52U1NmVHBESEN4WElhMVoy?=
 =?utf-8?B?RU1Ob0U3YzFmSUpiaFRHYldhWDZHU3ZDYzhSR25jRitZMHVPSDAyZFU0dGhZ?=
 =?utf-8?B?ZkZLbjAvaXIvV3FvMXdGeGNvY0RRSFJKZHh5OUtRQ1lXcGF0OHZLWEZha0hF?=
 =?utf-8?B?c1UxeWVxSEVzck0va0NFak56OXRDWE1KekRSMnZ6a0FQN2hQQjg0Y1NuS2xo?=
 =?utf-8?B?UzlacVN3NGdEaDE5Y2VqSU1Oc0JSQjFCTjQwaXZObVNiZ25MTFdtZERSZ0VW?=
 =?utf-8?B?S1dveHlkM1hxdFNUM2xSVjcwUWg1OFJjUTJUMHJtOFVjQ3B4WUVMVVNBby9t?=
 =?utf-8?B?SENNTk84SFdXVEhmU3RPSDFiVGJ4dTBGeTZHcFByTU1rZHFsWVNlVUVUYzZX?=
 =?utf-8?B?T1RPbmZvVDFBemxidmNPRXF5ZVB6VUdUcDJ1KzVFTXR3NEJ6dVVMMkZRUkhW?=
 =?utf-8?B?RkxMcGVFMXJNSk9nZG83b3RLU0tVZGhOdFZaSVlCa0R3QXBhZXJoejlVZVBG?=
 =?utf-8?B?cnZQMktwdjFZTjBWRythbG5rQWZJQUJQV0tUQXBiY2ZEbjNVemIvWUZrZlU3?=
 =?utf-8?B?eGUzeWRhYS96TmxUM0tSdnFMcGxQV0VPZlVwZ0dWUXdTbGkvT0VLU2M5R2pG?=
 =?utf-8?B?bU4zT0o3VngwWjhCc1hUWWJKcjQ5ZlRhQnhIb29FWXd6MTVMaUNIWGY1NWU1?=
 =?utf-8?B?aXNuUjVaN3k3TFFsZjhDVU1sSVloRms3cmpiZGErVEZMUTNrRVFMeVlwZHNO?=
 =?utf-8?B?eHljN3MwbEh5WURxL3BLdWJqM1lqVUUxY2dqcVZjN0J3eUc2blN4aGpxRHFY?=
 =?utf-8?B?cEMyenpnREtYcTdXb1VnbWdkS1dhcVBubDNzOEpFc2ZkZmZIR1N5b1hMRWJa?=
 =?utf-8?B?UUpocGNDMG9XWUI4d2NCbC9lMWR0Um9rb1YvNkRiMzZkZ2VzV1ZlVG0zdktU?=
 =?utf-8?B?N09uQkdDRzduQ3FsdzNYK0taWmZwZlI5L1dWYTFaZ2E4NDBTNzlmR1RYWGdN?=
 =?utf-8?B?Q0loNUIzckw2Q0xGTUtsSTlQV3p2QkhKd01qb2g3ekpET29sNkg3a1JqYWo1?=
 =?utf-8?B?a0hBbG1CQUZUQnN2cVlJb2Fha2cvZ29lcEo4S3pBVFQxVkxrUlp1akdpZlRE?=
 =?utf-8?B?UWhyK3VENDhBL3UveWJJbi96WWlDejg2cWt2V2JReGRmNEpkeEJSRU1TOTB3?=
 =?utf-8?B?bGc0YlVsL0FzOUZjQXk4R1Q4V3JvRGNWL3V4YUxDVmhlQmhrMGZVSy9NQ0pX?=
 =?utf-8?B?U3V6dllVZkR2Yk9iWGpaT3FtdjIyRUtDUnZqNmk4cnpydmVXTHl3V21rVzhm?=
 =?utf-8?B?MERNcWJjYXQwWTh4YStGaE5Eald3a1VmY09Pdzd3WEhoU0dQMjNZTGw3Z25j?=
 =?utf-8?B?NGdmOS85Ymt4bnVWVDVONytyT24yTmxLL1BZbWplQlJCRUlHdHdQdmVLN0ha?=
 =?utf-8?B?Q3duNnJWUnpPR0l0Ni9HQUJTRkhTMWozR3VoS3hnM3JUTmZ5Mks4SGJGQkpX?=
 =?utf-8?B?N2VoVWNpZkpVODM3MGdmdGloWkZ5TTRTOW1iZ2ZCY1ZmMDVQYTNQMFM4K1FX?=
 =?utf-8?B?QWU0OUZwQmR4cm5aaGxZblZOeEV4dHFQUFM0R2EzeEtrdkpKRHFYakFNSTVk?=
 =?utf-8?Q?wpY88ROxhIEMFQPNOupm8E+ZQrJU6dg/l599o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5800.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NERlbFhyYUVDRjd4M0FyWGhQbDV1YWEzVGdxT3ZYM3VpWUxQcEZoUGZSNVUz?=
 =?utf-8?B?bFJWaHI2cVJUMjV3YlMzY21CaEgyQnl2UVAvaFozVEtvcTk1M29Cd25lNEFx?=
 =?utf-8?B?UUlEZTFxcGFpQ21zTThHKy9yZmsrOXhIS3pNOFFrWGpxUHlocUh3VlA4MWdv?=
 =?utf-8?B?Tm1NamlkYTZ4RzJ0VkxwNENMNFF5ZXhsVDdNcUxMVzM2dGdCeEdXUkRsVTA3?=
 =?utf-8?B?WklIN3dxRGhnYWwrRTkzZnNZYml6MGszNzdwUENoWUMyc05WT25BY2lDc1Fw?=
 =?utf-8?B?VlUrczBnblhwUGlkeGsvc3MxR2tVazNRT0tHS1ZVRWdhY3lnNWhnVE9yemRJ?=
 =?utf-8?B?ZEk5cDVpOGhyZDk0eFJyVm5jUXoySlR0SksrYjlLNi9MRktNREpHc3NMbGpq?=
 =?utf-8?B?SHFGMXVMeTU1Z2I3ck1kcVpmdWcxUGE1bzZPamh3T0NVck9tSjhPbitNT25n?=
 =?utf-8?B?S3pPMzRmYmJvbDdwTXk1aDZLYU5GNUhsU0xHRVcrUUVQQVFQWXhQWm5paEIv?=
 =?utf-8?B?NU5IU1FvTSs5bzF6MDlUeHpwOGtBcFpLRlZUWkdKL3dUbUVRRXBNTDMwZTQ3?=
 =?utf-8?B?alZvMGkzbTcxR21HZE55QWFoUmhFUlZ4RDBYTUx3aUhOV2h4M2RRTHVvdDRu?=
 =?utf-8?B?SDdvdWtianlHbHgxOTllOHU0ZzR6eDhnb2VCYkk1SmdraXJQRlZpcTVMbmVh?=
 =?utf-8?B?bytqSGNGK01KWXZRMThjWHhjR2U4Y2dCZElXdGliZUp3TlU5eEFyQWVEcmpV?=
 =?utf-8?B?R2JmVmtwdDVQQU5CODNFbDE3S2RmZllkbzN6Y2k4UzBTTm04VDNSNEZxSjYx?=
 =?utf-8?B?MWVOZXVXRkNDY0hSQk1Ua3hZUTRjN0x6V2pzQjVSczFvMXhrYXVXR3gySktk?=
 =?utf-8?B?dUxRYXhBcXBhNWxwbTRBRUhKZmtHOUFoSGpwcWhhUGVZcmR5ZERRVWIyNEVw?=
 =?utf-8?B?RmZMa09jM2lTK2M5TWZEeENod29JcnlzYlRsMFRhdHVQK3MxZjJpc1RIMEZI?=
 =?utf-8?B?YzR3MzdtNGNrelovR3VoWWlRSVA4OVg2UVMxR0dURDZLNzdzcm5ERWcxZFFw?=
 =?utf-8?B?RlVuWG1yY3E2VnFaTkFLN2ZIV3BWNlVuTnNxcU9tcWZ4dXRMQ0E0THdXVTBM?=
 =?utf-8?B?RXFOYUFlWnY1RXJFT2FSdTZmZ09hd2ZBVjhseXh0M0JhOHp4VzgvY2dockl6?=
 =?utf-8?B?M25kQi9PS3lpbmJVdC9EZnBlMGtENWF0L2VCZlJWWVdUaFZsM1lyL1NMbDRH?=
 =?utf-8?B?Q3hwVE5hOHJESmhxVkNDNGZHQm55a1BQSkF6WFc1QlN6NWQ2ZnVKQWpzT2Zi?=
 =?utf-8?B?RkNrRVNTekRDT2xnRTdIK3Zxa0JGTVc0cnlHU1RHWnErdmRXSVB3RE4vdmpy?=
 =?utf-8?B?K2Y1ZWQ4Wm5zVnpoMnBRSUZBa0t0TVdSTFNtSmdQelV4NllPUXpFalB3UFkr?=
 =?utf-8?B?bFF4OGQ4RWVVdGZqLzhXbUd6TlZrQlhOV0t0UkozaEVkOEk5UXhQQ1hncHZI?=
 =?utf-8?B?Tk9ITnErUkx6L3R0OUk1RjBnK3NjMEtLaG10UFhTeHNaa3hhZ2JXd1ZVOFFh?=
 =?utf-8?B?UDNjQnBOemhvcmdycnl5T1o5NjFhNVRCTTBTWlpWeFhJMEdnM3FJR213Z3Nm?=
 =?utf-8?B?OEZpT1c2eHQ3dTJqU2U3dE9od21qeURHZ0x3SnhyR2J2MnBiNTZ0M25vTDYv?=
 =?utf-8?B?ak5lVnJ3NUpXU0E5bjJ1QzllUlhHdHZ1TTVDUkFQbGFsNFZERFlrWForV2tY?=
 =?utf-8?B?TUdXNmdwUHlkbm0wVDFYRG1BclJuSEtUN0N2ZUhpeE5mWHAwdUZCWVI5TWgx?=
 =?utf-8?B?NEZZSXN6TGNHV0VERHEyY0JtVXFGN2NoRG80ZEg3MGNDdGFldnU2elNjUEpz?=
 =?utf-8?B?dkljbW1MZXl6cy9DcFp5YW5odXl3eDBMbW9HM1RMUDV4cDhtWDFYNE1sRzVu?=
 =?utf-8?B?cFJnc0Z5NkIrRUVXU0M4WnY5d2lPK3NCN3RxVDBhZHVrNHdjcE9qRlFnQVhN?=
 =?utf-8?B?Uk9CTk0wNVFiRCtFY3pmWDhReGtQNjd6UVIxZnpnZWJoL3Bub2VpckRrZS8y?=
 =?utf-8?B?enJrelFLTDk2WkNOUm50aTNCK3lKZDNieWVkcXEyUmdDMVdPOFFqdFM3elhu?=
 =?utf-8?B?SmJZWXNTZHRmWGJaNUdsZjlOZWZqVnhxQ1lLSUlZV3M4NHNXWDJ5dzJ1VmpJ?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <415A7CBE02DD1840ADC33D684FB68AB6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8lDLYvhu3ACKUGIfmcSJ/jjV3IeA0FAaw7GHi8U3zTqTrF0L4Y6EYoQAMe5sCAn4dvG/JYlEiArKDbsfifAEJbPk2FWLW+3bTFJO11TJeDIqWEeha7ks7lbyJECGOzZSI7QWtvd/3+zhL0vJvgYuxwYofrBeguTr5TN0h233ANHMC4VCgCqAICFc7NSGcgl0oVbvXu+74WAsd+xLVWgAJraoHHS/9UxvtoQFlLlvRJfBvRZCs8Bw2/ElQrKssZi04zZgHcmQgyjlufvmbucdVvVoTVEkdl6f5yshIOUAAHQ/KBW7h92WNDcTm+LgmXMMfp7dIahuaOh2u8Fgml3hdDpa9x03eB0/OpE0NQcIq7ia4fXIuIl4S4FT+u9m056LLv/fPeJoj/0N8Ik0ofdWN1jQlnoNFQz3rmiSREQBcpUlPOPhA6mK32k8Dv54w2mZauLtXa+ka9cV8ZXbjmooSYaCy0Xubjz8Vy5S08Hh0DEgszbo6TMVRFkWOJbN9pue8iTy3Qo9bYHQWPOFlKeWISPpwgmAUMriEFNXuO46fOU5Z9nD1Fje+y1k8rpTZ5L1Xfr35YWG84bucmCg9nIVA1MZYiVKABRr+C5xQ55qy6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5800.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ffab79-fab3-481e-ab58-08dd021f0655
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 07:04:02.9664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wfha43oSREs0gkBRQBVHpSHkX/CVsWKBC+vE0/TxgsnViluI/lHyM6uPyzeVayr7hA8g9qlucCYesM7lvbCLZXt+DJOgE76I/lrbA5RMEqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_06,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411110058
X-Proofpoint-GUID: K6o-2wPCgcZzUuW0mDZgaTF3_coD4X65
X-Proofpoint-ORIG-GUID: K6o-2wPCgcZzUuW0mDZgaTF3_coD4X65

DQoNCj4gT24gTm92IDEwLCAyMDI0LCBhdCA1OjM44oCvUE0sIEpvc2VwaCBRaSA8am9zZXBoLnFp
QGxpbnV4LmFsaWJhYmEuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4gT24gMTEvOS8yNCAzOjI4
IEFNLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBUaGUgZm9sbG93aW5nIElORk8gbGV2ZWwgbWVz
c2FnZSB3YXMgc2VlbjoNCj4+IA0KPj4gc2VxX2ZpbGU6IGJ1Z2d5IC5uZXh0IGZ1bmN0aW9uIG9j
ZnMyX2RsbV9zZXFfbmV4dCBbb2NmczJdIGRpZCBub3QNCj4+IHVwZGF0ZSBwb3NpdGlvbiBpbmRl
eA0KPj4gDQo+PiBGaXg6DQo+PiBVcGRhdGEgbS0+aW5kZXggdG8gbWFrZSBzZXFfcmVhZF9pdGVy
IGhhcHB5IHRob3VnaCB0aGUgaW5kZXggaXRzIHNlbGYgbWFrZXMNCj4+IG5vIHNlbnNlIHRvIG9j
ZnMyX2RsbV9zZXFfbmV4dC4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3
ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+IGZzL29jZnMyL2RsbWdsdWUuYyB8
IDEgKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+PiANCj4+IGRpZmYgLS1n
aXQgYS9mcy9vY2ZzMi9kbG1nbHVlLmMgYi9mcy9vY2ZzMi9kbG1nbHVlLmMNCj4+IGluZGV4IDYw
ZGY1MmU0YzFmOC4uMzQ5ZDEzMTM2OWNmIDEwMDY0NA0KPj4gLS0tIGEvZnMvb2NmczIvZGxtZ2x1
ZS5jDQo+PiArKysgYi9mcy9vY2ZzMi9kbG1nbHVlLmMNCj4+IEBAIC0zMTIwLDYgKzMxMjAsNyBA
QCBzdGF0aWMgdm9pZCAqb2NmczJfZGxtX3NlcV9uZXh0KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9p
ZCAqdiwgbG9mZl90ICpwb3MpDQo+PiB9DQo+PiBzcGluX3VubG9jaygmb2NmczJfZGxtX3RyYWNr
aW5nX2xvY2spOw0KPj4gDQo+PiArIG0tPmluZGV4Kys7DQo+IA0KPiBXZSBjYW4gZGlyZWN0bHkg
dXNlICcoKnBvcykrKycgaW5zdGVhZC4NCj4gDQoNClRoZSBpbnB1dC9vdXRwdXQgInBvc+KAnSBp
bmRpY2F0ZXMgbW9yZSBhbiBvZmZzZXQgaW50byB0aGUgZmlsZS4gQWN0dWFsbHkgdGhlIG91dHB1
dCBmb3IgYW4gaXRlbSBpcyBub3QgcmVhbGx5IDEgYnl0ZSBpbiBsZW5ndGgsIHNvIGluY3JlbWVu
dGluZyB0aGUgb2Zmc2V0IGJ5IDEgc291bmRzIGEgYml0IHN0cmFuZ2UgdG8gbWUuIEluc3RlYWQg
SWYgd2UgaW5jcmVtZW50IHRoZSDigJxpbmRleOKAnSwgSXQgd291bGQgYmUgZWFzaWVyIHRvIHVu
ZGVyc3RhbmQgaXQgYXMgIGZvciBuZXh0IGl0ZW0uIFRob3VnaCB1cGRhdGluZyDigJxpbmRleOKA
nSBvciB1cGRhdGluZyDigJwqcG9z4oCdIGluc3RlYWQgbWFrZXMgbm8gZGlmZmVyZW5jZSB0byBi
aW5hcnkgcnVubmluZywgdGhlIGNvZGUgdW5kZXJzdGFuZGluZyBpcyBkaWZmZXJlbnQuICBJIGtu
b3cgb3RoZXIgc2VxX29wZXJhdGlvbnMubmV4dCBmdW5jdGlvbnMgYXJlIGRpcmVjdGx5IGluY3Jl
bWVudGluZyB0aGUg4oCcKnBvc+KAnSwgSSB0aGluayB1cGRhdGluZyDigJxpbmRleOKAnSBpcyBi
ZXR0ZXIuIFdlbGwsIGlmIHlvdSBwZXJzaXN0ICgqcG9zKSsrLCBJIHdpbGwgYWxzbyBsZXQgaXQg
Z28uDQoNClRoYW5rcywNCldlbmdhbmc=
