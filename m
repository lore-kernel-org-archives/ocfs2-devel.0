Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF70222541C
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778480117; cv=none; b=Pb6sJpQuVE7RiJWGbat/xuKj9yHSKzo9eX00nFf4psKDS5HbnWzANin32jpL+L8pquJL//bu3dwT8Woo4ktc8eaIUPmQvnXdR/HlH1sjodHJs0q5r8jxBv6yH4hP9A9S7nsX0Wp9bIyQ+jtCBeRXSlVwMJijzGLeQhCTOEinmjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778480117; c=relaxed/simple;
	bh=YOs+k+ak+5YlznEz/zzXBbN49HMokLY4PWHARD+g/iA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2++mQ+3f5cTzyBlpHJjqnAUN/GQ/n9mFiuthWrwOY09GoV5gWP3GDO6Zt/PLI+JnHxN9EqXWLuEtMwsb8jCT8hFKVmT70fQG8WV1MKjI1TDcZc1+NPawOiFq5ZUI1eh/NMY0pT2hsqtL64clr7BvEqMQItB3xWuWD/TXD2m+Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jmRZ0y8B; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jmRZ0y8B"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778480107; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KsdHm5s0IEELL91PcKNHeidjhF9wKkFsxjGbrXmI2A8=;
	b=jmRZ0y8BLxP7TelcgxC+ooHPkB24d/ztQlvDsfrxKwlhFD4VJq8zftJW2x+oKSIJ6syLhXw+s+Sbpe/XXiwlQ1shgnPTgY261VflK3Ch2l4HSwSMdiC6v4xeKhEEed3GUyXJBcMVAr0l4rCu7QH1htBnmFilFB1M071Nbw+u78M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2er-NG_1778480105;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2er-NG_1778480105 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:15:05 +0800
Message-ID: <80f6acd3-f80a-4b7a-abdb-6723df92d867@linux.alibaba.com>
Date: Mon, 11 May 2026 14:15:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: revalidate the journal dinode before toggling
 dirty
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260509135213.925551-1-gality369@gmail.com>
 <e5806b59-7d5a-4f73-aa9a-24a0c4ec2655@linux.alibaba.com>
 <CAOmEq9Wv+v_rb+FRKYJxvr4V6e9nj49zN-4tM+82=_Ei82PN2w@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAOmEq9Wv+v_rb+FRKYJxvr4V6e9nj49zN-4tM+82=_Ei82PN2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/11/26 10:58 AM, ZhengYuan Huang wrote:
> On Sun, May 10, 2026 at 12:02 PM Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 5/9/26 9:52 PM, ZhengYuan Huang wrote:
>>> [BUG]
>>> A fuzzed OCFS2 image can corrupt the current slot journal dinode while
>>> mount is still in progress. The mount path first reports the invalid
>>> journal block and then crashes in shutdown:
>>>
>>> kernel BUG at fs/ocfs2/journal.c:1034!
>>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>>> RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
>>> Call Trace:
>>>  ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
>>>  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
>>>  ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
>>>  get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
>>>  get_tree_bdev+0x24/0x40 fs/super.c:1721
>>>  ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
>>>  vfs_get_tree+0x9a/0x370 fs/super.c:1758
>>>  fc_mount fs/namespace.c:1199 [inline]
>>>  do_new_mount_fc fs/namespace.c:3642 [inline]
>>>  do_new_mount fs/namespace.c:3718 [inline]
>>>  path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
>>>  do_mount fs/namespace.c:4041 [inline]
>>>  __do_sys_mount fs/namespace.c:4229 [inline]
>>>  __se_sys_mount fs/namespace.c:4206 [inline]
>>>  __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
>>>  ...
>>>
>>>
>>> [CAUSE]
>>> ocfs2_journal_toggle_dirty() assumes journal->j_bh still contains the
>>> same validated dinode that ocfs2_journal_init() locked earlier, and it
>>> uses BUG_ON() when the buffer no longer looks like a dinode. That
>>> assumption is too strong. The mount path can force the same current-slot
>>> journal inode block back in from disk through
>>> ocfs2_read_journal_inode(..., OCFS2_BH_IGNORE_CACHE) while
>>> ocfs2_mark_dead_nodes() scans the journal slots. If that reread finds
>>> corrupted metadata, mount unwinds through ocfs2_journal_shutdown(),
>>> which reuses journal->j_bh and turns the metadata corruption into a
>>> kernel BUG.
>>>
>>
>> A bit confused.
>> Since journal dinode is firstly validated, it means image is checked.
>> Now mount is in progress, how to corrupt it during runtime?
>>
>> Thanks,
>> Joseph
> 
> Thanks for taking a look.
> 
> Yes, the journal dinode is validated when it is first initialized. My
> concern is that later in the mount path, the same journal inode block
> may be read again from disk with OCFS2_BH_IGNORE_CACHE, so the buffer
> used by ocfs2_journal_shutdown() may no longer be the same validated
> contents.
> 
After the validation in ocfs2_journal_init(), the in-memory copy won't
spontaneously become invalid.

And if it is broken by a re-write (e.g. recover), this a bug in the
re-write flow and we have to fix the flow itself.


> This does not mean the filesystem itself corrupts the block during
> mount. Rather, after the initial validation and before the later use,
> the block contents may change due to unexpected disk corruption, I/O
> problems, or a forced reread of corrupted on-disk metadata. In that
> case, ocfs2_journal_toggle_dirty() should not rely only on the earlier
> validation.
> 
ocfs2_validate_inode_block() is a bit heavy. So if we want to prevent a
BUG_ON in case of unexpected disk corruption (still a bit strange, it is
fine in init and then suddenly down...), a simpler alternative would be
just replace BUG_ON with WARN_ON and return error.

Thanks,
Joseph

> Since this is a cold mount/shutdown error path, adding this extra
> validation should not have a meaningful performance impact. I see it
> as a small robustness improvement to avoid turning bad metadata into a
> kernel BUG.
> 

