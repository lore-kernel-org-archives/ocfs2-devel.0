Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96E815573F
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Jun 2025 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716657; cv=none; b=WfAcssdIJLftetSWX1R/kpkDckXFP0HO1xRTZRV1PVTiImktdGZYdqW5tsuUVmRoUm1TNldW67cyPDaPsMX77QVp4iWkrI+gMjVkUsBAbToalneaeLDGP1WOXvboHxAqi8srL1e9TRXh7m6xan0KwrD/gY0HQStwRiuwX9n4iPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716657; c=relaxed/simple;
	bh=SUrp3msHj7f/1K8NVabxBLrjZqVDuoc++exdCHaZbnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyeVpEDQRfFBxb7iUbMD/vuYlBwxEmiTUNIp+9GaUPl4CnCOoaJcumURR1UpMCxVln/TgOF+ph2ShZiyPkExlIIHuIn1cGQmNoaUmmqqMoyMMO2M4aFsi8QkHpzpPiCCy2wMfT3RE20sb33hP+nUyQ5xfAVD7alvHckCVwSlOCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pjW7/Xsq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=v2p0fGS6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1CwuzBLR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NU+uJwWk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pjW7/Xsq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="v2p0fGS6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1CwuzBLR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NU+uJwWk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC69B1F7CF;
	Thu, 12 Jun 2025 08:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1749716654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTMTRD4bGFp407oNnvAExtTVyT2B4bJWP3/doMonz+0=;
	b=pjW7/XsqU5KiQEKFm91N5kjx4QNwlxF69Xj2V/Cj0Zzm9ixeJLe7Z4u7ZVyiXqOLNX595I
	DKaeaWEH5wXSJr1nxL2OJD3Ta1xFBwrAcmLlxYPUoVaz867oYO2N6DyULmPqT6jQuJZZDl
	I4kKbQJ2j3a14Q/QLcVc9KPop4HF6DA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1749716654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTMTRD4bGFp407oNnvAExtTVyT2B4bJWP3/doMonz+0=;
	b=v2p0fGS6Apg5Du3XvzhPAHm3IuRfXkP6tAEHJWR24SdvWtH578sW9vOlSfMR3ZlnUVyDoJ
	9DZtd2AApMmP8vDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1CwuzBLR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NU+uJwWk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1749716653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTMTRD4bGFp407oNnvAExtTVyT2B4bJWP3/doMonz+0=;
	b=1CwuzBLR6Tu8WqO+CB5lvY5kbwZW45uJlnJ8MbyRwL2PbtNEKTBlw+Kk+w12P02USAfJ9i
	neGKQl0zsSVjrOKQI4hAHfJBe6xaJmVaAuc9K8Qn6pfkhRwm+BR7H4cLAwbkwuyzJPtaR5
	9fnuZ528Qt6P7crDw4vV1tYHQgCtF0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1749716653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTMTRD4bGFp407oNnvAExtTVyT2B4bJWP3/doMonz+0=;
	b=NU+uJwWkuYUabiSHeSJLkCSLomc++IJcXQpCoRsOLyPpXc70qKcrNaLKJSJ/Ms06/aNZMu
	ckyIwVaMekRd5mCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDA87132D8;
	Thu, 12 Jun 2025 08:24:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4oXxMa2OSmjgLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 12 Jun 2025 08:24:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 670DAA099E; Thu, 12 Jun 2025 10:24:13 +0200 (CEST)
Date: Thu, 12 Jun 2025 10:24:13 +0200
From: Jan Kara <jack@suse.cz>
To: syzbot <syzbot+180dd013ba371eabc162@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, heming.zhao@suse.com, jack@suse.cz, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ocfs2?] possible deadlock in deactivate_super (2)
Message-ID: <vnghd7yksmrxs7whd5axkb3naty2ppyw5jprbfatec7xglz6yx@zwrfsuuky2yn>
References: <679f7c8e.050a0220.163cdc.002f.GAE@google.com>
 <68485d14.050a0220.33aa0e.035f.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68485d14.050a0220.33aa0e.035f.GAE@google.com>
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=170d968a88ba5c06];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	URIBL_BLOCKED(0.00)[syzkaller.appspot.com:url];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[180dd013ba371eabc162];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: DC69B1F7CF
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -1.51

On Tue 10-06-25 09:28:04, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit fcaf3b2683b05a9684acdebda706a12025a6927a
> Author: Jan Kara <jack@suse.cz>
> Date:   Thu Apr 24 13:45:13 2025 +0000
> 
>     ocfs2: stop quota recovery before disabling quotas
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123ce9d4580000
> start commit:   8560697b23dc Merge tag '6.15-rc2-smb3-client-fixes' of git..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=170d968a88ba5c06
> dashboard link: https://syzkaller.appspot.com/bug?extid=180dd013ba371eabc162
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d39b98580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fbd204580000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

Looks correct:
 
#syz fix: ocfs2: stop quota recovery before disabling quotas

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
