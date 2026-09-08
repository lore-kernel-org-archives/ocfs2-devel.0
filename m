Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89E04AF17E
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Sep 2026 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861236; cv=none; b=KwBzBfIPJ1GE9Q6ILYmXd5PWt8x/PjEg4VUUXIa2B9NG+UCT3UzWwwClHSw9wff16ls+ghvvhIFEK0TA3a0Zxz4+CoHOtCaDAdY0tQwCYZ79N6iiEzocUUr5HzxXiE+k4YpYQ6LoH9bslY60IToCrhjNhFYWE/b2amjCm/Dv2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861236; c=relaxed/simple;
	bh=zEBuvVbGieGs6jKdfu4PR52PSOjGH+tQliSRIQMbp7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuFkYy5zbOf5r9xNyfgZIHkBEkD1Pz5uiTCdYVA2aGS3n5ZeO0XNaEYoA3whlVT2P3dsM52euueQQ1FjkXL4RXtUeoOPc3prO/P6VEtYXvJ/exQjUH0oZgPS+WeamDtrS2wtDmuaOz16c/XLrxLaD6mYPBqbDLRVNqt9sXdRQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GG1fySeW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k6HS48F0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y8vD/srn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0sXJP/5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GG1fySeW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k6HS48F0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y8vD/srn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0sXJP/5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB5B021983;
	Tue,  8 Sep 2026 09:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788861228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=GG1fySeWVzC7v/sjU/PcPMQ7s38yV+K1u9lzraOQlpJua/14A1ynljVS+8BUsm7vYZ9IBh
	TuRfpowFgF8XSCWqLAwx9my+UGVXranpfhgkncNPC31GjyHfKs4wxqA0Ygj/gXqbI6MCNt
	C6mKqaLsrcdowSGhEl5MHfU1zYXDKsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788861228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=k6HS48F0AatfwT4PRO/j6uKfn1eG/CV6AoMC1DRH7odtmHYjidMo85wA/LAHDfBjPPiEWW
	38xFglA6Ovr8FDDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788861224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=Y8vD/srnNtZQMUFTh44Cj0oN67vSc/MViRGVBP3LckrOEt/VLmK8w1HhwC7uwbC8uJ0Mtx
	yGu5af1YDeqChm/LjgotNtrE0Mtp5nFQfpHvpqsbyTyz3HG7vz849kXAUp8eQ4/blbcIwi
	x+xsypZGSiyMSC/PFdULm6uVvqerHxA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788861224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=N0sXJP/5nOZMx8CI/e0ZK5vRp2THy1H98LeQVqHy+vtrqajakK6LMjDNyW+jUILHkwCL9a
	IcxnqmwN3SbCsWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9944813332;
	Tue,  8 Sep 2026 09:53:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vdZiJSjbn2o1cwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 09:53:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 33C40A12E2; Tue, 08 Sep 2026 11:53:40 +0200 (CEST)
Date: Tue, 8 Sep 2026 11:53:40 +0200
From: Jan Kara <jack@suse.cz>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
Message-ID: <mdwfu5l2lcdumckkgwhsbxwae3shhylkv3da3tkimwbzuoosjd@2cfx5p44mkgo>
References: <20260903090053.13120-1-jack@suse.cz>
 <20260903090508.1360863-4-jack@suse.cz>
 <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
 <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Mon 07-09-26 19:32:20, Farhad Alemi wrote:
> Apologies for the delay in response. Upon our run, the patched kernel
> (this patch on 28924df2a08f) no longer panics on the attached
> reproducer.

Thanks for testing!

								Honza

> On Thu, Sep 3, 2026 at 8:15 AM Hugh Dickins <hughd@google.com> wrote:
> >
> > On Thu, 3 Sep 2026, Jan Kara wrote:
> >
> > > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > > requesting to enable quota using tmpfs quota format. With suitable
> > > passed arguments this can actually succeed in enabling tmpfs quota
> > > format on top of ext4 filesystem which leads to crashes later in
> > > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > > filesystems only, verify we are indeed enabling quotas there.
> > >
> > > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> >
> > Acked-by: Hugh Dickins <hughd@google.com>
> >
> > Thanks: yes, please do route it through your tree.
> >
> > > ---
> > >  mm/shmem_quota.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > > index d0b92d6da50f..a3fa4bd93e75 100644
> > > --- a/mm/shmem_quota.c
> > > +++ b/mm/shmem_quota.c
> > > @@ -30,6 +30,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/rbtree.h>
> > >  #include <linux/shmem_fs.h>
> > > +#include <linux/magic.h>
> > >
> > >  #include <linux/quotaops.h>
> > >  #include <linux/quota.h>
> > > @@ -54,6 +55,10 @@ struct quota_id {
> > >
> > >  static int shmem_check_quota_file(struct super_block *sb, int type)
> > >  {
> > > +     /* Verify enabling happens on tmpfs superblock */
> > > +     if (sb->s_magic != TMPFS_MAGIC)
> > > +             return 0;
> > > +
> > >       /* There is no real quota file, nothing to do */
> > >       return 1;
> > >  }
> > > --
> > > 2.51.0


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
