Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA460C54EAA
	for <ocfs2-devel@archiver.kernel.org>; Wed, 25 Jan 2023 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AVY0BQ2uYVSHdgxG9D8M3pTa4Ir6l3545IYNGozC3jk=;
 b=Ep7X2QkZ9ziWkrtsxQgeGnKLfZKn2ua9wfW9W+PAJ4gN+gDWf1ooKwrNmMl8QeXusVHCbhNP/ql4
   ODE1g6sgFommIVvpSW5t1hj7EHKYGoAJlitIJCHQtxVjvdKnfWtrzrmw3osCYMoKYzp3wCcls7yt
   ooqrKCxEnsubskmvU1P0iZdCV80d4+9PlBCrdP45X6IjY0ld3IZVm79ZZHVILCsZWYlgR6qUvZj5
   0epi3jWVNm73SZVjJgbsw1haIwFboko6hCQPHf2fj7Bkvhl5xgViJu1KzdXRNxpzkfhWnrodYb4H
   0aVWTr8cX8+0BabTmT1Ecp8RSHZiMsLLIsiZ5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AVY0BQ2uYVSHdgxG9D8M3pTa4Ir6l3545IYNGozC3jk=;
 b=VDzKCWjOGTIENeTsRNMZxyNWQa8rN+Qlr39I6IzW2QXKVXpcsCDD2LKImaJ+jP61Ij2P96r0UDJt
   JLqiDWEXpbKAWfakNanEyiHUe7S/xOc4QcPKV3ONHxiKw6R9o1Sc5tvy9hg/+e0IdD7rxov0Nje9
   raSDjtbiHnHgqYZ7oNBbmms2ZjDevuxrYatcs8sgoydLqP18RPQtXOy7WjTITi+eamU7PEEoVO1n
   hD8TjI29S3a7J1xMSTpSdVDWUpk2drgQFkR+92a+lHxuBg+nCJuVxolE14UFv+iX9V2EufkNaiYn
   6lHuW81HiOLOIwNfTKAWqBEUnGazhcJFGX/eFg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP1009CKY0DIWF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 25 Jan 2023 17:31:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1674646187; bh=IOzssTgtK++UqVcJ5HUSWWFIaDrn43ndUjBrAjyFiaU=;
 h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
 b=dJV9+p9ePI3jx5JC9RvTtdzmW1bNqW1rsHe0cmGA6kJs92nv9sD5fIBkqleTFMBLj
 mYd6bQ6V/xxr3LaywZ7SXG2zALJFaZukjVImD/7wVfnjG/oHG1hUJ4FxL4k/PPJtGN
 ZlLquvMiwjZi1Rx/MZjfUORVlg9e76o1yEwZN4k0HhhmRzpUYrRJ1hIoLt7/xAmahk
 hTxcE2F3jcshpf4F97YK4cxgJOsvnvTFiZOW4ejFP3SkOum4XQHFhZpc0AU0sylydp
 AnvzLQ/MHW4pyUCigmxXVlRhUgbUs0uxvYsE7SyfhrbLF/zwI0PtZpNpGfJttcKN0j
 bQe613ufERfrw==
Date: Wed, 25 Jan 2023 12:28:55 +0100
MIME-version: 1.0
Message-id:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-10-6cf155b492b6@kernel.org>
References:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-0-6cf155b492b6@kernel.org>
In-reply-to:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-0-6cf155b492b6@kernel.org>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.12.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10600
 signatures=596816
Cc: "Christian Brauner \(Microsoft\)" <brauner@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com,
 Seth Forshee <sforshee@kernel.org>
Subject: [Ocfs2-devel] [PATCH 10/12] ocfs2: drop posix acl handlers
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Developer-Signature: v=1; a=openpgp-sha256; l=2847; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IOzssTgtK++UqVcJ5HUSWWFIaDrn43ndUjBrAjyFiaU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSRfFJr0gc14+e+JtjaTM+wZKpOMl6zUZWGsmHtpcsAxZ8v9
 ibETO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyTI3hf/2SS7sUq53Ft1/Yxb13td
 diR/E923/qrJ5telPw8MfzLNGMDK+KzdrWei9Iapx3QbfIZhNvzxudhO6W5ROs2t/9r/0rxg8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: TcwEwLQTOtl5C--jprQkp1ou2HPJzUFA
