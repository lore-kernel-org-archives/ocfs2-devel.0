Return-Path: <SRS0=g/kM=J2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E11C433B4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 18:08:25 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 408AC61453
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 18:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 408AC61453
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TI5mG8180283;
	Thu, 29 Apr 2021 18:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=E0Uxc9F/7+SvjrE7HTfLLGZDRL1szSSbDcRhssDIZtQ=;
 b=nYIRoC0+3QahA0kgn8pfnHk1myGHCjd69coBYwFmGW2Nnl0Bd6cyxaVocNRXEBqHswDg
 Qu26BKLRQ69LXSJPVtir08pzxC4Z1UMcnkMJfWDw5o+XS1SFJFDYil/PfHP0UIXQOPum
 r7+2cChu8e0f6yvmjUPxEHu/wEoPusrZv1VmpPhIKuFq0N9aFn48o/LHH7Nol9b8qmKQ
 adgyPm5xKh3F25EE53eKhFLN/0ZWZoYu+UjELIZzfCLI7BMhzHTCBRGNd+EFOVKD8yuQ
 ZYsVE/ELMqsol5lphaaYEMziirZAUoFcHifsgyqomPRzWp30rzZ+2dMojirORPgIU/XJ nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 385ahbwb0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Apr 2021 18:08:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TI6tPI005227;
	Thu, 29 Apr 2021 18:08:23 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3848f1f049-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 29 Apr 2021 18:08:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lcB5J-0000x1-Rz; Thu, 29 Apr 2021 11:08:21 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lcB5H-0000wn-O5
	for ocfs2-devel@oss.oracle.com; Thu, 29 Apr 2021 11:08:19 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13TI6t40005218
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 18:08:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by userp3030.oracle.com with ESMTP id 3848f1f019-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 18:08:19 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB2422.namprd10.prod.outlook.com (2603:10b6:a02:a9::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25;
	Thu, 29 Apr 2021 18:08:17 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Thu, 29 Apr 2021 18:08:17 +0000
To: Andreas Gruenbacher <agruenba@redhat.com>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
Date: Thu, 29 Apr 2021 11:07:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SA0PR11CA0188.namprd11.prod.outlook.com
	(2603:10b6:806:1bc::13) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-251-241.vpn.oracle.com (73.231.9.254) by
	SA0PR11CA0188.namprd11.prod.outlook.com (2603:10b6:806:1bc::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25
	via Frontend Transport; Thu, 29 Apr 2021 18:08:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d788bb-ebed-4060-127a-08d90b39c365
X-MS-TrafficTypeDiagnostic: BYAPR10MB2422:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BiiQ4FpKyY3QXibeaWzQcPC8cF37bOaqrJmEHkQFyiRHujmbjNMy0Q3pvOJ4qEJnEBzjFLNVn0zfkw/KiMJbhAU+T1z5paKieeVb1ryTlQtVk3ZDUkFEdm0GXXKdy8W0NgFvIDOOWGzdWDKQoA5edMYEjpp+owXvRw0z4AGFAeGTwy4D1+aocsHuE65zCkUXhJeSK4MnstTCNDXM26sJFmUau8a/AEX5+pVIsY1GTHSyOLfmein+xV14PuACkIeAbmRzwIExn7zGkeCOhKHqCuzOViT0DUiToJaBB25bnHAjaopkOOgM6OTFTjtSgd7L0IqGrUAvRMxlbUqB6OThRAsHDTjwt2XA4Xz2rrqEwI7ajXbBQ9tQ2f+HEMGeA+gnqZi5r3HzRxoIcC5zMZ/BWYtCsOhJr7RgvPO9+4eHYdDOw6dE1UN6+1xiK9cGEIH1UiAXtchONJzepEA57072o+GTbaBY7KLmZ4OC+Ws4yxuE+MjVgWZSsQqayHorfsmp7XgvXuy5XLwsqcwuPFHLP12fUDqMCymX0QiZnmIlKXNnFeT+EOnziqJtjR4xsUOqFe5qtRDJ/M8+6rgBx2MPvuahf0an2gX+VWDTpD64c/hgZ9Wif/cNwLUm/LmHeSEg
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGZkRmlvV3kxM1BRaXcweWZjcDNLNjlrNG56bWY5VVNkTFp3LzBsT0JWY2lG?=
	=?utf-8?B?RTlyWEYxcHF5dU1TRUFsU2hMRUdSdndMZE83ZVNvRW9LTUhqMlNkU1NVYWx1?=
	=?utf-8?B?MkdTY1VVRmZxMmhOak9pV0hkak95NlBKUUprT21Ram1vZFdhTHlFZ2UvNUt0?=
	=?utf-8?B?RWVheEZXdnV1NHRGVU80U2tUS1NLQ1RleGREdGEwZWlpKzg3bTF5MXVTS0hD?=
	=?utf-8?B?eVp1K0FuSlJDVmRLb2lQTm1rcUJTVUpSL1cxa3pxWWhmeGRWblRZTDFpVXFo?=
	=?utf-8?B?QmZhZGorRTFzQlcwUEs0cnJ2MUxKOUQ2MUhMVm92akVZREJacitMQXJERXpB?=
	=?utf-8?B?bHVSeCtLT1FwVUJPMVBIVmJtR2M1VWRpazQweWZxdXFvUmx6YTVmSGJ1QXVQ?=
	=?utf-8?B?QWZTN3d3ZFJJNlRtMnlucU9weHdPSUl1TjU5cmFMVnVNeXBzRGhjYWovOUI4?=
	=?utf-8?B?aEViRFVnQ3BwU09USGdEY1IzRGRrajlCZHYva3pzdWtkSUcrOE1lalk4cjB3?=
	=?utf-8?B?dnJoWlpvZ0NUWHl4dG5BK1lLWWRpY29CclpWNm5KdVBjY25UbkNQcU9XTUYx?=
	=?utf-8?B?SEFMWGlST25XYVVUNEJ3N0xZZlQydjZpVDJFRUxUT2d6ZnQxLy9sTFk1aEdi?=
	=?utf-8?B?c2NqL3BzblVTdXRjOEdDczJDTnhoV1cvM216NW41MXNsdWc4SlR3QzJrVmNH?=
	=?utf-8?B?TUl1ZWVybDBFa0ZDVEtqUEFJSDhRTllMczZ4aVFLV1puUTlIVVg4YmFkQkdL?=
	=?utf-8?B?eGFxVHp6dUZxWWtYZ3FXd3ZxNVdFQ0x2UDZQR2diZVZrRHV0WmJYUjFiV054?=
	=?utf-8?B?dVYwOUZ2eFVZVDQvNjZaMDAyK0srcUk3UlZYMjZaUUw0bzNKZ3F0blVGbkRJ?=
	=?utf-8?B?Q1p4WXE0VitsdCsyN0w2WnNSOEJXMHdlcHFXbitaRnQ2QXM0YmRHRmVPNC85?=
	=?utf-8?B?UXlLdklwTFlVY2tTVDI5dUdUWVJ6c2VNUUNRSSs5T3hRam9LUmlzNlJFYnhM?=
	=?utf-8?B?RTVtU3Q0VmlmWXRKdEpHTkJYYmRXM0FLYjFxZ2xXOTFOUlZZOWhJWlpib3p6?=
	=?utf-8?B?Tjc4LzB3d212WHpadmpnYUJUYTVZMmwyMGNyNWhzL0Q3Z3RKcVI4c2taZm9K?=
	=?utf-8?B?cVpLb1B1Z3p1NnFqTHZlbEltKzFxWFZrSE10QjFFck9MdncrZUNtZDRWc09y?=
	=?utf-8?B?YmlLcjN2NVdIYUhJd25PMzZ6WTZKQ0ZiREVqMTZNaU1aVjBUbTRQaWFoMnR0?=
	=?utf-8?B?SUNOdS83bm8vY2RndEp5ck5vS0tBVU91N0FlWUhSRzh5UzBBbng0RWh3aUxC?=
	=?utf-8?B?cWxWT3VCZngzL0lHR2dNYWhZVkxvaGF2MFdsalVTRWRrbmtWVVZlYndLSzd1?=
	=?utf-8?B?NmxZazNlNUxMbktDa3lrREZ0WUZ6MzdpZWV2VDZlUno5Nm9TZjdtZGdiVDM0?=
	=?utf-8?B?TWVIQU83bXZ3U3oxUUlGcjYwTkhNVm45VUpDOHBlLzZMTnlvUVlqOWVOSkph?=
	=?utf-8?B?ODNkek85TndBb2lHQmlTSzVnajNiNFpOcVFYRlNRbnBiYTAyaVFqbGtIRVdo?=
	=?utf-8?B?SGxtaXdrRGtYU1pQaHZmZnJaRXZIQXRhTSs1eUpEeFdyL2dZUC92M0taOCtp?=
	=?utf-8?B?MWFEaDBzNzc4V1g1WVlFRDZjZWVnNmM5MDV1NUQ2djF4Smk2c1dXYnpsWGV6?=
	=?utf-8?B?a0NkWXZpcjVPTzhXeFJRVmZZcEU1cGhjUk5Xbi9pbithaG9VUTNRS1pQL0RT?=
	=?utf-8?Q?tGdaky/YeKdaw4YycS96O7vZy8LjlEOQ6nX9wVv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d788bb-ebed-4060-127a-08d90b39c365
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 18:08:16.9794 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIF4drH56dL/NgTORbzgT9I9qC/itwWjhxSnSW1daxFYBpemT7V+r6XAK18olgGLD5XPm4qs4yLUJAMsCTIl5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2422
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BYAPR10MB2422.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104290116
Cc: cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH 1/3] fs/buffer.c: add new
 api to allow eof writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290116
X-Proofpoint-GUID: Bjo0o8u_LXu0y4akxhJqgnUVmjHv7rU5
X-Proofpoint-ORIG-GUID: Bjo0o8u_LXu0y4akxhJqgnUVmjHv7rU5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290116

On 4/29/21 10:14 AM, Andreas Gruenbacher wrote:

> Junxiao,
>
> On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>> When doing truncate/fallocate for some filesytem like ocfs2, it
>> will zero some pages that are out of inode size and then later
>> update the inode size, so it needs this api to writeback eof
>> pages.
> is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
> cache filling races" patch set [*]? It doesn't look like the kind of
> patch Christoph would be happy with.

Thank you for pointing the patch set. I think that is fixing a different 
issue.

The issue here is when extending file size with fallocate/truncate, if 
the original inode size

is in the middle of the last cluster block(1M), eof part will be zeroed 
with buffer write first,

and then new inode size is updated, so there is a window that dirty 
pages is out of inode size,

if writeback is kicked in, block_write_full_page will drop all those eof 
pages.

I guess gfs2 has the similar issue?

I think it would be good to provide an api that allowed eof write back. 
If this is not good,

do you have any advise how to improve/fix it?

Thanks,

Junxiao.


>
> Thanks,
> Andreas
>
> [*] https://lore.kernel.org/linux-fsdevel/20210423171010.12-1-jack@suse.cz/
>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   fs/buffer.c                 | 14 +++++++++++---
>>   include/linux/buffer_head.h |  3 +++
>>   2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 0cb7ffd4977c..802f0bacdbde 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1709,9 +1709,9 @@ static struct buffer_head *create_page_buffers(struct page *page, struct inode *
>>    * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
>>    * causes the writes to be flagged as synchronous writes.
>>    */
>> -int __block_write_full_page(struct inode *inode, struct page *page,
>> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
>>                          get_block_t *get_block, struct writeback_control *wbc,
>> -                       bh_end_io_t *handler)
>> +                       bh_end_io_t *handler, bool eof_write)
>>   {
>>          int err;
>>          sector_t block;
>> @@ -1746,7 +1746,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>>           * handle any aliases from the underlying blockdev's mapping.
>>           */
>>          do {
>> -               if (block > last_block) {
>> +               if (block > last_block && !eof_write) {
>>                          /*
>>                           * mapped buffers outside i_size will occur, because
>>                           * this page can be outside i_size when there is a
>> @@ -1871,6 +1871,14 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>>          unlock_page(page);
>>          goto done;
>>   }
>> +EXPORT_SYMBOL(__block_write_full_page_eof);
>> +
>> +int __block_write_full_page(struct inode *inode, struct page *page,
>> +                       get_block_t *get_block, struct writeback_control *wbc,
>> +                       bh_end_io_t *handler)
>> +{
>> +       return __block_write_full_page_eof(inode, page, get_block, wbc, handler, false);
>> +}
>>   EXPORT_SYMBOL(__block_write_full_page);
>>
>>   /*
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>> index 6b47f94378c5..5da15a1ba15c 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -221,6 +221,9 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
>>   int __block_write_full_page(struct inode *inode, struct page *page,
>>                          get_block_t *get_block, struct writeback_control *wbc,
>>                          bh_end_io_t *handler);
>> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
>> +                       get_block_t *get_block, struct writeback_control *wbc,
>> +                       bh_end_io_t *handler, bool eof_write);
>>   int block_read_full_page(struct page*, get_block_t*);
>>   int block_is_partially_uptodate(struct page *page, unsigned long from,
>>                                  unsigned long count);
>> --
>> 2.24.3 (Apple Git-128)
>>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
