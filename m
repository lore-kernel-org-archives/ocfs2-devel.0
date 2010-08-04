From: Theodore Ts'o <tytso@mit.edu>
Date: Wed,  4 Aug 2010 12:39:14 -0400
Subject: [Ocfs2-devel] [PATCH -v2 0/3] jbd2 scalability patches
Message-ID: <1280939957-3277-1-git-send-email-tytso@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Cc: John Stultz <johnstul@us.ibm.com>, Keith Maanthey <kmannth@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>, Theodore Ts'o <tytso@mit.edu>

This version fixes three bugs in the 2nd patch of this series that
caused kernel BUG when the system was under race.  We weren't accounting
with t_oustanding_credits correctly, and there were race conditions
caused by the fact the I had overlooked the fact that
__jbd2_log_wait_for_space() and jbd2_get_transaction() requires
j_state_lock to be write locked.

Theodore Ts'o (3):
  jbd2: Use atomic variables to avoid taking t_handle_lock in
    jbd2_journal_stop
  jbd2: Change j_state_lock to be a rwlock_t
  jbd2: Remove t_handle_lock from start_this_handle()

 fs/ext4/inode.c       |    4 +-
 fs/ext4/super.c       |    4 +-
 fs/jbd2/checkpoint.c  |   18 +++---
 fs/jbd2/commit.c      |   42 ++++++------
 fs/jbd2/journal.c     |   94 +++++++++++++--------------
 fs/jbd2/transaction.c |  172 ++++++++++++++++++++++++++++---------------------
 fs/ocfs2/journal.c    |    4 +-
 include/linux/jbd2.h  |   12 ++--
 8 files changed, 188 insertions(+), 162 deletions(-)
