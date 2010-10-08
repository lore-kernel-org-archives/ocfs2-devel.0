From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:14 -0700
Subject: [Ocfs2-devel] O2CB global heartbeat - hopefully final drop!
Message-ID: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


All,

This is hopefully the final drop of the patches for adding global heartbeat
to the o2cb stack.

The diff from the previous set is here:
http://oss.oracle.com/~smushran/global-hb-diff-2010-10-07

Implemented most of the suggestions provided by Joel and Wengang.
The most important one was to activate the feature only at the end,

Also, got mostly a clean run with checkpatch.pl.

Sunil
