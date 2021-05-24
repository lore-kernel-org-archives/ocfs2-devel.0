Return-Path: <SRS0=V2o+=KT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D9BC04FF3
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 08:55:44 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 593F1610A5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 08:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 593F1610A5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14O8jMNU036985;
	Mon, 24 May 2021 08:55:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38ptkp2c1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 May 2021 08:55:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14O8k5sR164696;
	Mon, 24 May 2021 08:55:41 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqr14yr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 24 May 2021 08:55:41 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ll6NA-0007Jw-MB; Mon, 24 May 2021 01:55:40 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1ll6Mk-0007Ho-3v
	for ocfs2-devel@oss.oracle.com; Mon, 24 May 2021 01:55:14 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14O8juQU145489
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 08:55:13 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 38pr0av5bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 08:55:13 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14O8iL9r021527
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 08:55:12 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2040.oracle.com with ESMTP id 38r6wm9r9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 08:55:12 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 85570ABC1;
	Mon, 24 May 2021 08:55:09 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id EA9DD1F2CA2; Mon, 24 May 2021 10:55:08 +0200 (CEST)
Date: Mon, 24 May 2021 10:55:08 +0200
From: Jan Kara <jack@suse.cz>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <20210524085508.GD32705@quack2.suse.cz>
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210521233612.75185-1-junxiao.bi@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-PDR: PASS
X-Source-IP: 195.135.220.15
X-ServerName: mx2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	malwarescore=0
	mlxlogscore=999 impostorscore=0 phishscore=0 lowpriorityscore=0
	mlxscore=0
	priorityscore=48 spamscore=0 bulkscore=0 clxscore=196 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105240068
X-Spam: Clean
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240068
X-Proofpoint-GUID: XU2OZLf46AzFgXh7GF-GETXxFbMrYBE7
X-Proofpoint-ORIG-GUID: XU2OZLf46AzFgXh7GF-GETXxFbMrYBE7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1034 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240068

On Fri 21-05-21 16:36:12, Junxiao Bi wrote:
> When fallocate punches holes out of inode size, if original isize is in
> the middle of last cluster, then the part from isize to the end of the
> cluster will be zeroed with buffer write, at that time isize is not
> yet updated to match the new size, if writeback is kicked in, it will
> invoke ocfs2_writepage()->block_write_full_page() where the pages out
> of inode size will be dropped. That will cause file corruption. Fix
> this by zero out eof blocks when extending the inode size.
> 
> Running the following command with qemu-image 4.2.1 can get a corrupted
> coverted image file easily.
> 
>     qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
>              -O qcow2 -o compat=1.1 $qcow_image.conv
> 
> The usage of fallocate in qemu is like this, it first punches holes out of
> inode size, then extend the inode size.
> 
>     fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
>     fallocate(11, 0, 2276196352, 65536) = 0
> 
> v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html
> 
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
> 
> Changes in v2:
> - suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.
> 
>  fs/ocfs2/file.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index f17c3d33fb18..17469fc7b20e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1855,6 +1855,45 @@ int ocfs2_remove_inode_range(struct inode *inode,
>  	return ret;
>  }
>  
> +/*
> + * zero out partial blocks of one cluster.
> + *
> + * start: file offset where zero starts, will be made upper block aligned.
> + * len: it will be trimmed to the end of current cluster if "start + len"
> + *      is bigger than it.

You write this here but ...

> + */
> +static int ocfs2_zeroout_partial_cluster(struct inode *inode,
> +					u64 start, u64 len)
> +{
> +	int ret;
> +	u64 start_block, end_block, nr_blocks;
> +	u64 p_block, offset;
> +	u32 cluster, p_cluster, nr_clusters;
> +	struct super_block *sb = inode->i_sb;
> +	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
> +
> +	if (start + len < end)
> +		end = start + len;

... here you check actually something else and I don't see where else would
the trimming happen.

								Honza

> +
> +	start_block = ocfs2_blocks_for_bytes(sb, start);
> +	end_block = ocfs2_blocks_for_bytes(sb, end);
> +	nr_blocks = end_block - start_block;
> +	if (!nr_blocks)
> +		return 0;
> +
> +	cluster = ocfs2_bytes_to_clusters(sb, start);
> +	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
> +				&nr_clusters, NULL);
> +	if (ret)
> +		return ret;
> +	if (!p_cluster)
> +		return 0;
> +
> +	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
> +	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
> +	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
> +}
> +
>  /*
>   * Parts of this function taken from xfs_change_file_space()
>   */
> @@ -1865,7 +1904,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  {
>  	int ret;
>  	s64 llen;
> -	loff_t size;
> +	loff_t size, orig_isize;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct buffer_head *di_bh = NULL;
>  	handle_t *handle;
> @@ -1896,6 +1935,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		goto out_inode_unlock;
>  	}
>  
> +	orig_isize = i_size_read(inode);
>  	switch (sr->l_whence) {
>  	case 0: /*SEEK_SET*/
>  		break;
> @@ -1903,7 +1943,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		sr->l_start += f_pos;
>  		break;
>  	case 2: /*SEEK_END*/
> -		sr->l_start += i_size_read(inode);
> +		sr->l_start += orig_isize;
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -1957,6 +1997,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	default:
>  		ret = -EINVAL;
>  	}
> +
> +	/* zeroout eof blocks in the cluster. */
> +	if (!ret && change_size && orig_isize < size)
> +		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
> +					size - orig_isize);
>  	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>  	if (ret) {
>  		mlog_errno(ret);
> -- 
> 2.24.3 (Apple Git-128)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
