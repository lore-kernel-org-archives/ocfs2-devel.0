Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B379F7464
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751933575; cv=none; b=QE1zLWKSlE3tAu2JOW/eRUinvUc4odv9A70iLcUWrHRQ+DxLXNWrk6t5z2n4Uh45QyuPL2gd/Z0P+E25+jtnNr01271kKK/JlckYteI5ttZbJS14m9GxGxTGumxxHKde00y9YM50JI4Tkdp4QxGYf5s5j/mVIHqxPQmHY+nKJTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751933575; c=relaxed/simple;
	bh=Cg4tCmXPkkrOzlKioCxtCYjIxNt95LxUF88Gb+F6is8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVac13hst/pdY1l1kBbxDWKjlGsDtwxitYnOpWjXJrKl0KfluWc8vG8L0yA94P4l7jxjauNSf14NTL9goQEJ6RrPBDDaLrBVCe5d40CNkTWpWxEQLgXQeYV19r5Sdk0vLtPHgw6u8DVp99e4WosP4kJ+HBbGNbIBDJvAsTClFm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cegliNsN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cegliNsN"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235ef62066eso59517005ad.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Jul 2025 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751933573; x=1752538373; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JlDwzugOo/DKjpqS8sAMSEvnbA//RO2aaxdwNuyUoE8=;
        b=cegliNsNJOp9jl8gI+PTvfILvzFx+2CTUAm70ar3e1UOxDoAM3BasYxCdy4tCfJzvl
         YPRaqy4onqi4wCxqi+KZeF0ZKu8GBilv7+Wn+BLTr8AJLZZhqNi64UZDbj0QqDlm5WJ8
         tVad5EPAFg8D5XZ91ETIHDUjnz2p60Qt07Rz+6bM1CFKqRsBvwkk1tFnnbK7gKGjoh/G
         goEDJ0k9OSXug1b/Dt4x6Bd79DhU8kNyDvkEBjMCATu4kM9M6ucB9TR2JSy32SLG57/e
         BebLdCVcioxBZm5+0KUh/zhKljleHMBSvTp89lR0ts0Xq58uhaJ5JwHoI2T1Nqi6ywCq
         fAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751933573; x=1752538373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JlDwzugOo/DKjpqS8sAMSEvnbA//RO2aaxdwNuyUoE8=;
        b=tXiGvR9XY+Gq4xR0zBkwTQXELybWPC20eRsvxJmISmGw5x2bMEVPsDAUjeCVXwwN6v
         Sjo8AgCYI6Dv5coYfhYx4id3J5eU7JGBqkDSl5O6LMdHJsVC+FcS3bfd2mK1lbW3nIUx
         ksRgNJRZ47OiCegZS+zIuXS9kiatVUidNUrbeIeSkv0BVNY2i6p7tAXYEieNuVBfsI3P
         5DxUI0owuNDAzQhl5LHLf2jAvTl8M7qXK7Gfg+fNXQlh8qY8wzS6cZnPlVUlR7rajiuF
         uafT85/w+CIzFfmp82r3bKqrSBnYwy+urL8dbXy6F2O3HauzIcEXCQrcff8ZRwDZeVFs
         3hqw==
X-Forwarded-Encrypted: i=1; AJvYcCU8oazCJf7TTOkArgiX5D6KkB4YN37S5BLmgjyCuLRNj+5FJy0UeDyhKHUWDgZ1CAvVyws7mPmiYb0fvA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzoay2GE4j2ivXCsbISj4HiNTdz2tCkeltOOifoo/Ff0ZypaVd8
	cHmMnWGDZWsEB/uNjveOuPp6HMWDUde66FGleEFTpv3NtUZY3Zbad6IK
X-Gm-Gg: ASbGncux3T9QS0ufxTN2MHd92QEY+Si33wcvxmr1P8LZyEVdzE8zEIMHSRwcXHGpakA
	p4083emm3hZokD+QEQc+9xgnLQEihYnlJiro+lLvh+01e2r51jg8beNUbYmAF+WPDt3h6bzTts3
	S6cGK0mdzL6n9Ci06ubWUNh0V1r6ak/b0N4qu+dVt1ZFEXodSoCxr5X4/8OKmRInDNdjjl7E23a
	J3gB1GiXUJz872z0uEH0/vpP1YENRGTiKP2f/sxtURSbem07924tCuCHexi3PgJG5Iwy0mxkKpb
	XkDTtcjR/WSmlLJ3N+dVaeNqVZuyOuxCSDXt1+GyafYiGnE4KMwuJNdt4jpdGf1zxavpKPflHYk
	QNHWPgl8kBQhZ
