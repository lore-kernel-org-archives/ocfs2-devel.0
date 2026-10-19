Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239A24825A7
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792390494; cv=none; b=gVTJewLH/RxlEF6jzKqnwQql/KZumfYirggUrFHrFP5HpeHVwCGXRyd4WBxDkQo/fiKWS/abfIo6ckXUiVJvlJr8H8GfI8i5wiTyco42wxfLyHm6SkTqp0f/Vy6eH11eVGKYIh2kKNJlDoAzbLRZCyACQbj8h1QA1cx+g4r5ypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792390494; c=relaxed/simple;
	bh=hLviHrUQcnY9d6Hs59o7A7DhG6hJV3vxIcScsJNeYyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDYP8HL8qyuh1lnz7lSpnoLFVjI+grYm+P155hpQSna2Xz8Y95PclxJbaCKCaMLFV+qTiI8OURf0A3clr6Z/6wyEO1MhHT2TEE/zjJr+3e9k2MZRhQM33Sy4CPJ6lHhSe5b1ASF7kNZy3crIVDUtlq42wRel5ZHqq3TLC9bUOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsAMJqf7; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsAMJqf7"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ccca948203aso543523a12.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792390492; x=1792995292; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=dsAMJqf7dGqTZbGxVwLIoUuVDVwEDvCxwVuBj5CI/eDj1bbHZ3NC9iHtp8dQdeyUbr
         Y8T5Bl2a51xi/U4+iwYIZNh604Og8hdoiFCLKPme5OrY5KbJYq7f/qniob0HFZ3JDiBR
         PRkktCBSlM9qzBUv2e55Gg3RtZxgGOorIodImuDB/ukDbvxB6C1kyJpU+yNx6lFaVeV6
         rdLkWonVPMZ+fvlJYyPRcscixnoKjIDPkYlZ6akbAtvdrydVEA9jnsT8CoUexgEHQ9T8
         +DXew2GxAp/YH2I/cZSUW4hdbweiQuP7rY1SCfZkiABYKwVYeonNksowNQXmCgmeXKq3
         rXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792390492; x=1792995292;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=UPEfsyJZ+jZY423woEkMjiP01NNEu4Mb6IrAu6GSg6KXG+iFj88AL1/3X3hR6hP/pC
         oYegzqNU7H5iobjYw0FoCxwr7vL1X8BnGfTFlkCdwaMs+t032D9Fk5d3yfbGac+KQKoI
         Li5AkrxqQqfdkR8357mMmbvzoGU65A6mmtuA1hpnLwcxQoy91xDkjmonYg6ef0WZYewW
         a2QP+sbgKcN2PXY5EM9W6hO6RsGlap32iDb5AJHGC+Ty+ZrvQYBKkIPs2au5w76K97gV
         +YPcjKhjN2YpZPr/LUFVxONq79j4HRzLMjRevsIwErS5/eyc8PBlvtQJxVJBcn7wdOUp
         QAXg==
X-Forwarded-Encrypted: i=1; AKwUvByk4Heto6yRl+dj7TfuGxcXxNmPTQCenGGZjaOrwGQoq/A0EIL0bSbsvYIPs/NEVGctFnutDNrF+Zdrbw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIIg6DHa0lomPmfWT6slRieBwKrgcYXFY9a4LCzAm1LnFJiB769
	S12iVXTlpgREczNLqrFRawAlMsUvPNcVl4UOa2CFyxUHbf0l5iYML52p
X-Gm-Gg: AYBFou1w43BNGyZQHuX1Jco7FuPYrxcfyo7I949xJcqtykiNP03Ueipb7c/TQPzLpuz
	rCLM0vsjul2ugVJZOAijTyzlKi5zLqsKNjeMat0ARRjVcm481R8iqmpjdFp9ZAHdiwJgPFQskmD
	xZ1slibskZE3q7G+x6dTQji8tV3LRVpmjqM0yN4VyrR1jGhkb1NM3meg8zepiueNzgwjKCZpVlF
	Gs3ZZeP5SvZeOM6DpiTwdzF2N2czf/xmlAjhhSixd0cE4D6+AykxmbnhSRcv0ExTDz0d4BErBe4
	/4tm5qLoDNu/6SaZzBa5z2LVRUbfwcfk2nNErU3tkmp6k1EPb1stsRv80uEtlHX7RM549qJ8Gpc
	2aEY1DTvziob/JWLZ1KHGFEKwY3AUOgtvfTLwsyqZ35ZHbPVF6TqcqVooHIo61Y/0Ms0pBwxw4w
	A4XC7241k1rERcipC5WRb7gN6fkpvdE9QlZWM+t0q8fK6NPcF3iQeV2QOLMJwp
X-Received: by 2002:a17:90b:3851:b0:3ab:c80:9362 with SMTP id 98e67ed59e1d1-3aceeea8f3amr5078332a91.35.1792390492104;
        Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94794dd9sm19035101a91.12.2026.10.18.23.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:14:51 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:14:46 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <atW1VhJXAIvtYPfd@hyunchul-PC02>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>

Hi Christian,

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 4066bacabe37..12ad2ce938ba 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -269,6 +269,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
>  
>  	ntfs_debug("Entering with remount");
>  
> +	/* Mark the volume dirty first if an error made it read-only. */
> +	flush_work(&vol->error_work);
>  	sync_filesystem(sb);
>  

    if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY)) {
        ....
	return -EROFS;

Before this patch, SB_RDONLY is set, so remount,rw returned -EROFS. With
this patch, sb_rdonly(sb) is false, so remount,rw skips the check and
return success even though writes are rejected with -EROFS.

I think that the condition should be test NVolErrors(), for example

    if ((sb_rdonly(sb) || NVolErrors(vol)) &&
        !(fc->sb_flags & SB_RDONLY)) {

-- 
Thanks,
Hyunchul
