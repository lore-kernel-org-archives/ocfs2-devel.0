Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5380EC433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:31:31 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC20C64DF9
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC20C64DF9
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SG9Fue109741;
	Thu, 28 Jan 2021 16:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=M5Cn3xjhylYcdLqnGMbLJ/A3bwpNLIb1EFfml1nq4kA=;
 b=BzjR/pRDpYyiPHCkQZMR/9qJljp9qGU+ID2jLnwZPYVn62B/A7J+uYrfmRjEZlSpvAez
 EyQ6DEWzIK9f06wNxmrNilW8mNf4rIIAy/kZtgCymtdnwuhsc+GrGUo4afQ4bwjxlTzd
 ABNxlZd+qzzy0OEeFGynKUkSXj+SCL9+Gbp5ITPe2iNSRikn642jDP/xJH+5RBzRLE/b
 jOILvuq+0vYTS+eNYGjOqxl0wHpxyTDILvrd+NgAolNy1ksk3vcjwRvMaqTYIFiJ7jGg
 c4rJGZAx3d0aubD7zeWpRB1fombsGq1iQAmoy//BB40f7Wz8PKPRYKiYLzZ4Lee/RHks wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 3689aaw6aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 16:31:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SG9s89152003;
	Thu, 28 Jan 2021 16:31:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjua2gu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 16:31:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5A6X-00081s-7m; Thu, 28 Jan 2021 08:25:09 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dave.kleikamp@oracle.com>) id 1l56dm-00040I-GH
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 04:43:14 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SCbobc047153
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 12:43:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by aserp3030.oracle.com with ESMTP id 368wcqmysx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 12:43:14 +0000
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
Received: from CH2PR10MB4118.namprd10.prod.outlook.com (2603:10b6:610:a4::8)
	by CH2PR10MB3941.namprd10.prod.outlook.com (2603:10b6:610:4::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 12:43:11 +0000
Received: from CH2PR10MB4118.namprd10.prod.outlook.com
	([fe80::2cd3:dc36:f8d4:ea2a]) by
	CH2PR10MB4118.namprd10.prod.outlook.com
	([fe80::2cd3:dc36:f8d4:ea2a%8]) with mapi id 15.20.3784.019;
	Thu, 28 Jan 2021 12:43:11 +0000
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Message-ID: <8d3f7e70-1c7a-567a-0e60-97bac846bf13@oracle.com>
Date: Thu, 28 Jan 2021 06:43:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.1
In-Reply-To: <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
Content-Language: en-US
X-Originating-IP: [68.201.65.98]
X-ClientProxiedBy: SN4PR0501CA0077.namprd05.prod.outlook.com
	(2603:10b6:803:22::15) To CH2PR10MB4118.namprd10.prod.outlook.com
	(2603:10b6:610:a4::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.190] (68.201.65.98) by
	SN4PR0501CA0077.namprd05.prod.outlook.com
	(2603:10b6:803:22::15) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.3825.8 via Frontend Transport;
	Thu, 28 Jan 2021 12:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e01d42d-3bc2-4bab-28da-08d8c38a4555
X-MS-TrafficTypeDiagnostic: CH2PR10MB3941:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDumhfaOVOWdFQgelYKW5jhmYpP2ajh2J9iuZP2JdpM0G6k8mxtSDEvkkXzceD0T1rEhLNNolMZz+2j48gNtkTq41CN2Ql8Snvcb4ElR3pnAL81ZrJPocFzTSetLyw8SjWrXvc7tdhk+vfPCH3WQAthW7PRnVNTYoJJHKY2yXvz+DOabMuf5hYMEx49i1lPy9GcjvWc3La7W4m8ycNvt26zx3ZgKF/EknOAc9eS53eKEJzPfiOqcRA7I5EO3M6gTYi1XpopsNGAKOHApcSzJ5azD4a7LpLI1eHvHo6E/k70F1x0sF+Be4tBJOhwlePkZpU0TjOfBAsxfO7BMyo+0fPYLAlUNfltUdyx4Fr/MkyiFm6lXZ+XMq+zodRkAXWHWtZfYel/DleTWjxnTx877P68ihhMl7JtMUmHhdvjM64pRteh5eFYNoXs0X4DB3zm6D+50rPJSkENXMpShJPgQD6plwYdNhYGnluLA2p+6pEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:CH2PR10MB4118.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2RiNjZJQ1Vqampsb0lnNUo3SDZ1bm0rMTloendxeG0xa0E2MXZnWEVHZGFq?=
	=?utf-8?B?QTRBbGJlYmk0QXgvOVZUMy9PQWZ3eVJ2MFNFS2wxOTRlY0RGZ2JWNDV2dGZR?=
	=?utf-8?B?bnROSWU5UndpdjdHRG1zc3IrTExxUXZ6d1NnbEhJdnVTbGtwWmZYcXJOdk95?=
	=?utf-8?B?cHF4bTFtbWhSOVpRSmJYbS9jSFhObkpmeWRGbmlCTnhGUVhidUJlYkVsVjhz?=
	=?utf-8?B?T1NDcDRLTFhoT3cyTWY0cEtOdlhieWYzQWVQd29qZ2dTMWVZTWdWa2pvQVp1?=
	=?utf-8?B?a2NjYXhBcVlCVHhod0VqSTlOTk5XdVlEaWlqVHVaTDBRaElXa3cyZFE4b0NW?=
	=?utf-8?B?RDR3a3Y3WEhPWnlhUFhUeUFZSmRrUkFyTGFHWW0yN1BhcGNJY2poWW52N2NM?=
	=?utf-8?B?RXI0WnpJN2tkV3h3WUxZUnplN1BVeTJUWnBCeGozME8vNXY5SXhLaWZmR2oy?=
	=?utf-8?B?eWRMUXJaVG5zSFN2TGpNZlNXTjJaRThvL3NSMkNRa05pdzBDSmplNkZ0YURv?=
	=?utf-8?B?VCtIRnpiaUhrMXQvcWJiVXdWSTc4Z1VBUzdBemdoYWFxaXQ0UURnUGZjTzhi?=
	=?utf-8?B?QTRqblkzQ0F4REZ5NmltYVVZU1d2S0pMLzdNNHNQVUZpM29tbFpTczJnaXQx?=
	=?utf-8?B?V1ZlT1g1eGwvc1VPenhVbFZyTm9DUVIvMDhKWFZ3KzdaT3BpV0U2Z3BHWWZ6?=
	=?utf-8?B?U0N1VVo4MjdqOW01OXZkcXY3WlQ1Mm12SkZvUFByc2ZQOFh4WUlGK2diV3Yz?=
	=?utf-8?B?R0hPb3JNcGgvZnJHWVFMQkc0cWxabXF1NS95WitFQTJWVFJtTHZJaHppZmxU?=
	=?utf-8?B?NnlUTmFLSXdzeTF5cnNqak9ZU21lNk5sKy8veXFGK1VpRSttbFV2QjNLZEY4?=
	=?utf-8?B?VEFSQjVHUWJUZlFXZDk1ODV1cUhYU0V5K0hvRXAyYU1qOVBHVkprMW9Eemk5?=
	=?utf-8?B?S0g4MlQ2U1laajY3RVNMcUlOMHI2SkNhbzNWKzk3NDFQRTlmZ3k0Um5QU0Mr?=
	=?utf-8?B?d0E2bGlrWkVzaWpoanp2YU5aejRCUkZiOFNuMDVDb3IrSHFuZm1IWnFSQ0xr?=
	=?utf-8?B?aVRXby9DRWk2SXNYS1g0M3gvVFJCSUtiZG40Q0hLMXBsU0hDWjlkNUtzcTd3?=
	=?utf-8?B?enNzS3hzYW02MnJXSVhPdkh5TmthZ0V2cTVBMFh0NDZKMGNVclZ5WGtiOGdx?=
	=?utf-8?B?ZmNjckNkV3hWbytEUzhIM1Nqd3drUVF0QzNZeW5LdWMvcDR0ZFZVbExjYS82?=
	=?utf-8?B?TFVOMCtOOGdYdEpmcGNYRkc1YncyWHY2aVVXQWYxYVBjWTNxNEViMTA4V3Av?=
	=?utf-8?B?ZytBbTlTZVpTRlU0WXJHd0NFKzhVandwMTh2Q2FDVHpkL0hubDU3UE9ObDA0?=
	=?utf-8?B?OC84ZGd5UG5CV2dFK3didit4ZHdIaXg5b0MxVnB1YUlkalo5ZmdKd1hHbWZz?=
	=?utf-8?Q?8rgawyWU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e01d42d-3bc2-4bab-28da-08d8c38a4555
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4118.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 12:43:11.2780 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFBedDYhghl7XP3cZN2/McX0JwxYw4Cu7FZ5NDxZqDAklfqhu0dMXnszrFIG3H4zPpJnTe1yGk1iM6Mt6c63XUXi/NVyG5gbxkRVEUnPYnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3941
X-MS-Exchange-CrossPremises-AuthSource: CH2PR10MB4118.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 68.201.65.98
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: CH2PR10MB3941.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 suspectscore=0
	phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280064
X-Mailman-Approved-At: Thu, 28 Jan 2021 08:25:07 -0800
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
        tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org, pavel@ucw.cz,
        alex.shi@linux.alibaba.com, agk@redhat.com, naohiro.aota@wdc.com,
        sagi@grimberg.me, osandov@fb.com, ebiggers@kernel.org,
        ngupta@vflare.org, len.brown@intel.com, konrad.wilk@oracle.com,
        hare@suse.de, ming.lei@redhat.com, viro@zeniv.linux.org.uk,
        jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
        konishi.ryusuke@gmail.com, bvanassche@acm.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, jth@kernel.org, tytso@mit.edu,
        rjw@rjwysocki.net, philipp.reisner@linbit.com, minchan@kernel.org,
        tj@kernel.org, lars.ellenberg@linbit.com, roger.pau@citrix.com,
        asml.silence@gmail.com
Subject: Re: [Ocfs2-devel] [RFC PATCH 19/34] fs/jfs/jfs_logmgr.c: use
	bio_new in lbmRead
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280081

You probably don't need 4 patches to fs/jfs/. These can be combined into 
a single patch.

Dave

On 1/28/21 1:11 AM, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   fs/jfs/jfs_logmgr.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 9330eff210e0..4481f3e33a3f 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1979,17 +1979,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
>   
>   	bp->l_flag |= lbmREAD;
>   
> -	bio = bio_alloc(GFP_NOFS, 1);
> -
> -	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
> -	bio_set_dev(bio, log->bdev);
> +	bio = bio_new(log->bdev, bp->l_blkno << (log->l2bsize - 9),
> +			REQ_OP_READ, 0, 1, GFP_NOFS);
>   
>   	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
>   	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
>   
>   	bio->bi_end_io = lbmIODone;
>   	bio->bi_private = bp;
> -	bio->bi_opf = REQ_OP_READ;
>   	/*check if journaling to disk has been disabled*/
>   	if (log->no_integrity) {
>   		bio->bi_iter.bi_size = 0;
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
