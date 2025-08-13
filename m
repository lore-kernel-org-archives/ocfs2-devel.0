Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E49136349;
	Wed, 13 Aug 2025 20:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755117244; cv=fail; b=LoWlz87LcyQa7MSMbr0uA3gpPrfYWZgbAg/52gqRfRC6J28c7k1jV02v4mRQAS3Uxyr0z9aPJIAOEvvuE4Np3FD611X1d17h0vEuzJ9XmwueX/82t9LWnu0AOsk3jk2d+zYlJW88sLj1X/DHdJMVkqD4Kh53FKXOdWDW3z/5kZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755117244; c=relaxed/simple;
	bh=169CXteuvXLGdeRfyVqSg1aBJEJAek8yb+TGrLl5Gxk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fXxZNZi+iJ6oX91/wmdM1FuRrnc3DwiFnCklZ6nVsA3HrVMS7HXQl51moXZ2uXLyqxFEOR+qzgQuiJ+NEUwii91sq50/RqXQhUbo9/9i2uR5jK3+UI4Av6N2cqdZZjjbanR6BcueRhKrbeY/g/DKiY02Lu5dFiDvCfubgbx80zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NurR5Bze; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gmap/VZK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NurR5Bze";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gmap/VZK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DIN0mV007243;
	Wed, 13 Aug 2025 20:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=id77YFnooQ4ZMg4uSUQFZ/5quWJixVe4mlX2df6ZFmY=; b=
	NurR5BzeyRuCjUzIcInKbOwwre/yeoZk7Zrm+dJnedqsvbjKhJ+jdznkbNfPIxSC
	pXSaCaUtd8AUD5CCBc8ke4d8fJi40om9K0G2vbx5iKnPDKG6kEvpvLSbJCPKCk//
	+slzG6Zk2c0QrUHVxwkeQ+ItBgNeftAGjZEDltEj7xsY68xz/WB2BxGjJyIO42qM
	dSLeUFA+hEjpW3FYmKjW0RuUsUwB5926u05PoS2GCJZ08AUZ63uEP8D5pm8009cg
	+80jlBIe/hp9l2Objs5LbrXDZ7dWarrgNiV8KknTjkdh63cc8peyMkebEwNJDsBA
	4XgU6+To0oagy55r5Ld7/g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrg0brv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 20:33:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DKFpFI030118;
	Wed, 13 Aug 2025 20:33:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2052.outbound.protection.outlook.com [40.107.96.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbvs2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 20:33:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wRJDm8Uh6RhxZK6KJPOAtgKBaV/0MRHXP0eKNUvPj/oeCFJKq5n5Lsv7FP2HMrEFFcSquP7wJI8P6Legc9BorEd9OdroPmfeWJnEtAoWW3XDM5PlH6buRW8MHg3DY7xSal7XnylTGYZlZ/xB8NCJUgRsxuRqtangl5+fiNdoKckrjfn0bnKAU3n1NuqSABkQ3OEf78KILZj+vTIFYHDJlGNfgPAqjzaS5TTS4DzR9g3Ur2tx/tOoCixod4CRXhiHmbiQqVmfVhR4pXJI9uPZLPIIVh5a+nVN+KdyXz9raO2VkGnmfZbt5/j64b827AMaLOqM5eMouQtScNoHlY59kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=id77YFnooQ4ZMg4uSUQFZ/5quWJixVe4mlX2df6ZFmY=;
 b=En1o3Az035hze4EfXJ1LOZGLrgDI4HmDaaNPLZ7kNNEtKg+zfTY6BhBi6vmY0Z4swk0fen8P0MZvunkksbGT74qAqIyWUN9wnjPgqu5FHmnSqtdhYO2m0i+KYT1lJ3hIzktn/j6jdbBGSoanbykU+QgmImi8QA+DC3uvmnk9A11Xe4xDVAToYSTymAPFTJ32fz6q8bQiH8RiPGzHEPZ3gO23aRDfWs/hedbQ85+BI4C7OmnlRq4Ae/HMm92k0z+g2NBh3wHeWHCmwwtSZ2/PVmgFLOxxrw/NySQDAoeLrFtRJqlShIY7aA2pkIQfVLzkKDmHI5+Ys033k7Naguqnkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=id77YFnooQ4ZMg4uSUQFZ/5quWJixVe4mlX2df6ZFmY=;
 b=gmap/VZKeyuoubi6cNBwWlLRDVglQHVl5fxjoCEABg1meUuEl487MgkwLNhdzNPxUzzfCK+GImpIo93kV+ic+81UKP6RzVhXpNWfhyj6If1G2e9/s7k1Rr5O0azyITXazG8d4nCRMNRRRPNMJfW+2Xwcqij8Nufd+nBkpTzWrak=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 DS4PPF9C7B9A88F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 20:33:42 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 20:33:42 +0000
Message-ID: <2ca08337-e750-4d96-9e81-7728dbccf600@oracle.com>
Date: Wed, 13 Aug 2025 15:33:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] ocfs2: Remove commented out mlog()
 statements
