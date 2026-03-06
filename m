Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1222D8768
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Mar 2026 05:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772774598; cv=none; b=sqZ2f6zqz0dvg8M5tZtMbzwW/3fyiXeaJqSDSNnBHfSxv0rb4ifn3Jr3nlTXx+uCVTyh11/0pyanb/pp2dP/7bFdDL3Bj71S9VqhlDYWDrlZKXEgf8pvvR022NjsocbxgMdBz9CYMjuEqGvo3W7YVVbmhDrUDuxzznuhGQ6n3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772774598; c=relaxed/simple;
	bh=0/KThnl/b/JffKbtiK7L53WzW5yzt/WB9FCuGrbTKL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mgyj0NWNWmofXbrb8qMDjJPMgEYTFeUxHX8sFIEzhCgKYn13V9TD4v6YjgTu278PXSUTk44Xx4BEcMEiSVmzykS+f+c1yooGJB6N+qWuqZWF2lnQaBSzCqkHdnm+Lgm42muRjgkdq4sTEe6ebZ+AdYYkmoJdOugMgofpWuXBy4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gG9ARhRv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gG9ARhRv"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso7667245e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 05 Mar 2026 21:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772774596; x=1773379396; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k5bOpCYLfMdTsia90R8Ah3sajiCTKQW98lNuE4Egx58=;
        b=gG9ARhRvy66Nyxj994Nm7RhymG1Gi6hxtKrhOnTXVCVy2p4Ai/kNpVNgUvWy+U6G92
         T4EL/daoZxGA7jqoyv6WM+ebW68KxlI/fx9YJyjSPQdw5+eRyaAVjOd7C+MatkdcCkJ6
         ZwmvCp2R2eoiKhCzIPo1Em4ZdP6twNxTTVQjuQt9BYQvsVfrPrn7PFLnm0cgR9Hi9Y3M
         40xgdPBn3qNr1sA6A88PJABx7EkGlF7PMMYtzBcn07RG0br78HXlIg444iQyP8GIHqr+
         tnigWiQvfKgnWkVm3j+qcgoAdMhgUKSXWZHkN/KpMfn/1YMLQZ9Cg135n/AuaWf8m3Z6
         yi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772774596; x=1773379396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5bOpCYLfMdTsia90R8Ah3sajiCTKQW98lNuE4Egx58=;
        b=muOapU6hyvjAiOeECgFL3zZUUA8jlvzEMWUfGc8Nryhw4mX0Tvwwcf+ucvwGCAK5TP
         dOd/DtAz0O1vAL1cBeNR/eV8RvRvBdcvhHvFdOQlXOnjMxehwBsbjNf4KE9yNnMbELq/
         nSo9Zu9KUQ3RsSgp0XmJxeoY67ImHAzQB27999Ul84jk3u6rvc/T/5b7HorOEzmPrMz8
         hCUpzTCWQfhSko6PeXbc9b1MKfnqM46Z3771zSLqd9ytqS2Ef3y+703nR+s76CgP0sMw
         Toy122aCB+oraGarzA6LPbe+Pk0/LCwPpU04bsebhI1G1sdnml3EJmT4tshmm76hl+Lu
         36WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVarioP6qB2wcksWlPOE24ZWXDYEIbk7ah+2xIcqriIybl64tOTTnKVyPLmqW+/3L10/cs3fk/fCkgGWg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyM2KOBuLSbplqp7xmpSo5/Ib3w0nobjTKShkOTpOLStDrFxJ49
	/GDpnep0Bp28yAU0de4NcSHzswpD6pNOsyOF750JA6mjBihOgr1YACZdIE6/aJW0oY119TladH0
	Og6tX
