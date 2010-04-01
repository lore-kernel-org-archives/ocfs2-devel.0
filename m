From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 01 Apr 2010 10:53:40 +0800
Subject: [Ocfs2-devel] [PATCH 0/15] ocfs2: Support for discontiguous block
	group.
Message-ID: <4BB40AB4.8040205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	This patch set try to implement discontiguous block group in ocfs2. We 
have meet with many ENOSPC problems because of file system fragmentation 
and among them a big part is that we can't allocate contiguouse 4M bytes 
to allocate a new inode/extent block group. So this patch set is going 
to resolve this by supporting discontiguous block group.

01-11 are the original patches from Joel Becker, I didn't touch them so 
that Joel could skip them for review. ;)
12 is a patch fixing some tiny problems in 01-11. I separate it out so 
that it can be reviewed by Joel easily and it will be integrated into 
the previous 01-11 when it get acked.
13-15 are the following patches.

[View]
http://oss.oracle.com/git/?p=tma/linux-2.6.git;a=shortlog;h=discontig-bg
[Pull]
git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg

For the design doc, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/DiscontiguousBlockGroups

The patches for ocfs2-tools support will be sent to ocfs2-tools-devel.

Regards,
Tao
