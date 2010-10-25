From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:47 +0800
Subject: [Ocfs2-devel] [PATCH 3/6] O2info: Add '--cluster-coherent' option
	for o2info.
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-4-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Default will be no cluster-in-coherency.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 o2info/o2info.1.in |    6 +++++-
 o2info/o2info.c    |   22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/o2info/o2info.1.in b/o2info/o2info.1.in
index fe32d70..d748df8 100644
--- a/o2info/o2info.1.in
+++ b/o2info/o2info.1.in
@@ -2,7 +2,7 @@
 .SH "NAME"
 o2info \- Dump \fIOCFS2\fR file system information on disk.
 .SH "SYNOPSIS"
-\fBo2info\fR <\fBdevice or file\fR>
+\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] <\fBdevice or file\fR>
 
 .SH "DESCRIPTION"
 .PP
@@ -10,6 +10,10 @@ o2info \- Dump \fIOCFS2\fR file system information on disk.
 
 .SH "OPTIONS"
 .TP
+\fB\-C, \-\-cluster\-coherent\fR
+Enable cluster (in)coherency for mounted case, means it will attempt to acquire a global PR lock when querying info from a cluster filesystem, which may degrade the performance, default is none cluster-coherency.
+
+.TP
 \fB\-V, \-\-version\fR
 Show version and exit.
 
diff --git a/o2info/o2info.c b/o2info/o2info.c
index 02058af..3fa4627 100644
--- a/o2info/o2info.c
+++ b/o2info/o2info.c
@@ -51,6 +51,13 @@ static int version_handler(struct o2info_option *opt, char *arg)
 	exit(0);
 }
 
+static int coherency_handler(struct o2info_option *opt, char *arg)
+{
+	cluster_coherent = 1;
+
+	return 0;
+}
+
 static struct o2info_option help_option = {
 	.opt_option	= {
 		.name		= "help",
@@ -77,9 +84,24 @@ static struct o2info_option version_option = {
 	.opt_private = NULL,
 };
 
+static struct o2info_option coherency_option = {
+	.opt_option	= {
+		.name		= "cluster-coherent",
+		.val		= 'C',
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	=
+		"-C|--cluster-coherent",
+	.opt_handler	= coherency_handler,
+	.opt_op		= NULL,
+	.opt_private = NULL,
+};
+
 static struct o2info_option *options[] = {
 	&help_option,
 	&version_option,
+	&coherency_option,
 	NULL,
 };
 
-- 
1.5.5
