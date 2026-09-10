Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D44718F1
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789076845; cv=pass; b=c+KVCMLOTsLeU1gLhC4w6dAnGiGwgu8KYSsEngN5yItKsxCAiiDQO5nMeFS6WozWsa7R+yTTWa7N7B9cvIzqw/o+QxAXko3QHa65AXk3yJNR0DqYvsYYg29dOM7CxosFkKteAmERZiMfOrAsiZ73IkJ/6nVfiKgYwmVtcEpQMSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789076845; c=relaxed/simple;
	bh=MzvZV/XlleF9nFmoW3RU0rOHpGBzwcekn1hbt8ZFZE8=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=L19UezFxD5Y0PrYEqxOILodybOrV/5G1cm9fHZyeoRXZqLxw8xHPJsNkGeJcA4pacYhyCRvl/g3QEezQ7SG1TIm3N34XLXCHOaQxLPD+lAlkbkZMSMx6fcbQ5XmFcX8VIFYb54Hbrky6aRhE99SR6Z43mPit2rnMuD1BMwSN0h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=kNf29mCb; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="kNf29mCb"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c6so185137b3a.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 14:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789076843; cv=none;
        d=google.com; s=arc-20260327;
        b=WmBf6mMXxK7MujUAHeq7Xx4pIkW/0lJpwGKTJrdc+Vll/IW9mKcku0jDfS4/mTicYG
         922aBxOjY0mCTSB2FZALNWZwrbBlmomucYfBn5Kr6fpYPL9MMhd6fMSAtObdQfykAjZa
         OhfFQ9AAAfo/YH4hHas3WZPpJ2S7UClf8/RzuKDaeoIJWd4erWeUZCbtFF2Ft580K57E
         Gkx401r8xg5Nc0kEPusZi/liz+P95Qn5gop09JY4kag96GPiZL0npzNM6k3WsqmNo7aG
         1Sf13Lcx0HleHJov9EN2VBNpkifg5PTKohGWsTN+l9YIEbyR8ZxyyaJrZxNRcRPpHCU+
         zYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=Dl/lrjIBKTQVv+jOBrTw+8RbI9HTEQP7bOs7FBwNKco=;
        fh=Sc8By0JmdrElFQHOGFdSy48FLyratISq9mm3FWhr9wI=;
        b=tBvKbDgdZ773XUr1Y4kckyCQxDt2DAHk2wLngGS3bI7ZAB3GYMRIYWtfOIfkAyAYwx
         avLQAqf7+UoXGkfa4JAIqWpP7RDdm6KGmOZ2C6WhuJyvv/7wrL1tIDSoy6tLFlMo2avp
         1E+N7knbCuQvbp2vvAvksPs/YImsHkmu3EDzS39sJIUD9kEOdWtp+oIvazRzs2g+vJ+e
         h1hf4ZRmu1pPiAM2/11zDf6tAKKnBdkKB/8Lc1qMV+TfONva+bVIX1wxbtkJENvNvXLM
         e/oZQjT4VzmnnOfOLa6Dy7IctKtz6c0xwBm+EoMAmlHzFNCrfS0qdA5Ac0u+omS0W7gD
         FoKQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789076843; x=1789681643; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dl/lrjIBKTQVv+jOBrTw+8RbI9HTEQP7bOs7FBwNKco=;
        b=kNf29mCbw1QszVlvW9HhL1f2nXQWNeONLRtz5f6oOi/zvmbLIOcb43AwbD2nZEPOBA
         i4O4U/IZbBpLcGMDSY/WFEZJY6RGQw+PfWbsOJNdCrmv4UjzyII7vlgNBLJYlgfaTFKw
         hsvXqybTYe43fDgM29TBnrGjxktXpCgmTD6GJ7HnJaPMCdIwZ+WJHqZodUHnFNvN4ucu
         FzWD+Jds5ZGt7ionpsUpdHsJ9ru0tpJOrA8l1LKm9Ora6ReJ384eXeFw05LTL1jCauaM
         3Kt4kg/JQtVlbk/QB2C9yYTAbO5vOsXq5NSaNSi4cEXU4PO9R3E/sBlnnCgTooyN6yPa
         Dkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789076843; x=1789681643;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Dl/lrjIBKTQVv+jOBrTw+8RbI9HTEQP7bOs7FBwNKco=;
        b=USpfoZbRpx5Dmje/pu4Z0mX54ASlfSEouKJLTZcupbkdZG3f1+4y17VNi4XOh84LAC
         bEbYmwlAz4MfXDJwonxSJk3YJCS3YGkFCP+5kB9q/pzR+kgOmLbsSq2DsCyV1A71Y0Yi
         PlFMpND2oBSfnfvnX1LyzrAHbL9ULyAZoJWET4RDk7Mx/pOCBBwsRx++HDRd1KwCpRrT
         zoWNX0Gj2a8oz0gxmixm/iTEj9oATTYbYENl4uMnparCctj3IQxdYFeWT5KRTTlr7Zh9
         yE1q2JAV+y5vAh9Z/SALUyPqtczzImgHV78LS31YiLgiV0iulLml1BA3J7iJbGSw29RN
         kbyA==
