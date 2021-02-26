Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3C3C43603
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:39 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD306601FB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD306601FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGsRsu133080;
	Fri, 26 Feb 2021 16:55:38 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36xqkfa5tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGsfMI118492;
	Fri, 26 Feb 2021 16:55:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc2uqsk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOt-0000dx-Pi; Fri, 26 Feb 2021 08:55:35 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lFUWq-0001jR-CQ
	for ocfs2-devel@oss.oracle.com; Thu, 25 Feb 2021 20:15:00 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q4AHZk155903
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 04:15:00 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 36uc6vdf14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 04:15:00 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q4ExxE011298
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 04:14:59 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2040.oracle.com with ESMTP id 36wskfjau7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 04:14:59 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9227864EDC;
	Fri, 26 Feb 2021 04:14:45 +0000 (UTC)
Date: Thu, 25 Feb 2021 20:14:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210226041446.GV7272@magnolia>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-8-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210226002030.653855-8-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:sjc.edge.kernel.org a:ewr.edge.kernel.org
	a:ams.edge.kernel.org a:nrt.edge.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2009150000 definitions=main-2102260028
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 07/10] iomap: Introduce iomap_apply2()
 for operations on two files
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260125
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1034
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260125

On Fri, Feb 26, 2021 at 08:20:27AM +0800, Shiyang Ruan wrote:
> Some operations, such as comparing a range of data in two files under
> fsdax mode, requires nested iomap_open()/iomap_end() on two file.  Thus,
> we introduce iomap_apply2() to accept arguments from two files and
> iomap_actor2_t for actions on two files.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/iomap/apply.c      | 51 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  7 +++++-
>  2 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> index 26ab6563181f..fd2f8bde5791 100644
> --- a/fs/iomap/apply.c
> +++ b/fs/iomap/apply.c
> @@ -97,3 +97,54 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  
>  	return written ? written : ret;
>  }
> +
> +loff_t
> +iomap_apply2(struct inode *ino1, loff_t pos1, struct inode *ino2, loff_t pos2,
> +		loff_t length, unsigned int flags, const struct iomap_ops *ops,
> +		void *data, iomap_actor2_t actor)
> +{
> +	struct iomap smap = { .type = IOMAP_HOLE };
> +	struct iomap dmap = { .type = IOMAP_HOLE };
> +	loff_t written = 0, ret;
> +
> +	ret = ops->iomap_begin(ino1, pos1, length, 0, &smap, NULL);
> +	if (ret)
> +		goto out_src;
> +	if (WARN_ON(smap.offset > pos1)) {
> +		written = -EIO;
> +		goto out_src;
> +	}
> +	if (WARN_ON(smap.length == 0)) {
> +		written = -EIO;
> +		goto out_src;
> +	}
> +
> +	ret = ops->iomap_begin(ino2, pos2, length, 0, &dmap, NULL);
> +	if (ret)
> +		goto out_dest;
> +	if (WARN_ON(dmap.offset > pos2)) {
> +		written = -EIO;
> +		goto out_dest;
> +	}
> +	if (WARN_ON(dmap.length == 0)) {
> +		written = -EIO;
> +		goto out_dest;
> +	}
> +
> +	/* make sure extent length of two file is equal */
> +	if (WARN_ON(smap.length != dmap.length)) {

Why not set smap.length and dmap.length to min(smap.length, dmap.length) ?

--D

> +		written = -EIO;
> +		goto out_dest;
> +	}
> +
> +	written = actor(ino1, pos1, ino2, pos2, length, data, &smap, &dmap);
> +
> +out_dest:
> +	if (ops->iomap_end)
> +		ret = ops->iomap_end(ino2, pos2, length, 0, 0, &dmap);
> +out_src:
> +	if (ops->iomap_end)
> +		ret = ops->iomap_end(ino1, pos1, length, 0, 0, &smap);
> +
> +	return ret;
> +}
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 5bd3cac4df9c..913f98897a77 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -148,10 +148,15 @@ struct iomap_ops {
>   */
>  typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
>  		void *data, struct iomap *iomap, struct iomap *srcmap);
> -
> +typedef loff_t (*iomap_actor2_t)(struct inode *ino1, loff_t pos1,
> +		struct inode *ino2, loff_t pos2, loff_t len, void *data,
> +		struct iomap *smap, struct iomap *dmap);
>  loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
>  		unsigned flags, const struct iomap_ops *ops, void *data,
>  		iomap_actor_t actor);
> +loff_t iomap_apply2(struct inode *ino1, loff_t pos1, struct inode *ino2,
> +		loff_t pos2, loff_t length, unsigned int flags,
> +		const struct iomap_ops *ops, void *data, iomap_actor2_t actor);
>  
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
> -- 
> 2.30.1
> 
> 
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
