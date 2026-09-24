Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA795457E53
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Sep 2026 10:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246248; cv=none; b=IS57a7veOBkH4FgFgh81uXzBMILuQLbAa2MKpWUPje/n3fUS1yuAMkpZgiAliooK4OpLAv5Tuo6/ERLrFg6MIl8zOt0877bYkDLHRTNdKPlz1w1oEL+4u9oZOdjflO4Lv+Io7r8dCCy3i1whCNrMxX+/E0y1qOlt4pcSfbZdHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246248; c=relaxed/simple;
	bh=KItYYmTb1hqzPFBT7AHYXiYDuHHx1H/geRCugysntMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmOrfPXPT5tf27K3zdidTqdfO6Bhng4puLHI7GaWz+L9UO7VjZ/K4oJognshhOqF9wn141BcTr1W5CDAUYl2d380uTNRADh+m6C3pmZA6exjZHlEeRAAL/8KEJ6rDo/KjaLJ7GOVVaQU3Y191EEU9nk7+aVTt05KhQBVvJ7FF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IoSQO8fb; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IoSQO8fb"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25bf832368so20197566b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 24 Sep 2026 03:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790246244; x=1790851044; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=34DvOH57h16Ry/MZtJV7+YneUNCdGFkltPA28JgRicA=;
        b=IoSQO8fbCJO+zHwMcsmnkbAuQQE5TavmMVM22Xhxi00FsG7VZSxUXSn+MaBUpvxgDG
         Lf1WmYIpW5yjnRBOYa+Z6Ab1LFnZyPGoxHOcs5psXFyUDct51p1NhAVlpJ7cQQ4mZnAk
         HamqhOB6Dm1XUQWly3BuGfSwZCxFWL0pN8yfMRrPBlo8WZCAvYEVqET1EMZXjRRwarwb
         fuWqIcgkMXw0z9tCwuvSLvujfVclz0ShHG/mRh6D0UOakjd+q48o8MWTeTSD8GPI981p
         KIKcuzpYV4Yt+mQ9iG4+YIDNLILT/twXHMsPJ5u6EyVlzLktTa8UrS9EC3mI429iMiUs
         ttWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790246244; x=1790851044;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=34DvOH57h16Ry/MZtJV7+YneUNCdGFkltPA28JgRicA=;
        b=dSMQuanDgzeKLgQPmCSxlPquralWIeqeEPwouma7qlFHHTIc+rhz64JaxH2mXJK6nP
         BHgBu4l6JgeR5A9nSWsDE+iImWbCSGr6zE1WjIgFPTp7bJmyJIGi89u77ULpHgtE7gpF
         ZAG9QDULljQvD7tZnwJYqzlFEDbnfNB0fnJKjIoUtpqD5vzHMpw7QhrdBTCm57WqH86w
         hHSWGlAHEu06Iaxsv4ZPr2SjgM+lzc5YBMWIdL0fdh831UWmrGBiCuJ1JI51tvdNWRpN
         OrBb+vNtfGZVBW2LONDPdJh5OCWfwAhGJvPRTcmHt2i5VBGtvRrx8RgKtiMk6POMnzPc
         dx9g==
X-Forwarded-Encrypted: i=1; AKwUvBzVBqbMIaA1RsUsyNmd1Nlt9yxVmfA889eHxF9Ya69PAzqft1sWfXOOt9HYpqY4wH768QdzJACM+B+07g==@lists.linux.dev
X-Gm-Message-State: AFuF++mtH0v2zdUYUvl8RCVP0lXEOsF7WL2Ez98rb3lV3tyMOPEz9iv+
	lMjtk7xDFyrlreaJbUVex7REgTO0CGV+/qUN7Q6L79rzBMCc3j9gYuELOIfSNSbfPHg=
X-Gm-Gg: AYBFou22c8L6USCYMCcTN/5E1jFkQa+ONCgwOb0LQZd8WDC/vtjP+SJ8Utx7/D53GPt
	3AiKNZwGRkMSortRJeMBj5mNzeBYhMgkDcjIpf5M53ID3hWpdSd7c5itN8CIBd/kp73gDKLxrm+
	uhg239SN5iCG2XPISvjnIfOWUvei24xnRsk5bOJ56HEjYbROgM7hRUqctjOdz6g56WkIh1OdKkx
	F0ufUydhHYSrfLQkiV9Xp2xHZU8UkFop7qFHpJ5S/NBqsLwvsUPPMv75XPo3L7zgSCNVLJ5RpkO
	DvJLEwkc6Wr4iMJ9hVo36yjgdnmoqh7dNuCjkwFk0lwblV5qX+E41vOT8GWXJAe3PuogdpDyS6+
	3rOYFCn/HF1VT5SPLlgJOYy/N+EepqQ6OCvXwlrOD9iqWkZZ1kutADUkp0pX4CP1tFJx6fwm0zc
	JvdgDTpZ6WO90jiPZ7rdsiLVTgcmebtlAmwG7IY9JIYyJeAtmx+VjmgcsSHmcMKXm+bArJ87RD3
	dGUeZs=
