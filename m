Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECB24BD03
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613083; cv=fail; b=dFCG4y0KPnJpNSagYEj2W/fZLZFcJJabPvo3s4jn1DubhSYjKI8XT2KCidA2obmOmTOUi+U9A5xhruHbA5xsL716XXAYjLEfOjtQulYMhGJHx6bGlSkheHJY6HpAGf00HovjUtab9S1ZuKXtBiaajvJZnI0yysS4xXDcenyxWlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613083; c=relaxed/simple;
	bh=MCSIE20GJJ6CQjBDKBL707LOdBlnBrIs8Oesb7Vk1HU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mn1tU8Mf3yyfN4LM7fUYv2TWchHhufIpbT6xXXzerFrSMsSwDJ7p1IPWEAvNYXquj3QpDR/0pMgdYWJbEKfhzf/pRKkLCyvYFvNz6qGYMl+8/gHQd2DSVH78Nh/AIOKfc/XaS9HSXIuohD3IcS9gAV2y2Etr7Z3yb5xosT+ewpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B0HHC1Ln; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jd1UKTmB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B0HHC1Ln";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jd1UKTmB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDixVS018500;
	Tue, 19 Aug 2025 14:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ONITRgic1b+5Y6BKOZRPvMujWhz95li+5H+Gi2p+JQs=; b=
	B0HHC1LnNkwqX9YZ/+E4fHpyPjRjbWQ5hdkKdtLl0AYBh8Od/uma/RAYkaQd1iuK
	DvUH7YbV6nEGEUKgz5jwhW+ngwXC7Ltcko4e1xhPgtIyHsxoMYvWtJcWSyMYmh+T
	wwez967FNTwknUI+ppG6VsYMl8Oir2Rg4Q2pE8GdDtRZLjsZZ28HtRUFtenr2B24
	179R95OZwmrRilHSXTJnDDuZ0Z5TdxTeoicN5KriwjZqTabKL68uzqNieSZtSobQ
	9la6omGJ8QuQP7FpilGcmmbFwamf9lrl7XkzT47PAAyFeTPraOrssWH4X9J9+ADr
	xnqFL8xKMq2DM6O4dw1GDw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48m0ybtycx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:17:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDGv0U003450;
	Tue, 19 Aug 2025 14:17:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgeagf9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:17:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7rh9vN/3BOdOKtXJKCmn9MkE7QpuHGdb/gfCU7gdoXqfBMxknuCkT3HSslDHRoGNWjD4FRkFWhVJ3i4vX4jiFMykHd6AepkT6ceRdajgEz+HpnDNC8/BuUxD+aEO2mPyHwoKi55xLdD0KO/78iqufV2sv+XUsueC/4yHHW6nXcp2u96nWHbufujv/ZVdYvTjhbXerx9GqzNNze+ZuvU31I5936uIl9R7yOfTq51MrjLMOA4lmYAKOBrPOBQqsncLtz4bMne4+3ynIP8gbAjfxGqmwb1nEZA38p9G+CEs2cMwEf9pNY43KGYih/ok+xc0xvzsc9p25ruadvPzLR6sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONITRgic1b+5Y6BKOZRPvMujWhz95li+5H+Gi2p+JQs=;
 b=qW78Yh/FEmjlvQmhFD2yhldEPWgEI6+lRVZotFep20pL9fTFHx/lI+hxqyBmG5iyAtLu3ezoItgHAPnJsJdNDWcV2Fj4H16Pw7RuJbm6+u44aE+/ljSalLJODAx7iY00gfLUCtZ7OXnDHM/vV9ftUF3cI0SBP+C8geT/BneYkXzKkDxPvbp0FM0z0/0IlkP/RPGXxDqKxpksB3fj5v27I+WkHyaFa/aisZ56KRpTQNnlmSSfjlqIgo9tFeFHPOt9J5we6ONmsRv1lg0Pr6wMSxzLwwxkohRelFi1F2AUoCR+nFLr+4KKq7nYfl3B0H3mL9+FEiKycvlae51+48T5ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONITRgic1b+5Y6BKOZRPvMujWhz95li+5H+Gi2p+JQs=;
 b=Jd1UKTmBWixADI3NxCBMRpj/nslML81yAmZHB+oXxxxlxzkkH6wDhg4RAVHnNjN0wYTvMxU7ExZdxyKAaK17+bA4IXHstb3Gf+G4idwZkyYU27LVXbIBYU+3R74fAxPYM1r8N0hwX7z/i+Y9XGVE+J+QrmtevHjief00SJMq8ik=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 14:17:43 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 14:17:43 +0000
