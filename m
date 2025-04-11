Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803FB1D86F7
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Apr 2025 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744389117; cv=fail; b=DNILbr9p+Pe5lXUiaBZxVHO1IgVW9KYuVjTyrWlHJMuPqUaj+enZfRnOCculvAeNgeL91MeRRPcatkVM2iiEEVZATNb1NPg/wDcCXVRRIStDiWBczMCwQpJYVXQ1ctskEqKDpx3qDfq5IypaqH9y/DtnN9Da+C/CuSiTzYGGqJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744389117; c=relaxed/simple;
	bh=WRO2FitGXPGCUs9HMeiUrDMImaqWoPefL33KNr1aBpw=;
	h=Message-ID:Date:Subject:References:To:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KlJMpjeddARDdZ8IX5iqb5ocKhylfMIgyOS0mkY40mi6oSTxd42QNnBXJp+V9Yg5fbJZhjPRNunvPRx8BBx/9tTonqkrTTz6Yu9/DKC6TLmbPvpkmuDpdG/v36DPLZCByeAtQwvvL8eoQ+qKAg2WucGGZOiBUL+loPX5Muvs73w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=drPNT0fb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZoA0dmQU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="drPNT0fb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZoA0dmQU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BGC3xX025125;
	Fri, 11 Apr 2025 16:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=so2o7euV2Rg/Mpg35evcYO/2WH+piiN4yTkPgII2vkM=; b=
	drPNT0fb6kbMaBp2w3nOAb5QaZR7cS2I+q2qLhy/nKyp2sOZIu03lFynqHpR24Lq
	mzfgqJ8mzE7LdGHrXOFmJKPKh1KrcfLbLMvLdwLcnMs8het4GFaRAPDsi/9yspgI
	A9GRzVULfn9Us8ItPeQQYxWvY+nWqWIVd3Qi8jCQ1p1AgzEoghC+g8+Il3nP9aAO
	CCv2DSHtnrqig7rDaF/W6zATN7PQSMpfrNiD612NeGMAhzEKWLLOh/Pp/Cm/isja
	z9dqFEvhb/QS6YM/NicyRa5+AV9miWPI4FZCYzRAxQEkLYe7okf4qykZBfkWkkOZ
	8fSINtcouqY9Q4rAyWGVfA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45y5k4r6kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 16:31:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53BEr2n6016129;
	Fri, 11 Apr 2025 16:31:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012014.outbound.protection.outlook.com [40.93.14.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttydvh5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 16:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJOHEmh7yhTjslOXAs8UriERyen+D5Otfg5jJQQYyvkDuQZEDpzUito/2ruYtVvAvX/fIBToaiooQAF5oC3iUKVv91yaRHzw6JjO+JARVh6kvytCrXZLg5Y1eNIrZGCp8u4eCPMBzoTXqvfnruv/ZhNse8JvagGdlsOX5azcKpHPkVTNkZd8H6Y3c6v4qjqIAGrmKG2cRQROxZ1lWRXOrus39UR0Q0UZM2LwsybOkH5hRwD6iJp169THv5zKkGveLubTPiklEPi/u+TsM1pprMGAWkeP5DBDC/BT9U+cIjxyIttjUXZPR3VwG4yLRjtuFQXYm9Uc2tDZWn5MrcFCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=so2o7euV2Rg/Mpg35evcYO/2WH+piiN4yTkPgII2vkM=;
 b=TAtGkvxfJaHvVHAbNv2m/7TBG4APAtxSbEWkYiQM1vx5ks3kY9sL431df6oiH5DjXRCOBw9YUIzpqTpPlp87xcSo0y5PiJovUoI44xz6dZVgp2zCFqUedi2dEFGTHXBNU3+DSqH5w6M6nlLCKo8itJC0akSjOJNFrwC1w4RzXuk/pnuulF/8DnGSiAW+aH9qvRbTETsjhodaeJ+4cg08P06lhS77HsMkJTWdazlOKAy3tkOE2e01XzmauKN8i/HFYybZIQTNKyxFUel99foLQ2p6qvPzkkbKNR1nPeKrgC6KNTW6+QpkmmOFLbI8MhD4MS92HmF3gGv+EE8QVOIrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=so2o7euV2Rg/Mpg35evcYO/2WH+piiN4yTkPgII2vkM=;
 b=ZoA0dmQUdsCJa1p17yiWguo2zzXlo7iOjwiyHmgNrB28p3wSTOqz1YmRPJddebPOyFOnRKsz5ktltP423DJktBoBJa6TUn+PB+G+1KbAlYMmh2JOR/chEvG/rFeIgFF32LaWYuiKcFeJqkFrCJeE1cEuO80OHw/g4OYwa6LE+50=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 PH7PR10MB5673.namprd10.prod.outlook.com (2603:10b6:510:125::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Fri, 11 Apr
 2025 16:31:27 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%6]) with mapi id 15.20.8606.033; Fri, 11 Apr 2025
 16:31:27 +0000
