Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953EA3290BD
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Sep 2026 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789608897; cv=none; b=UTVM47BtG19vskjtwvgJxNJ+GUPTsPoZI6UeqK4TtN45BWknDH50YqIzoYsh4KQEahb8r/cWLuoWwcWyZI41hTzkjyL/ZZ7sW/ALMA8Y4LDg/iklCOJiaxT54YVj2tQwKZnp1+W46nPXITZTwvpG4Ui7zcbKqITaO1r040O2/JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789608897; c=relaxed/simple;
	bh=Q4Bmm2BInOP5OudMdDYpd+HnkMiATD4AYQuj3ZU9kbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWX9Np2LuYtj6sTqfPmzo+6ZHr3PvQw/grUIBtvEWpjK0y4SnUzY8dY1ukQibU5d863AgDU+8sZiFneIgRVxkTd0cPar6gRWAIxix4XrLvhRL9mI1/p7yiDHkRS3P7aTOID364LklElZNy/HNcJg0/IfugaH4oZanYRXxkdWkog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N5onHOk0; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N5onHOk0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789608893; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NdN/lLlbb/Noes86GYTJvW3xAkNmueuxUfk2OeVX/Mg=;
	b=N5onHOk07/VHXESw69M0UXVyweeUd2in1PU4EXn5H/adQlGnE0ZOJhTneA5tC7uVtwqOcRlwpSzPSoS7tEFK4215YbvyMqz4RJFXIKmyHrcMJtz5VqknK2//knJA190dHgHK89Zwhdj1fhY0YgDGuNJ3fIxLrw5wqJeAG8H7Ub8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XB6H5Yk_1789608891;
Received: from 30.221.129.217(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB6H5Yk_1789608891 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Sep 2026 09:34:52 +0800
Message-ID: <2d65e5ee-7381-4230-baef-e5c34fb95806@linux.alibaba.com>
Date: Thu, 17 Sep 2026 09:34:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: retain all security xattrs during inode creation
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260916120258.3583355-1-joseph.qi@linux.alibaba.com>
 <aqqe10w7OONy6pcI@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aqqe10w7OONy6pcI@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/16/26 9:54 PM, Heming Zhao wrote:
> On Wed, Sep 16, 2026 at 08:02:58PM +0800, Joseph Qi wrote:
>> When creating a new inode, ocfs2_init_security_get() stores the
>> security xattr returned by the LSM framework in
>> ocfs2_security_xattr_info so that it can be written later within the
>> same transaction.  But ocfs2_initxattrs() only ever looks at the
>> first element of the xattr array, and it keeps the name as a bare
>> pointer into memory owned by the security layer instead of copying
>> it.  The value, by contrast, is already duplicated with kmemdup().
>>
>> With stacked LSMs, security_inode_init_security() provides one xattr
>> per LSM, so all labels but the first are silently dropped and never
>> written to disk, leaving newly created files without the security
>> xattrs the other LSMs rely on.
>>
>> The borrowed name is not an outright bug with the LSMs in tree
>> today: security_inode_init_security() frees only ->value once the
>> callback returns, and documents ->name as the attribute name
>> suffix, so the pointer stays valid for as long as ocfs2 uses it.
>> It is fragile though, as an LSM that allocates the name together
>> with the value would turn it into a use-after-free, so the rework
>> below copies the names as well.
>>
>> Fix this by storing copies of all the security xattrs: allocate an
>> array in ocfs2_initxattrs(), copy the names and values, account for
>> all of them in the credit calculations, and write each one in
>> ocfs2_init_security_set().
>>
>> While at it, switch the allocations from GFP_KERNEL to GFP_NOFS.
>> The callback runs in the inode creation path with the parent
>> directory locked, and the security layer allocates the very same
>> xattr array with GFP_NOFS, so direct reclaim must not be allowed to
>> recurse into the filesystem from here.
>>
>> Fixes: de3004c874e7 ("ocfs2: Switch to security_inode_init_security()")
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> The code looks good to me.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Thanks, sashiko has review comments for the case of 512B block size:
https://sashiko.dev/#/patchset/20260916120258.3583355-1-joseph.qi@linux.alibaba.com?part=1

It looks simple and I'll address it in v2.

BTW, I've sent the update policy including cc ocfs2-devel, but It hasn't
been merged yet.

Thanks,
Joseph
