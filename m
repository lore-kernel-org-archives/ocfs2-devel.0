Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010074.outbound.protection.outlook.com [52.103.72.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87533D6E6
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 10:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773309838; cv=fail; b=c3ECIc45hy4GJa4wWSngXnjoEtaWiVy9v65Xip0t/WocFPfX4Ud5+c0YSBJcjFg+KEanOnG4CjtsDwcYeY1BOTFbjUM9t9kmBSH281q4iIZC0BUkdXT3pxknaJAa/t65xH689nSallj//annF9gkzbOdMGZJMNGLxEoC6QbvkJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773309838; c=relaxed/simple;
	bh=IbXkzBUG5vpY+0T7JOy1olvZ1QOOwLg83oR3qW70JTE=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=JlR7ThtrGMMPZrqv0KpOuyAGjfdbcCGpdcsVClapPojsoqp/wwXOkJbpqP6OMUqlQf2UusHoH52KAdMDHAQgQEjhagnbSrU4zG+cPnv4fim0ruj5j/rTjNooq31EClV2L+xG6AC14EQcR+PwQUgUlrrQgHHUVatqdyiG3VnUns8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Fn0//Wt8; arc=fail smtp.client-ip=52.103.72.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Fn0//Wt8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKYyCIPcBBAvyP+Vox5vbJdrHxQEco7UOpjKAwbXI+rXc7wZQ5ydOLopXJboARX1+9U6R7rZNvfhGuxaLItWNsAeippwBWyS7QhtunjD0UOdd0QVjuDbX3ebhlJuHh9WXb6Wnbtoe/LZEuwlkBwW6LM4MOwtcaSnxRnu8wuPaITjVXyHHUXA/NbFjlsWFkKaX6ZVLDTegUBavt6t80oCeCNbBAgnbNVvDXtiXz/8LgrmRNP1H+q4CWmqqU9Nm6QcBZOVOIC16P2c2LryBHMP7NL4caGXjPacwn2JC0ReaR0gLcEONjpAmArRV0ZfvDfv3cpgGxAaVkkVj5WlNb1Lig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7vHXOjaBRtt697QGrlYiVi0QETF41nLiV01ZpKkhCY=;
 b=dsf0YcQafkjA4QIgWeRhCuid6e3xxiofF+1mpPJQ1oUqRHCKucWwXXPoposp1Ulavt/eYs6IdmLvEcPWPS81wT+3NF0xAN0G/4WOt1y6j96/LpgsnnALsz2VLrtPu9o9R7Q862bvX4QOAmWVor65p1oxPMjZQ4ix1Cv7gXV7ToHGSlR0FXv79ChF6Y3maqVPs1bMU0DYIzEsdJG7OgCV7pXNWsMQEsjJp1eI+7cIwsz11PwW3NRzMmG1JNRJNBc3dyV6HZUKFpLBf1ZZ+UeHqWEvjMHRt1UBaTRbq8gXRLZjtUziC/1H3g7LzFf0V7bePyybPUtWIwrOd9SNO8tSHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7vHXOjaBRtt697QGrlYiVi0QETF41nLiV01ZpKkhCY=;
 b=Fn0//Wt8sy5rE2X9PZt75NIt8teM3X5EjojqWoCoce+RNKr/ESLXC8cnlAGxlEyqGA+NxB/7voShcvA4ENKaZWfdDMNB1tWJtCRtrpDr7DHryYT1dytRbJz1aEtussFVBQ3a2ksaMTEDJDCuIlOGa0N+sHWAEnECAJ+ayKliPZFbx4qvqaLGQI2MPFmef2LWvJ4l6T/tXl1JYlUTMhX8k7Liso7vPQmhR9HPb8s2LEZfZx9PX+FEWS7zsEjkAAww5VxqyZ9B4+G8jeii4Rr+YruckrowvnYJYfyDUI516P2RuNn8NpiRPP2hvhlE1MoquTL2eJkKjuVkhrnn9MvnbQ==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SYZPR01MB7705.ausprd01.prod.outlook.com (2603:10c6:10:176::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Thu, 12 Mar
 2026 10:03:52 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9700.013; Thu, 12 Mar 2026
 10:03:52 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Thu, 12 Mar 2026 18:03:24 +0800
Subject: [PATCH] ocfs2/dlm: validate message payload length in query
 handlers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881890B57945C79BC03F31EAF44A@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0Mj3bTMitRi3WQLgzRTs7QkMwMzSyWg2oKiVLAEUGl0bG0tAKHVn5d
 XAAAA
X-Change-ID: 20260312-fixes-c80f56fb6069
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2025;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=IbXkzBUG5vpY+0T7JOy1olvZ1QOOwLg83oR3qW70JTE=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhsxN/fV+dTVvFDee+bN/w0O/6IcNjqfrQ4V41klMkNBOE
 Oq6qZzRUcrCIMbFICumyHK84NI3C98tult8tiTDzGFlAhnCwMUpABOp6mT4n7ksZePhxN40vTl1
 Su3XzM//Lniw2O6lbleNUADfh42brzD80wgUjrCfb2c4R2TahImV+71kbQSXO09+cdKuIsbD8gA
 7HwA=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCP286CA0203.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:385::16) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260312-fixes-v1-1-e0a1939ad4bb@outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SYZPR01MB7705:EE_