Message-ID: <a365b3cd-b1b5-4d04-9877-129286345ce0@oracle.com>
Date: Tue, 19 Aug 2025 09:17:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH V2] ocfs2: prevent release journal inode
 after journal shutdown
To: Edward Adam Davis <eadavis@qq.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        linux-kernel@vger.kernel.org, mark@fasheh.com,
        ocfs2-devel@lists.linux.dev,
        syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
References: <tencent_5E787A6C242FE96CC89454E856EC52CEC40A@qq.com>
 <tencent_357489BEAEE4AED74CBD67D246DBD2C4C606@qq.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <tencent_357489BEAEE4AED74CBD67D246DBD2C4C606@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:510:33d::6) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c80350-e55e-4d94-00b7-08dddf2b29df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXFCcHd1UldyTUdIV01LZk9hTmNiQm41WHNUbzVyZERYRlNHRzNzOW1TUjhL?=
 =?utf-8?B?R25sR2hhSGtoWWQxUncwby9qcFBhUUJzRDlDdGk2OGdQV2EvaFQ4L25VTTdK?=
 =?utf-8?B?L3hYZm9wNU9tL20weU54R295aTFxeWMvaG5KYVgzeUh3NGJkOHhRRlZPamJT?=
 =?utf-8?B?c2dCeTR3VWNMMEdndE1sWjRsQkZ1ekFwS3creXkrUkJ4cVdLR2wrQ0xzbi92?=
 =?utf-8?B?aU5kOEFlUnJUV0JseXJiMzJhN0N6SWNJQlVzUGEra3QrSlFMRGR3cytteHRH?=
 =?utf-8?B?cHlXZ3pQUjBDSUpYNlBTM2hYZzB3d1RzV3NYZ2dFL28yTmw4VkExdndnbXBE?=
 =?utf-8?B?dEtzMmxCT3JhYnY0dW5CaUxDMjQxWHVNWVlQWTJwNEtuY0VMU0xjdlk2VU5j?=
 =?utf-8?B?L01STnM4WTVvWlhrR2dWOHB6Y0x3em1xcVRPMVh2TDNORkJ4cS9wR0RCVXFn?=
 =?utf-8?B?VW5BY3Z2bU1mT1BaTjFSVkxhY3BhWmh4cnZocktIZnZVU0NwWndMQUw2YjNM?=
 =?utf-8?B?a0xBVmxlUS9ieWduUFVmOEdyZkMyQ3o3U1cydGpxRzY3aEg5NDZWaGlKQmJo?=
 =?utf-8?B?MTVWbTlNbmU4N3JMNEFqa0s2NTVqWW1HOEVHNGc4NzFVUzc5UmlKYlM2TFlB?=
 =?utf-8?B?bmM5TmdjdHFlK2JsckFYOU0ybm9BcUQwNHJrRTEzV1AwR0xqLzVPZmk2VW1N?=
 =?utf-8?B?WDNXdDZySWZSZzZFdHJ5ay9QRm56Mms4ZktORnNLblFMbkR5RG9TeW8wRWJO?=
 =?utf-8?B?dWVhWCtpT25CRlJYZVE4YVhqRG1xWVpKaXNtUzdaMHExNVJNRnR4UGRoNHg2?=
 =?utf-8?B?ZjBFcjNSQzg5OThCUnpvWmpUaS9PUTJsNXhTOTlnNDlFbGRlVTJBeGtaT3po?=
 =?utf-8?B?bU40a0YxRjNKREx4V2o0V1cwQXhzL0dHTFdKMU01a0dvWDU5UCtzNkl3amF2?=
 =?utf-8?B?Qmx4U1RoaUphOVRmZWJTRFBBTG1xbGpJM2lFcDBzMjhWajBnZStqMyt5TzNB?=
 =?utf-8?B?NzhDaVlpSjVXT0F1cUJFYy8xQUoreS80MkRYb013YnZJMG1RWkh0Z3JrVmR5?=
 =?utf-8?B?aDhodUtXZERkWFdHbHVJYWZjVm5mOXRTemxTc2p1MXhhLzV0TmxTcGlMUXFS?=
 =?utf-8?B?bXozNWF6MUg0SXp2RG4vdm92czFWaE9PWjkxZy9IMmQ3TmtkOHFsTDJFTDNv?=
 =?utf-8?B?cmRsa0VyeUVhYXYzK3VpTTFVRy8xbElBNUN5RnQ0KzUyRmtWLzU5S25CSWxY?=
 =?utf-8?B?TURsYTVyZjBuWjVET0U1SG1HVGxTUk8ycXlibTJXY041NndrbjBJMzlJRHFQ?=
 =?utf-8?B?elFLb2w3QU9vYzNkQkNVRnQzdHFlcEpBQmUwdXVWYStiOGhMbFZ5K0V6QU5l?=
 =?utf-8?B?RlhFQkJkaDMwR2wwdEUrYnlNazNOaW94dTJVTmg3YmJaVEpHVTNTUGVUa1dk?=
 =?utf-8?B?UUJEczMvRk5EOHNuZk05TTFVbzlhSm1lczJiSE1nWHJrTGlWS1pySzE4aW0y?=
 =?utf-8?B?ZmhXTXdiZDhhcE5JV3JzTGZmZmE5dFZJL3BBZmtWNUNCS3l5YStVNWYzMmxo?=
 =?utf-8?B?dDd5ODRpazNMdTVWUDhiZXQrdGRBaUZHcWd1ZGROUWNSV0kxMjhKNnFSbDhL?=
 =?utf-8?B?d2ptS1ZEbjRJS3lSQkN3YnR3RGpER3Y0a056N0JrL0VFYmd6MkNXZi9zQThI?=
 =?utf-8?B?ekpwZlpyV2xMNHFQNS8yY3kyZmpJSCt4bW5zdkdoeU9WRFJlMVV3KzdPU1ha?=
 =?utf-8?B?SDkyOCswMlVTQzZpWjBUa2NqOXBnbXd5NTJkajZzc056R3N3NmVkTU11OEpz?=
 =?utf-8?Q?QdLZmbkouS/I7AwzuqLDB2G59fh4bnGL1CbBs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1lrUTVhQTExS3hRL1UwS21zZ3FNVWRFNjVtajZIa1ErS3kwbitQNjBPSFRP?=
 =?utf-8?B?OW5JMHczMEVmQmNvMmxxMjhJaklaU0hiSXg2YmJsMTFtZmRySjYrM2txeHY2?=
 =?utf-8?B?RURiVDVDZWQ2d3kxU1hsZ1Ewd1Y2Wkd4RnIvVnBpV0ZYaWJlMGpYRVloNS9D?=
 =?utf-8?B?ZDFmam5DWHFQTXJUTHlHdlpZV2tiUWp2ZktpblF0b0o3QVRSVVkxT29vcCtt?=
 =?utf-8?B?OUJkRWZGUjgwK010QjcrdjBIbkxEOFpLcGJXKy9jKzVqNDhkZ3VTVEI2Z2tT?=
 =?utf-8?B?QjFNeUp6TTlDWXVJMHVBSUlYeHQ0TEFyVEx5TlBYSzBTUjlGb3FEQ1NPOXVD?=
 =?utf-8?B?LzZTOGN6czg2dElWMSsxMHRCTWxJWWhtenlwbng3Q281dVZZaUE0eU00WUtI?=
 =?utf-8?B?R1djN2xlWkhLS04yOTF0bkdtVTJJTDlPUXFzUVNJd3lEU2JIY2ZYa2NyOEt1?=
 =?utf-8?B?eWdNRExpUmJMM3Q4dDh3bVZxeVFXeitEckViVGwvc3RIb2U5S1p6dXZHQXB6?=
 =?utf-8?B?S3hQOVByQ05WQUFrVDIvaTJWOThtV2xnZFd5bmJEOW12NUxQVDVML0k2Nk1X?=
 =?utf-8?B?WmRLelVTZmU4V3l0TzFPNS91emxuZUZlUmVsSjh2R1VhRGlFUDJST0tyYXhn?=
 =?utf-8?B?cFZjbVNpRmdnbkZrQ00vbHlUaEZmcWk5QmVaZG9FVU4xY3A0QVRtWFdKRnZS?=
 =?utf-8?B?QTdPdjd2NUdJU2tXVkxzYTJUOStLNitvZ2R2aTlqTUdXRUJNVlI4aXhDYWg3?=
 =?utf-8?B?Z0EzTUJML1BFQ254b0dTakdwV0Roc21qeHlhNk9lQU9HcWJ2bzNvY1pUR29H?=
 =?utf-8?B?NkVIeHlBMG5pdWt0OUJpM1FzeldjZWZoKzRjQmVQcVhYU2ZDQ1M2ZnZ2MnVh?=
 =?utf-8?B?a1JuejlpTllXRGlzbTJ2L3lWelBtSVE0NEROclRFcXFkbTAxajRMWFFwUGdi?=
 =?utf-8?B?R2dVVDhVL1AraytzWmNJK3RTV0o2QzFlRTBQZDM2OGVmN1Y5c0gxdXU2Yiti?=
 =?utf-8?B?ZVFmYzBxaENHMHFmZXhXVlBUY3BaK3B3MVhaVENKblp5bHVYV1Y2NlhNdi93?=
 =?utf-8?B?YWp1UGJIYlJCTm1OcmZjQU1oZWhrR1BEYjV3Sk0zNVVuRHE3RngvR2tnL21Q?=
 =?utf-8?B?a2s4SEpObnc2NVQzSnBMUWJ2RVVodklyZ2c1cFhPMG9DSVNUYTB4WThzMWdk?=
 =?utf-8?B?cC9QV1A4TXlCVnBwYTlObTQvaUdaM0czKyswb01QaTlwVm9ieTVMakRMbnBM?=
 =?utf-8?B?SUpSa2R3dzBPdTRGdzErZk8vNDdpSjVGaHlPZVFXNlFMOGlkVVNCR1JWTS9Y?=
 =?utf-8?B?SzRPMjJtZmdzSWdITnllbmtaU0d0RVd6M2tjY2lPM2pRQ1o3Ri94YmFOQnpV?=
 =?utf-8?B?V1VCT0wrY3RXbXJGQmdaMlhQTkpkUzd3WG5Za3BwMDBYaTZBQ2VUSnNSUlVs?=
 =?utf-8?B?bU4wZlZTNE5aVnAvTk1ISTdUOGR5QWczazZETXNqWGZnMDN4RUVWaHBUdGxa?=
 =?utf-8?B?K05FbGl6dVZvOEJ1d0dFVjgvdlFVV0NITFd5cW5lVHc5UGdEZE1OY3h6bzhG?=
 =?utf-8?B?RlB1RFQxem1zZVNua3kyclkyNzkwTUU1WUZuWm80b2ZuUk1yNnY2VDg2b3ZS?=
 =?utf-8?B?SDZ1MU1sWmRMUXBUQlV5ektkSTFxcGxBeXlGRFNsQTBvWFdNckdxZkIzRkVl?=
 =?utf-8?B?NXQzQUdqWnRtK1JrRWo1N1IvdVdOUnY3bDZJV3ZVam1vMmVtMnJtWlVhVlJy?=
 =?utf-8?B?Q0xUOFRkcDl6WVRUVmRvNEo0N1k1QUE1amdoUXhpakY2TGw2bWRDWTczYUE0?=
 =?utf-8?B?Y1kxN2NaY1ZSUWtFVVRwblVTdnF6dlFHYjQrNU82bUZZb1g4Z2RTVjMzWXJv?=
 =?utf-8?B?KzlndXY5ZytrdFIwZi92MlNuM3FPL284ZW1nNEFqdTA2cEkrS0Ywa2NUVTRy?=
 =?utf-8?B?Y3dhbndReUdiWmdnSDhsZmNUNWkzanBjYzVINGFMeGJPdnhuSGVmdWIrMm1Q?=
 =?utf-8?B?Q2VnWWp5STJmQnYzMTVkVk8ybFZFK2JRZnhBT3J0OGRNY1BWUC90YkZvQm5q?=
 =?utf-8?B?OXd6ai8ydUtXdDJNaGJ4ZU44L1VhMG1uSTF0RjRpdnBPZ3pGbTRHVkM4SGV4?=
 =?utf-8?B?S3BlaHVYaWN6MUozdXp6OFd5N1FuMFI2cGx6SHVyT3diVkNMV281MmRYeUxs?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rZ2PjG0cRTCcxY04z0reFhclxeZuoS0np9k69OFAhceZdg0xnOuVhZoo3R7b5/J5ogWa3Z/VG30SlArW73Qb2srXNrT/0MFKh7cJ61Rf2tnblmE6SESDUx+5GovdNglpzjKEkKwa4Br/a52EwuB8NeIB1lWHprRdp1keEpkgKHbZ0pcvm8odxVu48mV1QRJRTeW4U4hBFwdW5kmaH9TbcinG6prvTt8KkKWjgtI0cu8pPhUXF0RDoroPE/SpFbcNn+6vdQR4ILW7Wj+3zGM6z2iV41Lz2+li02LhR6blGhAbb2+rDmu7t6qUwDZwjOLpF1nB8Si05YIEt27VSXYWi+6C+g5zUJlwjP/aS+rwqUMej3ThIBrNfP4GWeaQVI7MUSiSSnTwbebTPSPom248ZwMFGb2HZZKgldbyyVXsxME6smVc/sWl0T/ysC/rY0q1Lz45cAAnh4Cov+5rwHWy3W6bl17dn9/5wRsIgpkvp9cQXUa8CX8FdWzbtUO5jtT5V5g3LFmpgeI301sYlPR1tF9qfDYSXeH0lBmEX42wq4xY2utYeB8odXTm4ykbdBWCKuxs8FoLPE2jwFXxcZbGQxbbFqZLsCbRADp+guJaqEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c80350-e55e-4d94-00b7-08dddf2b29df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 14:17:43.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AGubuJIyvZsK+R5tEJL8HPMxqYE0OXihB2CofINog2zGhUXsi7WnYSuLulvSB7nf5f2x3kz9Emo66TKmgUQJnjBx623RNbc2QECbB2xWzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190133
