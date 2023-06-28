Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A204E7469
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 08:48:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CA0E2186F;
	Wed, 28 Jun 2023 08:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1687942107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lWHKJY9jffhTkOc71UZZjYPpecflPAFjJhiDX76mBCI=;
	b=Odo+MtmsCKi/zv71EzJmMtM03h1wgg5Ay19qcJaqjBmMEbKsCsCdI1dMZ8JlVRA4pvEI52
	YztE/J4qrRHiG2fMagOpCdrAGKZbsxkZtbStE28OqM4UzMHs1I/Cf2iMWqDLvbiTxd52fc
	TRD4x8AVJOrlIG1L4NombdD77LeXtdg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DEBF5138E8;
	Wed, 28 Jun 2023 08:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id BUgnMtrzm2TXYwAAMHmgww
	(envelope-from <ailiop@suse.com>); Wed, 28 Jun 2023 08:48:26 +0000
Date: Wed, 28 Jun 2023 10:48:26 +0200
From: Anthony Iliopoulos <ailiop@suse.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH 1/2] MAINTAINERS: Update ocfs2-devel mailing list address
Message-ID: <ZJvz2umev6Jjgx47@technoir>
References: <20230628013437.47030-1-ailiop@suse.com>
 <20230628013437.47030-2-ailiop@suse.com>
 <c8976472-ab01-de64-ff1d-9224b6c65633@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8976472-ab01-de64-ff1d-9224b6c65633@infradead.org>

On Tue, Jun 27, 2023 at 07:44:58PM -0700, Randy Dunlap wrote:
> Hi,
> 
> 
> On 6/27/23 18:34, Anthony Iliopoulos wrote:
> > The ocfs2-devel mailing list has been migrated to the kernel.org
> > infrastructure, update the related entry to reflect the change.
> > 
> > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 4545d4287305..2e95a8eb924e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15969,7 +15969,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
> >  M:	Mark Fasheh <mark@fasheh.com>
> >  M:	Joel Becker <jlbec@evilplan.org>
> >  M:	Joseph Qi <joseph.qi@linux.alibaba.com>
> > -L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
> > +L:	ocfs2-devel@lists.linux.dev
> 
> So the kernel.org admins know about this and have updated
> lore.kernel.org for the new mailing list, right eh?

Yes this is in coordination with Konstantin who made this possible, and
I'll soon ask him to switch lore over to the new list, once the old one
is fully disabled.

Regards,
Anthony
