From: Dan Carpenter <error27@gmail.com>
Date: Sat, 10 Jul 2010 16:33:36 +0200
Subject: [Ocfs2-devel] [patch] ocfs2: tighten up strlen() checking
Message-ID: <20100710143336.GB19184@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function is only called from one place and it's like this:
	dlm_register_domain(conn->cc_name, dlm_key, &fs_version);

The "conn->cc_name" is 64 characters long.  If strlen(conn->cc_name)
were equal to O2NM_MAX_NAME_LEN (64) that would be a bug because
strlen() doesn't count the NULL character.

In fact, if you look how O2NM_MAX_NAME_LEN is used, it mostly describes
64 character buffers.  The only exception is nd_name from struct
o2nm_node.

Anyway I looked into it and in this case the domain string comes from
osb->uuid_str in ocfs2_setup_osb_uuid().  That's 32 characters and NULL
which easily fits into O2NM_MAX_NAME_LEN.  This patch doesn't change how
the code works, but I think it makes the code a little cleaner.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Or we could get rid of check entirely.

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6b5a492..084b051 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1671,7 +1671,7 @@ struct dlm_ctxt * dlm_register_domain(const char *domain,
 	struct dlm_ctxt *dlm = NULL;
 	struct dlm_ctxt *new_ctxt = NULL;
 
-	if (strlen(domain) > O2NM_MAX_NAME_LEN) {
+	if (strlen(domain) >= O2NM_MAX_NAME_LEN) {
 		ret = -ENAMETOOLONG;
 		mlog(ML_ERROR, "domain name length too long\n");
 		goto leave;
