Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64428335BAF
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761814107; cv=none; b=bZEm9kwHlQNHt/WgOgF+ERbbq1yQNWcVskh9OhfRBuiS6Sh0LJKG7XFrLKJlys8b5CU3OQeLafmD5vyw8xGF4EciAMMu2/u3RUBG6pa9S3LyKdHU5z6k4MgJL7TPqb5ab7vrG4r4H1W6Ic4OxCrc6BFP2tnq348mUYJeF8DBpfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761814107; c=relaxed/simple;
	bh=J+EYqLb1D1xcN8w56Y92H/fISYVgTSEemisBFJGOQvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Itmt9ubXTSf4t+mUaubOHLn2BbjMYYVBa6J/jQ78gY2xJruCqptRKBQi30t93ISolxVOFv79GiylsyONJrvvuFLDxKRGA3sahulzYlgSlMxSBzuZEhbwNcASAh2p4nU5+n4XImskENxX5r+kvJonpW7eO+xZamHCMb4vYeGwijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ougi8TVY; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ougi8TVY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761814101; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hZtC9qWNK5upRr4D6x7wBqeIPV4d3KE5tOWkjCqAyZc=;
	b=ougi8TVYSgLxAGG8KBq82G7mAUFn7vpVqw/2+s0UmLJ39IhtLkqwyKTDXxsyQZODbEHZB6v+tnOhMeY4PFYLxMkKcnq1uR8xK0CqKlRysLAESOpQScCQfKHDIOQy1fjwQ/SNmBhTi7XJp/mydrYF9+bzzfWKmx85v3OxtOmSTC0=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrJaDC8_1761814100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Oct 2025 16:48:20 +0800
Message-ID: <a5f617da-ab4a-414b-ba2b-a6f126708620@linux.alibaba.com>
Date: Thu, 30 Oct 2025 16:48:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
 <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
 <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
 <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>
 <x4g7symjachxmkyhjqx5x2dfdn4ybvfkbzjvqiso7qbtxdgov7@2xds57btyzt2>
 <f2323939-4939-439c-8fc3-773c60cc25e6@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <f2323939-4939-439c-8fc3-773c60cc25e6@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/30 16:11, Dmitry Antipov wrote:
> On 10/30/25 7:22 AM, Heming Zhao wrote:
> 
>> One way I considered uses the inode block number to bypass global_bitmap.
>> the code seems ugly (demo):
>>
>> ```
>> osb = OCFS2_SB(sb);
>> inode = ocfs2_get_system_file_inode(osb, GLOBAL_BITMAP_SYSTEM_INODE, OCFS2_INVALID_SLOT)
>>
>> if (OCFS2_I(inode)->ip_blkno != le64_to_cpu(fe->i_blkno))
>>    goto by_pass_the_check;
> 
> This is what happens in ocfs2_initialize_super(), and, IIUC, the global (cluster) bitmap
> is the only dinode which can have cl_bpc set to 1. So what about the following:
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 709afbfd1f9f..a8138c150d81 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1520,7 +1520,18 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>                                          le16_to_cpu(cl->cl_next_free_rec));
>                         goto bail;
>                 }
> -               if (le16_to_cpu(cl->cl_bpc) != bpc) {
> +
> +               if (OCFS2_SB(sb)->bitmap_blkno == 0 && le16_to_cpu(cl->cl_bpc) == 1)
> +                       /* This dinode represents a cluster bitmap, and we're reading
> +                        * it for the first time from ocfs2_initialize_super().
> +                        */
> +                       ;
> +               else if (OCFS2_SB(sb)->bitmap_blkno == le64_to_cpu(di->i_blkno))
> +                       /* This dinode represents a cluster bitmap, and we can
> +                        * recognize it by using the known block number.
> +                        */
> +                       ;
> +               else if (le16_to_cpu(cl->cl_bpc) != bpc) {
>                         rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
>                                          (unsigned long long)bh->b_blocknr,
>                                          le16_to_cpu(cl->cl_bpc));
> 
We don't have a simple flag to identify the global bitmap.
AFAIK, we may check it through:
  1. i_clusters, global bitmap has the whole volume clusters set in this
     field.
  2. i_blkno, which is set during mkfs.

But now we face the situation during the mount when initialize super,
which means the corresponding fields in ocfs2_super is 0 as of now.

And I've also found during runtime, we can validate through:

static inline int ocfs2_is_cluster_bitmap(struct inode *inode)
{
	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
	return osb->bitmap_blkno == OCFS2_I(inode)->ip_blkno;
}

So here we may check it something like:

if (OCFS2_SB(sb)->bitmap_blkno &&
    (OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
    (le16_to_cpu(cl->cl_bpc) != bpc))

Joseph



