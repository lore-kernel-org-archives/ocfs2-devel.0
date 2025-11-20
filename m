Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE0D18FDAF
	for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 02:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763605973; cv=none; b=HLnkBNKSICip4ox6QYpluhH+bWn5IDssnW2q8BDWI6uN2/Ka6ifQFORTCCYwUTCMErnHtD6E/77JIuMi+B6rGSPcPWwS4TiVOpe7WMaQcuMk7HZ3Z3PC+3htn4kSFrhDOsGDje7pnhXgkQr20fbi2tmsbUFIqGCLt3XoSO9xaRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763605973; c=relaxed/simple;
	bh=NcGYGf473BRN/1TmB+krKsFVy0UVrO4c6EcgS9/oqec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PU23tszz5d1J7G8YxTHVyUXxoysxu2ysOeuf99+xm/iwolLQWNUokIrbOMzhN+kjTwHMjDrkq6R3xIPWJuEUVtJ/3t2fgrOmMYIkCfQdpUy5PIYWS3Fz4Ntg27NxbswACFfk1AvrwoB6XZUsB+snMD5SzyG9SaTwpP1A1WtvJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P4uQGQcS; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P4uQGQcS"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429c844066fso58329f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 18:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763605967; x=1764210767; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6OEllOICfOmnYghpQDm15WzVjiy1iyiVGB4iZU8wXg=;
        b=P4uQGQcSio40Omxk0r5LoJvltlw2mRhdOcbXT8bhPLrnj1E9Y98HWwuIn/WNQZsA9d
         FfXoRoSl4km3U+hfK4kQAiOVATVToUsKAckr170vdor/p8NzYkp+exYLV/8hkJht1nUJ
         azAtvbgAaoRsAnZhinNzGK9agO4EcMtUmWVSoQ2jVTOIvpWk3+EyRcyR8NpVHOKVOi2z
         PpdnEstPnH7RC6s/8fztID/Ocxzb3hZSElkwO2aJ4ltkosEmBOQpOXyeCc1pcL3siIQz
         PppwDpwbUpC+l/7cCMTxk/7aq8M8PxZckdGb9Pgm7j6JR/FG4rhXiLZZVMNTqewjocbA
         BONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763605967; x=1764210767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6OEllOICfOmnYghpQDm15WzVjiy1iyiVGB4iZU8wXg=;
        b=DhPwUvQuCc8xWm6+O5SbAnUTflKpX5cNi6dONXPMn7Tu5qLGQBP8ytJvGO7Dnho5NU
         4PKGl5JKjkCwZErXuQIjd8G2FBDQxjqiEZ3ZS8y2f3OKB5CfEsuIsWyJCNcGdJThO1I6
         mIQptzjXaBwxiBmvbNjGlsFKtg0Y4s55WGo8yhl2j0r/4lj3G1+jDWdMjihMQlYmdgym
         c/so+nEmnUoYyjH3/H4P8KLG1EAaTqxTuAozIGei6vZVyDLeN6z659mjzfIR+3QTAVgN
         /BD85QO5Z5jsupNLT5O+6+KqDTnPTwhQU/yQUjvUxyYrYS5gXzINjPfKWJC0l6JZX1H2
         3fRw==
X-Forwarded-Encrypted: i=1; AJvYcCUkuUtY6J0DmbqSPL5ZCV9PYCKgCZfFNTKT7E8/gAPRJIeKgRe+DlbfuGNlXyE8l4UgVe7wcmRjZTlhVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxVu8MkT1T5VKA1khj3MTUIIQxn5p+KHFB0ZWfv5wVs+uDnibSg
	N77zKJvylqnErLY+uwlTxT8MxXHopiznUim4thPt/F1jakl9zcvmIVW9syUbGU0KS94=
X-Gm-Gg: ASbGncvqHwAOCN3HENxMRUnJpm5+LYl1wxSLDjHTXbdQY1FRqZuyRTGLC6PvMv/9Fro
	JSO1mfoFBETC4TFSOVYzEa9lOEr3XzoDaRS9pcbOo8diE0j3y6r9cYgB+E0GN1t5wPsd28Vo7sW
	M0sAOAvDAz8G9DYSPaAVAcpvv1ZYT3DHUajFPWnTNgJv1+W7l8VnssGrTDWTlKNzhO/N/y7M3NM
	+E+bZX6QhdbdyRQFkOQ8SD41zu8jAzr63zS2oXLUDSA/FQQxuuOoeKY6NUWC3AX+sKHrhrb8uQD
	8oMQF47fkpuXEsWUlTxvknk2hqB33IDD454QNT37Oq4ncqoEA002dhfzI2FtzZJf5TB6txdwXB6
	9UDMgeU2PH+j2rgkNyu3UlLgGYIE7A8fzpCRL0zLN1O/NeceTKSfuQ6J5i0kfbtnOzXb+Tb8iwi
	ripVLVBkvSnA==
X-Google-Smtp-Source: AGHT+IGeBiop61w5CeaXZi68jDSh7W1Kf+OhzjFh1OhAQG6HrI5Gn2pJO011Nff3UpuTYK8oTb2uWA==
X-Received: by 2002:a05:600c:4506:b0:477:9a4d:b92d with SMTP id 5b1f17b1804b1-477b8c91d91mr6174255e9.5.1763605967042;
        Wed, 19 Nov 2025 18:32:47 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b25e321sm8114625ad.50.2025.11.19.18.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 18:32:46 -0800 (PST)
Date: Thu, 20 Nov 2025 10:32:43 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251119221723.171746-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119221723.171746-2-eraykrdg1@gmail.com>

On Thu, Nov 20, 2025 at 01:17:24AM +0300, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
> v2:
>  - Only checking either i_links_count == 0 or i_mode == 0
>  - Not performing le16_to_cpu() anymore
>  - Tested with ocfs2-test
> ---
> v3:
>  - Add checking both high and low bits of i_links_count
> ---
>  fs/ocfs2/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..c8b129db756e 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (!ocfs2_read_links_count(di) || !di->i_mode) {

the code logic looks good to me, but I prefer the following code to save a few
cpu cycles.

```
/* only check if the "link count" or i_mode is ZERO */
if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode)
```

@Joseph
which do you like?

- Heming
> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink=0 or mode=0,) detected!\n",
> +		        (unsigned long long)bh->b_blocknr);
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */
> -- 
> 2.43.0
> 
> 
