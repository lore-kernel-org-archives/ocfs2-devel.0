Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72B529008C
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314979; cv=fail; b=qHGQ8Rzw9ZXozxCVnTqDMXNB6qyNHjCivW4fFogQr9T8Na/NMSx5sQnVzBFPTuDvpLZvIEEtQ86KLBbLWd4/vh0XLjPcMhbGoGDy1DNDopifL7L7MpEzGRjLPNSUqlHDQLAOl1tlI+jZnDB/ZBviGrRde0wrU1cq4HfTO41kFYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314979; c=relaxed/simple;
	bh=raUmSS3rXOHZfpvvOSNr1eI2bYjGTp43KFM/OAs4pJY=;
	h=Message-ID:Date:Subject:References:To:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qZjbHaSA6eu+Tn54w1obptWBKR2Eqcrwt47mbcE+kj3YdVsQBpBwtsbyoYC7fT1nGqQgDMt5ZjDyG9k0Pnhj+5QklSG4+oCaDwpgLeq38OReMkieP9brKScd7bYcHu7TcIxyQTFVCC+py9cwjxvrr6cNq7JfstGMqIKWOuh/PqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IcEosOVd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VU+OA7dK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcEosOVd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VU+OA7dK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AJbYe3032266
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=B/is9gj/XAzijYfFRbGMvwoCt8dBMMF6wX4Ng0Fq4fQ=; b=
	IcEosOVdunvNMNpmt3k913mwHLnDOBF0YqyAvE3b7S2qtZAWCj+utJvKI765Z8A1
	N3ndiRr1FJo4cGIotcQGBqILopQf5DBhNWJ8KBjubqd7tfwJKkM0siiBdRrdBtAD
	PfbmQUMQtihmUXt7fUZYI9S2JQCZnVfwNeQMQoc+gpTdW6px8pjLr9hEQLybUjrq
	haZn09JAVdvJJWFgVgM42XDb6k8bSj+9asUb5JFisKJkY0qVpPkkw67iOfJeDlzQ
	pPxk+YhcVvEJQTs03zHzEfzrjfcZSJ002jhOoQL/Zd56iNez4QiVRIUgzXmicqPd
	7PoieGsHU2sGjjAaTKh6zA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xma4g1cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:56:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AIYprD001830
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:56:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttycqfe2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:56:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elm/oNyMltu9Dw62QYpX4VMH65iz0iAag0JQgR8x5qx2XY+/rSaUTcrMe7puSWP1UYiFS8KvTClCBQNbhpZuopD7SMAiMaCMbRXzCdV5TTLxCAlQO+RteyqLHa3BfItUCt+2HomvhZ7sMEGY35tEEQx5BTfR2aIwUVO5tL2gPeSCduLkPHXuPnnIT+qrR7ynQsb6wbGbYO9Tnkk4tA6xcQ3YvYlteJ9Yk1U0TOFyJRNrc5hbbd0uL92UXUNCcHXEeA0np5CE5LzqwbYii+pRXn/Wn/EU0WjkVjP8Dz2yxSFVjaA86BfkBcIE/t9f+0x9UAjBMZXnidO3xPUjZK/GUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/is9gj/XAzijYfFRbGMvwoCt8dBMMF6wX4Ng0Fq4fQ=;
 b=o3tn3cv+eb2QSjJX6cqbuWiKIMVd9ntRvK5iYcX46Fkn3TmHUUg1LbTxkMXG043C/+j7TuKm2eQ3hYDGAkBJRIyIYCHUFCIXC5ujWwQsPU2NYXMgsvRzN1I2SKxP1zlRcVBTIsCTYV7mX2s74T9zAS/DSc5q8s/PR2GxYYqaPUjVpIv8HkF5YgMYdB7raTyl1MN5AuXV0oy+ocBHLQ6CNt/J/C7xnz24YGO6DtL/9YVfEneY9j5GBjYSnGBXLUhAaW953HbREMA+haYYCThlQDEs4OoX0w2nRI0u/LZsyp4LNbzujNlJcq4UBGDTUf1YA8D4XWHoSMSnwEw57u+N3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/is9gj/XAzijYfFRbGMvwoCt8dBMMF6wX4Ng0Fq4fQ=;
 b=VU+OA7dK7hmg6Cdq8muQ5DaMIPylsDMaEvf/VNlQ8n7kAK/W11JgChdpeZnH8huXmlZe0HKKQfzfQrKtVHLJQKLUHxvR6YXlpJmG5Mxw4sC+3GUtmvBe6VXiXwEK3Z/xrdZ4gxbrxe4EXSKEVxi5mDoXAKvBRznUpW0O5Tx3pA4=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 SJ0PR10MB6376.namprd10.prod.outlook.com (2603:10b6:a03:485::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Thu, 10 Apr
 2025 19:56:12 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%6]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 19:56:12 +0000
