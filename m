Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A1E1DED46
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736185630; cv=none; b=MPrNW4fdAMP2OSKGOyLtwxK/W7nDis9fwHoRLGKxME9SYP1Wwg2ym6ozCMyD0FD7UC9/ySZZg2QjPJmRx+08pMOBBDh/+H7f0npERMZ24fDrBQ8lyXxUviw52d4kObqRIwgM5fu46yepv6lZxlbyRjWwkfyiGjkbKrHqwlEp+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736185630; c=relaxed/simple;
	bh=a6kz5Tt/09AWtMtktdHp+XvDl7QFCYGVFrnsfJtJjdo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V32t3sf7BiILnVvWqfeP7DOD/bsYyuGbN00zHvtOKNsUlIbv/p+o/wh1/oa8YcAoMSYFmWjmD2j7dQXODnUyltpWU2MkT6wzzpRxnJDDCAe0h3SFKjVZZuzdlu6gMkMN3NKutmPO84D7UD0OTp9U5v0Z6x5btNVPwgahRlyEUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=N23hUi5z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OWnwgOt2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VG1M/1gK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0cbCyHFk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="N23hUi5z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OWnwgOt2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VG1M/1gK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0cbCyHFk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 741A01F44E;
	Mon,  6 Jan 2025 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736185625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCyexgqF3uhrsEN9aoYoz8ANXjITaW8yZ35u5rQfGTo=;
	b=N23hUi5zcH9kyUb9P9LbQrsmDtUGPSJfRbCL8H65C2etenyUhMLJSlbkLERG5qVxPHSTN0
	iNc56Li4+233AImA1w9qRKGmQsw8CqK59niNYfINqXZLjkBeMUOz4WwnUGsfxJCYHie3Pj
	zEZZAiqK785lhx+p0bn9kvknc9L3u7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736185625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCyexgqF3uhrsEN9aoYoz8ANXjITaW8yZ35u5rQfGTo=;
	b=OWnwgOt2GDd/1hmwZHAKn5+fCecucGxfkX2Z+eBg2aItARB1hsudbeH9ZWY/Hr6xfKi06/
	CeIGKNxgfIVkl0DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VG1M/1gK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0cbCyHFk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736185623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCyexgqF3uhrsEN9aoYoz8ANXjITaW8yZ35u5rQfGTo=;
	b=VG1M/1gKQTMWqWG7m5h1HWTOuHvlxiAd/QuQzNXv2rI9rJZaDeFcXPVNChkm2j6vBr4UWh
	CIFVqmfAoaFHvsZRsGcq2yU7SVwXOsRpULk2uVxUxe7dP9brm/ucSgYuAwic0qijreRu7O
	z+r5gz6fcQlFYtBqYfppTdhnxIjB1j4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736185623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCyexgqF3uhrsEN9aoYoz8ANXjITaW8yZ35u5rQfGTo=;
	b=0cbCyHFkWQkWUs5Oc0kD9SBkgIqUiCDYdGWnxCQGvP5OeUA9q7GG9z2m6tv7oRT9asCDHV
	TieFja2TOOM8+fAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43423139AB;
	Mon,  6 Jan 2025 17:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZfGbDhcXfGcXbQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 06 Jan 2025 17:47:03 +0000
Date: Tue, 7 Jan 2025 04:47:02 +1100
From: David Disseldorp <ddiss@suse.de>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] common/quota: filter out option projquota in
 _qmount_option for ocfs2
Message-ID: <20250107044702.7fb7edaa.ddiss@suse.de>
In-Reply-To: <20250106140124.91928-1-glass.su@suse.com>
References: <20250106140124.91928-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 741A01F44E
X-Spam-Score: -3.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon,  6 Jan 2025 22:01:24 +0800, Su Yue wrote:

> ocfs2 doesn't support projquota but does support usrquota an grpquota.
> For now, two tests generic/594 and generic/603 are for testing
> usrquota,grpquota and projquota. The mount option 'projquota' causes
> failure of ocfs2 mount.
> 
> To make things simple, just skip the tests for ocfs2.
> However, we can't just put '_require_prjquota $SCRATCH_DEV' before
> _qmount because f2fs and xfs need runtime after mount of SCRATCH_DEV.

All _require_prjquota callers provide a $SCRATCH_DEV parameter, so
changing the order and mkfsing / mounting to check support for f2fs and
xfs should be an option. Still, this approach looks reasonable too:

Reviewed-by: David Disseldorp <ddiss@suse.de>
