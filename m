From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 29 Jun 2013 11:56:55 +0800
Subject: [Ocfs2-devel] A serious of OCFS2 resend-patches for Linux 3.10
Message-ID: <51CE5B07.5090705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew and All,

Here are a number of old OCFS2 patches I'd like to check if they can be
merged into Linux 3.10.

The first patch from Niwamatsu could fix a critical issue for OCFS2 fencing,
this patch has been merged back to Oracle Linux kernel for a long time and
it works very well.

The left three patches are trivial patches for fixing naming conventions,
typo as well as syntax adjustment.


Niwamatsu, Noboru (1)
- ocfs2: submit disk heartbeat bio using WRITE_SYNC

Jeff Liu (3)
- ocfs2: consolidate o2hb_global_hearbeat_mode_set() naming convention
- ocfs2: fix a comments typo at o2quo_hb_still_up()
- ocfs2: adjust switch_case syntax at o2net_state_change()


Thanks,
-Jeff
