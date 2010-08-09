From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 9 Aug 2010 09:06:55 -0700
Subject: [Ocfs2-devel] [PATCH -v2 0/3] jbd2 scalability patches
In-Reply-To: <1280939957-3277-1-git-send-email-tytso@mit.edu>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
Message-ID: <20100809160652.GA4743@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>, John Stultz <johnstul@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>

On Wed, Aug 04, 2010 at 12:39:14PM -0400, Theodore Ts'o wrote:
> This version fixes three bugs in the 2nd patch of this series that
> caused kernel BUG when the system was under race.  We weren't accounting
> with t_oustanding_credits correctly, and there were race conditions
> caused by the fact the I had overlooked the fact that
> __jbd2_log_wait_for_space() and jbd2_get_transaction() requires
> j_state_lock to be write locked.
> 

Here's an initial set of runs.  Not the fastest disk ever, but it shows
the patches don't hurt us.

http://oss.oracle.com/~mmatsuna/ocfs2-test/FFSB/FFSB.html

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
