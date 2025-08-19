Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C2275B05;
	Tue, 19 Aug 2025 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613950; cv=fail; b=Y0LQb6fGmHFFpYXwZtsC1bP/YLRJx6yS/RK6Zuh4j7v8G6eHGwmyJe04P6IdI7L0lZ6L6ceLENWJSnspKGDvCsyQoPSPDzdPIOeFjyyRim1rDMJ4Z0gTVUcSg+DoZUm5fOL/o9l0mjTnLOBuiYQUWpX+EgJsaUDQpMjRwhJgo6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613950; c=relaxed/simple;
	bh=Kc8Nd3slKh5Bey517PyAP2Dg0fjAGzT7EOxu48O41JI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EkCrnqnHCZcgLPGf0n+Rp2HR/WjKLACvbgV8jWt7IkqEm9aplKft/gktG/VoAn+tHL/jeOOh3oN7f2YL7bzwW+sStwl/krCac8zzFu9urrLxCwrX0ESJsFpQIgPWKEk3C6noiUN7ob5qHTcYBRAjrG3qO/eHe4v2030DbQFM17s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9dkdJJR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nNXnzDyP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9dkdJJR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nNXnzDyP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDj0Cb018549;
	Tue, 19 Aug 2025 14:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1PwPp+MYlPqPIZmo6nlPUX/4fbVbNDXzXzIeeFACzcA=; b=
	m9dkdJJR4sNveJFx7zKHrbbJzzkAA9ZUnnV07VYQ7uANTJ9pHwbDeQLbYbH6VqRu
	MgqzLdrAruF369+m+C8KpakcoSEWsgA1QAl1q/9gbrPasvoTUWJzzPz80wWxDpRX
	3pMxb63uKV2MHMYaBUsY5YYr5pG+H6LAbKTNsOiz9D4PSxYyZ0K8rZqsFmlM6kgO
	2tvho6udxP2xZo7Ot71QPNMPn0F4kmJ0dgrZ1hReuHdN8hdwRu5zemsvcwhgVG0N
	3qWo2miSuNmySbd5iw39RjEd4XuZIAL+M0edLtW1oJMVhQXtSPwZmM4b7cTzy25U
	DLWAxEdjnodYgrRo36TJQQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48m0ybu0mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:32:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JEUlu8030949;
	Tue, 19 Aug 2025 14:32:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jgea9q3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:32:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7y3H9nBsraEyMorUE/0dkzGCawwRM6gmKedQtHZGmb5nllb6DUkvDN4b4fzdV0239kl+DmvS1v5fgnceewr9P8zPFY5UwjOVrb/jjVW6+FRNKtBTz7e7mmUszE8hBPlmw8xmBGCPDR7BlVzj6/XIsK1liZj5QeGPwem9vAYQNrpOLvEiUsHteq28mqfiEdLacE8wyYF+V7p89fzBTJWgJq0eViYQWAzJCzOuWty1AW7yBltJ2BI2x4Uj4SXU4HhAsXPoGRF2GCy7ljLZciRQxlkvQvhznT2Y3Tf5FRFYSKzP5+jnxC2ZWa9nQn0I1RzGKpFyVGM9E86Axy9l3cr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PwPp+MYlPqPIZmo6nlPUX/4fbVbNDXzXzIeeFACzcA=;
 b=fD84XEKoNAQge3w8OqTPsNkKQGNt/N+doSNKW9dhaE58VgajhEiwlpUo6GMleXZtLDzzyL3kYysVpx7tHcnoWv4rztfbbk9LjBMBEDooLt+QUUT8sEmxKOfzWhUbAD1GPudr7TaXuMjZ9R0o+QKUvxppnctA9CcWq7nUcpgtH/I2I5i9KYiA2YYEfc6PMiQaPR8xVl1OtarzWssSAXUfmEE4c+N7Ts+hcvwIbpzA5iiasfzH7ep2AVprRKRNec0gWQOF1jQflla77z3D57A7bM4c+H8NfyaTwMrlWaPHgkAyIDWWQRTXFsZ3+eHQq0bTpeP+RRAVmhGjZKNIY/CDrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PwPp+MYlPqPIZmo6nlPUX/4fbVbNDXzXzIeeFACzcA=;
 b=nNXnzDyPu348IMEb7n8WqWticCsJ3kihCJQBz3Nn5IbqLTvBfurSAeWF08rR0UAJG5ivvtYUcl1NQ2qRU2hMo6AYe2Tbmv7VqnSnHsAxgKt02PVmBHk1DCigBRneEyhQejsQ39utJ+VT3slHr0UGBWI5Y0gWy27+S8KsxEpE2XI=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Tue, 19 Aug 2025 14:32:09 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 14:32:09 +0000
