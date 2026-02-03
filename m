Received: from sender4-pp-e104.zoho.com (sender4-pp-e104.zoho.com [136.143.188.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8573D33D6CD
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Feb 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120648; cv=pass; b=JPqJsWbSjrrni7FDCWRvS3NXZTAcwWqoRyGq1vYgkHCosNiadJDeppNOFbFGeajcHG/ZK58jC34Y8mB7Ld5hez6Bc5Gn3YcAiVY7HL0WfsQe00jRDlKWPfpa5cJEJ3beM/BQv4sLqtIepUM4Z3KUukhYKdbhcfDJp8wUSIBXNmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120648; c=relaxed/simple;
	bh=Q0tftleGutfbMIbJ3JoWHS1G5LtDLt5Ug2U/ryoqsdM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=LHDAyPBT2BIqEGQ69UWIeGG32S6LrqbCERln5W+0iIEJbkyV5DV2xW4QiMpwN3fR69DV2GaHaEMZjjwNlEN8ewYXTvuCqMujd8XODZPaCf71mHm3npP7FYBC+VdT8CNdVZL3g9TwcHcEExv18iyXQnfEfP35YzlJbodh1E/UF8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=YAf3ZTC0; arc=pass smtp.client-ip=136.143.188.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="YAf3ZTC0"
ARC-Seal: i=1; a=rsa-sha256; t=1770120644; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ti60k2GphWR2W+18ctMv3l07d5Jui3jxmU4KiEQwaaUCzuHR1aevIBKRDwT7QYF69TVwPYIq8n+fXrC63X2biS2jx3r1n0iS3NGyvaALJQDslYJJFTkmtbVDSoMm9QNTRJwVeJKuDFsQFzk1Zf+PVaUTnPZ1S/EZfMompuKiq2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770120644; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4EudusyqyIlpQ1xpiusBN+m8mjvCHzdcIPmJiCoNrTs=; 
	b=Iu3LZ3hzcU2Um1MM8UHMPGoFJUHTlPmF2fMawOGieaxKJy19k2g8E1rvI169VmAtkHGsmH1SsV2fWkiDFqs0FBIjs4NtEfK3YJwocko2Gp4fR1/lN/RVyzEgJpFQz+orJtNV2H6l0g08zgh78k7P4cAY2jBm3NXWGUT4FWV8cd4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770120644;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4EudusyqyIlpQ1xpiusBN+m8mjvCHzdcIPmJiCoNrTs=;
	b=YAf3ZTC0WarIKQMHz0vYz81pMiv8XVVUeGUmCZy62YkEzFOWUIxT17M8R1sTyvxs
	Uih0WGM5fiZkZNjjoZ6QYOcoERWw+bmc5M27Fwp7uRKtTHwaNj8SkLFxlNxjnPoXHnU
	o1Y985l80Tf/g85oiznNEZ4UbulOlswGjTv1Mj3I=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1770120642782197.9951253270375; Tue, 3 Feb 2026 04:10:42 -0800 (PST)
Date: Tue, 03 Feb 2026 20:10:42 +0800
From: Li Chen <me@linux.beauty>
To: "Jan Kara" <jack@suse.cz>
Cc: "Matthew Wilcox" <willy@infradead.org>, "Mark Fasheh" <mark@fasheh.com>,
	"Joel Becker" <jlbec@evilplan.org>,
	"Joseph Qi" <joseph.qi@linux.alibaba.com>,
	"ocfs2-devel" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Jan Kara" <jack@suse.com>
Message-ID: <19c236980cd.2370a267287093.895726956980326936@linux.beauty>
In-Reply-To: <nxltvmkavegi5tedwzb5g4gt5vzyjvsmkmg24sej74q7b5nvfm@o5u6uivv7sm7>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty>
 <aXxBX2Ul-S6nJzG5@casper.infradead.org>
 <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>
 <aXzeDE5P_lxiXfPB@casper.infradead.org> <nxltvmkavegi5tedwzb5g4gt5vzyjvsmkmg24sej74q7b5nvfm@o5u6uivv7sm7>
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

Hi Jan,

 ---- On Tue, 03 Feb 2026 01:17:49 +0800  Jan Kara <jack@suse.cz> wrote ---=
=20
 > On Fri 30-01-26 16:36:28, Matthew Wilcox wrote:
 > > On Fri, Jan 30, 2026 at 08:26:40PM +0800, Li Chen wrote:
 > > > Hi Matthew,
 > > >=20
 > > >  > On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
 > > >  > > ocfs2 journal commit callback reads jbd2_inode dirty range fiel=
ds without
 > > >  > > holding journal->j_list_lock.
 > > >  > >=20
 > > >  > > Use READ_ONCE() for these reads to correct the concurrency assu=
mptions.
 > > >  >=20
 > > >  > I don't think this is the right solution to the problem.  If it i=
s,
 > > >  > there needs to be much better argumentation in the commit message=
.
 > > >  >=20
 > > >  > As I understand it, jbd2_journal_file_inode() initialises jinode,
 > > >  > then adds it to the t_inode_list, then drops the j_list_lock.  So=
 the
 > > >  > actual problem we need to address is that there's no memory barri=
er
 > > >  > between the store to i_dirty_start and the list_add().  Once that=
's
 > > >  > added, there's no need for a READ_ONCE here.
 > > >  >=20
 > > >  > Or have I misunderstood the problem?
 > > >=20
 > > > Thanks for the review.
 > > >=20
 > > > My understanding of your point is that you're worried about a missin=
g
 > > > "publish" ordering in jbd2_journal_file_inode(): we store
 > > > jinode->i_dirty_start/end and then list_add() the jinode to
 > > > t_inode_list, and a core which observes the list entry might miss th=
e prior
 > > > i_dirty_* stores. Is that the issue you had in mind?
 > >=20
 > > I think that's the only issue that exists ...
 > >=20
 > > > If so, for the normal commit path where the list is walked under
 > > > journal->j_list_lock (e.g. journal_submit_data_buffers() in
 > > > fs/jbd2/commit.c), spin_lock()/spin_unlock() should already provide =
the
 > > > necessary ordering, since both the i_dirty_* updates and the list_ad=
d()
 > > > happen inside the same critical section.
 > >=20
 > > I don't think that's true.  I think what you're asserting is that:
 > >=20
 > >     int *pi;
 > >     int **ppi;
 > >=20
 > >     spin_lock(&lock);
 > >     *pi =3D 1;
 > >     *ppi =3D pi;
 > >     spin_unlock(&lock);
 > >=20
 > > that the store to *pi must be observed before the store to *ppi, and
 > > that's not true for a reader which doesn't read the value of lock.
 > > The store to *ppi needs a store barrier before it.
 >=20
 > Well, the above reasonably accurately describes the code making jinode
 > visible. The reader code is like:
 >=20
 >     spin_lock(&lock);
 >         pi =3D *ppi;
 >     spin_unlock(&lock);
 >=20
 >     work with pi
 >=20
 > so it is guaranteed to see pi properly initialized. The problem is that
 > "work with pi" can race with other code updating the content of pi which=
 is
 > what this patch is trying to deal with.
 >=20
 > > > The ocfs2 case I was aiming at is different: the filesystem callback=
 is
 > > > invoked after unlocking journal->j_list_lock and may sleep, so it ca=
n't hold
 > > > j_list_lock but it still reads jinode->i_dirty_start/end while other
 > > > threads update these fields under the lock. Adding a barrier between=
 the
 > > > stores and list_add() would not address that concurrent update windo=
w.
 > >=20
 > > I don't think that race exists.  If it does exist, the READ_ONCE will
 > > not help (on 32 bit platforms) because it's a 64-bit quantity and 32-b=
it
 > > platforms do not, in general, have a way to do an atomic 64-bit load
 > > (look at the implementation of i_size_read() for the gyrations we go
 > > through to assure a non-torn read of that value).
 >=20
 > Sadly the race does exist - journal_submit_data_buffers() on the committ=
ing
 > transaction can run in parallel with jbd2_journal_file_inode() in the
 > running transaction. There's nothing preventing that. The problems arisi=
ng
 > out of that are mostly theoretical but they do exist. In particular you'=
re
 > correct that on 32-bit platforms this will be racy even with READ_ONCE /
 > WRITE_ONCE which I didn't realize.
 >=20
 > Li, the best way to address this concern would be to modify jbd2_inode t=
o
 > switch i_dirty_start / i_dirty_end to account in PAGE_SIZE units instead=
 of
 > bytes and be of type pgoff_t. jbd2_journal_file_inode() just needs to ro=
und
 > the passed ranges properly...

  Thank you, Jan. I will update the series accordingly.

  It seems this won=E2=80=99t break large files on 32-bit either: MAX_LFS_F=
ILESIZE there is
  ULONG_MAX << PAGE_SHIFT (i.e. ULONG_MAX pages, ~16TB with 4K pages), and =
pgoff_t
  (unsigned long) can represent the same ULONG_MAX-page range.

Regards,
Li=E2=80=8B

