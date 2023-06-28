Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934557E2
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 01:35:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD62A21879;
	Wed, 28 Jun 2023 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1687916146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=t5C1FqxbhDihTAvRsiJRCAZuV1hpcNCdAw+KOFRVobY=;
	b=VAeonAyzNDTcfWBYSd2QZ/vYiSxXduYwyskNrtOLFmJerUvqJCtHEFm5MIBCcjwnn66+Pf
	ZCpktB3/ysg0PygfQVCyLQrvDMaeIpSjNWDbXuLzAsn0JmwzmcJrQUBclC3Tj3G4t9Ltmv
	9MRAbh5p78nji3479CoaCv1kTy7E2KI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 716C6138E8;
	Wed, 28 Jun 2023 01:35:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id kedIF3KOm2Q+LAAAMHmgww
	(envelope-from <ailiop@suse.com>); Wed, 28 Jun 2023 01:35:46 +0000
Date: Wed, 28 Jun 2023 03:35:45 +0200
From: Anthony Iliopoulos <ailiop@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: ocfs2-devel@oss.oracle.com
Subject: announcement: ocfs2-devel mailing list migration to kernel.org
Message-ID: <ZJuOcTIxSK8VeTk6@technoir>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-ID: <20230628013545._iydzjK5myRAwnLRm7vVqatdvJHo0VzxLQnb1MEcr50@z>

Greetings all,

The ocfs2-devel mailing list has now been migrated to the kernel.org
infrastructure [1].

Members of the old list [2] are already automatically subscribed to the
new mailing list, so you do not need to do anything further (other than
potentially adjusting any mail filters to match the new address).

All the previous archives will continue being accessible at lore [3],
which will soon start monitoring and archiving only from the new list.

Henceforth, please post all patches and related discussion at the new
address [4], as the old list will be decommissioned.

I'll send out patches to update the kernel docs and related pointers to
reflect the change accordingly.

Regards,
Anthony

[1] https://subspace.kernel.org/lists.linux.dev.html
[2] https://oss.oracle.com/mailman/listinfo/ocfs2-devel
[3] https://lore.kernel.org/ocfs2-devel/
[4] ocfs2-devel@lists.linux.dev