Message-ID: <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
Date: Fri, 11 Apr 2025 11:31:24 -0500
User-Agent: Mozilla Thunderbird
Subject: v2 [PATCH] ocfs2: fix panic in failed foilio allocation
References: <20250411160213.19322-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: ocfs2-devel@lists.linux.dev
Cc: Mark Tinguely <mark.tinguely@oracle.com>, stable@vger.kernel.org,
        Changwei Ge <gechangwei@live.cn>, Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>, Mark Fasheh <mark@fasheh.com>,
        Matthew Wilcox <willy@infradead.org>
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250411160213.19322-1-mark.tinguely@oracle.com>
X-Forwarded-Message-Id: <20250411160213.19322-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN1PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:408:e0::18) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|PH7PR10MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: dcb4bece-76cd-46d1-1d12-08dd79164e72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTdrcXFkTnAvYVNlR2ozK1M5WHI5bE92d09vbGhSM1JaMFRKSmkzamk3Z2ll?=
 =?utf-8?B?bnhPdHo5Y0txOVYxZjgwUkE5eTFyNnhYakVaL1BBU2hncWRsU2NSb1BXbXlk?=
 =?utf-8?B?Vk1kL01KZWpZSVEwZFFkQkRxWVdOQlp5dWlhcHZCRDNMVFdCUW41MWFkTlNT?=
 =?utf-8?B?VWlPRXFGUjlyWEdmUUFQcHRTTHdsUkNqME80Tm5ab290L0RUN1dtME1hYml1?=
 =?utf-8?B?R1E3MDFjUnVOc01LR1paa1lWdU1KMHpQK2tXMml0K2lCZHpHQ3p0Y2JISUFG?=
 =?utf-8?B?S2hEcmNFb2x0andST1E5Sm5qdDlhTlZoZWpKV3VQc3FLOFVvZUpaMjhsdUls?=
 =?utf-8?B?NnZlb2NTTkRGSTgxR3J3dHJTa3o3MXdmK1ZJc0xWUXVGaUhKQTAyaTRMOHhy?=
 =?utf-8?B?NC9KYUVBZXhDRFBEamRremc1d1JUZnF3VWtPRDN1NVBKWTh6eHR0MGdISXc0?=
 =?utf-8?B?T25qSS9qRkliSHFjT3U2Z1BnSVU3SnVCNmRQcGJycC8vTFR0MWpkdjVIMHM3?=
 =?utf-8?B?ZWZSQ2hoRFlET2pxcnVKTll5bUNpbnFudmxEQm54Sk9kUDJ2QithaURraGN1?=
 =?utf-8?B?c29SbGk5N2ljYXgvRHF2eTRxV1dCVjNVb0hrU3VNd2VrVzA5Rml0SkN4ckRa?=
 =?utf-8?B?ZlRlSkdZYTd2a0hjNEQ1Z3E5aEplUEo0UlErRUZobVNJYy9weUJhWmRKL2dE?=
 =?utf-8?B?dm0rQlZybGFJMjFIaVJaZUJZNXhCU2RmWnB2ckVpUlhhODViRWxBSmxZbTRy?=
 =?utf-8?B?OU8wbWpMQ1d2eUNJbUhNam5zaFpXb0VVb05zY25xV1hnNVBLWnlBVHo5MXpS?=
 =?utf-8?B?aTdlczY1SHhIU1dBbWZRTXU2ekhmenRhSGJ4ODA4MlJXTnBGZFpBWWRuWkxp?=
 =?utf-8?B?UkRjZXl2MnJLUVV3Qmppam90eThrWkF2cUxJaVVhTk1zL3ZzMGN2VTdReHox?=
 =?utf-8?B?WWN5R2FqV3VlNUxxR2craC9xMnMxQjV3c1JVcThjdnpmd01RSjhoZHF5SzFH?=
 =?utf-8?B?MHpIZCtjRzBUenZxRzcxY1BkZzdJbXNGUmVwOGJ2aUVzbWU3Zzh4ZkFlT2N0?=
 =?utf-8?B?c3JLTC9Ndy9mTWdhYm1rcW96cVFHSTVrMWhLTE1KQUJLeWIvNXI3MzkzYXp6?=
 =?utf-8?B?MDl4ZGdRVk5zOTVOODBaRUFOeW4yRFhUck1GQkE5aDFSOWt2OEgzbEhyc0FI?=
 =?utf-8?B?T0x0Q1o4dE00Y2xtT1lqY2tRTkpkOXNTL2hTU0FidzVIUjlzcmpzOTFiSXFZ?=
 =?utf-8?B?akxHclR2Rmp3bEo0ZzhmZ3FVOWh1WE9xTUloZFcrUE0wcGZDQS9EUmlnSkdO?=
 =?utf-8?B?OTFGQysyVmhreDYxM29RL0V4QllZNEJDdzhDcFA0YTFSR1g2Znl1OWx1RXlp?=
 =?utf-8?B?QnNkcW5UaUIzZ2N3L3RIUnY3VHZYbW5LQTh3QTBHWUttU2FVZkYzTDI2QVVk?=
 =?utf-8?B?YWhBUXo0MHB1MEtFd3lYdEpqWG4yZjVTcUZpVmd4WnlOYzBOeGFwMThCSFV1?=
 =?utf-8?B?RU12a2RQbnJTeVBjdWUrT2MvdzdFdW91SHp0bUdEaXpvRnVCSEJwWGFCL05x?=
 =?utf-8?B?ZmdqNFVKc1JEY0FxNWFxUitvMHVNRlk0OHcwZGUxVXZUa0VZQ2U5Zksvckxy?=
 =?utf-8?B?cWkzblk3SVRjU1puZWx2akhwYUtRN0ZETmhWd1pRYVUySjh2Ukw4QWE0WVpk?=
 =?utf-8?B?S1pUblhLUUo1amVMK0Nkek8rd1dHQ0x6NTJOSlRtTmpreGFCcEdqMk5LQzNL?=
 =?utf-8?B?QmFnb3dlMjNtNElxZWMyelA4Y1FKMjJBZHlPT1FXdDVCRmRuNXN6QTJQMVhL?=
 =?utf-8?B?elhPcDgzOFpNSmM2WTN4dUwraXZBMk5jNlVpdW02SkVnQkdKam1qUnNJeFdK?=
 =?utf-8?B?dE4rZ3RjTlY3MEd6RlFxL0VWb2tTbmE1UlN5eS9KUGlGUlhtaVcyNEtUNGsz?=
 =?utf-8?Q?C64pq9gvUOU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnRzbitEVVBmb3VCZjdmWWtvVzRzdnpQa3JuWk5rdDBxMDhSL1VMY2hTeEtj?=
 =?utf-8?B?cmZyakpFVjZFT211dHB0di9NSkplamw2dDdQQVgzK3c4ZkVnY3RqcHdxTjF4?=
 =?utf-8?B?K2hBc0wrVFJjbnorejhjV2Uxb2s3cUhwVk90SUFjdzU2NjhFNTFoek5PdXRw?=
 =?utf-8?B?V3BrbW5FWm5la0pIRHNJNFk2L3RwMFlzRGQrenVGQy93akpZMGF6dW95NStE?=
 =?utf-8?B?VURVUm1mMU9kZjFIOGl6czJQS0lJQmNybGlFNHRNTWxHd1BDaDdaOW95UFV2?=
 =?utf-8?B?MnB2Ti9teTJIeUlIZHFiZDc2R3B3V2hTQzlIU2tVKyt1ZFJLTTdOdTJtcE5K?=
 =?utf-8?B?eDliNkNnMWxrb0tFN0J1WnZ6UmJKb0I5YmtSR0lSc3pIaEJoSVh0NWEwbmV2?=
 =?utf-8?B?Ulh1TzNBOUhIWjMzVG1Ra244RkQ1bkNzWmxxYVp6ODlrUFFReUpVbFhEaC81?=
 =?utf-8?B?MUJlWUd0Z0MrSFZTUklPbHo2S1dDdTFHdWNtTzVCQjR4U2U3R1VUTkRJYVl3?=
 =?utf-8?B?dXp1K1duVDdrb2didDcyTHJRVUVQRkZoTjZSSU5EWVVDemdEQWF0bmRqY3ds?=
 =?utf-8?B?SlE2ZUEwNC92RkN4c3o0WjJ1VllTeWVodUlJVFM2RnpYZjlZUGk2TnJlOS8y?=
 =?utf-8?B?RWFzdzVFQk5oWXhXYld0RTVXU3M0WFQ2NTFhT1BKK3RTTnNFWUV2bmNzMDhr?=
 =?utf-8?B?L1FuUk0rSC9JQjBmRTNuUy9QNHVVMmp2aE1NOXQwVnBrWW1vbExZRW9PWUQ4?=
 =?utf-8?B?RXY0SnhBNWNWYlpZWjBqUzNUTmRBdnRoenFLZnhzNEU2c3QwZkFKRHRwWktV?=
 =?utf-8?B?V09KdVBlV0x5aElzVzZ2blJBYjZvMzRXZzJqRnl3WUZjbHcwNDhwU2JQWmhI?=
 =?utf-8?B?R3Y4cjFXMlppT0k0Z3JyZWJpWTkwR1luTW83aVpTUi9pUGEzS3hCS04rTGlY?=
 =?utf-8?B?bFB6SkhOMVJVWlZ3OWV4UXhaUms0UEVuTFpLMGcyczZsQ2hWU3RjRWduak5E?=
 =?utf-8?B?dnAwZWRtWFlBS3FiWWZnQUhKY3pGZlMzOVRRT2sydm0zMEtQZ1loN2NqU0k5?=
 =?utf-8?B?UWZZcGRTbEN6dEhaV0tKbTM0dEV4Zks5RC90d0RTVXR4ZGlhQ0pycjFPZ3JK?=
 =?utf-8?B?Wm1yMmpEY3lVUVNNTk1QT1V2Ulo4L0doelRQTVBZblVJZlcrWHk4a0MwWTZC?=
 =?utf-8?B?a0grQmppbEVET20yNWhWNm5jenppbG1sM0Z1MlJ6dS9udmJvZ2hwMFhyOTBk?=
 =?utf-8?B?OXpiSmNYT3l6d2NnY09vc3VmZWFEblNCdWJ6NlRFRzdNcFdwalhEQlZLVS9I?=
 =?utf-8?B?cXc0OU11VklaL09PSnZqSW02U0tRSXpBc0ZGT3hpcW1JcG1zODRzQVhHQ0pK?=
 =?utf-8?B?RnU0S3F5aEJac2dZS3Z5OWRRRmRROTVGb0FDY1pFaTZPZmE0NGhZUHBFU29s?=
 =?utf-8?B?ZkxMZFA3YlBZRkhkUXQzb2YwczVxMG5ubmk2dFd6aDBYQlZzT2J6MHNwWksw?=
 =?utf-8?B?V1AvUUxIWW1WcUg5QWtlVW13QlZGZDAxc3FOa05McDZJcjQ2TEZURFZuN1hE?=
 =?utf-8?B?ZW81dUlFWGhVd0ZBWll6L050L0ZSRSsyT1ZqM2c3RjlRcDloSjNya3pjMWFT?=
 =?utf-8?B?bXVGaTA1cG8rTHljbUVSZkdWTlZZUCszMVlaYjhxMmRqaXlyc3ZLcWYwRkYx?=
 =?utf-8?B?eVBOcDFEQkxtSDdoRjdhaVJsNnpISjhkY2tQUWZPZUxBcDB2Vkpnc05TQmMr?=
 =?utf-8?B?NkkwVFQ5b2pmR0prMGJ5N29yemcvOCt0eCtVTWhyc0hFWjV0UEx0NnNzTmNQ?=
 =?utf-8?B?SXhYRHBPMldVYU5YdjNVQWg3NTAxODFnZ2I0VlR6Q3N3NFBycWFXRkVrUDRh?=
 =?utf-8?B?MnhDL2dnTmlmYitGRU9uSE8zVjUvWHBqTTVHcitLVEp6YXJldmV0dVcxNDFp?=
 =?utf-8?B?S3YwWWZMdzFHcE9WYkRJVmFDMGxjVXJWOFN3ejVuRm9iTXhRc0NOclNTQ3Y1?=
 =?utf-8?B?UG1wZWF6bGNHNXNFaVVTcXNRZDZxWFMrZzBqTjBKalUrRmlXSGdoV0Zsdmo0?=
 =?utf-8?B?RVlHeEdudE5XS2lWSE5XUWtRV295THRXZmxKRVlOS0w0RFlJOGpZd0xXME9J?=
 =?utf-8?B?OW1WZE5oYnpzRThyWFNuNy9IaFp2bERuR0JsaFJkSVg0UzQxTTFJaERhYURL?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GyR1y+TPMvd0thdeH6OfHAJlLWc3UBdR42kOdfiosaQpE8DTi9JgH8HC0Jg1EhwUJAZnpfbboGLXrNyGKgaGK4P432TLbpj+C4+0X/fr/DrH9lkD8CGcEbGyD5S9rLswqXZZZOSHShzHuBBWzfqM6WXsQexZqgtC5t9Z4Kee2c/+vNjhpE8cLHIwfqs9H/+gy6wA655n4dRarw1t42/wWZMfH566IvTRV9bUQzWLemEGSpMVuugCl1YQvbu+0xh7Prx6wmwQgijdMmcldi2nG5GuCONsza6LFMDcRKMEoH+YYF08BWb6PxFStWmmYBcgTvauhhkY1KOPEYiy3aksAAbkVWiNVkAjc37SIVMxlcVKvONLqr+WBcQUzbsBTu5rS5CznwVG7pSNExpxmzxzTQOGu6DmQOyrMPSfkKq1sc/GOVuv34BefL+ooxRkqVIz7aFvPSggXcsSc/6vTxH5tALnNuMgBg1i13TKaLJQzsVgMEbDHnf124XzJsN8mZ/mUGhL093H4Zleac1/QBRU47ki7R/xTiKfAGY+P9dyvx6t/ES7WluFEj4CbNXiG6KAOes0/icv4Y0h0okWzPz42LBkrWnppF1JGzv5lj+5QDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb4bece-76cd-46d1-1d12-08dd79164e72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 16:31:27.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRzAZZAyHfCkeBTfrr/M74FixvYwXsv405bAacKnIdxWt1xNiFgpnKCGyLViDObf8bY5tFDYFeqtjE6aUi7/P649hmAKiNK2VJO8PMZk/EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504110103
X-Proofpoint-ORIG-GUID: HSBINNohZNZJFFStotMTrcfanFXjyndx
X-Proofpoint-GUID: HSBINNohZNZJFFStotMTrcfanFXjyndx

In the page to order 0 folio conversion series, the commit
7e119cff9d0a, "ocfs2: convert w_pages to w_folios" and
commit 9a5e08652dc4b, "ocfs2: use an array of folios
instead of an array of pages", saves -ENOMEM in the
folio array upon allocation failure and calls the folio
array free code. The folio array free code expects either
valid folio pointers or NULL. Finding the -ENOMEM will
result in a panic. Fix by NULLing the error folio entry.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Cc: stable@vger.kernel.org
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
---
v2: sorry, ocfs2_grab_folios() needs the same change.
     the other callers do not need the change.
---
  fs/ocfs2/alloc.c | 1 +
  fs/ocfs2/aops.c  | 1 +
  2 files changed, 2 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b8ac85b548c7..821cb7874685 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inode *inode, 
loff_t start, loff_t end,
  		if (IS_ERR(folios[numfolios])) {
  			ret = PTR_ERR(folios[numfolios]);
  			mlog_errno(ret);
+			folios[numfolios] = NULL;
  			goto out;
  		}
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

