From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Tue, 22 Jun 2010 17:11:50 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
Message-ID: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have just submitted the following bug report:

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1266

This is formally reporting the issue originally identified (and fixed)
by Robert Smith back in December:

http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg04728.html

Specifically, even the latest OCFS2 produces an error when you attempt
to mount a volume larger than 16 TiB:

"ocfs2_initialize_super:2157 ERROR: Volume might try to write to
blocks beyond what jbd can address in 32 bits."

I would like to use large volumes in production later this year or
early next, so I am interested in seeing this issue resolved so I can
begin testing.  I believe this check in fs/ocfs2/super.c is the only
known issue standing in the way of large volume support for OCFS2.  I
want to submit a patch to fix it.

The simplest approach is just to delete the check, like so:

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..0ba41f3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2215,14 +2215,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
                goto bail;
        }

-       if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-           > (u32)~0UL) {
-               mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-                    "what jbd can address in 32 bits.\n");
-               status = -EINVAL;
-               goto bail;
-       }
-
        if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
                                 sizeof(di->id2.i_super.s_uuid))) {
                mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");


Questions for the list:

1) Is this patch sufficient?  Or should I try to modify the check to
take into account the cluster size?  Anything else I need to check
here (e.g. inode64 mount option)?

2) Should mkfs.ocfs2 contain a similar check?  (It may already; I have
not looked yet...)

 - Pat
