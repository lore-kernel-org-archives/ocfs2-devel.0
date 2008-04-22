From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 22 Apr 2008 11:46:44 -0700
Subject: [Ocfs2-devel] current OCFS2 testing results
In-Reply-To: <28180743.1208882223804.JavaMail.oracle@acsmt302.oracle.com>
References: <28180743.1208882223804.JavaMail.oracle@acsmt302.oracle.com>
Message-ID: <20080422184644.GA26425@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 22, 2008 at 11:37:03AM -0500, Randy Dunlap wrote:
> There appear to be 2 problems.  One is sysfs duplicate filename and the other
> is with mlog_and_bits & mlog_not_bits.  Maybe the latter one is just a result of
> the first one.
> 
> OCFS2 Node Manager 1.5.0
> sysfs: duplicate filename 'o2cb' can not be created

	Looks like the rejiggering of the /sys/fs/o2cb path didn't get
merged right.  Please try the patch at the end.

> ocfs2: Unknown symbol mlog_and_bits
> ocfs2: Unknown symbol mlog_not_bits

ocfs2_nodemanager provides these, so when it fails to load, they don't
exist.

Joel

--------------------


ocfs2: Correct merge of 52f7c21 (Move /sys/o2cb to /sys/fs/o2cb)

Commit 52f7c21b613f80cb425d115c9e5b4ed958a133c0 was intended to move
/sys/o2cb to /sys/fs/o2cb, providing /sys/o2cb as a symlink for
backwards compatibility.  However, the merge apparently added the
symlink but failed to move the directory, resulting in a duplicate
filename error.  It's a one-line change that was missing.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

---

diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 98429fd..bc702da 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -65,7 +65,7 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_kset = kset_create_and_add("o2cb", NULL, NULL);
+	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
 	if (!o2cb_kset)
 		return -ENOMEM;
 

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
