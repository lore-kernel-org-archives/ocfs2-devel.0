Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85280370AD4
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516518; cv=none; b=Wq7LhtN/6ZKw6K5FXgxbgXVzjO6yuHC6TXD6guIUckhd8NmyrRw0qqnud0OPEcaJu3ezUhOZjI29C/iI9Nr4FIVUIxzSWh7LWS0WNHoUUipS8xNI4K2y5JrUY8Gvz/Ra4RrnqpLvHlf6ZPSe4XAojUI4RJwo/NOieUjZ2aKTo3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516518; c=relaxed/simple;
	bh=Fhf89OxtAjPYUu2KgbUnqM6rwY+Pss1vn61vMZFRnUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d3kYP6/9vLQE1t7KGbn40giYaeNHWCPafJJUZYQ4iwzXc+O2jHe81fZZez4UvXFOpb+ZAXw9AwEyCfMNAJWsSMAG7eoR1CNwODKlHXYIdwX2vRtM0STD+lvB1sKtgDVwC/az4rSSQosxkgRxDDxCsWk3dCa7HJMDbkvZq+WY2YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=edH5l26e; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="edH5l26e"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791516499; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s3kRDoAF/vjBPX0XYIPxqBqn90ZUIyzKkTuvhvO7wgQ=;
	b=edH5l26exbSk6Mc1Y/3IwfIrKx87jv+uEE5L/Tn9ucJovkw4hPD01w2jKJdwvX+kCNoiGe/GXS8lltzaIrpRUuCeIPid8cZiJEvm7cJT/CAftHZ+UUIuCAusa+wjX6lgMdLoPd5kNBAcw127B9PSZcVbdzS6a4s5oPns3FiicRQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCS-sfJ_1791516498;
Received: from 30.221.148.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCS-sfJ_1791516498 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 11:28:18 +0800
Message-ID: <131f9866-3ac2-4de2-9589-3e35eacce8d5@linux.alibaba.com>
Date: Fri, 9 Oct 2026 11:28:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: deal with legacy signed xattr name hash values
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Anderson Ferneda <anderson.ferneda@braza.com.br>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>
 <20261008122743.616779-2-joseph.qi@linux.alibaba.com> <ashc5y5FgsvxvX0F@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ashc5y5FgsvxvX0F@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 11:18 AM, Heming Zhao wrote:
> On Thu, Oct 08, 2026 at 08:27:43PM +0800, Joseph Qi wrote:
>> Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
>> -funsigned-char globally, which changed the result of the naked 'char'
>> load in ocfs2_xattr_name_hash():
>>
>> 	hash = (hash << OCFS2_HASH_SHIFT) ^
>> 	       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
>> 	       *name++;
>>
>> A name byte >= 0x80 used to sign-extend and now zero-extends, so the
>> hash no longer matches the xe_name_hash an older kernel stored.  An
>> indexed xattr tree is searched by that hash alone, and both the bucket
>> binary search and the entry scan within it stop as soon as the wanted
>> hash falls below an entry's, so the entry is never reached: getxattr,
>> setxattr and removexattr return -ENODATA for a name that listxattr
>> still lists.
>>
>> Search with the current unsigned hash and, on a miss, retry with the
>> legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
>> with legacy signed xattr name hash values").  New entries are always
>> stored under the unsigned hash.  Skip the retry when the two hashes are
>> equal, so that a miss on an ASCII name does not walk the tree twice.
>>
>> A miss is not empty handed: ocfs2_xattr_bucket_find() leaves xs->bucket
>> holding the bucket a new entry would go into.  So after a double miss
>> drop it and search once more with the unsigned hash, otherwise a new
>> entry would be placed by its legacy hash and stored under its unsigned
>> one, breaking the ordering the search relies on.
>>
>> Only indexed trees are affected; inline xattrs and non-indexed xattr
>> blocks compare names with memcmp and never look at the hash.
>>
>> Also spell out the signedness instead of leaving the current hash to
>> -funsigned-char, as commit 854f0912f813 ("ext4: make xattr char
>> unsignedness in hash explicit") did, so that both variants stay correct
>> if this is backported to a kernel without the flag.
>>
>> Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
>> Cc: stable@vger.kernel.org # 6.2+
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> I agree with Sashiko review comment, the ocfs2_check_xattr_bucket_collision()
> also requires the same fix.
> 

I am looking into it.
It seems we have to use the stored hash for an entry that already exists.
I'll send v2 with a third patch to address this comments.

Thanks,
Joseph