X-Gm-Gg: ATEYQzyQURSTfpII4HPsM7t1wMdQDhYX2N+RL/v4IImtj76SrfcQzZS/BZ1OgMwoQ9J
	ZAVMLBwosR/znOCHKks344OUV/fU/2u64C6/TVzzsMTOBWb2C7Rc9qTetdG6yeZdGkfR5IwDf1x
	Uiy0IUWI01i46pfcB8tEY/L89hJZvrZNJlyvbzq5ekKbMRlOlFzpRZwZwaF6DAImpEftsfw2kT0
	e/Y/BX9oiDhywIaAewEYcy+N3V2iDURjkgO2Fr0/DH0WXlSWzBl2cUyN70s6iNJ0Xrn18uq7cut
	cIBQNOVToejT3SgfrCoBgu/ZwUTgi78UB8Gr2yP9wD4kcAXFrpqhN7cfen3esWarnoeiGBY3Dqm
	sl+2WqL3s1YobWOq9lxK4sEGRAnHe6ZLidahmI3igzdgDo3TxneO3oOCJJIpPSAXOdS7uxzxF6o
	ITrtkCtrwyPKDZbh+WV+XHpA==
X-Received: by 2002:a05:600c:3b17:b0:47d:6f12:de57 with SMTP id 5b1f17b1804b1-4852695884cmr6061345e9.4.1772774595801;
        Thu, 05 Mar 2026 21:23:15 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e57af3sm6838485ad.13.2026.03.05.21.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 21:23:14 -0800 (PST)
Date: Fri, 6 Mar 2026 13:23:11 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix possible deadlock between unlink and
 dio_end_io_write
Message-ID: <46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz>
References: <20260306032211.1016452-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306032211.1016452-1-joseph.qi@linux.alibaba.com>

On Fri, Mar 06, 2026 at 11:22:11AM +0800, Joseph Qi wrote:
> ocfs2_unlink takes orphan dir inode_lock first and then ip_alloc_sem,
> while in ocfs2_dio_end_io_write, it acquires these locks in reverse
> order. This creates an ABBA lock ordering violation on lock classes
> ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] and
> ocfs2_file_ip_alloc_sem_key.
> 
> Lock Chain #0 (orphan dir inode_lock -> ip_alloc_sem):
> ocfs2_unlink
>   ocfs2_prepare_orphan_dir
>     ocfs2_lookup_lock_orphan_dir
>       inode_lock(orphan_dir_inode) <- lock A
>     __ocfs2_prepare_orphan_dir
>       ocfs2_prepare_dir_for_insert
>         ocfs2_extend_dir
> 	  ocfs2_expand_inline_dir
> 	    down_write(&oi->ip_alloc_sem) <- Lock B
> 
> Lock Chain #1 (ip_alloc_sem -> orphan dir inode_lock):
> ocfs2_dio_end_io_write
>   down_write(&oi->ip_alloc_sem) <- Lock B
>   ocfs2_del_inode_from_orphan()
>     inode_lock(orphan_dir_inode) <- Lock A
> 
> Deadlock Scenario:
>   CPU0 (unlink)                     CPU1 (dio_end_io_write)
>   ------                            ------
>   inode_lock(orphan_dir_inode)
>                                     down_write(ip_alloc_sem)
>   down_write(ip_alloc_sem)
>                                     inode_lock(orphan_dir_inode)
> 
> Since ip_alloc_sem is to protect allocation changes, which is unrelated
> with operations in ocfs2_del_inode_from_orphan. So move
> ocfs2_del_inode_from_orphan out of ip_alloc_sem to fix the deadlock.
> 
> Reported-by: syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=67b90111784a3eac8c04
> Fixes: a86a72a4a4e0 ("ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

btw, I have a question below that is unrelated to this bug.
> ---
>  fs/ocfs2/aops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 17ba79f443ee..09146b43d1f0 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2294,8 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  		goto out;
>  	}
>  
> -	down_write(&oi->ip_alloc_sem);
> -
>  	/* Delete orphan before acquire i_rwsem. */

The comment above looks wired. From commit a86a72a4a4e0, the correct one seems:
/* Delete orphan without acquiring i_rwsem. */

Heming
>  	if (dwc->dw_orphaned) {
>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> @@ -2308,6 +2306,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  			mlog_errno(ret);
>  	}
>  
> +	down_write(&oi->ip_alloc_sem);
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  
>  	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> -- 
> 2.39.3
> 
