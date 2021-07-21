Return-Path: <SRS0=C0ey=MN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66F4C07E9B
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jul 2021 03:33:14 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3315761106
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jul 2021 03:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3315761106
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L3WZgh003895;
	Wed, 21 Jul 2021 03:33:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfv5uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jul 2021 03:33:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L3GNTK122067;
	Wed, 21 Jul 2021 03:33:12 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39v8ywesqt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 21 Jul 2021 03:33:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m62ys-0008VO-UK; Tue, 20 Jul 2021 20:33:10 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1m62yq-0008V0-AE
	for ocfs2-devel@oss.oracle.com; Tue, 20 Jul 2021 20:33:08 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16L3GNTI122067
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 03:33:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 39v8ywesjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 03:33:02 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16L3X1mJ007405
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 03:33:01 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by mx0b-00069f01.pphosted.com with ESMTP id 39x1ms5260-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 03:33:01 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=1; SR=0;
	TI=SMTPD_---0UgTv3SK_1626838368; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UgTv3SK_1626838368) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 21 Jul 2021 11:32:49 +0800
To: ocfs2-devel@oss.oracle.com
References: <20210713211306.50593-1-junxiao.bi@oracle.com>
	<20210713211306.50593-2-junxiao.bi@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <93d572c7-53f5-ecc1-d5b6-d52ff13f8add@linux.alibaba.com>
Date: Wed, 21 Jul 2021 11:32:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713211306.50593-2-junxiao.bi@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxscore=0
	lowpriorityscore=0 mlxlogscore=999 priorityscore=156 suspectscore=0
	impostorscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
	clxscore=203 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210018
	domainage_hfrom=8133
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxscore=0 malwarescore=0
	adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210017
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: issue zeroout to EOF blocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210017
X-Proofpoint-GUID: s32RpLt3OGNsW5OvepA7qKwg4MgQuAnV
X-Proofpoint-ORIG-GUID: s32RpLt3OGNsW5OvepA7qKwg4MgQuAnV



On 7/14/21 5:13 AM, Junxiao Bi wrote:
> For punch holes in EOF blocks, fallocate used buffer write to zero
> the EOF blocks in last cluster. But since ->writepage will ignore
> EOF pages, those zeros will not be flushed. This "looks" ok as
> commit 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")
> will zero the EOF blocks when extend the file size, but it isn't.
> The problem happened on those EOF pages, before writeback, those
> pages had DIRTY flag set and all buffer_head in them also had
> DIRTY flag set, when writeback run by write_cache_pages(), DIRTY
> flag on the page was cleared, but DIRTY flag on the buffer_head
> not. When next write happened to those EOF pages, since buffer_head
> already had DIRTY flag set, it would not mark page DIRTY again.
> That made writeback ignore them forever. That will cause data
> corruption. Even directio write can't work because it will fail
> when trying to drop pages caches before direct io, as it found
> the buffer_head for those pages still had DIRTY flag set, then
> it will fall back to buffer io mode.
> To make a summary of the issue, as writeback ingores EOF pages,
> once any EOF page is generated, any write to it will only go
> to the page cache, it will never be flushed to disk even file
> size extends and that page is not EOF page any more.
> The fix is to avoid zero EOF blocks with buffer write.
> 
> The following code snippet from qemu-img could trigger the corruption.
> 
> 656   open("6b3711ae-3306-4bdd-823c-cf1c0060a095.conv.2", O_RDWR|O_DIRECT|O_CLOEXEC) = 11
> ...
> 660   fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2275868672, 327680 <unfinished ...>
> 660   fallocate(11, 0, 2275868672, 327680) = 0
> 658   pwrite64(11, "\0\31\237\v\0\336\330\f\0\373~\r\0\300\270\16\0\335^\17\0\242\230\20\0\277>\21\0\204x\22"..., 311296, 2275868672) = 311296
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/file.c | 99 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 60 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 53bb46ce3cbb..984b950f5abc 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1529,6 +1529,45 @@ static void ocfs2_truncate_cluster_pages(struct inode *inode, u64 byte_start,
>  	}
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
>  static int ocfs2_zero_partial_clusters(struct inode *inode,
>  				       u64 start, u64 len)
>  {
> @@ -1538,6 +1577,7 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	unsigned int csize = osb->s_clustersize;
>  	handle_t *handle;
> +	loff_t isize = i_size_read(inode);
>  
>  	/*
>  	 * The "start" and "end" values are NOT necessarily part of
> @@ -1558,6 +1598,26 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>  	if ((start & (csize - 1)) == 0 && (end & (csize - 1)) == 0)
>  		goto out;
>  
> +	/* No page cache for EOF blocks, issue zero out to disk. */
> +	if (end > isize) {
> +		/*
> +		 * zeroout eof blocks in last cluster starting from
> +		 * "isize" even "start" > "isize" because it is
> +		 * complicated to zeroout just at "start" as "start"
> +		 * may be not aligned with block size, buffer write
> +		 * would be required to do that, but out of eof buffer
> +		 * write is not supported.
> +		 */
> +		ret = ocfs2_zeroout_partial_cluster(inode, isize,
> +					end - isize);
> +		if (ret) {
> +			mlog_errno(ret);
> +			return ret;

Better to use "goto out" to keep code consistent.

> +		}
> +		if (start >= isize)
> +			return ret;

Ditto.

> +		end = isize;
> +	}
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
> @@ -1855,45 +1915,6 @@ int ocfs2_remove_inode_range(struct inode *inode,
>  	return ret;
>  }
>  
> -/*
> - * zero out partial blocks of one cluster.
> - *
> - * start: file offset where zero starts, will be made upper block aligned.
> - * len: it will be trimmed to the end of current cluster if "start + len"
> - *      is bigger than it.
> - */
> -static int ocfs2_zeroout_partial_cluster(struct inode *inode,
> -					u64 start, u64 len)
> -{
> -	int ret;
> -	u64 start_block, end_block, nr_blocks;
> -	u64 p_block, offset;
> -	u32 cluster, p_cluster, nr_clusters;
> -	struct super_block *sb = inode->i_sb;
> -	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
> -
> -	if (start + len < end)
> -		end = start + len;
> -
> -	start_block = ocfs2_blocks_for_bytes(sb, start);
> -	end_block = ocfs2_blocks_for_bytes(sb, end);
> -	nr_blocks = end_block - start_block;
> -	if (!nr_blocks)
> -		return 0;
> -
> -	cluster = ocfs2_bytes_to_clusters(sb, start);
> -	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
> -				&nr_clusters, NULL);
> -	if (ret)
> -		return ret;
> -	if (!p_cluster)
> -		return 0;
> -
> -	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
> -	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
> -	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
> -}
> -
>  /*
>   * Parts of this function taken from xfs_change_file_space()
>   */
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
