Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3462D7BF
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Aug 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307326; cv=fail; b=ricrTDg3OvOU0VcXnhcja/bxVdSRRe/XX7T5bShzJOAp1Nw4DKSuwgLlI092vRWyBkzlr0GPQCkIuFN/BYkuGi8+SGG08sXyH80yPxynACced1Lo8HOAlYNq/x5dbUCT4hFRl9MpYEeQBfyIz/Ww5Yf5+Py1bG1VRZJIkiQ/Rlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307326; c=relaxed/simple;
	bh=RWZR6KVaNSmzFsGv53HvS/mrxf5YvcELwSfUo6Rc4iI=;
	h=Message-ID:Date:Subject:References:To:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HoX7L6FM3csPbPxx1CaSGN6+S7EMnwx8/O8T1L4GLas10Vde2sFNUbuRrf/sHURAyM9miAEEaTDCy6xjLDR+1Do/V74rqD4w9n5q6r2dJpudccNmphJYWIP1VQZRX+tKmel3c9anG/Gm2sEmPNxyYt28kRqzjLI8LajM6taNOVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l2yOmcRO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o8fnAaqw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l2yOmcRO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o8fnAaqw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7tvXt024182;
	Wed, 27 Aug 2025 15:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qkqtF/3siNqvHr2UxPL1ASD1izNlFJ7Fb2oJDvtx23s=; b=
	l2yOmcROii82VDkAC/N3a5qQb4zTGwEkMZV3iP905yy0TqzxRhYRSOW/hz2bIQ0v
	hsISDGz9mtkJorJfMmNs+a36Vg+U+aedbLDvfz+baPgO2VNIcnTQt/JJJHk20buR
	GqQJzv41lag115M+m+49tatz+qWA7H++nr920L1d1t8WBMhZL6A1QVjqkroDiNng
	nfEW86kUO+07m3GQwFqdfgfbqtTTnN8sFgOt4GwmeYt+NPwfnp39+awT6+kFSSGp
	TJT2F74GVQDVkpCx+Mis5u5RFilI/iOidUQWhZdsL6lJ6JYKW7RkDlspD1ZBznpc
	9lC+E+E0/BwqQwYFUG9rgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t6h0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:08:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57REOYi8012229;
	Wed, 27 Aug 2025 15:08:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43arh2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:08:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAbeUjHnbOO5o+oHWqBLFUvt0+rdidn/uNxt1SUWdzueQanbBgVMGGDZwpb8RM926VobUoejRou276nu06M1kKGYt8br2gW714Yl4Krj5T/om5zEBSOeM78z8fPJg2ch4fQbHqPBgz5gD29vEJwT4MT5vCnULQOPq9BjQtil12rvCX9xiyTCBYFEmpNyR4xamYblxmaahBgu6HGjSYXzcCiGCLh9jTeUntjadS2X/643vSo+ZhMRXlDXEPfP3n9QCEQH9fCNLoBjukAW4oxD982nQceSG8vMGj8Wgy+R6RSY+gPM8i/KMyNs+b9a+Pe49NqeEwJL8APFS+4kbR7INg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkqtF/3siNqvHr2UxPL1ASD1izNlFJ7Fb2oJDvtx23s=;
 b=maks35iYV0I8oylGT/I5yjz3zlSQW7VWNOYa1CjNWqB4qf0AZekkwIVCLWdp2fypUEJSXPxbUSNFsc2UNcc5VIrAn7bLNV+dqLpWbLqvuSO+lGcMT2mzrX/m9bqNI1F6wNvaANWr0COmJWhZo7ULEEPnnfBa0UTaFLTYLgCPg+erPfes1Aw1LXvTkbLLZJKOs5YN8brycAcNWsXg/TLCIXtTsirPPUk88hgU9V+w/2/0Z0jovPJsIhyxn2PpiPS8KsqluZOsPpvW4+iNqnTJP8/9kqWX3hYAVLLM7zAC5YYe65BsqD0hQwZ9BSuL2vUXggvarzQYUexnV+uWnX7Z+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkqtF/3siNqvHr2UxPL1ASD1izNlFJ7Fb2oJDvtx23s=;
 b=o8fnAaqwymJEsa3YCqP/4ysrWP8HxWAl+dX3DeKgH183TzI0dhMumpvkiNhO7M5ETSCFJp5SaAngPeJrrZfCV5FxnFbWT91CvSJHjcDoUZ9KHi5GvDX63in4e0i6I4Np29203bFOfcO7ykiacBHs3Lw4xAbnmX9cfRBLiBPILhU=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 DS4PPFF0E76365E.namprd10.prod.outlook.com (2603:10b6:f:fc00::d57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Wed, 27 Aug
 2025 15:08:38 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 15:08:38 +0000
Message-ID: <bc1472a7-493e-4696-ba72-d6b8686bea88@oracle.com>
Date: Wed, 27 Aug 2025 10:08:35 -0500
User-Agent: Mozilla Thunderbird
Subject: [v2 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
References: <20250827145919.30162-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        Mark Fasheh <mark@fasheh.com>,
        syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com,
        Heming Zhao <heming.zhao@suse.com>
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250827145919.30162-1-mark.tinguely@oracle.com>
X-Forwarded-Message-Id: <20250827145919.30162-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0041.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::27) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|DS4PPFF0E76365E:EE_
X-MS-Office365-Filtering-Correlation-Id: a1735764-0a46-4d48-96d5-08dde57b99e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTVreGRaTm10a2Irem1NYXR0amVXZ1NOQXdIWEU5Yk5WZGlRRjZWcHQxYXZu?=
 =?utf-8?B?VG1xVUN1R2wrTnQvbDExZ0dkOUFBYVFHSGFQTXA0MEtIb3l0aGkyVDRYbm94?=
 =?utf-8?B?MmhFQXFzSTdaVUVEYmdpR09YVDdoVlhpZEpoeXZwSnlQbXdlYVVwY0d1dVI4?=
 =?utf-8?B?eUlBMnFDUnI4NitqeGRQT2lxaUpOMlJrVDNlNFNRUlpQT3QwWU04VVVCaXFj?=
 =?utf-8?B?MWZrcW9rRDlMZ045S0FWSmk3Zy9MV2dVWklyTnZqRzdORlBFRzI5dzdueWZY?=
 =?utf-8?B?aVgvaDlRMlhyQW9uN3dPV2MxYVlka05VcHQ0OUs5bDNyRmkwemRJWGtPSERh?=
 =?utf-8?B?ek82UEF3VXM5VlVlWk9PeGZJOHI2NTRLRkJ6YkN2Y1hQWGQyam9WSTNNeVVv?=
 =?utf-8?B?MlYramdVbXVTelZjOHRWeHpya1BDeFJjZmRMUVVXTzRESldKSVFvYjVqcnJZ?=
 =?utf-8?B?TzBUMlhRRXlVU1ZwbGhMaW5aZGRjMkVPc0hLYzd5anBEN1RWdmhyR1ZqemVF?=
 =?utf-8?B?blN0ZVNVdGRPS2xnVXllOTdCM2NNckZCVkI0N3Q2SjFvcVZBV1liTVhiRU1L?=
 =?utf-8?B?emNpMGVjaVFaSWRDTm50VmF0dXJvOUUzZ1FkMUwxUDRLNTNvTFpna1hZMDRx?=
 =?utf-8?B?SlkycE91ZndrbXdCa3lFRS9JT1p6ZkIvWVRTWXlHSXJMOG5OUFFOUlpwd1dZ?=
 =?utf-8?B?blZhZ0JpVmVLblg3NGRHZ3lBeVJ6MHRoSERkcURWemFmRjlod2hiMUNOY0Ft?=
 =?utf-8?B?bUdWdEZmenoyZVJacVpBekdUR3hKNzJnNFZxUU8wNFdlOEFVeEhTTjhVelJY?=
 =?utf-8?B?SmhFQVNNM2E3Rlc1UnJzdWRBR2ViZVA5NE5nSVpGcVdzV21vaG9pRzNhODlY?=
 =?utf-8?B?UFZhQ1k5cXpRTWIrTUFZZ2p6ODZSTHp5THpyUTA1ZzVZSVhVeGJCQitubzQ5?=
 =?utf-8?B?a0xqUVR6Q1RwMldKTHJ5R0FzcEhFTWE0Smtwa1pRU3hSQm54bnJYRzJPWksz?=
 =?utf-8?B?SzI3VFRlczRTbzdubm1VR0FVajNHZU1JOXdJdkpKWjN3M3N5cDVidHNvdCtQ?=
 =?utf-8?B?TVg4TnBzdzA2ei90RmlhUE1RaEJlTEpVdU8rRWpzK2hYVWJaN3lVRG1UcGtI?=
 =?utf-8?B?WHE2VVpiWmxrYWN2M1dHUFN4WHNCaVRHZkJ2REpQcjdNSkxuQjNXWUZoTDQ2?=
 =?utf-8?B?TnpLY3ptQlNCODg4L3hTcmduaVlsY2VUWWsvUXNJelAxekhzZkxZalp4K21I?=
 =?utf-8?B?MXlldDBpWmhJYitIaWwwanFNQnJTMjArazRhQkFQdU95aWkzVHNVUWNHY0lV?=
 =?utf-8?B?VEJrckxUYmxOeEVlaGNiL09lL0d0N2VLRFQ2emdKcjB2ek55MFlzMzJQaW9r?=
 =?utf-8?B?bmd4ai94WnJFUjF5MTR0NytVWjBHaGkyeXV4OEZkd3J4c3U4R2l2aTRlaTV6?=
 =?utf-8?B?M1lMZzZJb2MxN1U5UjRyT3ZFZUxldVhVOEloaHJMbnhjNk5DWVRKMEJJMkly?=
 =?utf-8?B?LzBUaWx4SjJMdUMvc2N1L0FNc3dtaW5DdHhJUmVGTW9oZ3hkcHFoYlZGM0Ri?=
 =?utf-8?B?QTJTZDFjaEJWVUFUWnl5V0orcnBMM0NTeVNqOUY2cll0NzcySTNKejNUeEkx?=
 =?utf-8?B?MGdiV3BKVzMySVlKcXljRHBPeTdCajhQcDl1enNhY1BQVFhnd1U1bjNNanRx?=
 =?utf-8?B?am5kQ0k0Q0pScTQ5aFE0QnhpZkM4Wmc3eE1YdHgxeHpHbDQ0OEQxeVV5WEhN?=
 =?utf-8?B?VU1Nc3FRUktLS1lMdHhkUFMzQ3JVVVVGZkRUTk1UcmZEdVdVanJsc0c0N1or?=
 =?utf-8?Q?8vO5it7qLy+FSPmwL2AnHFanirDSKDH5t4UV8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXdZZnplQWlwQzAva2N0KzJhN3VreTVsVTBRdGpHQnRRL2RaZFE5cnJUTFlB?=
 =?utf-8?B?dGhPME51K0FORldLd1pWajh3Ym9LQWk5Qy94K2lnVWVGdCtzOE5DN1BZV3J5?=
 =?utf-8?B?UVdrMUFKY1JJbFBmOW0vY1RoVVFGcERIbDNZRzVHV3E4MkxuOUZZNFBCaHoz?=
 =?utf-8?B?R01UNkMrYWwwNXhzSTlXYW1CRisxa0h3a0NTUm5iSXovdTZva1dtVFpVbXJT?=
 =?utf-8?B?ajdicGRFNk1RYVBCMXlrRzNkclA4N3o4Z1poZ2lYNFlUMUlFaUFRSVc3T0x4?=
 =?utf-8?B?OUZFbXUzTk5jVC9BT254OU9SZWlYbXhIY2RHTTl0a2VEYVZHa3VYNXJyQ0hX?=
 =?utf-8?B?MHBXM290L2Nhc3J6Zzlwcmd5cmVlMy9pNWo0ZW1IazNvOTBsL0FYUHdQUERi?=
 =?utf-8?B?RkthdThuYzdhUkx2TzhabC9Rbk0reTExUFJHRzhRa1RjR2FTRjFvUjVYd2Fh?=
 =?utf-8?B?WXFRNDI2aXVxN2xiRXIzOU1lZFVDMUhTaWU1aFAyYXJOTGloVklFMlVtVXRU?=
 =?utf-8?B?Zk84TmRFanNaV1BsTTJzUEFCNU9MQTVHSEZmNEd6Ynh0Z3FjelNYRmFYYW5h?=
 =?utf-8?B?WHAxREU1RDk5aEZDbDVzNmVyajA5TEtHTFc1eFFVQjZYWk0yUDVISER2bG50?=
 =?utf-8?B?Zzkxckg5aS9XWmVHUE9qZm1mVVBNOU1zQWV3UzlaWDdZVS9yMzk2eVhYUDEw?=
 =?utf-8?B?amxkeDhzN2dlK3d2Z2gxNnlLSWE3Y1dOQ1ByVVdONjZJb2lYUG1PK1R1UjEx?=
 =?utf-8?B?SC9lK2JVWnZqZ2NZbHgxVjh2YXdaYUk0N3BKZTB2eS9kQWRuTEYrMXA5UjNH?=
 =?utf-8?B?dkp2eUw3cUVWQzdVOGhaWTBscDhBYWFLeFY2bGFNL1FPQ05acU05OE5IczRS?=
 =?utf-8?B?SXEzN0Eyc1NUN0VZdzhvWitYUUppampyUndseTl3c2w2K29qbzA4c0tjRVJ1?=
 =?utf-8?B?MEhxdnZkSlJ2TWNUYWpOVkZJc1oxR3pHUlg5UDM2WldnVGRKeUtYT3BzTnls?=
 =?utf-8?B?UXM2YTRiNksrZkZ5bVdzUzlpRmk1T1dLNDhrVEt0blhqQm5nVERsU0dYQjd0?=
 =?utf-8?B?S3Ara0laa2Q3MHVkSXU0c3JPV3VKQWxvVlptRHI2aTdjTm9Bb25OY041dGhr?=
 =?utf-8?B?VWZicndUUUd3MUdZTGsxZktVbFh4Yndablg4dzBtQk1QNWJoWE1wdW5UeEVz?=
 =?utf-8?B?VVEvUUZYM0hwNi9UbkdXc0o4OGJLdk5CRFVKUnBaVlBNMDVZeFhybGRGMWVt?=
 =?utf-8?B?bENDek9BQ3I5K2tzN2xCK1ZpZHRGNFBRc0IyVmI4MmkvaGxkdHZ0a2FYcG9i?=
 =?utf-8?B?WVBIdjJYNkNudlgxVnB0YzQ3MmhrWU1lbk9XVzhVbEd6Q29yZFBZeGcvWVE1?=
 =?utf-8?B?UWVaSDZYSXJ3WU15b0NJVy8xZkZMSTBWRERUQ2hranRLWEVLTGdlWlFENlk4?=
 =?utf-8?B?Mm5UdE84QVVsUHBwN2kvR2VUcnliblBRVCtlSUFySmx6bmdRSEpJTzZaa2cv?=
 =?utf-8?B?UzJONXNKeFNWNjdqclVjb0J2YkgwN24zT2hIS24xTDNQZE9WdWZvZkFmNTk0?=
 =?utf-8?B?Wk1uTVdYdU9VRFlsL1ZNbGNobG1KdDNVdDJuNW5SQU9RL2dVVHBJcmY4SThI?=
 =?utf-8?B?cGVQd2txWjc0WnM3b1lGNEYxbENUb2srTzVObUphSmpUQi9IcnZzUE5GWEdY?=
 =?utf-8?B?LzhRdmFkcElabHlVdi8xVW5kZHIxRzlqTVF3elg2NkNFZG9oOERIa1lPZmdi?=
 =?utf-8?B?MDNxdWhCUVdQLy8rdTJnRm45L2dXWE9uYUVKSmVFdE10RmxqOTJTZkc2M2No?=
 =?utf-8?B?bFRieGxkeVZaMWw3RWUyRzNDME9udW9GRTFKZWQzczBIRENHRGk1K0Y0Q1A4?=
 =?utf-8?B?YjZMMmthWG9LZStiUHpUeWtuVHFHdVFBRTdaRjk0OSswRWpyS0pBMDNoaDFX?=
 =?utf-8?B?SFFPYzBkVGpXUlQxNGpkMzRwaHNIM0pVL1NKS2VIK3BvZnRjWDRYS1FaOTgx?=
 =?utf-8?B?eWpHbUVORC9OZXBLSTczWkNVaXpzWFZvZXNucXQ3QXM0YW91eVZXcTZqSUFX?=
 =?utf-8?B?REIzM3FnelFwdU9ZSFVocEYxU3gyaCtxcFoyejZzTG1ySEl6TlM2ei85ckg5?=
 =?utf-8?B?KzRLRTNmaDhPeGtOWk9ZSTROekZTRWFMazlNZFk0ckdRQlZuWnphb3JNOU9D?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XBru4ctu70gJtm10jxfGjv+MdSSSttkPvj4AZNm48rdzIFl7EQm47dq5XUENNMQtCfrGd0PdEAQAvxXvLtvFe+V8LQUV6FBhHaR2Vtv2twDv9VzV7njueGNN1bMLJxL0SMu2xVBQzNhVDw/i+h998zjYVJYeZUSP2+HpBfBcQZLdiU9d5TBCDTRR1m1DNx5IEHr7eRrZf5Qy6DdzJPdiR1OYrXKmaJRI6UdlKKx4meBEMGrtDAMDEc/Mir5ltMXCHu4Oiu/UCh3sWKqsxiEwCQykOptyviLwfNCcb3PlX+rnEl0KxvSyGeuvGDWqf7aAFOsiWuA2eeT67nGTOr5lkmSu8MM8tgz7Dcw0OQuk5s0H6FA6nL1UC45ZLjOmvvOmyh2woxWM/a7OyzD2lD4bqh2TPqBN59uTche3b6A9fZd2EwPogfpajw57bYkoBsErzlXHDK913RywnJ+mSo5U6Wn6+2cMuoHD5dMyJOY2M+lhyNhNRNYF+TX/rgieqimnzVCQGXRnf0v3y1Vz2QPDGvEGnW3irCmWJLcdo30ydlmcVRL7a3iimFZB6M9dAESeJ9BRXyKy4EXCPv9R5mbDyXJi3drPIs1JMxeJSnezJuI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1735764-0a46-4d48-96d5-08dde57b99e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 15:08:38.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ys+8IMIIqMvLFRdcy6HuYAoISD6SpLwcyv57qyi27TP9SmCVjEyXfwEGo32ecv/d+VLHit/l/OMyMZeAkz7gahmlqmRR4BDgWuokGZlPzUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFF0E76365E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX7XwjLhAF/+GH
 LDaXkAK8dHydOhqemjNjTe9JQJWyyr9FbO9Ruinna8jYM9CKfCViQ+TgSXSLni65HT8ZnfZUOAW
 oXwB/F3SUasJYNSqWq5iAlB3js+Rvs//6GBFNFG4Dz/XFtfBwSsZLPrM8GPqpajHx8HiRDJrD+R
 zGFfNVheXnn30s+jcSTQzqVFzANPeKgtKyEI8i+3m1DNqfqsADaGb4oSpkV4sqNtEYtQfXW48sG
 EjK/FHyHzMMBo0kP1iqnJ74dxcdIo5oywVDwBgXoc17ajGvwRfx8BsaIU4epXTrUt3bKKXWpfi0
 kBsa6UKIGYddagXbifJeaq8g1ceqg2FSan5S3pJDOuCVOxWJikuaIelfn8lMLyP4H2Won+Ah1vm
 MCPj0CvCFiUMYbrXVp/Tg6SqWhKcBg==
X-Proofpoint-ORIG-GUID: Zts_Ad00kTJOnLyEPRy1DzeUvn_BpwkW
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68af1f7b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=3FFV49VUl_jWXNJ1T2cA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: Zts_Ad00kTJOnLyEPRy1DzeUvn_BpwkW

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
Release the read semphore before calling fiemap_fill_next_extent().

Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
---
v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the 
read semaphore before calling fiemap_fill_next_extent().
Add a Closes: line
---
  fs/ocfs2/extent_map.c | 17 +++++++++++++----
  1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 930150ed5db1..c9e19ce73976 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -762,14 +762,14 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
  		goto out;
  	}
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-
  	/*
  	 * Handle inline-data and fast symlink separately.
  	 */
  	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
  	    ocfs2_inode_is_fast_symlink(inode)) {
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
  		ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, map_start);
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
  		goto out_unlock;
  	}
  @@ -780,8 +780,19 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
  	while (cpos < mapping_end && !is_last) {
  		u32 fe_flags;
+		/*
+		 * fiemap_fill_next_extent() can page fault on the user
+		 * provided fiemap_extent if called on the running mmap
+		 * executable file. The ip_alloc_sem cannot be held or
+		 * result in recursive deadlock on ip_alloc_sem and a
+		 * hung filesystem.
+		 */
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+
  		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
  						 &hole_size, &rec, &is_last);
+
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
  		if (ret) {
  			mlog_errno(ret);
  			goto out_unlock;
@@ -817,8 +828,6 @@ int ocfs2_fiemap(struct inode *inode, struct 
fiemap_extent_info *fieinfo,
  out_unlock:
  	brelse(di_bh);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
  	ocfs2_inode_unlock(inode, 0);
  out:
  -- 2.39.5 (Apple Git-154)

