Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960613DE43F
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 07:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787902925; cv=none; b=If7NI/29N9FpdJBdo9S72VpDCWEFbq8t7sq2wcm/7YdcLFu2hzIAA693HDb6zYI66y5w5071/GnfMh8+iacE6umyNW5kKJpvIICWWbI2xtol54D+kXLMv2vyVerWcYBxsH+6NLYxnBqqchVA2tfZ+YZOWvXu/tjC0Ew1l7x3mJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787902925; c=relaxed/simple;
	bh=fsiviA7Tyk6WnmoBGpH6H7lFpVkB9xpLinZ8CKeHRZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mD/SfU+stw5Kv+CpsoOK5lVffiVwwDnjvHeZVLztibeWVbI07IyrTVdO5k4gsVw3XhoOPir5nnPSdL/ZXFsCZYVhTZZAd+AZlJzt5rYSBDI9PZNxtnK1tmOGiad3eHlzA8LnsLCHcCl7A8jxeOIh5FngAxr60bSQBUb+X1nv1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PkLVAdKB; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PkLVAdKB"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f502ff678so79700f8f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 00:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787902919; x=1788507719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QzzPfcrESMmXj4MeD1wijXaEhujYoS5NdXZGJYE9Z8Y=;
        b=PkLVAdKBHQj6FkV1bAylbzBgz/qQc2fCGzVeJinhmK5ru/Y2LXFhtVXM6BDwBPRDoM
         oFDl6DsLiEFoNCR+oIr5XDIQiV3zdKEHcp7oYrm9C3xPBGEO42Dq8lkXB0Gp9hZDKyv5
         +UbZ+P2G8bRaiRcYvewgH0Tiy46c2PY6G5Cocgd3jcaMmpV9Gxw+pb0bczkt8Y5dnWKk
         iD3PA6G1LXtAAq3jnrq8EgC/uSelaPsMXlJUM6VTl+lbi6K8b4XB3n/DtA3nLT8gFyQ4
         ugpwa+iaHufvQtypzjjmLoQFnQIC0CrsAIOyATAeC7dUccK7PCYQnBF2PAfoRj1fPG4O
         w0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787902919; x=1788507719;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QzzPfcrESMmXj4MeD1wijXaEhujYoS5NdXZGJYE9Z8Y=;
        b=doVO4HwBHR+dGzpsry+3D9OmsS44TSV/TYb9y8wEJsmYqFyo6wTzRk3+py5JqsxohH
         JTt88+rbUdUtXWhFleQXRYECcDWpsV2Mm+5G0NoB/iQ5E1OnKsX9+f2Zfio6TW2q4aLc
         B6MXApIeW2gI7gB2OFBkDNhHtC1UEO5E9j5gkP6Ts0CgqF6F+RUk9n2B3hlbDqQapb7x
         v+HocRUWeMU5qdeDOoZWuhFtKnXa3whX2GFF6iasqbpSRGtIZG2RpCfX72hRlT3xbbtH
         DELeO8j3nrK9tSOdTGsDVbreALGXzHuXZHtKdWXok5AhCgX9hjRIEPkTFvNCKZVOIpmv
         udiQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4rIPigDJy7SHu0Dfyb+y0a8/+A9Ge7raMTKqo6aW9yYtusTNXu4XMiS790ZcQVohD6t1403FgS8w+1w==@lists.linux.dev
X-Gm-Message-State: AFuF++kYtu4IOGwkLU4ZK91nS8hLfpMM47eLn+xlGO5P435JZI87vGm7
	PzEciZSpCABVg3KYgai5SBwNvBjIOT/AQlcGRc22Yp7JY3snh8pVMVxzY3u8kMN1zPc=
X-Gm-Gg: AR+sD13PZI5UjGVcfAjiDKN+fv0ZeM/OkTJbEXAq2tzGm2pJm1Ybnsu5Ye0dd8RjCMA
	3AjdzA0sCljp6KeTDwWhXSYCUmthDLbqaMFMHyDNK+dzmarjD2ZmvW0QKghNQd/oA40JmzGOxNd
	qwYnIjjf++75+0oHVrpnYvdTMKOkVCghTvGqMg3Tk8ZZ5hU8XXb0npOVF6oUEfuYfP/Hh08HcNK
	LDBzH2Mm9VHl81upIdTfWgrSDg+JTRM6UFxrDNohq/IENUjueW49vrVwHPKRVh4PzQpxxYLsnxE
	r6qxwBD9XwsrPA1ZwpLd0Vpd6thl2vQZYArlD/5qAvOCSwMxMwF+1bkuaRMTkfC5BalWY1rMtJW
	0khXC1+FfWrvaHWteXJL9aZQnWya14nPAmZG/Ua3m5H0Wwoc2Qk4aKFKb7VOQYr4vVbdWwYDQwh
	7PpgxjcBV6NZUM65ZMB0UE1s/wxJG/qoJE/wrd1RRXJcVBasRrFDk8hAyXEgY=
X-Received: by 2002:a05:600c:1f87:b0:492:4a7a:e415 with SMTP id 5b1f17b1804b1-49b91c41ca2mr36558795e9.2.1787902918749;
        Fri, 28 Aug 2026 00:41:58 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75963a250sm2998305ad.31.2026.08.28.00.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 00:41:56 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:41:53 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ocfs2: exit recovery thread on mount error path
Message-ID: <apE7j-pFxA8iCY7_@p15>
References: <20260828071553.262254-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828071553.262254-1-joseph.qi@linux.alibaba.com>

On Fri, Aug 28, 2026 at 03:15:52PM +0800, Joseph Qi wrote:
> When a mount fails after the cluster connection has been established,
> e.g. in ocfs2_mount_volume(), ocfs2_fill_super() unwinds via
> out_debugfs/out_super and frees the osb without disabling recovery.
> 
> A node failure event can concurrently launch the recovery thread, which
> blocks in __ocfs2_wait_on_mount() waiting for the volume state to
> become VOLUME_MOUNTED or VOLUME_DISABLED.  As the mount error path
> neither sets VOLUME_DISABLED nor wakes osb_mount_event, the thread can
> never make progress: the kthread leaks and stays blocked on the wait
> queue embedded in the freed osb, which may then be accessed as freed
> memory.
> 
> Fix it by setting VOLUME_DISABLED and waking osb_mount_event on this
> path so the thread bails out, and replace the plain
> kfree(osb->recovery_map) with ocfs2_recovery_exit(), which waits for a
> running recovery thread to exit before the recovery map is freed.
> 
> Fixes: f1e75d128b46 ("ocfs2: rewrite error handling of ocfs2_fill_super")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c62e389d4dd6..f785c39d1fb8 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1169,8 +1169,17 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  out_debugfs:
>  	debugfs_remove_recursive(osb->osb_debug_root);
>  out_super:
> +	/*
> +	 * A recovery thread launched by a node failure event may still be
> +	 * waiting for the volume to be mounted.  Set VOLUME_DISABLED and
> +	 * wake it up, then wait for it to exit before osb is freed,
> +	 * otherwise the kthread would leak and stay blocked on the wait
> +	 * queue embedded in the freed osb.
> +	 */
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
>  	ocfs2_release_system_inodes(osb);
> -	kfree(osb->recovery_map);
> +	ocfs2_recovery_exit(osb);
>  	ocfs2_delete_osb(osb);
>  	kfree(osb);
>  out:
> -- 
> 2.39.3
> 
