Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2843C433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 17:26:22 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62F6861481
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 17:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62F6861481
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SHAlng184769;
	Thu, 28 Jan 2021 17:26:21 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 368brkw8yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 17:26:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SHAG9C010988;
	Thu, 28 Jan 2021 17:24:20 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wr0n6t8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 17:24:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5B1n-0002ol-Ct; Thu, 28 Jan 2021 09:24:19 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1l5B1Z-0002m6-Mw
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 09:24:05 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SHBKAa169689
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 17:24:05 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 368wcr06r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 17:24:05 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SHEQVH001309
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 17:24:04 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2030.oracle.com with ESMTP id 36c0pa90fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 17:24:04 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id B21F464DF9;
	Thu, 28 Jan 2021 17:24:02 +0000 (UTC)
Date: Thu, 28 Jan 2021 09:24:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Message-ID: <20210128172402.GO7698@magnolia>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-19-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210128071133.60335-19-chaitanya.kulkarni@wdc.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:vger.kernel.org
	a:mail.wl.linuxfoundation.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2009150000 definitions=main-2101280083
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Mailman-Approved-At: Thu, 28 Jan 2021 09:24:17 -0800
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
        gustavoars@kernel.org, sergey.senozhatsky.work@gmail.com,
        snitzer@redhat.com, tiwai@suse.de, linux-nvme@lists.infradead.org,
        philipp.reisner@linbit.com, linux-mm@kvack.org, dm-devel@redhat.com,
        target-devel@vger.kernel.org, pavel@ucw.cz, alex.shi@linux.alibaba.com,
        agk@redhat.com, drbd-dev@lists.linbit.com, naohiro.aota@wdc.com,
        linux-nilfs@vger.kernel.org, sagi@grimberg.me,
        linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, osandov@fb.com,
        ebiggers@kernel.org, xen-devel@lists.xenproject.org, ngupta@vflare.org,
        len.brown@intel.com, linux-pm@vger.kernel.org, hare@suse.de,
        ming.lei@redhat.com, linux-block@vger.kernel.org, tj@kernel.org,
        linux-fscrypt@vger.kernel.org, viro@zeniv.linux.org.uk,
        jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
        konishi.ryusuke@gmail.com, bvanassche@acm.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, tytso@mit.edu, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        minchan@kernel.org, linux-fsdevel@vger.kernel.org,
        lars.ellenberg@linbit.com, jth@kernel.org, asml.silence@gmail.com,
        ocfs2-devel@oss.oracle.com, roger.pau@citrix.com
Subject: Re: [Ocfs2-devel] [RFC PATCH 18/34] iomap: use bio_new in
	iomap_dio_bio_actor
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280083
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280083

On Wed, Jan 27, 2021 at 11:11:17PM -0800, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  fs/iomap/direct-io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index f6c557a1bd25..0737192f7e5c 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -267,9 +267,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  			goto out;
>  		}
>  
> -		bio = bio_alloc(GFP_KERNEL, nr_pages);
> -		bio_set_dev(bio, iomap->bdev);
> -		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
> +		bio = bio_new(iomap->bdev, iomap_sector(iomap, pos), 0, 0,
> +			      nr_pages, GFP_KERNEL);

op == 0?  It seems a little odd to me that we'd set the field to zero
and then construct bi_opf later.

It also strikes me as a little strange that bi_opf is combined from the
third and fourth parameters, but maybe some day you'll want to do some
parameter verification on debug kernels or something...?

--D

>  		bio->bi_write_hint = dio->iocb->ki_hint;
>  		bio->bi_ioprio = dio->iocb->ki_ioprio;
>  		bio->bi_private = dio;
> -- 
> 2.22.1
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
