Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE01448F2
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 16:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181546; cv=none; b=ZlhpACHc6iDu+BaoIFDbhP+igrAeCCUlYn6l+e5bdSQwLuHYowcwV54p6EPtlmU1SqBNcIMLEC0NgyYSLSqX/reoIq0zBTk5dq8EFWGmwNHsM3hDx1btPAAmQHTEFgeTDAJ/kOKExpgSkEAOQDa4pmv5c7MgaJKinJM5n8lJhTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181546; c=relaxed/simple;
	bh=nB1y05bdXOoGc0aPE8FII4Zy5Ut0/giuu7njMUQQYLk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ccat7BjHRWZ4d1mya2jhjZ/PeHvvUHW0zqdiNYsM3FuqFx2mnUzHT8jaa2cvMKYOhQPJi93nSVKSwLbXD0lFEqbgv/AKmChiX7PEP/IORr1q8vF7fYucORyuHiczV4Z3ZQ2+6K/AMXMRs8cDNiHvRvFxD37/3CZcaI59L5Al8T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V2gDaA8j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oq+GBOKu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V2gDaA8j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oq+GBOKu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V2gDaA8j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oq+GBOKu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V2gDaA8j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oq+GBOKu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D454210F0;
	Mon,  6 Jan 2025 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736181543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AA4LnWZe7+LNISX2hMCqOdt/iD0bfXQvhkNExTrdtk4=;
	b=V2gDaA8j9yEK8yP/bdKQucDls/oM7e8fuxkOnBnBWxpCeB23YglLomHv58+XKd2cbHuvpj
	EBcdL323gGYb6ewOHhmOzVWDFKr1AVU/bAtNnksYXEe9oEoLd7BkAaXo50vV1mYbyPMvde
	F8n6gf/v2TJPFLPPxb+7/ivSh5E4+dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736181543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AA4LnWZe7+LNISX2hMCqOdt/iD0bfXQvhkNExTrdtk4=;
	b=oq+GBOKuDcSdwPTMc8AOt8ADCk9Bdb7oHsLevKa4Ql5vu7SijALM/dxtrrgdV0s3hiGS9t
	CQHDMh3S6lDQjYAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V2gDaA8j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oq+GBOKu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736181543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AA4LnWZe7+LNISX2hMCqOdt/iD0bfXQvhkNExTrdtk4=;
	b=V2gDaA8j9yEK8yP/bdKQucDls/oM7e8fuxkOnBnBWxpCeB23YglLomHv58+XKd2cbHuvpj
	EBcdL323gGYb6ewOHhmOzVWDFKr1AVU/bAtNnksYXEe9oEoLd7BkAaXo50vV1mYbyPMvde
	F8n6gf/v2TJPFLPPxb+7/ivSh5E4+dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736181543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AA4LnWZe7+LNISX2hMCqOdt/iD0bfXQvhkNExTrdtk4=;
	b=oq+GBOKuDcSdwPTMc8AOt8ADCk9Bdb7oHsLevKa4Ql5vu7SijALM/dxtrrgdV0s3hiGS9t
	CQHDMh3S6lDQjYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19EFA137DA;
	Mon,  6 Jan 2025 16:39:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n393BCcHfGdJXAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 06 Jan 2025 16:39:03 +0000
Date: Tue, 7 Jan 2025 03:39:01 +1100
From: David Disseldorp <ddiss@suse.de>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
Message-ID: <20250107033901.5da29524.ddiss@suse.de>
In-Reply-To: <20250106140104.91880-1-glass.su@suse.com>
References: <20250106140104.91880-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D454210F0
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi,

On Mon,  6 Jan 2025 22:01:04 +0800, Su Yue wrote:

> mkfs.ocfs2 is using 32bit journal as default.
> For 16T size device support, '-J block64' should be used.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  tests/generic/620 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/620 b/tests/generic/620
> index 3f1ce45a55fd..60e5a2cacdda 100755
> --- a/tests/generic/620
> +++ b/tests/generic/620
> @@ -41,6 +41,9 @@ sectors=$((2*1024*1024*1024*17))
>  chunk_size=128
>  
>  _dmhugedisk_init $sectors $chunk_size
> +
> +[ "$FSTYP" = "ocfs2"  ] && MKFS_OPTIONS="$MKFS_OPTIONS -J block64"

Makes sense, although as Christoph mentioned, a less test-specific
approach might be a better. E.g. _require_scratch_16T_support could skip
if block64 isn't configured, similar to ext4 (assuming tunefs.ocfs2
provides a way to query for it, which I don't see at first glance).

Cheers, David
