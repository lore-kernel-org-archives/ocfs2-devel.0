Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2D23C8A1
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Sep 2025 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573584; cv=none; b=DKKOY12Gy/jq2icrvbv2jkGRmxxwEmwpK73qzQ2EYPHKYeCTfKMFQTYqq+K3xNEWOGekYxAlABBuD95pr3opsJobTiHzYDWoi0W6PY+Lsqf2J/n5s7R5yt2OlXXtpe/S3YzIBskFolV7eJ0EjUZsWZAvsP1C6ilO+y4vgQCazvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573584; c=relaxed/simple;
	bh=MosfAOPXggOaMXmK1NE1OB2KAznkuBaD9gE8puz8LQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNjxngR8VLHdgFgGJlvCrxsF84TdyJL0MeUIrSqlk1GwYQ1XycSdMSJvvpLukCEnQwgA3sqU5xFD5vbShwHa+hs7AMEWqliUYT1KWld++k9oQgXJjzGTRiPUzkHt7gk5IsFlKBMRGl4dH5XcpbSeXCKnIxVNoIGXACb4i5c0+VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M4tSS/Kr; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M4tSS/Kr"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77460a64848so266691b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Sep 2025 23:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757573581; x=1758178381; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmZdHMjW2ierOJlMW2a8YzsyJfuW1roryoxn9+9Fw3c=;
        b=M4tSS/KrMRhUdoYeM7pQeVhVnrlWn35OqlE00VWtJjLm0CqbgQJdKwBpWuCXH3VsfY
         235XtC9Jdj8g9CDbJ5+ZjuZRoHEpi8+tGE/8JK0nCBH3yYuq9bbDAmvlj0IWHm5xvrtT
         l77ELuyduXasuCDbGhAtMgqthk5+xR7/GLQp6qKhvf37n9g4JfMSlrWJSEFjaLV7V32U
         AS6ph3beZRjvz/eJrxP9pbihI2EbsxK9utrilao2gYT9jqx4h5Fcm2COiRSUFEvmyXAK
         zC68s/R9AjVae0cyOugcVqG6BsOqqvOPzp/YgZlG/ihBOd0jIQdu9hTmqkjRisI336Ng
         ySQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757573581; x=1758178381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmZdHMjW2ierOJlMW2a8YzsyJfuW1roryoxn9+9Fw3c=;
        b=KyisLe0sdkrkkdjScf+zF4u+QRwQQZ8WHl99NnS+MqF24DbKDdROywjcIL/LgjEzAs
         2UAohdKxKVqv01jJjYm1OfurgQPTnAiCopaqkM2whCLrjehx+jewRvemuusc+H5QxD3I
         VS5yqSBY4uXaq2AHkcfjxhwlpDgaFcbi0YBfX5AMLk5x0nAU7nE72hIcCuZi4HJz4g8J
         cH29gTIxkgurIJGLwXldpg1+h/1lsfHFAcJ9T232j14281fMK/D9h1TPsJ816TcpNB7w
         cSJ2Tsdwo54c/i0qGatDoQK0YnDcg00OckiFdfDedMJRTpRiJqtShf7aBN8fWC4B6Jr5
         LVSg==
X-Forwarded-Encrypted: i=1; AJvYcCVSPdXXbhmDg/aUljRJx0ZhvV1HFHOCZgCiCyqfyd6eK2w+sysAbogYl3fQxJrcwP+gq63kHcvP1E+U+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yze13QrndsWQ5I7JV2krswnKa9DbGq+8RD+udXXKTW8qZgKiipC
	b2hHDXlTuGyibX57Brco1C866fGT1P7S5Q4/hZfO4h2seUyCC2LI7PBL+wsYzHoeo+Y=
X-Gm-Gg: ASbGncugOG9OrJNwENEBxO4pfGyyOBgBvYG4v58/236EBd9ef/v767vrek2XCEMTbzf
	nVXTrx6ClVuPTrefUVcBCciJqSsztZT8FAeV0E5B+CthCwTRWL8oD1DhDulhnkvltkqXi4G5oTg
	NH/lq6b5GRYFqN9QUSR+kdWv38YpY3kuOPIcRbS2iviU0/OfT9bB29elDq2Z0Jr34wrI3Jad7Y/
	QDbo/VxrcekI3qi274qKy7+D/5J2lK9Jw9ZlCPMo4rKsHs0p8yU+G71PBnPV/pBAeRgaD6G1rMs
	laETXfkZUDs0pqfUXpg+OICG+b48vQs+irk2szm/pN/5yDhFYFZM0VBm0BLRPU0G4snes+u3dEo
	tAe9F8wdrquw+iHkLEmKcwUsOZxRRgAYACmfLqUN0lfpAAhGNJqtbg6iQLsK1rGP6FiLjvR+yPc
	8aLp9qpCzp
X-Google-Smtp-Source: AGHT+IGasaLzOYam5A1QsgyXdSjCVIvWR7XOAwof9JLu91tc4jZXAZZcaQdzlfPlVrkI/CXhO/i++w==
X-Received: by 2002:a05:6a21:6d9f:b0:248:4d59:93dd with SMTP id adf61e73a8af0-2534640cda7mr22645053637.52.1757573581062;
        Wed, 10 Sep 2025 23:53:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a387b5c5sm835488a12.34.2025.09.10.23.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 23:53:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uwbAv-00000000RJK-3hpp;
	Thu, 11 Sep 2025 16:52:57 +1000
