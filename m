From: David Teigland <teigland@redhat.com>
Date: Thu, 9 Jul 2009 13:53:38 -0500
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
	question of ocfs2_controld (Jun 27)]
In-Reply-To: <20090708141542.GA8778@redhat.com>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
	<4A51ED7F.2040105@suse.de> <20090707160113.GA9140@redhat.com>
	<20090707174741.GA24163@mail.oracle.com>
	<20090708141542.GA8778@redhat.com>
Message-ID: <20090709185338.GA11643@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 08, 2009 at 09:15:42AM -0500, David Teigland wrote:
> On Tue, Jul 07, 2009 at 10:47:42AM -0700, Joel Becker wrote:
> > On Tue, Jul 07, 2009 at 11:01:13AM -0500, David Teigland wrote:
> > > On Mon, Jul 06, 2009 at 08:26:39PM +0800, Coly Li wrote:
> > > > DLM_USER_LVB_LEN is defined to 32.
> > > 
> > > > DLM_LVB_LEN is 64.
> > > 
> > > Yes, the kernel dlm api allows a variable lvb size, but the user dlm api fixes
> > > it at 32.
> > > 
> > > Do you need to actually use a 64 byte lvb from userspace?  Or do you just need
> > > to create the locksapce with a 64 byte lvb?  We could add a flag to work
> > > around the later fairly easily.  Changing the dlm user/kernel interface to
> > > copy variable size lvb's would take some significant work.
> > 
> > 	In this case, it's userspace utilities locking to verify no one
> > else is doing anything in the cluster.  coly has noticed mkfs.ocfs2, but
> > tunefs.ocfs2 and fsck.ocfs2 do the same thing.
> > 	While a 64byte user lvb would be ideal, I think a flag to work
> > around it would be great.  If the flag says "I know this lockspace may
> > have !32byte LVBs, but I promise not to use them", and you can error
> > when someone tries to set/get LVBs in that case, I think it works.

Here's a kernel patch that I've not yet tried.  The code using libdlm will
need to add the flag 0x00000010 to dlm_new_lockspace().  (Until we've added
the new LVB64 define to libdlm.h.)

From 75e92c78bb0b0002f0253bfe10bef8585a0d52d6 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 9 Jul 2009 13:11:02 -0500
Subject: [PATCH] dlm: add DLM_LSFL_LVB64 for lockspace creation

Add a new flag DLM_LSFL_LVB64 to create lockspaces with 64 byte lvbs,
overriding the lvb length parameter.  It is useful to override the
fixed 32 byte lvb imposed by the user api when the lockspace is created
from userspace but used from the kernel.  Locking through the user api
can still only access 32 byte lvbs.

Ocfs2 user tools create lockspaces that may be in use by the file
system on other nodes.  The file system creates and uses 64 byte lvbs.
Creating the lockspace from user tools fails unless the default 32 byte
lvb is overriden to match the 64 byte length already in use.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c  |    5 ++++-
 include/linux/dlm.h |   28 +++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index d489fcc..4d5b5d5 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -391,6 +391,9 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	int i, size, error;
 	int do_unreg = 0;
 
+	if (flags & DLM_LSFL_LVB64)
+		lvblen = 64;
+
 	if (namelen > DLM_LOCKSPACE_LEN)
 		return -EINVAL;
 
@@ -451,7 +454,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	/* ls_exflags are forced to match among nodes, and we don't
 	   need to require all nodes to have some flags set */
 	ls->ls_exflags = (flags & ~(DLM_LSFL_TIMEWARN | DLM_LSFL_FS |
-				    DLM_LSFL_NEWEXCL));
+				    DLM_LSFL_NEWEXCL | DLM_LSFL_LVB64));
 
 	size = dlm_config.ci_rsbtbl_size;
 	ls->ls_rsbtbl_size = size;
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index 0b3518c..24a62de 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -65,12 +65,34 @@ struct dlm_lksb {
 	char *	 sb_lvbptr;
 };
 
-/* dlm_new_lockspace() flags */
+/*
+ * dlm_new_lockspace() flags
+ *
+ * DLM_LSFL_NODIR: Do not use a resource directory to determine the master of
+ * resources, but set the master statically by hashing the resource name (the
+ * same hash that would otherwise determine the resource directory node).
+ *
+ * DLM_LSFL_TIMEWARN: Track how long locks are waiting to be granted and send a
+ * notice to userspace (via netlink) if the time exceeds
+ * dlm_config.ci_timewarn_cs centiseconds.
+ *
+ * DLM_LSFL_FS: Use GFP_NOFS for memory allocations instead of GFP_KERNEL.
+ * This is set by filesystems using the dlm.
+ *
+ * DLM_LSFL_NEWEXCL: Create the lockspace only if it does not already exist.
+ * If the lockspace already exists locally, -EEXIST is returned.
+ *
+ * DLM_LSFL_LVB64: The user api has no lvb length parameter, so it creates
+ * lockspaces with 32 byte lvbs by default, or 64 byte lvbs with the LVB64
+ * flag.  LVB64 is useful for lockspaces created from userspace but used from
+ * the kernel; the user api still only reads/writes 32 byte lvbs.
+ */
 
 #define DLM_LSFL_NODIR		0x00000001
 #define DLM_LSFL_TIMEWARN	0x00000002
-#define DLM_LSFL_FS     	0x00000004
-#define DLM_LSFL_NEWEXCL     	0x00000008
+#define DLM_LSFL_FS		0x00000004
+#define DLM_LSFL_NEWEXCL	0x00000008
+#define DLM_LSFL_LVB64		0x00000010
 
 #ifdef __KERNEL__
 
-- 
1.5.5.6
