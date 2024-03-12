Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B2CC13C
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 04:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710217767; cv=none; b=QM8bR8GT/RrB6SDcO+kxDEdmrZK4KyAuK1an+VumIFv0PEY33sW4WSJF13fdpLBGNk0gwqdWcf8+5G3tLdBefxTxNdmizbW6iGA+hlafb92EL6dkXbAa1u7808bLopZV0iMhe/qwkAIASD/YUp24/nNwUU8hlI6+OVKlzo5F6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710217767; c=relaxed/simple;
	bh=TyNhIimBZSYtjnlKuRd1rlSvNpNsQfAEJhN5dTIcg5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Racx14aNn8DnrksGk7IfwSmfjQeXnfIJLShIByn1eKKTz6meKPpJ8sNeQ+NuqtcccuVvccer8N5jEcMz13P03w/8wK0q7fXWCRbnMI0+bxC9SAquzlsIWylXzCOQwYL+A58/EBe/ofIyIyNr+efcpI/QzIgEQ3v5CEf3FYJCMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KYXHOkxx; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KYXHOkxx"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d4141c4438so79013561fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 Mar 2024 21:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710217762; x=1710822562; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4mthZ80HfWhIaVuZTaVL5omvfPgV0dvkWSCXddT52iw=;
        b=KYXHOkxxLLxzFVyQc6K/WJW7uKkIKFi8iZjKDRA2M2/ljcKBX+37EFzrqbPsPmmP38
         hXseeg7IBKBOSeUJl7woK1H3pd+s/UFG5iiGCcE6mrGTzksgK4SaVF2/n52DrurV8K5j
         8YmB5scduBQRDLFpspK3r0Y8O5cFWnYURhETqMpZzNjPeCF09Zx+STNp51jt6RmNwngH
         K+ANS9Ucbq9JlfKEXvdXO7q225M0icXFDuUDjS+CAczQL+aElI4spogF6c8G0M+0KCmp
         3tpHWAP86XvFXbYkCmLRcsyBiuvWzsbhcmF/m3+CJB042HEqM3QMog8CNOkXhS+xI5g4
         teUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710217762; x=1710822562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mthZ80HfWhIaVuZTaVL5omvfPgV0dvkWSCXddT52iw=;
        b=wFay3dFw2bUS9x6vgwpA0SGSMJ+WBy0ikiCNS3zZWcEzO4HshHzPc+zldu3L1oyzwI
         v3r3jPHMK09Ae5goEGdhbDsYUh3zMUpTtx2oeuUgHXdmF7NpPO1UHjRdby/vXZPFH2MG
         sfvfVlAbCiIhKDZ/kuo+RTrylV1FVgA31OlThCAUydYCFbHV1Ywcl3DAwvULaumPFvP6
         iOKO+ZKwlwqfMUi80bYhrCaJi8Y1vrreTI/P4r5yAj7FQVrGM94TFol7eds/OWwPZ8v6
         MKInsbkx5VVUDRmFyPaxswSZ9vi0MyZ9Qak3PKN3FsPhEoAk4bBnNu/Uq2VTjdlcM5Kn
         AY3A==
X-Gm-Message-State: AOJu0YwM1Q+C9r5nUHY4OKKmUKOefSvEq+WaaRhiR8cc+HV7mktHSVO+
	oGV3M151ZaLU4mH0HMEEAoytx4vIZhfCUKXnCrJkoqeNUtGmoOTBTKf7vYmVbi03tT7uAV0Xz5Q
	Lp9Y=
X-Google-Smtp-Source: AGHT+IGucBYT2tm0SKzfx31C/NDTskA8d6IP4YT+QoOkHS60WvpHvrWjBSRy5IFqkZsFv9RkkVN3ag==
X-Received: by 2002:a2e:a0ca:0:b0:2d3:3305:c373 with SMTP id f10-20020a2ea0ca000000b002d33305c373mr4356891ljm.3.1710217762567;
        Mon, 11 Mar 2024 21:29:22 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001dc3ef7aa2bsm3095342plh.49.2024.03.11.21.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 21:29:21 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] ocfs2: enable ocfs2_listxattr for special files
Date: Tue, 12 Mar 2024 12:29:08 +0800
Message-ID: <20240312042908.8889-1-l@damenly.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

For special files in S_IFBLK/S_IFCHR/S_IFIFO type, we already
have ocfs2_setattr and ocfs2_getattr enabled.
It's confusing for user space if it can use setattr/getattr to
control one attribute appointed but can not list attributes
using listxattr for above type files:

$ mknod /mnt/b b 0 0
$ setfattr -h -n trusted.name -v 0xbabe /mnt/b
$ getfattr -n trusted.name  /mnt/b
getfattr: Removing leading '/' from absolute path names
trusted.name=0sur4=

$ getfattr -m trusted  /mnt/b
$

Fix it by enabling ocfs2_listxattr for ocfs2_special_file_iops.
After the commit, fstests/generic/062 will pass.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8b6d15010703..0da8e7bd3261 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2763,6 +2763,7 @@ const struct inode_operations ocfs2_file_iops = {
 const struct inode_operations ocfs2_special_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
+	.listxattr	= ocfs2_listxattr,
 	.permission	= ocfs2_permission,
 	.get_inode_acl	= ocfs2_iop_get_acl,
 	.set_acl	= ocfs2_iop_set_acl,
-- 
2.44.0

