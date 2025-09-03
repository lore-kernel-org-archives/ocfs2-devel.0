Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671612030A
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Sep 2025 14:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756908237; cv=fail; b=ay9dhiU6WR1dNnH5iuiL4aVlJnA59RcUmrVwTn6ygaur8eL8cnnxW8Xm+y5TQ83q4k2dBi+PDX74yIVsdDIvwVz4hcbFnD3X2hY/yvcCjhM/+t4aVgjANOWnRUTEgltFZjFdc4FepWSRJ1zK3p4n1JSAYko0ZWVv4KW8CGKPMvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756908237; c=relaxed/simple;
	bh=9eia23YWnCTxZpZnMmcV+NqHVLl0YSairDkxcRfuwwY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DPqCttKugy0VAJyM4RYriTC/YTOYt7kqJZxQRlQqSAID8RuIxMsGcFsCD7MqtLt8QFFFiNi3moA60QHrx5kqq/BLl2Y9f0DzXkDhEgzB3CMWWbKl9xRyz2n60lmCPx6IfFbk6XViPCpfBvKZ5MO0sRrSXZd4ga/oictnRdRXge0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C1/L5+fq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JGP/uN9Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C1/L5+fq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JGP/uN9Z"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5839Nhmq018594;
	Wed, 3 Sep 2025 14:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vcAfrRST2wlFuky/L3jl3bJG1d9goCmX1a4eiYwDmfM=; b=
	C1/L5+fql2QSoJz5VIlNQTdO8WEun64Nb+42gFAkHw80I1loubtg9wTqJLbov5Y7
	7pemY/M6JLvPNZU9RXyNq0CGzKxiFmTMDIvbFX8q4wqEwscuRWu55C7Qyp1DLJZc
	bCQUrbu5EJ/rAq/Kz6H41YzoBCfO0XocJd/s0y0B9Im3pM8JbAyga4sCnQIYAf/5
	65AVHAmJ4I4qkynFWE1ayia4e20SEXhdNYlQTess+c3K5BuHKEpRE9mZEgeGTQ9r
	hGiYEw2Y1ysFPKEpHvZBcPNLrVhwK+0dw5EAD/m2N1gr0ydLj0HQaXHK5+uk0Uzz
	JBuEnMP7wX9+mzdKeIyDMA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmbedq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 14:03:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583DLDHP036099;
	Wed, 3 Sep 2025 14:03:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqracgeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 14:03:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVqlwvbAQAa4pWBNgRzi+WQqKiVjAOzJjM0r8tZl4CKC4v9ghzT4ojri9MuhOb3IHHTfgQdQ/p9w1UmnWhiKkEi280Akw3IW4j8+jxOIcxFNsr/IPZL5hrm9qoudhxFx8lQaBz+7dH7v/zTJO0yYGU8ooOo14xBcZtf2Igp6t3sHApl0B5JRVvvzvW6q0B2t5p3Pfp88oMZukYJNAma7r92eIBn6NVw1SgfH1fXSCpRQnIRUgBsgaQg/mcpsj2miN6FfoPsJu4Ssw2U7i+n3+fiI87+acu+6heKtarwBKTQgZh+F1jtBfmMviJ+yamgtmTkhEx7lKgDE0O3gmIE7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcAfrRST2wlFuky/L3jl3bJG1d9goCmX1a4eiYwDmfM=;
 b=G6zEqYepJFKg2tVokLVRHbrjmBToQ5uVfEbta8/8XMKcKc25MRMpBf005jzoEQLUEy/QdXGmNbOhDQiyT6iIaYKrgFAapUzVZVqCOAwSvXO0XGCmPPm7/HNmTAIPmzpPhDDVcmEXh+ta2eEgOSOMXYNRP+V3Rx0cq8Afx3X+CxwYw/nlQ+CaZh0sRasnu3kN+bPS7eBFMKZJGTfUpMzxkpI0/d4/6nxPlav1FmC5dsgB8AK9MMG1bFzWSMyX+hGQJ1FjpUYLEBlWKULxQR+4yH2TcHaL5nl8xjMEKrpCVePTInyn3QzemerglxiGKza4z5Tvyz4QfC92NXsB+zbyig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcAfrRST2wlFuky/L3jl3bJG1d9goCmX1a4eiYwDmfM=;
 b=JGP/uN9ZzI/Dgwp0Icb/hrJtwgZImu1iEAtyXouayw/Kx1E3Faff7SVBGGZuEiE2je9fVARGKY58WsqO0jPRm+coa6JE25UUhzlPWIO/PZztaovWylvauyojW39yjFJjuyq5AfGD0WQrz4lOJ3+CbvgHn9ydFdaEwabo/ouJTsE=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 PH7PR10MB6553.namprd10.prod.outlook.com (2603:10b6:510:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 14:03:29 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 14:03:29 +0000
Message-ID: <d40d8e00-cafb-4b0d-9d5e-f30a05255e5f@oracle.com>
Date: Wed, 3 Sep 2025 09:03:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [WIP RFC PATCH] fs: retire I_WILL_FREE
To: Matthew Wilcox <willy@infradead.org>, Mateusz Guzik <mjguzik@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20250902145428.456510-1-mjguzik@gmail.com>
 <aLe5tIMaTOPEUaWe@casper.infradead.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <aLe5tIMaTOPEUaWe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|PH7PR10MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f5f88c2-28b2-4f16-bf98-08ddeaf2a8d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGRsSzFPWWFrUHRjMWx4R21sQlNZSmU4YXdhNzlRWDlBRGRLRkFhekRCN0hj?=
 =?utf-8?B?dTNabzdpQndhSGhKVE9Ld3dTeVlYb3lvSVM4ZjRBa2hWVzRpRnk0Nm5OakRv?=
 =?utf-8?B?N2IyUk1hV0RDVER0WFhzOW94YXRZNVlRWlNMdlNWZmhLbytCVTlZNGRRZThD?=
 =?utf-8?B?QWhNZjVxNnNVU0FVODFtTGVGNDJaK1hxa29tT1VyU3hjQ0JMY2pOamlKMHFv?=
 =?utf-8?B?OFBRY0lNWllCRjYwOUVPc29CR2ZmVWpNa3lRZFdOL0k3TTBmTlBOUzBGTTBN?=
 =?utf-8?B?OVY3bEk5N0M1YjZrbyt5cldQRy9PWGlpTHp0L0Qwd1JMYm9qWTZEbXorRVp4?=
 =?utf-8?B?MUI2cC9wRzk5ck1SM1k1Q2tNZ3NHVlp2SDc3dnZhR2xTUmRsM3JxWkZreUE1?=
 =?utf-8?B?Q1loR1VualdPL3BLaGdLK1dvWFVDVUp2bHlLM3hRb3RiUy82RHY1Z2l0Z0xB?=
 =?utf-8?B?NzduVFZORnNvNVpvbzl3R2owazZGanQxRmQwa0ExVmNmdW1iVThWU0RTblYw?=
 =?utf-8?B?bHlFb1I1cjJYQXpYYldPVkRwQXhDU0p5Ris5cUpDNUthM3pjTXlzRTdYZVNB?=
 =?utf-8?B?N2VTSmlKaDV1TWlTVmdYaDl2TlI4Q1RHL3cvV2hBRG9ac3pEUldpWFovVWp0?=
 =?utf-8?B?T3lzOTFEWjdzdEpCVzNwc3VVM2l0Y21Udm1EdStjV05IRURQVTJRenZMK2ph?=
 =?utf-8?B?d1kwdFBIRFRIdXlwcGljRWxTVFo1OUFyclBPL0FtQXV4YkxBQU5JN3BmUGsv?=
 =?utf-8?B?cFpNYVNLT2RHb1o4czVaV2NpYXJvaWtteTJYT1l0V0RNaWdXU2JMMWJsa1RD?=
 =?utf-8?B?MWQ3ZlFHVEEyUE90THpIK1RsMU91MmN5cHQ3VmpPTlpZMFZNUC9IaWw1ZWVP?=
 =?utf-8?B?U2VxMU94NGZsc2hTdUhYZHlmZWxUa1VjdWd5QjBJTFltN2UrTjJTbXJ6VU1j?=
 =?utf-8?B?RFowc1VxTkJGL2gxZUluNExzejBnRjZndHlUNEVuQVBkODN1aStWUGpKcFd0?=
 =?utf-8?B?R0tJR0MySXdMUkZtQTBBajNYanFPTGlEWVJ2NU5IL1ZlTDBNeHc2OHFQY05J?=
 =?utf-8?B?czA2a29IVVpWbTROZEkycGRCVkt6TTJFMCtmOUhRdmRDa2dhaWVkTmdIbmhi?=
 =?utf-8?B?OVJyTTdNVklOVjdkTzhLNXBHVDdtVDY5MUg4SG9QOEJsa3pQeERFcmpYbFlE?=
 =?utf-8?B?ckdKWXN5ZnBmRFZBM3gwTHNscWVhaGpCanROeXVVUm5ucnRTcU04a2NGV2ZX?=
 =?utf-8?B?cG1YU3pxTDhoZWYzQVZaYWk2V01XbmxKVjdZUU1DeGU1Smg1akd0SDhoOVk4?=
 =?utf-8?B?UGNCcjVhd0EzQjBhVjhja0hyNHppbkgxaXk2QUh6TXpiaWgvZ0FGcnV3c25U?=
 =?utf-8?B?SXVpQjljZlBHbWFGMERQa2ZENUJlby8xTWlIOHVkNWdOUURIcWhOMjVBdGJX?=
 =?utf-8?B?bzhaM3FFdlgxQk0zY0JFSmZNYSt4a1JJRHJCRHlySDRrb3dib0krTnRTdmxi?=
 =?utf-8?B?ZlJCckN1dDN1M2tzdExtanczRXV1YUFvMk9OdUErU1hINnAzK3BwMGJsR1NX?=
 =?utf-8?B?V29UYW5nSGZFUlRZSkg0a3oxMTRZMTF1NUhjQ1hyZy9lUk1hcG5vYkh3SjVm?=
 =?utf-8?B?cFIzNmpjcFkxbkxSVElWM1NRYXZ1MHRvTXBSeXpYMWdiamplOFlkUFBNR3c2?=
 =?utf-8?B?WDNKMFhtUFMxS0hac2RjU0tzNDgrWHg2d0dTL3FPWEozK09OZVQ5RkxUUkZX?=
 =?utf-8?B?RmxrbDVVQ1BqdGpuMHN3TE50dW5QQm9LNHNTZVdXYXNBNVhkYmdjMzZrVFM2?=
 =?utf-8?B?UlVGVzNTTE9zeEE1NndzRHdGWUQ0d1hscEphTEo0V25LS1BIcW1VekcrOFhD?=
 =?utf-8?B?YWNMR2hPOG94QXl2czA3KytNZm9kRWdqakUwckk3RElYbGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVFlUkJKT1ZYbmdnZWVQQTZhNXRhWnFXR1FONDJiMVp4TVVOZHIxY1k4dGxH?=
 =?utf-8?B?NDg5dkx5STFVT1IrcWs3ZzkrN25DSTRFT3FrenRDb1pXQmZBQS9pOTlmbEpN?=
 =?utf-8?B?ckpkZ1k4NHpFNGtvQlB5WlVmZWlNQnlHMEFuTU55U0RjMlNBYlRvVFBvQVhy?=
 =?utf-8?B?UzlNMHRUTVBuek0zKzhHVDRCbUM4VVVZMzIxc1pMeUNpcmZhQmlNWDdURzJU?=
 =?utf-8?B?WlhSL3ZXa3NFdW1XWUwzWjZiTktpKzM1aTYrN0NhVVBwK29IOERhUDBleXFQ?=
 =?utf-8?B?THdINnRyTTlYTW02M29uRFphZGFlSTJFTTM3d2hqTDg1OE0vZ0JMQUZjakY4?=
 =?utf-8?B?NTFnMkgvL2tpbjZMcHRoeThOUk81QXVpUEUzVEVLWFBLWGptNlcvMStJYVBZ?=
 =?utf-8?B?SWw2R1ZtUFZHT3RMeHRKOHJrSW5CRGpVYWN6V1dxY0VSYk9wUDFONnVyazl4?=
 =?utf-8?B?MDR4c01zelpyQW1UWkwzYmwzbTNLazJ1VUVGWS93MHBiSDUxM1Fua1F6dWxn?=
 =?utf-8?B?YzBsQmZkQyt5Rzh1VVlhUUNBM3p1YWxpMG00WTN0K3Zud1I2Tk9zclJGTTFN?=
 =?utf-8?B?anRmc29qc3hDaVNnallaNDVzV1NLNGhLSEJTVER6cTRnV3ZPa1R0ak8wWTJm?=
 =?utf-8?B?d0NCZG5oc0FwZnY1UFJMUjRWeWVQMG8xNFV6ZVFuOXBBaFVwYUxjdnNhWURk?=
 =?utf-8?B?eG5OWGpEbTNhNjRPWGs1SlNRUTk0S24wUWFYWjJZN3ZVdlJaZVkvQ2M4RzZw?=
 =?utf-8?B?Ym9GK2tHaWdzcWZIbWQvcEZaNWJSM2IyRGIrYlZ1cm9USFkyUVExNFRaZDNK?=
 =?utf-8?B?WDFWVHhubUpvdFVKYmVwRWxNSExWNEs1LzlMeUptN0JEMGdSbnppZzRmSWlO?=
 =?utf-8?B?RmFYYmN4U0NXM2hMQWZ4WG9OKzU1U2FKSWJxb0diL2hMMVFEUmpIaUoxU285?=
 =?utf-8?B?RklxM0s3Y1R1aWhCNnQ0QzJJUG94czRFSDI0OWpST3lTbUwrZVVNUkFwcDBC?=
 =?utf-8?B?ZDBzT0orWHlJSy9yVG93Z0RuMy9BOVI0dGxBc3RQRzB3RERUY2ZHUi9Ic2VQ?=
 =?utf-8?B?TGY3RHN0WHVPeXgzKzdsbWFWSm9VYmFyM2NieXdnay95aFFpSTVrd2ZaUXNW?=
 =?utf-8?B?REo3QTAxeTgxQ2hpQkZqTndJeURIMUJId3hKNGgzNmMxSXJEM2NDS1NFS0dQ?=
 =?utf-8?B?T1UyOW9LbnpJNDNJL3RhbmVqU3h6a0NFMHZpbGJ3cFdpS3RNeCtaNk85cmZ4?=
 =?utf-8?B?Y2pvb2RYaGNPMFN6TGtlRTgxUzVXMjNMaU5ZQlduM3QwTFRyZHRHV3cvcm5U?=
 =?utf-8?B?VFJqcUNrOE9jRnJKVUxtc1dFWTZVOHEwNFNTbzQ1Sk9lZERSZ0F3bW1nUnVk?=
 =?utf-8?B?a0FWdUVUemUydUhxZDR6ckVIOVEvQmdvZHBoTGdnNlhjT2hJRWN0UjZNM1Bt?=
 =?utf-8?B?ZDlnWTBpUEpWRUNXcUZxSnk0SE5mQzNZajNXc2p4T2J6bUc1bTFrdGw2TFNW?=
 =?utf-8?B?QUVzVWJ5SDNqdFhGNDdHOTdTY3ppLzIraUR3M3ZnbFRPOWdjUjJCRVIvb2tZ?=
 =?utf-8?B?L1lybWRjRXlhSnBEdlN1YW9ManBoSy94MWFLRlYwOHppeHVIY2hzeVIzK296?=
 =?utf-8?B?ODkyYytsMURTQ2lncnRxeXJsZGFNMDJhRENTSzVyb0JWQ01PU01yN1YrYmIz?=
 =?utf-8?B?bERMZzEydXZ4cy9ER211SmdJeHF6OWdUU2FCSUpya3c3R05IZzJxUjNoZ2ZF?=
 =?utf-8?B?V1lTWWVhenBLTlNDZWtTNFFNdENHcDFONzdDN3pnOEZqeCtHdTBZZ3A3NEJH?=
 =?utf-8?B?TkZqK3JWaWdQZVZmcFVIbGg4VXJhQmpuRUd2Q2RpcUNVbHd2cUl0QlNmZ3J5?=
 =?utf-8?B?aG12WEdxdWFoRlVleGdGZ01MTmpJS3RoWXpxL3hYa3YzOHUxNjY0cTdTVS9p?=
 =?utf-8?B?NVgwcUd0cnQyTmsvS0tNTm53THpkNkJNTDU1dFhGWjZoRTcxd1FrMmRVVng2?=
 =?utf-8?B?SlRYTExQeDduZ093Nldsam5NNS8veFdKTXRtMFlSZHJSeXlML3RHRVJQL0hL?=
 =?utf-8?B?QmJiR255Nnh2QTRYbWdxeUFXbmxsYW5DbUdiT1FkWDI5UEJRUmlFaUpCc3BN?=
 =?utf-8?B?Znl3YkZvR2Q2c2t4SU9FUUVWYXNvVm02V0RremhqWkFWNDVqVE1UaVpGbXlo?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VmpM4RFk4NIuiYW4pzh1xf9+D3gNoQPhCo3JPlDkkddGFXt/DgQSpO3YQlmQt/h+QY+gDmZgviuYRGtIyxc70mn4zazKAQaW1j4tN1EmMpQLvNCWbi9WGsNj9/cznVCiOb8rdumBrtlOO1u8wQpmv6Ii1HNd9P+d8/OAv0CTxCvgE9ES3hl0Thr9t5HVmWeSdUi4LY1rShOPdlomXPDBCI6iCc7DxVLdHShYnA1ROPGet46P9/aaj0lEeqgDp26g4y6FGIkGnHvKbcp50hMwHPhU0cJe9nKc8MTuaQjdHjDJn4LOSvzTPDRl/AImJ1wy+cv13TiOqUuDYmafuswrFlcxjwrSGh8iZBIww6v0ARFXh0REgPIcEcLTvymvRhNRaLeWJHbK4RHpHzh7s823+uXYU//Fu/+e2XwHC8gN3wS9YKiNxij70V9RUqoNfr8ZBk3CVeyonWIvksQWxxc5KNmHS1nNmO+n0L4nZAE9fHY/yIXsetuwknzwnFmPm5pSOOCtoS3518NNELbhu2hFSkUDqaj0qn7tgXTKxZY56YQLKzSC5qcPjrTgvBAcj+zrQEIzvNHzZHLSeHBLQRKhZHpxT5aCMxAsr5WV5JJfDrM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5f88c2-28b2-4f16-bf98-08ddeaf2a8d8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 14:03:29.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUp0QTCg0RbSHBzD+tMoq6e4t/yrOPSJPgDPIc0HJgeZH6pC6xDT/p/bqw6x1MuAMvJn5FzhyRj5bgLpAJXHpgudVSDCKQYBSlzoYac9qPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_07,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030141
X-Proofpoint-ORIG-GUID: ShM4ISzIoCYxDA3FQxsP_BBdS_12AbZX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX7fcH3dAqmNgg
 tcvvhMdFYC0maJ73m8CHWfYE9EJX97J5pl+XKbEiS6Aq1xPKN1fPHrGBtWt6M+0Qth65HKqUmQD
 NAT+pRhOQ7aydmkoPwSKJluONPPPYD/tneNLn5tuNt+BkCs91ckoEi1ZzcSooElE+YKXKhYdzKO
 TLP5lBc0103XmcwnYFqRBqcW6sFi/HWCN7JckOl/l9hyUGLDPgwDyXglleWJTc+y5ZdpCXCXB7i
 i2YUXd2iqynYb1m/Adlu2aL7qngm7h9kYcb3Qh3o90Ws2f1mA6qvkb/nDugiftJtpQQISirXD08
 2HvKYAkvj4nbWBP6IomVyik5kqptnLDqVn2pn55wI8cq/1bpnGVSbslOzXBOyOEurNC66uCu+VD
 BCn/cb9N
X-Authority-Analysis: v=2.4 cv=KORaDEFo c=1 sm=1 tr=0 ts=68b84ab5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=J7-fzIN4sIeF4tigLgcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ShM4ISzIoCYxDA3FQxsP_BBdS_12AbZX

On 9/2/25 10:44 PM, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 04:54:28PM +0200, Mateusz Guzik wrote:
>> Following up on my response to the refcount patchset, here is a churn
>> patch to retire I_WILL_FREE.
>>
>> The only consumer is the drop inode routine in ocfs2.
> 
> If the only consumer is ocfs2 ... then you should cc the ocfs2 people,
> right?
> 
>> For the life of me I could not figure out if write_inode_now() is legal
>> to call in ->evict_inode later and have no means to test, so I devised a
>> hack: let the fs set I_FREEING ahead of time. Also note iput_final()
>> issues write_inode_now() anyway but only for the !drop case, which is the
>> opposite of what is being returned.
>>
>> One could further hack around it by having ocfs2 return *DON'T* drop but
>> also set I_DONTCACHE, which would result in both issuing the write in
>> iput_final() and dropping. I think the hack I did implement is cleaner.
>> Preferred option is ->evict_inode from ocfs handling the i/o, but per
>> the above I don't know how to do it.

I am a lurker in this series and ocfs2. My history has been mostly in
XFS/CXFS/DMAPI. I removed the other CC entries because I did not want
to blast my opinion unnecessaially.

The flushing in ocfs2_drop_inode() predates the I_DONTCACHE addition.
IMO, it would be safest and best to maintain to let ocfs2_drop_inode()
return 0 and set I_DONTCACHE and let iput_final() do the correct thing.

Mark Tinguely.


>> So.. the following is my proposed first step towards sanitisation of
>> i_state and the lifecycle flags.
>>
>> I verified fs/inode.c and fs/fs-writeback.c compile, otherwise untested.
>>
>> Generated against vfs-6.18.inode.refcount.preliminaries
>>
>> Comments?
>>
>> ---
>>   block/bdev.c                     |  2 +-
>>   fs/bcachefs/fs.c                 |  2 +-
>>   fs/btrfs/inode.c                 |  2 +-
>>   fs/crypto/keyring.c              |  2 +-
>>   fs/drop_caches.c                 |  2 +-
>>   fs/ext4/inode.c                  |  2 +-
>>   fs/fs-writeback.c                | 18 +++++++----------
>>   fs/gfs2/ops_fstype.c             |  2 +-
>>   fs/inode.c                       | 34 +++++++++++++++++---------------
>>   fs/notify/fsnotify.c             |  6 +++---
>>   fs/ocfs2/inode.c                 |  3 +--
>>   fs/quota/dquot.c                 |  2 +-
>>   fs/xfs/scrub/common.c            |  3 +--
>>   include/linux/fs.h               | 32 ++++++++++++------------------
>>   include/trace/events/writeback.h |  3 +--
>>   security/landlock/fs.c           | 12 +++++------
>>   16 files changed, 58 insertions(+), 69 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index b77ddd12dc06..1801d89e448b 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -1265,7 +1265,7 @@ void sync_bdevs(bool wait)
>>   		struct block_device *bdev;
>>   
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
>> +		if (inode->i_state & (I_FREEING | I_NEW) ||
>>   		    mapping->nrpages == 0) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index 687af0eea0c2..a62d597630d1 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -347,7 +347,7 @@ static struct bch_inode_info *bch2_inode_hash_find(struct bch_fs *c, struct btre
>>   			spin_unlock(&inode->v.i_lock);
>>   			return NULL;
>>   		}
>> -		if ((inode->v.i_state & (I_FREEING|I_WILL_FREE))) {
>> +		if ((inode->v.i_state & I_FREEING)) {
>>   			if (!trans) {
>>   				__wait_on_freeing_inode(c, inode, inum);
>>   			} else {
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 5bcd8e25fa78..f1d9336b903f 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3856,7 +3856,7 @@ static int btrfs_add_inode_to_root(struct btrfs_inode *inode, bool prealloc)
>>   		ASSERT(ret != -ENOMEM);
>>   		return ret;
>>   	} else if (existing) {
>> -		WARN_ON(!(existing->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));
>> +		WARN_ON(!(existing->vfs_inode.i_state & I_FREEING));
>>   	}
>>   
>>   	return 0;
>> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
>> index 7557f6a88b8f..97f4c7049222 100644
>> --- a/fs/crypto/keyring.c
>> +++ b/fs/crypto/keyring.c
>> @@ -957,7 +957,7 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
>>   	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
>>   		inode = ci->ci_inode;
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
>> +		if (inode->i_state & (I_FREEING | I_NEW)) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>>   		}
>> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
>> index 019a8b4eaaf9..40fa9b17375b 100644
>> --- a/fs/drop_caches.c
>> +++ b/fs/drop_caches.c
>> @@ -28,7 +28,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
>>   		 * inodes without pages but we deliberately won't in case
>>   		 * we need to reschedule to avoid softlockups.
>>   		 */
>> -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
>> +		if ((inode->i_state & (I_FREEING|I_NEW)) ||
>>   		    (mapping_empty(inode->i_mapping) && !need_resched())) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index ed54c4d0f2f9..14209758e5be 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -425,7 +425,7 @@ void ext4_check_map_extents_env(struct inode *inode)
>>   	if (!S_ISREG(inode->i_mode) ||
>>   	    IS_NOQUOTA(inode) || IS_VERITY(inode) ||
>>   	    is_special_ino(inode->i_sb, inode->i_ino) ||
>> -	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
>> +	    (inode->i_state & (I_FREEING | I_NEW)) ||
>>   	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
>>   	    ext4_verity_in_progress(inode))
>>   		return;
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index 6088a67b2aae..5fa388820daf 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -405,10 +405,10 @@ static bool inode_do_switch_wbs(struct inode *inode,
>>   	xa_lock_irq(&mapping->i_pages);
>>   
>>   	/*
>> -	 * Once I_FREEING or I_WILL_FREE are visible under i_lock, the eviction
>> +	 * Once I_FREEING is visible under i_lock, the eviction
>>   	 * path owns the inode and we shouldn't modify ->i_io_list.
>>   	 */
>> -	if (unlikely(inode->i_state & (I_FREEING | I_WILL_FREE)))
>> +	if (unlikely(inode->i_state & I_FREEING))
>>   		goto skip_switch;
>>   
>>   	trace_inode_switch_wbs(inode, old_wb, new_wb);
>> @@ -560,7 +560,7 @@ static bool inode_prepare_wbs_switch(struct inode *inode,
>>   	/* while holding I_WB_SWITCH, no one else can update the association */
>>   	spin_lock(&inode->i_lock);
>>   	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
>> -	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
>> +	    inode->i_state & (I_WB_SWITCH | I_FREEING) ||
>>   	    inode_to_wb(inode) == new_wb) {
>>   		spin_unlock(&inode->i_lock);
>>   		return false;
>> @@ -1758,7 +1758,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>>    * whether it is a data-integrity sync (%WB_SYNC_ALL) or not (%WB_SYNC_NONE).
>>    *
>>    * To prevent the inode from going away, either the caller must have a reference
>> - * to the inode, or the inode must have I_WILL_FREE or I_FREEING set.
>> + * to the inode, or the inode must have I_FREEING set.
>>    */
>>   static int writeback_single_inode(struct inode *inode,
>>   				  struct writeback_control *wbc)
>> @@ -1768,9 +1768,7 @@ static int writeback_single_inode(struct inode *inode,
>>   
>>   	spin_lock(&inode->i_lock);
>>   	if (!icount_read(inode))
>> -		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
>> -	else
>> -		WARN_ON(inode->i_state & I_WILL_FREE);
>> +		WARN_ON(!(inode->i_state & I_FREEING));
>>   
>>   	if (inode->i_state & I_SYNC) {
>>   		/*
>> @@ -1928,7 +1926,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>>   		 * kind writeout is handled by the freer.
>>   		 */
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>> +		if (inode->i_state & (I_NEW | I_FREEING)) {
>>   			redirty_tail_locked(inode, wb);
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>> @@ -2696,7 +2694,7 @@ static void wait_sb_inodes(struct super_block *sb)
>>   		spin_unlock_irq(&sb->s_inode_wblist_lock);
>>   
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
>> +		if (inode->i_state & (I_FREEING | I_NEW)) {
>>   			spin_unlock(&inode->i_lock);
>>   
>>   			spin_lock_irq(&sb->s_inode_wblist_lock);
>> @@ -2844,8 +2842,6 @@ EXPORT_SYMBOL(sync_inodes_sb);
>>    *
>>    * This function commits an inode to disk immediately if it is dirty. This is
>>    * primarily needed by knfsd.
>> - *
>> - * The caller must either have a ref on the inode or must have set I_WILL_FREE.
>>    */
>>   int write_inode_now(struct inode *inode, int sync)
>>   {
>> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
>> index c770006f8889..1393181a64dc 100644
>> --- a/fs/gfs2/ops_fstype.c
>> +++ b/fs/gfs2/ops_fstype.c
>> @@ -1749,7 +1749,7 @@ static void gfs2_evict_inodes(struct super_block *sb)
>>   	spin_lock(&sb->s_inode_list_lock);
>>   	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>>   		spin_lock(&inode->i_lock);
>> -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) &&
>> +		if ((inode->i_state & (I_FREEING | I_NEW)) &&
>>   		    !need_resched()) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 2db680a37235..8188b0b5dfa1 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -532,7 +532,7 @@ EXPORT_SYMBOL(ihold);
>>   
>>   static void __inode_add_lru(struct inode *inode, bool rotate)
>>   {
>> -	if (inode->i_state & (I_DIRTY_ALL | I_SYNC | I_FREEING | I_WILL_FREE))
>> +	if (inode->i_state & (I_DIRTY_ALL | I_SYNC | I_FREEING))
>>   		return;
>>   	if (icount_read(inode))
>>   		return;
>> @@ -577,7 +577,7 @@ static void inode_lru_list_del(struct inode *inode)
>>   static void inode_pin_lru_isolating(struct inode *inode)
>>   {
>>   	lockdep_assert_held(&inode->i_lock);
>> -	WARN_ON(inode->i_state & (I_LRU_ISOLATING | I_FREEING | I_WILL_FREE));
>> +	WARN_ON(inode->i_state & (I_LRU_ISOLATING | I_FREEING));
>>   	inode->i_state |= I_LRU_ISOLATING;
>>   }
>>   
>> @@ -879,7 +879,7 @@ void evict_inodes(struct super_block *sb)
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>>   		}
>> -		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>> +		if (inode->i_state & (I_NEW | I_FREEING)) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>>   		}
>> @@ -1025,7 +1025,7 @@ static struct inode *find_inode(struct super_block *sb,
>>   		if (!test(inode, data))
>>   			continue;
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
>> +		if (inode->i_state & I_FREEING) {
>>   			__wait_on_freeing_inode(inode, is_inode_hash_locked);
>>   			goto repeat;
>>   		}
>> @@ -1066,7 +1066,7 @@ static struct inode *find_inode_fast(struct super_block *sb,
>>   		if (inode->i_sb != sb)
>>   			continue;
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
>> +		if (inode->i_state & I_FREEING) {
>>   			__wait_on_freeing_inode(inode, is_inode_hash_locked);
>>   			goto repeat;
>>   		}
>> @@ -1538,7 +1538,7 @@ EXPORT_SYMBOL(iunique);
>>   struct inode *igrab(struct inode *inode)
>>   {
>>   	spin_lock(&inode->i_lock);
>> -	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
>> +	if (!(inode->i_state & I_FREEING)) {
>>   		__iget(inode);
>>   		spin_unlock(&inode->i_lock);
>>   	} else {
>> @@ -1728,7 +1728,7 @@ struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
>>   
>>   	hlist_for_each_entry_rcu(inode, head, i_hash) {
>>   		if (inode->i_sb == sb &&
>> -		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)) &&
>> +		    !(READ_ONCE(inode->i_state) & I_FREEING) &&
>>   		    test(inode, data))
>>   			return inode;
>>   	}
>> @@ -1767,7 +1767,7 @@ struct inode *find_inode_by_ino_rcu(struct super_block *sb,
>>   	hlist_for_each_entry_rcu(inode, head, i_hash) {
>>   		if (inode->i_ino == ino &&
>>   		    inode->i_sb == sb &&
>> -		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)))
>> +		    !(READ_ONCE(inode->i_state) & I_FREEING))
>>   		    return inode;
>>   	}
>>   	return NULL;
>> @@ -1789,7 +1789,7 @@ int insert_inode_locked(struct inode *inode)
>>   			if (old->i_sb != sb)
>>   				continue;
>>   			spin_lock(&old->i_lock);
>> -			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
>> +			if (old->i_state & I_FREEING) {
>>   				spin_unlock(&old->i_lock);
>>   				continue;
>>   			}
>> @@ -1862,12 +1862,19 @@ static void iput_final(struct inode *inode)
>>   	int drop;
>>   
>>   	WARN_ON(inode->i_state & I_NEW);
>> +	VFS_BUG_ON_INODE(inode->i_state & I_FREEING, inode);
>>   
>>   	if (op->drop_inode)
>>   		drop = op->drop_inode(inode);
>>   	else
>>   		drop = generic_drop_inode(inode);
>>   
>> +	/*
>> +	 * Note: the ->drop_inode routine is allowed to set I_FREEING for us,
>> +	 * but this is only legal if they want to drop.
>> +	 */
>> +	VFS_BUG_ON_INODE(!drop && (inode->i_state & I_FREEING), inode);
>> +
>>   	if (!drop &&
>>   	    !(inode->i_state & I_DONTCACHE) &&
>>   	    (sb->s_flags & SB_ACTIVE)) {
>> @@ -1877,19 +1884,14 @@ static void iput_final(struct inode *inode)
>>   	}
>>   
>>   	state = inode->i_state;
>> +	WRITE_ONCE(inode->i_state, state | I_FREEING);
>>   	if (!drop) {
>> -		WRITE_ONCE(inode->i_state, state | I_WILL_FREE);
>>   		spin_unlock(&inode->i_lock);
>> -
>>   		write_inode_now(inode, 1);
>> -
>>   		spin_lock(&inode->i_lock);
>> -		state = inode->i_state;
>> -		WARN_ON(state & I_NEW);
>> -		state &= ~I_WILL_FREE;
>>   	}
>> +	WARN_ON(inode->i_state & I_NEW);
>>   
>> -	WRITE_ONCE(inode->i_state, state | I_FREEING);
>>   	if (!list_empty(&inode->i_lru))
>>   		inode_lru_list_del(inode);
>>   	spin_unlock(&inode->i_lock);
>> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
>> index 46bfc543f946..cff8417fa6db 100644
>> --- a/fs/notify/fsnotify.c
>> +++ b/fs/notify/fsnotify.c
>> @@ -47,12 +47,12 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
>>   	spin_lock(&sb->s_inode_list_lock);
>>   	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>>   		/*
>> -		 * We cannot __iget() an inode in state I_FREEING,
>> -		 * I_WILL_FREE, or I_NEW which is fine because by that point
>> +		 * We cannot __iget() an inode in state I_FREEING
>> +		 * or I_NEW which is fine because by that point
>>   		 * the inode cannot have any associated watches.
>>   		 */
>>   		spin_lock(&inode->i_lock);
>> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
>> +		if (inode->i_state & (I_FREEING | I_NEW)) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>>   		}
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 14bf440ea4df..29549fc899e9 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1307,12 +1307,11 @@ int ocfs2_drop_inode(struct inode *inode)
>>   				inode->i_nlink, oi->ip_flags);
>>   
>>   	assert_spin_locked(&inode->i_lock);
>> -	inode->i_state |= I_WILL_FREE;
>> +	inode->i_state |= I_FREEING;
>>   	spin_unlock(&inode->i_lock);
>>   	write_inode_now(inode, 1);
>>   	spin_lock(&inode->i_lock);
>>   	WARN_ON(inode->i_state & I_NEW);
>> -	inode->i_state &= ~I_WILL_FREE;
>>   
>>   	return 1;
>>   }
>> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
>> index df4a9b348769..3aa916040602 100644
>> --- a/fs/quota/dquot.c
>> +++ b/fs/quota/dquot.c
>> @@ -1030,7 +1030,7 @@ static int add_dquot_ref(struct super_block *sb, int type)
>>   	spin_lock(&sb->s_inode_list_lock);
>>   	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>>   		spin_lock(&inode->i_lock);
>> -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
>> +		if ((inode->i_state & (I_FREEING | I_NEW)) ||
>>   		    !atomic_read(&inode->i_writecount) ||
>>   		    !dqinit_needed(inode, type)) {
>>   			spin_unlock(&inode->i_lock);
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 2ef7742be7d3..e678f944206f 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -1086,8 +1086,7 @@ xchk_install_handle_inode(
>>   
>>   /*
>>    * Install an already-referenced inode for scrubbing.  Get our own reference to
>> - * the inode to make disposal simpler.  The inode must not be in I_FREEING or
>> - * I_WILL_FREE state!
>> + * the inode to make disposal simpler.  The inode must not have I_FREEING set.
>>    */
>>   int
>>   xchk_install_live_inode(
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index c4fd010cf5bf..e8ad8f0a03c7 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -671,8 +671,8 @@ is_uncached_acl(struct posix_acl *acl)
>>    * I_DIRTY_DATASYNC, I_DIRTY_PAGES, and I_DIRTY_TIME.
>>    *
>>    * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
>> - * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
>> - * various stages of removing an inode.
>> + * until that flag is cleared.  I_FREEING and I_CLEAR are set at various stages
>> + * of removing an inode.
>>    *
>>    * Two bits are used for locking and completion notification, I_NEW and I_SYNC.
>>    *
>> @@ -696,24 +696,21 @@ is_uncached_acl(struct posix_acl *acl)
>>    *			New inodes set I_NEW.  If two processes both create
>>    *			the same inode, one of them will release its inode and
>>    *			wait for I_NEW to be released before returning.
>> - *			Inodes in I_WILL_FREE, I_FREEING or I_CLEAR state can
>> - *			also cause waiting on I_NEW, without I_NEW actually
>> - *			being set.  find_inode() uses this to prevent returning
>> - *			nearly-dead inodes.
>> - * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
>> - *			is zero.  I_FREEING must be set when I_WILL_FREE is
>> - *			cleared.
>> + *			Inodes in I_FREEING or I_CLEAR state can also cause
>> + *			waiting on I_NEW, without I_NEW actually being set.
>> + *			find_inode() uses this to prevent returning nearly-dead
>> + *			inodes.
>>    * I_FREEING		Set when inode is about to be freed but still has dirty
>>    *			pages or buffers attached or the inode itself is still
>>    *			dirty.
>>    * I_CLEAR		Added by clear_inode().  In this state the inode is
>>    *			clean and can be destroyed.  Inode keeps I_FREEING.
>>    *
>> - *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
>> - *			prohibited for many purposes.  iget() must wait for
>> - *			the inode to be completely released, then create it
>> - *			anew.  Other functions will just ignore such inodes,
>> - *			if appropriate.  I_NEW is used for waiting.
>> + *			Inodes that are I_FREEING or I_CLEAR are prohibited for
>> + *			many purposes.  iget() must wait for the inode to be
>> + *			completely released, then create it anew.  Other
>> + *			functions will just ignore such inodes, if appropriate.
>> + *			I_NEW is used for waiting.
>>    *
>>    * I_SYNC		Writeback of inode is running. The bit is set during
>>    *			data writeback, and cleared with a wakeup on the bit
>> @@ -743,8 +740,6 @@ is_uncached_acl(struct posix_acl *acl)
>>    * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
>>    *			i_count.
>>    *
>> - * Q: What is the difference between I_WILL_FREE and I_FREEING?
>> - *
>>    * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
>>    * upon. There's one free address left.
>>    */
>> @@ -764,7 +759,7 @@ enum inode_state_flags_t {
>>   	I_DIRTY_SYNC		= (1U << 4),
>>   	I_DIRTY_DATASYNC	= (1U << 5),
>>   	I_DIRTY_PAGES		= (1U << 6),
>> -	I_WILL_FREE		= (1U << 7),
>> +	I_PINNING_NETFS_WB	= (1U << 7),
>>   	I_FREEING		= (1U << 8),
>>   	I_CLEAR			= (1U << 9),
>>   	I_REFERENCED		= (1U << 10),
>> @@ -775,7 +770,6 @@ enum inode_state_flags_t {
>>   	I_CREATING		= (1U << 15),
>>   	I_DONTCACHE		= (1U << 16),
>>   	I_SYNC_QUEUED		= (1U << 17),
>> -	I_PINNING_NETFS_WB	= (1U << 18)
>>   };
>>   
>>   #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
>> @@ -2628,7 +2622,7 @@ static inline int icount_read(const struct inode *inode)
>>   static inline bool inode_is_dirtytime_only(struct inode *inode)
>>   {
>>   	return (inode->i_state & (I_DIRTY_TIME | I_NEW |
>> -				  I_FREEING | I_WILL_FREE)) == I_DIRTY_TIME;
>> +				  I_FREEING)) == I_DIRTY_TIME;
>>   }
>>   
>>   extern void inc_nlink(struct inode *inode);
>> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
>> index 1e23919c0da9..6e3ebecc95e9 100644
>> --- a/include/trace/events/writeback.h
>> +++ b/include/trace/events/writeback.h
>> @@ -15,7 +15,7 @@
>>   		{I_DIRTY_DATASYNC,	"I_DIRTY_DATASYNC"},	\
>>   		{I_DIRTY_PAGES,		"I_DIRTY_PAGES"},	\
>>   		{I_NEW,			"I_NEW"},		\
>> -		{I_WILL_FREE,		"I_WILL_FREE"},		\
>> +		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
>>   		{I_FREEING,		"I_FREEING"},		\
>>   		{I_CLEAR,		"I_CLEAR"},		\
>>   		{I_SYNC,		"I_SYNC"},		\
>> @@ -27,7 +27,6 @@
>>   		{I_CREATING,		"I_CREATING"},		\
>>   		{I_DONTCACHE,		"I_DONTCACHE"},		\
>>   		{I_SYNC_QUEUED,		"I_SYNC_QUEUED"},	\
>> -		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
>>   		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"}	\
>>   	)
>>   
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index 0bade2c5aa1d..7ffcd62324fa 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -1290,13 +1290,13 @@ static void hook_sb_delete(struct super_block *const sb)
>>   		 */
>>   		spin_lock(&inode->i_lock);
>>   		/*
>> -		 * Checks I_FREEING and I_WILL_FREE  to protect against a race
>> -		 * condition when release_inode() just called iput(), which
>> -		 * could lead to a NULL dereference of inode->security or a
>> -		 * second call to iput() for the same Landlock object.  Also
>> -		 * checks I_NEW because such inode cannot be tied to an object.
>> +		 * Checks I_FREEING to protect against a race condition when
>> +		 * release_inode() just called iput(), which could lead to a
>> +		 * NULL dereference of inode->security or a second call to
>> +		 * iput() for the same Landlock object.  Also checks I_NEW
>> +		 * because such inode cannot be tied to an object.
>>   		 */
>> -		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
>> +		if (inode->i_state & (I_FREEING | I_NEW)) {
>>   			spin_unlock(&inode->i_lock);
>>   			continue;
>>   		}
>> -- 
>> 2.43.0
>>
>>
> 

