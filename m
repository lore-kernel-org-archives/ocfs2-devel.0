Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183AA30DD10
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 05:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763359180; cv=none; b=ub+6TRfGjgHhd7dFzh6G+i8GM95+rWYm6jT7zQ8ptpbSTDFeVzyyo1zsX0f4bBHybxL1kh3z2Gun7KmZx361OwYXRcBg6rD1fAlJ85QGGJvwz36QaswnXfbIRbz1WSw80RRrM+9HYwbdPsMp9eiftCwceVhlNVlfreHPO5OlByw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763359180; c=relaxed/simple;
	bh=LTs1zU58jLEM2UFaSTzZQ52459H3mgoxR4nAunmxg5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQTLK/gf2q1g8EN17hAKk4AhJWOXHJKWZB9gdin1lih+vH1lg3LOYGNHWnZ0llEicDcrRI4H6ZhDmqJ9uVqfKDUM1eZS17t3lyXUmfIQng4k/IMIP9SNNf+OuhXc+1lVSugnmgVCqeEDDmxK3/1Ava3gmSY7lBnZpkhcHh9HDWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G2xXyicE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G2xXyicE"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477985aea2bso1228015e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Nov 2025 21:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763359176; x=1763963976; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4QJ1bXkqCKy8aOs5M0IR425CNUiDKk6Cx+Nd30B4hYo=;
        b=G2xXyicExGFMCDNd+xqZNEALE12aaiLsPYuoPmIn4rzXIQRAFRZ8447+Mcx8pNx2hZ
         ZthrMNgGAS0jT3ctcJAjlwkRg66IG9z90bc5s5o3xrRVbACT5mhp57SxQlcYQQRvdzu5
         Yx+wMy/HxB0RkkxHo/HCDu4ov3gsUCPlyfDkVXCdG+sT4VqQ7S/QTVKvlmTTFEjPBzAo
         9WPY/gl5Rgv4xHeHkQEu5EFHg3VNFbi0KqFjzs90ZOgNUtA6/jf+80youP9uPdX/yF/w
         KhuI+/fdCvrn4mE+XiNfiR5KDH/GBbfLCD6aKSohAYsmIDlbhRo9/9+1Y6MMkynfgDUC
         NpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763359176; x=1763963976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4QJ1bXkqCKy8aOs5M0IR425CNUiDKk6Cx+Nd30B4hYo=;
        b=k1kL0A5X8ry9UJ/LSy+5CCIfpUXk2LEI+OBHDE9gyItm6Z8oXfV8XIkDPf1rB0gf0E
         Wr6mrbUa4S4grV3xZc1ugk0ZJ8j+ioyRCkYZF+ZFoEUVTC9gEa9IgbRlKIZHitvfYzAs
         Biy/6B5o//8qpmXESazPY9ZowlCn26Nh8J6oHsBzdJ33OjaGELhyHL6xLeBP3DOOHW5e
         eufowp8fzXMXzuJLiEn6MyU+b988aoBjTUa+EIJDbDsxGDSnLu64iTNh6ylnd1Qp/OTN
         O5QLdW9RaOrf/atoXY8AG2pUIq1A2qUSFADuY/el7IWBJKnLcYlrSgUFRI26PToOvkZU
         +AcA==
X-Forwarded-Encrypted: i=1; AJvYcCXKdFoZmUrSDO7cWDSCRBGXW0tqceQbM7aY8Vx2U19VrYviAM0LrFmloY6W3yhm58keHA5m9gPK3RvjKA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZFTDaeF05lDy7DX2sB8BAOx7nczHwwXuAtuoT0pZSPQtGgvdh
	3WqKeumI2YKocXOesM59aczv7gAjhYCeb/+rHlEoEWZq/kTVgz4gv+zJqZwEArh4Mk0=
X-Gm-Gg: ASbGncuchaW9d16GWrbNaROtaZ7AwStv8g3v/dAKcFGixaNPyiRudJSu5ALducEmpiR
	LmR8iAChhDJbCP2GRlINdgnCtRaB3IJvvebQRGN9YL1xWmDEzrNvUmeHJmmJwPje5wnI/iL47h1
	3hApaJpJbanUpZIYwlgd6Wg72DiKiwDxGY36GBqr/VDQNWRROs+R9nKzOwMuQ/xvJAJSYSdHQkG
	45esBQ8GO+cQhmtXsk9cPdJ6x+VH77x/ld2juMHU3g53Gp3o2gCVoWL9a81w6yR5uFyGZedIB5I
	cVlbu8t39ijQUUlW+DCzd3wT1FrJn/GBpCAqLRFEYFiVYawWxoSxQd0pusFsIs7liFoKx1KWoJs
	NZkIUNqcU+BiwTJBpZVmLnWN1EHtwoOor9rnpY476ENaOTSqqBA8C3/xGR6lFxKlx1HPvnfHSyI
	rnC4ZJe/Oi0A==
X-Google-Smtp-Source: AGHT+IHz/Y6n6se2uQRG+YrvjNrVhEaaPZ2cSffk0MZTj+pbAhb4UczAD7yUNZy/5A5lLWYaoPXM2A==
X-Received: by 2002:a05:6000:603:b0:42b:2da3:ac30 with SMTP id ffacd0b85a97d-42b5a757c9dmr5184820f8f.2.1763359176396;
        Sun, 16 Nov 2025 21:59:36 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345900a4ff5sm2780671a91.3.2025.11.16.21.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 21:59:35 -0800 (PST)
Date: Mon, 17 Nov 2025 13:59:33 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: validate xattr entry count in
 ocfs2_xattr_list_entries
Message-ID: <undb2iy2lstp7oksnbtkls25ql6un4tbokgp55dfozjwxtfydp@eed726ssveyi>
References: <20251111073831.2027072-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111073831.2027072-1-kartikey406@gmail.com>

On Tue, Nov 11, 2025 at 01:08:31PM +0530, Deepanshu Kartikey wrote:
> Add validation of xattr entry count before accessing entries to prevent
> out-of-bounds array access and use-after-free bugs. A corrupted
> filesystem with an invalid xh_count value can cause the loop to access
> memory beyond the allocated block, potentially reaching freed memory
> pages.
> 
> The validation calculates the maximum number of entries that can fit in
> the available space and rejects counts that exceed this limit. This
> prevents the subsequent loop from accessing invalid memory addresses.
> 
> Without this check, the code directly uses xh_count from disk in array
> indexing operations like &header->xh_entries[i], which can point outside
> the block when xh_count is corrupted, triggering KASAN use-after-free
> detection.
> 
> Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
> Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d70a20d29e3e..2caf63c6206e 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -928,8 +928,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	size_t result = 0;
>  	int i, type, ret;
>  	const char *name;
> +	u16 count;
> +	size_t max_entries;
> +	struct super_block *sb = inode->i_sb;
> +
> +	count = le16_to_cpu(header->xh_count);
> +	max_entries = (sb->s_blocksize - sizeof(struct ocfs2_xattr_header)) /
> +		       sizeof(struct ocfs2_xattr_entry);
>  
> -	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
> +	if (count > max_entries) {
> +		ocfs2_error(sb,
> +			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> +			    count, max_entries,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EUCLEAN;

The meaning of EUCLEAN doesn't align with the code logic; it appears that EFAULT
or ENOMEM would be more appropriate.
The others look good to me.

Thanks,
Heming
> +	}
> +
> +	for (i = 0; i < count; i++) {
>  		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
>  		type = ocfs2_xattr_get_type(entry);
>  		name = (const char *)header +
> -- 
> 2.43.0
> 
> 
