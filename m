Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE689C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 18:54:39 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 848BE60EC0
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 18:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 848BE60EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183ITirG008914;
	Fri, 3 Sep 2021 18:54:38 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aue9fsy07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 18:54:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183IUal3147735;
	Fri, 3 Sep 2021 18:54:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ate07vxus-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 18:54:36 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mMEKh-00076d-Oa; Fri, 03 Sep 2021 11:54:35 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1mMEKf-00076N-DK
	for ocfs2-devel@oss.oracle.com; Fri, 03 Sep 2021 11:54:33 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	183ITu8N181133
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 18:54:33 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3atdyyup5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 18:54:33 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	183GhkSK019779
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 18:54:32 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au7whkvsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 18:54:31 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EEA61051;
	Fri,  3 Sep 2021 18:54:30 +0000 (UTC)
Date: Fri, 3 Sep 2021 11:54:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <20210903185430.GE9892@magnolia>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-16-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210827164926.1726765-16-agruenba@redhat.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 15/19] iomap: Support partial direct
 I/O on user copy failures
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030110
X-Proofpoint-GUID: p6tygKdxgej71vgNNxJmsqja4_vCquhi
X-Proofpoint-ORIG-GUID: p6tygKdxgej71vgNNxJmsqja4_vCquhi

On Fri, Aug 27, 2021 at 06:49:22PM +0200, Andreas Gruenbacher wrote:
> In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
> IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
> return a partial result.  This allows the caller to deal with the page
> fault and retry the remainder of the request.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Pretty straightforward.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c  | 6 ++++++
>  include/linux/iomap.h | 7 +++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8054f5d6c273..ba88fe51b77a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -561,6 +561,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		ret = iomap_apply(inode, pos, count, iomap_flags, ops, dio,
>  				iomap_dio_actor);
>  		if (ret <= 0) {
> +			if (ret == -EFAULT && dio->size &&
> +			    (dio_flags & IOMAP_DIO_PARTIAL)) {
> +				wait_for_completion = true;
> +				ret = 0;
> +			}
> +
>  			/* magic error code to fall back to buffered I/O */
>  			if (ret == -ENOTBLK) {
>  				wait_for_completion = true;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 479c1da3e221..bcae4814b8e3 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -267,6 +267,13 @@ struct iomap_dio_ops {
>    */
>  #define IOMAP_DIO_OVERWRITE_ONLY	(1 << 1)
>  
> +/*
> + * When a page fault occurs, return a partial synchronous result and allow
> + * the caller to retry the rest of the operation after dealing with the page
> + * fault.
> + */
> +#define IOMAP_DIO_PARTIAL		(1 << 2)
> +
>  ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
>  		unsigned int dio_flags);
> -- 
> 2.26.3
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
