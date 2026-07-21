Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14610404BC7;
	Tue, 21 Jul 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656562; cv=none; b=kk9M5y0h7r9IxbbNqO3rrvKI7B/w32mnfstBp2hZwWhxzfY3S9y+JOZTNZD1cwofdVNIuiviGBuc77JpMpvWSNYFjNNwJLD/pdTQFwLyhepPzdkfwSuFeQccGa8EPwsLwnf2vzfaS/WUl09z+oWL5DewrQnPJXy00H4+JxxMAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656562; c=relaxed/simple;
	bh=AykgVZf5L06/XliHEcDhuyj7UCJcbyTr4gU3prB8xdY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CPnfSlxIR9D4pAgWje3/MJ1tSg7lCq3QMONUHivZZIHTcn7xh7RfnFDMcaYiQBTR7viTgZtiokF4+agJ3t0UF5b7IJ2g6T1OS5RtS2k2/NhFWljTtKmXprXSQeCJpJpX4uyRO3fWPfGzVSfgSozFkGczUhhE2ZZXzY2DijnU27U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y0JRss4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y0JRss4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2EE1F000E9;
	Tue, 21 Jul 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784656560;
	bh=bMXL+4AOCXFZrmgHwrbcnVVlfNgRcnx/oyg2P866hqM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Y0JRss4S7G0jirXsd7HJQIG06ohLJ0Fqwa+8ZgkQEIA6/cf0Wlh+4sNJwGL9Gph9p
	 exITIj1VFoVYT4gchsq+WUj49kjjXOrtxP0KUPJNsehvHI/xO0YlWyoow1onDTGXks
	 uz4NliXMXgm/ZI/5Ix8eAyvuonc1GGPQfIat259Q=
Date: Tue, 21 Jul 2026 10:56:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: cluster: don't sleep while holding
 o2hb_live_lock in o2hb_region_pin()
Message-Id: <20260721105600.4b9532cb049ea1add5e671f6@linux-foundation.org>
In-Reply-To: <20260721114916.2098617-1-joseph.qi@linux.alibaba.com>
References: <20260721114916.2098617-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Jul 2026 19:49:16 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> o2hb_region_pin() is always called with the o2hb_live_lock spinlock held
> (from o2hb_region_inc_user() and o2hb_heartbeat_group_drop_item()), but it
> calls o2nm_depend_item() -> configfs_depend_item(), which sleeps: it pins
> the configfs filesystem and takes the configfs root inode rwsem. Under
> CONFIG_DEBUG_ATOMIC_SLEEP this triggers:
> 
>   BUG: sleeping function called from invalid context at kernel/locking/rwsem.c
>   in_atomic(): 1, ... name: mount.ocfs2
>     down_write
>     configfs_depend_item
>     o2hb_region_pin
>     o2hb_region_inc_user
>     o2hb_register_callback
>     dlm_register_domain_handlers
>     ...
>     ocfs2_dlm_init
>     ocfs2_mount_volume
>     ocfs2_fill_super
> 
> Rework o2hb_region_pin() to pin one region at a time with the lock
> dropped across the sleeping call: under o2hb_live_lock find the next
> eligible region and take a config_item reference to keep it alive, drop
> the lock, call o2nm_depend_item(), then retake the lock and record the
> pin. The config_item_put() is done with the lock released as well, since
> o2hb_region_release() also acquires o2hb_live_lock and can sleep. The
> region list may change while unlocked, so the scan restarts from the
> top after each pin. Local heartbeat still pins only the matching region;
> global heartbeat pins all eligible regions.

Thanks, I'll add cc:stable to this.

Sashiko might have a found a couple of pre-existing issues in there:

https://sashiko.dev/#/patchset/20260721114916.2098617-1-joseph.qi@linux.alibaba.com
