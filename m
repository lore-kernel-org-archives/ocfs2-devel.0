Return-Path: <SRS0=/tXN=OR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480D7C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:58:15 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCB1B6113A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCB1B6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6PBvF020451;
	Mon, 27 Sep 2021 07:58:14 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3banbbau6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Sep 2021 07:58:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18R7uHpt128547;
	Mon, 27 Sep 2021 07:58:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3badhqkxy4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 27 Sep 2021 07:58:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mUlWY-00066M-JF; Mon, 27 Sep 2021 00:58:06 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mUlWU-00065v-JU
	for ocfs2-devel@oss.oracle.com; Mon, 27 Sep 2021 00:58:02 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18R7treo103433
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:58:02 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3b9rvtab45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:58:02 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18R2Dlt8001560
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:57:59 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3baqsm1h5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:57:59 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12-lPD7zca0NaC4UqHZ4ZSrBg-1; Mon, 27 Sep 2021 09:57:55 +0200
X-MC-Unique: lPD7zca0NaC4UqHZ4ZSrBg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=bQoJ3CDiD3vFIKugrSXS+vBA3B5sT3Lr+cvK07wcsqzCcgZDKjkcPrrEbLWjhh8L97INpmPEBpvu/8LtmwX+dEp7lxvxfjTtx+eN7zzCq1EO0xAhma2n3Zjf1ly3DwWCjnXqWHhxaDhK1SgJrwpUV9B1dPVXZoaRByUUUKKTpZUgbEgQVhlqkrrBnMk9AIOp+6qq5L4lR6xuQ+gQ1/Iq5cZwvXb5MVeV1GKLawgTsJORpNyo0+BTiQIU9FuFxQEFMugi6jFQ98u8BsyRnVWSM+Rj0n/DwBcqOJu9ye0TRh1Gk/ZEAw0HadyC9Im5bvlZXRf/LG8E6llzjmM9s+xUzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
	bh=yPJId8NeoQ/jRwz1t/J8feAKVpjQAGo32IP8FJlND/s=;
	b=KuKphBT2k1p7TagJTWCcAvQgIc9WeF7Xiw8H32Q1ebuYX8ntxNOZ68k0SvZRp0q0J40S8hMz/Ge7Ndofobik9b9Q9YVifha1DgPNvTkMIZqixkS9fXZ/2mxrVu6h5FWSKAd9W6V5wPJbOsDqWmKlD8Ly3YDmWTALcaahN8V16waOhbNig2ZotMIcXAMVl+ETfVJ/WpUaUK3fQw7oAZS/BXJ7cn8tNWpwYMg//CilDMbdLlrmV6YXBPbVR0YgfFY453PqfbzvF9IpSD1aa4snx8BJu5FL2Vl4Eu9dOPjlC5dFLbpDTYk+0DQw/vbhWl/qJJScGimDa+w4NtTjaKSCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
	header.d=none; oracle.com; dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AS8PR04MB7526.eurprd04.prod.outlook.com (2603:10a6:20b:299::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18;
	Mon, 27 Sep 2021 07:57:54 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4544.015;
	Mon, 27 Sep 2021 07:57:54 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "Markov, Andrey" <Markov.Andrey@Dell.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
References: <AM6PR04MB6488C35E2103DFC0BF4AF896CFA79@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<816ee511-5764-aeed-4554-83b91de8e06e@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <1190fbe9-f53d-d35c-6631-ba71f4f92bd1@suse.com>
Date: Mon, 27 Sep 2021 15:57:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
In-Reply-To: <816ee511-5764-aeed-4554-83b91de8e06e@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HKAPR03CA0027.apcprd03.prod.outlook.com
	(2603:1096:203:c9::14) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
Received: from [10.67.20.87] (60.251.47.115) by
	HKAPR03CA0027.apcprd03.prod.outlook.com (2603:1096:203:c9::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8
	via Frontend Transport; Mon, 27 Sep 2021 07:57:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0659e668-5486-4147-40c5-08d9818c8304
X-MS-TrafficTypeDiagnostic: AS8PR04MB7526:
X-Microsoft-Antispam-PRVS: <AS8PR04MB752617E62DE2BEEA9440CB30CFA79@AS8PR04MB7526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OK0pZh5AY64UqD9SvuaKkTS3I8y8REiDO/FWlLfn13Epe/Z3A2AnSCNTXqQm9P8JIsKAPhEHzzPxq1+dlnlY1NDnYX5P7Qq5J6Fzs02I6keYyFmkQuGsfDkYX6QFaN8WLfMLv2WlxF/l5tDk+wNTr5wLPLEczNpibqv/Vh/ydUqu9ZvuiLtD2VCJ5l9VtrCHF7r1un/5q62GRXKEDdda/ZL3peVxatWKPg2VzKjSAdZy1xNwEFcAxw3Mrkp8w9M5RrkH0Ljt90K6xxqpJ7Cf6lDubQwy7o7ojVMkGSqQ+bAiHrIBkCdIjaEmAz0+L0gh2o3i94YXAmIYiGk+ULudAMs5VVE1y4U2kVNrD5kFLZRymRwxWpmAyRkwBNp/Dz1vpPJFeha0paH7Btuf76zdloI1jI9jDQM7qjFjZ2Sp+2HXVrFXPBLEtgU6Ub95JcvYhFUiYEOui8W2u3N3K++dAIELZowBnh2dTLE8O8ITHWH3pDAXL3ToKuDhzQOIhx/JO157Sj/NBhYGV6CaSTMbF6HxwXkagawBYyeOd74feDl+MtS9Uczy4nf02Sc8awDXaiI6tDatvWN6cUndVvhr7zRQwLZPHAx1cJw9GjILwrIsSnC5YM1rpZONDg75AgZexw8VQKdQbMps1s5Vj8dWj9u+yU+0LTDpgD+eoDzy6e3B4qNd6W8dS/DXl1LZpQ+JUwsctFNahjQZZctXAFWmdpdhWqH0cR4iwQD3FTuEVVmBQ7vhDA2nUFRSeuIjfGkvrFDbDe5XhfMikKRsBpsIaOvOaQGgkRHGU0oQ/5zK3DpwDjOuBprmQ5aiEpnkvve4prwUAQzpYLvUsUDuPBBmywJNC173TA1dJlKlDhmO2/633v2v4T2koKieC2vG9vJkuPp9a2TXHul8Bc4ouJFHYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(66556008)(316002)(31686004)(2616005)(956004)(5660300002)(6486002)(38100700002)(83380400001)(110136005)(16576012)(36756003)(66946007)(66476007)(55236004)(8676002)(6666004)(966005)(31696002)(26005)(186003)(8936002)(86362001)(53546011)(508600001)(2906002)(10126625002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1FIQU5VckUrb09tQzZjRTdrTi9STVFRRThyT3BpWmM3RFlqRXMzcEJsRjQz?=
	=?utf-8?B?N05hZFdvYWlJTXVVMUhQMUJmSklqaG1iTXh0Y0M3dnorMnBuaElPZTZEU1F2?=
	=?utf-8?B?SVhDQWFkbmVUbnlrVERHQkNpT1R4VkFoZlhtcjhNb2tVQmRGR1laOTdIQlhY?=
	=?utf-8?B?NEpJSm5YZ2VNb0p5Z1BxU3g4T2pkU1M5RC9YdGtiRE1QdkRHWHh0ZitnaFhQ?=
	=?utf-8?B?VHppaEJMcDBJbjc2cVJVVVJGZ3Z1SEJlekhOaUdEbG1Ta3UyRkxmTy9RSDlP?=
	=?utf-8?B?a0ZRRkVTY0s1ZFVybmRsUS8raGZEa0Vtb0JZK1Q5cTY0VEtwRVpjRzBLUnhB?=
	=?utf-8?B?OG9jNm4wcU05R0h1MklacDhtQU9xMmI3aWxwU0g0ZXllZ29wQ3NqSkUzeFlp?=
	=?utf-8?B?SC9WQW1VeHhONlRISUEvV3p6TWdMQ3Z6emhoWEdkZk5OMW5MUm84bnFZQWdU?=
	=?utf-8?B?aVlFUmlNdDVLSnBzYW1tYTRuc29ZbkJmZDVxMndmUHBnNnNjMjc0d05FSEhW?=
	=?utf-8?B?cmdIYUFyenhtQ3duTEhIRVJNdnowSWttQ0JRSzQvTVZlNEhObVlaalVtcURJ?=
	=?utf-8?B?d0RhTERlcjlLaE94S29FMVFkYzA5NDFvUzVxWHFWUjkvbjROQjJzM3RrSk93?=
	=?utf-8?B?LzBZRzczWGQrdlVKTm4wQ0svbExOR1VCWkdaaks0R2NZRE1sNmorUGRoNzZF?=
	=?utf-8?B?Z3hralVzNzRaM0RHOXZteHZqdHUycDMvVXhUMlhadVdHbm9GOXdad0R0UURW?=
	=?utf-8?B?M2JXNHFxTXNIbDBNY3d0bkJuejN4U1l2c3NhRHlQMkRvdXcxYUlCWWxTNy9i?=
	=?utf-8?B?Y3BsblRDWVgzMTNQUFBQbFhxemRzUFYwQmtsNUVRNW1Pb1FxaUROR0tYM25Y?=
	=?utf-8?B?NWVMVnVMRTZiY3RrSE02NjVOTVFpQWxaeHpzRmxpazR0NHloM2lHMUkrU3VE?=
	=?utf-8?B?UU9kTDFDbnhQbHNBSFZRV1VTTk4vY0dxUVlublBhU2dHZXhpL2w0K3JmT2g2?=
	=?utf-8?B?dngvOWNsWVVyMk15MFJLQkh5Y2RnK1Bpc1JMWWg3dG5KdGd2S2ZQWG5PNGFO?=
	=?utf-8?B?WnR6M0gwQTlQc0FBL2gzbVpiS2FITThXakEwaHVFWjB3aG4zdWN3SDRWWkZ3?=
	=?utf-8?B?TXZYWTBnT2UvdWtQNGlIZ1grbm03L2QzaXl3cHNSUndmNFJJY29lcW9HQ1kr?=
	=?utf-8?B?ZklkSEZXQkdQZzl4eWQvcGU2bWhXQVZwWjY1bXU1MHNrdFdtYW1hcTArUVpY?=
	=?utf-8?B?VUZMVW9hVVhxWnZlYjNOM3dlN1R1K1RVbHlYMFJUYzhZWTRTZTFYNVZ6c081?=
	=?utf-8?B?bmt3T3V1Q3htb3ZqL1lPZUxTR0NrNjJBOXl1eThOUjFqYUV6N3JaVjR0REtK?=
	=?utf-8?B?VlNkeC96TWxpL1BjNy9oOVF5c090dndmSHFsekh2UWhMWnN2alliMDY0YkhX?=
	=?utf-8?B?blFYWUNVUDliMGJaUlBEaG5NQ01JZHd0S3lhdWlhYkVmYkVzN1VscURjRTdN?=
	=?utf-8?B?NkRtYzlGcjM5SGNMS0ZHLzd2dWd2SDZLdmExdG1hMTlYdEVqYnh4NSt1Ullv?=
	=?utf-8?B?cXZ5Rk5ESEx0TVBOWTFjcGdGOHRoamJCK3RJTHRCcGk4NlBKSGdQOUE2ckhQ?=
	=?utf-8?B?c1dMdVQ0MFRBeTFXcEl2TFVJL29RSlB4SXc2Q2w5MzJ0MUVTU1ZXSmsvN2s5?=
	=?utf-8?B?cXNjSWdVTXZWblVpZDVGUnZjdVduWHhlVXJDQmRCTFluUytlOHdUNDJwQ0FM?=
	=?utf-8?Q?egPjHz2U9o4Me6V+nIRbDMEQ0z8D2PaIBTpLzn+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0659e668-5486-4147-40c5-08d9818c8304
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 07:57:54.6032 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hI5EoRPqH+teEV+N2/a6YMjZgLZCljF51iBi7dWzoVYPG/DvfQAqPQjdneyq4VB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7526
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	impostorscore=0
	malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
	phishscore=0 priorityscore=123 clxscore=176 bulkscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109270054
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270054
X-Proofpoint-GUID: E14VbWN6pNx1rZ6y6OXTAhfwZaN8w91u
X-Proofpoint-ORIG-GUID: E14VbWN6pNx1rZ6y6OXTAhfwZaN8w91u



On 2021/9/27 15:49, Joseph Qi wrote:
> 
> Last week, Andrey Markov reported a similar issue, but unfortunately not
> on mail list.
> 
> And Junxiao has resolved a similar issue recently. So can you reproduce
> the bug in latest kernel?
Yes, I can reproduce this issue with the latest code.
The cluster size must be greater than 4K(e.g. 8K, 1M), this is the key 
to the problem.

Thanks
Gang

> 
> Thanks,
> Joseph
> 
> On 9/27/21 3:16 PM, Gang He wrote:
>> Hi List,
>>
>> I'd like to report a data loss bug when write N random bytes, since I saw there were some related commits in the past weeks.
>> I can reproduce this bug stably with the latest ocfs2 kernel module code as below,
>> 1) Create a three node(e.g. ghe-tw-nd1, ghe-tw-nd2, ghe-tw-nd3) ocfs2 cluster, attach a shared disk(e.g. /dev/vdb).
>> 2) Format the disk with the command "mkfs.ocfs2 -N 4 -b 4096 -C 1048576 /dev/vdb", and mount the disk to /mnt/shared on each node. The cluster size must be greater than 4K, this is the key to the problem.
>> 3) Copy the file write/test scripts to /mnt/shared directory, then run test script on node1 to reproduce this bug.
>>      file write script ocfs2_fallocate_bug_plain_write.py: https://pastebin.com/QsXcD8rq
>>      file test script ocfs2_loop.sh: https://pastebin.com/eTUe2hkW
>> 4) Then, you can meet this bug, the file md5sum is different between from node1 and from node2.
>>      In fact, the last part of the file is zeroed out from node2.
>>      e.g.
>>      file dump from node1: https://pastebin.com/HB92TVS0
>>      file dump from node2: https://pastebin.com/jBG7HdSz
>>
>> More information,
>> this bug does not exist on some old kernels( e.g. linux-4.12.14-120), but it will happen on some new kernels, I feel this bug is probably NOT caused by ocfs2 commits, since I used old ocfs2 kernel module code on the new kernels, the problem also happened.
>> Anyway, if you have any comments, please reply this mail.
>>   
>> Thanks
>> Gang
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
