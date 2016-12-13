From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:22 +0800
Subject: [Ocfs2-devel] [PATCH 04/17] Trivial: fix a typo mistake
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-5-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/mkfs-tests/mkfs-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/programs/mkfs-tests/mkfs-test.sh b/programs/mkfs-tests/mkfs-test.sh
index 3fc93a4..8fdd02a 100755
--- a/programs/mkfs-tests/mkfs-test.sh
+++ b/programs/mkfs-tests/mkfs-test.sh
@@ -431,7 +431,7 @@ fi;
 echo "Test ${testnum}: -L mylabel" |tee -a ${LOGFILE}
 label="my_label_is_very_very_very_long_to_the_point_of_being_useless"
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} -x -F -b 4K -C 4K -N 1 -L ${label} ${device} 262144 >{OUt} 2>&1
+${MKFS} -x -F -b 4K -C 4K -N 1 -L ${label} ${device} 262144 >${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 echo -n "verify ..... " |tee -a ${LOGFILE}
 ${DEBUGFS} -R "stats" ${device} >${OUT} 2>&1
-- 
2.6.6
