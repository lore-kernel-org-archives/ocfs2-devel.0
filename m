Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27B881ACA
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751936359; cv=none; b=FiZhvpPRy98tFl7ueGZDXiEgHTQ4QWSBtHmZsz6jHbplciTKXMQOgwBf9MkwQwhpc1n0ZZg28mFoOHrkmtMFQxb6PEa6kt1IZZd7kB14P6iWBBeq3YjqzaKVRK9ju/NB+Q/jx8yMN1CFB8zA6iT8KlDvVvlAvnf03Dr9d2jDJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751936359; c=relaxed/simple;
	bh=pM9dYLWatSwaxucX+LnqjPG6C6W/esF84y9eDra37d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PEeM6I/xX8BgrlgqLubCCz2OpS0iFltvqLjO7r+u1cRypFDCAr0mY4N2w/QsCZQMivTev0GV8V/jDFOO/6tGD3755466ax2T2+RX0/RrMBFuyyafmaflg3c5sMmb8StqeF303UXyuTr0f01sO08Fr5vcdieIzjcKs7wA6uPvrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JvzZx2Mp; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JvzZx2Mp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751936353; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PbspvFHHJE7N1XKNWATpHnYf3TkWrZp08xKIarGIekI=;
	b=JvzZx2MpuKgAmyXKxeZg1JxIsGWhXPtiU8lEX1LQdVCGwnSoK2cNXvXqHEEQsUL6S5dK0z4WahfPfnG/Awb6ykVKRssBRsHyBs28KE1dOCSs23OJvp66346WDCb+7u+SdfwIQXNUxQYfz5cPllBtYHbuJG9IyrXC8HPB3AXLdx4=
Received: from 30.221.128.116(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WiI9CPa_1751936352 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Jul 2025 08:59:12 +0800
Message-ID: <3ac6bcb9-ac73-492c-a9f6-fbfb827c5967@linux.alibaba.com>
Date: Tue, 8 Jul 2025 08:59:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
References: <20250708001009.372263-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250708001009.372263-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/7/8 08:10, Ivan Pravdin wrote:
> When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
> error message that unconditionally dereferences the 'rec' pointer.
> However, if 'rec' is NULL, this leads to a NULL pointer dereference and
> a kernel panic.
> 
> Add an explicit check empty extent list to avoid dereferencing NULL
> 'rec' pointer.
> 
> Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>

Looks fine.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v1 -> v2: Changed 'Closes:' tag to point to the correct bug report.
> v2 -> v3: Added an explicit check for empty extent list before dereferencing 'rec'.
> 
>  fs/ocfs2/dir.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 7799f4d16ce9..acbae902ae3a 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -798,6 +798,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  		}
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) == 0) {
> +		ret = ocfs2_error(inode->i_sb,
> +				  "Inode %lu has empty extent list at depth %u\n",
> +				  inode->i_ino, 
> +				  le16_to_cpu(el->l_tree_depth));
> +		goto out;
> +	}
> +
>  	found = 0;
>  	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>  		rec = &el->l_recs[i];

