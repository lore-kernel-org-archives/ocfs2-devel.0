Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A72D9EDA
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760474756; cv=none; b=T2BS6kHIjU40C/i7peyRG51cwnBbIx/TfBpJ2uYEJTCdJ9h4ey0FRbC0ijUXozfE1gui41g2410HN+tQuPQlODYekCkTHgxlzlxHIcebyTyhBwjfstiYI2G7fAy+/+h6P1u+oNhV5p/Ik/K2VOBGt71YK6W+cic1TBP63PPvntk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760474756; c=relaxed/simple;
	bh=mLMiOvkuQ1waPsYJBAJdPUyickusJQ8ORxj4y3Zep3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP+K++VmIgvC14Eu0ip+2aTyDEZRdGmaH05GvE+D2OCdMUZh+6ylst0qTuHQe7t3otGXpBgo1bovf9KvoAhw/y2QlSjysTY5uVEYCtR3dYNb+uC0VGWqyMcal4owdbtPwPFuFvXXOD8yhvO0KseNrPOhn2p3op1uVvex5PsT4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=srjW0sRV; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="srjW0sRV"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33274fcf5c1so6133054a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760474754; x=1761079554; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ProMLWdJiYhd+ReUg4Q/nfu5OGup3NKBCnvPEIlS8hk=;
        b=srjW0sRVUYqmtK+ZSoMIdjhhPUxzBaO40zIjQzPVsYAcGpkffC/OwGwZlsPK3EV3Qr
         Df0I//tFySUBtMsJdbts2zToYSGfUuQRmaUYxOPcvJMxbDXzGxYTjPrK+besiQJSVhpW
         g33T59dNLzCrsq2smo3W9HBZUw5PNIJjg72wq42P4gVEFKax3XD8Jr6QGgmQt6V/aLwE
         oZbHQ1TD+tX2cUGt9iw1iGDxQD9KSr+B8OEyqvMAa39cAdL0HPeRzGzGfLRyQJjPVLyF
         oG2NzTUuDUHb+XXz2jmY4H1iU4AordQvLQGlnICMLri1HjY9ZnXrZjbUsrkKUujoNq0l
         cazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760474754; x=1761079554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ProMLWdJiYhd+ReUg4Q/nfu5OGup3NKBCnvPEIlS8hk=;
        b=nOTtKPIhXUXbLTiwQQVBP3E5YqpeIf8Fzzq88cuPTwOBQ+EI6AqtGvU6t8AUYOmV5w
         /lniyVuLYeCuXZk69+Euuvz6jYaaurSiUhDZrN4FXzSDBJ3hnJFF9Y4/Js+VpKAoLYDr
         tOCSTwCMa4sy7St4GBhlCoRLM+kMxke3VjDGq69yFTcFsrBYQNU7joXklOFWVFC4l04f
         JB7Xqsdud1mNMAxstdZCaSZjhzcmp2UrBDhZTlfvLmceYX4+GBo/5tbfmCRDPgEdVmDt
         BAT+CeyaoysotbhMNWszrBWrr5l2Pub8EkAs3BI/EQRCXY+PEcqaJSSb88duYtgh2Z5e
         1MJA==
X-Forwarded-Encrypted: i=1; AJvYcCXISwGLjmCpDnHqIbKeC8XItjlKAwdS0tLb4N4cZAkOAdFcXfL++6DN3fH9zpTqvmkpXym9vuht+WR7SA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzORroAfubl5LQzf/E3gEKAAL3Dg+v2PWqyeIJ909z3ipDiWQx7
	oGWStADdMDqNzXxk98HTKXLeJEqwG2OK0dxSlUww3z4+ZT7/PC8OsIeFkZW5gvJPfjarseCdwGT
	y1egH
X-Gm-Gg: ASbGncsKDrSlrdAcUBubmgtJzc4gEDorPQq0Dumly5DyTkr/4eCftlTr3nHs0/+e/hN
	LAKozyJ9zH/8gDRgDnVdzEiQWHRcd18rPnjDIlFLtuKUl2M/xZrgjVbx3gmmuJJlWMaRlX8OmxB
	bJTU3lQUZ5/PO2xeTGt9fQNaxYPna3ewfWf6paurpU7xssuXvV8UprWBC8N7w37ua7oB8XXJarb
	6hw8INfV4+aO1dNOQOTOOUiK7oWpJnUzFWKE4cHO3bSg3n9Frl+ZJPetuVEwWfJ5J9U+HIoazr4
	C/YPjg71hLOah00/ilujTQjQwfA+fpVA4//dvpsjhpepKQ73ac1MFqLB2ln5Gp0v6vhL4+v9mZ2
	l4tcfh3Ffcewtv2lh56F8nurP64GPD8NtDbunQ3BB70ZmjFEK0RDn3jjZE3UMxn5S3ORXToudwF
	6CjpisqDMCVZhBsTH4
X-Google-Smtp-Source: AGHT+IEha/464YLIDe1S05FMmmIwJiiHJqNozxP/E/7ahWiUSHSloNCgr/S9uHudRNKH/rfSTuG4WQ==
X-Received: by 2002:a17:90b:3947:b0:31e:c95a:cef8 with SMTP id 98e67ed59e1d1-33b5139a259mr32044929a91.32.1760474754350;
        Tue, 14 Oct 2025 13:45:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b62631266sm16839994a91.3.2025.10.14.13.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 13:45:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v8lu3-0000000Es6g-0Y5G;
	Wed, 15 Oct 2025 07:45:51 +1100
Date: Wed, 15 Oct 2025 07:45:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <aO62fx2B5ZZLsRVM@dread.disaster.area>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
 <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
 <20251014044723.GA30978@lst.de>
 <qh7xhmefm54k3hgny3iwkxbdrgjf35swqokiiicu5gg3ahvf4s@xhyw4sfagjgw>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qh7xhmefm54k3hgny3iwkxbdrgjf35swqokiiicu5gg3ahvf4s@xhyw4sfagjgw>

On Tue, Oct 14, 2025 at 11:33:26AM +0200, Jan Kara wrote:
> On Tue 14-10-25 06:47:23, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 01:58:15PM +0200, Jan Kara wrote:
> > > I don't love filemap_fdatawrite_kick_nr() either. Your
> > > filemap_fdatawrite_nrpages() is better but so far we had the distinction
> > > that filemap_fdatawrite* is for data integrity writeback and filemap_flush
> > > is for memory cleaning writeback. And in some places this is important
> > > distinction which I'd like to keep obvious in the naming. So I'd prefer
> > > something like filemap_flush_nrpages() (to stay consistent with previous
> > > naming) or if Christoph doesn't like flush (as that's kind of overloaded
> > > word) we could have filemap_writeback_nrpages().
> > 
> > Not a big fan of flush, but the important point in this series is
> > to have consistent naming.
> 
> I fully agree on that.

*nod*

> >  If we don't like the kick naming we should standardize on _flush (or
> >  whatever) and have the _range and _nrpages variants of whatever we pick
> >  for the base name.
> > 
> > Anyone with strong feelings and or good ideas about naming please speak
> > up now.
> 
> I agree with either keeping filemap_flush* or using filemap_writeback* (and
> renaming filemap_flush to filemap_writeback).

I'd prefer filemap_flush* because most people are already familiar
with that naming and the expected semnatics. But I could live with
filemap_writebacki*, too. Both are better than "kick", IMO.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
