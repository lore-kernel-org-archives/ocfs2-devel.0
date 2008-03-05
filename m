From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 11:05:52 2008
Subject: [Ocfs2-devel] [PATCH 04/12] ocfs2/dlm: Create debugfs dirs
In-Reply-To: <20080305185459.GB799@ca-server1.us.oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-5-git-send-email-sunil.mushran@oracle.com>
	<20080305185459.GB799@ca-server1.us.oracle.com>
Message-ID: <20080305190405.GC799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 05, 2008 at 10:54:59AM -0800, Joel Becker wrote:
> On Tue, Mar 04, 2008 at 04:49:52PM -0800, Sunil Mushran wrote:
> > This patch creates the debugfs directories that will hold the
> > files to be used to dump the dlm state.
> > 
> > Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

	I take this back.  Can't you do the #ifdef in dlmdebug.h
instead?  eg:


+#ifndef DLMDEBUG_H
+#define DLMDEBUG_H
+
+#ifdef CONFIG_DEBUG_FS
+int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
+void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
+
+int dlm_create_debugfs_root(void);
+void dlm_destroy_debugfs_root(void);
+#else
+static inline int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+	return 0;
+}
+static void int dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+	return;
+}
+static inline int dlm_create_debugfs_root(void);
+{
+	return 0;
+}
+static inline int dlm_destroy_debugfs_root(void);
+{
+	return;
+}
+#endif  /* CONFIG_DEBUG_FS */
+
+#endif  /* DLMDEBUG_H */

	This allows us to leave a million #ifdefs out of dlmdebug.c -
you just wrap the *entire* debugfs bit in a giant #ifdef.  That's much
nicer to read than functions that are ifdef'd out one-by-one.
	Also, in general, can you comment your #endif lines if they are
not on the same 80x24 terminal screen as the opening #ifdef?

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
