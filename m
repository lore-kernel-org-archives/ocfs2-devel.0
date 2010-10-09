From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat, 09 Oct 2010 10:35:27 -0700
Subject: [Ocfs2-devel] [PATCH 02/22] ocfs2: Add an incompat feature flag
 OCFS2_FEATURE_INCOMPAT_CLUSTERINFO
In-Reply-To: <6632EF04-C58F-4FE9-94C9-5B37A71A3FE1@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>	<1286496936-17072-3-git-send-email-sunil.mushran@oracle.com>	<20101008231103.GK8031@wotan.suse.de>
	<4CAFA8B8.3050101@oracle.com>	<20101009001554.GO13876@mail.oracle.com>
	<6632EF04-C58F-4FE9-94C9-5B37A71A3FE1@oracle.com>
Message-ID: <4CB0A7DF.6030705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=summary

So there is a new branch "global-heartbeat-2" that has this change.

--- ./ocfs2/ocfs2_fs.h  2010-10-08 14:12:55.000000000 -0700
+++ ../G/./ocfs2/ocfs2_fs.h     2010-10-09 10:24:53.000000000 -0700
@@ -592,10 +592,10 @@
         union {
                 __le32 ci_reserved;
                 struct {
+                       __u8 ci_stackflags;
                         __u8 ci_reserved1;
                         __u8 ci_reserved2;
                         __u8 ci_reserved3;
-                       __u8 ci_stackflags;
                 };
         };
  /*08*/ __u8   ci_cluster[OCFS2_CLUSTER_NAME_LEN];
