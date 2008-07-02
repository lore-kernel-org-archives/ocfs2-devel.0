From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 2 Jul 2008 15:18:04 +0530
Subject: [Ocfs2-devel] Add --force option in tunefs
Message-ID: <20080702094655.GA6088@baloo.nue.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch enable --force option in tunefs.ocfs2
Like mkfs, the --force option ignores cluster initialization 
and locking.

A force option is useless for local mounts and hence, to display the
warning message, the check for force flag is checked after the check for
local mount.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>


diff --git a/tunefs.ocfs2/tunefs.c b/tunefs.ocfs2/tunefs.c
index be10eb2..e238f1e 100644
--- a/tunefs.ocfs2/tunefs.c
+++ b/tunefs.ocfs2/tunefs.c
@@ -44,7 +44,7 @@ static void usage(const char *progname)
 	fprintf(stderr, "usage: %s [-J journal-options] [-L volume-label]\n"
 			"\t\t[-M mount-type] [-N number-of-node-slots] [-Q query-fmt]\n"
 			"\t\t[--update-cluster-stack]\n"
-			"\t\t[-qSUvV] [--backup-super] [--list-sparse]\n"
+			"\t\t[-qSUvV] [--backup-super] [--list-sparse] [--force]\n"
 			"\t\t[--fs-features=[no]sparse,...]] device [blocks-count]\n",
 			progname);
 	exit(0);
@@ -202,6 +202,7 @@ static void get_options(int argc, char **argv)
 		{ "quiet", 0, 0, 'q' },
 		{ "query", 1, 0, 'Q' },
 		{ "version", 0, 0, 'V' },
+		{ "force", 0, 0, 'F' },
 		{ "journal-options", 0, 0, 'J'},
 		{ "volume-size", 0, 0, 'S'},
 		{ "uuid-reset", 0, 0, 'U'},
@@ -221,7 +222,7 @@ static void get_options(int argc, char **argv)
 	opts.prompt = 1;
 
 	while (1) {
-		c = getopt_long(argc, argv, "L:N:J:M:Q:SUvqVxb", long_options,
+		c = getopt_long(argc, argv, "L:N:J:M:Q:SUvqVFxb", long_options,
 				NULL);
 
 		if (c == -1)
@@ -292,6 +293,10 @@ static void get_options(int argc, char **argv)
 			opts.verbose = 1;
 			break;
 
+		case 'F':
+			opts.force = 1;
+			break;
+
 		case 'q':
 			opts.quiet = 1;
 			break;
@@ -1295,6 +1300,10 @@ int main(int argc, char **argv)
 		get_vol_size(fs);
 
 	if (!ocfs2_mount_local(fs)) {
+		if (opts.force) {
+			fprintf(stderr, "WARNING: Cluster check disabled.\n");
+			goto skip_cluster_start;
+		}
 		ret = o2cb_init();
 		if (ret) {
 			com_err(opts.progname, ret, "while initializing the cluster");
diff --git a/tunefs.ocfs2/tunefs.h b/tunefs.ocfs2/tunefs.h
index c7b4acf..819997b 100644
--- a/tunefs.ocfs2/tunefs.h
+++ b/tunefs.ocfs2/tunefs.h
@@ -87,6 +87,7 @@ typedef struct _ocfs2_tune_opts {
 	int verbose;
 	int quiet;
 	int prompt;
+	int force;
 	int backup_super;
 	int update_cluster;
 	int list_sparse;

-- 
Goldwyn