Date: Thu, 11 Sep 2025 16:52:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] fs: hide ->i_state handling behind accessors
Message-ID: <aMJxydmz_azN7Kce@dread.disaster.area>
References: <20250911045557.1552002-1-mjguzik@gmail.com>
 <20250911045557.1552002-3-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911045557.1552002-3-mjguzik@gmail.com>

On Thu, Sep 11, 2025 at 06:55:55AM +0200, Mateusz Guzik wrote:
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

So why did you choose these specific wrapper functions?

Some commentary on why you choose this specific API would be very
useful here.

> ---
>  block/bdev.c                     |   4 +-
>  drivers/dax/super.c              |   2 +-
>  fs/buffer.c                      |   4 +-
>  fs/crypto/keyring.c              |   2 +-
>  fs/crypto/keysetup.c             |   2 +-
>  fs/dcache.c                      |   8 +-
>  fs/drop_caches.c                 |   2 +-
>  fs/fs-writeback.c                | 123 ++++++++++++++++---------------
>  fs/inode.c                       | 103 +++++++++++++-------------
>  fs/libfs.c                       |   6 +-
>  fs/namei.c                       |   8 +-
>  fs/notify/fsnotify.c             |   2 +-
>  fs/pipe.c                        |   2 +-
>  fs/quota/dquot.c                 |   2 +-
>  fs/sync.c                        |   2 +-
>  include/linux/backing-dev.h      |   5 +-
>  include/linux/fs.h               |  55 +++++++++++++-
>  include/linux/writeback.h        |   4 +-
>  include/trace/events/writeback.h |   8 +-
>  mm/backing-dev.c                 |   2 +-
>  security/landlock/fs.c           |   2 +-
>  21 files changed, 198 insertions(+), 150 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index b77ddd12dc06..77f04042ac67 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -67,7 +67,7 @@ static void bdev_write_inode(struct block_device *bdev)
>  	int ret;
>  
>  	spin_lock(&inode->i_lock);
> -	while (inode->i_state & I_DIRTY) {
> +	while (inode_state_read(inode) & I_DIRTY) {
>  		spin_unlock(&inode->i_lock);
>  		ret = write_inode_now(inode, true);
>  		if (ret)

This isn't an improvement.

It makes the code harder to read, and now I have to go look at the
implementation of a set of helper functions to determine if that's
the right helper to use for the context the code is operating in.

What would be an improvement is making all the state flags disappear
behind the same flag APIs as other high level objects that
filesystems interface with. e.g. folio flags use
folio_test.../folio_set.../folio_clear...

Looking wider, at least XFS, ext4 and btrfs use these same
set/test/clear flag APIs for feature and mount option flags. XFS
also uses them for oeprational state in mount, journal and per-ag
structures, etc. It's a pretty common pattern.

Using it for the inode state flags would lead to code like this:

	spin_lock(&inode->i_lock);
	while (inode_test_dirty(inode)) {
	.....

That's far cleaner and easier to understand and use than an API that
explicitly encodes the locking context of the specific access being
made in the helper names.

IOWs, the above I_DIRTY flag ends up with a set of wrappers that
look like:

bool inode_test_dirty_unlocked(struct inode *inode)
{
	return inode->i_state & I_DIRTY;
}

bool inode_test_dirty(struct inode *inode)
{
	lockdep_assert_held(&inode->i_lock);
	return inode_test_dirty_unlocked(inode);
}

void inode_set_dirty(struct inode *inode)
{
	lockdep_assert_held(&inode->i_lock);
	inode->i_state |= I_DIRTY;
}

void inode_clear_dirty(struct inode *inode)
{
	lockdep_assert_held(&inode->i_lock);
	inode->i_state &= ~I_DIRTY;
}

With this, almost no callers need to know about the I_DIRTY flag -
direct use of it is a red flag and/or an exceptional case.  It's
self documenting that it is an exceptional case, and it better have
a comment explaining why it is safe....

This also gives us the necessary lockdep checks to ensure the right
locks are held when modifications are being made.

And best of all, the wrappers can be generated by macros; they don't
need to be directly coded and maintained.

Yes, we have compound state checks, but like page-flags.h we can
manually implement those few special cases such as this one:

> @@ -1265,7 +1265,7 @@ void sync_bdevs(bool wait)
>  		struct block_device *bdev;
>  
>  		spin_lock(&inode->i_lock);
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
> +		if (inode_state_read(inode) & (I_FREEING|I_WILL_FREE|I_NEW) ||

-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
+		if (inode_test_new_or_freeing(inode)) ||

bool inode_test_new_or_freeing(struct inode *inode)
{
	lockdep_assert_held(&inode->i_lock);
	return inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW);
}

Or if we want to avoid directly using flags in these wrappers,
we write them like this:

bool inode_test_new_or_freeing(struct inode *inode)
{
	return inode_test_freeing(inode) ||
		inode_test_will_free(inode) ||
		inode_test_new(inode);
}

Writing the compound wrappers this way then allows future
improvements such as changing the state flags to atomic bitops so
we can remove all the dependencies on holding inode->i_lock to
manipulate state flags safely.

Hence I think moving the state flags behind an API similar to folio
state flags makes the code easier to read and use correctly, whilst
also providing the checking that the correct locks are held at the
correct times. It also makes it  easier to further improve the
implementation in future because all the users of the API are
completely isolated from the implmentation....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