Message-ID: <cf71e138-656d-4740-a5e9-43b4460147ca@oracle.com>
Date: Tue, 19 Aug 2025 09:32:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] ocfs2: remove unnecessary NULL check in
 ocfs2_grab_folios()
To: Dan Carpenter <dan.carpenter@linaro.org>, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>,
        ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <aKRG39hyvDJcN2G7@stanley.mountain>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <aKRG39hyvDJcN2G7@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P221CA0072.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::10) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|DM4PR10MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: 164d7630-d031-45ef-c959-08dddf2d2dab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXRETjc1dTVmd2VIbEQyNDM4ZEQrSy8xNytRY29NUFRUdUVUTitydG9uRzRq?=
 =?utf-8?B?TGc0L0xEMXJkNVZZNE1RZzJKWFF1OThVOGg3ZEdqM2FDcVJWZkdkMlNReVc1?=
 =?utf-8?B?YnkxZmxIdWVPczQ4SjdWTXlFR1oxZG9vVnJVMHEyK0ZxWmw1MkJTRERQQmlo?=
 =?utf-8?B?QVd6ZXNjWlR0NUt6MmlJRXMrVnJmS3dhb2V0K3VMSTlGenVLdUVVSXZnNzdl?=
 =?utf-8?B?cEdrYzN4NUdZcmx4VEVBajRGeW43dFYwcFlDMlFZZGZoYnZtU0xDb3JyZXNV?=
 =?utf-8?B?SWxiMWExRkYrR0pQaFU5TXhHZ2FaTjZSSnBhZ2JJL2hhbmQxQVUrOE9rZ0pZ?=
 =?utf-8?B?R3ZMb2NNWjRtYVZkT0ZFbWJUUG9HSGhvL0NYWUZ4Y21sQjNIa3ZPRC94Nnh1?=
 =?utf-8?B?ckhid2hEZitPcW5nNFZnRVhIZGR6RDZOVXBaamkxNVVQNlBoa0RjdUh4bXk1?=
 =?utf-8?B?TDV0cTYxdW9jeHEyeXpVQnhhWE9tSVBJYVZyNmI1UEYrTGJYdTlMSlk5Q3lP?=
 =?utf-8?B?ZW1wNmdldUh3M1JtL3JXKzYreEIzT1kxNEFBaldxRFhNNjh1bzErWUNKamNY?=
 =?utf-8?B?Njk2MElsU1JzV0h3U0dCdjFqUG9RcnRaUzUzQ2RHVHRXdmJQc2wxNkRFbEdk?=
 =?utf-8?B?TGVyd09ocXFOTjR0TW0rY2FIaW9jSUJpM0tacXRSTFlYclNCZ3orU3JYOTYv?=
 =?utf-8?B?L0ZEODZHaDhXRER6UUVQTmJwWTVOMkhNYlVXaS85WGN4QVpJaWhVMGNOWWxC?=
 =?utf-8?B?SW9keWkvT0VqY2w3TGI3ZHJlajgzN25pV1ltdkJ3VE5JbzQ1SlJJYW13dzZG?=
 =?utf-8?B?ZXJNcjFZdGMycnVCVjAyMEUxLzNpa0h2dW1uMkZoTnpnaWE2SVhYN2VDM0VH?=
 =?utf-8?B?UHBhcDhrWGh3RzlPZVNKeFRFRGVqMDV3VFpYcTZqVTBYSEpGd2hxaFBBWFJI?=
 =?utf-8?B?TzdOQVI5d3p4ZXlKdGpPRlJ3ZjJZVW53dTM2aW8zVWxTcDBDeTkxUXYveThu?=
 =?utf-8?B?TXZtQ1Nlc0JGRjU5azRORUFHMElMeEl0REs0elBrOElHY2J4c2krQ0cvVmFy?=
 =?utf-8?B?b2FielEzSDVpZUFEMUM1K3VsZkV1TTltYkNCbFdRQVVHelNHU05xSkc0K0o3?=
 =?utf-8?B?MjFIOHdwMS9Ia3dNaU9ta1hWczVqSTNvcVluUncwdVVaUzZSVXRHQ2pRS1lo?=
 =?utf-8?B?VmIyL2s0dkVIbDdkdEpzZEppazU0b1RNZTByY0FHQmludWxQL2VlZjVjL0Vp?=
 =?utf-8?B?c2U5ZGlVT2tmZFlFZUliTExFMVRXTHZEU1dVQW15VHh6QXdYeTRyVmk3Y3Vi?=
 =?utf-8?B?Zy9wWmdPRitBWUE0YVZyOWlVbUNVdWZxejBYM1JCQ1ROQ3QwUkZMdlhkRUlZ?=
 =?utf-8?B?SEhLZ3hQb3R1WSsxcG9HODR3c1I3TEVsdzNnWE5KcGlBZ2pNbXRIYk9yQlZ4?=
 =?utf-8?B?Q2ZYZ0xFOCtrWTNaSEIvNDk2NWUxOE9rN0pHNXBFUkt1RDZDMGNmczhuS3cv?=
 =?utf-8?B?NnBDcEZJcmlGUTgzdkNzVTJ5c2ZjN3RveTgzNDJJSTdxN2Q0WWFxSlI4M2w1?=
 =?utf-8?B?V2hUTjE4UWlWbnVSM3NXdkQ5ejR6TE14VE1XWTNnYTdudzlFUW9TcVY1TURq?=
 =?utf-8?B?TG5TMXcyQm1SWENheC8yTThSbnlvSExuUWhDVHNaOVBrYVdIZy9ZdEF2WlE2?=
 =?utf-8?B?dnhrRzdCOVZ6RnpVYVBOOWZCSFdYSnRDZjZEV2cyTjZ3TlYwU1AxT2RWbFhz?=
 =?utf-8?B?SlhEWHhPcHhkRlM4VzZCZDZiY3pzeUZ1RjZjbzRibVNCdkF0UllMcUtDZDhx?=
 =?utf-8?B?R0hDZ09pMUlGU2UxWXVPWnB2bTFPdVlFNnM3VFJhVGY4c0tRa0JaQ1k2MVNn?=
 =?utf-8?B?WUNpMVltYVhXYTBpc3Y4UVRCMEtIY2FiTTZnN2FXaG5RM1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWR5bnJYTU5wczB4bENKaEVZSXZwRTR0ZFJoN21tb0lKSDl0Q2Mzd0pSSmFD?=
 =?utf-8?B?cDRmTHZWbU5aV3IwR2pyVnRhQ241ZW9xZGpTVW9mR0ZwUmJQRkpOb1RIczA1?=
 =?utf-8?B?WjQ4M2FudWhlUWtkZXJOSnBoQXIvaUFXU3V5V2JzQXdlbVZVbjBaWFJ6UkZX?=
 =?utf-8?B?R3YvZm45RzVSVkFqeG4wNGJIUnZSZnJFR2RDV2V6YjRrb2hRZVZmTzhTZm82?=
 =?utf-8?B?WjdGTmpGUktPbG5uWDRKc2R0dTRLdS9yaUppZFpxU0R6UzQzUFVodTFHeGpv?=
 =?utf-8?B?ZWxwMFRHR2c5bUJFS0VpM0loWk1WYk5BSU1MbmJWMUZOSGxCSWZ6ZVkrc2pS?=
 =?utf-8?B?NTB1R005YkJpYlpvUG1TZnVVOWN3dFlnVEVpTFpLMUhpN1pFMCtSeCs3Rkk2?=
 =?utf-8?B?QUlWdEsrUnVabDVPdXNYMDBDUWU1NVAxSVRFeUFNa0dMeW5wZDRkY0pmaS92?=
 =?utf-8?B?c3BuR1NTSXNMaW4yWnAvUCs3TW1zSDFzK3RVVDNUMmVTdnNJQkhROUJUV0Qz?=
 =?utf-8?B?UzlRYTY4VlRLNmgybGVFck43eVo0NjhsMlE1SXZTaDQyQzZTVmxvWE0zRzBZ?=
 =?utf-8?B?OXZwdXJJWGhJVXlKajVucTVmMjlFRFhhRFoxSHFKSFNVWTNjcXI2MThUUTk2?=
 =?utf-8?B?Z0I5b2hSNlREcjc3K2JyUVVQTXFGMW9iK0M5eXVCQnk2UXdwaERRVmhjQ1pa?=
 =?utf-8?B?eHJoYmkrMUFRcUgrQWJpNnV6Wi9uZ2QweitWTkFRUnBiaHpDOEpSZ1FiZnNZ?=
 =?utf-8?B?Q1JDdFREYmdQdWxuTDU1bWRmL2VoZFYwMUJRcVFNOTZiUXp0N2hYUmF0b21O?=
 =?utf-8?B?RlNKaUpKSUQ3Sy9hcU9XNk5XVGtGczRLUTZ5Y1lvUkN4eE1zS2lRczVEczhz?=
 =?utf-8?B?cHB4a3lYSmlhL2toV2xSMFhUVVNjRmRUaXhLS1BWYlpkOWgzZ1I3aVZkK0kw?=
 =?utf-8?B?S25pTGwyNjRJdzNVQjdUQW9BV2RKNTJzanluU0NDMzdld3ByZjAzbXJiZUZq?=
 =?utf-8?B?SU9mcGRiRTVqMFlmeWZ1ZSs5dFRrVnlJWG1qK3FPdTV4Q0djNWdoYnh1UjVi?=
 =?utf-8?B?c2ZLemNaNTRnUFlUZ1RrL051S2lJcGNtT1NtUjZLZzNpWE5zTDVIaXJzSHZQ?=
 =?utf-8?B?cXBpUWNTdVg3TVp6RlgrNS93YVppSUVKejdiYWo5K1M3dXU2SzNnSThtcGVN?=
 =?utf-8?B?MHFlaWQwdlpqREZlMUZnaTJ0N3l1Y014RERuSGs3d3Y3RlhqeGw3TktnNURR?=
 =?utf-8?B?NXFETEZuNTBkQVFEZ0ZLRys1Ny96RVRrT2Rnam56bE1XMXplM29ucXlWQWFs?=
 =?utf-8?B?OHpYRTV1Y2Qwd1hYYXp0TVN3ZjIzNSsvMGQ1MlFTOVBSVGwzYlFuNmhjZVd6?=
 =?utf-8?B?K1VXUU9XQ3VGVHY1ZEZXMURxNVQ5VlN3SUpILzhOVTVsNXBGUThjalBkUkJu?=
 =?utf-8?B?azU4ZGs2ZnJVMjVLcit6SGNxYzUvYU5PS21QVzd5QjdBOFE0VHVMYTU0bnZ3?=
 =?utf-8?B?bWl4VDZCMlBqMHVpN0pmWkNJdEZ4Q3I5eXZPbHJJc1kvNlE2VGtoNDRDRXNz?=
 =?utf-8?B?Rmh4WXNRbUhGd2lKbk14UmVUMlN2RzNtWjZOWHBtUzB4MDZrc0xjNTMwSnJH?=
 =?utf-8?B?MTVLZElWdlFlbU05bjk4TW9PVGVURWJraEltelpReHdia2pFUHNLM1UyeDl4?=
 =?utf-8?B?cGh1dHdpNW1leG5VZ3ZGZlREU05yVFZUSVlPZ2FVMnBNYUtYZ3ROcS9TdUcx?=
 =?utf-8?B?OS90TlYvYUFCSG81UTRXZG1xWkowWkNsYVpkV1FzM2dRMGdzcTJucDFrT2Nj?=
 =?utf-8?B?QndqNTBPS1ZZY1JYWFhXYkVBRTJLbGRYcVNqdnUzY2hwUjF1Zy9jYUVMc1Nw?=
 =?utf-8?B?OExCbGFCSVd4cGo2eWtvY21ucUlGeDJWbU5sd2U1MEtxK241Q3RwUWVGOHFj?=
 =?utf-8?B?K1RabFQxcytKcVUwVzRUZjZhb2cxYjZGV2xDSWgvYjh1NmRlTDNUZm5mVjBR?=
 =?utf-8?B?T0ViMzI1MWtjUXlYanNodXVHRGl5aENDbUJrOUhtV1pLZE0yZ0p2aDJIeEdv?=
 =?utf-8?B?M1cxejJ0a1RGL0pGYjRUdlNGOEtXdHF0TkZyNzVsNGtEQ2s1MkxvTXV1cDJO?=
 =?utf-8?Q?j8rYQgWct2AoPH6c64TUoV+ys?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pSNp7Re8Y5EUUMkRrrj9op+/ZJT4cRMcJEYdU6a+7MXM2vf+2mmmdEyOzQhuN+PFpNfqHmh8bQag0lEz/cipPX24542Oh5pzdfmmwwYWu3ajsnM7i0dy/awb67KAGxc34RHfZfTwBJDYpYk7C/NTAd5vEQAsjLzV32BxhsOP8X9dvpxaZYlVf4z6q9oVc6d0aY5q02O6aEgVwfezEz4BZcB2YhBwwfY2W2bWR4b2cg/85tt62PAYe0mmO54ymwVmlA9krfRZl1En2kjR/LI8GUeidJ+F6OOEUvneWiE4j0zGx4D7jUwp9HcCgwpOdWvyhTkD636bt7h1REHvtrlSIf+TnIo1MdNla3MckOM0A1OL/DdspqUDGxdLHV4/+X4CAVGCxnSapjp5Jh+Da6xc5iidJL7vlArCUh0JOFevkDOfyRv3diFePiB5c/y/xzKosnXXxChmVc13Un+Qc18eSLGGU9WvwTjnpNjoJgutrJ2T6eOvM6MKvoyKKSepGNz98lVD5TAXHOMx0mCbpvWGJlWKxG1S8QsoigT6LfVahpe4XMHHUXAFs7gAPaNVG1P1OwGWmsPoDMCNSu16Zgk+8cwsK2TyX/er8N6dl6UFBMk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164d7630-d031-45ef-c959-08dddf2d2dab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 14:32:09.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tg1PG7vUclizwuf2hOzf1X2XxJg34hlRh191uxf06b6EHllxVA4URfZm0rKS9ZFJRyt1ObmPiDVr2ujyYNdCTy0jtEn3Sxy7lIIyeOtY7eU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6885
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190135
X-Authority-Analysis: v=2.4 cv=fcOty1QF c=1 sm=1 tr=0 ts=68a48aed b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=KKAkSRfTAAAA:8 a=yPCof4ZbAAAA:8
 a=B2W1k0CDRJHj6MK_viMA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: JTmOa6qOKBDnT5okPoFw-uffJobQbeTP