X-MS-Office365-Filtering-Correlation-Id: 698a1467-0c28-44a8-d5a5-08de801ea819
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|6090799003|19110799012|23021999003|41001999006|15080799012|461199028|5062599005|5072599009|22091999003|24121999003|8022599003|12121999013|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEUwUkN1UVBLbGYrQnczSmQzRU5sM090QTROcUY2RllTYXVqb0JNVUF1RGxU?=
 =?utf-8?B?dXQxMU9CQ1lSTVV5VVg5cHFGZWphS2ZMV20vUVpDOUJVa1JLekRiaUlsOFU1?=
 =?utf-8?B?Kys1Z2FzZEFPYW9Hbi9qMk85bkRwOVZ3WHl6M2huaXJ3V1RyQ1VTVnVlb2RK?=
 =?utf-8?B?TVY5M0R1UHdEV2czUHE5RDlGQlk1K1lOTWFuakl6UWNZVHJWUGQvajRCMWNr?=
 =?utf-8?B?bFFrSndxd0V6R1JwZVNLNWZlN3h4cS9HZmhaSGZ3UnJCeVlBNmlkUldvRmFn?=
 =?utf-8?B?VFUzcmhuY1NidkFSY1NJL1R0czJ1N2FXaHlyZkp4djlVcjlOM3NPYnF0Y0Rq?=
 =?utf-8?B?WE9zRCsxSVFoUktqdWFSWkJzUVF3U3NXTFd2Qk1sVE4rN3BBRXNRQUtvRGNN?=
 =?utf-8?B?UllCeXV4b1ZHeHJyVlJ5dUZ2ck5LMjkwUHpqQkIrRCt2TFNkZ3BvUGN0TlNw?=
 =?utf-8?B?d25aZnFJcU5KUlZwd2dsL08wWFROU1EvQ2hHZ29KbGRMY1RxS1hwdEtBSXVQ?=
 =?utf-8?B?RHdmZkZwNGIraDBUbXNhMU5pOXhrZFdFczVsWmdCZkpZKzBzc1VjMHZia0Fn?=
 =?utf-8?B?YlFldmQwTVdFdGtxaWkvYlpVZTJlR2h1RFpVQS9NTE9FNGdVTzFWZHY4RlhL?=
 =?utf-8?B?cVdHMHFWQVNSYXBtTUVPejhxTXJrUll0ZFhmZTZEditEV3ltYlNPelN1aWIr?=
 =?utf-8?B?OWJKaGljemFiNHdualdyTUJvbE9pY0E3ZmpJbnBURk85VkhsMy80YWpWNm9o?=
 =?utf-8?B?NU9ONS9JN0FrQnR4dmI5bVlLUTdUeFlOcW5OcWFoNVdGdERyNGxmYVhKV0NB?=
 =?utf-8?B?ajg5cEpKVWZsRmNlcmFtNWdQaG9EVmQ0cHc0WGhyWGVWMWZudmNjMnFET3Ru?=
 =?utf-8?B?Vm1SRHh0VE5lY0w4MVdUM3JJZ2hnUW5aTHcxaEdHdWtBZlhSMDh3bEtMeWJY?=
 =?utf-8?B?ellSOHE1Zy9DcWo2NXNFTVNteEs3YnB5dnJmc3VtVnRwSklUOGtCd1QvU25Y?=
 =?utf-8?B?c25RbVBWdmV0VDFPODRJaUNSMWNNQmNCRGhXRnVFUTBzTWFyQ0xRSTBObUY1?=
 =?utf-8?B?Qks4SnN0NWh1NzFGSk5UbHMreG1lK3Nwc3NWblRWOUkwb3NzVmUxOTVpSDdC?=
 =?utf-8?B?d0IrYndYSm42U0dYMWgyV2FRbkFpNzFIelpGdUpVc2JORUhtSGZmTFNoTzZ6?=
 =?utf-8?B?d09MWFBJaXVyVFpQdXhHampqRFBUS05WcVpZL3Y3MXpac1lwcmRBU0xZbTJ5?=
 =?utf-8?B?cHdRbk11RTlQSUJKNmhieDhadVFqdmFLS2dEM2I1QjkzOHhvU3FxVmlUV1FR?=
 =?utf-8?B?RXRNTjN4UEdycGFXalMyRHczTjZBVnVuUFM5VlRnNHZjU2dDVkRUT015akJJ?=
 =?utf-8?B?WWl3ZERLMnUvSTBJUmNXcWJhOGR2Y1FOSGUrcWJXWVFrRTNXRkNVaWJJOEJD?=
 =?utf-8?B?VjZkRFVtVkFjNm5VUGNTR0NZeElLYUd5UnA0cnBRPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEllN0xzQ1VxSENQTU54cWFpb2lEREJlS1RzWU5mK1ZSZ3hhTENLcDQ3c2hM?=
 =?utf-8?B?VUNuanRNbXllNTEvbm5LV2hJOTloMDFVNlRpMjdHZUpveXFwNGpydzFBbGJP?=
 =?utf-8?B?VWI1R3UwdTczY3pMQXlrM1IxRXh1cXdBVlFYUWpEdDVLaGtzUHlhSjNQUFdS?=
 =?utf-8?B?S0ticlc0cDd2eUprcUp0dVJ0NUJPbnozQjFkdmVKeklROE01UWVYNG1rZ2ky?=
 =?utf-8?B?Y0pmbmxkRFNoeUF5bmZJRFpCZ1RHQ3c2WUJoSUJQVEZIVHoxclNIUUk1clhQ?=
 =?utf-8?B?QVR2WHNxeHByY0x4Sk9PSGp3c2pqMU53YkJxdkZvTFJ4cVJKNU5ScUpIeW1I?=
 =?utf-8?B?c3B3UFVVdE16YWZadDRTdVZOaE5weFN3OWVMcW5pSUczeXVNaXZSQnc3VEUy?=
 =?utf-8?B?dnN5cmhUV3BPWHk2NGp2VkdzTm4xdWRjeGVIMUMzNmIyU1ZTSTZkL1hwaUJy?=
 =?utf-8?B?NmNjOXpIaTRJaGRFWDJDWDRaaCtjbkNvcWJ4RVhWVUZ4M2RGNVdTU09lYUxn?=
 =?utf-8?B?RG5NNUR4Y1E4YWVtN0dRaFNOb2dZRlYvRHhqaGRNN0Y5S1V2YkhYZC9PMnV5?=
 =?utf-8?B?WU9SR0ViVGNvQlpjUzFZOFB5Um1tUE1Jekg2Q3lCZU5GcVI2MU8yUGlyT2dv?=
 =?utf-8?B?ZmxUYVh3bVEzbVRtMmJBMGpTWm53a3RCMUgyMUROd0FVZGVyaEVWZm81eWQx?=
 =?utf-8?B?WXMxdmZKTVNLR1BuejZxZUZVSVl6ekxKd05qckNlc0hSeFpDamFTMmhqNjFp?=
 =?utf-8?B?UXN5c1lRUU5rN0RwUW55djRKVmdtQ3lXN3RmbTZENFh6NFJZOG8vZndnTGtk?=
 =?utf-8?B?L0k0NkZ2M3FyZnVwbWFCVy9BcS9XQ0VSUlJIRU9mMm52aHhaS0FsNnNHS2dz?=
 =?utf-8?B?MEc3eTRBTDltZW94alV2RFdQSEpwbHhha05IZUV6cGpGSkxlTzNaR2xFOFVm?=
 =?utf-8?B?Mjc4YTZtRVpFd085cG9ESDJVQWF3anZYTG02VHV0ekZLNE1YOWtHc2w2SzNs?=
 =?utf-8?B?bVFpMFVtQlZSVyt1QjNqaHU1UCsySWZwZWgxakN0U3dJSFJmakFBMjVzM0Jl?=
 =?utf-8?B?WHpKeW9JRlJ3Q09HQ1JQVlZDbmh2NFZBUUpWQWZIQkVwaEJDcm9hb3hBOEVZ?=
 =?utf-8?B?eGd6R0hrNkw0MnBwTmJsY29KSXJwbVdNK3BJUzVKb0I4MC9Rc0ZScWR3YVhW?=
 =?utf-8?B?MDU3NUdxM0dKTFJIUVgwVXZTTnBBUFdHWENwWnd3K0tRVXNqTHIrRUJYa21T?=
 =?utf-8?B?YUlnY1E4MVc2enhvRjg5RW13bTVaWkNVdFVpWXB5bHZLNTEwL1dwT3c0emc5?=
 =?utf-8?B?WC9sWXQ2S2RCQUlNUkp3MUpqNmg4S1ErVllhWmkyc0UycXoxeFJDa2xkUzda?=
 =?utf-8?B?THlDWkZlVkxjV3dxUStBcFpqV1hubHprT3R1VWozdjBNUU9EbWs5eDB2emkr?=
 =?utf-8?B?NU9ZUHVwRXZMb29kajlSVjRtVmppOHB5ZVc3YUR6YkFUNHJBNEJVN2cxYzRL?=
 =?utf-8?B?WW1pZm85dWxyWkMyTzUyRm9rRjZaaFVzVE1sWndXYVB1azl1SmZnYXNrN1pU?=
 =?utf-8?B?cW4zTUdDVzBiZWp3T1hVckZxQkJScUpsSllRUmsyQmlyOEhMTDRvN2tuZ1FE?=
 =?utf-8?B?MTM2Y3UxdU5QN05jUWlIWnVnSzNKR0EwUDJvZFJHSWd1ZEl1a2FLUkFVMjNU?=
 =?utf-8?B?UmZIdTdPWFYxOWM5QjIra3NVL3hMYVdESm15U280bHFvY2hFcjRjbkpDNFFo?=
 =?utf-8?B?WC81Z2JLSnQwKzJJdUl5WWdWRDJ4MnljYi9SOVdSTyt4ODYrVkY4TzVVMjlm?=
 =?utf-8?B?djVZNU9oMFIzaDZTM0tzNHMxZ0RPc0ptRWdXZ0xsVVBhb3lTVXhzamhpVHNu?=
 =?utf-8?B?Yi9TZUtyN21meWpQa2ppc0plTVppclBGcUdsK2pxTkpqK3c9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698a1467-0c28-44a8-d5a5-08de801ea819
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 10:03:52.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYZPR01MB7705