X-Received: by 2002:a17:907:6d13:b0:c24:908b:4e2e with SMTP id a640c23a62f3a-c2ac25a5a03mr172545566b.4.1790246244095;
        Thu, 24 Sep 2026 03:37:24 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc75f3f4173sm2449097a12.20.2026.09.24.03.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 03:37:23 -0700 (PDT)
Date: Thu, 24 Sep 2026 18:37:19 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>, 
	joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, zzzccc427@gmail.com, ericterminal@gmail.com, 
	ocfs2-devel@lists.linux.dev, christophe.jaillet@wanadoo.fr, linux-kernel@vger.kernel.org, 
	syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix use-after-free in o2hb_region_dev_store
Message-ID: <arT8GTxhKeGu6cAW@p15>
References: <20260904235710.16317-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904235710.16317-1-kartikey406@gmail.com>

On Sat, Sep 05, 2026 at 05:27:10AM +0530, Deepanshu Kartikey wrote:
> Concurrent writes to a region's "dev" attribute can race, letting two
> tasks both allocate/free reg->hr_slot_data for the same region and
> causing a use-after-free. Add a per-region mutex to serialize
> o2hb_region_dev_store() against itself and against
> o2hb_region_release().

Hi,

Did AI generate this patch? The commit log says "reg->hr_slot_data" should be
protected, but the code protects ->hr_bdev_file in o2hb_region_dev_store(), not
o2hb_map_slot_data().

Just code logic, I prefer changing struct mutex hr_dev_write_mutex to hr_mutex.

@Joseph,

I'm not very familiar with the heartbeat, based on the syzbot report, it seems
hr_slot_data needs protection. Does it make sense to fix this in cluster world?

Thanks,
Heming
> 
> Fixes: 1d3aa0b97c55 ("ocfs2: port block device access to file")
> Reported-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3025e3e8fc0b928af8f5
> Tested-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1c3def99bb07..6f03de1b6d4a 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -273,6 +273,9 @@ struct o2hb_region {
>  
>  	/* last hb status, 0 for success, other value for error. */
>  	int			hr_last_hb_status;
> +	/* Serializes dev_store() against itself and region_release() */
> +	struct mutex            hr_dev_write_mutex;
> +
>  };
>  
>  static inline struct block_device *reg_bdev(struct o2hb_region *reg)
> @@ -1616,7 +1619,10 @@ static void o2hb_region_release(struct config_item *item)
>  
>  	o2hb_quiesce_timeout(reg);
>  	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
> +
> +	mutex_lock(&reg->hr_dev_write_mutex);
>  	o2hb_unmap_slot_data(reg);
> +	mutex_unlock(&reg->hr_dev_write_mutex);
>  
>  	if (reg->hr_bdev_file)
>  		fput(reg->hr_bdev_file);
> @@ -1879,9 +1885,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	ssize_t ret = -EINVAL;
>  	int live_threshold;
>  
> -	if (reg->hr_bdev_file)
> -		return -EINVAL;
> -
>  	/* We can't heartbeat without having had our node number
>  	 * configured yet. */
>  	reg->hr_node_num = o2nm_this_node();
> @@ -1906,12 +1909,20 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	if (!S_ISBLK(fd_file(f)->f_mapping->host->i_mode))
>  		return -EINVAL;
>  
> +	if (mutex_lock_interruptible(&reg->hr_dev_write_mutex))
> +		return -ERESTARTSYS;
> +
> +	if (reg->hr_bdev_file) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	reg->hr_bdev_file = bdev_file_open_by_dev(fd_file(f)->f_mapping->host->i_rdev,
>  			BLK_OPEN_WRITE | BLK_OPEN_READ, NULL, NULL);
>  	if (IS_ERR(reg->hr_bdev_file)) {
>  		ret = PTR_ERR(reg->hr_bdev_file);
>  		reg->hr_bdev_file = NULL;
> -		return ret;
> +		goto out_unlock;
>  	}
>  
>  	sectsize = bdev_logical_block_size(reg_bdev(reg));
> @@ -2029,6 +2040,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  		fput(reg->hr_bdev_file);
>  		reg->hr_bdev_file = NULL;
>  	}
> +out_unlock:
> +	mutex_unlock(&reg->hr_dev_write_mutex);
>  	return ret;
>  }
>  
> @@ -2149,6 +2162,8 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  
>  	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
>  
> +	mutex_init(&reg->hr_dev_write_mutex);
> +
>  	/* this is the same way to generate msg key as dlm, for local heartbeat,
>  	 * name is also the same, so make initial crc value different to avoid
>  	 * message key conflict.
> -- 
> 2.34.1
> 
> 
