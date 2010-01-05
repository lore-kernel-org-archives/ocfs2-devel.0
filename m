From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 Jan 2010 17:38:23 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 update for 2.6.33
Message-ID: <20100105013823.GD19331@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Sunil Mushran <sunil.mushran@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hey Linus,
	Here's the one fix that conflicted against master.  I rebased it
atop master and let it stew in linux-next for a little bit.  It's an
important fix, getting O_DIRECT correct as we CoW a refcounted cluster.
	Please pull.

Joel

The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
  Linus Torvalds (1):
        Linux 2.6.33-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 upstream-linus

Tao Ma (1):
      ocfs2: Handle O_DIRECT when writing to a refcounted cluster.

 fs/ocfs2/file.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)
-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
