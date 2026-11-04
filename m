Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753392;
	b=xsvQJFLFDqTxU+4QIIU0qnZjZIHJJrIxuR4Ncrq9Y86GyDMUHB76N+roj2tAvJImStxO
	 3xF41g7XXJC5nugx/wedc5B4+P8hnhlApFwcDVmyc1uDQpBci1GPg8dBOmZ+LGBDybxMw
	 k5Nm6B09JgOI5CfEydtEcltZNZ0rKdlCSe3In5zqFSuOIHRBILFgx8QgdsZGG5Dku0S4w
	 ssuRT/bVAzpDfozmUFFTJrayKo7Mc5cVCYxwIM5xvi0F95JjG0xVoXAqyNpywykUrtRqf
	 IEaGYX56qftRM5J0J3u/kbKHkcJu4oUm1wEdD/HpZ5icyogHz8cmVK8U+n2P5QJjr8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=ABjDBvqCDeo/G1sZqlXyMMaKG2XN0hY4LVhO0dWWokEU6p6+NIgQUcM2kVvDKI+GX6Jh
	 BJOGCi1xfkhovrneLzgjzxFNwu1EzfvoU5gitMg7dS4pV+yQq69OFRMyOoms6SSB31Vp1
	 PozpCsArReDU6fcuav398jZV18YuOGS9Og8m/alu3A6urMA5W9A3OzozH1W6yCaN3a4Fd
	 ntxueFlWwFWHZ6/4KN4ne7XWWIDl4PFvBScsYzci5MzU6YNR3q8843FL9amK6AjL9WNSA
	 bVT3IOIAoKCihvy1SEkgTfrwYez4IhE8GkU58n4RzxQzfMYGqUzQ9LAzjUpV1L5grfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oIYlTqWT;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F8E606A32E
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28F8E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oIYlTqWT
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so87342a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=oIYlTqWT09/SUly5k7UaCud1EeaQUvC7RMvXrFBnHL1wmqCrj3MF89C/VXUkjUE4MW
         MziXsexG5bZFD8/5ww69ukE2+IAW6248QEOegXPgkb4laWmAWO0mwI0jz3EE+tEVQ1jb
         Cfr9y2L8ivx3OiRBLYdUWMaYuAzn99jgCpRFzDU+cms5tT+mfREViht1fwtzFR7BmEUY
         Dk03HD8TwkWYMwWGJyQBLSx0XZUUmjmvUNI1ma0gO7kyaeuiYFznEyfPu3/P2SGS2yTn
         k3zcFNcDDLBq0JsK+rJh9aCed1fQkIO/CZh4Uf65Jxl0PqAvIJq2QDcMVS3yE1w4mgt7
         yQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=RKovcnUZbVvjgEzQK1/ucXgX83nI98EYnRotb9k0qssnYYvR2BZP0Gh1paYB6T44jW
         hIDFfYFLgXdDWAfRefA3EXXdb62NKWtgl0DKvs2b/8+GsXJ7W0X+1jHN3HilUbE5boSh
         jWjxVjj+crmV8xcki88sPVHtUVXS68WSOKkokeJnQ1eSQkPg/tOvRSdyx7c9n497WdZS
         0Dw1t7duF0FwSg5lZz1NJOf+iJ0Fr+CD2pqdDpZFklmPIRcr7FKln+8+sHOKrdUMo+Hv
         FSt2Ur3ECPm1L0dkFpU5qera/zfFRgzqpHxaj9Dx6x9eGR+glbmgAvRt8AGjW0NSxgBi
         yuRw==
X-Forwarded-Encrypted: i=1; AKwUvBwJCk85fj+u0LKStmJNa9B7JU+dyLNQR7iCY874NPuiHZyKZ3Pudn9u13EjQ2Q0UTGRHDDNY9P4/Q3/Ww==@lists.linux.dev
X-Gm-Message-State: APuU4Z+9PunfP1Rt05t7g/gjQswh9rrs5LeeZ22NNmoGi6irQpgnVtyr
	gxpH8zwCP9A0yjwMpcOkLR8MDt1gMj85+XHyBnGeNsKeN+ahzwisp5+L
X-Gm-Gg: AYBFou2AN3SQZ4CbjyNgRHNKBDdaH6Ei5sqehJ8O5jVmj8FkcXfzyI0MZpf8Hppylo6
	HdXRPQXoxveNxZxsUx4VkCWX2O8t6mD6qbmWtIJmnOq4653qF2aa9O2N5dj0GrPVzjA/IY3RvkQ
	Xm9JA4pcTts0ViCxot4rLNpDkzUtJWoLzgxxkvJLE44eahQ2s7dHCQyVG8SU1A/OfYUH+0vg3lT
	N5F2s1ccvRSQo5zksfHliebf3gzH5uhbr26o8TGyfN/Xc3vk0ohicSloZZBofUl8jBRHZiVQlm1
	Iu1A22Ti+KB4Yc2cesi6gZm0qJ9pSHJYpQEEKE5G3sfvCSmfHkt8s0TiYCkcJ41sq7A/gShieUM
	/mTbvl1MWfO/c461jzfPIYpCNgNxZ0gq9gwFYcVV/bhqlMgl8U4qzS/fuevyZQxa79rREsLMgwE
	hwenPh7fzw35GWd0t+K8S/8u9iExOQYC0DUKd+xWYUH4UoKOYmXBQF0S5das138OEXFqDHup+7S
	bxfkh1EV52uA/5TyaG2xViNN4g7SAeg+GOxBCJwLphxMCiDPYfKKJ6itwzxGAglDKSrmKmHyxTu
	+/88eF8nnUXUV890MzL5BDiSukUeBf4W/C9E3YE=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
