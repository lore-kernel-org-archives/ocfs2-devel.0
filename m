Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871180;
	b=PS83sVuiPB6r5hkhtXe9ax0WVLdnMfvRnfYhBRSwcem5oHl8aRmVYWJFFt294XIn0GEA
	 MBhHb/wwjBrrvHtAi44JIkhFqg/ofUm2cE2CO4Tf568k3M+2xdRhTBZqEwrbwXzbciN+Y
	 7ueBOKlW7gahCuNqBUT+XNuN/rkckyBlKyo4JorhQw5aqtqvMWgK6d6qKQ79MZ2lRSBV0
	 FBrrXZXvb7+jxhefEgkhK2rxsbKjweuCkIokFRgzWoiMwdIFM6USWAn1VCDwrJuL1UqlO
	 FBGxCNqnSJ+pq7IwBCSTpRBkrMsvxq6v4D9wItB+D2XCaUzK9ECrrKvbZ9dmGnB0ZLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871180;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=xI6ch27TNfax2941EofEbksH0BlyDUBn+BxE4p46isDhNJSpGj6vhLeSF2eb4diNkBZW
	 0nhA8yCtHHxi55lF89GoAe3DTmCZ2nZXWIpURw1PcJ43caHBwPorFdwFiL0itGLXKKV6r
	 /+deC58/80LZwuu+NUTJajVpz+IYJvK6LzcfhowRrPIMDWInoQEEYlzeBaAt3QC/D3+0C
	 Kkhtg0Vxv1O9dd71stMGCtAPNHXN3rjnzVa3rCiwxJ7IhfVoe8Wh7ms9kwa24RciO1Ksm
	 y5qAWcxpBXEuvZjOLhm2ZjhM/hnnp2PNK7mDxXwipC6hxguW/vKM42lIGQxpVIXeb3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37923606A328;
	Thu,  5 Nov 2026 09:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37923606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43A9421F5B;
	Thu,  5 Nov 2026 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793871178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=v14WN48bHlIql9h5HLTugaVISujZG1I/c68I+QtgBbLoIBApSEacYXXWBcqgCfJXFq6f+A
	a04b7rV9MZ+1A7GaOjZPNsUBb09L6OB9bhWH1gZyydPZAUwPj8q85pTy4SRbmwmJ76LAqC
	SSzXuvpaBX/SH14eaONLs8VdXTpBuaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793871178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=OvkNExNyUPYRAlVHRPqHODS9azrcpr+2lIkcR7gaa3TaHUtdVPDuCCR60na21ee4PYtMBN
	8FyqEylcSu5PIbBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793871178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=v14WN48bHlIql9h5HLTugaVISujZG1I/c68I+QtgBbLoIBApSEacYXXWBcqgCfJXFq6f+A
	a04b7rV9MZ+1A7GaOjZPNsUBb09L6OB9bhWH1gZyydPZAUwPj8q85pTy4SRbmwmJ76LAqC
	SSzXuvpaBX/SH14eaONLs8VdXTpBuaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793871178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=OvkNExNyUPYRAlVHRPqHODS9azrcpr+2lIkcR7gaa3TaHUtdVPDuCCR60na21ee4PYtMBN
	8FyqEylcSu5PIbBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 160DB134F4;
	Thu,  5 Nov 2026 09:32:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jQQAOUlN7GrMbwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 09:32:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9A6FBB666; Thu, 05 Nov 2026 10:32:57 +0100 (CET)
Date: Thu, 5 Nov 2026 10:32:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 31/34] ext4: use the generic emergency read-only state
Message-ID: <m2tpyczkdirf7z4pnidxf3375ykgs6mrybxz6aejffpfgptw26@vfepghgrvgdr>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[17];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Thu 29-10-26 17:07:22, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
> makes the filesystem read-only. The VFS then refuses modifications
> before they reach ext4 and reports the superblock as read-only like it
> did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
> and so do all of ext4's checks because they cover both states. ext4
> keeps showing "emergency_ro" in its mount options.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ae5ba6823c01..afbdbb607b14 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
>  	 * and other problems.
>  	 */
>  	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
> +	sb_set_emergency_ro(sb);
>  }
>  
>  static void update_super_work(struct work_struct *work)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
