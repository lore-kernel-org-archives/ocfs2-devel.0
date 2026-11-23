Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411604;
	b=Rl6uNd5rwmNH1MR7Svdao5JroaZFVMjFqei75DH+kAfw6yUIyjz/6ygkri0M1aSyWgAm
	 CJo/be9cN186UdhRpginCe7Kw8jGxNMv2+3jH2T/jicZSckfS4AvaCCdPKYa/9DZZt1Oc
	 tXN+BX/Dvokzt4S10zRxYQDg3Vs/8+2NmkHjLbPSxDN2hWw8gh8ZraQX6BW19fuG8cjRX
	 ZEWQhD6zkdrSYh/0kf4mWqt5eS1aqqMTBnUSGJmZkJ/2bUhybsfHszFq2lmqsDYCkvHx7
	 HNhQYZfOAsy78yQmNIDvKoGzDUau+ENQKjYhqeqbFe1Gi8NLhD8YI6uxvsBIIBUf99Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411604;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=uOn8zdpKhoiEr4LfwPlbQlbGhchooXKwDyef2Q+wxQE=;
	b=bnfq1biRhSwZ3IuLesfqA0EPjvW9Azt76v0poE7Zv4XK+UbDClbYpuPGfLQHgFqlpwtd
	 HnAwn5seqht0DRySCyirbfiScKjPWfx/7cqvO4APbi5qbSylXebTP63fQ13aSmk02YgJN
	 fz/JofrxdjSTTMDsWmLZ/NN9pizbFk3YWFroz9t27f7WpulV8Vvo2y5XOWsmhXU9CiVuP
	 ioxJ7EQTbXaO/axPzlAG7L85qEAonVLeLn6RRt/shXOZ0NRIfaire2c61OOPDMQiwdGKC
	 wWGNmnLlgaJFbxT84HjXse7GJn6wGL1J2S8BNNx8TBM36HXJfQqhpSVTpAWMVpsHfBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cnima+C8;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C55606A31A
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C55606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cnima+C8
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b87040a20bso267815a12.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 21:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795411602; x=1796016402; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uOn8zdpKhoiEr4LfwPlbQlbGhchooXKwDyef2Q+wxQE=;
        b=Cnima+C8SF7tjo3cXaqzSGPZ08d7WYdBwPxKSaItLXTiyo3ZecC/q2Hg6pcpOSvRyO
         md16satrGG9cs0bMEHBUjrs9HfwNtdGpgJtoFpwZ7PsEl8TlGckr5GI/Ln/uuNbvRH9f
         VSKIy13qiBJAzsaRdIGYfC7ZC+2jfHc90lbceqCssCLaM4tV0QKKPmPd4jzwo8Hehv0h
         sXQ0T6MumEUTN36tAA3KzKzuZ4CmzlXHTATgewJ6MODFX8uuYiR+ZbpE4Gw2Nhz7qdD9
         kVl2gC0bnj5XodHf1T7NhszrZHhJ2vzHlJLHtT/Uww5kvS2ywYUO56RaYrcUDoHmioDF
         /IBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795411602; x=1796016402;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uOn8zdpKhoiEr4LfwPlbQlbGhchooXKwDyef2Q+wxQE=;
        b=BI3EAv1XyQmiYlS+43LUlc+wo9qOuE86Xqesl9KvjnYNxTNEDxF3l5oCX3YjDmXyz/
         wrfkOZDzVGBWQtOJDh9+y98vx0WwDIFA7eMHAnkuuzHjxR0QJL5rYgdUCp+imOCnBw5t
         evtrChPSGzcTEKRiQKpJm6bkYVElxGJqeHT/C3AC7S8EBUyRKOXOpw8OqfEgxYu/e+CW
         D/cWtN84nFfjWW69poScILZXWM+JeiJgvqpQlZ1WyQhtvVZ1L6+GuFk53D0O7fSqEtN/
         soFzlokyUvmlWGGCXB7kVWb+56fZmgGpM+NAlZuC9KEh5SUG821cpxp9SQZi8Vf+MW+i
         carA==
X-Forwarded-Encrypted: i=1; AL+hErE00zcAKx5q4E7SGuqc5B+3Odo/fwVN7nRZfyndFa2M0AqXsR4SDMA2JKHJ9CWwh66oF5zm9ckdYN0fmw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/PQWMp0kv8CH9gGI8k7WHoeM3yb5vDXOsjTEFWXvDjfr892doC
	3zXw6TdzHNK+jqagEegV6W0K3iQXPQv+Z46Pinoj+9BPNW+6bme2f5KmoTJ4GdlqWWHLdTVdWXn
	b9/rSTIU=
