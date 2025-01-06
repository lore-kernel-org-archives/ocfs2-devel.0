Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9479B144D1A
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 16:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181605; cv=none; b=rjFMo+OJZRnQmN+RJNdRn3N0vmi0bLRgpW4lTL9+hY9E1D/1vBmdVMbPTVpgG+X+xvCcf5X908Lmw5b15Wxk47enNW4j2xNETo60i9DyS5PBgCtw2RnTQ+la2y+Ell9CeMaY1cZm4aJD607RClEC/XiY7M9dnfvnXSQN3M/wO7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181605; c=relaxed/simple;
	bh=5UkRwpVRY/QvfhdipK9Bsi4F/V2eJLUoiGicVsCmatk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgMSCWICuZVTttjthASKQNxx5fEeTIgd499Jtkn0XO3j51wJxIsWWnn5JSQedHLNFaOh9qEOgooErtOgWGhdfJ/EEsmR2fuZYaFDjPjUnBqpV4vj0QQlQC1tGixVaQf/0hsY+XE5KiOLH2T29g73r+hyuViQoVFpAuCeqQnYnm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=re96L5Z9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8EimrhUo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B70P8aDs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xu7jdtIg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="re96L5Z9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8EimrhUo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B70P8aDs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xu7jdtIg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C81AA210F0;
	Mon,  6 Jan 2025 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736181601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oB3OJ/nQWsvA4cmDu2y+HMQeR0izhf5CuTsebjMkY4E=;
	b=re96L5Z92skhy+5KFO/EqxiuuGe2wbmgJ+G1MHvZShAOvOL2DhdbYeslxQ3UwjXE8+r4hu
	4bRDvmM6/qe8nmPDJfqIYiZVs26vnjuVEZ5qAzVbyFjliLg0TtB4TTz08/qGck+m63OjFl
	470nzRllNK0cUH7qjmm5yP1yJqQkk8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736181601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oB3OJ/nQWsvA4cmDu2y+HMQeR0izhf5CuTsebjMkY4E=;
	b=8EimrhUowRj/y483xWg5g6Iu7bpIUdYEdY/CEyWp8u15fecvZbUiCTV3eyiEhT5xhNTmdu
	k7l5cZyusLsBQTDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B70P8aDs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xu7jdtIg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736181600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oB3OJ/nQWsvA4cmDu2y+HMQeR0izhf5CuTsebjMkY4E=;
	b=B70P8aDsV9RSQXFCabsrBbmBnH6hSJlVIE+HedybBvKyjXhjTPRjnkvlQ0aTohc3fNGxKL
	Q9HieVPBfuP1Z6VfzzzPMpRRtC8pt18M3Ka+Malapp19rqWWFXfNwjFZnB6Hm2i1pZGwwD
	HRpiJLt6+2Q5a4dCYWiTud/ReKXm7E4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736181600;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oB3OJ/nQWsvA4cmDu2y+HMQeR0izhf5CuTsebjMkY4E=;
	b=Xu7jdtIguiYSkTbKYSevV0kGHDsNBFvydAG1Uu5g5IJwYeS94u6N++FOlKHv3CP5lUCXTb
	3njQDKhoLJzdmkBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97781137DA;
	Mon,  6 Jan 2025 16:40:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RXqJI2AHfGeIXAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 06 Jan 2025 16:40:00 +0000
Date: Tue, 7 Jan 2025 03:39:59 +1100
From: David Disseldorp <ddiss@suse.de>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] common/rc: add ocfs2 supported timesptamp range
Message-ID: <20250107033959.57c1cbb3.ddiss@suse.de>
In-Reply-To: <20250106140118.91905-1-glass.su@suse.com>
References: <20250106140118.91905-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C81AA210F0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-2.29)[96.68%];
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Mon,  6 Jan 2025 22:01:18 +0800, Su Yue wrote:

> ocfs2 supports timestamp ranging from s64min to s64max.
> Add it to _filesystem_timestamp_range then generic/402 runs.

Looks good.
Reviewed-by: David Disseldorp <ddiss@suse.de>
