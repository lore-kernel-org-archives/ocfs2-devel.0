Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86563F9D2
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 06:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760078199; cv=none; b=Z04gyAeDUI3tAZEqTG9KUKh+XpzNlbcoGE4XLJVlygkK58+jTbm6s31VBB+YQStowUE6vSHfSATqQ7jlUM06nEpDnJOIpHxMDe7O7ReQiZrIl2sPqRA6l/0hUXMKizXzhZSVf3qjXzYNlae4rtxnUSMVfSA/zAOttiMkiNLRM4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760078199; c=relaxed/simple;
	bh=FEgAL+JjDSIZzLIUZUnRv5cp6ja2ElTmDrIPRmPuqWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BECG7YjiDwK+q2QktjNuli9LnDZjMZPMOfLiDMVlUUxGU4n+trb4qlmP+iMmgJXFWUssjvot1kItDRl0f54bNqY/OL4v5IDr6VlvLw0DVWzfu4CtWDAvpvivuTXF0ol82QLoUVEY6+3BaifhOmh14x90xgi/Tj6cJe506e1bxtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ebc1X+cT; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ebc1X+cT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760078188; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4LEi1hp9dAtM7VK58/+l+uwJw7dbJFn9jmEeTJru+2w=;
	b=ebc1X+cT5XzhTKMxlNIrShg+tJ9vZTy0xE1b7acxzQ5iLT0GNU5HaqOGBt/cyKPWUxoXwE6wumZkCfVdPYdk0c8D7nREJqaekOM+8BsdoZLfDSlt8Lr+jbTUP4I7zQD36kteo4/m1M/QkEVeuEUAvY8ysKkFzwAHg3fwW24hRis=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpsOhZ1_1760078187 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Oct 2025 14:36:27 +0800
Message-ID: <35fdecc4-39f3-4f3b-b1fa-95c9a8134f18@linux.alibaba.com>
Date: Fri, 10 Oct 2025 14:36:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_dx_dir_lookup_rec()
To: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
 <20251007094626.196143-1-dmantipov@yandex.ru>
 <93f3ef3c-0363-430b-acf8-db70bd4a4b16@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <93f3ef3c-0363-430b-acf8-db70bd4a4b16@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/10 13:53, Heming Zhao wrote:
> Hi Joseph,
> 
> Do you have time to check my following comment?
> 
> On 10/7/25 17:46, Dmitry Antipov wrote:
>> In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
>> of the directory indexing block matches the one configured via the
>> superblock parameters established at mount, thus preventing an
>> out-of-bounds accesses while iterating over the extent records below.
>>
>> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>> ---
>> v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
>>      and rely on the convenient ocfs2_error() to handle error
>> ---
>>   fs/ocfs2/dir.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 8c9c4825f984..ece0462a5d26 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>>       struct ocfs2_extent_block *eb;
>>       struct ocfs2_extent_rec *rec = NULL;
>>   +    if (le16_to_cpu(el->l_count) !=
>> +        ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
> 
> el->l_count represents the length of the array l_recs[], the max value is
> ocfs2_extent_recs_per_dx_root(sb). Therefore, we should use "<=" instead of "!=".
> 

In ocfs2_dx_dir_attach_index():
  dx_root->dr_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb))

And the above path is non-inline case, so it seems '!=' is correct.

Thanks,
Joseph


