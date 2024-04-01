Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E347FEC2
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Apr 2024 01:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711936333; cv=none; b=qEaHfnrj0EqRAohk3gNMeb+wIQuGJ3P44EbzS2DT5CDZjFfo8+FN6m6PIpNPjpXL/h9j6akARyXDOg/oegssjizzUpAztIk5hS7an/AcDOhsr+f6mZQHEiDukIOPR7jURB25qTF8qdaZEJlaSjhF1LYscfTKzSgsXHDoC5sIAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711936333; c=relaxed/simple;
	bh=8gOD2pbQxoSkwPp5RVB3znPclVM6FIzGcIcy0LUqSLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tj+68IdadLyUQZ8rPIeYyjZh/GgEujuKCYdKXvYgcFFrsDrgpJGhM6RycbpcEZvZ7CfBwoqy8S0/CI6pC0W2R2qA2sf17UiS2S65I137mtXoVMYOVc+09bzKzGyf4j0/I53acmeajpWusQ7xXA363NJW1NRV4xDxlsH8/ikYb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Jw5FPHew; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Jw5FPHew"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711936322; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VBS0bLjiM+ZK8ZHx+FGmoeYfaLxo/kj56mV2fpn2iOg=;
	b=Jw5FPHewAqUvJNl+03ERwqbiPx0SCPfgpO+plqCP+J7+Fq4MrNs/0cITQmQysMUP7DJ5vm3UhutCkkzKbtDL11sqGhhldJpGp7jWH/KvQjulkClyiDwaZeMbBomcQ5sHhFUjXhVQToYny0exFkV9w/23jQb0yt1yZxWXh4M2zSc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3cmrF5_1711936321;
Received: from 30.221.128.209(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3cmrF5_1711936321)
          by smtp.aliyun-inc.com;
          Mon, 01 Apr 2024 09:52:02 +0800
Message-ID: <a76e763c-72a0-4a0e-b23a-b3b8dee5f622@linux.alibaba.com>
Date: Mon, 1 Apr 2024 09:52:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] ocfs2: fix races between hole punching and AIO+DIO
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
References: <20240331111744.7224-1-l@damenly.org>
 <20240331111744.7224-3-l@damenly.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240331111744.7224-3-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/24 7:17 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> After commit "ocfs2: return real error code in ocfs2_dio_wr_get_block",
> fstests/generic/300 become from always failed to sometimes failed:
> 
> ========================================================================
> [  473.293420 ] run fstests generic/300
> 
> [  475.296983 ] JBD2: Ignoring recovery information on journal
> [  475.302473 ] ocfs2: Mounting device (253,1) on (node local, slot 0)
> with ordered data mode.
> [  494.290998 ] OCFS2: ERROR (device dm-1): ocfs2_change_extent_flag:
> Owner 5668 has an extent at cpos 78723 which can no longer be found
> [  494.291609 ] On-disk corruption discovered. Please run fsck.ocfs2
> once the filesystem is unmounted.
> [  494.292018 ] OCFS2: File system is now read-only.
> [  494.292224 ] (kworker/19:11,2628,19):ocfs2_mark_extent_written:5272
> ERROR: status = -30
> [  494.292602 ] (kworker/19:11,2628,19):ocfs2_dio_end_io_write:2374
> ERROR: status = -3
> fio: io_u error on file /mnt/scratch/racer: Read-only file system: write
> offset=460849152, buflen=131072
> =========================================================================
> 
> In __blockdev_direct_IO, ocfs2_dio_wr_get_block is called to add
> unwritten extents to a list. extents are also inserted into extent tree
> in ocfs2_write_begin_nolock. Then another thread call fallocate to
> puch a hole at one of the unwritten extent. The extent at cpos was
> removed by ocfs2_remove_extent(). At end io worker thread,
> ocfs2_search_extent_list found there is no such extent at the cpos.
> 
>     T1                        T2                T3
>                               inode lock
>                                 ...
>                                 insert extents
>                                 ...
>                               inode unlock
> ocfs2_fallocate
>  __ocfs2_change_file_space
>   inode lock
>   lock ip_alloc_sem
>   ocfs2_remove_inode_range inode
>    ocfs2_remove_btree_range
>     ocfs2_remove_extent
>     ^---remove the extent at cpos 78723
>   ...
>   unlock ip_alloc_sem
>   inode unlock
>                                        ocfs2_dio_end_io
>                                         ocfs2_dio_end_io_write
>                                          lock ip_alloc_sem
>                                          ocfs2_mark_extent_written
>                                           ocfs2_change_extent_flag
>                                            ocfs2_search_extent_list
>                                            ^---failed to find extent
>                                           ...
>                                           unlock ip_alloc_sem
> 
> In most filesystems, fallocate is not compatible with racing with
> AIO+DIO, so fix it by adding to wait for all dio before
> fallocate/punch_hole like ext4.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/file.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 0da8e7bd3261..ccc57038a977 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1936,6 +1936,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  
>  	inode_lock(inode);
>  
> +	/* Wait all existing dio workers, newcomers will block on i_rwsem */
> +	inode_dio_wait(inode);
>  	/*
>  	 * This prevents concurrent writes on other nodes
>  	 */
