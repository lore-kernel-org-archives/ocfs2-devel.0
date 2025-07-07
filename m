Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C3D165F1A
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Jul 2025 03:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751857869; cv=none; b=SXCSqvRnqLUHJRHsjWZLL2/TAnZjVT3h4pLXu3q/RM3DfgugZ0vAHR0SieZ2LmsbNe0iU6W3rW94eSpd4pbkQZfVwDcV5fdQQS7AtNhm+WiVpVxjJXywD+2QBLGSjukuVTywX7+8+IK7GrPSwZXhz1/7Vf33Pxf6ytIh0W6cWtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751857869; c=relaxed/simple;
	bh=xwz1l/H5UXZjQk3J+hYZITziwIvJlL/zfAu2kp+YoiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKndB0RYGlHzr+6h0BAbnZnqALhenwYI8yXKRv25xjeNtSVYrNW+JTInsA4mheRg6fBnupCfwfbZT8BPyEPVNKBk528M3aP1vYnD2DQHKJEV6ZWs4wuDS03Y7ynAeASMNXr5RwXawvcPeyV5P9Vn/ZF8UA1SKmJX6EftDcELpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZ957H5M; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ957H5M"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2352400344aso25170085ad.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 06 Jul 2025 20:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751857868; x=1752462668; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7amhQqX50eRT9loQj3sMjgvmIkBWmbgVYCt5B3y/xTA=;
        b=FZ957H5Mc+G3FxpqIRWAUR6m9j6FbBjgy7sXFvWOCtAjlZXglwgsQY1ArxXEJLYD/A
         PTtaOoSIneBsbnFEPRZCG5uv+5FGCBnfB/UAj/OI5ggdlCoPynUQhIEDTGusToY5rEcq
         wDIJ1iWt8e/ARMOa+koHL1ljg/71fQBb0qbXVQft06EzA/fYo0RVhkufSo/UvZO0lsam
         fN5z8DKZyqwKNpSXXpP0++w0brQpQyUQBqaOCsuPxvSLsXmZT/Tw20qz73Fgih9+583F
         m+EzmGeBpcgr2wLf2dNcoWVo8G06VYRE+bHVIuUX7+EtRYetWzIPMAGgWw0aO1ddFRKi
         5vYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751857868; x=1752462668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7amhQqX50eRT9loQj3sMjgvmIkBWmbgVYCt5B3y/xTA=;
        b=We2TioVsVT+0aR6BhWBA+kUIVVZFJ43j1BcyIAp/0tVee7WTIoCOVnCA5gd5575C8l
         xjir2kF3jkJjO6AX6+2JR6bwlFDx7xqzMXGs4mYVk+Wyinp8DI7w1EXJuqXKgHWEX+Mc
         I0R+EN0OvAYLRfnvEYawpUZPLQecTWFzmPW8U4d1X/bFEBmGm3I+X1Sn4A/TxgxINgsi
         oZJShK8pQ54v4S9jc+d0KgNitKRmxIinOdcR0GXdmzFz98ijFn8D5971mjlLYPsERcv6
         JZxw1R8ZtrrXGa7DymoCxKZlN1LQ2r41wGSZfAFk4aFi6td0UWO7rOL+EBm2CbxmQDlc
         w1cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIpAHeKDuiKS2/rim8fiFMWdJdGSAxJ9UeUecEkTcQadpKLXhf7UFSO++BzM9RSviCjiXZS1CyNSGu9Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxefrpZtNFhS96jTIGRUtzOuAA4rp3VrXoqYb7xrpTv5TqZbErg
	FwGaDZ3jEVb+CCVMJ9/LNEYPSIVYmqhO7dvgwQzvZU+zl4LyYCxdWBic
X-Gm-Gg: ASbGncu94shUdPdXl9qApu7Vijg+2EAmSRtmRko250zaUTH86pmZjS9USVsV66jaY56
	tY3fTyTvNqvrQBDKzDilFXxKcfQORnzSPyq/ylEG1sxyddQnKweXEh924xjsp+jfy3nGke1Wt5g
	YdVPqPymdw11z1m6mOdjTZ+eljvq9jAqh0HFRmU1+G/byALJsIJl1jkqm08tsVlTD+7aTq/GauI
	6d1NM7hk4UD2v0XZ2gfq4O1l2jJwraA+GBW4LCANMN/l+FBg3B9IBOLEnURy0NZjZhbMddZ5XTV
	WXWhX8tVCOsCnXFVz5sdLcj9RjDN7I9fsrbYhX+X1HZTWI9M6Aca95Sel56Hh0jRZBbLtRrMaGb
	lZaMBigEem6zF
X-Google-Smtp-Source: AGHT+IGIbEvG3vsSdCpTz1S1BGFX5z8oIm8yeCQTxGVZVKcStSckfWZrCw2pndUc0Dy7K0uNEyB8lw==
X-Received: by 2002:a17:902:f70f:b0:235:e309:7dec with SMTP id d9443c01a7336-23c9105d8dcmr79734375ad.26.1751857867638;
        Sun, 06 Jul 2025 20:11:07 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55 ([2601:646:a000:5fc0:5e93:4ea0:4954:ef6c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c84351ae4sm73971615ad.72.2025.07.06.20.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 20:11:07 -0700 (PDT)
Date: Sun, 6 Jul 2025 23:11:04 -0400
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com, 
	jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: avoid potential ABBA deadlock by reordering
 tl_inode lock
Message-ID: <ximqx453owvswgsgaqdsg26pbkyzj4mqhm4gowudbhvxfsdzqw@fmndfzgkt53z>
References: <20250705175315.225246-1-ipravdin.official@gmail.com>
 <02850dc3-1827-433a-89f1-b66553efe02a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02850dc3-1827-433a-89f1-b66553efe02a@linux.alibaba.com>

On Mon, Jul 07, 2025 at 09:32:52AM GMT, Joseph Qi wrote:
> >  
> > +	inode_lock(tl_inode);
> > +
> 
> The following out_unlock should do the corresponding order changes.

Will fix it in v2, thank you.

> 
> Thanks,
> Joseph
> 
> >  	/*
> >  	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
> >  	 * logic, while we still need to lock the global_bitmap.
> > @@ -637,8 +639,6 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
> >  		goto out_unlock_gb_mutex;
> >  	}
> >  
> > -	inode_lock(tl_inode);
> > -
> >  	handle = ocfs2_start_trans(osb, credits);
> >  	if (IS_ERR(handle)) {
> >  		ret = PTR_ERR(handle);
> 
	Ivan Pravdin
