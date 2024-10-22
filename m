Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BF71BDE6;
	Tue, 22 Oct 2024 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729556752; cv=none; b=Nn1S4NMREB2iUaTSatMMT27qiZA7tTk0yAiwppnedkSDQypEBhPnxN79/+ehVY6TccQyBXSk+PpMrj3KAb99saeJSjsSn/bopfYkPvfqccGAnTFEoYM2R4m/ti1o8UToGiT6fEIFNfktXZRab54Z3VYCzbF8H9UKc3jj0XbtzdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729556752; c=relaxed/simple;
	bh=+dQEqyR1FwmTFvq/RxzO/cnLV1+2Py1q3UpkJBRDW+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pWi/8gshG8Tn8MEhTh03YuBoOsNoWzaNQOMJnu3pdCdv+KGXWy+gfKMYwWX40muuzOXykrYx0nAMUxKE+NfNXBTomDZI8FEH9BJTv0VInXc0+KlVlbYZ0cq7K2c6m0k4pO0dLLPJA0/fyAAeM8pUh4cNSbyWtv6GJfszh7wMtcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TuXXxyim; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TuXXxyim"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=Dtc7LdzxqLP/AAZKaGDFqbUfwMnenAfL2h3IaUrggsY=; b=TuXXxyimsJ8g6/sN
	MDYAvzntpb4A6j9S7rXcoEC7S1YzvRjEneesBdjI6CROncqZGMK0/NbsugZkfItdbZyYcXD1Yl+bw
	z2C1/b2L1QdiyQLl3eCchYAr/w7mqR+GG4Nd2kmbX64ucI/4Nz5/P+1eX+mCA3fmvNTDfR1Mv4+jk
	slqXP7gKvNfC4qZrppjNF5r34EW2qoOjXNpZf1xGDFphOH2hG8o1qwous/Qd4eKH5p91hT32uz85P
	UUiI0P2TwswvIjJOC1+jHXfpyRqIfDD8YSif4RcBUj7pXab2KUTCeOt8Qoe2XpOh97a9rIkOnk6Wt
	TrrdC8cYuBLwXLHWFw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1t32iV-00CeIJ-2l;
	Tue, 22 Oct 2024 00:25:43 +0000
From: linux@treblig.org
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] ocfs2: Remove unused errmsg function and table
Date: Tue, 22 Oct 2024 01:25:43 +0100
Message-ID: <20241022002543.302606-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

dlm_errmsg() has been unused since 2010's
commit 0016eedc4185 ("ocfs2_dlmfs: Use the stackglue.")

Remove dlm_errmsg() and the message table it indexes.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/ocfs2/dlm/dlmapi.h   |  2 --
 fs/ocfs2/dlm/dlmdebug.c | 53 -----------------------------------------
 2 files changed, 55 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
index bae60ca2672a..847a52dcbe7d 100644
--- a/fs/ocfs2/dlm/dlmapi.h
+++ b/fs/ocfs2/dlm/dlmapi.h
@@ -62,8 +62,6 @@ enum dlm_status {
 	DLM_MAXSTATS,             /* 41: upper limit for return code validation */
 };
 
-/* for pretty-printing dlm_status error messages */
-const char *dlm_errmsg(enum dlm_status err);
 /* for pretty-printing dlm_status error names */
 const char *dlm_errname(enum dlm_status err);
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index be5e9ed7da8d..e9ef4e2b0e75 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -164,59 +164,6 @@ static const char *dlm_errnames[] = {
 	[DLM_MAXSTATS] =		"DLM_MAXSTATS",
 };
 
-static const char *dlm_errmsgs[] = {
-	[DLM_NORMAL] = 			"request in progress",
-	[DLM_GRANTED] = 		"request granted",
-	[DLM_DENIED] = 			"request denied",
-	[DLM_DENIED_NOLOCKS] = 		"request denied, out of system resources",
-	[DLM_WORKING] = 		"async request in progress",
-	[DLM_BLOCKED] = 		"lock request blocked",
-	[DLM_BLOCKED_ORPHAN] = 		"lock request blocked by a orphan lock",
-	[DLM_DENIED_GRACE_PERIOD] = 	"topological change in progress",
-	[DLM_SYSERR] = 			"system error",
-	[DLM_NOSUPPORT] = 		"unsupported",
-	[DLM_CANCELGRANT] = 		"can't cancel convert: already granted",
-	[DLM_IVLOCKID] = 		"bad lockid",
-	[DLM_SYNC] = 			"synchronous request granted",
-	[DLM_BADTYPE] = 		"bad resource type",
-	[DLM_BADRESOURCE] = 		"bad resource handle",
-	[DLM_MAXHANDLES] = 		"no more resource handles",
-	[DLM_NOCLINFO] = 		"can't contact cluster manager",
-	[DLM_NOLOCKMGR] = 		"can't contact lock manager",
-	[DLM_NOPURGED] = 		"can't contact purge daemon",
-	[DLM_BADARGS] = 		"bad api args",
-	[DLM_VOID] = 			"no status",
-	[DLM_NOTQUEUED] = 		"NOQUEUE was specified and request failed",
-	[DLM_IVBUFLEN] = 		"invalid resource name length",
-	[DLM_CVTUNGRANT] = 		"attempted to convert ungranted lock",
-	[DLM_BADPARAM] = 		"invalid lock mode specified",
-	[DLM_VALNOTVALID] = 		"value block has been invalidated",
-	[DLM_REJECTED] = 		"request rejected, unrecognized client",
-	[DLM_ABORT] = 			"blocked lock request cancelled",
-	[DLM_CANCEL] = 			"conversion request cancelled",
-	[DLM_IVRESHANDLE] = 		"invalid resource handle",
-	[DLM_DEADLOCK] = 		"deadlock recovery refused this request",
-	[DLM_DENIED_NOASTS] = 		"failed to allocate AST",
-	[DLM_FORWARD] = 		"request must wait for primary's response",
-	[DLM_TIMEOUT] = 		"timeout value for lock has expired",
-	[DLM_IVGROUPID] = 		"invalid group specification",
-	[DLM_VERS_CONFLICT] = 		"version conflicts prevent request handling",
-	[DLM_BAD_DEVICE_PATH] = 	"Locks device does not exist or path wrong",
-	[DLM_NO_DEVICE_PERMISSION] = 	"Client has insufficient perms for device",
-	[DLM_NO_CONTROL_DEVICE] = 	"Cannot set options on opened device ",
-	[DLM_RECOVERING] = 		"lock resource being recovered",
-	[DLM_MIGRATING] = 		"lock resource being migrated",
-	[DLM_MAXSTATS] = 		"invalid error number",
-};
-
-const char *dlm_errmsg(enum dlm_status err)
-{
-	if (err >= DLM_MAXSTATS || err < 0)
-		return dlm_errmsgs[DLM_MAXSTATS];
-	return dlm_errmsgs[err];
-}
-EXPORT_SYMBOL_GPL(dlm_errmsg);
-
 const char *dlm_errname(enum dlm_status err)
 {
 	if (err >= DLM_MAXSTATS || err < 0)
-- 
2.47.0

