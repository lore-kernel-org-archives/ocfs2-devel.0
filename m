From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 29 Jan 2010 22:23:47 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: add freeze/thaw support -v2
Message-ID: <201001291425.o0TE2OZK005935@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

changes from v1
1): fs locking prototol version up 0.1 instead of change in dlm protocol version.
2): fixes the racing with umount. yet relies on cancelable cluster lock.
3): timeout the joinning in a cluster when it's frozen instead of waiting until
    thaw. yet relies on cancelable cluster lock.
4): fix deadlock(with super lock) when joining in a frozen cluster. Move freeze
    lock out of super lock.
5): takes care of a node crash when cluster is frozen(recvery related). Flush
    journal in ocfs2_sync_fs() when cluster is in progress of frozen. so that
    no journal replay needed.
6): tiny changes
