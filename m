Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4B72DCF41
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Oct 2025 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759840545; cv=none; b=MSs9dP+NFhcq/pWkSZWDAfpBy3B5VWfIPwBtU3mpoWZ0M5xVyGYFa762OWavtIPRiBjn63GF55VAyxLi1X39g3sADIWkTOn8UrGjoJ/Q9Vd6VCAKxRFXC0BH/iXQIy1v9mablw9AvD3VS97UwnON4oIAc5MZusmCgUZiBbS1tHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759840545; c=relaxed/simple;
	bh=ELJYoW6FOCHRifIsUfj1Fi6XF6ahiz6li36P0fRML/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EooGRnRAwFJFaXfaeDT5Mt5NAfOXM52VG4eUf0J5stX0H8S6xJBAKloVPceEa2uxTv42Caj81QoVWTovNPUiE+EHwHk+xXCv1BHqAGElu+NdQkdngMTkAfGI+h8RW+vDr7Fx47C5zzyUzH/K8lBko86qi3BhxJRA0ymkJMvGUOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=lxIJ4iTk; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="lxIJ4iTk"
Received: from mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:31a4:0:640:3040:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id C1C82C0110;
	Tue, 07 Oct 2025 15:35:37 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id aZk0bf9L8eA0-y0Nq3Ye8;
	Tue, 07 Oct 2025 15:35:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1759840537; bh=IsLI13Uf0Fi6adnErKNRKlvpHyskKzV7eStiNqOYyI0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=lxIJ4iTk4SrFHhnBXXwinPOwXs6MHaV5PwuS2REcxseMLdHFPwE4hUNHqG2GASIVP
	 ZDJOd+U+Miw0bz3ZkVZ2h+mFzVB8N1U/MwsoB7gCVHkycyQvLEgLnNltcdyN50i1vB
	 wxQGcsAtcSOiyFeHOdnoxMMxICxgyYQUVRFgLxUs=
Authentication-Results: mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: annotate flexible array members with __counted_by_le()
Date: Tue,  7 Oct 2025 15:35:26 +0300
Message-ID: <20251007123526.213150-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Annotate flexible array members of 'struct ocfs2_extent_list',
'struct ocfs2_chain_list', 'struct ocfs2_truncate_log',
'struct ocfs2_dx_entry_list', 'ocfs2_refcount_list' and
'struct ocfs2_xattr_header' with  '__counted_by_le()'
attribute to improve array bounds checking when
CONFIG_UBSAN_BOUNDS is enabled.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/ocfs2_fs.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index ae0e44e5f2ad..f7763da5c4a2 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -468,7 +468,8 @@ struct ocfs2_extent_list {
 	__le16 l_reserved1;
 	__le64 l_reserved2;		/* Pad to
 					   sizeof(ocfs2_extent_rec) */
-/*10*/	struct ocfs2_extent_rec l_recs[];	/* Extent records */
+					/* Extent records */
+/*10*/	struct ocfs2_extent_rec l_recs[] __counted_by_le(l_count);
 };
 
 /*
@@ -482,7 +483,8 @@ struct ocfs2_chain_list {
 	__le16 cl_count;		/* Total chains in this list */
 	__le16 cl_next_free_rec;	/* Next unused chain slot */
 	__le64 cl_reserved1;
-/*10*/	struct ocfs2_chain_rec cl_recs[];	/* Chain records */
+					/* Chain records */
+/*10*/	struct ocfs2_chain_rec cl_recs[] __counted_by_le(cl_count);
 };
 
 /*
@@ -494,7 +496,8 @@ struct ocfs2_truncate_log {
 /*00*/	__le16 tl_count;		/* Total records in this log */
 	__le16 tl_used;			/* Number of records in use */
 	__le32 tl_reserved1;
-/*08*/	struct ocfs2_truncate_rec tl_recs[];	/* Truncate records */
+					/* Truncate records */
+/*08*/	struct ocfs2_truncate_rec tl_recs[] __counted_by_le(tl_count);
 };
 
 /*
@@ -796,9 +799,10 @@ struct ocfs2_dx_entry_list {
 					 * possible in de_entries */
 	__le16		de_num_used;	/* Current number of
 					 * de_entries entries */
-	struct	ocfs2_dx_entry		de_entries[];	/* Indexed dir entries
-							 * in a packed array of
-							 * length de_num_used */
+					/* Indexed dir entries in a packed
+					 * array of length de_num_used.
+					 */
+	struct	ocfs2_dx_entry		de_entries[] __counted_by_le(de_count);
 };
 
 #define OCFS2_DX_FLAG_INLINE	0x01
@@ -934,7 +938,8 @@ struct ocfs2_refcount_list {
 	__le16 rl_used;		/* Current number of used records */
 	__le32 rl_reserved2;
 	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
-/*10*/	struct ocfs2_refcount_rec rl_recs[];	/* Refcount records */
+				/* Refcount records */
+/*10*/	struct ocfs2_refcount_rec rl_recs[] __counted_by_le(rl_count);
 };
 
 
@@ -1020,7 +1025,8 @@ struct ocfs2_xattr_header {
 						    buckets.  A block uses
 						    xb_check and sets
 						    this field to zero.) */
-	struct ocfs2_xattr_entry xh_entries[]; /* xattr entry list. */
+						/* xattr entry list. */
+	struct ocfs2_xattr_entry xh_entries[] __counted_by_le(xh_count);
 };
 
 /*
-- 
2.51.0

