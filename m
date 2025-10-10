Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24714286
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079305; cv=none; b=ZaLyG3+xBJUoxuE/Yt/IURSDUpdDG8Z3+IpGaMYT1OI4EOzu06JEWib05SWEFCbRCiOWoKMBXmYKGQMZFJ+c+m7H2YgZmwzwcLefanFVrJ+6Nfw4re1KdIurLh43BmqTkAQSyJ27OBfqvmEu/pbWazniRbR/U2nfvjr98HM4rLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079305; c=relaxed/simple;
	bh=0LNKZNIJ2Bq7y+xJyjKNhfZYNIQDmIP8Liwrpyst6wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBsNV93e1yd7AQYqsENnsn2iheOl/87ErodU+vrqCrvw0UfaJJRa52tumKCVf4Qu1nAikxzD3dK5OY4LacYzDi7QtpSX3bzL6aRztt3rPsTPdNyyfiLxKecWYAKXiwj0gwtAChzsjFbvPjQi7MndlE9pwZ5WB4utnHoSqgX/7IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aLVo2K8L; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aLVo2K8L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760079299; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xqkGLrtq7tPL9AjwuPCeB3hyU6qIjzz0ywfX/KpD3gI=;
	b=aLVo2K8LK08eul61mnW5/KEOQH8gTt9yXgO7l8nFFeBiKciR/v66R0Nn6TyEDToFz2kv2+I7nuc5BwJzBNnXPnywuuy65NxTTV9Vn5mCLr2KlKrX8kabQ244aBXkh7BGhkC6lYjeOZIqk8cjcXcMXBUcF+3+EI9t03XEsZMTUbA=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpsR0V8_1760079297 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Oct 2025 14:54:58 +0800
Message-ID: <60ee8e1a-3e06-4b9a-8e2f-bd3f81331732@linux.alibaba.com>
Date: Fri, 10 Oct 2025 14:54:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_dx_dir_lookup_rec()
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
 <20251007094626.196143-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251007094626.196143-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/7 17:46, Dmitry Antipov wrote:
> In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
> of the directory indexing block matches the one configured via the
> superblock parameters established at mount, thus preventing an
> out-of-bounds accesses while iterating over the extent records below.
> 
> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
>     and rely on the convenient ocfs2_error() to handle error
> ---
>  fs/ocfs2/dir.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..ece0462a5d26 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	struct ocfs2_extent_block *eb;
>  	struct ocfs2_extent_rec *rec = NULL;
>  
> +	if (le16_to_cpu(el->l_count) !=
> +	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
> +		ret = ocfs2_error(inode->i_sb,
> +				  "Inode %lu has invalid extent list length %u\n",
> +				  inode->i_ino, le16_to_cpu(el->l_count));
> +		goto out;
> +	}
> +
>  	if (el->l_tree_depth) {
>  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
>  				      &eb_bh);

