Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B4325735
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761894670; cv=none; b=d29AqgY1IJK6TnnOv9JPrJbsYg2kn+S5BZAaJFYDJUl03LEp//5bJk5+qFPURWbwvn/IY4HpYKhjhEceSQMISM5P9rYFX4Q2B+z+THqZti1YJWMBr/b7+uPTfcGYY4aJi+BA4QgJAkw85uzOL5OraG2SDAo3pum0QnuTqXY7jEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761894670; c=relaxed/simple;
	bh=kn5IlNskVWiWEIxTKucMN0laetjolyyoeeDjidy5ioA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klK4ANaMP8uGct8dOXCghKpIZRN9vgFuW3r+76+sorEvUHbSu2dAi2ZnptaAhjiKTQQll8Gi4UdBE6TD9sTegllqg10qhNEjSVJiI3NHgUd85TezVAKGyH3PGCSDxPtSdWC/Ht7OKsLRqtQ0h6T6EVYiC2ID8VE4BbM1FTm9kuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bKEfSkC7; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bKEfSkC7"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4285645fdfbso254994f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 00:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761894663; x=1762499463; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8osoMKeQmvxx6gG177xOJBtkaCzMSiR723YzVsYSSQ=;
        b=bKEfSkC7jLH2G7muDiMqAWXqRGhNiItUIgVa3xkzvSbhU6K3QWfIAYMDx9vOWiDrS7
         ir2Rv92eZvbbln9BH78OHL4ztw+SBH3Yfag3ozsbG/PzfzlrythZ+psykIBb77T/E9L0
         lXsbarn+wTK4HO9/7UBJK7vzoaA7+ao0k/Ta3p1LUoOPG3DOfSKlVNQ0w0IuyXtEotqq
         12Ibh53mhfrCZcaLrc/FVs6Vn08e/AWFlXYsXLmM2qx5DiW3nTxUPvxzYRrXtYR4/XDA
         Y2j6bVDE5B0EgxgQAV+Q2YPYyGqdLPmI8bfqrukfwktEhONnwR+ovHDZ6K9fcCXzzKKn
         fv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761894663; x=1762499463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8osoMKeQmvxx6gG177xOJBtkaCzMSiR723YzVsYSSQ=;
        b=ntq/qy+YTdFQs9IEbwyht5JM/zrtPEPdYHODu7zsYKtChEcaDHGfN7GyYJUqVN1UxK
         H3g+Z7iWOR9hX4kFqhaMWuvIXppf1eqvDtTpyrllJCF49aKRqDhDd3R847npw6m+Sew5
         X4/0rcsY6VdGTJG7SMvTMuqi02udHB5UXt8KSFqdlJMVu5077yoT+Az+uKSAQVUmW7rz
         DThfgWqdTsEm3+SbloNxuxv2sPsWvvYqSbqKd3iDJs9zcQbeS63iLAAHWtDCxXYRQeBT
         sQif2sfl4fQmhOYFZWqjb5/l3hQTe1QLo4Hkta+8a6Wl99+NqYp+0fS5Idd3NpceuBeJ
         5U5g==
X-Forwarded-Encrypted: i=1; AJvYcCV06fmanq3cfswOtMG9kyNMQwevhy6lIuQyY7+UhZO2XSoZvqpsAJdD/5px8tUsYrqcOZflYTk15opoGQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1nrH9r1kCZWU+rc5hssJ3gRPfR/OrS4zTWa2rcyVtfCm8nqvq
	xKEoNsZwkVBXm9IFZEAwN+WFG/XXMAQizMUVm5NlxRZOuKk2YQsg8Ev/SCLN/r04MC5jbyVH61n
	V299p
