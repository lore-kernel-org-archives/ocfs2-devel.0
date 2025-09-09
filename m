Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBBC239E8B
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409253; cv=none; b=pdhmhGKCxxg8SGowaX8miDJS7HmiWXWUW2xIlW6xIX/co9teJtHmFTym8SznH4U5cYIEEehhACsjcbxkS54hXnVQ+Zmtr01LMCZTudRZ/FLJhpCCdUISo1th36GcLon5gBHTr0nu3299H4EhWuouQrsNUpHEp5TFkOn1Du4fSrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409253; c=relaxed/simple;
	bh=TYlBN9SWy6X1LN8X45cEXu8CIOiJF9kPJiuMRA9CPXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx/cjUgQBMRaZxZ5NfFy3Zc+15POHlIxuBAh+qJlJjxCIps1B+dYBuTbyEqQjSePZDRLGKtotQReOkdHrqhX1YEDHoIHCvEGps/4oEuRpls2hZ0PiRQc9EQnBHXpAj77eYSN4kcEVEH7vKF0AyiI55GAOIenO7kMBpj5dCzU76w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ohev1RPt; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ohev1RPt"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3dce6eed889so4256102f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409250; x=1758014050; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLviJGbVCxzfvbX4BT9S5ksTvNKxyPolWu16EG1Zpx8=;
        b=Ohev1RPtynfP1f//mar5KR+aD+qUBqWd0qznvdjRQBBVEk03WOLkFL686l5ASAFK8r
         65z47oQE1ZCfWl2s22bWfRCcezTjINWqpj2yAz+ZOvZ9VKosRK4VnfiS1lZEjnUIhDnf
         pu8/sstpz5MS/JwkYh+vKG5DfEsiP5KIcEQPktua2BBOdsRdmLB+3U6LAm9p6rawztbL
         aH/yMj+3Ln9GjKHIZT5ILVpXTqMQICJ/uL3Ma9uKOvrVTXA37+nmdTxOS/3phTcNQYdV
         6Ep7PVuBNQp+KTAzHli+gUarehpKLHwyC/8Fg2JPnfeOpolrhxS7iQRd7ODkfylpBUu2
         cRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409250; x=1758014050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLviJGbVCxzfvbX4BT9S5ksTvNKxyPolWu16EG1Zpx8=;
        b=rW/31mRnk7hg5ppJrh5tBpDLshCQ1eFTLEF9N2lRvtmslo82uFouWpzWNO6ICnDUgl
         uXFcX84lPjvjiwT31FCUXjgor1DOHqWX2iGUdll31R8K8JH/3/Ol8nUxHU4rnJdokfC+
         OV6fPk8QOX0rSrfL94j0c7PEWVBa4Jc+VHb6zA8A5U7dCR7zE+J4Izr8ZWkd/yaHVEf/
         PbYC9FkxrbjMJ9MxaX+AHyG5w3ku+iTx97EIqVDAVaWrpjc9kOz/uiVl6Yp0sdrCsKLK
         3/3P5QnvVochw1/D0JEOrjhQIwiYPH6cqXHCAZ83aF03nQxlKPEZE2JbWnNvmTekPK/1
         uTqg==
X-Forwarded-Encrypted: i=1; AJvYcCXpG7W3xJdP2DQ6xEaFLgr1/tRnx6RTZ4KKXR6S87DNoqrd7zFicyH44iOiBPPiI+PqSSC5LgwNXJa2LQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzly6nOqrz92UYoQx3HyEb3mzmGmZ07eSBmjIPWH+1xzZtYJGgD
	GmH72j/0BFSb6FUAczOo5pP+IXgr8wy7ChSQB0kZMjGVvbkerIQTCc4H
X-Gm-Gg: ASbGncuUtQjqr+lpeY3VXerCzSnOxLXlF4lP3olL2g3hqEKwg4iw7HbPlRfsq0eNzje
	/1Tem0lQFXOOdZSqje4SJkJe8IASfqt1hl6Hh9r7zLTdeANfS9JHHbCHQGd12sg8ty4i6aSmsnP
	nyLigGFrfkaqrP/VsylBrSgCph00mB2AdWAPOulwQT9T/aq65Cx91jcivQXMQ+vmR4Q42V0XKPT
	NQ2CygzH50zFX+idXDHPY+SsmZLKbPvk88vP7M+mFoSI/ivrSMJpjgOMPFrNQORpD4gLkmI3W0/
	B1vELcGp36kSHt7bqXdN1pCcN7kbCBAj40sgMn26lMwtnzfc3ZVJ61Xvj9p5pLd30GjjDMQsMNe
	K7cApL8/Y5UEbnbmbFXDUQLcnQ/S1Zq/iuzq1peiz
X-Google-Smtp-Source: AGHT+IHjsTfqM5PBGVR6UF94HDhLwfXTx/8ONN5qUE2vE5qVeIKFE1xIuEhq4NJqrwwdtIH9zK4Ugg==
X-Received: by 2002:a05:6000:2481:b0:3d9:dbe6:e613 with SMTP id ffacd0b85a97d-3e6427d8186mr9548204f8f.15.1757409249630;
        Tue, 09 Sep 2025 02:14:09 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:08 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 03/10] bcachefs: use the new ->i_state accessors
Date: Tue,  9 Sep 2025 11:13:37 +0200
Message-ID: <20250909091344.1299099-4-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/bcachefs/fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 687af0eea0c2..172685ced878 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -347,7 +347,7 @@ static struct bch_inode_info *bch2_inode_hash_find(struct bch_fs *c, struct btre
 			spin_unlock(&inode->v.i_lock);
 			return NULL;
 		}
-		if ((inode->v.i_state & (I_FREEING|I_WILL_FREE))) {
+		if ((inode_state_read(&inode->v) & (I_FREEING|I_WILL_FREE))) {
 			if (!trans) {
 				__wait_on_freeing_inode(c, inode, inum);
 			} else {
@@ -411,7 +411,7 @@ static struct bch_inode_info *bch2_inode_hash_insert(struct bch_fs *c,
 		 * only insert fully created inodes in the inode hash table. But
 		 * discard_new_inode() expects it to be set...
 		 */
-		inode->v.i_state |= I_NEW;
+		inode_state_set_unchecked(&inode->v, inode_state_read_unlocked(&inode->v) | I_NEW);
 		/*
 		 * We don't want bch2_evict_inode() to delete the inode on disk,
 		 * we just raced and had another inode in cache. Normally new
@@ -2224,8 +2224,8 @@ void bch2_evict_subvolume_inodes(struct bch_fs *c, snapshot_id_list *s)
 		if (!snapshot_list_has_id(s, inode->ei_inum.subvol))
 			continue;
 
-		if (!(inode->v.i_state & I_DONTCACHE) &&
-		    !(inode->v.i_state & I_FREEING) &&
+		if (!(inode_state_read_unlocked(&inode->v) & I_DONTCACHE) &&
+		    !(inode_state_read_unlocked(&inode->v) & I_FREEING) &&
 		    igrab(&inode->v)) {
 			this_pass_clean = false;
 
-- 
2.43.0