X-Forwarded-Encrypted: i=1; AKwUvBwT8pZVux3kOppCXFZlFMYf843MzyYEMRZyPwNXKa80EKidPXCEQTTF71oaorcdNn+QRm62AoQivKYFrA==@lists.linux.dev
X-Gm-Message-State: AFuF++m8DEpFxJOJ1rTIN1P2MqGcgZnoYVSR68LATWyRCULhfiRiXWXM
	h3kmig/tftlmYputT6HW15aCE+VCH4E0oI7LYaiMcy3M98PtanG+m9DErXDRFB1KbI78MZkwtEK
	OsBz5MC64iVJ3V0iBoS5ylPsglvLyT/EGdb/aim5K
X-Gm-Gg: AYBFou1JGVFr5HCUVUMUVsHdgKZRn0r1EMvZsAJyjCguHuDCEBPUKgN3uKGabVeoUbP
	IIKfaImrgSRQkjbN9q1vKE4W5aqiAcCm+z9xRBKNQhK4LmerPTwsrQcGMJgDvkARBfiNgiw5VEG
	EyaihZKowPRsFQ1ZgtmBaeJtT/fWMKJdEScB37al9ktUd/nP3vNLsWqdQ5YJ3kOVaapSHZicNyO
	yAHA/0GsmJ0sNhLskTY5EauZpOx8dUkcxklWVZhZM9zBsqALZR4kbCQ4EOBoP6unMg/2Jv5/2kM
	gB6FuSuEy+EV8vfxFSavENqC9rBgt9U+5z19ylDKwKkNHWhGZnBmqVptX9oVLqv3yOtHtwOcaOw
	SqHpwqap/c8U4NLR80obE9ZLiRvt6ZeDTzY5YE2Dcxfg=
X-Received: by 2002:a05:6a00:c4c4:b0:869:427:9b0b with SMTP id
 d2e1a72fcca58-86b30e0c7f7mr1052490b3a.1.1789076842087; Thu, 10 Sep 2026
 14:47:22 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 10 Sep 2026 21:47:21 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 10 Sep 2026 21:47:21 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 21:47:21 +0000
X-Gm-Features: AcwNN1UuNgE93mQmrT5ODw4YWg2HNZ_hxuHKP9cOZHTw5nScsf2TNLiEOtPKodE
Message-ID: <CA+0ovChT6BRXp0kntaJ_Eiw-2-z=fpofsvyALiwdORe3zG_YWA@mail.gmail.com>
Subject: [PATCH] ocfs2: don't let the root inode outlive a failed mount
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: falemi@asu.edu, ocfs2-devel@lists.linux.dev, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ocfs2_init_global_system_inodes() installs osb->root_inode before the
second ocfs2_iget() runs, and when that iget fails ocfs2_initialize_super()
jumps to out_dlm_out, which sits below out_system_inodes, so
ocfs2_release_system_inodes() never runs and the kfree(osb) that follows
makes the stranded root inode reference unreachable.  ocfs2_fill_super()
strands the same inode a second way: nothing drops the reference igrab()
takes on osb->root_inode when an out_dismount path ahead of d_make_root()
is taken, so the ocfs2_release_system_inodes() call inside
ocfs2_dismount_volume() cannot free it and the root inode stays hashed on a
superblock whose ocfs2_super has already been freed.  The reported KASAN
slab-use-after-free write hits an ocfs2_inode_cache object that
ocfs2_release_system_inodes() freed during teardown, so an ocfs2 inode
reference that survives that call is a lifetime error on those same objects
and not a bare leak.  Release the system inodes at that failing
ocfs2_iget() and drop the igrab() reference on out_dismount, clearing inode
right after d_make_root(), which consumes it on success and on failure
alike, so it cannot be dropped twice.

Closes: https://lore.kernel.org/all/CA+0ovCjAKQMn7iF8BJR-3+G9_HBRnRFtJxjr-9P9GuKSxFj+3Q@mail.gmail.com/
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
---
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -450,6 +450,7 @@ static int ocfs2_init_global_system_inodes(struct
ocfs2_super *osb)
 	if (IS_ERR(new)) {
 		status = PTR_ERR(new);
 		mlog_errno(status);
+		ocfs2_release_system_inodes(osb);
 		goto bail;
 	}
 	osb->sys_root_inode = new;
@@ -1110,6 +1111,8 @@ static int ocfs2_fill_super(struct super_block
*sb, struct fs_context *fc)
 	}

 	root = d_make_root(inode);
+	/* d_make_root() consumed our reference, on success and on failure. */
+	inode = NULL;
 	if (!root) {
 		status = -ENOMEM;
 		goto out_dismount;
@@ -1163,6 +1166,7 @@ out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
 	ocfs2_free_replay_slots(osb);
+	iput(inode);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
