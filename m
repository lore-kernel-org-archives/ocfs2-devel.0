From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon,  7 May 2012 16:21:27 -0700
Subject: [Ocfs2-devel] ocfs2 discontiguous localalloc patches
Message-ID: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

can you please review following 3 patches that implement discontiguous
localalloc bitmap support for ocfs2 file system. This feature helps
applications that significantly fragment the filesystem.

These fixes needs changes to ocfs2 tools as well. I am sending those patches
for review separately.

A write up on this feature is available at
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/DiscontiguousLocalAlloc.html

Thanks,
--Srini
