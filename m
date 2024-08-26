Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50353373
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Aug 2024 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724679159; cv=none; b=oZqHhpjDE4vfJNAwshrNgIMDgaf2aTyepe2irL9sIgPQhT3n1i7yLz+gu8WngRzilZpAmvuICdX9VMtqXbtfSKDmNBRRXX/eQFcq4PU53iIf/x4v1lDvzseNugNcyIu5wD3XOEUViVdJQqoymcGUZ4e1x8MTbZ+OzdRFRVqG1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724679159; c=relaxed/simple;
	bh=n0NPm7B6J7gVDk2ymDoWEA5zA8j5C6+nBCISk/lA5Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVcJceBDE+Pkv4GMCVzeEYk4zL8c8TpT9XA3LHOszEY6/IAWS0XBipX3rBuY7DRNg8uGVNMA6oBWr5covnnmAyFvN96eYmNDtwygn3eqnbIEJLKPt5C75BEEu8ZtzM20CwK3OieMSvSpm8bnJLJd49TXVN9K1u2panHGgf1MKRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MZG+zzd8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MZG+zzd8"
Received: from cwcc.thunk.org (pool-173-48-102-154.bstnma.fios.verizon.net [173.48.102.154])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 47QDW8j6004718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Aug 2024 09:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1724679132; bh=Fri/kc3dR/ARb2zKFwI6CM6fhXpI4ReBwuWSC6P3TgM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=MZG+zzd8YoEYiH+pUWgnfqgM7vJoEyYa4aBt0CagAKr72sOkn/bVYrmB7osXKGjt1
	 Qcg14P5902cyLz5kzCRuTLhMTjs3HwWE4iQu1VPFKpZZP3+bJABRXz2wgL8FvPOSuG
	 /77RJZsWCamci5WSPnuE6kMjQNt2VR95u4rm/QHvtbtkn8nqnoRLw6+6sbe0dBjkqU
	 UkusYmsZzm0g/ylujOXY5rxjCC1vbnhfnsc46E2Og9N4b89qhGb5d+3xOmGsSHgIfv
	 8G9cpRxlV1Co1cnIsN5/LilcyFW0yJ2KqwsugOyQuyx9eGI8q7BslJrwyWGoztjtXV
	 lwBZoaJyYA02A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 9C5FB15C02C1; Mon, 26 Aug 2024 09:32:08 -0400 (EDT)
Date: Mon, 26 Aug 2024 09:32:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vinicius Peixoto <vpeixoto@lkcamp.dev>
Cc: syzbot+8512f3dbd96253ffbe27@syzkaller.appspotmail.com, jack@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark@fasheh.com, ocfs2-devel@lists.linux.dev,
        syzkaller-bugs@googlegroups.com, ~lkcamp/discussion@lists.sr.ht
Subject: Re: [syzbot] [ext4?] [ocfs2?] kernel BUG in jbd2_cleanup_journal_tail
Message-ID: <20240826133208.GB424729@mit.edu>
References: <00000000000070a66706204e7698@google.com>
 <d673f289-2385-4949-ac80-f3a502d4deb2@lkcamp.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d673f289-2385-4949-ac80-f3a502d4deb2@lkcamp.dev>

On Mon, Aug 26, 2024 at 01:22:54AM -0300, Vinicius Peixoto wrote:
> Since the disk data is bogus, journal_reset fails with -EINVAL ("JBD2:
> Journal too short (blocks 2-1024)"); this leaves journal->j_head == NULL.
> However, jbd2_journal_load clears the JBD2_ABORT flag right before calling
> journal_reset. This leads to a problem later when ofcs2_mount_volume tries
> to flush the journal as part of the cleanup when aborting the mount
> operation:
> 
>   -> ofcs2_mount_volume (error; goto out_system_inodes)
>     -> ofcs2_journal_shutdown
>       -> jbd2_journal_flush
>         -> jbd2_cleanup_journal_tail (J_ASSERT fails)
> ...
>
> I confirmed that setting the JBD2_ABORT flag in journal_reset before
> returning -EINVAL fixes the problem:
> 
>         static int journal_reset(journal_t *journal)
>                         journal_fail_superblock(journal);
>         +               journal->j_flags |= JBD2_ABORT;
>                         return -EINVAL;
> 
> You can find a proper patch file + the syzbot re-test result in [1].
> However, I'm not entirely sure whether this is the correct decision, and I
> wanted to confirm that this is an appropriate solution before sending a
> proper patch to the mailing list.

The reason why this isn't an issue with ext4 is because the normal
"right" way to do this is if jbd2_journal_load() returns an error, is
to call jbd2_journal_destroy() to release the data structures with the
journal --- and then don't try to use the journal afterwards.

The weird thing is that there are two code paths in ocfs2 that calls
jbd2_journal_load().  One is in ocfs2_replay_journal() which does what
ext4 does.  The other is ocfs2_load_journal() which does *not* do
this, and this is the one which you saw in the syzkaller reproducer.
It looks like one codepath is used to replay the ocfs2 for some other
node, and the is to load (and presumably later, replay) the journal
for the mounting node.

There are also some other things which look very confusing, such as the fact that ocfs2_journal_shutdown calls igrab:

	/* need to inc inode use count - jbd2_journal_destroy will iput. */
	if (!igrab(inode))
		BUG();

... which is *weird*.  Normaly the journal inode refcount is expected
to be bumped before calling jbd2_journal_init_inode() --- which
normally is done by an iget() function, and is needed to make sure the
journal inode isn't released out from under the jbd2 layer.  It looks
like ocfs2 uses the journal inode for other stuff so get the journal
inode without calling something like iget().  Which is OK, I guess,
but it means that there are a whole bunch of places where it has to
call !BUG_ON(igrab(journal->j_inode) before calling
jbd2_journal_destroy().  It would seem like the *right* thing to do is
to bump the refcount in ocfs2_journal_init(), and if for some reason
the igrab fails, it can just return an error early, instead of having
to resort to BUG_ON() later, and if you don't realize that you have to
do this weird igrab() before calling jbd2_journal_destroy(), you'll
end up leaking the journal inode.

Anyway, I think the right thing to do is to restructure how ocfs2
calls the jbd2 journal, but that's going to require a more careful
examination of the code paths.  Your patch is a bit of a blunt force
hack that should be harmless, but it's probably not the best way to
fix the problem, although doing it "right" would be more
complicated....

					- Ted
