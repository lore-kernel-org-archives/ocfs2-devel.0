Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1318619A
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 02:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726624954; cv=none; b=PfK6QqqohlWHc/p656xVDEE79+SAO8/EoVXF4f03ChL/bM7G6fnqyG14Dd4ItizfDUXli12ilfY4HbWUfOJATRjOI9Xvtjhuc566fV8Kze6pHb+0AAYurGjG9/yaRHsu3dg4ZxePxe9PDgTzDFUe1IjC3DcfFbieXx7yglWn6jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726624954; c=relaxed/simple;
	bh=ZfbDh9k7Gfb0x3Lj2v48kbWRsPcK5V6WwootI6rG4EI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T3iGXZjsNaM6IBRedTJZEzURA6X8/RFdI31QvR3o9rV0HEb43JjGVaiPuTwSai+rkKscSh+mgR59sllZfHDED1RnT/x8h48rGHuF8X6eCn0u72H7JeK5r9BqixYzu6cwT7go/sJ9Cg7g+CrrIvxK9LwE9iSAB1qrFuGr1BDqdio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=imqHEDxB; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="imqHEDxB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1726624944; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RYxP3LN7HfQ1HoAFsYKPPgOdnmK7jxbAQtD2YB8bc0s=;
	b=imqHEDxBtgwaKFbt9TSKGy0P+ZzI+dy3qQ3m4ViAxgV1C+13+LpZRde1SaayGq5/mw04hHDau9Nd0Prhw3+3IuSLUO/1yijCYgVNjetp/ksL0Q88ugK6xHyAicCVe9zd3oLD7nbzMRforI86ZNK5ppgkw/Y5riDI7VGqWDhCQ0o=
Received: from 30.221.131.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WFC8WJI_1726624625)
          by smtp.aliyun-inc.com;
          Wed, 18 Sep 2024 09:57:06 +0800
Message-ID: <a4ff61ae-c83d-4a6d-837a-4e3c22c99a69@linux.alibaba.com>
Date: Wed, 18 Sep 2024 09:57:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC V4 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
To: Andrew Morton <akpm@linux-foundation.org>,
 Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Cc: junxiao.bi@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240912064720.898600-1-gautham.ananthakrishna@oracle.com>
 <20240916091647.dbcca9d29f081c7a4c5cd2ea@linux-foundation.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240916091647.dbcca9d29f081c7a4c5cd2ea@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/24 12:16 AM, Andrew Morton wrote:
> On Thu, 12 Sep 2024 06:47:20 +0000 Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com> wrote:
> 
>> One of our customers reported a crash and a corrupted ocfs2 filesystem.
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -25,6 +25,7 @@
>>  #include "namei.h"
>>  #include "ocfs2_trace.h"
>>  #include "file.h"
>> +#include "symlink.h"
>>  
>>  #include <linux/bio.h>
>>  #include <linux/blkdev.h>
>> @@ -4155,8 +4156,9 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>>  	int ret;
>>  	struct inode *inode = d_inode(old_dentry);
>>  	struct buffer_head *new_bh = NULL;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>  
>> -	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
>> +	if (oi->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
>>  		ret = -EINVAL;
>>  		mlog_errno(ret);
>>  		goto out;
>> @@ -4182,6 +4184,26 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>>  		goto out_unlock;
>>  	}
>>  
>> +	if ((oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) &&
>> +	    (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
>> +		/*
>> +		 * Adjust extent record count to reserve space for extended attribute.
>> +		 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
>> +		 */
>> +		struct ocfs2_inode_info *new_oi = OCFS2_I(new_inode);
>> +
>> +		if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
>> +		    !(ocfs2_inode_is_fast_symlink(new_inode))) {
>> +			struct ocfs2_dinode *new_di = new_bh->b_data;
>> +			struct ocfs2_dinode *old_di = old_bh->b_data;
> 
> fs/ocfs2/refcounttree.c: In function '__ocfs2_reflink':
> fs/ocfs2/refcounttree.c:4190:55: error: initialization of 'struct ocfs2_dinode *' from incompatible pointer type 'char *' [-Werror=incompatible-pointer-types]
>  4190 |                         struct ocfs2_dinode *new_di = new_bh->b_data;
>       |                                                       ^~~~~~
> fs/ocfs2/refcounttree.c:4191:55: error: initialization of 'struct ocfs2_dinode *' from incompatible pointer type 'char *' [-Werror=incompatible-pointer-types]
>  4191 |                         struct ocfs2_dinode *old_di = old_bh->b_data;
>       |                                                       ^~~~~~
> cc1: all warnings being treated as errors
> 
> I could just add the typecasts, but that doesn't give me a tested patch :(
> 

Oops, sorry for missing this when reviewing.
Hi Gautham, could you please add the missing typecasts and confirm it?

Thanks,
Joseph