X-Gm-Gg: AZFdTZezKivl7W3JKzJ+jI4E8gR+tTmVX2rn+sNwiDT4/qDaDQUVtYVh6qVyPS1CEPz
	wG9UBi3uhm7bojmofJvjpDq5KKLenJl90tZ+B2WqtlGLoviVcqlRzw4Jz6zvMMgzh0bkM08kVWN
	AvsniyJdi8DH/vGbFZDULmLLjioF8UN9CdezHoN4CFWhZSepWpTMp6umUUzqa1Fr4PCbynM9F2K
	nNEM14Ycd24v97vqc8Tk3REfqtAI5R7OTO0hXVNDIsuuI6cHBId+3zj/WVLSEE3A8EeLOCXniyz
	M0gP2dr4sWjVdXDLBjbEVSiTgrGA6M8/osq3x4VqZvTTf6hc/EJklsSfIv9/KXRAeDnjc5k1sU/
	7qyIad5wq+jMCSU4YrPC/F3CWFJNAdyQrR499k8ezk9LYd7O/qdW4CNDZF6ugQdM6VvPjc8Thc5
	I40D5xrF3gUZrVnPbaxuW31Css+39grqi/tcBBKmyQBzXanZqy//Arcak8iRMlmK8EuIOogAKQp
	Cicx5gSvWIRgz6+oYTrZU5EurUBrr6WOOdDSKiQDL6XCujoiMAPpmMclvYXFrIA1EnHl6gVxmZC
	OtNEqrekjGECRh8BJukkMm3I75df2HxvijE=
X-Received: by 2002:a17:906:fcb7:b0:c50:d900:8536 with SMTP id a640c23a62f3a-c513a3a33dcmr799689966b.1.1795411602207;
        Sun, 22 Nov 2026 21:26:42 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe23sm15945748a91.15.2026.11.22.21.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 21:26:41 -0800 (PST)
Message-ID: <595a50d5-b2d7-4162-bbb7-03bbba129ac8@suse.com>
Date: Mon, 23 Nov 2026 13:26:36 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v9 2/3] ocfs2: switch DIO read path from buffer_head
 to iomap
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261120060014.12087-1-heming.zhao@suse.com>
 <20261120060014.12087-3-heming.zhao@suse.com>
 <77d9e06a-9111-44d8-b09d-c91bab908327@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <77d9e06a-9111-44d8-b09d-c91bab908327@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph,

