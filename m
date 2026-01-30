Received: from sender4-pp-e108.zoho.com (sender4-pp-e108.zoho.com [136.143.188.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE2F36A007
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769776007; cv=pass; b=qiIJf9XX2j2l6hsCBnB9RI18orMvxKEYOk3XtWOT6twHdWXlrh7i7fk5KmJ6ocF9BgZxSK6xyhNxOM5o/EfxoIzMeUuetP+Ma9UvL0ms8wd1sGXo2eGy0YUYQWZn2byc6NwzdNcNPzPCtAmR8V1Ry6aQDMhl4WE6rJYYUaz9SpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769776007; c=relaxed/simple;
	bh=T3pOdLpvOP9vbd73qdKd3/cknoieqQVYhzgoQE9rtTk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=FkWpMsY4msLRcYh4jbMo179kaMaxNf7kL1LiRMYNiFAelYF17/nzDT8HXBTYe2uQskNuuIq+nz2Vvk2zTwSVxKe1C0yQaFF5NO9cf4mnG0aTp3yrUcirPAx6Sn04JzxIY7Qu5tQX1tkIRF5NKtONm+4dWWeOjerjjVck9hMbkZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ITn1b1jn; arc=pass smtp.client-ip=136.143.188.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ITn1b1jn"
ARC-Seal: i=1; a=rsa-sha256; t=1769776003; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GV23GX3wsrMzNUcoeqCdFUsIkFiYmZBrwORLqLEbZ8EkM5tqAj/LLMuIQrTkWwdlCge+N0MK/NbcNgyxl3T9+ndfogBmk8FMiDItG9JbHVa50hSdX2DkESg79WBmkHkdVlGUWtTKBUec2oi9qdpbL6iEH+mfwOV6E9qJXSKgLS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769776003; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XJXhlezhNVka90gfhguBsF/A4YLerwP7DguEfZQk8RI=; 
	b=LWX+oTR7QlfXfbb1DNdkEGpaSolJUmmWNKU3GULkB72b6a/PolJ3xOG3QXZqkenLu8d3DcA5rHg3NPfOZSHaSm53whjmb3UkKeY6WOMuW60o+Cv3oud4JM9F+FMOWGzJElYEEQtfza92T6CdU/XbcRzRYcnvxuYD7QkXsAhRdgY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769776003;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XJXhlezhNVka90gfhguBsF/A4YLerwP7DguEfZQk8RI=;
	b=ITn1b1jnePJOxIb9qQH66GLA0CfkTpFV2Hp1K8csnlvuoRpyu+sSlUjTVZPI1Szf
	hvzfZvt+Xg6bSuTLP3GEX1yj9gJ4oAtdLn0AdYGKDcSuN/6qicXMuDAC1xlI1qo7Lxx
	beKnqOhFL/3O1cMNWu/66kY7F7Qpst1lPtbrx9FU=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1769776000453639.5079009310039; Fri, 30 Jan 2026 04:26:40 -0800 (PST)
Date: Fri, 30 Jan 2026 20:26:40 +0800
From: Li Chen <me@linux.beauty>
To: "Matthew Wilcox" <willy@infradead.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
	"Joseph Qi" <joseph.qi@linux.alibaba.com>,
	"ocfs2-devel" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Jan Kara" <jack@suse.com>
Message-ID: <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>
In-Reply-To: <aXxBX2Ul-S6nJzG5@casper.infradead.org>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty> <aXxBX2Ul-S6nJzG5@casper.infradead.org>
Subject: Re: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Matthew,

 > On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
 > > ocfs2 journal commit callback reads jbd2_inode dirty range fields with=
out
 > > holding journal->j_list_lock.
 > >=20
 > > Use READ_ONCE() for these reads to correct the concurrency assumptions=
.
 >=20
 > I don't think this is the right solution to the problem.  If it is,
 > there needs to be much better argumentation in the commit message.
 >=20
 > As I understand it, jbd2_journal_file_inode() initialises jinode,
 > then adds it to the t_inode_list, then drops the j_list_lock.  So the
 > actual problem we need to address is that there's no memory barrier
 > between the store to i_dirty_start and the list_add().  Once that's
 > added, there's no need for a READ_ONCE here.
 >=20
 > Or have I misunderstood the problem?

Thanks for the review.

My understanding of your point is that you're worried about a missing
"publish" ordering in jbd2_journal_file_inode(): we store
jinode->i_dirty_start/end and then list_add() the jinode to
t_inode_list, and a core which observes the list entry might miss the prior
i_dirty_* stores. Is that the issue you had in mind?

If so, for the normal commit path where the list is walked under
journal->j_list_lock (e.g. journal_submit_data_buffers() in
fs/jbd2/commit.c), spin_lock()/spin_unlock() should already provide the
necessary ordering, since both the i_dirty_* updates and the list_add()
happen inside the same critical section.

The ocfs2 case I was aiming at is different: the filesystem callback is
invoked after unlocking journal->j_list_lock and may sleep, so it can't hol=
d
j_list_lock but it still reads jinode->i_dirty_start/end while other
threads update these fields under the lock. Adding a barrier between the
stores and list_add() would not address that concurrent update window.

So the itent of READ_ONCE() in ocfs2 is to take a single snapshot of the
dirty range values from memory (avoid compiler to reuse a value kept in a
register or fold multiple reads). I'm not trying to claim any additional
memory ordering from this change.

I'll respin and adjust the commit message accordingly. The updated part wil=
l
say along the lines of:

"ocfs2 reads jinode->i_dirty_start/end without journal->j_list_lock
(callback may sleep); these fields are updated under j_list_lock in jbd2.
Use READ_ONCE() so the callback takes a single snapshot via actual loads
from the variable (i.e. don't let the compiler reuse a value kept in a regi=
ster
or fold multiple reads)."

Does that match your understanding?=20

Regards,
Li=E2=80=8B

 > > Suggested-by: Jan Kara <jack@suse.com>
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > >  fs/ocfs2/journal.c | 7 +++++--
 > >  1 file changed, 5 insertions(+), 2 deletions(-)
 > >=20
 > > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
 > > index 85239807dec7..7032284cdbd6 100644
 > > --- a/fs/ocfs2/journal.c
 > > +++ b/fs/ocfs2/journal.c
 > > @@ -902,8 +902,11 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 > > =20
 > >  static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode =
*jinode)
 > >  {
 > > -    return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
 > > -            jinode->i_dirty_start, jinode->i_dirty_end);
 > > +    struct address_space *mapping =3D jinode->i_vfs_inode->i_mapping;
 > > +    loff_t dirty_start =3D READ_ONCE(jinode->i_dirty_start);
 > > +    loff_t dirty_end =3D READ_ONCE(jinode->i_dirty_end);
 > > +
 > > +    return filemap_fdatawrite_range(mapping, dirty_start, dirty_end);
 > >  }
 > > =20
 > >  int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 > > --=20
 > > 2.52.0
 > >=20
 >=20