To: Thorsten Blum <thorsten.blum@linux.dev>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250813180622.209305-3-thorsten.blum@linux.dev>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250813180622.209305-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::9) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|DS4PPF9C7B9A88F:EE_
X-MS-Office365-Filtering-Correlation-Id: 13c8a311-db70-456f-66e7-08dddaa8b140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEl5eE9zSFlDa0tFQnFENEk3bTQ1Sitta2x3S1BjUHNYZHZtTHJYc3pWRmF0?=
 =?utf-8?B?OWh1VHluRGJ3Wm8wK1NvSHNuSER4QU9KWmRzOXhjMzl0a2o1aXF1ZEpNQWx2?=
 =?utf-8?B?NkdBRnJSeWg2ZDlzcC9aeXcxd2xSbGpDZmx3bVlKbitoZUlnTExRa293Nisx?=
 =?utf-8?B?UXVHZ04xVndVUUZXcEVkZHp2K2RHeS9kajk1eERRb1hPdTRWMjZhbDh5ck5o?=
 =?utf-8?B?U3hYbUgvbVJxWE9tSEg1bXkyR1BNZ3gxdHA0YzFrbDNIVnR3WjcrcXB4dEhK?=
 =?utf-8?B?bWFNZ1BZNFFqUHp2bDJqRmNMYWJ3NmhPNXNKRUdCaVVCQWEzcUxtM2orVG5S?=
 =?utf-8?B?TFBWL1FGc3dLaVM5eWp6Z3E0WS8zRGFna3RlNWszcDhBNWpWbGtFUWp5anRK?=
 =?utf-8?B?eUtzZjFaSTEweEVTSFNiWXNvQVBjUjZWZjJ1b0NpQWRlNG1wTEw1Si9odng4?=
 =?utf-8?B?a0thdkVKVjJBMEpNb28zQkttSGx6dnJNSmpmc1BZTjdZMnNROXA4Qi9ScERQ?=
 =?utf-8?B?R01xUkYyMy8vRXlJTGRhSlBnR2JYSS9WSFNDZjgyVUVYTGw0d1hNNjlqa3BK?=
 =?utf-8?B?NW5kL21lTzExeDZ2OURGNjZJZCtBN2kyMGVQK2Z3MkR1c1Rxanl6Z0s0QlJF?=
 =?utf-8?B?TWpEQUo2c0MyaHFTS2xqMjAzUElOM204eStocG1LelFGUXBmYUVaZkpZVFNM?=
 =?utf-8?B?TnZCTmk5UnlBeGpIZUpvdEpKelpyRFhmbUI3cVBoeGpIN3NCZTFMR29JMjVN?=
 =?utf-8?B?QkhHZzZrZktnckpoVzZxU2laL3hsZ2gvNldacjROWHB1a1RVQWY3TVZ4ZDk2?=
 =?utf-8?B?US9uZ1lZTlpBaGU2Y0RlUzIxRDc3TFl0MkY4QktmYVkveW1wbmtocG9KRzVk?=
 =?utf-8?B?YkIyZHJlWnpPL3JaN3o0elVrNUF4bVVkKzJPVXBKT1l5Z0JvSXJlaU9jNGlu?=
 =?utf-8?B?cTczRWtNSG9SU2tWZS9kWGJPS0Fjc2l3K3ZvYUFDS3NiSWw5MUUwVzMvazQz?=
 =?utf-8?B?dHUzK2tOeE1WZFNhUjdBR0dVdjBqVW1QRWhIRXZScGpjc21rM0xoc2JmNWpG?=
 =?utf-8?B?SXBmS1I0cmpIb3BoSk5WbzNpRHcyL1l3VCtobFJYVlVWMi8yZmJ3ZnNwSmoz?=
 =?utf-8?B?QytKNmNVczBzTkEzSk1tN0oyNHJSQ2Z2TVVUdjVsWThOZjVObndnUi8yYTNY?=
 =?utf-8?B?Wk95TkRjajM5VmNTakVSeUZDdFJFSHRRMU9rcjkwbW02QjVxeGNSdmJjb2Fo?=
 =?utf-8?B?TzBDSVNQWXE4RFR5TmxEblNSTjdXTEFtMS95bGlCRzh0TStsblE5V2M0YXNx?=
 =?utf-8?B?QUhSUkVNTkk0TXNQb2RHSGRqQ0JuNHVrbktUajhtQ2xjR2Q5cjNCdXFhZVFC?=
 =?utf-8?B?NkxveG95S3pwOFNITHpEVW1rK0Y5RmZqWTdpM05NN0E3MkdWbkNQY25Gb3Aw?=
 =?utf-8?B?RWxyZjIwaGxiaGI0cWZ6bXdaTjBwQ1FESk9qZnhkNUh0U1Q1VC9zZzJROEdN?=
 =?utf-8?B?dGliUEdudzN5QVVWam95MU1MbWlnRGV6ajNDeFJzYlZxT0NzM3dlSGhzbUcx?=
 =?utf-8?B?ZXp6eDIyMVVBZmpsdnFqdSsxdzBJRGxYZUhFWlVtWTI0ODlRNnAyMHprcVRu?=
 =?utf-8?B?czNhbUR3YURqUk5FYWoxMVR0QncwSi92b3ZNYW9WNG1BRmRkbEtBT1o4VDFZ?=
 =?utf-8?B?Z0luemo3alk2UjMyd2VlTGpIK1JXSGZOSHJySThjUmgzYWZrT2p5N2ZqUGpI?=
 =?utf-8?B?b1hpbzRLV05MSVlwOWV5UkEyK0lNU0tmNUp2dlJXRzlUUEpZWm80dHJ4aTZw?=
 =?utf-8?B?dWtQN0lYMHp1cGJLeENUT3E3TmtzaHlDcmhxUjVSZy9EMnZSV2tsbjVMZVFD?=
 =?utf-8?B?WGNyZUpidUlWVUZscXZhS3NMYWhRU1I1M2RZR1dPMUtDaGJBRkVMR0pYYVJE?=
 =?utf-8?Q?HVMFlwAnV68=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFlqSE5YYXltYVUra3MwQVFCSStKd0UrL1JYd0owbkF2U2FhZytnTnY1NWdl?=
 =?utf-8?B?b3NORXJ2cE8zSnp1eVRBd25YQ0RaSXRrVlFYMFIwWFhjQUlRVkw2aUNFSzVC?=
 =?utf-8?B?bFNyekNHSmlQVEh6RTNTbitFMUc5NUdSbkFCeHZpUm5zUklIUWp2bkFCa0hR?=
 =?utf-8?B?bXB0VjVkWWd3a2k1WE5SSGpVVDAyZ0l3dlJTa2Q5UlpqenVsbUlzWUQ1Qm5l?=
 =?utf-8?B?eEF6Wmw1T0RYNit3MThTMUl4TkgrSkxQZjFvSlIyTGtZRTkyWnJNWU1vSTlP?=
 =?utf-8?B?c0loaXdlKzNCdVdiZnE4UUVFTllqbEZUQm0wOWR2cDlsS3A2ZEtkT3E0U1FI?=
 =?utf-8?B?aFNwaGdzVVRpK2ZlZk8zRTllTnJkc1JMMHI0OUNJVEpMaUtEcW5HeHdXc09r?=
 =?utf-8?B?VDNPS3diT2liTmlZVU0vdDNrSTZMYlo1elc3RXdndDdqVksxRXhPZ3pVaHRC?=
 =?utf-8?B?SlNjUDRDSTNkWTgwNFROdHRSdVppVHJ2WDl3RUVNWjBCN00vVUJBYzN4OVN2?=
 =?utf-8?B?d3ZmaUpRZDNUaGFlUWUrZFRqdEdFSlcxTXRweWQ0MnJjaVdjZDlFRDFPSDZv?=
 =?utf-8?B?eW9xSG9hdXhsT2ZPWHRrUkkyWTNqYi9ZK0NuYWd4MXdrOXRrdkZHa3lQL2ZN?=
 =?utf-8?B?S1lwdnJZK0hyNkdzbVh1T1o3QXpISFAxSXJNcWwwRzF4SlhRcENERkZ2OFdK?=
 =?utf-8?B?a2JPZUZWL2FiY3dKdGE0OFlMNk5EYklkbWY5bGZyQWFIZGRmdFA0bE52eTdT?=
 =?utf-8?B?Z3RzVzY3cGczRUdQQkdZRTJnWTZ5dHRrbkFJZ2NQbk1BVDdhUUsyNzY0L3l3?=
 =?utf-8?B?M3RQM1ZNWSt6c0E2dkMwYi9BcEI1ZzQxdGozak1oLzZ0K25ITkFOYmxGYTMy?=
 =?utf-8?B?N3Z6MGpIbVJIazM2NlhqLzRsMnNhOGMxb1lHQ2ZjdU9BSkpNZnBvYXN2cktt?=
 =?utf-8?B?aFNLTWRUb2N3bmtUM05tYXlJdzY5T1BEVjBhbzNiRGMrcEhsMVE0Mks5Sjdr?=
 =?utf-8?B?a0tzRnY2U1d0QXhmZjQ3TzhpUVIwTWE4NDlJZFN5aXJSZHJNejQxZU1Eb1p4?=
 =?utf-8?B?QytHdzN2S3hkQm5wZGhicGZ4cU1xM0pJcTkwdFlDRzdsU0hZdStHTUpzUDJ2?=
 =?utf-8?B?TktLNERmWmIxSEN5OHRTZkwyM3FQWHJLUE1teThiRFpjVW4wbGdIVXlsNEJP?=
 =?utf-8?B?d1BNNDBuYkJUb2hubWRtL0M2T1AxV1ZnSlMvMEtBRGRtdG43MlhRTTVqeEpq?=
 =?utf-8?B?Z3dLb2dQcGQ5OWVjQ2dIelRXc0FJR09kT0NPT0VxQ0ZYekpwWDZNeUEvdkpM?=
 =?utf-8?B?Vyt2bG9CSkNjUWNIZjgvTE1CSE5VY1k0Mlk0R0c3UFNMTnZDN2haYWtXdUlZ?=
 =?utf-8?B?OFVLNlJpWWtwOHlkVzRMeCtyM0ZObGgxNG9MRDVTL0VVZXhxMWMwd2M5aXlK?=
 =?utf-8?B?Q0tnYXB0NC81L2ZIaDJLMVJDR2pNdGMxRnplRGhqcEkxRG5SNXFhQlQ2bHRV?=
 =?utf-8?B?alJrR3JHeU14T2dMa0ZDY3VBZlUzZ3ZqeDZ3eUxZQlNpNTNSY3EwQnloR2Za?=
 =?utf-8?B?TjJDQkU1QXV4eDNBQW5DV3I5RFJzQnVLM3RnTmsxaXF4SFp5NDRDQnM5cXNE?=
 =?utf-8?B?NzBWeTVZTUx4NUVYUjFPdTEyZ2xIWDZCVldDTWhWM0tlZmpaOGhuVklXdW5r?=
 =?utf-8?B?Zms5bmFwOFFUNlo0c3ZhTnlHbDh1ZFpaYVh5MTN0T3ZrS29Nd1ZCYmIzRmtM?=
 =?utf-8?B?V2QzMXJiU3Y1QVVicVVQMmlSL0NiLzliTmtVaTlDWUtpYnhTaXlCbFE3eTRO?=
 =?utf-8?B?TkxVR0RNY0ZPZUwxMUlVcEl4VTJXeDJLNTRZeXZlTE01S3JGWVltWHVRTFM0?=
 =?utf-8?B?NitBcFc1VittRkpWa0hZVmlKVnR0aTBKMnMwcmY0S09hM2JyMXFYSWxKcUlK?=
 =?utf-8?B?YnVyZVJlbHdsN3NVYzRNL3A5SHplZWRHODNnd3NESlBhWUx3MkxQUFhlRUdz?=
 =?utf-8?B?M1QwZFIrWGZLenBRb1B6dncrTmNiOHFCTUpJK3Zmc1NpTDNRN1BFeTdpNnZm?=
 =?utf-8?B?VnhQZVhseEUwRXE2Nk12d29FeTlXazRTUU1VdWcxbENTOEh0RFNnTGpqSTNl?=
 =?utf-8?Q?Eh54FY1AqCJ9gebotGLqn0ffL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9o/5QPAdTFXB0uOSeSMKGbCHu4BPvjxzXfVLdD94Wbn2bq1SLuEPQunsK0t5GibrR+t4+BWPPBvuexQ1cO9m2Bi93Af5O9cCQR6jj5JoLQmgMj6/4XJNyakXtBxz++6zdXI594EiixR28VAlK4cF5Y6Y928CaYeluVFKcPfET0D3AntUqggcJ2sPHRSjbvRtMypzfRjLc+gMKdx+CAqT0oLM/w2yDdXLhYtapwxXizqCbicX4Yat4uoyQty3q6dPjBB8Xt4PIXuQfP/eQE7OebiSRCvF8OV0E8xl3PM4NQGosAD3LYsY/iIE69VpJs9u1ztNVmLZCU8Tf3QvDrbL1uDRV+uY3sWfbw23f5H8+WgBxwFfrm5ZdDGi1NThYm7CC5KIBBT6GSzKFnoRMGqHTy5o8P6cQ+xAHz0kFL3uhqPPvZwSz/FdULNvpoyffw7Nz5Dskve9eD2zwcGt4x8L1EIfbw42kZRTN1IHcTbDOayOPBxj8TKrUnC4/5mTJTAWJ93/bKQPpT43UzhNtjDIt3vc4Vs64+VBCJ2n0QEyVw+hYH+WfbTqv3S/4/GsBc1aSv6ndPOrWR0u66cwi6m8MgaqsZaUNbjLn0AwsQqY6RE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c8a311-db70-456f-66e7-08dddaa8b140
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 20:33:42.1167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+lAGGEn9CVjoF4+V4mKRfkHx9P3Mkxzv5EHNGZFuyZUWZ4HQoXx7TOQK/ZkFryAmEqRTlNEpTrL+pLskDhogocUtmbppKs8q1MuTiIWYDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF9C7B9A88F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130191
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=689cf6a9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=RJf1f9yhQLz49x2dnbEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: KQkWejogH3T_luAdHgP_WcGM3anADj31
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDE5MCBTYWx0ZWRfX0wxq5r6MsHce
 AMY70YGAyu50ca8svoCrdyIX7d7i/8BrETrqe6FmuewAEpM75myxInj6M8Prm7lFaboshwmoF5z
 nLSGty9hU4O3d2kBfcGBHjdPE8y8iXWzvvSQbR2Tq6EtcQ4mHVkKr4zzDTmgt9LZJrYJ08t3L5l
 GjiP/pNvcfqKAeyrJ5SuhEKyNMKGe2tGE/4vugRBIoDvD+2+BS7fIV/k+17yrglfd0zpKdwaxNl
 FhJEa9ODVTrGuK7tGse0w7eeIZdqaN3oa1iQa9OEJJGTaLdRXf39DDDhkqO0h2j1H7yN3jzpcVt
 2zeL3wira/wCwsbMdRLI9mdYW152DJCpviJRgEp8noyXkSsPFUjzt3KvIaZOKfAMjoirbgKXL4F
 WtFE8q278vBQRwCsXPYRgcHBZFIlSRmGCu+p+89vI7sF9i2U5gSQcKxom0Im7fvnxLDg9HQB