X-Proofpoint-ORIG-GUID: TcwEwLQTOtl5C--jprQkp1ou2HPJzUFA
Reporting-Meta:
 AAFhyCr5S/w4NbZ43ZvZT9uiODZEGZmrpRmHhU33MErYnL4c6MEeUBwlbi3mf7is
 5TLgigGsoLA5pC20rv14DRKBjQd1JD/Xc6oBEoMINy/LoaKOCfaqjO4HpbHagKl3
 wrGTSW3GUb5wVG0bAopW5EDPS08haY9pMRIua6uAjPQ0Od4+A3MnWX0akBVhj6Fh
 ej9Jj/h+NpFMVrgRcEUYCeoyccZah+1FIHk7H4DhTo3/Pwd075dSDQjvwXC78rGS
 aaEVGXzrMjxe2DE1XwC5p1aL7ZNz/mARyKKkGbNntT+F5LQDGEo2OCLwQoJLzANA
 Lc/W2w+HzLhap3EzeBw1upfwn1eKOQsdhI2dR8Q83EHUZkT3KFe6gpwTP6XSpgja
 +M4zwBr+Lyw6b1xxbh+L8+f0jb1bgJx9p1AmZtNciUtgIW6Sq6FCXyyuBVwdL9iV
 cys2AuuVt8TeYSPJdOgyUMNcXiSybDk9Sc4sDgoO+SFIiV2cv4EJNQ+WhlDzduPT
 p8pJaHNDywpauRRM9X5GJ+jyzYVlAcAo1b/ozMjHkdS0

Last cycle we introduced a new posix acl api. Filesystems now only need
to implement the inode operations for posix acls. The generic xattr
handlers aren't used anymore by the vfs and will be completely removed.
Keeping the handler around is confusing and gives the false impression
that the xattr infrastructure of the vfs is used to interact with posix
acls when it really isn't anymore.

For this to work we simply rework the ->listxattr() inode operation to
not rely on the generix posix acl handlers anymore.

Cc: <ocfs2-devel@oss.oracle.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/ocfs2/xattr.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 95d0611c5fc7..e55cd11d72fc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -89,23 +89,11 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 
 const struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
-	&posix_acl_access_xattr_handler,
-	&posix_acl_default_xattr_handler,
 	&ocfs2_xattr_trusted_handler,
 	&ocfs2_xattr_security_handler,
 	NULL
 };
 
-static const struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
-	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
-	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
-					= &posix_acl_access_xattr_handler,
-	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
-					= &posix_acl_default_xattr_handler,
-	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
-	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
-};
-
 struct ocfs2_xattr_info {
 	int		xi_name_index;
 	const char	*xi_name;
@@ -528,13 +516,34 @@ static int ocfs2_read_xattr_block(struct inode *inode, u64 xb_blkno,
 	return rc;
 }
 
-static inline const char *ocfs2_xattr_prefix(int name_index)
+static const char *ocfs2_xattr_prefix(int xattr_index)
 {
+	const char *name = NULL;
 	const struct xattr_handler *handler = NULL;
 
-	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
-		handler = ocfs2_xattr_handler_map[name_index];
-	return handler ? xattr_prefix(handler) : NULL;
+	switch (xattr_index) {
+	case OCFS2_XATTR_INDEX_USER:
+		handler = &ocfs2_xattr_user_handler;
+		break;
+	case OCFS2_XATTR_INDEX_TRUSTED:
+		handler = &ocfs2_xattr_trusted_handler;
+		break;
+	case OCFS2_XATTR_INDEX_SECURITY:
+		handler = &ocfs2_xattr_security_handler;
+		break;
+	case OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS:
+		name = XATTR_NAME_POSIX_ACL_ACCESS;
+		break;
+	case OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT:
+		name = XATTR_NAME_POSIX_ACL_DEFAULT;
+		break;
+	default:
+		return NULL;
+	}
+
+	name = xattr_prefix(handler);
+
+	return name;
 }
 
 static u32 ocfs2_xattr_name_hash(struct inode *inode,

-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
