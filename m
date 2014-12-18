From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Dec 2014 16:37:33 +0100
Subject: [Ocfs2-devel] [PATCH 19/25] xfs: Remove some pointless quota checks
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
Message-ID: <1418917059-23870-20-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

xfs_fs_get_xstate() and xfs_fs_get_xstatev() check whether there's quota
running before calling xfs_qm_scall_getqstat() or
xfs_qm_scall_getqstatv(). Thus we are certain that superblock supports
quota and xfs_sb_version_hasquota() check is pointless. Similarly we
know that when quota is running, mp->m_quotainfo will be allocated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 59 ++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 26070257fd39..8cb5090dcdbc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -410,20 +410,12 @@ xfs_qm_scall_getqstat(
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		return 0;
-	}
-
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
-	if (q) {
-		uip = q->qi_uquotaip;
-		gip = q->qi_gquotaip;
-		pip = q->qi_pquotaip;
-	}
+	uip = q->qi_uquotaip;
+	gip = q->qi_gquotaip;
+	pip = q->qi_pquotaip;
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
 					0, 0, &uip) == 0)
@@ -469,14 +461,13 @@ xfs_qm_scall_getqstat(
 		if (temppqip)
 			IRELE(pip);
 	}
-	if (q) {
-		out->qs_incoredqs = q->qi_dquots;
-		out->qs_btimelimit = q->qi_btimelimit;
-		out->qs_itimelimit = q->qi_itimelimit;
-		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-		out->qs_bwarnlimit = q->qi_bwarnlimit;
-		out->qs_iwarnlimit = q->qi_iwarnlimit;
-	}
+	out->qs_incoredqs = q->qi_dquots;
+	out->qs_btimelimit = q->qi_btimelimit;
+	out->qs_itimelimit = q->qi_itimelimit;
+	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+	out->qs_bwarnlimit = q->qi_bwarnlimit;
+	out->qs_iwarnlimit = q->qi_iwarnlimit;
+
 	return 0;
 }
 
@@ -497,13 +488,6 @@ xfs_qm_scall_getqstatv(
 	bool                    tempgqip = false;
 	bool                    temppqip = false;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		out->qs_pquota.qfs_ino = NULLFSINO;
-		return 0;
-	}
-
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
@@ -511,11 +495,9 @@ xfs_qm_scall_getqstatv(
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 	out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
-	if (q) {
-		uip = q->qi_uquotaip;
-		gip = q->qi_gquotaip;
-		pip = q->qi_pquotaip;
-	}
+	uip = q->qi_uquotaip;
+	gip = q->qi_gquotaip;
+	pip = q->qi_pquotaip;
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
 					0, 0, &uip) == 0)
@@ -550,14 +532,13 @@ xfs_qm_scall_getqstatv(
 		if (temppqip)
 			IRELE(pip);
 	}
-	if (q) {
-		out->qs_incoredqs = q->qi_dquots;
-		out->qs_btimelimit = q->qi_btimelimit;
-		out->qs_itimelimit = q->qi_itimelimit;
-		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-		out->qs_bwarnlimit = q->qi_bwarnlimit;
-		out->qs_iwarnlimit = q->qi_iwarnlimit;
-	}
+	out->qs_incoredqs = q->qi_dquots;
+	out->qs_btimelimit = q->qi_btimelimit;
+	out->qs_itimelimit = q->qi_itimelimit;
+	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+	out->qs_bwarnlimit = q->qi_bwarnlimit;
+	out->qs_iwarnlimit = q->qi_iwarnlimit;
+
 	return 0;
 }
 
-- 
1.8.4.5