X-Proofpoint-GUID: KQkWejogH3T_luAdHgP_WcGM3anADj31

On 8/13/25 1:06 PM, Thorsten Blum wrote:
> The mlog() statements have been commented out ever since commit
> 6714d8e86bf44 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem") -
> remove them.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   fs/ocfs2/dlm/dlmmaster.c | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 86bb1a03bcc1..4145e06d2c08 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1477,7 +1477,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   			goto send_response;
>   		} else if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN) {
>   			spin_unlock(&res->spinlock);
> -			// mlog(0, "node %u is the master\n", res->owner);
>   			response = DLM_MASTER_RESP_NO;
>   			if (mle)
>   				kmem_cache_free(dlm_mle_cache, mle);
> @@ -1493,7 +1492,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   			BUG();
>   		}
>   
> -		// mlog(0, "lockres is in progress...\n");
>   		spin_lock(&dlm->master_lock);
>   		found = dlm_find_mle(dlm, &tmpmle, name, namelen);
>   		if (!found) {
> @@ -1503,8 +1501,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   		set_maybe = 1;
>   		spin_lock(&tmpmle->spinlock);
>   		if (tmpmle->type == DLM_MLE_BLOCK) {
> -			// mlog(0, "this node is waiting for "
> -			// "lockres to be mastered\n");
>   			response = DLM_MASTER_RESP_NO;
>   		} else if (tmpmle->type == DLM_MLE_MIGRATION) {
>   			mlog(0, "node %u is master, but trying to migrate to "
> @@ -1531,8 +1527,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   			} else
>   				response = DLM_MASTER_RESP_NO;
>   		} else {
> -			// mlog(0, "this node is attempting to "
> -			// "master lockres\n");
>   			response = DLM_MASTER_RESP_MAYBE;
>   		}
>   		if (set_maybe)
> @@ -1559,7 +1553,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   	found = dlm_find_mle(dlm, &tmpmle, name, namelen);
>   	if (!found) {
>   		/* this lockid has never been seen on this node yet */
> -		// mlog(0, "no mle found\n");
>   		if (!mle) {
>   			spin_unlock(&dlm->master_lock);
>   			spin_unlock(&dlm->spinlock);
> @@ -1573,8 +1566,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>   			goto way_up_top;
>   		}
>   
> -		// mlog(0, "this is second time thru, already allocated, "
> -		// "add the block.\n");
>   		dlm_init_mle(mle, DLM_MLE_BLOCK, dlm, NULL, name, namelen);
>   		set_bit(request->node_idx, mle->maybe_map);
>   		__dlm_insert_mle(dlm, mle);
> @@ -1897,8 +1888,6 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
>   		spin_unlock(&res->spinlock);
>   	}
>   
> -	// mlog(0, "woo!  got an assert_master from node %u!\n",
> -	// 	     assert->node_idx);
>   	if (mle) {
>   		int extra_ref = 0;
>   		int nn = -1;


Looks good to me
Did you want to remove the one in fs/ocfs2/dlm/dlmrecovery.c from the 
smae commit also?

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 00f52812dbb0..843ee02bd85f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -464,7 +464,6 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
         }

         if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
-               // mlog(0, "nothing to recover!  sleeping now!\n");
                 spin_unlock(&dlm->spinlock);
                 /* return to main thread loop and sleep. */
                 return 0;



Reviewd-by: Mark Tinguely <mark.tinguely@oracle.com>