X-Google-Smtp-Source: AGHT+IGlPYMAjX8N776SnDST+Z1sse3S9TOfo1i7zhuj4vhzwygHl5zuojjfRSeH5rNOjJDfITTiyg==
X-Received: by 2002:a17:903:4b2d:b0:238:f2a:8893 with SMTP id d9443c01a7336-23dd1d5dcb4mr8076965ad.42.1751933572939;
        Mon, 07 Jul 2025 17:12:52 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55 ([2601:646:a000:5fc0:268b:48b1:88cf:6e90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c845810a5sm101956885ad.180.2025.07.07.17.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 17:12:52 -0700 (PDT)
Date: Mon, 7 Jul 2025 20:12:49 -0400
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com, 
	jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ocfs2: avoid potential ABBA deadlock by reordering
 tl_inode lock
Message-ID: <kxo27vjuqawoynwttpg56tzhvxeuobmvgdfglp5g2xcuy4vfnq@t7t4zxq27qon>
References: <20250707032951.361331-1-ipravdin.official@gmail.com>
 <11999e4c-b0ef-4718-8e93-75363729515a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11999e4c-b0ef-4718-8e93-75363729515a@linux.alibaba.com>

On Mon, Jul 07, 2025 at 01:58:35PM GMT, Joseph Qi wrote:
> >  	/*
> >  	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
> >  	 * logic, while we still need to lock the global_bitmap.
> > @@ -637,13 +639,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
> >  		goto out_unlock_gb_mutex;
> >  	}
> >
> 
> You've missed unlock tl_inode when ocfs2_get_system_file_inode() fails.

I will add it, thanks.

> 
>   
> > -	inode_lock(tl_inode);
> > -
> >  	handle = ocfs2_start_trans(osb, credits);
> >  	if (IS_ERR(handle)) {
> >  		ret = PTR_ERR(handle);
> >  		mlog_errno(ret);
> > -		goto out_unlock_tl_inode;
> > +		goto out_unlock_gb_inode;
> >  	}
> >  
> >  	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
> > @@ -704,12 +704,13 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
> >  	ocfs2_commit_trans(osb, handle);
> >  	brelse(gd_bh);
> >  
> > -out_unlock_tl_inode:
> > -	inode_unlock(tl_inode);
> > -
> > +out_unlock_gb_inode:
> >  	ocfs2_inode_unlock(gb_inode, 1);
> > +
> >  out_unlock_gb_mutex:
> 
> inode lock has changed to rw_semaphore, so 'mutex' is no longer proper. 
> 
> >  	inode_unlock(gb_inode);
> > +
> > +	inode_unlock(tl_inode);
> >  	brelse(gb_bh);
> >  	iput(gb_inode);
> >  
> 
> How about the following alternative:
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 369c7d27befd..d56c337204f6 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -611,6 +611,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out;
>  	}
>  
> +	inode_lock(tl_inode);
> +
>  	/*
>  	 * need to count 2 extra credits for global_bitmap inode and
>  	 * group descriptor.
> @@ -626,7 +628,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	if (!gb_inode) {
>  		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
>  		ret = -EIO;
> -		goto out;
> +		goto out_unlock_tl_inode;
>  	}
>  
>  	inode_lock(gb_inode);
> @@ -634,16 +636,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto out_unlock_gb_mutex;
> +		goto out_unlock_gb_inode;
>  	}
>  
> -	inode_lock(tl_inode);
> -
>  	handle = ocfs2_start_trans(osb, credits);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
> -		goto out_unlock_tl_inode;
> +		goto out_unlock;
>  	}
>  
>  	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
> @@ -703,16 +703,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  out_commit:
>  	ocfs2_commit_trans(osb, handle);
>  	brelse(gd_bh);
> -
> -out_unlock_tl_inode:
> -	inode_unlock(tl_inode);
> -
> +out_unlock:
>  	ocfs2_inode_unlock(gb_inode, 1);
> -out_unlock_gb_mutex:
> +out_unlock_gb_inode:
>  	inode_unlock(gb_inode);
>  	brelse(gb_bh);
>  	iput(gb_inode);
> -
> +out_unlock_tl_inode:
> +	inode_unlock(tl_inode);
>  out:
>  	if (context->meta_ac) {
>  		ocfs2_free_alloc_context(context->meta_ac);
> 
> 

This is definitely better. I will update the patch, thank you.

	Ivan Pravdin
