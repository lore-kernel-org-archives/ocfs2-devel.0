Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D955B4A987
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Nov 2023 12:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jp2FuFEG"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C93621907;
	Tue, 21 Nov 2023 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1700570368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwx/mAjaJ5YmXpYXiXCJSGhx9zGKVcg1C1LXTsfe5O0=;
	b=jp2FuFEGEBeVmzAk26U055DEFXDOWUI8qQHLAMK87evzBow6gAXrgGCMliiFQqwRaZBAB8
	4yQNf3RNaO35xam1dFbfUHxKxfHxg+MMqsq87hWWoe9mzG1fQAxeONiwsjsRz2Quxml5FN
	Q6yykZ+mKouSKti9kcC0XHXK8doQzl8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66958138E3;
	Tue, 21 Nov 2023 12:39:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id j1G9Ff+kXGVBFgAAMHmgww
	(envelope-from <ailiop@suse.com>); Tue, 21 Nov 2023 12:39:27 +0000
Date: Tue, 21 Nov 2023 13:39:26 +0100
From: Anthony Iliopoulos <ailiop@suse.com>
To: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Cc: "mark@fasheh.com" <mark@fasheh.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>,
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
	Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort
Message-ID: <ZVyk/v4YRCEMOcrY@technoir>
References: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
 <7ABBFC08-4350-4D6C-B740-80DE590F9476@suse.com>
 <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>
 <DM6PR10MB4347E075A7DADE3FEA97707BA0BBA@DM6PR10MB4347.namprd10.prod.outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR10MB4347E075A7DADE3FEA97707BA0BBA@DM6PR10MB4347.namprd10.prod.outlook.com>
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.23
X-Spamd-Result: default: False [-3.23 / 50.00];
	 ARC_NA(0.00)[];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.43)[97.38%]
X-Spam-Flag: NO

On Tue, Nov 21, 2023 at 12:19:03PM +0000, Srivathsa Dara wrote:
> [Srivathsa]: Isn't it a bad idea to leave the filesystem like a way it is
> with a journal error. Because journal is not working as expected, we
> might run into some trouble in future.

The journal being in an aborted state is part of the expected design. It
implies that the filesystem accordingly should be in read-only state.

Anything else is a bug, and you'd have to be much more specific which
exact bug you're trying to address. Resorting to panic is simply
obscuring any potential issues that may actually need fixing.

> [Srivathsa]:  Switching to read-only and self fencing affect
> performance in production systems.

How so? Again, please elaborate with specific technical details.

Regards,
Anthony
