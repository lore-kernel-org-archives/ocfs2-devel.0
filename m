Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0382C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 00:57:57 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C45960D42
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 00:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C45960D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T01tXB027662;
	Wed, 29 Sep 2021 00:57:56 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvc3snh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 00:57:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T0uQVe052396;
	Wed, 29 Sep 2021 00:57:55 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bc3bj5n2g-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 00:57:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVNuz-00005S-PY; Tue, 28 Sep 2021 17:57:53 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mVNuZ-0008WH-7J
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 17:57:27 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18T0uPN0052315
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 00:57:26 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bc3bj5mrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 00:57:21 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18SJJZhC030967
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 00:57:20 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc5hcyk96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 00:57:20 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2110.outbound.protection.outlook.com [104.47.18.110])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-24-CQdCwzECPR-H8V686glkTw-1; Wed, 29 Sep 2021 02:57:16 +0200
X-MC-Unique: CQdCwzECPR-H8V686glkTw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=OmDGMLXdZ/EbyStkwtDLspa3c7EmmRzSWHkZVzIB4r7/9Y3dqI5IfpseTH5XP1c/CfvYSdlCZyX+mf0mVySwQLv9X9ojwL7B3DRz9cBEVgtn9xOpq3mknemMfuOIr/nGBJdHo6r6dU+VtewTd0FVcf33ziOaPrhqRZ+tX6/vt16hV08hBwoYnxZ1NgUP1tDLqZqEVA6LZQ5/8rtWwGP4/VyQ4UNzsF/d+aA4mfqXlwfBv7gu4xL3zBRSINmVt0cE0yRY0lgzDmYajmhr3C2o7c/TGNgALHQH+jwCQJvZGgOsQxyG9nYZbnn+hOraagxEvTLqm8PeJ7Xx9XZYbe7UJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
	bh=XIG6UtblQ/8F1e7J8OCoCJ75i7mO+cDz6zVnv5v+IzY=;
	b=FQVg8gS2p8y7xwnVzk/uFChk+twx7hWFdSAYZFBxvHvrkqISQpPsR2/v4oVmHeQisu+jOosD2CrQ7VuM0RlDldCd2piRYCP/hhCUdQVlAu2RZC5VlXIW7wAtQlqW/0n5Ra5gBookyWdbz/ypPybr3N0b92DfPkOPEMcscNxs3FPVLJmpfrqIdYTcHJhf2LVYaFIFHMpLMuE9GeNpZse8rmiDQQlS8DJZMuL06yNv1cJG2OP49Ggfho2HZwfTo0Jj4VtTfwJcJ82TDiAsFzxDgYC+IOkh+uy5jX/Z0ri4pXH47GU/AOUfJgCCG1YSEF7AVEPUH8hAoqBM0nWiPHCeXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM7PR04MB6790.eurprd04.prod.outlook.com (2603:10a6:20b:dd::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13;
	Wed, 29 Sep 2021 00:57:15 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4544.015;
	Wed, 29 Sep 2021 00:57:15 +0000
To: ocfs2-devel@oss.oracle.com
References: <AM6PR04MB6488C35E2103DFC0BF4AF896CFA79@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<816ee511-5764-aeed-4554-83b91de8e06e@linux.alibaba.com>
	<1190fbe9-f53d-d35c-6631-ba71f4f92bd1@suse.com>
From: Gang He <ghe@suse.com>
Message-ID: <9b1a45f7-ff5d-8c0e-bb72-5b7edb4d7573@suse.com>
Date: Wed, 29 Sep 2021 08:57:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
In-Reply-To: <1190fbe9-f53d-d35c-6631-ba71f4f92bd1@suse.com>
Content-Language: en-US
X-ClientProxiedBy: HK2PR04CA0067.apcprd04.prod.outlook.com
	(2603:1096:202:15::11) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
Received: from [192.168.1.110] (111.205.14.55) by
	HK2PR04CA0067.apcprd04.prod.outlook.com (2603:1096:202:15::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13
	via Frontend Transport; Wed, 29 Sep 2021 00:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78cc4c5a-06f5-4ecc-6f89-08d982e4143b
X-MS-TrafficTypeDiagnostic: AM7PR04MB6790:
X-Microsoft-Antispam-PRVS: <AM7PR04MB67901383FEA5DF13A3F96625CFA99@AM7PR04MB6790.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7ApQsIxy5+R1CsBDTuDBeV3SvJ2hFmTznOuVnkZPLgouGOsBSdIrpi4TrrTYdBTCd4aJuOcLXuvteOhQTVpizXGi6z0nbu0f7Ma8CrLQ8kSEP8tiyn/ZrzbvLIGBQCWSZ7ouxt/YggeXg7Fnn5N6Jpb4JPFGtUtigT0CdEPEs+YcS4P5b/c3GHLd+MaqVEL6nO3j6VBH6e3EPtkO6iO1KrUtynCKRAoho0qpE7mrf/44AumUMKL4Sxv/VirlP+DFkDQsknmfKEIhBmTgGXe3WK9udcoJOA74+3r0oU2Uiu3TI/h3fTN2/Up/cH1bZ0i0F8j+g93K7JamGEEuEyyp0TxxoIolf6E2Ge07GXj7JKFKTVbM/QSzFlHcof/7JPjYDpvHHUzsuCpNIZ8si+y7O0wADwNLDtVJXuj7/V/l0lxEWNOS1DOIkUnc16tSncodKnxGwEa79q2l9YqfpctcG1G2FXw1rP6GWApPB7AJ76xGJ75gPVjDk2u/zfLi0WVMXji+rmmsen2TAXn+VwJErVKxDNjPP5qDkzDD7BlwhUkjnLEXRg0s9OZq7HlfUEtLXGmeb+bgouQMjop1D5Zi6LsCJj6Y8bnnKGZX4jvJRIUlV2FBvOUM54V/ciX0cplZSFimCpA8xReq+sNyzkgryCxLIbEtGhdOePVkVdypr7gcW1fvqJ9NtlrI4bJnu8MnsCsonrV5MoiMdhi8sGNfzr2jnG3PAXOjeDERhWXkJKuyhKQHx7nCcFV1r3thfwHZZUfqAd1vtKeZKZ8u64Jp7DO/LjXPfyiv/yjUT1aqmA+yDjAkk99n10xYmlWg40gGXFj1TgQbeEuTPqYkSyg94VlkK45Jhe6LLQWIKBV0pHb5iE0A3ihMI9CijCRpMRiDi6F1JksiWTtxX7q6EE/+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(66946007)(956004)(5660300002)(6486002)(8936002)(66556008)(66476007)(966005)(83380400001)(6666004)(38100700002)(36756003)(316002)(16576012)(31686004)(31696002)(2906002)(2616005)(186003)(508600001)(86362001)(53546011)(8676002)(26005)(6916009)(10126625002)(13296009)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExhWXY5eEdYNU84UTFkVEJyUTdFNVhXaW52Qlo4ZW9pOHdWKzV2MUM5aklj?=
	=?utf-8?B?UmxhdFBxNjQzSlBtdUFmS3VyUmhGbkJjV0xSci9jZSszUHVyc3RzYnNlV0hT?=
	=?utf-8?B?Q0RTRkN0V1oyUElsc0VIMWJmWGc3bytnY2h3K1RSbzAzTndLWElhK0lRNlN6?=
	=?utf-8?B?K3hYWmtqYUdmbXZ1b21pOU9rUzFkZXQ2bXNleUlhenhOWHkrUUNCYWFIbnNW?=
	=?utf-8?B?bHd1ZzMxdDVFSWx4TGFqVU1uTXVRWHlhZlkvaDI1UWNhMEVMME92MG9lbVhk?=
	=?utf-8?B?OE1LMjZhYkdJNDZXRGM3eUFiU2hPU1JKdXdBaUlPV0ZzUlhBVFNqT2FWUmVa?=
	=?utf-8?B?UFRjUlZoZW9icGZBbFRxZzhmb0ZDUXlVZERVZ2xpL2NhNjdidUR2a3VZTm5C?=
	=?utf-8?B?RzhLTE1pUnFJSy9mQlZOc3F1U2dRRFdGM1lZR2dxZlV1S0h3TU5TQWpidzZw?=
	=?utf-8?B?cmlDbDEwUkVIMEZCNy9vQlAwa2V1WkxrRG42R3p4aDNnYStnYVEvQkZJL2FH?=
	=?utf-8?B?MEFDSDRWa2M2WWo4TmY5cWRnTThUK2pZanA0cFBmNTA4OTdUbVVSUlVpaytx?=
	=?utf-8?B?NWhSVXAvdU5vT0dZZVdrUHBFMGdJbkZWOG5tTU5jY1RDaHI3ZU5HZDl1TVlY?=
	=?utf-8?B?K0hyakd3Y0g4UnFuR2E3TWdxMk1OdzQ5WFlzTndBQUd3Z2ZkRDV1WnVicDE1?=
	=?utf-8?B?OGdzNStBUEdOaHQ4WXNiZVRremZWUVBuRitpM1pFcUVmYjRYWVhMN1pqR0Rx?=
	=?utf-8?B?SURIZ0lGRjQ2TXpXOGpQajZxSzhYM3YxUEcyR3BBd2hvUERVamlOSGcwNS9m?=
	=?utf-8?B?OWNpZ3ZmbWpJdHlqR1dkcWpVaU01RTJPRTNCYjN5endmVzJITjZNTHFpQVdZ?=
	=?utf-8?B?RzNvbUlKVDg4ZmlNSFJzTGZwSFlRa0NmSkZtd1dsRWcwdk5VN0t5V3kzaFgz?=
	=?utf-8?B?c0VUUlc1bVNqMXJ0bUFHNWhyWjVObjMwdTNFempLNW1VUng5RVJxbmdyU1Yw?=
	=?utf-8?B?ek1YbXZJcHpxVU9YQjRSY25tWGgrNy9kUUlkVlk3ZjJQMXVvelY5WUxyZnh2?=
	=?utf-8?B?UnR1amdRRldETWpyQkh0R3p3YlM3VnBmY014NTNHMEdkZkdpeU9HOGdDdTJW?=
	=?utf-8?B?TDhBNVNON2F2Wm5BdjFic09ReWZ2bGE3dVpPZ0NrQ1VaYXkzNXhpSi9JZGpE?=
	=?utf-8?B?YjFGN2ZDOVVrdm15Y29kK05VeFFvazlIWHdFYjFoRmtWVktMZVhVTWZwazFB?=
	=?utf-8?B?QWxrM0ZXRmprdCtiZEg1cUt4U0dRWXdlK0VjZURUc0s4MW1Fa2VMWmx3Q2E1?=
	=?utf-8?B?bjZZTGZJckwreXVsWThtT2Q2YnNyRzg1VHpuMXNzTk5uMlVWcmd1Z3dSc2Ro?=
	=?utf-8?B?QU4wdlBRMUNQQ2hFNytmZGdoRnUzZWdNbXJwN3lvUXR6R01HM05DWForK2Ny?=
	=?utf-8?B?S0xNbkxzR01XNE5yNHZnTjBuRjhiY2lydlZxWHpHUjkrRE9yeHFDNWhzbmJU?=
	=?utf-8?B?QkdzVllzK1kya1ZaTXVwM0J4YVFrNEJFUlhGenZteGVmKzZGT09jaFhMNWwx?=
	=?utf-8?B?cW9KWXpEUElyU0Vnc1h2UHRGZjlkbHhqQUtOams3TXAzM2dRV2g0cVg1bjRu?=
	=?utf-8?B?UXRJTG5hREpKc3RhVmZ3UHBVN08rR2o0UGhFNUw4MXBHZnhkYXpDT1RZUXJu?=
	=?utf-8?B?MG84NjFqd1ZKMlMxK0trd0xwNjQzQVF5TjI5TFJ1MTJPc0Vxby80Yk1mc0tu?=
	=?utf-8?Q?vSBEDw5ou4xvRsOGn9nzWZx8HKK9PavFI9M7l5V?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cc4c5a-06f5-4ecc-6f89-08d982e4143b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 00:57:15.6118 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzwBm3B8Xsr2PMFkj5uuBKNy1uxt3V7K96dRBz5ZxC8uixvixrTMDXKm5sXxpO88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6790
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=134 mlxscore=0
	clxscore=177 impostorscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
	bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109290002
X-Spam: Clean
Subject: Re: [Ocfs2-devel] The last part of the file is zeroed out when
 write N random bytes
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290002
X-Proofpoint-ORIG-GUID: ANWpPa6IChwCvK3tBU4I_4tdAhnbP9Wn
X-Proofpoint-GUID: ANWpPa6IChwCvK3tBU4I_4tdAhnbP9Wn

Hi Guys,

Just give a update.
Based on our testing, the problem was caused by the comment in fs/buffer.c.

commit 6dbf7bb555981fb5faf7b691e8f6169fc2b2e63b
Author: Jan Kara <jack@suse.cz>
Date:   Fri Sep 4 10:58:51 2020 +0200

     fs: Don't invalidate page buffers in block_write_full_page()


Thanks
Gang

On 2021/9/27 15:57, Gang He wrote:
> 
> 
> On 2021/9/27 15:49, Joseph Qi wrote:
>>
>> Last week, Andrey Markov reported a similar issue, but unfortunately not
>> on mail list.
>>
>> And Junxiao has resolved a similar issue recently. So can you reproduce
>> the bug in latest kernel?
> Yes, I can reproduce this issue with the latest code.
> The cluster size must be greater than 4K(e.g. 8K, 1M), this is the key
> to the problem.
> 
> Thanks
> Gang
> 
>>
>> Thanks,
>> Joseph
>>
>> On 9/27/21 3:16 PM, Gang He wrote:
>>> Hi List,
>>>
>>> I'd like to report a data loss bug when write N random bytes, since I saw there were some related commits in the past weeks.
>>> I can reproduce this bug stably with the latest ocfs2 kernel module code as below,
>>> 1) Create a three node(e.g. ghe-tw-nd1, ghe-tw-nd2, ghe-tw-nd3) ocfs2 cluster, attach a shared disk(e.g. /dev/vdb).
>>> 2) Format the disk with the command "mkfs.ocfs2 -N 4 -b 4096 -C 1048576 /dev/vdb", and mount the disk to /mnt/shared on each node. The cluster size must be greater than 4K, this is the key to the problem.
>>> 3) Copy the file write/test scripts to /mnt/shared directory, then run test script on node1 to reproduce this bug.
>>>       file write script ocfs2_fallocate_bug_plain_write.py: https://pastebin.com/QsXcD8rq
>>>       file test script ocfs2_loop.sh: https://pastebin.com/eTUe2hkW
>>> 4) Then, you can meet this bug, the file md5sum is different between from node1 and from node2.
>>>       In fact, the last part of the file is zeroed out from node2.
>>>       e.g.
>>>       file dump from node1: https://pastebin.com/HB92TVS0
>>>       file dump from node2: https://pastebin.com/jBG7HdSz
>>>
>>> More information,
>>> this bug does not exist on some old kernels( e.g. linux-4.12.14-120), but it will happen on some new kernels, I feel this bug is probably NOT caused by ocfs2 commits, since I used old ocfs2 kernel module code on the new kernels, the problem also happened.
>>> Anyway, if you have any comments, please reply this mail.
>>>    
>>> Thanks
>>> Gang
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel@oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
