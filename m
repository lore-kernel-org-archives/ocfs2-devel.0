From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar  4 16:50:17 2008
Subject: [Ocfs2-devel] New dlm debug infrastructure - 2nd attempt
Message-ID: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The patches include the following changes:

1. Rename dlm_mle_cache to o2dlm_mle
2. Create o2dlm_lock, o2dlm_lockres and o2dlm_lockname slabcaches.
3. Add debugfs interface to allow users to dump dlm_state, locking_state, etc.

Changes suggested by Joel Becker have been made.

This patch series has been tested with the latest mainline kernel tree (2.6.25-rc3+).

Sunil