dlm_query_region_handler() and dlm_query_nodeinfo_handler() cast
msg->buf to their respective structure pointers without validating
that the received message length is sufficient. The o2net transport
layer only enforces a maximum payload length, not a minimum, so a
truncated message passes the network check and reaches the handler.

This causes out-of-bounds reads from the receive page buffer when
accessing structure fields beyond the actual payload, leading to
operations on stale or uninitialized data.

Fix by validating that len covers the full expected structure size
before accessing any payload fields.

Cc: stable@vger.kernel.org
Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Fixes: 18cfdf1b1a8e ("ocfs2/dlm: Add message DLM_QUERY_NODEINFO")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 70ca79e4bdc3..07aef9ae8cbe 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1100,6 +1100,9 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	char *local = NULL;
 	int status = 0;
 
+	if (len < sizeof(struct o2net_msg) + sizeof(struct dlm_query_region))
+		return -EINVAL;
+
 	qr = (struct dlm_query_region *) msg->buf;
 
 	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
@@ -1276,6 +1279,9 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
 	struct dlm_ctxt *dlm = NULL;
 	int status = -EINVAL;
 
+	if (len < sizeof(struct o2net_msg) + sizeof(struct dlm_query_nodeinfo))
+		return -EINVAL;
+
 	qn = (struct dlm_query_nodeinfo *) msg->buf;
 
 	mlog(0, "Node %u queries nodes on domain %s\n", qn->qn_nodenum,

---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260312-fixes-c80f56fb6069

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

