From: Christoph Hellwig <hch@lst.de>
Date: Tue Jun 22 07:22:59 2004
Subject: [Ocfs2-devel] [PATCH] provide strsep for ancient kernels
Message-ID: <20040622122254.GA14879@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/super.c
===================================================================
--- src/super.c	(revision 1182)
+++ src/super.c	(working copy)
@@ -435,13 +435,7 @@
 
 	LOG_TRACE_ARGS("strlen(options) = %u, options = \"%s\"\n", (unsigned int)strlen(options), options);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	while ( (c = strsep(&options, ",")) != NULL)
-#else
-	for (c = strtok (options, ","); c != NULL; c = strtok (NULL, ","))
-#endif
-//	while ( (c = strsep(&options, ",")) != NULL) 
-	{
+	while ((c = strsep(&options, ",")) != NULL) {
 		if ((value = strchr (c, '=')) != NULL)
 			*value++ = 0;
 		if (!strcmp (c, "gid")) {
Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1182)
+++ src/ocfs_compat.h	(working copy)
@@ -87,6 +87,19 @@
 	sb->s_blocksize_bits = bits;
 	return sb->s_blocksize;
 }
+
+static inline char *strsep(char **s, const char *ct)
+{
+	char *sbegin = *s, *end;
+
+	if (sbegin == NULL)
+		return NULL;
+	end = strpbrk(sbegin, ct);
+	if (end)
+		*end++ = '\0';
+	*s = end;
+	return sbegin;
+}
 #endif
 
 typedef long sector_t;