Message-ID: <150746ad-32ae-415e-bf1d-6dfd195fbb65@oracle.com>
Date: Thu, 10 Apr 2025 14:56:11 -0500
User-Agent: Mozilla Thunderbird
Subject: [PATCH] ocfs2: fix panic in failed foilio allocation
References: <20250408135904.52237-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: ocfs2-devel@lists.linux.dev
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250408135904.52237-1-mark.tinguely@oracle.com>
X-Forwarded-Message-Id: <20250408135904.52237-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:208:52f::19) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|SJ0PR10MB6376:EE_
X-MS-Office365-Filtering-Correlation-Id: c0169c23-442b-413c-ba15-08dd7869bee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODQwTjlqZEUrYXVZdTgxbnBoa2F2cHQvNXUxUElTUVhqdVM5ZlZtTU5mc1Qz?=
 =?utf-8?B?SDJUVU55THROOE1ZeUh1ajJRSHo5QytvVGd6MWtQRGdKeWo2SFhQR2xERTZK?=
 =?utf-8?B?enNIbVRKWEw0OEg5VTFQWlZyRzR1b3NjRWwvVXJ1dG84UnE4ZU1sVnJvRGxZ?=
 =?utf-8?B?dXJQbmUrazBWMWEraFBwMW8vallILytOaE1tMzZrK082ajcwRGszNVJJaDJB?=
 =?utf-8?B?eW5lVFJsNi9mTlBsOWhjVVEvTTl2UUR3RmlpOG9mUEZWSlJMcUJMSEgveWN3?=
 =?utf-8?B?L3dVdEVucHFpVFBBcUlSemlSanhPWm9ITkllVDhOM2gxL2tLeWcyaXBpUGdx?=
 =?utf-8?B?OGNzeXZYR2tjRnZCT0wwSGhCRkJmOHBrOUwzdkpOMUVLVE5CVHFyNmJ4VTlm?=
 =?utf-8?B?aHBmYlRXa1NKRkhFb1RKN2RWZWJBSW55dWRib05lNXdYeE1UM291Z1Vua3FY?=
 =?utf-8?B?MmxqTkpWVHNDTmoyYVBWV1ArU3djeG5wOUpmNjBibWhXN2drZDVadFZBMHYw?=
 =?utf-8?B?ci9SbHlmcnBnejVEY3A0bFJ1QlBwOGlIQ2c1ZVBiOEJhVVBBSHZKbjNGb1p0?=
 =?utf-8?B?MHMyTTh2bkJ1SjBwSmg0Y0w3RG9zNUtJWElwb2hDUUNLVnpPNFcvUG9JZ3Bz?=
 =?utf-8?B?ZVRDY0drcnUwYkljVVhuM1RxR3B4eE1mbThMM2d1Z0dIdi9TNjh0K0hMZEpU?=
 =?utf-8?B?RXdqVEJzZjJVWlZDeUdNNmo0b0U1R0NmN0l4TmdHRmYxaWd0WTZXSFRtRDNz?=
 =?utf-8?B?ODBUR2ZWZHB0YVZwVndTdnZ1c1lPMVMxek9FdmpndHpaa0RDdWNSNTdNb0Vl?=
 =?utf-8?B?NUJoMy9qQ1lVMmVhSnlmeGFFY0poZHNnanpPQkxzV01waVZ3VllmbjBBaDQ4?=
 =?utf-8?B?RVYxUXhkNUFCS01RWUI4OUNLdnNVK1pvN2MyaVV4d1JQdks2RFVpc052dk9k?=
 =?utf-8?B?L2lzRWdLekJNZ2J5blAvUSs4eTJxdzc0eEszVGplTit2NzEvZHUwa2I3bW8y?=
 =?utf-8?B?SEhMb2RKT1MrNlVPWkc1UkJrVGRScTZqc2Zsdi96bnc5WTA3N3VVbitVdTNk?=
 =?utf-8?B?UTkvOGJvblNnRW5EMURqNUZZWlB4V1VQRmRRUGVYZjZtdkdVc2F0TjZqckJI?=
 =?utf-8?B?cjc3WUllbmVTOWVoeWJ3cERPVHFJSWlVSlVMRWVTU2hzSVEvTk1wK2ZuU3Q4?=
 =?utf-8?B?RS81VUczR083c0tqSW1xSWg0QW16eHF2U2xMV00wWC85Uk1xQ1Z6Wkl5MjRY?=
 =?utf-8?B?am43VW45Q3c5djBabTRHUWhBSERPZll0a05mSXVaQWJmbDE4QjRocjJTUGJY?=
 =?utf-8?B?WWxUNlVZaHNRQzJqRU1sZml6ZFB6V0YvMlFYMHlIa2w3Mitsck12TlBFOER4?=
 =?utf-8?B?YkVoRm15TVV6Z0ZQb0Q1b1RMRVhQYW10RDkyVVNURldvUi9SL0J5ZFZ1elB0?=
 =?utf-8?B?SSt5RDVqS1ovU242VVBra0hKQjh1VlVwTGE5NTZLcEJ2cXZQckg3eVN1Mzhv?=
 =?utf-8?B?R2ROU3dxWjB3N0xTSW9zRzZUeFM2Ym5KSXpXcGhJNGRZQnY1MjhaWlU3TmpS?=
 =?utf-8?B?K2lpU1pHR1lObWpIZjh3VGV5cG1reVlXY0xJL21NbUdYbnQyQWlKcUx3TXNL?=
 =?utf-8?B?WFVCSDBVUjdzcjQxWlpEV0l4SXIxV0lLRzI1dWNDbUNmSklNSmJqODJOeUtp?=
 =?utf-8?B?d0IyZkxCNE5ld3dpY09tQ0tLdEFzRmhPeGdWUVFGK1JrT3M1T2VmWXN0c0NE?=
 =?utf-8?B?dzFCampYTk0yMktlOUNCdHlndUdkdU51ZWhiZW1VTjFjMk8zVno1M2FadGFV?=
 =?utf-8?B?ZmI3Zi8wRllJQ08zSFY5YSs0bnU2RzcyT2Z0YjV4UHpqYnpTTnAzbDFxZmll?=
 =?utf-8?Q?FP7VWqIhaVq/W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUd1K3JRRVMzRW8zMkNWQmlpMEJmM1d1MkNDeW1JOTdscG1jWG1PVlgyQldR?=
 =?utf-8?B?eG5HQm85cTZPd00vUUVVQ0YwbmN0ZEtndjdoLzNjSDRFbEEyVUZtNDVLWjZ4?=
 =?utf-8?B?cFlRMUhyMW5yZyszeHhkRlZmMVh3Q2lOb2hvV0ZzZnRHTGZBN3F0U0xLLzBG?=
 =?utf-8?B?b3VPQTJpaDB0Q2hKWjVwNUxlc1dCN3htcWtsNnE0bW5QR2dGWTlhc29kMVIv?=
 =?utf-8?B?TDFDZlFRZkYrS3FNYS9CQkN3ZnVnZ0ZQK1RrY1JROTlHRUpPM285a1l6c3By?=
 =?utf-8?B?TUdGNitTWXJXUEdQL3REU0cweENJcUFWNjVvbnNJSk9QRkl3dFVLR2x2UlVO?=
 =?utf-8?B?WmoyUnNMNDJYcm51M2ZIVjcrUkZ6K2tIZXlhUEx2RVMzSlpWb1VIZ3RVVkRo?=
 =?utf-8?B?VjQvSThvNS95V05seVNON0JPTkJUcXZmUTVYTHBhL1pqZXdRU1cvalFIUWtu?=
 =?utf-8?B?U0dvOVBNMDdXdy9YK1hjb1hyQjByVlAxTzVHZktqZUkyVU9Bajg1OGhPcGx2?=
 =?utf-8?B?a0VJazBOUXpJcW9JVE41ZzhRMDRJWXBkRS9rU29ZcUhVMTlWUUtXamtEV2k3?=
 =?utf-8?B?MTkrZUFLTnhrL0psUVhjOUxxWGNDWDF3Z3B1WTFOam9PUnJ4SWR6VjhBemxV?=
 =?utf-8?B?cFVUOGc5UmJvcERwdUl5cWVma3diZi9BakZCWkxGMmdHTDArZXdCZnM3Z0tw?=
 =?utf-8?B?cFRCZzRkUkVWeUgyT1c5RmNBZmpyTTNiZnJaOHdDMjJXL3REeGVmVkUwWGVX?=
 =?utf-8?B?a2hKemJwOHZSR2JwWG1VUVhuM29hNlZZV1VkZlp2RFJweGU3a25hQ2hld2xU?=
 =?utf-8?B?K0ZidCtjU2NIYkhPRFhkcFNUeXhhdWprK0N4NHdNbzRHWW9wOVI3ZW42THdm?=
 =?utf-8?B?RTI0ZFZ6elJ0UWpNZEZpMm53YXVzMG9ocnhoNnhHbkdIMzRXTm5vRkJ2N0pR?=
 =?utf-8?B?dlZ5MEdMaVI5SUI1eWs0Z3dFS0VYZ3FvWmRyc3A5ejBTQUJLV2xEd3l5SzQr?=
 =?utf-8?B?Q3crcEF2clljNkF3Rk9SR1ZrZEdhK0J0NmZGL1QvRWZrRWM3WHRKOTFuMyto?=
 =?utf-8?B?NWcyK0ZZR3BEWm9XVnErZnFXcW9iekJId0JGcFloMkJpbUxnRE5hRERkejNP?=
 =?utf-8?B?SUxOakJvVG1yVG5mNkFFdXVWZHhCMnphcUd0cXJoQUd4c1RNR3NocUJGUjY0?=
 =?utf-8?B?MVpYYzV0Z0dyaXFMN0ZyUVZRdTBBZXBvTjhud2Rkb0REVGUvLys3WXg5bjZB?=
 =?utf-8?B?MnU2MjBoTlZqZHZWNWFYZm5YcjVLMFFvcWpUU01UWmVMMFJlMFJLRkVDbVlr?=
 =?utf-8?B?dW1ySFRHbEtZeGh3VmJBcEhLcUF0OU11QkhSZmtOdmJIMlBJSjd3ajVWZU9Z?=
 =?utf-8?B?bTl1VzQ5a3NnaWFYRnJDKzVxbEIzZ2hhL044MzBJME5aRFJ4cXZBSk45dWZY?=
 =?utf-8?B?TkFJQmFpRnB5bkRpOFptTFF3V1VvUFVIR0hhMmpaalEvbEx5R0FackUybG13?=
 =?utf-8?B?RkRjdFpQQmZjTnJxMnFtMm1uQzhzME05b3pOVXlmNnZTeVJpZkd3cG4wTmtQ?=
 =?utf-8?B?cEFyYXMyQjdVVnB1Z3MyNXp2eWRmUk4vRXFMN0lXV2dEZ2F0c3BNbVpRVndq?=
 =?utf-8?B?TTh4bWRJdHNobnlrUnp5OWkrSExXbDdHRjV2ek5JdlEzV0lxZm83YklRUkZH?=
 =?utf-8?B?V1EzbjllSURrbitQZ0t6Ymk2UmNsNy94MkU5WHlGSEVxMys2TWtoV0Y1TXJX?=
 =?utf-8?B?c3BpYU5zOCtqcFJnMEVDVmFJNmtJN2g2YjBlR2YxNnppcHBjTjhQTysxQUEx?=
 =?utf-8?B?TmJDYnVBZzFRb0hpdklmQTJ6UjFTa2JlelpLa3lzWitYdHp3eFNITE1sdytR?=
 =?utf-8?B?VGZoTVB5blg1Wm96STh1SUFYcm1WVVZ1Nm5HZGtleTdGZ2xCZFZaZUkybGE1?=
 =?utf-8?B?VG40eEdIVGU4bTN5S1VFTGpEa0dWWVNqa0pwbU1KQVNiOGdBSEJmR2dvRllk?=
 =?utf-8?B?aXNIQmk4enVmTnpGVjhNdWQwVFJxSFE1Q1ptYjIzWXR6NUx1cEJIM2RWdEtn?=
 =?utf-8?B?eHcwbEwvZ1lSUmNJVE1rUlQ1SytuMkxRVnNLYUJPdWZXQnBJK0RNeEdIZkJx?=
 =?utf-8?B?a3JXVzZPRGdVMTE0UUY2VlpvZ1VweWE2SDhWWXQyc3p2Wnl3ajc5NVRjSVZr?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sI4N3mJ8cbANhY8DqXKBy/0o8WtDT3EuRW0bl8crwowroJWBNMVqRIyMuLzE17RnJBjYY+CKbFnVYgFp+DTp9dQdtM7wMVAGB7snGLQfm8SP8RRY0DBoy5Vw7s+4vNgecS1xIN5CnTEiD9YNxeFNmUCE7fht06icy72xYPIsNntApyAveeD/Dh9P5pShFn9Ix10h7Xdz8qADJDrL1NI0cjtuJ6z+qDFd2fjZjnGJJbDPTwmW2xqbRvB2OkMJZxl0gqDUDILVOdqtV+acbwm/IfyZgGBehwM4WqiFOFi/G1S+QDcmORwKfyGbuf00jfAsnBMK9W6HZqn+Ak7XMZEZ7SLzQyTk749+ufgiSa94hAuHXFjSxPffk4MQAfW9SzNiUiC4kAXOJKdFM51yrvonFNnVLTzn3WEvKUZ9syUqWQ08u8Vqc1w/pZwhEH2PjP/rqagsadrIDJ1/wWycuHEDYqqpSP31PdEvK03D+Hat0kirRaXQ6xMdX8hiOH5Ty3YnH1syKaDxNjEalVAYiPBGkTirsHPNiox4m9GgoQwYYzZGq307aGzlKyGnwvVVhJx9p1ju/idlW5NNeU2TR4WMM8irN58RRP4A9/iJ+uG3Nfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0169c23-442b-413c-ba15-08dd7869bee4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 19:56:12.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4psHG27jryAqTRjDycBv2ldx9GtRlmEfI9I7ZDXkDtMkTOxxvn21uavdhlkEAVw90OLV5w1Mk34SfMbMKuLhUsZCrGaRtn6BW3cwVJOPIIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6376
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100144
X-Proofpoint-GUID: oscYGxhON6FCeZVZkOjV4Xt9--_j5JA6
X-Proofpoint-ORIG-GUID: oscYGxhON6FCeZVZkOjV4Xt9--_j5JA6

In commit 7e119cff9d0a, "ocfs2: convert w_pages to w_folios" the
chunk page allocations became order 0 folio allocations. If an
allocation failed, the folio array entry should be NULL so the
error path can skip the entry. In the port it is -ENOMEM and
the error path panics trying to free this bad value.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Cc: stable@vger.kernel.org
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
---
  fs/ocfs2/aops.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 40b6bce12951..89aadc6cdd87 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct 
address_space *mapping,
  			if (IS_ERR(wc->w_folios[i])) {
  				ret = PTR_ERR(wc->w_folios[i]);
  				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
  				goto out;
  			}
  		}
-- 
2.39.5 (Apple Git-154)