X-Gm-Gg: ASbGncuqMuoci1tdmluUgBIM84fmpH2Hrx/S3ki6GmstaW/pNokpdqbQ0c/WSGcR6pe
	+RIR4TrBGN8eol4T5vn0eaMNVDQP4fo2vmE3MqqF73xsl6lq/CzhZvt1t/O0N6zcuzKIfs8Yiev
	rkf/WPnJgla/rL8uWz9EdF6v6WHF7vtFCkQ7+No3Pmwd23VIuRvory6KlfI/4XBMjVdyZdCN+Ag
	COX/M1Sq614GoN5yGXWQ5kXsTg/lnD5c9s5Mn3Xx8qv0jSfRycYJl8WAH2ZB569cG0dLCNpVrfY
	cColBp7oFlNo1SjQSyNIvl/59Q2nDChoUFok6bAt4vFCSC1m7l3LpyP9LzE+ejeWF7U+GG6QFMs
	sSWVzi7if7BZ0wkLPbyIYHGJ6lIVpm8vUkw1+HaRsxOtbc+I1VQjIZzoOxK7RAQz52sONZHaPF9
	ErVgfBGRYLibrWLR1FMAgF
X-Google-Smtp-Source: AGHT+IH/ggqC2kFzF5qNk5oWgmUdprKKn0CIGlZ1KxCeItmWJR8Y3WxA5x1dXDm+hMEnFGS0dEf7YQ==
X-Received: by 2002:a05:600c:468e:b0:46f:ab96:58e9 with SMTP id 5b1f17b1804b1-477302d3684mr10577625e9.0.1761894663096;
        Fri, 31 Oct 2025 00:11:03 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db678f67sm1058382b3a.57.2025.10.31.00.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 00:11:02 -0700 (PDT)
Date: Fri, 31 Oct 2025 15:10:59 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <2wxmaoytqyztwxjmeiq5427o572passabvpfndj77rywsrrc6g@5uoztrgzqnor>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029225748.11361-2-eraykrdg1@gmail.com>

On Thu, Oct 30, 2025 at 01:57:49AM +0300, Ahmet Eray Karadag wrote:
> Potentially triggered by sequences like buffered writes followed by
> open(O_DIRECT), can result in an invalid on-disk inode block 
> (e.g., bad signature). OCFS2 detects this corruption when reading the
> inode block via ocfs2_validate_inode_block(), logs "Invalid dinode",
> and often switches the filesystem to read-only mode.
> 
> Currently, the function reading the inode block (ocfs2_read_inode_block_full())
> fails to call make_bad_inode() upon detecting the validation error.
> Because the in-memory inode is not marked bad, subsequent operations
> (like ftruncate) proceed erroneously. They eventually reach code
> (e.g., ocfs2_truncate_file()) that compares the inconsistent
> in-memory size (38639) against the invalid/stale on-disk size (0), leading
> to kernel crashes via BUG_ON.
> 
> Fix this by calling make_bad_inode(inode) within the error handling path of
> ocfs2_read_inode_block_full() immediately after a block read or validation
> error occurs. This ensures VFS is properly notified about the
> corrupt inode at the point of detection. Marking the inode bad  allows VFS
> to correctly fail subsequent operations targeting this inode early,
> preventing kernel panics caused by operating on known inconsistent inode states.
> 
> [RFC]: While this patch prevents the kernel crash triggered by the reproducer,
> feedback is requested on whether ocfs2_read_inode_block_full() is the most
> appropriate layer to call make_bad_inode(). Should this check perhaps reside
> within the caller or should the error propagation be handled differently?:
> Input on the best practice for handling this specific VFS inconsistency
> within OCFS2 would be appreciated.
> 
> Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>

LGTM.
There are some review comments in this mail thread; anyone who is interested
in them can check them:
https://lore.kernel.org/all/20251029225748.11361-2-eraykrdg1@gmail.com/T/

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..415ad29ec758 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
>  	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
>  			       1, &tmp, flags, ocfs2_validate_inode_block);
>  
> +	if (rc < 0)
> +		make_bad_inode(inode);
>  	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
>  	if (!rc && !*bh)
>  		*bh = tmp;
> -- 
> 2.43.0
> 
> 
