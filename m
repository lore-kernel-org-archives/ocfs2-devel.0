Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D31E192D61
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734191114; cv=none; b=e8UaO1ZUjzSKmEj1caIaV5rJfGWO/7db8k35DpVNkGSsgBxjEEWM4sgqUQbGPBB2V75lW8VngYjQRqG+L37HmZoWwXoaYc/SSAAZ8DomHIOBKPDDQODlfqvSFPEVIcEgb8brM6qWggITTcSNcm+MiILiBqbwu+43V4Tnfm11r9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734191114; c=relaxed/simple;
	bh=+o5BYVCssbAMi7hBNxBBN2JqNcHscI14nwE255bsBhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YIxnfHpn6OY/Ex4YFoNiB3MBjFvkhhjjtlN7n19dVWV92jP6V24jmuol9VbaPyvYOXhq8NSFHqD6FL/8bv6Da9vd3lIobBB5ZjfP7EHqjbptMeS47kMe9jp7r5JlOFYIp4p30M2lQInfjjmKmtnU0P33Ptfst/DKlMMNqxCKC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Re6i2mb+; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Re6i2mb+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734191103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Hgyzlj2j42/5VauO89Px6z/HVWmjD245RSFpHbLffxQ=;
	b=Re6i2mb+2VrMZCtjP0w+D8eS4CuWvX3SNB5UxvZ0HG9FpEeYtw4ITX89RYu0gD2IEz2l4ICeeJHIFhcz67ygnjkGe6fSLbLycRgla6/eNhkWH2lwT7IGaavDKncRpbQOoHsfGTmNJ6MYtyBU47pidNRU45vvh4PH9R8uBVKLL9k=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRypw2_1734191101 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 23:45:02 +0800
Message-ID: <87b85294-6364-4424-882e-2737eca0a85d@linux.alibaba.com>
Date: Sat, 14 Dec 2024 23:45:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] ocfs2: Handle a symlink read error correctly
To: Matthew Wilcox <willy@infradead.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>,
 stable@vger.kernel.org
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-2-willy@infradead.org>
 <f0279f1a-936e-45c2-9f57-0b82c3fffcd9@linux.alibaba.com>
 <Z12iWZqMw8tiz7jE@casper.infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <Z12iWZqMw8tiz7jE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/14 23:20, Matthew Wilcox wrote:
> On Sat, Dec 14, 2024 at 08:03:30PM +0800, Joseph Qi wrote:
>> On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
>>> If we can't read the buffer, be sure to unlock the page before
>>> returning.
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  fs/ocfs2/symlink.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
>>> index d4c5fdcfa1e4..f5cf2255dc09 100644
>>> --- a/fs/ocfs2/symlink.c
>>> +++ b/fs/ocfs2/symlink.c
>>> @@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
>>>  
>>
>> Better to move calling ocfs2_read_inode_block() here.
> 
> Hm?  This is a bugfix; it should be as small as reasonable.  If you want
> the code to be moved around, that should be left to a later patch.
>

Well, either way is fine to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
