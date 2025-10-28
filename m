Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6AD212559
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761614074; cv=none; b=fq61b18/7ZR1qZ0eDoNwZOlfSStedGkKpNQMSqA5dIhGY0yKAmwItkjQJ2Usc5Qqu10GWIxaifTQrd5JFzmy+5eHHoXPm3EmIR7UDAUOMULXZmwsMBXzgDvnD7ANabcpl7AJ/4qUqfPmi53hTcCLoUVLVbsifTpipa6xuKgQjho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761614074; c=relaxed/simple;
	bh=qE/znF2A+COkF27PSsJV89ZhuAZKpPTVplbANqYuHPE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzMmmRkhbFkysd0m+EWb0/7U1COujAC5vleQz+Mhxlal9X+oj+Abg0zyES2ydYiOCvWjMxeQMH2KWp5A9abx5W0CmFh49whL5VWFYDGVls4EWvZRBFtPwBzePNBap5C0LiIXhx2mC3lNZSuF5yHongKVmNW90t9X4ZktZlVYMBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12D8A12A5E4;
	Tue, 28 Oct 2025 01:14:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id B058135;
	Tue, 28 Oct 2025 01:14:24 +0000 (UTC)
Date: Mon, 27 Oct 2025 21:15:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
 brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu,
 neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org,
 linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com,
 casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
 john.johansen@canonical.com, selinux@vger.kernel.org,
 borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 02/50] tracefs: fix a leak in
 eventfs_create_events_dir()
Message-ID: <20251027211501.1ec4940c@gandalf.local.home>
In-Reply-To: <20251028004614.393374-3-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
	<20251028004614.393374-3-viro@zeniv.linux.org.uk>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: emtbj1y1cju7g4shfpg13tdhnhs4nnwe
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: B058135
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19GTe7PKSAfAGlbt/zS4ZGC8rcOFjmyEK0=
X-HE-Tag: 1761614064-363610
X-HE-Meta: U2FsdGVkX1/G1h3gGfRooYvnXx3jiT0AwrBONfXuKy3eeIhUbLFRGxNdBXPDpG/5ncnLD2Wi5bI2V9h+KPnTFqly0Q7VErHQu2q25ySYnNUny7DQWnj8sQCkkGfdWbi/bua2gd1Vg0frbF65fQ9/rH9lMpLN/+yjp/Vvtw1+ic2u+9OP9IqIBCHUSVaRSxDQRiidgj30RK844jt+AK/UFlJ9gl7wzbw6jqw/OkARt4qz2ow1hPKmVkDosJyejXNCzHhjgqGnoD0TuFx88/ym7PrOpd+IGQq4/krEZ6R626JFHE2nA2hzR9aU7tXEvFNqkK/yNMiujAAkUAQ+eodxQUyFYdHjihtmjcWI+LhUwkQvR3fTh7c3F1AI5fHutu/+k5BuP5JJRzbLX4ISmbC6rhojJVMm7lNjNjOrSwZtVdzqO+33uq5OHXe7VMnZNZ5zUTeXJ7349odfYLfXhL1Dfg==

On Tue, 28 Oct 2025 00:45:21 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> If we have LOCKDOWN_TRACEFS, the function bails out - *after*
> having locked the parent directory and without bothering to
> undo that.  Just check it before tracefs_start_creating()...
> 
> Fixes: e24709454c45 "tracefs/eventfs: Add missing lockdown checks"
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/tracefs/event_inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