On 11/22/26 22:41, Joseph Qi wrote:
> 
> 
> On 11/20/26 2:00 PM, Heming Zhao wrote:
>> Migrates the DIO read path from the legacy buffer_head infrastructure
>> to the modern and more efficient iomap framework.
>>
>> Under the current code, ocfs2 holds a cluster lock during DIO via
>> ocfs2_iocb_set_rw_locked(), and releases the cluster lock in
>> ocfs2_dio_end_io() via ocfs2_iocb_clear_rw_locked(). The lock level is
>> stashed in iocb->private.
>>
>> However, iomap DIO owns that field (it stores a bio there for polled I/O
>> and unconditionally clears it before calling ->end_io). Any side-channel
>> state packed into iocb->private is corrupted, which trips the end_io
>> lock-state check.
>>
>> Instead, encode the unlock level by passing distinct iomap_dio_ops methods
>> (ocfs2_iomap_dio_ops_pr for PRMODE or ocfs2_iomap_dio_ops_ex for EXMODE).
> 
> The code only defines ocfs2_iomap_dio_ops_r_pr, and ocfs2_iomap_dio_ops_w_pr /
> ocfs2_iomap_dio_ops_w_ex are defined in next commit.
> 
>> Additionally, the *_iter() functions use the split __iomap_dio_rw() +
>> iomap_dio_complete() API so they can determine unambiguously, from the
>> return value, whether the completion handler already dropped the lock
>> (real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
>> (no I/O issued, or buffered fallback).
>>
>> The new function ocfs2_iomap_begin() performs a similar role to
>> ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
>> call, ocfs2_iomap_begin() can handle multiple blocks at once. Limit the
>> map offset and length in ocfs2_iomap_begin() to OCFS2_MAX_LOGICAL_BLOCK
>> to avoid overflow issues.
>>
> It seems OCFS2_MAX_LOGICAL_BLOCK not defined.
> 

Do I need to send v10 to fix the mistakes above?

Thanks for the careful review.
Heming

>> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/Kconfig |   1 +
>>   fs/ocfs2/aops.c  | 107 +++++++++++++++++++++++++++++++++++++++++++++--
>>   fs/ocfs2/aops.h  |   5 +++
>>   fs/ocfs2/file.c  |  60 ++++++++++++++++++++++----
>>   4 files changed, 161 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
>> index 2514d36cbe01..bf1678a5eb01 100644
>> --- a/fs/ocfs2/Kconfig
>> +++ b/fs/ocfs2/Kconfig
>> @@ -7,6 +7,7 @@ config OCFS2_FS
>>   	select CRC32
>>   	select QUOTA
>>   	select QUOTA_TREE
>> +	select FS_IOMAP
>>   	select FS_POSIX_ACL
>>   	select LEGACY_DIRECT_IO
>>   	help
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 64fcf6eb3d89..21cdc5c29331 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -4,6 +4,7 @@
>>    */
>>   
>>   #include <linux/fs.h>
>> +#include <linux/iomap.h>
>>   #include <linux/slab.h>
>>   #include <linux/highmem.h>
>>   #include <linux/pagemap.h>
>> @@ -126,6 +127,19 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
>>   	return ret;
>>   }
>>   
>> +static int ocfs2_lock_map_blocks(struct inode *inode,
>> +				 struct ocfs2_map_block *map, int flags)
>> +{
>> +	int ret = 0;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +
>> +	down_read(&oi->ip_alloc_sem);
>> +	ret = ocfs2_map_blocks(inode, map, flags);
>> +	up_read(&oi->ip_alloc_sem);
>> +
>> +	return ret;
>> +}
>> +
>>   /* ocfs2 never allocates in this function */
>>   int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
>>   		    int flags)
>> @@ -171,8 +185,11 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
>>   			map->flags |= OCFS2_MAP_MAPPED;
>>   	}
>>   
>> +	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>> +
>>   	if (!ocfs2_sparse_alloc(osb)) {
>> -		if (map->pblk == 0) {
>> +		/* detected a hole (unallocated extent) in a file */
>> +		if (map->pblk == 0 && map->lblk < past_eof) {
>>   			err = -EIO;
>>   			mlog(ML_ERROR,
>>   			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
>> @@ -187,8 +204,6 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
>>   		}
>>   	}
>>   
>> -	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>> -
>>   	if (create && (map->lblk >= past_eof))
>>   		map->flags |= OCFS2_MAP_NEW;
>>   
>> @@ -2532,6 +2547,92 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   				    ocfs2_dio_end_io, 0);
>>   }
>>   
>> +static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>> +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	int ret;
>> +	struct ocfs2_map_block map;
>> +	u8 blkbits = inode->i_blkbits;
>> +	u64 max_lblk = (inode->i_sb->s_maxbytes - 1) >> blkbits;
>> +
>> +	if ((offset >> blkbits) > max_lblk)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Calculate the first and last logical blocks respectively.
>> +	 */
>> +	map.lblk = offset >> blkbits;
>> +	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
>> +			max_lblk) - map.lblk + 1;
>> +	map.flags = 0;
>> +
>> +	if (flags & IOMAP_WRITE) {
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	ret = ocfs2_lock_map_blocks(inode, &map, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	iomap->bdev = inode->i_sb->s_bdev;
>> +	iomap->offset = (u64)map.lblk << blkbits;
>> +	iomap->length = (u64)map.len << blkbits;
>> +
>> +	if (map.pblk == 0) {
>> +		iomap->type = IOMAP_HOLE;
>> +		iomap->addr = IOMAP_NULL_ADDR;
>> +	} else {
>> +		if (map.flags & OCFS2_MAP_UNWRITTEN) {
>> +			iomap->type = IOMAP_UNWRITTEN;
>> +		} else if (map.flags & OCFS2_MAP_MAPPED) {
>> +			iomap->type = IOMAP_MAPPED;
>> +		} else {
>> +			WARN_ON_ONCE(1);
>> +			return -EIO;
>> +		}
>> +		iomap->addr = (sector_t)map.pblk << blkbits;
>> +	}
>> +
>> +	if (map.flags & OCFS2_MAP_NEW)
>> +		iomap->flags |= IOMAP_F_NEW;
>> +
>> +	return 0;
>> +}
>> +
>> +int ocfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
>> +			    struct iomap *srcmap)
>> +{
>> +	int ret;
>> +
>> +	if (iomap->length) {
>> +		ret = iomap_iter_continue(iter, iomap, srcmap, 0);
>> +		if (ret <= 0)
>> +			return ret;
>> +	}
>> +
>> +	ret = ocfs2_iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
>> +				iomap, srcmap);
>> +	return ret < 0 ? ret : 1;
>> +}
>> +
>> +static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
>> +				int error, unsigned int flags)
>> +{
>> +	struct inode *inode = file_inode(iocb->ki_filp);
>> +
>> +	if (error)
>> +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
>> +				 (long long)size, error);
>> +
>> +	ocfs2_rw_unlock(inode, 0);
>> +
>> +	return error;
>> +}
>> +
>> +const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
>> +	.end_io = ocfs2_dio_end_io_r_pr,
>> +};
>> +
>>   const struct address_space_operations ocfs2_aops = {
>>   	.dirty_folio		= block_dirty_folio,
>>   	.read_folio		= ocfs2_read_folio,
>> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
>> index 8dd6edd7c1a1..72de1e764a57 100644
>> --- a/fs/ocfs2/aops.h
>> +++ b/fs/ocfs2/aops.h
>> @@ -7,6 +7,11 @@
>>   #define OCFS2_AOPS_H
>>   
>>   #include <linux/fs.h>
>> +#include <linux/iomap.h>
>> +
>> +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
>> +int ocfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
>> +			    struct iomap *srcmap);
>>   
>>   int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>>   			  struct inode *inode, unsigned int from,
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 82c88fa8e98f..e309ff9a56e5 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -9,6 +9,7 @@
>>   
>>   #include <linux/capability.h>
>>   #include <linux/fs.h>
>> +#include <linux/iomap.h>
>>   #include <linux/types.h>
>>   #include <linux/slab.h>
>>   #include <linux/highmem.h>
>> @@ -2399,6 +2400,26 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
>>   	return ret;
>>   }
>>   
>> +static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
>> +				struct inode *inode)
>> +{
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> +	/*
>> +	 * Fallback to buffered I/O if we see an inode without
>> +	 * extents.
>> +	 */
>> +	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
>> +		return false;
>> +
>> +	/* Fallback to buffered I/O if we do not support append dio. */
>> +	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
>> +	    !ocfs2_supports_append_dio(osb))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>>   static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>>   				    struct iov_iter *from)
>>   {
>> @@ -2588,7 +2609,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>>   	if (!direct_io && nowait)
>>   		return -EOPNOTSUPP;
>>   
>> -	ocfs2_iocb_init_rw_locked(iocb);
>> +	if (!iov_iter_count(to))
>> +		return 0; /* skip atime */
>>   
>>   	/*
>>   	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
>> @@ -2606,8 +2628,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>>   			goto bail;
>>   		}
>>   		rw_level = 0;
>> -		/* communicate with ocfs2_dio_end_io */
>> -		ocfs2_iocb_set_rw_locked(iocb, rw_level);
>>   	}
>>   
>>   	/*
>> @@ -2628,17 +2648,39 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>>   	}
>>   	ocfs2_inode_unlock(inode, lock_level);
>>   
>> -	ret = generic_file_read_iter(iocb, to);
>> +	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
>> +		/*
>> +		 * Use the split iomap DIO API so we can tell who owns the
>> +		 * rw_lock on return; reads always hold it at PR level, dropped
>> +		 * by ocfs2_iomap_dio_ops_r_pr(). Call it directly rather than
>> +		 * through generic_file_read_iter(): iomap advances iocb->ki_pos
>> +		 * itself, so the generic helper would advance ki_pos twice.
>> +		 */
>> +		struct iomap_dio *dio;
>> +
>> +		dio = __iomap_dio_rw(iocb, to, ocfs2_iomap_next,
>> +				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
>> +		if (dio == NULL) {
>> +			/* No I/O issued; rw_lock still held. */
>> +			ret = 0;
>> +		} else if (IS_ERR(dio)) {
>> +			ret = PTR_ERR(dio);
>> +			if (ret == -EIOCBQUEUED)
>> +				rw_level = -1;
>> +		} else {
>> +			ret = iomap_dio_complete(dio);
>> +			rw_level = -1;
>> +		}
>> +		/* never fall back to buffered read */
>> +	} else {
>> +		iocb->ki_flags &= ~IOCB_DIRECT;
>> +		ret = generic_file_read_iter(iocb, to);
>> +	}
>>   	trace_generic_file_read_iter_ret(ret);
>>   
>>   	/* buffered aio wouldn't have proper lock coverage today */
>>   	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
>>   
>> -	/* see ocfs2_file_write_iter */
>> -	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
>> -		rw_level = -1;
>> -	}
>> -
>>   bail:
>>   	if (rw_level != -1)
>>   		ocfs2_rw_unlock(inode, rw_level);
> 

