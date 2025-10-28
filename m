Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899927145F
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664699; cv=none; b=En4aSyQy/NyTypeXaLd/fwBFbo8gP0cL/MtM6qPHIaX4qVzzAjR42v9eTmQhCS3a+JaJlwP+isG/PTBNYN4liigwf0e1rMEB8XeGN40iURPG3GELmRFlGc4uh2r768ofMm230AByRc8RD3qUpEUtRkLsWtUNm++noYLrnfn3+Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664699; c=relaxed/simple;
	bh=PbRp+ajtOg+0xSFPHREHFQRZTUdCmqfyv3R8J3wjGkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMco5pmikjI+tReVS0X6N+TF9hT+bZnJTdGzucYq5Cy5w9/XFfkcEtmbWdm11PLyruAVPXWMTrDmZXelsSyyms+go1ikbiAf/I0RKiO4lPt1pNtyRxFvGwiATVWfM9LmL5KrnUFsva6Vf5AhdXuvxn9p6soK2YkpE4RIae3Knz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DkP8Lkty; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DkP8Lkty"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-470ff9b5820so8101435e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 08:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761664695; x=1762269495; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aCCqFJAi2+9Tsms88mpx76RhkzC4wwnAMBJgZAH1fA=;
        b=DkP8Lktylt/eO66813K9fz5o00Ckd8EUQOOISiTaY3vUd129Jo8paJzXHAThl8ts7+
         jBdMoXxCwyTUV8Aio++cbDJc0MfkXf3q/Jr8bcUw0YTkpPzrlnhWUx+2AENL9mPy0bKt
         gtAaFK/zgHq+2jG2dl/UZ+N3lOUZNgdAR80WHbbELaGh0jqG3eOvkhix+CuWMxcqHbTU
         wa+EaKPgvq86JgZGSXro5vrHw7LN1qASACcKivPc7ofqm/zc3sm0mJ5iFq7qh4SqFP3P
         Nj+P5YVExMgWnjHAvvfnRonV8qOdqEYtkqTCLodKTBtDYBexLWgA7n3DDlGqWUHOCGb/
         gaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761664695; x=1762269495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1aCCqFJAi2+9Tsms88mpx76RhkzC4wwnAMBJgZAH1fA=;
        b=sWL2ojAi7m6Tat0HjWbP/dAIjsrl4e5WavOHwapl+oS6GtKr5aBOdDs19W/5ZQA9NE
         VZAgDxdVBdtlwXS7PTnjsiywMoqR24U5XMxLie9xLwRuH0Jfpnyp15shNb6D+opdkqpc
         Kj2oAz75PnGNZ367Mp2hEHh3BnJaf6QklF98xW7Qrr2c8QppkRbjDisDsJKTE8H2CW5e
         Zr08OdL+tXDIrAty34jhSpioFdu/YMCZDtymaxlGKO34gyKmvhxu3hre16CQ4Fl48/qp
         JI/SmRoKoiVzaio4pZvLWIh3d1592ouqvAssbo3Hb53ErY/bLLDiGKWJ6DcDs9JbIK3K
         l2RA==
X-Forwarded-Encrypted: i=1; AJvYcCVUzOdHAGbTi8M6Hl7XiaP0cGYP7QC0qOploY9b2yCjQuNpGFRYLK6zGCw1a2PqQD4YaTalTbS6HA6etg==@lists.linux.dev
X-Gm-Message-State: AOJu0YysahXWYm+jGWK9OEh1RoEatJpCaOanqchNDdCESigHy0ASWaKm
	k+ffZ5qQ0LupP8y0oDZCLGL8Siq019d91F6sSTK8GMcWOC4vDLOxGA+ulzdFrNZltK0=
X-Gm-Gg: ASbGncuaVhrVcnTFRO5OvYmFdSVJvI9+h7mxJ7eT51cHkeZ4z/hjOlFWjT6SYqplxLV
	A1pvRie0btInEoZ3zgeVXbNYuMnHdFjGszt+eSs7te7YeSzHA2HJOSZHR2piD0Gkbnp8LOwO4Tn
	84o4iAGRoWQ7Dn9iGgcfOQ002RcwfDaBCGwW6T7kV+cIfjeqIvFsYjXyGN/Gv0xVEjwl8Fyu6jK
	hwfDzwsVEk/tJv4ls3aYfCCdkR+wAUOlj4qvEteTzThLyJ8KYdAwVjelHcJICoz0lnSDFeKGM4V
	pewYT2l4uMNjM6AynbZWDP0LBn03MoHjH4MHo5fxW77TpxL6vv2EGq+M/e3OwT+yj7H5ibMkv6c
	PAUwmvE9frIHyV9stMUObMYctFV21hakvyOlCE1l74vu7E0s/oObkfpXRNDo4JsSV+jT2zNUQvY
	r8/sCJTh6Fnw==
X-Google-Smtp-Source: AGHT+IGHC+5q3jONyLVpxr/LPe1IU8xxVo2vnazBFL5gdLj4RwP+IOpO7Ejjlwux8bliJlgClGLqsw==
X-Received: by 2002:a05:600c:1987:b0:471:703:c206 with SMTP id 5b1f17b1804b1-47717e6c391mr18222615e9.5.1761664695355;
        Tue, 28 Oct 2025 08:18:15 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a4140a0d47sm11869358b3a.73.2025.10.28.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 08:18:13 -0700 (PDT)
Date: Tue, 28 Oct 2025 23:18:10 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com, syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: add extra consistency checks for chain allocator
 dinodes
Message-ID: <7dtojt66rmztmpj4sc7y5jlpewccdic7hcsrinz5bzoipod4f2@m4huov4utr7n>
References: <20251028101447.693289-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028101447.693289-1-dmantipov@yandex.ru>

On Tue, Oct 28, 2025 at 01:14:47PM +0300, Dmitry Antipov wrote:
> When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
> add an extra checks whether a) the maximum amount of chain records in
> 'struct ocfs2_chain_list' matches the value calculated based on the
> filesystem block size, and b) the next free slot index is within the
> valid range.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> note: this is going to replace "ocfs2: introduce chain list sanity check
>       with ocfs2_check_chain_list()" because it looks more consistent and
>       allows to filter out damaged/inconsistent dinodes earlier (immediately
>       after being read).
> ---
>  fs/ocfs2/inode.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..1b6bdd9d7755 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1503,6 +1503,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
> +		struct ocfs2_chain_list *cl = &di->id2.i_chain;
> +
> +		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
> +			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(cl->cl_count));
> +			goto bail;
> +		}
> +		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
> +			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(cl->cl_next_free_rec));
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:
> -- 
> 2.51.0
> 