X-Authority-Analysis: v=2.4 cv=fcOty1QF c=1 sm=1 tr=0 ts=68a4878b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=dZbOZ2KzAAAA:8 a=yPCof4ZbAAAA:8 a=C2nGwJBpJOnyvZGmsfIA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: 5uQMKWGpzP3VG8LYMlgdUJ1aJbama1W6
X-Proofpoint-ORIG-GUID: 5uQMKWGpzP3VG8LYMlgdUJ1aJbama1W6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDEzMyBTYWx0ZWRfX+fOFEALXnqit
 OA3W1MgjfnnKOe3ww26bai7jHjBDkUyEG3jKchIMPr1g6MO6L2KgsQ9VtNe4twjtshGrvmO8ho7
 Op/11UuuzSnhJwTrx9NpCPixHUSBSisTJGsnqH/KeaJ4FsH3UYj/8fpd79cb7Vid/ngxavuOyAo
 FNfYO+a0q4wA2tG8JWVjuIXnavJAkMQwN/aapJyKKZdxjt3eYUzuow+m1kgDOnk/kMZcRGfDvbf
 0nbzEj55nSW6QUeAuZ2u+8sWHUB7iU0vyyFX5a+EX0RyRPYAC056OZqeRY4XT0HncCbjpi1gsGJ
 Yz0Tga9dctKRnSWILGtNLgZbCauBmsVzeQCH5WZQzMHilv9g02iKJXLlId3aRbVk/Y/6zF2jMR2
 3UuMJJctWfOUUv7u5goKTkj3dWL9yS2yHsOicEFWTiLxSEBKzzRbRlCc3dsnmSbxfPb7xi9T

