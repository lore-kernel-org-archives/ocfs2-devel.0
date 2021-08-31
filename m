Return-Path: <SRS0=ddK4=NW=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0344C432BE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 31 Aug 2021 06:25:58 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6535D6023F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 31 Aug 2021 06:25:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6535D6023F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17V6K4px022218;
	Tue, 31 Aug 2021 06:25:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3asf2mg0a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Aug 2021 06:25:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17V6Fnvc035890;
	Tue, 31 Aug 2021 06:25:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aqxwsvnc2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 31 Aug 2021 06:25:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mKxDV-0003At-A5; Mon, 30 Aug 2021 23:25:53 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mKxD1-00039v-KK
	for ocfs2-devel@oss.oracle.com; Mon, 30 Aug 2021 23:25:23 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17V6FjTM093831
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 06:25:23 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3aqb6d94r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 06:25:21 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17V4Zuhd020156
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 06:25:21 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aruywcag5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 06:25:20 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2054.outbound.protection.outlook.com [104.47.0.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-1-JGVuA7LTOga7aikZkL7drw-1; Tue, 31 Aug 2021 08:25:17 +0200
X-MC-Unique: JGVuA7LTOga7aikZkL7drw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=i31YOCQGWZ+gkaf1Yr9E9DJ7onNkpBbn8lNuXMcv1e7LmrbO7RvxN3Sb43ayH+8auhewCOC7xQJR0oNr80ndOKcnYy98vWNcv7dwISgM9KC/NY6PK56GNXlrljAKPsT2pQPLg9lMxgkvB+0S/B6YyFofhSE7xVEkzvNCDwI4+fkFeuwnzJbA3eo7jmq7DKBGXBIsIY3Iv2F3i2HyWOFa8tOqyi0YZtHuTkqHSYcu+CkypdNi+mzzhzXrQXhr070wH9PqKG8ItSNYF8S5t+fTCQ1c7EUaLOcP0LfOn+RYmVaui6Fkc/CqLx3XM53dFviIcczL4jyUGnnpLsXhln1+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=rwy8dPYWOEApu52DE/6J2Bfq56iAwxHkgPFP4DsvP84=;
	b=kNSF5C3PT02HqrPw35VY1RQexa67crFMjQUGXbXMwkqJwLxzKOZ8uv58acuvS3Dy2vno0yI+XeNcce+QdO6jWm6y4OAr6Bnx0YO9PiUP2EzyKC8iGHONjJiCLbVpIMrAAu9cPa+VrBaMiuY3Ci3WsRsV/wxTsONAw+aBa/ql+EC8OHG6gUfw6w/o8wjuV60iiwZ+9GbuMgC9trGJ/cdrDm9oNo2uZSvPw5/4cSt1NTx5gJvlKw1zjtxGmzYIuPQ4Kcno0Trz3+jRfyMA8a1ReDyUKoFd1/LJM8ueaaIeyf1ISJsjV1cPDHJdv/m+KW9qGeKQxrdIOQegQFXNi81X2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB6487.eurprd04.prod.outlook.com (2603:10a6:20b:f7::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19;
	Tue, 31 Aug 2021 06:25:15 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4457.024;
	Tue, 31 Aug 2021 06:25:15 +0000
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
References: <20210826075941.28480-1-ghe@suse.com>
From: Gang He <ghe@suse.com>
Message-ID: <744d756c-7640-d312-37ef-126755324e8a@suse.com>
Date: Tue, 31 Aug 2021 14:25:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <20210826075941.28480-1-ghe@suse.com>
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0057.FRAP264.PROD.OUTLOOK.COM
	(2603:10a6:100:1d::21) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	PR0P264CA0057.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18
	via Frontend Transport; Tue, 31 Aug 2021 06:25:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 557ef6ec-f00f-429e-4eec-08d96c48182d
X-MS-TrafficTypeDiagnostic: AM6PR04MB6487:
X-Microsoft-Antispam-PRVS: <AM6PR04MB64874B795E9A55AD7C478619CFCC9@AM6PR04MB6487.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtGb8ynvwxPkYx4SkqLfbm7IxiYIdtTL74vR+OfJR3VuVh3MxzGoRMLmm2bqnAzWKKVAwNab82ognRNjxdAcpFxlG6T8X5fyZEvWh+eNBsoWThZcfB3FgHZn8m5W1mHgpMVWnabaceZWwhILKFcUcZDH9Oy3TIzw5K/Sv9WZhPvKdN5eowJMKFo1jdeOinXfj+xDWC82M6EJZu7tKDg3t35xEDnsObBwhNXHgeerqVg2CXnBBV+GAsviAXPU4Ss7Awl/HO7lNJPnstbBZZaXF+vMUSJ1qXhNGrrvg6GKsNGhY0QtmDGBifIlmCeHFmshFbfWirs8IPPvy1t7yw60qESh8OKSs96nUgZCNKWu6+bOfw6Z+/obscLt1WhBXg7m+rKeoE4rrnyQHQwmnQx4USvq7uyRhszyxAFdpjY8FjgZ5HMKjXB5MDgBNzfrEo30YWLAaBHkfAIFpPhDDTrWm/TgB4294VZS/vbZvImXoy3rWRaJ9e1jdf/I8iEFmG6WVDvddj75H7b2+lbkULnQ+fbti6d1sQmCLsGnjIW/29/4jvkjGwOosylYrv8WqnFUT2YCtM/xi0i45NO0+LrxXpQa7diMaYJ2mP3Vij0+UekfjfYjoKYflIOQ8dU1j0GDbX2vannDq+00KFomyeaeorvASJQ9M8ThrO0YEdkLETj8UnKf1fNLvRmGj6AXLK4Gx0dleBihd4wGGdekN92CPOtikSHZuGP9cMnMBtUbGh4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(186003)(55236004)(5660300002)(86362001)(36756003)(31696002)(2616005)(956004)(31686004)(83380400001)(16576012)(4326008)(26005)(2906002)(66556008)(38100700002)(66476007)(66946007)(8676002)(8936002)(6666004)(508600001)(316002)(53546011)(6486002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2ZoVkpvWUFLWlhjaGwrVDN0RkIyaE1xckk3b3hNS3k0YjBnUjVYcnl4c0Q1?=
	=?utf-8?B?UHVSQStZMzdhSTNqeVA4YUdZNzQwcHVEcGFQNGJhdjhmRmpRbElhR0FZV2xm?=
	=?utf-8?B?YlFLQnpKTU1zU3duQS94ckF3MmZHenJpUUFtQklIYWZBUFA2VFFLOGppelhh?=
	=?utf-8?B?ZXcvUGticHFScUN2NjBkNlgvamo2YkxOeTA2Umo1a3hpWmd3SUVITnJYWGl5?=
	=?utf-8?B?SnQvOEVLVTA0am5WTmpTNlJhckVXZEYyQ1NHR25BbXZuN1cxb0VZZGdyMVNU?=
	=?utf-8?B?alNaRjBGSk9HTEtTMGdCRUJia1JzWlBabUhEd1oxMjdpZTVBM1ZXZklsejVp?=
	=?utf-8?B?RjRrNC9Pdk01a1lhcDdSNFRyb0l6Rm8vNUNicnpqMHFROEtSQXpPTCtLN1dO?=
	=?utf-8?B?WkxQdVdVa1NPQW5aR1Qra2xQZll1eFF2ckRsQnF6czZZd0pKdUNLQ09SRlZL?=
	=?utf-8?B?NGhVMG1meGUxTEExV2U4Q3NLRDZoQ3FYZU81YXhGREFNSEhGdXJTU21NVkpM?=
	=?utf-8?B?ZC9ZOTZhZk14am5TTTBQanF2ckFPT3d6UUpxTDN2NXdRazUrNXZIODRsbjdD?=
	=?utf-8?B?a2xNK2JGR0cwTkZBNzgwaE51TzQ4ODh1N1JtcEc2Vk1aZXQxNFdSbTZ5U0Vh?=
	=?utf-8?B?d0IvcE1PM25wODJ0ODdvcS94VGswQWYrclltMFVaY284Q0Y4L0k4UUdWMmFE?=
	=?utf-8?B?RWY0Nzd1ZTJBemtYR1p1Y2hNT3pDRVJsd1M5QUF5d1JLUGwzVEw5NzkrVlo2?=
	=?utf-8?B?VTlHQ1Nqem8zdFY1TFlmQmp1VnRyMnZFbVdZQkJ0SGZ1ZEQxU3Axd3NVSWFY?=
	=?utf-8?B?UG0zN2FVQVlCZUhhVVhXUk9uUC9uVzhBOFJITWZkaEhwT2J1R0VJVktLNHNi?=
	=?utf-8?B?YnF1UnN5QzdQcDBtUUw1STJKWlVoME1QQXdieVV5dW51eTd6ZTU5SjRQZ2JD?=
	=?utf-8?B?SHpsTTdhcVg1WkxUaDN3MnhNUUNCZ3lVeWN1NEg5Z1daS1QxTjJzcDdqd1pM?=
	=?utf-8?B?ak1BUEI3K1JyYlR6MEJZeEtOVjN0V2o3aTJ2R3k4VWowVHR2VWdudU55Q1g3?=
	=?utf-8?B?RTdlTkxmUkVzNG5mRGxKaGVGQ2lDcDA3MkR5cmRMcmw5SHVWSUtQN0FZNGFE?=
	=?utf-8?B?ZUx5ZXBlWVJtUjBNQmtIN3orVkQ2YVd5WUhrZGhsZDB3ZEpPTUk5dkFpMHNI?=
	=?utf-8?B?Z1Z0Wk9NcmFOMjN3ZGFrVFpOa1c3cFRDbllWRTE5MmVkNXRlOUluelhVVHBi?=
	=?utf-8?B?NTlXYjc3ejNUSVR4a2tqU3llM29rMHJ5UTlLM3dZWGQ0Vk5DaUsrUldaZDYy?=
	=?utf-8?B?OXQyZjdoMktNVjdhMmxDT0VGcHNaWnVGSm9acmxxOGFWZDRKN1BSa1d4RzZ6?=
	=?utf-8?B?S1k4ZEc1RTFKNmIxRlNIdXRFUmxTTXl3S0ltWW5BNHlJVDNzVHhKcGUxbXNt?=
	=?utf-8?B?RzBFdmw1TlBOQXJnRktlYUk4S3N1bkVJR1pyVTB3R2QxY3FuZjhpWFZRYklj?=
	=?utf-8?B?NEd6emVvcDhFZjhPK2xuODVPekVMdEhyaTg5UldOWmEyR0JpQkUrS2tEUWh5?=
	=?utf-8?B?VXdVdVI5WktweW9EaGJVdWM5OXNEZWhEa0tDU3NGaDhkTEpJamRNWkdjK0dj?=
	=?utf-8?B?cFFqRVEvOWFnTTZrYlpENURXQjN1TlZSd3R5b1I0b203K0FPM01VSGlPZWo1?=
	=?utf-8?B?TTNoNjJBZWFNcUg1Q3ZJMy80MGo5MEFRdVppeTFiLytJUU4vTS9VdXlmVEZn?=
	=?utf-8?Q?a230SEcaY2s8WnueDt1hTnDUmwjR5LcQ/N+Dctc?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557ef6ec-f00f-429e-4eec-08d96c48182d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 06:25:15.0422 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5L7+SKtjxoHgWGxNfFrEvsdccha5u4yCwlIYzkcFACFT6WTx3dnhnQDMhoGsTzi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6487
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10092
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=272
	phishscore=0
	mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0
	mlxscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
	priorityscore=161 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108310036
X-Spam: Clean
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: avoid getting dlm lock of the
 target directory multiple times during reflink process
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10092 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310036
X-Proofpoint-GUID: hy0z2DYH5t3ECkZ1emAcYiHaUwwck5lh
X-Proofpoint-ORIG-GUID: hy0z2DYH5t3ECkZ1emAcYiHaUwwck5lh

Hello Joseph and Wengang,

When you have time, please help review this patch.
About the deadlock problem which was caused by ocfs2_downconvert_lock 
failure, we have the fix patch, it is very key.
But I feel this patch is still useful as a optimization patch, the user
case is to reflink the files to the same directory concurrently, our 
users usually backup the files(via reflink) from the cluster nodes 
concurrently(via crontab) every day/hour.
The current design, during the reflink process, the node will 
acquire/release dlm lock of the target directory multiple times,
this is very inefficient in concurrently reflink.


Thanks
Gang

On 2021/8/26 15:59, Gang He wrote:
> During the reflink process, we should acquire the target directory
> inode dlm lock at the beginning, and hold this dlm lock until end
> of the function.
> With this patch, we avoid dlm lock ping-pong effect when clone
> files to the same directory simultaneously from multiple nodes.
> There is a typical user scenario, users regularly back up files
> to a specified directory through the reflink feature from the
> multiple nodes.
> 
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>   fs/ocfs2/namei.c        | 32 +++++++++++++-------------------
>   fs/ocfs2/namei.h        |  2 ++
>   fs/ocfs2/refcounttree.c | 15 +++++++++++----
>   fs/ocfs2/xattr.c        | 12 +-----------
>   fs/ocfs2/xattr.h        |  1 +
>   5 files changed, 28 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 2c46ff6ba4ea..f8bbb22cc60b 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2489,6 +2489,7 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
>   }
>   
>   int ocfs2_create_inode_in_orphan(struct inode *dir,
> +				 struct buffer_head **dir_bh,
>   				 int mode,
>   				 struct inode **new_inode)
>   {
> @@ -2597,13 +2598,16 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>   
>   	brelse(new_di_bh);
>   
> -	if (!status)
> -		*new_inode = inode;
> -
>   	ocfs2_free_dir_lookup_result(&orphan_insert);
>   
> -	ocfs2_inode_unlock(dir, 1);
> -	brelse(parent_di_bh);
> +	if (!status) {
> +		*new_inode = inode;
> +		*dir_bh = parent_di_bh;
> +	} else {
> +		ocfs2_inode_unlock(dir, 1);
> +		brelse(parent_di_bh);
> +	}
> +
>   	return status;
>   }
>   
> @@ -2760,11 +2764,11 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>   }
>   
>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
> +				   struct buffer_head *dir_bh,
>   				   struct inode *inode,
>   				   struct dentry *dentry)
>   {
>   	int status = 0;
> -	struct buffer_head *parent_di_bh = NULL;
>   	handle_t *handle = NULL;
>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>   	struct ocfs2_dinode *dir_di, *di;
> @@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>   				(unsigned long long)OCFS2_I(dir)->ip_blkno,
>   				(unsigned long long)OCFS2_I(inode)->ip_blkno);
>   
> -	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
> -	if (status < 0) {
> -		if (status != -ENOENT)
> -			mlog_errno(status);
> -		return status;
> -	}
> -
> -	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
> +	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
>   	if (!dir_di->i_links_count) {
>   		/* can't make a file in a deleted directory. */
>   		status = -ENOENT;
> @@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>   		goto leave;
>   
>   	/* get a spot inside the dir. */
> -	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
> +	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
>   					      dentry->d_name.name,
>   					      dentry->d_name.len, &lookup);
>   	if (status < 0) {
> @@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>   	ocfs2_journal_dirty(handle, di_bh);
>   
>   	status = ocfs2_add_entry(handle, dentry, inode,
> -				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
> +				 OCFS2_I(inode)->ip_blkno, dir_bh,
>   				 &lookup);
>   	if (status < 0) {
>   		mlog_errno(status);
> @@ -2886,10 +2883,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>   	iput(orphan_dir_inode);
>   leave:
>   
> -	ocfs2_inode_unlock(dir, 1);
> -
>   	brelse(di_bh);
> -	brelse(parent_di_bh);
>   	brelse(orphan_dir_bh);
>   
>   	ocfs2_free_dir_lookup_result(&lookup);
> diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
> index 9cc891eb874e..03a2c526e2c1 100644
> --- a/fs/ocfs2/namei.h
> +++ b/fs/ocfs2/namei.h
> @@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>   		     struct buffer_head *orphan_dir_bh,
>   		     bool dio);
>   int ocfs2_create_inode_in_orphan(struct inode *dir,
> +				 struct buffer_head **dir_bh,
>   				 int mode,
>   				 struct inode **new_inode);
>   int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
> @@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>   		struct inode *inode, struct buffer_head *di_bh,
>   		int update_isize, loff_t end);
>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
> +				   struct buffer_head *dir_bh,
>   				   struct inode *new_inode,
>   				   struct dentry *new_dentry);
>   
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 7f6355cbb587..a9a0c7c37e8e 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>   {
>   	int error, had_lock;
>   	struct inode *inode = d_inode(old_dentry);
> -	struct buffer_head *old_bh = NULL;
> +	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
>   	struct inode *new_orphan_inode = NULL;
>   	struct ocfs2_lock_holder oh;
>   
> @@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>   		return -EOPNOTSUPP;
>   
>   
> -	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
> +	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
>   					     &new_orphan_inode);
>   	if (error) {
>   		mlog_errno(error);
> @@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>   
>   	/* If the security isn't preserved, we need to re-initialize them. */
>   	if (!preserve) {
> -		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
> +		error = ocfs2_init_security_and_acl(dir, dir_bh,
> +						    new_orphan_inode,
>   						    &new_dentry->d_name);
>   		if (error)
>   			mlog_errno(error);
>   	}
>   	if (!error) {
> -		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
> +		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
> +						       new_orphan_inode,
>   						       new_dentry);
>   		if (error)
>   			mlog_errno(error);
> @@ -4328,6 +4330,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>   			iput(new_orphan_inode);
>   	}
>   
> +	if (dir_bh) {
> +		ocfs2_inode_unlock(dir, 1);
> +		brelse(dir_bh);
> +	}
> +
>   	return error;
>   }
>   
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dd784eb0cd7c..3f23e3a5018c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7203,16 +7203,13 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>   /*
>    * Initialize security and acl for a already created inode.
>    * Used for reflink a non-preserve-security file.
> - *
> - * It uses common api like ocfs2_xattr_set, so the caller
> - * must not hold any lock expect i_mutex.
>    */
>   int ocfs2_init_security_and_acl(struct inode *dir,
> +				struct buffer_head *dir_bh,
>   				struct inode *inode,
>   				const struct qstr *qstr)
>   {
>   	int ret = 0;
> -	struct buffer_head *dir_bh = NULL;
>   
>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>   	if (ret) {
> @@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   		goto leave;
>   	}
>   
> -	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto leave;
> -	}
>   	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
>   	if (ret)
>   		mlog_errno(ret);
>   
> -	ocfs2_inode_unlock(dir, 0);
> -	brelse(dir_bh);
>   leave:
>   	return ret;
>   }
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 00308b57f64f..b27fd8ba0019 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>   			 struct buffer_head *new_bh,
>   			 bool preserve_security);
>   int ocfs2_init_security_and_acl(struct inode *dir,
> +				struct buffer_head *dir_bh,
>   				struct inode *inode,
>   				const struct qstr *qstr);
>   #endif /* OCFS2_XATTR_H */
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
