Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D8619ABD3
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 11:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724238921; cv=none; b=jKT3V9uMGGqYBdGIGoVqFn2s34K1z+uq0PYGjF/IJiAnFPBo0u2Lw5QZj5Vy0d7DQ9f8VHokxDFaTni0AT6bhSHDG1dEsJXvsxss2fVbR9ptmwoXp7A0WrubUIoSqXRdFHXZdq+IFHnlBk5fNJhZmYEuKq4PIJmtLFXKF1nqPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724238921; c=relaxed/simple;
	bh=l3wvNV+VklR8Lxi8amEs5BeXVWIW8+LaHr/iC9b4Kns=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DUQEApYBPQ9GAWw3YKp5AHiBhfBq8JI3pgLOj3+6l4CFP4hI/tlMial+PXLWCfgy5bEQLcV06tCSRdAMpp5/6gVfA8Rq1WJx40/4iiZER1Uzz9HvnS8kNDbddLyShj28Ap02+ZFYGQKDbmoXDYRUKgtIAXHpSivbnNYricdrBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=GWJiRM5h; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="GWJiRM5h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1724238916; bh=JNZYhdmUEM5+zsieVXil6/J+yfO7Rh4dM5XLtObIkjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWJiRM5hjyj/555im3+5FSNRT74nww9UAR3UNbQ8HJFfIqhZH5WW4wzJP8g5wBxkX
	 90+w7kV5E9pVWX9+G32FMLbLwwWz9esduhSeYo9bjfBmZ2smgumzwizHcUi3C03T7S
	 gg6tOhTEkrmgbtvFw48JP+DTCY3SXNkwfSiW/6aA=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id 3C7354F1; Wed, 21 Aug 2024 19:15:07 +0800
X-QQ-mid: xmsmtpt1724238907tax76rmbm
Message-ID: <tencent_0DCC0C781E6C402F756C3C9758E9F6EE720A@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTPOzuldNXnGcmcxVJyiZqBY+ub/YrZ4Moo55x9pyWR+2orsk2xV
	 l6kRx1MNTmzUXNuVqcjt6ch94+BQoW3kFagmiMHyAN6Nd3sxr0fXYpNj5zbe4UGU5WoDsOcEi3mx
	 +Yo40N4avGXlg7LL8u0QZWolYwnb3gL+iINcIwx5iPekaHK52fqypyVdl+KYbzkmJWAXTtNpHPvg
	 3PJQuA84nhm4cqFLAXLheF9w6YxhZLzIVyKPIdK+6aeh9x92Lo1MHq5d8ZMVo2dBIVcdKVLHM3OB
	 J6NAYYcswdGzTtEVjR7xfc/YTKgy26jOUzxw/dXMlEu4NSi48sSrCc8wyADxOZnm6GxzcvDf9Ihs
	 7RSfZjiwGh/0N0gQN8uvpM3gUm3FTi5T3vY6mNC86xLeV81R6WyVDa+O9U6/d+T+hWaId7uT5ChV
	 1NVdUlIFAyQhwrC+gV/4cRVkg1O7BoqdbEeJud0Ioww0SiHBaCp1N5EYBYyEDqJhDX3oKEwnLnAf
	 yUH9xHpMJ8/hdR1FyH1gY9tdCMGJpbU+3oYW1bkXtHV0G6Byy5to0DSZQBKbhQguabhtWZZrDROk
	 3GXMeni7YtgxMvOkQ+jTS0QWR6WMqXk6sjVT5l4jGLYVKg8fyEtVVuKRY38nbF/2CILNuCQw0+I1
	 ErCXOxIbq26vg/AglYssFfIMnlpKdoMYeIHcbOEfG1yY2TS/eLsSPhSxrED6WX/xhAf4j95wZRhy
	 3HR/kcAPY6/INHkzeL9qJ6yr0/G4o35/N5DOlm3e9EKvevbIAMRSloo63VqQ4lLU6LFAKP8nlpBV
	 Bmna7Cfyp5cDgzDUC4G+dXpW/XbqkFWfhCA2w42hGA+HS9Q3nMJB43/Gs2EtjM2YS3HHk3AblHCX
	 cnxQfrUDutiuG9vwHXp89nh03wiSASCLn/N51DpJwijxjPVK8BmVufw9N6N2fK6vX4UccohCbSB4
	 9S/6S/Bla4zyvFduREUqc1CQexD27zQN4KPEIEOS8=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
Date: Wed, 21 Aug 2024 19:15:07 +0800
X-OQ-MSGID: <20240821111506.555440-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <606d781a-2d5c-48fc-bc67-4c7ff66a1dd7@linux.alibaba.com>
References: <606d781a-2d5c-48fc-bc67-4c7ff66a1dd7@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 21 Aug 2024 18:41:06 +0800, Joseph Qi wrote:
>>>> When the i_size of dir is too large, it will cause limit to overflow and
>>>> be less than de_buf, ultimately resulting in last_de not being initialized
>>>> and causing uaf issue.
>>>>
>>>> Reported-and-tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
>>>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
>>>> ---
>>>>  fs/ocfs2/dir.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>>> index d620d4c53c6f..c308dba6d213 100644
>>>> --- a/fs/ocfs2/dir.c
>>>> +++ b/fs/ocfs2/dir.c
>>>> @@ -3343,6 +3343,8 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>>  	unsigned long offset = 0;
>>>>  	unsigned int rec_len, new_rec_len, free_space;
>>>>
>>>> +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
>>>> +		return -EINVAL;
>>>
>>> Why OCFS2_MAX_BLOCKSIZE?
>> I think it is largest block size in ocfs2, therefore, if it is larger
>> than it, it must be incorrect, even though the value of i_size in dir
>> in the current issue is much larger than it (i_size_read(dir) is 0x900000000000100).
>>> It seems that this is caused by a corrupted dir inode, since this is an
>>> inline case, we may try best to make sure it won't exceeds block size?
>>> i.e. dir->i_sb->s_blocksize.
>> You mean dir->i_sb->s_blocksize bigger than OCFS2_MAX_BLOCKSIZE?
>>
>No, I mean check s_blocksize seems more reasonable rather than
>OCFS2_MAX_BLOCKSIZE.
Perhaps we have different perspectives on the issue. 
My approach is to set a bottom line for the dir's i_size, and if it
exceeds the bottom line, the dir will definitely be corrupted.
And I think OCFS2_MAX_BLOCKSIZE is the reasonable bottom line.

BR,
Edward

