From: Zhen Wei <zwei@novell.com>
Date: Thu Dec  7 23:49:53 2006
Subject: [Ocfs2-devel] [patch 2/3]OCFS2: allow the ocfs2 heartbeat thread to
	prioritize I/O --revision 3
Message-ID: <4579B3C00200000400262DB0@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

- call ocfs2_hb_ctl to prioritize thread I/O  after mounting the device

zhen wei
zwei@novell.com
+86 10 65339225

-------------- next part --------------
--- trunk.orig/mount.ocfs2/mount.ocfs2.c	2006-12-08 15:09:42.000000000 +0800
+++ trunk/mount.ocfs2/mount.ocfs2.c	2006-12-08 15:17:59.000000000 +0800
@@ -393,6 +393,7 @@ int main(int argc, char **argv)
 		goto bail;
 	}
 
+	run_hb_ctl (hb_ctl_path, mo.dev, "-P");
 	update_mtab_entry(mo.dev, mo.dir, OCFS2_FS_NAME,
 			  fix_opts_string(((mo.flags & ~MS_NOMTAB) | MS_NETDEV),
 					  extra, NULL),
