Return-Path: <SRS0=Sx2O=KZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DC1C47092
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 May 2021 11:57:33 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8177860E09
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 May 2021 11:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8177860E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14UBuiUb046181;
	Sun, 30 May 2021 11:57:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 38ud1s9e5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 May 2021 11:57:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14UBngZP116055;
	Sun, 30 May 2021 11:57:30 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38uaqukpmp-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 30 May 2021 11:57:30 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lnK1M-0002Fi-5W; Sun, 30 May 2021 04:54:20 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lnK0m-0002Ee-I0
	for ocfs2-devel@oss.oracle.com; Sun, 30 May 2021 04:53:44 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14UBoSOA015800
	for <ocfs2-devel@oss.oracle.com>; Sun, 30 May 2021 11:53:44 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 38uycpjtg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 30 May 2021 11:53:44 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14UBrh3M002788
	for <ocfs2-devel@oss.oracle.com>; Sun, 30 May 2021 11:53:43 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by userp2030.oracle.com with ESMTP id 38ubnhepy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 30 May 2021 11:53:43 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UaY1w9V_1622375610; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UaY1w9V_1622375610) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 30 May 2021 19:53:31 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
        akpm <akpm@linux-foundation.org>
References: <20210528210648.9124-1-junxiao.bi@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <4d48a59f-e7b6-0e37-3d8c-c24fa7572693@linux.alibaba.com>
Date: Sun, 30 May 2021 19:53:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210528210648.9124-1-junxiao.bi@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9999
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 bulkscore=0
	priorityscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
	adultscore=0
	suspectscore=0 mlxscore=0 spamscore=0 clxscore=211 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105300096
X-Spam: Clean
Cc: linux-fsdevel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH V3] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9999 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105300096
X-Proofpoint-ORIG-GUID: erV5dfx4BHQGvpIHmbZUXNxMmOKUc67D
X-Proofpoint-GUID: erV5dfx4BHQGvpIHmbZUXNxMmOKUc67D
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9999 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1034 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105300096



On 5/29/21 5:06 AM, Junxiao Bi wrote:
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
> v2: https://lore.kernel.org/linux-fsdevel/20210525093034.GB4112@quack2.suse.cz/T/
> 
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> 
> Changes in v3:
> - move i_size_write after zeroout done, this can remove duplicated code and kill possible race.
> 
> Changes in v2:
> - suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.
> 
>  fs/ocfs2/file.c | 55 ++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index f17c3d33fb18..775657943057 100644
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
> @@ -1957,6 +1997,14 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	default:
>  		ret = -EINVAL;
>  	}
> +
> +	/* zeroout eof blocks in the cluster. */
> +	if (!ret && change_size && orig_isize < size) {
> +		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
> +					size - orig_isize);
> +		if (!ret)
> +			i_size_write(inode, size);
> +	}
>  	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>  	if (ret) {
>  		mlog_errno(ret);
> @@ -1973,9 +2021,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		goto out_inode_unlock;
>  	}
>  
> -	if (change_size && i_size_read(inode) < size)
> -		i_size_write(inode, size);
> -
>  	inode->i_ctime = inode->i_mtime = current_time(inode);
>  	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
>  	if (ret < 0)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
