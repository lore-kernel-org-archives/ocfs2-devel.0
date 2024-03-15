Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE892175AB
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 07:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710487343; cv=none; b=dkd/gD0BYCSfE085EXroTCx4oA0ndpPRPG+7XkGf47U4yAUS4HhyuWOGQIGFIZp5uW3kGjqOCv21PxO+21GjUt2kQ87qV+LuD7QFtdr5PNxxfRRqSeAlQSwLPNFK/O5A3hF6Ddb4RM3pqLEit0gW/HSMnvC3iunKYPa5BUVEmDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710487343; c=relaxed/simple;
	bh=n0p+OyCrinr+D9488ye3XjWQmeZsqxuLxMgAQJ6p/uU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RcgfwdERHEtoeNacYXIqo9S8G/nSY2dAnIbQrfHiKX5PApRd8HXIg/t896UK/bbd2SDSjI+nLSleNoG6FWjq6a3roEmb9zOorBZ3KyJUFWkDptckOqBXboPK4X1qCL/5+HT62WZDKY6ddm6KLlT5WHDPWmIqHNqHgL/kKZqmimo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KlLiLmB/; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KlLiLmB/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710487331; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=E231W4z4t9LbVG37E0eLnknrQ4xB83guQ8W7M/SIP9A=;
	b=KlLiLmB/m62FsglUu17U6/osKy/3j95e4m7R5rBFS4lxnyw9lE9u6HazYxcsHr2agmZd4Hr7fvkg4XaFUhp/a5QKkq+q5WHrWKd9wEOI52jnCJMiE6mDkN+RP2H4iH0J96Kd5qL8/l7UGjIljLSJr6qRlpT73qRwP+1gMQ71RiQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W2VQFer_1710487330;
Received: from 30.221.128.128(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2VQFer_1710487330)
          by smtp.aliyun-inc.com;
          Fri, 15 Mar 2024 15:22:11 +0800
Message-ID: <c535edcc-67da-4c40-bfd2-decd602bfded@linux.alibaba.com>
Date: Fri, 15 Mar 2024 15:22:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
 <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
 <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/15/24 10:25 AM, Heming Zhao wrote:
> On 3/15/24 09:09, Joseph Qi wrote:
>> Hi,
>>
>> On 3/14/24 3:33 PM, Heming Zhao wrote:
>>> This patch resolves 3 journal-related issues:
>>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>>     protection for modifying dinode.
>>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>>     journal protection for writing fe->i_size.
>>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>>     This adjustment ensures that only content requiring protection is
>>>     included in the journal.
>>>
>>
>> Any real issue you've found for above cases?
> 
> No. I just found these issues when I was reading code.
>>
>> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
>> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
>> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
>> already dirtied before. Since they are in the same transaction, I don't
>> see any problem here.
> 
> Yes, they share the same transaction.
> However:
> In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
> pair to protect metadata. In my view, jbd2_journal_access starts the
> protection stage, jbd2_journal_dirty closes the protection stage. the rollback
> function should start a new access/dirty pair to info jbd2 the di_bh had been
> modified again.
> 
Refer jbd2_journal_dirty_metadata():

/*
 * fastpath, to avoid expensive locking.  If this buffer is already
 * on the running transaction's metadata list there is nothing to do.
 * Nobody can take it off again because there is a handle open.
 * I _think_ we're OK here with SMP barriers - a mistaken decision will
 * result in this test being false, so we go in and take the locks.
 */

So IMO, we don't have to access/dirty again since the buffer head is
already added before.

Joseph
