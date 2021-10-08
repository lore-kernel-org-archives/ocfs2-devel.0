Return-Path: <SRS0=Bxih=O4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2777CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Oct 2021 10:50:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7C9360FC1
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Oct 2021 10:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C7C9360FC1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198AQN7A029276;
	Fri, 8 Oct 2021 10:50:24 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bhwfdr522-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Oct 2021 10:50:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198AioPf158469;
	Fri, 8 Oct 2021 10:50:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bf0sbn83u-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 08 Oct 2021 10:50:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mYnPD-0001zi-Nq; Fri, 08 Oct 2021 03:47:11 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mYnP8-0001zG-03
	for ocfs2-devel@oss.oracle.com; Fri, 08 Oct 2021 03:47:06 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198AkAFG156740
	for <ocfs2-devel@oss.oracle.com>; Fri, 8 Oct 2021 10:47:05 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bev7xu2pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 08 Oct 2021 10:47:05 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1986K728024919
	for <ocfs2-devel@oss.oracle.com>; Fri, 8 Oct 2021 10:47:04 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bj57gm03u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 08 Oct 2021 10:47:04 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-17-JlqLj52tO0KofDpOw1VTSQ-1; Fri, 08 Oct 2021 12:47:01 +0200
X-MC-Unique: JlqLj52tO0KofDpOw1VTSQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=mFv9MJ72h8Xc6tEFxYrsEM9cWo1GtQsqmrJ9kLH2EYhttC+0dkQj3IgLeaUJ7yVUN3Lj4u7sauM4Z5F09ldUTYtR9GNaukwxTUKrD5MsOmOV+OKdHnCioXFY3CrKj1QYophigwLeuazW2pdZLR9e1gdzgx4B/ga1jYQ+CJsHvVr7MK0lT2sV1cNHOP5u6bVM9RwA/kASA4oi+sz4iluUtHULw2d6ZBE1AxvnIvbCJkBLnzQB8zHJdFFdvbs3wRtoJcwJqbijY2RHuJyP5bEs+YN4oiTbtSRUy37UFD+yoQnY00wUal26nx5JpcMzGiEFGJBC7Q4A+VskOHxsdR2Jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=MN5n1BigSXnBKmGqkgLOBIrpX0LMH4Lf15wkbiyyaiE=;
	b=bG5fv99KCh3aETgF+r8BlsxcqMVJzcAaRdHUqmyWAdzlHBtyx8Nhex/gDih+vyAqXCLjlZmdfghEDSUrBRTdvi5DcVGIv0hsDPUveY5GaxT4x0Aj1EPi5O9BHTR0NQl+skNvn2P1t3TBWaXA+pCHZec7jvxGS9HMvg1AkRzif+PeS14CoDtuZyhtnAMt/5PFfZNv0OksaITgAAQCrVW3+7KjAcjPbmFAaKxByRDnPerE0TjETp9xbedeQ8iBN4ZX4O925UZ7rD5YxFr0cEwBBoOH7yukiW+oksP4YWKTkZUEuscU5sQFUjCKNPCisVeOPFAJjyPePCY/oYqk9LHZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM5PR0402MB2817.eurprd04.prod.outlook.com (2603:10a6:203:99::8)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22;
	Fri, 8 Oct 2021 10:47:00 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::e989:6ee5:2367:49e0]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::e989:6ee5:2367:49e0%6]) with mapi id 15.20.4566.023;
	Fri, 8 Oct 2021 10:47:00 +0000
To: ocfs2-devel@oss.oracle.com
References: <1ab61ba3-8c9b-092c-7843-9c45b58e3987@linux.alibaba.com>
	<20210929180654.32460-1-vvidic@valentin-vidic.from.hr>
	<a1bea8f5-91bc-66c2-0262-cb091b15b4d5@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <6717b5a9-260a-0db2-e5a4-a3d14272b63a@suse.com>
Date: Fri, 8 Oct 2021 18:46:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
In-Reply-To: <a1bea8f5-91bc-66c2-0262-cb091b15b4d5@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HKAPR03CA0016.apcprd03.prod.outlook.com
	(2603:1096:203:c8::21) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
