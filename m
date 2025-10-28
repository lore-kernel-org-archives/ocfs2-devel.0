Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C1B23506A
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 04:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761624502; cv=none; b=KJnF6FgIBsITfuR5fhUUwhsATiIoYPa1820ljCss8UHB9GmZajPDyaUwQwRu24GIxoA4gTA2Pqp5zl+DvICy5PC3vb1Dp0AVq3gPQOCKkeSJNFfXsurcP0WS5wQVDQw48jSc1ZvYMrOIYIx3C9oTBQ2az6g/tK/znKctf/ocpe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761624502; c=relaxed/simple;
	bh=kX4Ag6SyB+N8IzmFD6q5jBMwaqUTQgC5DjQISVMECwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcAxy0XPJgt9Ry/qdcMZcGtKG0Ra1NTucYEAmrJZQzq4WC3yHChOwFNS2yTaJsMEhvx0Ybk+JoMz2WR6Uwd116IAJH7adYHKCqPo3EVRtRRAyIQoCfWKWOBnxZ0p7CN0eFaLIa5a0lFDm2kIqm9W956ZKk/i75r58S9RR+hAyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P2fkUSQM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P2fkUSQM"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-472cbd003feso3965855e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 21:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761624499; x=1762229299; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EF6NmwlPOpsr3cR+pzU2dQE84+SIPk4SPyxRaTBwNJg=;
        b=P2fkUSQM5b0stiSRKVHA2WU24tHJwA6DKN0jYIzT985UGRRsclKRvr/ZlZVFrho42c
         HBrsCgqsZgkYHivKjBgzdhapHjOKWGuEAWa14Qi6y0ZSkcsaWQUwOmJuc0b7VKv2Z6t7
         xMu02HWzOyUVlPHuweXvoBD+Z3053zfhU1U6QCdwKhbXLX1OM7GvCX7pZdPjgMZto+36
         QQbV4vbgfLMCaiXucHdJrEUtq4B5x6ngHmmd5mj9HX3FrMfw/qyOCGiXwoW+j/mTDarj
         JlB4jujBRAojDGNsv7XkAqpr3Nh6Fv/0kARL0uq/gz6fp412sKpMQeyYa0Kh7JMT0CSl
         qqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761624499; x=1762229299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EF6NmwlPOpsr3cR+pzU2dQE84+SIPk4SPyxRaTBwNJg=;
        b=gwbtvh8ZFf57/8c2husFeRGghNXSnRgQd7ZXb2L99epqolK+p+laP56dRedXN//oHi
         CyEBAHhpQ5uAtqb2BCJk/fU3mX5Z4KtvXZCqDalK0QAQMcQuHDBsz+8lGDVHtaVCb3ij
         fIzxIWAqeSDbzKHQWRhoWzMheTL8xtD98+gcgTy6MAQ0meAxDwjJEztWm2Rtrg5YbOIL
         jtqcMcM4WZtMRk8KBVbCxDX+1ke2ehFI9kS4wVdEI5a+/ER7T10/iNPwXkHPliMLKo8z
         mlfBHwGgwRBiE+RXQOSVUCb+KuDJrgAPfPyRul2/hZ/XiM87upNSimmdCvJTdVGbYYbF
         oiNw==
X-Forwarded-Encrypted: i=1; AJvYcCUZK6eRc0w7esQRp8bnX8d4uypfqZ6mOY88ZmYnXh8stcXUZx4a9rgGjxD9RlhrPY7f0Z86UqKccX1ubQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YySQ+L+avgXC6Mm+LVBs/Uvd4qklsH0U1orojZUY1RJOMajlk46
	MHYsYPMqua3+gg0gZ9hKzyTdEe/xjGNaB2kNlVoePgOasYWsiZ2kpt+tVPI3vLfJhxY=
X-Gm-Gg: ASbGncuBu7+QrAswSaTvuJJvhGXExoO643Zvuv3CMUhrr/CUH78G4E/viY4jV7iG0x2
	gWZ/a9JP3LEZ3jcAq6XQSuJ3hRUJ/UuO/LJi1EqOfiBPJrxHhWjS+93GVPuzyWplls79a7g64pg
	kqs/Nj1TMTuJKK2DLkaz53OYhmT0ClJ0b0AFSEYX4N29BpJ40CUWXHsBzdAC/XdPgDFoqUStJd1
	Ritp4ILdrRMJzpikF4JFh8o0E1scDXPBBo1nVHUoHWjwTpIpWxQUrMhkyWw/IhNer8wlSyQLr9i
	Sa1sJ4XQ+w3rgJwHSKe0bxb7eGDnxJm+b29xwgMsh5d1qUyKrUxoNgsgqL8GQLa4sU6tNsZNCLU
	ONxSKzZdoQeHTEHzegzK/0iU3kbLjb8g7RHGcq1tDiHRIYgyZCfRSo3yREhsTQ7wfxFi/WjRI92
	I=
