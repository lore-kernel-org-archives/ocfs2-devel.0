From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 27 Feb 2009 18:00:53 -0800
Subject: [Ocfs2-devel] Patch to move ocfs2_slot_info to slot_map.h
Message-ID: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Next 3 patches does the following
1) movies ocfs2_slot_info struct from slot_map.c to slot_map.h
2) patch to recover orphans during mount even if the journal is clean
3) patch to recovery orphans in offline slots
