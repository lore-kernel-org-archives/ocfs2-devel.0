From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:50:00 2008
Subject: [Ocfs2-devel] Much needed changes to o2dlm
Message-ID: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1. Moved some dlm structures to their own slab cache.
2. Fixed memleaks uncovered by the above move.
3. Added debugfs support in o2dlm to allow dumpig of dlm state,
lockres, purgelist, etc.
4. Removed o2dlm's proc interface.

Sunil
