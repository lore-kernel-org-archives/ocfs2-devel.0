Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C0A26F2AF
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Jun 2026 01:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780624191; cv=none; b=EZ/PwlboJ8HwuUMkKy5ebWOAvnncBBKBzEXMzLHnLSKQdJOF+atMrPr38YBOiUxNdyrDU2MvYznIKkG0kfSzMmWFjsEiQKB8GskMAGv7efdY5hDDSdUYthJ3p5qgK+Boc03K1LwgwectoYLD/I7WkX6cp/K8hivAuxqNLyZoFc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780624191; c=relaxed/simple;
	bh=7qIiA2BEQLrumrd5I/Ji34bgtlLLTmlCkcqM4HKHv2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DF63T0x7+d3atLlW9b2XYIvGKZWd3yuvR8GhjNbsGZHnpMjTnrU5fh4p5z+59Gw5hzu/LWS/pYWFWzqDUit/coUawSBjmHX5cIm/2B2QjjReXbvUDlv+YitBm3zg47bhxQ5sLsUvJjbGg00X1zvFzZZ0HYS7HLUCDxN+hSoctoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SpJkeEka; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SpJkeEka"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490a78b0c8fso778925e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Jun 2026 18:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780624184; x=1781228984; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+hm9LRLnIvPsq+7DMFtAuGDRMztKXXKHY+hSaoXZUE=;
        b=SpJkeEkaw4G5C820i5Tcevvw8oHroP0wTqMrHwo9lqXQBbZWHukae4tFhia2pMN/+M
         GTrcDkQ4jfIVucE4XeF6l7uJWgopGerGMoVbfBvft7qbuKdgCG9cXH5fBaUbQNMCF6BT
         rbiFcsL8MxjCIY47Qeu8dMjjOFjw4f5wnqFlB3A78tsJgixu6/PSq7Bx8zri1+Xx3rdc
         u1eB5ZuGPeInx70NoUuBvQNNgkzg/AAJmwC/uuT/H0HPOYhTn4+3UtltJ1Wao2Vc5HIP
         BFzsmla4LR/VVbMwlb+CrWA0eQylMiBpWOmqr6IMmKPN02WQvESFWoRbSZPW1D7AWis0
         l6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780624184; x=1781228984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+hm9LRLnIvPsq+7DMFtAuGDRMztKXXKHY+hSaoXZUE=;
        b=qBIiez1nUpW69Xc/y1bbheCx1kUdYv5fUT2w6ugqs3Jhf1Eh71xHv1VhNHnS2JQ8St
         c3ijZcGUdjP7OQEnHWZ0HjIHqeI8zAliFnUWVZdcd0DCtgeK5S64D5Gq8N3uGW52Gtlc
         qHE3mACi12ER15A3SR3wLowBNHYTG+I4ibDO+XjXIWef2zW8wkISuVFC8WIFROlGaO6O
         suh+rSbUeq0ym+N3LDq5l6ygrTeSByV/gXh8qAszVa+DBki+zjU3bixGAKENMfUuPkg5
         epbJtWhFKh/0JM/OBmGFj+nKxjYtrTy+dvxkZ6UP17qguH2E2Ie7ugIzilmu2GTP75/W
         wl4g==
X-Forwarded-Encrypted: i=1; AFNElJ9QoAmftN3xL20UbK5Bl4qtDQsFXfAueZqtRjzEnknszK1KnbCuq+WS8oafJP6r/JiaZLGjwNHjCfjSRw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx00qV8Q9F/u/08yAsUTBHCPClBvk+K3S4qsbgB1Y0LGyjv4xn5
	C4A74OF+D2tKGuaqcvLxwA0WKfWE3y6ryEirdgY0coJ5opqFXU90HQ0yT6kWT0f53rk=
X-Gm-Gg: Acq92OE6eRocnBdJpDiQwr6n25XMdLdQW7QkUan1fG+x0y5hEaK7rz/RXUJ3ROZDiL8
	Hzwylwfq5Ic6Qx4zONGsRgRd2SGNZI9GNxiGSELfI/BoqKm3PvHGpTsdI3ZxjCU7jR2qo1nCLB9
	QSPeKL/6v7tCFIZ8PoDsvykhWc/bbqu2eTwAxzcySH6uLHRkpqCaNRQ8Lx40OpxbB5LFeE9Slww
	LmopYGN2Tqhp4k7fICO0GjXTSFcVhpf0RUiqKbOmJysmzQwUxjCO8Af9kQogJnvvvCQkERKHBmE
	pNVUpRNU+uVNiYkVbNTsFxLEhMW9W30maQZ/3vyz6eItJ4zbVpqQgOHw4wB2L3HpItctFOY8D79
	2s2Vt1KC+JnyvibJCciuCyrDKuOPScfXk6cQY0TeF4Z5Ji4xb81cyHj6nvUHOLkfhRaKRpIjlmF
	jD+KGCGIKbeLbavUA6AicZl8LP/haXg0GB
X-Received: by 2002:a05:600c:190b:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-490c24f5f07mr6736825e9.0.1780624183996;
        Thu, 04 Jun 2026 18:49:43 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164fa3a5fsm78228945ad.36.2026.06.04.18.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 18:49:43 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:49:40 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: reject orphaned dinodes with non-zero link count
Message-ID: <aiInqlRZmftnaPVX@p15>
References: <20260604115919.536337-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604115919.536337-1-dmantipov@yandex.ru>

On Thu, Jun 04, 2026 at 02:59:19PM +0300, Dmitry Antipov wrote:
> Since non-zero link count for an orphaned inode most likely
> means that on-disk inode data is corrupted, reject such an
> inodes in 'ocfs2_validate_inode_block()'.

IIUC, If a file has hard links, its link count will be greater than 1. If the
file size is extended, this inode will be marked as orphaned, while the link
count remains the same as before.

Thanks,
Heming
> 
> Reported-by: syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> I'm quite sure about Closes: but was unable to test this using syzbot due to
> "FATAL: kernel too old" issues (most likely caused by the kernel vs. glibc
> mismatch) like https://syzkaller.appspot.com/x/log.txt?x=13f51bec580000.
> ---
>  fs/ocfs2/inode.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index a510a0eb1adc..d483e0c61d12 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1477,6 +1477,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
> +	    ocfs2_read_links_count(di)) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: orphaned with %u links\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 ocfs2_read_links_count(di));
> +		goto bail;
> +	}
> +
>  	if (le32_to_cpu(di->i_fs_generation) !=
>  	    OCFS2_SB(sb)->fs_generation) {
>  		rc = ocfs2_error(sb,
> -- 
> 2.54.0
> 
> 
