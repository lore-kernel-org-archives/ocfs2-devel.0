From: Tristan Ye <tristan.ye@oracle.com>
Date: Sat, 22 May 2010 16:26:32 +0800
Subject: [Ocfs2-devel]  [PATCH 0/1] Ocfs2: o2info(v8) patch for kernel.
Message-ID: <1274516793-29129-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

It's the latest o2info(v8) patch for kernel, changes from v7 to v8.

1. Fix compat bugs when running 32bits o2info binary on 64bits kernel.

2. Pad o2info structures to be 64bits aligned.


Corresponding patches for ocfs2-tools will be posted at the same time.

Tristan.
