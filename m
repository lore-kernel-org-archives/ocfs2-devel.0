From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar 25 21:34:56 2004
Subject: [Ocfs2-devel] No longer seeing first-time-mount on 2.6 bug
Message-ID: <200403260334.i2Q3Ykpx008368@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I'm not able to reproduce the first-time-mount failures on 2.6 anymore.
The patch I just recently sent should make such failure be less painful, but
not fix the failure.

I just recently updated my mkfs.ocfs2 tools... I'm wondering an old mkfs.ocfs2
had anything to do with this.  

    --rusty