On 8/19/25 8:41 AM, Edward Adam Davis wrote:
> Before calling ocfs2_delete_osb(), ocfs2_journal_shutdown() has already
> been executed in ocfs2_dismount_volume(), so osb->journal must be NULL.
> Therefore, the following calltrace will inevitably fail when it reaches
> jbd2_journal_release_jbd_inode().
> 
> ocfs2_dismount_volume()->
>    ocfs2_delete_osb()->
>      ocfs2_free_slot_info()->
>        __ocfs2_free_slot_info()->
>          evict()->
>            ocfs2_evict_inode()->
>              ocfs2_clear_inode()->
> 	      jbd2_journal_release_jbd_inode(osb->journal->j_journal,
> 
> Adding osb->journal checks will prevent null-ptr-deref during the above
> execution path.
> 
> Reported-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
> Closes: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=47d8cb2f2cc1517e515a__;!!ACWV5N9M2RV99hQ!IR4Z9VG7eJItxQAEk4-F5EMvtDaSRSvdmdcMeFjajaLLqAc2Vk9HICGKkI-geAk8gYlrJzH-UEfJuaJ2kw$
> Tested-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: Corrected typos and comments.
> 
>   fs/ocfs2/inode.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..6c4f78f473fb 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1281,6 +1281,9 @@ static void ocfs2_clear_inode(struct inode *inode)
>   	 * the journal is flushed before journal shutdown. Thus it is safe to
>   	 * have inodes get cleaned up after journal shutdown.
>   	 */
> +	if (!osb->journal)
> +		return;
> +
>   	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>   				       &oi->ip_jinode);
>   }


fixes commit da5e7c87827e8caa6a1eeec6d95dcf74ab592a01 
(v5.15-5-gda5e7c87827). Also for the stable branch?

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
