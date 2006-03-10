From: Daniel Phillips <phillips@google.com>
Date: Fri, 10 Mar 2006 14:32:32 -0800
Subject: [Ocfs2-devel] Another ocfs2 performance bug
Message-ID: <4411FE80.7030302@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi guys,

Reading all the files in a big directory tree takes at least four times
as long on ocfs2 as ext3.

# ocfs2: Copy a kernel tree to /dev/null
mount -tocfs2 /dev/hdb /big
time find /big/linux-2.6.16-rc3 -type f -exec cp {} /dev/null \;

real   1m54.933s  <===
user   0m0.896s
sys    0m1.844s

time find /big/linux-2.6.16-rc3 -type f -exec cp {} /dev/null \;

real   0m14.301s
user   0m5.172s
sys    0m9.093s

# ext3: Copy a kernel tree to /dev/null
mount -text3 /dev/hdb /big
time find /big/linux-2.6.16-rc3 -type f -exec cp {} /dev/null \;

real    0m23.899s <===
user    0m4.672s
sys     0m9.513s

time find /big/linux-2.6.16-rc3 -type f -exec cp {} /dev/null \;

real    0m14.198s
user    0m5.168s
sys     0m8.977s

Regards,

Daniel
