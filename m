Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DC420823D
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079876; cv=none; b=oxXf+s61p6kFaZL7kM5Gu61bAtjjqW/vuOgFK/Ka1zM80hAc7jGxBB3phNsQHVAiDIY7WwTzDrktypW/vAvnUfOTds9ek5gOWK+GSxIXtOjWub69a1OOO84FfYzK4xKkK9YTlUTvZBrzZYms4CZ6yjaihaVW4K6tI8TrqVbN2N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079876; c=relaxed/simple;
	bh=qHJwCML0yuaduv6O7XQdt2UjbsUZ/mhSoYf7b61MFxw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=W4ExP6H9IeFq3ON0Aksv85HwqlQTmDV7DiHY7mFz9ZDw+mW95ZaRgzosZsoaPETBYqpYoDVO/I2ugyymQmkrpysmUW8X+jTcaC02FQbV8AEznzxPs6tr5bHEc7gfY0ExW7qLbCoYB3tRu5KagS5OLyJtbt7QHfwyirYV1pZlr/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=q9MRlZKP; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="q9MRlZKP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1729079864; bh=yyVVPhmTjoVlyUBI17XwqcnWMQyrN6JMB9OGuBqaJck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9MRlZKPLejsCdLx2DSoG2eLEv849T2F1pZe4O0zvpOQx7lTxiHq6L59khNUQPr8/
	 krf/HAw1dy9vIgn7KOJG0JuGxJPS8kshAEXJVeQMn8kxIo7T3uGv9hzQwGxJgQMq9o
	 Q7UrD6geNtMpk9dnUt0Fa3feq4BlBjuqLApCVTgw=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id E690D494; Wed, 16 Oct 2024 19:57:41 +0800
X-QQ-mid: xmsmtpt1729079861t4vn90nml
Message-ID: <tencent_A6B4645A17675769C6D6F37A8362C9660305@qq.com>
X-QQ-XMAILINFO: MB5+LsFw85Nos7rz+LzGdi90P3PTIcBMLOgnb29vp8A0vHFYyQlnH5Y8ScEVyg
	 rndWC4Aal+2atadnG5nMbOgSaXxcFhBVHuCq+oUARJ+VabRH8OuF5jqYN02ezVB8puZ8S6AfN8DA
	 r367H835UeoPQ6cX4FCn2lleNYhw77qSQfFhTsj0imy0hO1Yeiv6XZSShhoSBeq36OqJUgAklCnv
	 On6HybZPcGwyPL9DDGjCEWl1DaN+LMiAYbT0SskNsqq1Wi3gHprlknxApVvE9Mu8/EgNBeHuaFih
	 nYcuGndipvLXyHXsldKPQaWzeyP7khX/CYJXLqBe9lJyHSk/OiUKI4LutKjEIlnyETLx5kwqMZo0
	 CURrZO5bpfyl8JU/k19GlsKn8jSNIqZUEWMgxDP1VKCQCG9WkzHbKt3tjzVaGZWhtZ7tl6GUFff6
	 VtjDJK5OjPEqoIndp++L3SHxx+8n+n9o09p9aj9161aN93NJbJ/vi6lmkxE+CVejcwlTvQgkeLsX
	 ZqI3Prmzdbn+SqV8LTuQm5r8I1dFG7vWMyhZd8phM8dscDFQE49gQ2d+p8idxButZoOWId5Q18vQ
	 q43szTB76V/TZZt85hUmSOFHSxUlF8anSiTUg8uOw3e05quptZJfdgviONH6276viFKe0BlBtKBs
	 /16F4V+GotjM/VJlWeI6fKPJUQE5MRE2X4fQxbOIo6gMrE/IMp5b4vPUEVgjOIcZhR+ve177PUzX
	 SXEUTokha4O/88U1ViyCmtWx8KphC2orFC5wABSw9YC6rYHH2zaul+cOhUcAzeh+symrncqJJ0oN
	 QXSBVcymXnkObELjHYBZvaSbuqv49UzxF8KkmDQFr5J92A36KzSDzhREs7NtdNU8Tx+aFJVXgeQZ
	 m6i9Zk7mFJFQ5R/OtjfwmE+xX/zninire3Mm2Bb4IS4Xo+yvrTgvy7YPQ0QUZ2R0ll8IlDDdAajz
	 /xwQv3BPYpvkU/1RaCyB9NdD8AdODmAWTXJO3te4fL+vrmn7wQqQqh50xOFOl8
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V3] ocfs2: add a sanity check for i_size
Date: Wed, 16 Oct 2024 19:57:36 +0800
X-OQ-MSGID: <20241016115735.904671-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <106ceb9b-0f7f-4962-98e7-d9fa86d08a0a@linux.alibaba.com>
References: <106ceb9b-0f7f-4962-98e7-d9fa86d08a0a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 16 Oct 2024 19:08:26 +0800, Joseph Qi wrote:
> On 10/16/24 11:52 AM, Edward Adam Davis wrote:
> > On Wed, 16 Oct 2024 10:06:27 +0800, Joseph Qi wrote:
> >>> Reported-and-tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
> >>> Closes: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
> >>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> >>> ---
> >>> V1 -> V2: keep rc to 0 when falgs contains READHEAD
> >>> V2 -> V3: check i_size only and alert subject and comments
> >>>
> >>>  fs/ocfs2/extent_map.c | 6 +++++-
> >>>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>>
> >>> #syz test
> >>>
> >>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> >>> index f7672472fa82..29d27a70dbdd 100644
> >>> --- a/fs/ocfs2/extent_map.c
> >>> +++ b/fs/ocfs2/extent_map.c
> >>> @@ -961,13 +961,17 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
> >>>  	int rc = 0;
> >>>  	u64 p_block, p_count;
> >>>  	int i, count, done = 0;
> >>> +	loff_t i_size = i_size_read(inode);
> >>>
> >>>  	trace_ocfs2_read_virt_blocks(
> >>>  	     inode, (unsigned long long)v_block, nr, bhs, flags,
> >>>  	     validate);
> >>>
> >>> +	if (!i_size)
> >>> +		return -EINVAL;
> >>> +
> >>
> >> Take a more consideration, inode size 0 doesn't mean it has no blocks,
> >> since we have a case that fallocate with KEEP_SIZE.
> >> Could you please check inode->i_blocks in above coredump?
> > I have previously verified the value of inode->i_blocks in my testing environment, which is 0.
> >
> So it seems the check condition should be:
> 
>   (v_block + nr) > (inode->i_blocks >> (inode->i_sb->s_blocksize_bits - 9))
Do you mean like this?

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..9613cd356ac5 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -966,6 +966,9 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
             inode, (unsigned long long)v_block, nr, bhs, flags,
             validate);

+       if ((v_block + nr) > (inode->i_blocks >> (inode->i_sb->s_blocksize_bits - 9)))
+               return -EINVAL;
+
        if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
            i_size_read(inode)) {
                BUG_ON(!(flags & OCFS2_BH_READAHEAD));

BR,
Edward