X-Google-Smtp-Source: AGHT+IFL60BC5AW67LbLmPP35a6qPtu3/iCN4XXt28JDv67GGFVDQ7ed3zi8hgUC3nYNjJDKmSFusg==
X-Received: by 2002:a05:600c:3507:b0:471:1387:377e with SMTP id 5b1f17b1804b1-47717e787b0mr7892475e9.6.1761624498611;
        Mon, 27 Oct 2025 21:08:18 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d26c13sm98807475ad.53.2025.10.27.21.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 21:08:17 -0700 (PDT)
Date: Tue, 28 Oct 2025 12:08:15 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com, syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: Re: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with
 ocfs2_check_chain_list()
Message-ID: <nxmdosp26qotev63tpeq43njfobyxpes3v4zhpb6jhmerpjhpn@ba4ylsi6nctq>
References: <20251027125654.312153-1-dmantipov@yandex.ru>
 <9e9f5ed7-5c37-462c-9970-3da7dd957e4e@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e9f5ed7-5c37-462c-9970-3da7dd957e4e@linux.alibaba.com>

On Tue, Oct 28, 2025 at 09:53:06AM +0800, Joseph Qi wrote:
> Hi,
> It seems that these checks can also been moved into ocfs2_validate_inode_block()?
> 
> Thanks,
> Joseph

The patch checks 'block group' not 'inode block', the signatures are
different: OCFS2_GROUP_DESC_SIGNATURE vs. OCFS2_INODE_SIGNATURE.
In my view, current code is correct.

- Heming

> 
> On 2025/10/27 20:56, Dmitry Antipov wrote:
> > Introduce 'ocfs2_check_chain_list()' to check whether a) the maximum
> > amount of chain records in 'struct ocfs2_chain_list' matches the value
> > calculated based on the filesystem block size, and b) the next free slot
> > index is within the valid range, and use the aforementioned function
> > in 'ocfs2_block_group_alloc()' and 'ocfs2_claim_suballoc_bits()'.
> > 
> > Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> > Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
> > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> > ---
> > note: resend to ensure that it's reviewed and hopefully good enough for
> >       mm-nonmm-unstable of -mm
> > v2: bail on cl->cl_next_free_rec > cl->cl_count (the name is misleading,
> >     cl_next_free_rec is a member count (and so can be equal to array
> >     size) rather than member index)
> > ---
> >  fs/ocfs2/suballoc.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index 6ac4dcd54588..9969a041ab18 100644
> > --- a/fs/ocfs2/suballoc.c
> > +++ b/fs/ocfs2/suballoc.c
> > @@ -649,6 +649,16 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
> >  	return status ? ERR_PTR(status) : bg_bh;
> >  }
> >  
> > +static int ocfs2_check_chain_list(struct ocfs2_chain_list *cl,
> > +				  struct super_block *sb)
> > +{
> > +	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb))
> > +		return -EINVAL;
> > +	if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count))
> > +		return -EINVAL;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * We expect the block group allocator to already be locked.
> >   */
> > @@ -671,6 +681,10 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
> >  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
> >  
> >  	cl = &fe->id2.i_chain;
> > +	status = ocfs2_check_chain_list(cl, alloc_inode->i_sb);
> > +	if (status)
> > +		goto bail;
> > +
> >  	status = ocfs2_reserve_clusters_with_limit(osb,
> >  						   le16_to_cpu(cl->cl_cpg),
> >  						   max_block, flags, &ac);
> > @@ -1992,6 +2006,9 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
> >  	}
> >  
> >  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> > +	status = ocfs2_check_chain_list(cl, ac->ac_inode->i_sb);
> > +	if (status)
> > +		goto bail;
> >  
> >  	victim = ocfs2_find_victim_chain(cl);
> >  	ac->ac_chain = victim;
> 
