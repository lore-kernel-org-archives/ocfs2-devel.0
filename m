Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F31189906
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765465581; cv=none; b=Qdz13jEOdS1N0VqBWHhllD1FNlISSY97CsARpgnOnJWD76tpPovX92WgrPVKEY9YmOoP1Ed0DH8A2gHzGJOmTU7hI0YQMCzUMiaeuy2KzFzALcksBhAHL3VgfbW9NmVh8398KWfZl3u526wc3YTQx64HlXYBAHwGsjCkAH/PLgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765465581; c=relaxed/simple;
	bh=1lIQgdzVv70r8VxfU2HSi9gKkzzWK1KoGLBwudAJWsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOqL85I+CtrRTzvGGDKct6lAqLX1BQdq2TOAhCzMSTReAAxq2uo9jh5/MYVhArYzwQf1jWmRwwde8I6rLJfbjIVsASz2OPkvmqtBB5V2fmHe4aWbwuK0pPV8dwzcRNguGQtKlKymD8rMYAHPcXnWhDd/wUkcRgzuQv73qu4YVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=go1pz/B5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="go1pz/B5"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47798f4059fso288455e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 07:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765465576; x=1766070376; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8V1aRrqO+rVrVbh0ixSf2B7/JzMsp/uS65gcBckD96c=;
        b=go1pz/B5X2z9jy4Uh3EtOyQSftLGEifEMSg0msv1eVa++nzCbrNUhHQGcgYaLTqzt8
         n743uJAXS9uyu5ejIG248ZAwnZWGwG4RfKBPTb7F5BGHgIG/ZLb6Ie47eKXjHieAY3uO
         7jyacYx+4Xdp3oVvqqF8Psgn1X5iGoXHK6y5FjLzUfoDRUlkYKtAxAqtfYzDPhTqMcPe
         8dYZJj4HrwE6DS5e47nY5nN8PumdDvw6B3RABwpwWAXOyd7oxrSupO2SPbL4Qz7A/Ugy
         2Yp8Tp0+zT9NgNPQoHY4ugQHknfReSpw+/31zQMQzDYmcPiud1bdYVu+viZi+f67094g
         9QZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765465576; x=1766070376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8V1aRrqO+rVrVbh0ixSf2B7/JzMsp/uS65gcBckD96c=;
        b=hzfD/kL4ZT2DqtxVzyOuX58xm8Tm6jD8Qbw9PzQ5ggtnYWBcqHEN1/PN22+GhFUZIj
         QtU1jfTa6DOfPfDH0hUrOFtTKYDJpLYOqMYYyKUFhsXMnYcWHMGSjtNQ+/Na0saLm6Jd
         FNB3xYD9aOclPPXCQKL1D2pDSd3RmyWclte6inxDOFAoQWOLGXhTWTEzAtoos7ox8I4s
         Pb+dfkg/zVkWEGxd9sd1Io30e42KZIS64mWly/XD6957AIdC7MNSQGRX2qfhOgedVW3K
         HKG2KBRt6QYazbXMOUC5EZ0PGSIQuMa3eJ9KSv5uNU8+WDEVoRZW/joyYIIHIJW32t35
         wL0w==
X-Forwarded-Encrypted: i=1; AJvYcCVmicJWvWOBMUvWlnzI5IQjCLyYkncmO039FtRATQAHIkDR81znOKpAbjrDeXa1pRszLDkIoG2powJAlw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8nPvPTlpeHfOnmH/Eokf1utHTpKDgXqJYCWiN6PApg2LpOyIS
	fv4aJRx4Tuwk796ioAqx0t0SKrQH0BnINMQwWVRuY9tSeTPqag+oB+vAOItAC5p372f1wnYab7W
	+1VBK
X-Gm-Gg: AY/fxX5QX0FWBYFZ1lvG7Pr8nyqispKKhPW35lIPgGKPPr3hCgXn8FqDnxiE1fZde6R
	X2Pn9nMuBQneKt+pb043l3+7MxlxFrGqkf5/wrproR2idTIqyNNyGyt1xtVpXDrltvLck2WTftg
	xP9hioUnT5ClbTbFh39lMBEckINOz/A+YQxwTFCwN0H5Ij8TVr8Gba2uiSD3NOwy08t6NVvnZwK
	C6zDuzv3IVXpww9IYYUmW5oh85tBkJjzS/lZLC5kQ7jMoc9MfF/Nut3nOkG6ZyI6MLOs1Cu5ckf
	5CYzSSkDgcYr36mEb+65rLD3/LEBCcfcHibCcdQ5PnEpkfq6BK0F5aIK3/vY89htVp7T795HApP
	rLIM+DSe1fUTOGDj1xhwia92tu6WAEFzp8C0YTZW0hmKDM/h50RkiMeHAi6wchnPx3Y+n30spvl
	kZN0uI7rvbZQ==
X-Google-Smtp-Source: AGHT+IHvVy3qBMxUoLNW0nAnodQdK76KW4GWx98MlIbF+AA6/22TWO/Y/ev9W/gEm3GWvODhQNa/iQ==
X-Received: by 2002:a05:600c:450e:b0:477:a450:7aa2 with SMTP id 5b1f17b1804b1-47a898d2dbbmr17538065e9.1.1765465576044;
        Thu, 11 Dec 2025 07:06:16 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a92838192sm2205858a91.2.2025.12.11.07.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 07:06:15 -0800 (PST)
Date: Thu, 11 Dec 2025 23:06:12 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: validate inline directory i_size during inode read
Message-ID: <ndx6im5oxwuajgqcj3cagdhh3d5z3uufdahsmlrsxu7tdedqh6@qkgfgxph4ysw>
References: <20251211115231.3560028-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211115231.3560028-1-kartikey406@gmail.com>

On Thu, Dec 11, 2025 at 05:22:31PM +0530, Deepanshu Kartikey wrote:
> When reading an inode from disk, ocfs2_validate_inode_block() performs
> various sanity checks but does not validate the size of inline
> directories. If the filesystem is corrupted, an inline directory's
> i_size can exceed the actual inline data capacity (id_count).
> 
> This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline
> data buffer, triggering a use-after-free when accessing directory
> entries from freed memory.
> 
> In the syzbot report:
>   - i_size was 1099511627576 bytes (~1TB)
>   - Actual inline data capacity (id_count) is typically <256 bytes
>   - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
>   - This triggered a UAF in ocfs2_check_dir_entry()
> 
> Fix by adding a validation check in ocfs2_validate_inode_block() to
> ensure inline directories have i_size <= id_count. This catches the
> corruption early during inode read and prevents all downstream code
> from operating on invalid data.
> 
> Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/inode.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 8340525e5589..9eb364bef5c3 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1521,6 +1520,20 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	if (S_ISDIR(le16_to_cpu(di->i_mode)) &&

The S_ISDIR() looks useless, OCFS2_INLINE_DATA_FL is used for both DIR and
REG.

> +	    (di->i_dyn_features & cpu_to_le16(OCFS2_INLINE_DATA_FL))) {

Above line is enough to handle this case.

> +		struct ocfs2_inline_data *data = &di->id2.i_data;
> +
> +		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: inline directory i_size %llu exceeds id_count %u\n",

Please run "kernel/scripts/checkpatch.pl" on this patch.

Thanks,
Heming
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)le64_to_cpu(di->i_size),
> +					 le16_to_cpu(data->id_count));
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:
> -- 
> 2.43.0
> 
> 
