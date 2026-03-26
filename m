Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6038D018
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 06:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774508349; cv=none; b=DKcgwoUqa2UpOkaD5Jx9TJU1zRGzKQVmPv+Kt4KIGiMLjYEiFiM4ZqG+M2vFARKxLeNcFf9jUxT8vxyEjet3aEaI4Bd9fbAXpSW0QenpxantnvT7UFX5xon0NFbsRFwsUH6SYrpk7n9jvCFbI8wvwX14sXC4FOhG1dHs47fpdmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774508349; c=relaxed/simple;
	bh=53tbKULyOQRaVzS8QDdsC6bUGbeFbSBM0gzXSXlqSuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG50B5JXPbczD/7lN2X04xSPNlE4llPcHMrTDfb5Ft3TaRRv3iMwREnSjiF5zz/pNiHg/X8UqGLl7U0TkXPaQrS1WbNAAfrrrAFXtdHxZRW7njcjl4Cee0ox4fxCWFAkFKDYGMV/BXfcnvgKHJ2CYeZEpodYkE5stiXYIYn8caw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZbIltBn8; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZbIltBn8"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso306135e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 23:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774508346; x=1775113146; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDskmvXad++Rd5SeP2EifaqFOR5Jf0vKwAyNdeQTils=;
        b=ZbIltBn8webpooTm6KVa+0ojatrwNaepGxaYDhBjpdOXn2GWKmyowh/17H2RO0eMzx
         /vLZkr/BIASUaE4+Q8dXoNyMwdrQOSnzEJFWnLftTDGSTIXrgynGvUUb78A9tqfbPhD3
         UFGdnACjQ6OYC2yTxtBkeDUOnfUxpiLDJadCsQh5CwD6j4JzGam0esLlNElg7/ViWHIx
         6f/7CMc99YPSON/f5jakRGYWX7oCZe7kmh8vIfHqycVvp37lh2lzdYJEwp/af70oUuu6
         YRt4+AB3gUFAc1Fg1X1Op/RHp6NrjaAIK8xB+Ayx/feLcRpDM/clPOC8H+o65DuObGye
         bCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774508346; x=1775113146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rDskmvXad++Rd5SeP2EifaqFOR5Jf0vKwAyNdeQTils=;
        b=IkSf7aHS+xcK2Wgl3PgDsmkBnxGTTOcKGErb/6926SALi74T+rUTenE2vCJIXOGGuN
         Y3dz6g/bBo3ioDqZ0JEN4nww4flBWAQZxHxk+EgYw5DgErECSo+ckp3gPhyFZaYIIvSF
         dW0VBhqEIC38r7YSbwsrN/3J/ECnyotM0K4NkSH60KyNXHhTMvKEWLXRBDfCDKQYoMgN
         vDq0tD95HrAC5dobAqlb1roowkA9IWhIbBFxrBESH1p+y4+PDHciUoFfrUFN1d1ZL2rL
         uwz0hTTJs6TQGMjRUQz5EfyVYOAKLuLGPO4dI9HnGGeXNmGABtRY3UlxcUJZRsCGsGcx
         dl8A==
X-Forwarded-Encrypted: i=1; AJvYcCXESF1DSM2rwEIJMPSxlNF77LWH9OYaWjVx7T9fJ5fQTp+kS3A/Q937x0IMaLbqZzVbT/1eSwnFaSzcgA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxPnTrtlfFS2Blk5BtSbBl5gUm3KzhtWFCartgdyFBwND4ZP7if
	c7igRD8Vf1nXCcPVMAk+cquhOAGwwqE6LogF0NBV8/c+NsKBhSdy7UEX+lsIpuRL41A=
X-Gm-Gg: ATEYQzz9GE8OFgrbE+Gq9/pNN48fzqOQVRJVnyeMPV2v2shL3SgiPvnfAsYlmns5xAZ
	QLVu73CMbolx/7TjMhldog9ZyKx4JIohvt5v2fE0feGlln+b7fH4eM5niB7YbjcrZI3KBkFOVLl
	7UWpvsMokgbjfq2BFHgA59lGTxuEH2xDPThDI+5RNr1JQ/fYjpB5b6DYNW4jnS2stxTQ34UMeEV
	eIfTFvyBUP9PlYoDgGHD60OjVv/UMlhAfXxRwvJsYP9KYLuQXJ+0xPBxPYAuEDCR+xoXRu6/RxT
	Qp8XIA6nHyPWotahMgNCy7EmrooAEnHI92GdY3FgPawDAJZM/ZISJSgc/0BwCR3wJgpHwjOb8Q2
	kK8OWeawxkFFopdULqTFYjoovxvFHn+nfVfhvu0Izg5zfjjzBFbd3yk2TQwJCtOcvDaGhxAJuZx
	/iSKsg7TGGVwa/9OAdSt2+Ul/X4G9B4Zxsso2+
X-Received: by 2002:a05:600c:3113:b0:486:fb8a:fed with SMTP id 5b1f17b1804b1-487160b3d0bmr50797675e9.8.1774508345665;
        Wed, 25 Mar 2026 23:59:05 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8c4bd3sm20279875ad.63.2026.03.25.23.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:59:04 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	glass.su@suse.com
Subject: [PATCH v3 2/2] Revert "ocfs2: fix DIO failure due to insufficient transaction credits"
Date: Thu, 26 Mar 2026 14:58:18 +0800
Message-ID: <20260326065821.15156-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326065821.15156-1-heming.zhao@suse.com>
References: <20260326065821.15156-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit be346c1a6eeb49d8fda827d2a9522124c2f72f36.

With the patch "ocfs2: split transactions in dio completion to avoid
credit exhaustion," the jbd2 transaction is now restarted every
OCFS2_DIO_MARK_EXTENT_BATCH loops. In theory, this should prevent
credit exhaustion issues from occurring.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c        |  5 -----
 fs/ocfs2/journal.c     | 17 -----------------
 fs/ocfs2/journal.h     |  2 --
 fs/ocfs2/ocfs2_trace.h |  2 --
 4 files changed, 26 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 60f1b607022f..e58314c6506a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2332,11 +2332,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 				break;
 			}
 		}
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
-			mlog_errno(ret);
-			break;
-		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4c86a9d46870..7e7546e070fb 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -464,23 +464,6 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 	return status;
 }
 
-/*
- * Make sure handle has at least 'nblocks' credits available. If it does not
- * have that many credits available, we will try to extend the handle to have
- * enough credits. If that fails, we will restart transaction to have enough
- * credits. Similar notes regarding data consistency and locking implications
- * as for ocfs2_extend_trans() apply here.
- */
-int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
-{
-	int old_nblks = jbd2_handle_buffer_credits(handle);
-
-	trace_ocfs2_assure_trans_credits(old_nblks);
-	if (old_nblks >= nblocks)
-		return 0;
-	return ocfs2_extend_trans(handle, nblocks - old_nblks);
-}
-
 /*
  * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
  * If that fails, restart the transaction & regain write access for the
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 6397170f302f..9d4763f758ad 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -244,8 +244,6 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
 int			     ocfs2_commit_trans(struct ocfs2_super *osb,
 						handle_t *handle);
 int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
-int			     ocfs2_assure_trans_credits(handle_t *handle,
-						int nblocks);
 int			     ocfs2_allocate_extend_trans(handle_t *handle,
 						int thresh);
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 4b32fb5658ad..74b283875e17 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2575,8 +2575,6 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
 
-DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
-
 DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
-- 
2.43.0

