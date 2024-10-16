Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00185221
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729058271; cv=fail; b=XWcU8ZWGWNpSU3eqN1o/RbHyI2puWeWmTHeoJ/5UFCQuRRBrQp0b4E8DtLNZC/1oG5p7g03ujPj8+7kJr5QUlZ5qpNF+IYjOyWYwhoGIwGgCdzwQuA10TDa4QTVzhY0hjxTuXc15+2xWZ53Cxe2myvsmJz6j4rRyANCmhraaiJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729058271; c=relaxed/simple;
	bh=fee6W4TPmZD8O40vMiq6gWQzqMApadG4iylunGtiYYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jrU8gLjcoFIbTowGKvQCnmco2i7wuKzWffE1JrNkmFTEmHKECNp8AS7yaDjB+fnahjH7VTc5HTKUNLmDS5UWYvCpi+qc9UzFjLlepL47kTWav7+Me2GzYodi8H1aR3rjXfFvYcbyYRshCzVVyZVfuSuPvfciyJ9k5zKPGJDwU9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LKJ0LIrm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V+v8eL90; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LKJ0LIrm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V+v8eL90"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2McAF016605;
	Wed, 16 Oct 2024 05:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fee6W4TPmZD8O40vMiq6gWQzqMApadG4iylunGtiYYw=; b=
	LKJ0LIrmvcnn65Cj0Qh0Lqka29Vn3kjygGaEJQfJAcNA7WOMajVweUwleP1wVpLy
	xuhYdaNY5oZAlVKSkTXUKkZKQNLYLuckwDP42x0+OL1sssy3V5WPWrBrMP1B7Hjw
	47o6wNCkAN1uxCn/rJjQeBUm6jZxOT393N/K+FWqlFr80kFi/8+8qCjkb7ht/Iep
	7x8dBtN9A3iSNh1j63n8IaY20Z6evhBFQCiDpgZWmXeXYGzRlLhOZ/4MZrAlm7Xq
	e5x8H4aKJBp/5CGk01IRvvjT8z7XQhvU3AH8qxaHiIGSTqFjYGYpjiT0sea+ndSs
	OsUc0UY1AgdF8V4+tlAyDg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5ck7tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 05:57:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G5RPnR011318;
	Wed, 16 Oct 2024 05:57:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjepc98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 05:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkAK+TMFqOnJayV7BV7rRkbDpCsfxSIlEfYW9bodOYNwp4iapnsv4i022DG4gFqTBqnCHrolC1LOfRZ+SDCXhUYY39cmxZKrDAJwA/ojEd3gEFjBKBruzsV9eI9Ytsw/JfFZDQePMkUapl7w873idBtM5rmFGP0EJFxuuHqY96lWL1S52e2363Y+6+ugpINTf5xuc7gyLUixhsufItvRuJQThhBshZ/nICugwKfOUeZJFXXAH9RLokreK7anKkAq8zHb3uGH+UH01bnAcLTpylq/xabsngeaKihAwz4jEZnVch+DQI/UQaCMr7dAsjE3yBJ9BnKk9Hz5gcP9bJvm/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fee6W4TPmZD8O40vMiq6gWQzqMApadG4iylunGtiYYw=;
 b=W1qGSQ0JnnRphLp4Fn/laS5KrmTOaazbuN2aprBuNE78vrw0P+rew+MGye4CGzhhxSjLQywXZDGf/AXfe8xFcc4hUHhfH1Kfv7YozX/S5GDiU0JuNZsosqskbvaP7HQj16OTAZmWp6i8F8sIHvWu2D7SmfD4UEcObaYQL89m8hlWy4CVGMicXbtpv0ewAwxlXBY9VyQ8ziSxJsUtuwy1a0JnNy/Lk/5YE7/Uo9Z0gxuY3Y3eALHDi6RS1wtMEEXj2zjT5uaN5aKQXpsz1BvygI0VPwNgrczoD0L5MFuCUwleEoJey1y6ai9UBJh0ETPHUa6TwoI4JKc1jWwi87ix8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fee6W4TPmZD8O40vMiq6gWQzqMApadG4iylunGtiYYw=;
 b=V+v8eL90i4XsM6qmDKkK3F/5aHwFh1ekyhw94BRdYDF2IV0ER+8Z2hiF1SBHCBoNUPoyzTqEU5JqhxK9D1CvxzldrjxXDA5Bj9720tiNI5UQvvvqe34fu6Fm4NDRp1V0w4hA6sleb718Z3CMGX6i5huxzUAEDgMiFKctUT35+hM=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 CH3PR10MB7494.namprd10.prod.outlook.com (2603:10b6:610:163::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 05:57:40 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 05:57:40 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>
CC: "ghe@suse.com" <ghe@suse.com>, "mark@fasheh.com" <mark@fasheh.com>
Subject: RE: [PATCH RFC 1/1] libocfs2: fix non-zero value in Next Leaf field
 in the rightmost leaf metadata block
Thread-Topic: [PATCH RFC 1/1] libocfs2: fix non-zero value in Next Leaf field
 in the rightmost leaf metadata block
Thread-Index: AQHbHxzbe6k2CmED2U6a8elAGPGQKLKInb+AgABEXeA=
Date: Wed, 16 Oct 2024 05:57:40 +0000
Message-ID:
 <DS7PR10MB4878C389A9A97B368916A9B9F7462@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20241015161109.156497-1-gautham.ananthakrishna@oracle.com>
 <e028897f-eb29-4bc9-9b2e-fe102810fba5@linux.alibaba.com>
In-Reply-To: <e028897f-eb29-4bc9-9b2e-fe102810fba5@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|CH3PR10MB7494:EE_
x-ms-office365-filtering-correlation-id: 24153157-3d54-452d-372e-08dceda771b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bW1wVFZXeGVjSHhWQ1NyS0VOZXdhbEpJVnlOdE9kMGJ5d2xvV2orWHNKb2tx?=
 =?utf-8?B?blljdytkTlkySFFkVEtiakQ0aHZTZkZQNzFoUnpjTmgydE9IblJOTHR1aXJx?=
 =?utf-8?B?dG52VnZmSHdXdmttc1p1d2ltN1FWK3hGTWFRMFRTWURaRGdRYkFHUTV0ekkr?=
 =?utf-8?B?R2FGZW8zNCtCNmY3Q01pK3JQQTgrU25hVXVET1VCZUlYRlpYNVdwVUtiZDZa?=
 =?utf-8?B?cjRybk9OczlFNjQxM1VGaUlmM3lQSVRRSmlya2JSVmdHVldjUXl6empjamxK?=
 =?utf-8?B?RENmcVNHN3k4Y2JZMXZaQzJJL2pGRFVyRWNQSDlBdXdiWERBNEt2WSswSWd1?=
 =?utf-8?B?NnViOHJEcUJGaEhHdVh4U0IyRmp2WW00MVcrQ0lUanh3RHJNT3JKaGZFSXlR?=
 =?utf-8?B?L3VFUzJpc3N3Wk1OZWZHZWp0UTV1Vy9Ra3FadkM4UzlMS1lVb0VzSko3K25O?=
 =?utf-8?B?TWVEd0JEUVY2WVlLbkZUR1F0NDYzdW9XMFpGdXkyb09UYVdlRmlXTmlMZkNn?=
 =?utf-8?B?cTh6cG5wNTg4U1I1aXY3bXhvQXlVU2xzSWhvRFc3Ym9Dc3YzWkw3Z3F0SDBW?=
 =?utf-8?B?dTVhOUw4RUJKM29NTTlqYUUvUFlJUjFxdU53aEZMaE9GQnBNSWswdkRzSHlm?=
 =?utf-8?B?ZVpNSlVYL0ZtS3dYaHVlVURLKzBIbWJNU0hwbUZxMXJZK01vN0xvWmU4SFZG?=
 =?utf-8?B?QUp0NzRoNmRjMFMyeEF3emxWMG0ySnR5U3N1L0xrQm5WZWU4b2hYTnBZVCtV?=
 =?utf-8?B?NitsamhVaFFyYnM1dFBMdlBiU3NrNFdSVUpnL1Z3elNQNWJIS05Pd0VNeFdF?=
 =?utf-8?B?SnBKQ1NDTisvM1VpUnJNVFJSZzh6RXErd25iNWJ1VEMrRUg4akNtZm54M2xH?=
 =?utf-8?B?YnE0bUVsS3lBaFA5OXVoU21SL1hxTnRUc05IeG9xNy9uMkZEbnRGR3RMVjdR?=
 =?utf-8?B?Q1RtM0h4NmpWcXN6Y3R4ZHdaQXNwTlB0c095NlU4cXpqbktMSTU0QmpmQ1Az?=
 =?utf-8?B?b01nZm52OTRDWVRVVjBKVUVXVmhGNjBISkw0LzRXdmNaS0w2Z1U5dVZtdVRr?=
 =?utf-8?B?YmI5QjIrSnpsekxqNmFkSm9jNWhaZFA0NjFSWVhtaGdaTThaR0lINXdPUDR6?=
 =?utf-8?B?MVZsR2hZVXZKb0RuTjFoc0x5UTl4S01QK000UjdlMU02WVVxNkJyZ1pnU3Jn?=
 =?utf-8?B?RHV6cTVSQ25NcFdTYXp0djdPMmhwd1VRZ09aUWlQSy9MZTJKaTRjeGwrZHB3?=
 =?utf-8?B?cjJkNld5M0dHdlFRMjNUakIxOVY3eHVuNnJYY2NlSUU5WVhYak5tSTRtU0Ft?=
 =?utf-8?B?a2ZhWFZvTWpJbjl2ZmR6bmNTWjNCQVJYYVRIeVBHamNORi81ZFZmSDB0dVdW?=
 =?utf-8?B?Z2xXSEpjckd5U1czdy81Lzl5V0czb05SZkM5a0N5enZrWk1EVXlTbkZTUTJH?=
 =?utf-8?B?VkNZbC9SSWo2Z2s5ZzBuZkk1dzVtQUFXSEoxN2ZCc1BXdmoxblVOMWJIMlV4?=
 =?utf-8?B?WVgyZ0JRdXRWbU9zcE9SR0VyUUFCeHE1RXZSYkJlWE5EdFlxMlJvNWc4L2Zr?=
 =?utf-8?B?SkdyTG5UQ3krR1oyblZaVkJzRVZPeURQcUJzTEdDTFdyeU5NdmtwTEgxODBK?=
 =?utf-8?B?YVZoRDhDdWF2RlpNS2V4b3J3SGIyUjk5QjNndnZSc0RSS1hFaGFteGdySGc3?=
 =?utf-8?B?L3BnZ0srNnIrQ1BvOE5OSlpwV1pKWVluR09iKzdCVHMvaVBVekFWZ05ldS9k?=
 =?utf-8?B?UWwybWhRaUFieGk1OHZHZ2E5K1dOb21uZmIrT3JTcElFUTZKVUFwQTRadEVD?=
 =?utf-8?B?djk0QWpHYU01WVlDdmR0Zz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R05haVQxOUNIMW83NEZ0RGxTeHYvZnJONUN1d2wxSXFieS91ZE8vQWlrQk9T?=
 =?utf-8?B?WVU2djZ1TnBVNGNXbG9scmFQZHk4QmdVdHI1VnJKODFGS2ttdDVpZTEvNFBQ?=
 =?utf-8?B?YVRMcFBMNmpOTE9KYW5ucnBCYXZLbGlUdTZtQjl5dEthNTJ4dXpNS1lRY0Yz?=
 =?utf-8?B?b3dVZzJXTjVMeHlkTjZiQXNnN3VwVXFzUGNhcmNiU3ZTR052d0MrMmtWc1k1?=
 =?utf-8?B?Ky8rTjRpcTFSODRaSUhYM1JzTHRlOTgrSXhiZ0NQRUx3eFRrS1VXaVdLV0hz?=
 =?utf-8?B?ZVVQbm92ZmFSMHBrekk0KzJrczJnUnhuUGxhT1RCRFNLZmJ0TXljaytHZTFE?=
 =?utf-8?B?S0h0bXd4V1k2Wm12Ti9PMC8yL0hTRCtlSGZxVGxtTm9HdENjQ2hhcE02MjU2?=
 =?utf-8?B?WGhmOEpzVUEva3hJTTdNaGJEUFN6MzZsV0FjYzR0UUE3QjRleFpKSUpHYyto?=
 =?utf-8?B?UWYrK2xLRmV4cm1weWZtMFErc1lLQzFXeVBkN3Q4a2s1Y3V1bmU1TXRaZXRE?=
 =?utf-8?B?UEIrWjZVbUZick81dG1uNTFtY1lLTjV0MzNUeGdKK0NmY1ZXaUhkQzFuWXhz?=
 =?utf-8?B?TlY3WWw2cER4TE5yNlBXb2xlNkY4UkpJWnhNNVNvMlRwWWRlSEpscW1abVc1?=
 =?utf-8?B?MU02bk5VOXMvUTk0amR4SnpOYkZoekp6QlJDbE9xaXg1TFZWYXFqRjV0S1RS?=
 =?utf-8?B?WWxMcGFZTE9qR0tZeUZkZ3NTbW5HeXV1VmRiNmwvb2hCcUFVTTU1akpYTy9L?=
 =?utf-8?B?SVRSUjFndTRyaXl1dktNNmx2cnNLMEtBU0FXcHBwK21mODcvb1EzM2kyZVln?=
 =?utf-8?B?ODlobjdYdUdZV0VvV1dKR0ZCQWxNcEdXbDBGSUVIR29CUUxqc1VKZlFMV1ZE?=
 =?utf-8?B?WlROL1FqVGVaZGtGYldBckl5RGsrV0F1NmVMMys0c1BzN0FYL3NtNVp4aVJj?=
 =?utf-8?B?MGZGY29LSVhkMFIxY0xUZUJ3VFMwZks4UTJ6Q2tseFlEOE91TGI1MG05ZEVn?=
 =?utf-8?B?SEMvMXRRUWFsaVdBenV1bUVRTll5NlRaemJUczFxclYyV0JmL29qeUprYnlH?=
 =?utf-8?B?SWlwdmtoSUk4NExLUE1xMDAvWWdrRVFIMDNzTy8rdTV3c0FEMmNYQTZxRnpK?=
 =?utf-8?B?RTFWR25GVkhpNTNOQ2pqZEV6VXpWVllhMlJybjhnaDBZTTJDV0lrUm5qZWcy?=
 =?utf-8?B?dmRxZUplamJQczNTL1R6WWYxL0NPbjlCemRwM2M1MndMcDlNclRjM2dVODNQ?=
 =?utf-8?B?RGZxcjlpQVB2Vnd2YUhlTWxMeElncitpSU15UnZvdi93TnFxSVJYQ1FuMkEv?=
 =?utf-8?B?RmFmdW1YcnRreG90alpwZjZYczhmSUZvL0VFaTRnRTFlTzYvNHJJbU14WXdF?=
 =?utf-8?B?enVWNmxKY2JYYkt2cXd0YUwzZWdsV1BpSnk2bysybGEySGM2MU5GVWVkenRw?=
 =?utf-8?B?b2Y2eDVVZngzM3ZkQjJvUU42MGVDZFBKTGcrdjVRYm5rVnlVMmhSMWhOcUZk?=
 =?utf-8?B?QkYzelh3MFRvSGwxV0Q1cVhnQ1lJc2J0Z2RTMGpYbFM1N2NPU3o4YU9PRUZN?=
 =?utf-8?B?QXFZVVl3d3IyMHVEYjEvTnhqd1BscmFiMC9zUHE3bmJzU1NVMUpJOGkrdm5m?=
 =?utf-8?B?K0FRQ1FuVXZJOTAwaG16UmNQRjFRNXpHUVd5TGduR0JjQ0ZYNVZqR2REMm1h?=
 =?utf-8?B?RWtWMklxS1M4SngwU0cvdXpKTUh0cmdWc0lLQXZ4SG1LS1RLNTdPOHVzcGJG?=
 =?utf-8?B?VkxaK295M05iWlZSYlExWU9SNDMvVlpsUTkyL1UyTUgyVzhENlRMU29DY3pO?=
 =?utf-8?B?SjRKZEh1bzJESlI1eEdKblEzYUk4bWI3cTN1dUNTaGc3c2VDU2pUUkVzK3Fs?=
 =?utf-8?B?TG5Sa016NndpZWlhS3ltb1ZmdU5pVXoySTZZSjRLNE1JL0lQYU5NbjI3eTlJ?=
 =?utf-8?B?YmdRK0FrTnJHOEFGUUFzTWZNcVFCYXN4ZjFXTlhFSExYZUUvWUtBU3JLaThp?=
 =?utf-8?B?R3J3NmQzdXd2SHFzMmVVWFMvWGxGSUZrYkttSnNqZTRTSDAyNzNFV1RGbklS?=
 =?utf-8?B?Z0cvdnVtamhPaS9BYUEyM1llY3Z2dTR3Y0dDV1FFUElPVHk2QlNEa0xVcjlh?=
 =?utf-8?B?Nk9NK2ZoUFVPZlQyVHJyemRlck9lSDVkQ2wyZXRRTmpNZS9uVElxQlZ0ZEFL?=
 =?utf-8?B?OXc9PQ==?=
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
	tfk/FkOra6TCL3hmpe0QffyOaO5eyBM7vqmOES8HsHJO7M/RxgpUOhiHjHUyeNwYSTp1v0uH11NcPkrgcud1vDa3HXnYCjyp0XentYEHHWbXK0+eVnYFICrF1MGqWjsK6smG8FI9J9HgniI6PxC4CQ2WhOWVvgUL6zhWDLbh6Ml1Gas99r0jDqqoAk71aSkOvpp83fzwOSFLik3J3mx6BMYEAg2jKLyEatUK1nfvboDiCymqrlpEuF91SGCBqpJmAYgCuwAK079fXWo+GnsZQVKOeOcxQKzUUxVvYljw5SdiU1LfwRvYripqqMzkcLWGcqXyz7mmxwrV5h/QVVlvWTV7HQZ8DINmltO8jKJj5nN1LmrUbDGiSGTV0aQ0G26U379bMd/cNhxPYd62sMiE1Cmn/f0vopk7AjI1Rm1zNzF93J2dGXnbrb28WPCA75GRALo6W3URSN9rAyd5Ydjti7l061QdFRJxB1RofIS4jl55kttCL6fan24io2faFabIAqSlUiAo2T0f1Kha3xFtUMqd8Q5+8oif/i3//vBCuWENfbroFYdR29wSB5YxtP6c5L4HfhDQyHMsKzE+vVG2jtNO0yjlXX8lpfS1Dv2DTAc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24153157-3d54-452d-372e-08dceda771b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 05:57:40.2674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OO5LMiPhJk8qWKMI0Xq7xNRI7MD8Cf1lnZ3NRSXjgwVIOw9d4XQStoWM8Iv7ze6+SAL9NWTSSclbteBkzubL/MigmrcSLflFowSNgcMEGabsoLUefNRdahZPPHmEmdBF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7494
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_03,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160037
X-Proofpoint-ORIG-GUID: YjMMqPNrGOjVHnvIQsdcmBFZD9g3kEU4
X-Proofpoint-GUID: YjMMqPNrGOjVHnvIQsdcmBFZD9g3kEU4

VGhhbmsgeW91Lg0KDQpJIGhhdmUgY3JlYXRlZCBhIHB1bGwgcmVxdWVzdCBodHRwczovL2dpdGh1
Yi5jb20vbWFya2Zhc2hlaC9vY2ZzMi10b29scy9wdWxsLzY4DQoNCkNvdWxkIHlvdSBwbGVhc2Ug
cmV2aWV3IHRoZXJlLg0KDQpUaGFua3MsDQpHYXV0aGFtLg0KDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4g
DQpTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTYsIDIwMjQgNzoyMiBBTQ0KVG86IEdhdXRoYW0g
QW5hbnRoYWtyaXNobmEgPGdhdXRoYW0uYW5hbnRoYWtyaXNobmFAb3JhY2xlLmNvbT47IG9jZnMy
LWRldmVsQGxpc3RzLmxpbnV4LmRldg0KQ2M6IGdoZUBzdXNlLmNvbTsgbWFya0BmYXNoZWguY29t
DQpTdWJqZWN0OiBSZTogW1BBVENIIFJGQyAxLzFdIGxpYm9jZnMyOiBmaXggbm9uLXplcm8gdmFs
dWUgaW4gTmV4dCBMZWFmIGZpZWxkIGluIHRoZSByaWdodG1vc3QgbGVhZiBtZXRhZGF0YSBibG9j
aw0KDQpIaSwNCg0KVGhpcyBpcyBwYXRjaCBmb3Igb2NmczItdG9vbHMsIHNvIHBsZWFzZSBzdWJt
aXQgYSBwdWxsIHJlcXVlc3QgaW4gb2NmczItdG9vbHMgZ2l0aHViIHJlcG8uDQoNClRoYW5rcywN
Ckpvc2VwaA0KDQpPbiAxMC8xNi8yNCAxMjoxMSBBTSwgR2F1dGhhbSBBbmFudGhha3Jpc2huYSB3
cm90ZToNCj4gT25lIG9mIG91ciBjdXN0b21lcnMgcmVwb3J0ZWQgcmVhZC1vbmx5IGZpbGVzeXN0
ZW0uIGZzY2sub2NmczIgLW55IA0KPiBzaG93ZWQgdGhlIGZvbGxvd2luZyBpc3N1ZToNCj4gUGFz
cyAxOiBDaGVja2luZyBpbm9kZXMgYW5kIGJsb2Nrcw0KPiBbRVhURU5UX0xJU1RfRlJFRV0gRXh0
ZW50IGxpc3QgaW4gb3duZXIgNjU4NDM1IGNsYWltcyAyMzEgYXMgdGhlIG5leHQgDQo+IGZyZWUg
Y2hhaW4gcmVjb3JkLCBidXQgZnNjayBiZWxpZXZlcyB0aGUgbGFyZ2VzdCB2YWxpZCB2YWx1ZSBp
cyAyMjcuICANCj4gQ2xhbXAgdGhlIG5leHQgcmVjb3JkIHZhbHVlPyBuDQo+IA0KPiBkZWJ1Z2Zz
Lm9jZnMyIGFsc28gc2hvd2VkIHRoZSBjb3JydXB0aW9uOg0KPiANCj4gICAgICAgICBJbm9kZTog
NjU4NDM1ICAgTW9kZTogMDY0NCAgIEdlbmVyYXRpb246IDk3NDU4OTM4MiAoMHgzYTE3MGRjNikN
Cj4gICAgICAgICBGUyBHZW5lcmF0aW9uOiA0MzI2MzE4MDQgKDB4MTljOTZmZmMpDQo+ICAgICAg
ICAgQ1JDMzI6IDAwMDAwMDAwICAgRUNDOiAwMDAwDQo+ICAgICAgICAgVHlwZTogUmVndWxhciAg
IEF0dHI6IDB4MCAgIEZsYWdzOiBWYWxpZA0KPiAgICAgICAgIER5bmFtaWMgRmVhdHVyZXM6ICgw
eDApDQo+ICAgICAgICAgVXNlcjogMCAocm9vdCkgICBHcm91cDogMCAocm9vdCkgICBTaXplOiAx
MjE2MzM3Njc0MjQNCj4gICAgICAgICBMaW5rczogMSAgIENsdXN0ZXJzOiAxNDg0ODAwMA0KPiAg
ICAgICAgIGN0aW1lOiAweDY2ZmE2MGQ4IDB4MzQzYWNjNDMgLS0gTW9uIFNlcCAzMCAwODoyNzow
NC44NzYyNjg2MTEgMjAyNA0KPiAgICAgICAgIGF0aW1lOiAweDY2ZmE1ZTVkIDB4MzQ1MTRlZDgg
LS0gTW9uIFNlcCAzMCAwODoxNjoyOS44Nzc3NDM4MzIgMjAyNA0KPiAgICAgICAgIG10aW1lOiAw
eDY2ZmE2MGQ4IDB4MzQzYWNjNDMgLS0gTW9uIFNlcCAzMCAwODoyNzowNC44NzYyNjg2MTEgMjAy
NA0KPiAgICAgICAgIGR0aW1lOiAweDAgLS0gVGh1IEphbiAgMSAwMDowMDowMCAxOTcwDQo+ICAg
ICAgICAgUmVmY291bnQgQmxvY2s6IDANCj4gICAgICAgICBMYXN0IEV4dGJsazogNTM5MTg2ICAg
T3JwaGFuIFNsb3Q6IDANCj4gICAgICAgICBTdWIgQWxsb2MgU2xvdDogMCAgIFN1YiBBbGxvYyBC
aXQ6IDINCj4gICAgICAgICBUcmVlIERlcHRoOiAxICAgQ291bnQ6IDIyNyAgIE5leHQgRnJlZSBS
ZWM6IDIzMQ0KPiAgICAgICAgICMjIE9mZnNldCAgICAgICAgQ2x1c3RlcnMgICAgICAgQmxvY2sj
DQo+ICAgICAgICAgMCAgMCAgICAgICAgICAgICAxMjkwMjQgICAgICAgICA1MjU4NTkNCj4gICAg
ICAgICAxICAxMjkwMjQgICAgICAgIDEyOTAyNCAgICAgICAgIDUyNjg4Mw0KPiANCj4gVGhlICJO
ZXh0IEZyZWUgUmVjIiBoYWQgb3ZlcnNob290IHRoZSAiQ291bnQiLg0KPiANCj4gVXBvbiBydW5u
aW5nIGZzY2sub2NmczIgLWZ5LCB0aGUgZnNjayBtYW5hZ2VkIHRvIGZpeCBvbmx5IHRoZSByb290
IA0KPiBtZXRhZGF0YSBibG9jayBhbmQgdXBkYXRlZCBpdCB3aXRoIGEgbmV3ICJMYXN0IEV4dGJs
ayINCj4gDQo+ICAgICAgICAgSW5vZGU6IDY1ODQzNSAgIE1vZGU6IDA2NDQgICBHZW5lcmF0aW9u
OiA5NzQ1ODkzODIgKDB4M2ExNzBkYzYpDQo+ICAgICAgICAgRlMgR2VuZXJhdGlvbjogNDMyNjMx
ODA0ICgweDE5Yzk2ZmZjKQ0KPiAgICAgICAgIENSQzMyOiAwMDAwMDAwMCAgIEVDQzogMDAwMA0K
PiAgICAgICAgIFR5cGU6IFJlZ3VsYXIgICBBdHRyOiAweDAgICBGbGFnczogVmFsaWQNCj4gICAg
ICAgICBEeW5hbWljIEZlYXR1cmVzOiAoMHgwKQ0KPiAgICAgICAgIFVzZXI6IDAgKHJvb3QpICAg
R3JvdXA6IDAgKHJvb3QpICAgU2l6ZTogMTIxNjMzNzY3NDI0DQo+ICAgICAgICAgTGlua3M6IDEg
ICBDbHVzdGVyczogMTQ2NDQyMjQNCj4gICAgICAgICBjdGltZTogMHg2NmZhNjBkOCAweDM0M2Fj
YzQzIC0tIE1vbiBTZXAgMzAgMDg6Mjc6MDQuODc2MjY4NjExIDIwMjQNCj4gICAgICAgICBhdGlt
ZTogMHg2NmZhNWU1ZCAweDM0NTE0ZWQ4IC0tIE1vbiBTZXAgMzAgMDg6MTY6MjkuODc3NzQzODMy
IDIwMjQNCj4gICAgICAgICBtdGltZTogMHg2NmZhNjBkOCAweDM0M2FjYzQzIC0tIE1vbiBTZXAg
MzAgMDg6Mjc6MDQuODc2MjY4NjExIDIwMjQNCj4gICAgICAgICBkdGltZTogMHgwIC0tIFRodSBK
YW4gIDEgMDA6MDA6MDAgMTk3MA0KPiAgICAgICAgIFJlZmNvdW50IEJsb2NrOiAwDQo+ICAgICAg
ICAgTGFzdCBFeHRibGs6IDUzNTA5MCAgIE9ycGhhbiBTbG90OiAwDQo+ICAgICAgICAgU3ViIEFs
bG9jIFNsb3Q6IDAgICBTdWIgQWxsb2MgQml0OiAyDQo+ICAgICAgICAgVHJlZSBEZXB0aDogMSAg
IENvdW50OiAyMjcgICBOZXh0IEZyZWUgUmVjOiAyMjcNCj4gICAgICAgICAjIyBPZmZzZXQgICAg
ICAgIENsdXN0ZXJzICAgICAgIEJsb2NrIw0KPiAgICAgICAgIDAgIDAgICAgICAgICAgICAgMTI5
MDI0ICAgICAgICAgNTI1ODU5DQo+ICAgICAgICAgMSAgMTI5MDI0ICAgICAgICAxMjkwMjQgICAg
ICAgICA1MjY4ODMNCj4gICAgICAgICAyICAyNTgwNDggICAgICAgIDEyOTAyNCAgICAgICAgIDUz
NjA5OQ0KPiANCj4gSG93ZXZlciBmc2NrLm9jZnMyIGRpZCBub3Qgc2V0ICJOZXh0IExlYWYiIHRv
IHplcm8gaW4gdGhlIHVwZGF0ZWQgIkxhc3QgRXh0YmxrIi4NCj4gDQo+ICAgICAgICAgU3ViQWxs
b2MgQml0OiAxNiAgIFN1YkFsbG9jIFNsb3Q6IDANCj4gICAgICAgICBCbGtudW06IDUzNTA5MCAg
IE5leHQgTGVhZjogNTM2MTE0DQo+ICAgICAgICAgQ1JDMzI6IDAwMDAwMDAwICAgRUNDOiAwMDAw
DQo+ICAgICAgICAgVHJlZSBEZXB0aDogMCAgIENvdW50OiAyNTIgICBOZXh0IEZyZWUgUmVjOiAy
NTINCj4gICAgICAgICAjIyBPZmZzZXQgICAgICAgIENsdXN0ZXJzICAgICAgIEJsb2NrIyAgICAg
ICAgICBGbGFncw0KPiAgICAgICAgIDAgIDI5MTU5NDI0ICAgICAgMjU2ICAgICAgICAgICAgNzg0
NTg4OSAgICAgICAgIDB4MA0KPiAgICAgICAgIDEgIDI5MTU5OTM2ICAgICAgMjU2ICAgICAgICAg
ICAgNzg0NjE0NSAgICAgICAgIDB4MA0KPiANCj4gVGhpcyBwYXRjaCBhZGRyZXNzZXMgdGhpcyBp
c3N1ZSBieSBjaGVja2luZyB0aGUgbGFzdCBsZWFmIG1ldGFkYXRhIA0KPiBibG9jayBhbmQgc2V0
dGluZyAiTmV4dCBMZWFmIiB0byB6ZXJvIGlmIG5vdCBkb25lLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogR2F1dGhhbSBBbmFudGhha3Jpc2huYSANCj4gPGdhdXRoYW0uYW5hbnRoYWtyaXNobmFAb3Jh
Y2xlLmNvbT4NCj4gLS0tDQo+ICBsaWJvY2ZzMi9leHRlbnRzLmMgfCAyMiArKysrKysrKysrKysr
KysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2xpYm9jZnMyL2V4dGVudHMuYyBiL2xpYm9jZnMyL2V4dGVudHMuYyBpbmRleCAN
Cj4gZDcyYWU2Ni4uYzJhM2E4OCAxMDA2NDQNCj4gLS0tIGEvbGlib2NmczIvZXh0ZW50cy5jDQo+
ICsrKyBiL2xpYm9jZnMyL2V4dGVudHMuYw0KPiBAQCAtMjc3LDYgKzI3Nyw3IEBAIHN0YXRpYyBp
bnQgZXh0ZW50X2l0ZXJhdGVfZWwoc3RydWN0IG9jZnMyX2V4dGVudF9saXN0ICplbCwNCj4gIAkJ
CQlpZiAoZWwtPmxfdHJlZV9kZXB0aCA9PSAxKQ0KPiAgCQkJCQljdHh0LT5sYXN0X2ViX2Jsa25v
ID0NCj4gIAkJCQkJCQllbC0+bF9yZWNzW2ldLmVfYmxrbm87DQo+ICsNCj4gIAkJCQljdHh0LT5s
YXN0X2ViX2Nwb3MgPSBlbC0+bF9yZWNzW2ldLmVfY3BvczsNCj4gIAkJCX0NCj4gIA0KPiBAQCAt
NDc4LDYgKzQ3OSw3IEBAIGVycmNvZGVfdCBvY2ZzMl9leHRlbnRfaXRlcmF0ZV9pbm9kZShvY2Zz
Ml9maWxlc3lzICpmcywNCj4gIAlzdHJ1Y3Qgb2NmczJfZXh0ZW50X2xpc3QgKmVsOw0KPiAgCWVy
cmNvZGVfdCByZXQ7DQo+ICAJc3RydWN0IGV4dGVudF9jb250ZXh0IGN0eHQ7DQo+ICsJc3RydWN0
IG9jZnMyX2V4dGVudF9ibG9jayAqZWI7DQo+ICANCj4gIAlyZXQgPSBPQ0ZTMl9FVF9JTk9ERV9O
T1RfVkFMSUQ7DQo+ICAJaWYgKCEoaW5vZGUtPmlfZmxhZ3MgJiBPQ0ZTMl9WQUxJRF9GTCkpIEBA
IC01NDMsNiArNTQ1LDI2IEBAIA0KPiBvdXRfYWJvcnQ6DQo+ICAJaWYgKCFyZXQgJiYgKGlyZXQg
JiBPQ0ZTMl9FWFRFTlRfQ0hBTkdFRCkpDQo+ICAJCXJldCA9IG9jZnMyX3dyaXRlX2lub2RlKGZz
LCBpbm9kZS0+aV9ibGtubywgKGNoYXIgKilpbm9kZSk7DQo+ICANCj4gKwkvKg0KPiArCSAqIENo
ZWNrIGlfbGFzdF9lYl9ibGsgYW5kIHNldA0KPiArCSAqIGl0cyBuZXh0IGxlYWYgdG8gemVyby4N
Cj4gKwkgKi8NCj4gKwlpZiAoIXJldCAmJiBlbC0+bF90cmVlX2RlcHRoKSB7DQo+ICsJCWN0eHQu
ZXJyY29kZSA9IG9jZnMyX3JlYWRfZXh0ZW50X2Jsb2NrKGZzLA0KPiArCQkJCQlpbm9kZS0+aV9s
YXN0X2ViX2JsaywNCj4gKwkJCQkJY3R4dC5lYl9idWZzWzBdKTsNCj4gKw0KPiArCQllYiA9IChz
dHJ1Y3Qgb2NmczJfZXh0ZW50X2Jsb2NrICopY3R4dC5lYl9idWZzWzBdOw0KPiArDQo+ICsJCWlm
ICghY3R4dC5lcnJjb2RlICYmIGViLT5oX25leHRfbGVhZl9ibGsgIT0gMCkgew0KPiArCQkJZWIt
PmhfbmV4dF9sZWFmX2JsayA9IDA7DQo+ICsJCQljdHh0LmVycmNvZGUgPSBvY2ZzMl93cml0ZV9l
eHRlbnRfYmxvY2soZnMsDQo+ICsJCQkJCQlpbm9kZS0+aV9sYXN0X2ViX2JsaywNCj4gKwkJCQkJ
CWN0eHQuZWJfYnVmc1swXSk7DQo+ICsJCX0NCj4gKwkJcmV0ID0gY3R4dC5lcnJjb2RlOw0KPiAr
CX0NCj4gKw0KPiAgb3V0X2ViX2J1ZnM6DQo+ICAJaWYgKGN0eHQuZWJfYnVmcykgew0KPiAgCQlp
ZiAoIWJsb2NrX2J1ZiAmJiBjdHh0LmViX2J1ZnNbMF0pDQoNCg==
