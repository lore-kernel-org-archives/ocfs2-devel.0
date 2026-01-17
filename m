Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE4B221DB6
	for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671756; cv=none; b=B7cSM3b47H1NlbH5LXTJajMdQzLJ59Pzj61M0zk2h5Ec96upy7XYGHp18OPjDtqhQeXiRG+ECuuxliEjJHoVX+tr/EyObHUUxjSG9barBs719wJNWUUO56t9w4xx8C/tkCAluMIe188lapVhgDlLnnrlBXu8KNeG5NBGqeZ22d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671756; c=relaxed/simple;
	bh=AYBzPkhdjgGJDi0kHW57cXrX2NxQBmdXVWZn8NiITpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8UvHDDMZUxyKL/mrysm2HMgmU0OCatyguoJz+nT4G1Qor4iU9sr+xGOPFtLDAEFQqirMpJS6bVUlrsek2VSKy3UnAJwdgCy91DIVgwOwF3we35E6AlmdZYTCjtr2O6sr7KWCcS9dh5X5YiCApny3RAU+RerOOVF52znmH3vDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R0eyUO5b; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R0eyUO5b"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0a95200e8so19942365ad.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 09:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671754; x=1769276554; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fa2C3CjBP0zf49hlsRlTlbBzJ9ToDABb44obJ64qh7o=;
        b=R0eyUO5bhb9H3Aps8Bor0nJzBBJbmKEIN8yfUx78f/17vc042tx0cLIB4cAfoOAf2k
         uF2anUHnZOay3uKOSlX4KmgJdODCgwCs6cK0oV1GEHPNlJUfnWRZqNC9cXLvyWHptU7p
         1mWd8IOiovhMPHAKwggRejYGpk5uUmVE3oIRvvbH3NQBqW3KF7bEwvU/59Glcew7C570
         VwlwZktv04PBzIJYjUulOMyH1Ct2yRxi6hiXX17y6neSAdE44m7w6DmQP8wl1aBkJiRU
         u9yIiw3PasY3XF5e4ANOdUjyxD3fnKtGZtr6c3+uPKEFfSBTBnMKcLTz9qASZdLH57Y8
         TxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671754; x=1769276554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fa2C3CjBP0zf49hlsRlTlbBzJ9ToDABb44obJ64qh7o=;
        b=rLUa7TTIrcEwfbFLUzKmwbU4BpGrzLA35ThSg8FZ1Zo+4YMpjfBBh4y4xuUYox6nvi
         6MvkysVeKow1rkAtnRyfS0B3UB1lS+a8FfQxfC5Vk+bmLKoD+e5koOR//zcdR4zYSNJ2
         hZqRYzu8qjxjL2ACyhWN8UThI9R3CvGuw9an4b29nEg+03UXiYVOcPhe7ci3jUmGkkMo
         Ta5FZbl32DPFp9xHqs3Vv3yxXUwsj+FVLqGY7n/wPIr47eK2ZFdTjoXW2CRK4a8qa2tn
         G8vNsfa1olTf5MnwCV750L1W+KIfpYXoHUReyXJ4da89XkaT145tzo42Xj3YHGnq1f5R
         /Ucw==
X-Forwarded-Encrypted: i=1; AJvYcCWtaPHdGxskWOpeY+AgnL5/xR/OilM8uaq+W7SBxdl6X0q2LoEMqbPtACxizME9/yMGjDFrQuFtQOuBhg==@lists.linux.dev
X-Gm-Message-State: AOJu0YykDxBRdRPmtT7uYBtV/kbIiDlCzFRkqsdqArcjc09EXe9loK6J
	L2tOVtyxALfR2f+zAReFXB00xayezU3/c/ovsK4NbDZ1aPrviLfSRLUP4NUMvg==
X-Gm-Gg: AY/fxX5ZICxSYG/kLqB7XfAWxHh0vnU7PZfAoIqnRCz2slwT3BPj8VAgvcvdCZoyAHh
	kwfQX+X8TJA91SL2TvGEmP4AORDNdEZNfQHFq4JQWglHGnh7bBa+FzCB7/Q5eWkDgrmO1TnZsPV
	u7o1NPFx2L4bm8EsZRJHIA1RdDmUYOJSjso/yFoJYndy21/lB6v5SUUYenEIOeUTeJ/KAc7xTt1
	NyxDIz4MVNyKc5z406epWaWN1UzT7oQJE/sSelTj+jcWplQcKnExorO0HL5egHuxznFmfub92e1
	n50i/v/Tv5qvjkmcQ8Udu7zvOJmuaH8/dPXyMRP2cQ5yztopnak1TEerjGdpk9OvgtSDhMeSPj+
	JO/06amzdbqJ+e97KXouJDyGJ3Yh6Pn+S+QFZw0ae4o2Jv5XsnZLtpQ35KQ359VJeexXWyDAeHm
	LryIq1V5xuIso=
X-Received: by 2002:a17:903:3508:b0:29f:cb81:8bd1 with SMTP id d9443c01a7336-2a7177ce73cmr67547695ad.55.1768671754499;
        Sat, 17 Jan 2026 09:42:34 -0800 (PST)
Received: from inspiron ([111.125.235.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm51942115ad.62.2026.01.17.09.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 09:42:34 -0800 (PST)
Date: Sat, 17 Jan 2026 23:12:26 +0530
From: Prithvi <activprithvi@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <20260117174226.qpmlqbbsnc6pjgxo@inspiron>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
 <aWhxfLwUvHDswsIY@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWhxfLwUvHDswsIY@casper.infradead.org>

On Thu, Jan 15, 2026 at 04:47:56AM +0000, Matthew Wilcox wrote:
> On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> > On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > > syzkaller, the function is curently operating on a quota file.
> 
> So the right fix is probably to disallow DIO to a quota file, wouldn't
> you say?

Hello Matthew,

Thanks for the feedback! I agree that disallowing DIO on quota files can
probably be the fix for this bug. I will work in this direction. I think
Joseph was indicating earlier that DIO doesn't act on quota files, but I 
misinterpreted his feedback...apologies for that.

Thanks,
Prithvi