X-Proofpoint-ORIG-GUID: JTmOa6qOKBDnT5okPoFw-uffJobQbeTP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDEzNSBTYWx0ZWRfX3dQ5OuMWx5jq
 bEbdn8uqhctk/ogYW7v60O6ALR6C6RGohAqQRUY+2ZN93Ncbkx4QcUcXh3cZOgP6aLSzmEbIjEa
 o+gpW5ViipAkRBbV3jwxNPlp4JLJW4EetklNXJ3OevHhvA2nZDKzdbaf4WmBs56HC8Gwx+kRYtV
 qhgx94Wk/6UI951BWq58/kfbLLVIt2cnY3Rny+uNpV3Tehl/ohP9kPtzuRl2l8rmx43EZzq2INE
 eWl+gS6FjUeTKKKXajzO8g3bCvReB86Z87vqg4NLD8PaTZ/BzVP1r4wgdB9WNAyzpPWhiX4Ioot
 rVlSsK/OyFVKV1PoyGfemk9tSHobChesS8CLha719JAgpKb88TnmRSej8dl5Lex0asHNkaSGFcI
 0rbmE31Iipp6KfNubRW991/mSxsW2/fuRKkTriOc/BIMsmIHbebf9/TuhcGwreOyhPjoVU3f

On 8/19/25 4:41 AM, Dan Carpenter wrote:
> Smatch complains that checking "folios" for NULL doesn't make sense
> because it has already been dereferenced at this point.  Really passing a
> NULL "folios" pointer to ocfs2_grab_folios() doesn't make sense, and
> fortunately none of the callers do that.  Delete the unnecessary NULL
> check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>   fs/ocfs2/alloc.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 821cb7874685..162711cc5b20 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6928,8 +6928,7 @@ static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
>   
>   out:
>   	if (ret != 0) {
> -		if (folios)
> -			ocfs2_unlock_and_free_folios(folios, numfolios);
> +		ocfs2_unlock_and_free_folios(folios, numfolios);
>   		numfolios = 0;
>   	}
>   

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