Received: from [10.67.20.87] (60.251.47.115) by
	HKAPR03CA0016.apcprd03.prod.outlook.com (2603:1096:203:c8::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4
	via Frontend Transport; Fri, 8 Oct 2021 10:46:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f948203a-f234-4e5b-3427-08d98a48f512
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2817:
X-Microsoft-Antispam-PRVS: <AM5PR0402MB28175AF39A0D966B01E2E922CFB29@AM5PR0402MB2817.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGmfNdTJqKUTFZVTUPka90JbmVb/5KameKt30TiUzOgYP0YiHIDhMPfU4bQnZcSRctNeNiy/NYVoTfrci9ieEneBfMF22ga9Tyt0iTb3uyT3U0c21dlD07qnx4l+96LxmdtpkVSaQGJ15zvpqL2SqyBcJT9x7C6AFxPQlSUem77JPL8baqoBerCk5eBYb/yIYFw/Vrk00XzBgypay2yiwEPyaXaR2X+A7Ll9mnyUHbJN2mGyK3bF1IycaPkKwhHkIoyigLPq7yv7kzSZN/tJ5k58wC099H2eFFEYOyWMTWWLm7SmzdebTV1TwDXDacmpfyayu9qifVnHVJ9ceqhm5G7IrogOOtoac6zLmGbjR7JGXj9BI/Iz55ENd2/XXQVwdB8kK1FwFv962/nuP1jUI8mg8y2wDe1+3KuYyCicq/zwW4uFnjwPPXZyzPQSIHbW62fPx+MNY/XKQnL56uK+r1wfTbvHwIJoOxYHK9nXoH61qxEmxDXTO+P4STW3IWPOpVbhEBGHvcKVj13xP/cQDm+j7JENZW+m6XJjKAgnOUs5uh/ROjPdKom9dc5LzlPeF9Hib6fRb5UqDuZmombqPAStbxrosCB1OgG/IgKTtO36lt0G46+4UM+RD+OPJlJ5XgiZ8PQqb8vbFUV5wlbRKKXwDVvxicLUSojJ0QA+MtvQkiq1maG9IuFEuT1T8vlKtElkxmtuwL0GuOGrj/gvfFYTXmYnpcA4RlXRG1UY4j9Xj5CvOBcPZXXwz/r7G9vexBEXTO+tsN1Dhv8ROLUlHK1KWIaYQtYvRFkytzOCfbNLrSh8rTn6c8XveljwJlE9
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(6666004)(66556008)(316002)(16576012)(6916009)(956004)(31686004)(66476007)(26005)(66946007)(966005)(8936002)(36756003)(6486002)(38100700002)(2906002)(186003)(86362001)(55236004)(83380400001)(508600001)(31696002)(53546011)(2616005)(5660300002)(8676002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDl3TEMrWDZ6ZHRSTDBMajFNeS9sSDVPdHhJTWlvWU9wN1JRNVZXK3VJTnI5?=
	=?utf-8?B?MEJWWERHYWxUTXAzWjFQR3lScXhvRmprYkQ2Uys5M0ZLc1BSR0ZvU1JERml4?=
	=?utf-8?B?M3BXbVgrS2MweHk1ODY4eUZVRzRKRmdjdXN2UzhibnoyZUxuazJsL3ROUUlN?=
	=?utf-8?B?T0s0WlpjZ3RBMVlvK1ZFVGZVcUJ6MkJpUTVwZGp1Rmc1UER5M3ZzQzkweFJi?=
	=?utf-8?B?ejBENmgvRUxIdmRpOHRxNFJuK3pGYVEzaC9sbldTM3M3cFptWXBTSW1YNEkw?=
	=?utf-8?B?bHdwVzBuQUlYMkhRTlo5c1VndXhJNzE3YzF0eU9zRUlLODhZd0dtSHRkVGow?=
	=?utf-8?B?WGxuOWdsUnZsYnZ3VWprcEJhVDJHbWttc1lWSXN5anZyaEpicC9hQVhmSUc1?=
	=?utf-8?B?RStiQ2dHM0htVC9sOTRkeG95MG1MUUp0dnRMUXFHNWFYWXRuZEZUcTdKTHhk?=
	=?utf-8?B?dDl3bTR2aXlibGdULzdCdjRTZENJc3k1TFdwWmNCdkpLZDZFMzhlTk9VT1A5?=
	=?utf-8?B?R3lISFJaUEMwekF4ZlgxUjlBMkRVc21DdHZha2wzVW81VVg2M0xQM2xrWGFP?=
	=?utf-8?B?d0hnSVpGSlJSYXBPMVhadDRCWU1iNDYyL1N3OW5WVUNzYWdaaDV3Rzc3MHEr?=
	=?utf-8?B?eTZNcUxIOGVoK1oxWkwrSEx2cEZBMC8vblNSUmxJS2hiY0RGTVlacGVTanlT?=
	=?utf-8?B?WjRWWHZlbEY5czN6ZGRTckcvSTM4M0JteFFDZkgwck9tWGpld0MwVis2VHZS?=
	=?utf-8?B?MXFFTEdyVjd2b2VycG9kcDZmSE14VzVTb0dNb0ZXYXZFeGJYVHl2dkl1ZWor?=
	=?utf-8?B?SmRXTUowUnVYY1NOemIraHBDQ3pPQmg4bFV1U1hPMGQ4TklkdUhxQnF1aVA3?=
	=?utf-8?B?dnFWd1hHQ1M0UzMxVWdLMHRDaTc4UVIvUFZES2FZLzVSOCtyeDR4Z2tNK09G?=
	=?utf-8?B?SUhha0xVMHZRNHdXL0svZGxOYzFIMzd4NlVGUG1OZC9USzFiVERiTzJ1Qll4?=
	=?utf-8?B?dUdRWjNDTmRmZE9zYWFPVWd4WkZGbnZGbk90bUo1STNqWC92K1ZNSUNRVm1w?=
	=?utf-8?B?cHIvWTV3MlF4SEVmSGZaTEZRVnVSU2M2N3hJaUpvYldlWUJSWlN2elUwZjR6?=
	=?utf-8?B?U1VhNzBSMTFSOGpMb21oT1pqOW54N3V3YUM5MnhKdVo4bTB6R0JTRHByTlJW?=
	=?utf-8?B?aXVpY1BUYkdiOEx1VDhQaVlReFJRcWQxR1k2QjNuYVE5U2ZoVE1vRVVrOFh2?=
	=?utf-8?B?YjBCcWxrRmwxTFNxQVY3ejc3TWhKeW5ZQ205L09sbHNuTTBPM2tqbHlHTXUv?=
	=?utf-8?B?a3dXa2oyWU8zNkRkM2ZsV0JiN29EazZldm15TnhYK29rV0F4cEc4OXJNYlA5?=
	=?utf-8?B?RllxZUZSS2tYRjQvaUViK20xOTNUTzJZQmdHbE9MbGtIeEdUUlY2dDBtbHUy?=
	=?utf-8?B?eVkwL1VJZzNCTnNCUzNibnVBQldsZlNLK2RleVlqQlJrSHJua3VRdjgrd2lE?=
	=?utf-8?B?cUNNeHpHK0sxeEJ3SW03bURjVjh1Y2lyS0ExQWVtVFErOTlDbGttcUU0dEl6?=
	=?utf-8?B?aWlNS1N6dzNZTzFqUmg5WUg0VWhQc3UyZEZBVCtxREI4NFJmSmJaWmRJaUNP?=
	=?utf-8?B?cWZla0o1VVNydlFnMi9RREdpSXpOQ05hNVpwcjE5RUdER2Z1ZnZMbml0Mysv?=
	=?utf-8?B?TTh5SmU1VEZ3Q2xTbGRVS3Bha1c4TkhDczhtSG5SMVVTRmRETFZWS2VBL3Nx?=
	=?utf-8?Q?KghebtFMPzm8cfFOWXRpJjDRqEw9DUYWrM+2rt6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f948203a-f234-4e5b-3427-08d98a48f512
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 10:47:00.5873 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nlam+nta2uyyWaycCFj/fcN/BRvviLLvwqpYes9qK0pfGcibC9AxT83wrXxJuwAm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2817
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	clxscore=289
	spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
	impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=176
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110080063
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: mount fails with buffer
 overflow in strlen
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080063
X-Proofpoint-ORIG-GUID: lI6Hc8rNWGZRpSvW59Czdvjd-kNkFKyB
X-Proofpoint-GUID: lI6Hc8rNWGZRpSvW59Czdvjd-kNkFKyB

Hi Andrew,

This panic looks urgent, which is blocking our CI testing for new SLE 
releases.
If possible, please help to merge it to Linus git tree.

Thanks
Gang

On 2021/9/30 9:54, Joseph Qi wrote:
> 
> 
> On 9/30/21 2:06 AM, Valentin Vidic wrote:
>> Starting with kernel 5.11 built with CONFIG_FORTIFY_SOURCE mouting an
>> ocfs2 filesystem with either o2cb or pcmk cluster stack fails with the
>> trace below. Problem seems to be that strings for cluster stack and
>> cluster name are not guaranteed to be null terminated in the disk
>> representation, while strlcpy assumes that the source string is always
>> null terminated. This causes a read outside of the source string
>> triggering the buffer overflow detection.
>>
>> detected buffer overflow in strlen
>> ------------[ cut here ]------------
>> kernel BUG at lib/string.c:1149!
>> invalid opcode: 0000 [#1] SMP PTI
>> CPU: 1 PID: 910 Comm: mount.ocfs2 Not tainted 5.14.0-1-amd64 #1
>>    Debian 5.14.6-2
>> RIP: 0010:fortify_panic+0xf/0x11
>> ...
>> Call Trace:
>>   ocfs2_initialize_super.isra.0.cold+0xc/0x18 [ocfs2]
>>   ocfs2_fill_super+0x359/0x19b0 [ocfs2]
>>   mount_bdev+0x185/0x1b0
>>   ? ocfs2_remount+0x440/0x440 [ocfs2]
>>   legacy_get_tree+0x27/0x40
>>   vfs_get_tree+0x25/0xb0
>>   path_mount+0x454/0xa20
>>   __x64_sys_mount+0x103/0x140
>>   do_syscall_64+0x3b/0xc0
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>> v2: update description, add comment, drop null termination
>>
>>   fs/ocfs2/super.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index c86bd4e60e20..5c914ce9b3ac 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2167,11 +2167,17 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	}
>>   
>>   	if (ocfs2_clusterinfo_valid(osb)) {
>> +		/*
>> +		 * ci_stack and ci_cluster in ocfs2_cluster_info may not be null
>> +		 * terminated, so make sure no overflow happens here by using
>> +		 * memcpy. Destination strings will always be null terminated
>> +		 * because osb is allocated using kzalloc.
>> +		 */
>>   		osb->osb_stackflags =
>>   			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
>> -		strlcpy(osb->osb_cluster_stack,
>> +		memcpy(osb->osb_cluster_stack,
>>   		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
>> -		       OCFS2_STACK_LABEL_LEN + 1);
>> +		       OCFS2_STACK_LABEL_LEN);
>>   		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
>>   			mlog(ML_ERROR,
>>   			     "couldn't mount because of an invalid "
>> @@ -2180,9 +2186,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   			status = -EINVAL;
>>   			goto bail;
>>   		}
>> -		strlcpy(osb->osb_cluster_name,
>> +		memcpy(osb->osb_cluster_name,
>>   			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
>> -			OCFS2_CLUSTER_NAME_LEN + 1);
>> +			OCFS2_CLUSTER_NAME_LEN);
>>   	} else {
>>   		/* The empty string is identical with classic tools that
>>   		 * don't know about s_cluster_info. */
>>
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
