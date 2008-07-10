From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 10 Jul 2008 16:17:49 -0700
Subject: [Ocfs2-devel] OCFS2 1.4: Proposed fix for mount/recovery race
Message-ID: <1215731871-17351-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Please review the patches as discussed in the last concall.

In particular, please review the journal inode read code. I am not
sure whether that is the most efficient. As in, I may be reading the
blocks twice.

Sunil
