From: john stultz <johnstul@us.ibm.com>
Date: Wed, 04 Aug 2010 18:58:57 -0700
Subject: [Ocfs2-devel] [PATCH -v2 0/3] jbd2 scalability patches
In-Reply-To: <1280939957-3277-1-git-send-email-tytso@mit.edu>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
Message-ID: <1280973537.2678.37.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>

On Wed, 2010-08-04 at 12:39 -0400, Theodore Ts'o wrote:
> This version fixes three bugs in the 2nd patch of this series that
> caused kernel BUG when the system was under race.  We weren't accounting
> with t_oustanding_credits correctly, and there were race conditions
> caused by the fact the I had overlooked the fact that
> __jbd2_log_wait_for_space() and jbd2_get_transaction() requires
> j_state_lock to be write locked.

So without the vfs patches, I don't see much change with this patchset
(similar to the last).

novfs + j_state lock
Throughput 763.105 MB/sec 8 procs
Throughput 1056.81 MB/sec 4 procs
Throughput 681.761 MB/sec 2 procs
Throughput 409.25 MB/sec 1 procs

vs

no vfs + j_state lock + jdb2 scalability queue
Throughput 767.778 MB/sec 8 procs
Throughput 1069.58 MB/sec 4 procs
Throughput 679.786 MB/sec 2 procs
Throughput 401.419 MB/sec 1 procs


But with the vfs patchset, there's a nice increase @8cpus.
 vfs + j_state lock
Throughput 1061.44 MB/sec 8 procs
Throughput 1126.55 MB/sec 4 procs
Throughput 706.306 MB/sec 2 procs
Throughput 402.102 MB/sec 1 procs

vs

vfs + j_state lock + jdb2 scalability queue
Throughput 1214.21 MB/sec 8 procs
Throughput 1175.49 MB/sec 4 procs
Throughput 716.294 MB/sec 2 procs
Throughput 402.988 MB/sec 1 procs


I'll post perf log data tomorrow.

thanks
-john
