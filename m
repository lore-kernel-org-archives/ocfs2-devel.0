Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ADC499F27;
	Fri,  9 Oct 2026 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538874; cv=none; b=OvYWNhx5dpyOIttAcioAKWpcS7uF3N4For6FB1TJi2pgjtg3ALQXUdDnQAvxmtpV/ZNI0umWH5/IakAmDDmGruBlI7yzK7uuJfh6QsG2wiRPr+2h+f6BK+GclrbOrr+nhjnfSqLlPP55rYw7UpK0EYAngZ4Ey/RCADYuy+SH7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538874; c=relaxed/simple;
	bh=1u2fMIn/UHyiX68ZoyrdpZyu0QIjx2gp4HJSCEXEsKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJs0yvHhfooZQEaiXTh8t/5uMGXCzgIJTjnZfvf8f7sXufHkvmKMzRlPFRHl4MBKTtGlkGDBrHoGLgSSxkju/2zGHqMIxutH47kPFw2+MsJoJ9WbfJ0qhfL56VLjYmJEBGb2Pt2CGn9tRpUmbIVGGR0Uzv+22+UHn/6LvyWjcCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=U7kr/jir; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="U7kr/jir"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791538862; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e4WsnXhUWvFP/4QqW0Le65evTE6jEKbwUwOkVL7zD1g=;
	b=U7kr/jirBFn1UAtbzSc8nCWWKGdQIeh87h+x7uBVO9QW0j9xnZnNjsXozxUGZHbpPP4OALQaiWxMlBCDAmBPDNiowl7rlR9/3hj6F3AXSf4hibXKlBuMuV8AdzhTF4XM9fYHtx6a5mHt6GFmJW0aM4YR32CDEAv//oEKEZLZ1DI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSy-vG_1791538861;
Received: from 30.221.148.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSy-vG_1791538861 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 17:41:01 +0800
Message-ID: <8455728c-272c-4128-91a8-2d512516936b@linux.alibaba.com>
Date: Fri, 9 Oct 2026 17:41:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ocfs2: deal with legacy signed xattr name hash
 values
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
 <20261009083002.2621201-4-joseph.qi@linux.alibaba.com>
 <sashiko-outbox-165103@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-165103@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 4:45 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] fs/ocfs2: NULL pointer dereference in ocfs2_xattr_set_entry_bucket() on corrupted index
> --
> 
> commit d720400774af2e4eeb97fd62736805be315e728c
> Author: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> ocfs2: deal with legacy signed xattr name hash values
> 
> This commit introduces retry logic to xattr tree searches to fall back to a
> legacy signed hash if an entry is missed using the unsigned hash. This fixes
> a regression where names containing bytes >= 0x80 became unreachable when
> char signedness was changed in kbuild.
> 
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index c5a39a7d43d07..e92bcf401490d 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
> 
> [ ... ]
> 
>> @@ -4304,11 +4322,12 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
>>  	return ret;
>>  }
>>  
>> -static int ocfs2_xattr_index_block_find(struct inode *inode,
>> -					struct buffer_head *root_bh,
>> -					int name_index,
>> -					const char *name,
>> -					struct ocfs2_xattr_search *xs)
>> +static int __ocfs2_xattr_index_block_find(struct inode *inode,
>> +					  struct buffer_head *root_bh,
>> +					  int name_index,
>> +					  const char *name,
>> +					  u32 name_hash,
>> +					  struct ocfs2_xattr_search *xs)
>>  {
>>  	int ret;
>>  	struct ocfs2_xattr_block *xb =
>> @@ -4317,7 +4336,6 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
>>  	struct ocfs2_extent_list *el = &xb_root->xt_list;
>>  	u64 p_blkno = 0;
>>  	u32 first_hash, num_clusters = 0;
>> -	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
>>  
>>  	if (le16_to_cpu(el->l_next_free_rec) == 0)
>>  		return -ENODATA;
> 
> [ ... ]
> 
>> @@ -4348,6 +4366,59 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
>>  	return ret;
>>  }
>>  
>> +static int ocfs2_xattr_index_block_find(struct inode *inode,
>> +					struct buffer_head *root_bh,
>> +					int name_index,
>> +					const char *name,
>> +					struct ocfs2_xattr_search *xs)
>> +{
>> +	u32 name_hash, legacy_hash;
>> +	int name_len = strlen(name);
>> +	int ret;
>> +
>> +	name_hash = ocfs2_xattr_name_hash(inode, name, name_len);
>> +
>> +	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
>> +					     name_hash, xs);
>> +	if (ret != -ENODATA)
>> +		return ret;
>> +
>> +	/*
>> +	 * Nothing under the current hash.  The entry may have been stored by
>> +	 * an older kernel, which sign-extended the name bytes when hashing.
>> +	 * Skip the retry when the two hashes are equal, so that a name made
>> +	 * only of ASCII does not have to walk the tree twice.
>> +	 */
>> +	legacy_hash = ocfs2_xattr_name_hash_signed(inode, name, name_len);
>> +	if (legacy_hash == name_hash)
>> +		return ret;
>> +
>> +	/*
>> +	 * A miss still leaves xs->bucket holding the bucket a new entry would
>> +	 * be inserted into, so drop it before searching again.
>> +	 */
>> +	ocfs2_xattr_bucket_relse(xs->bucket);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> Does this new retry logic need to validate that xs->bucket was actually
> populated before relying on it?
> 
> The patch builds its retry logic under the explicit assumption that a miss
> invariably leaves xs->bucket populated. However, if the filesystem is
> corrupted such that the external xattr block is indexed but its extent list
> is empty (el->l_next_free_rec == 0), __ocfs2_xattr_index_block_find()
> returns -ENODATA immediately without calling ocfs2_xattr_bucket_find().
> 
> This early return leaves xs->bucket->bu_bhs unpopulated.
> 
> Later, during a setxattr() operation, ocfs2_xattr_block_set() delegates
> to ocfs2_xattr_set_entry_index_block() and then
> ocfs2_xattr_set_entry_bucket(). The call to ocfs2_init_xattr_bucket_xa_loc()
> expands the bucket_xh() macro, which accesses bucket->bu_bhs[0]->b_data.
> Since bu_bhs[0] is unpopulated, this triggers a NULL pointer dereference.
> 
> Can we add validation to handle cases where __ocfs2_xattr_index_block_find()
> returns -ENODATA but doesn't actually populate the bucket?
> 

It's a pre-exsiting issue.
It seems we have to enhance the validation in ocfs2_validate_xattr_block().

Thanks,
Joseph
