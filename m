From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Fri Apr 23 19:08:23 2004
Subject: [Ocfs2-devel] OCFS version 2 Beta format change
Message-ID: <20040424000819.GA1782@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Just wanted to send notice to everyone that the disk formatter and some
kernel code will be changing my next checkin to svn.  The mkfs.ocfs2
tool will now do a *complete* format of the device, including creation
of all of the "system" files.  It will also create the first 4 journals
(of 8MB a piece).  A later change to tuneocfs will let you add in nodes
beyond the first 4, and will also finish up the work of doing a proper
v1 -> v2 conversion.

So if you are doing OCFS version 2 testing, you MUST grab the latest
version of BOTH ocfs2 and ocfs-tools.  You should format any new
filesystems with the mkfs.ocfs2 command in ocfs-tools/format.  Existing
volumes will likely continue to work, but I would advise reformatting
existing volumes in the near future.

The first svn revision that contains the new code for ocfs2 is 866, and 
for ocfs-tools it is 18.  If you run into any problems, let me know
asap.

Thanks!
-kurt
