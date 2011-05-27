From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 27 May 2011 02:52:48 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 important fix for $next_version-rc1
In-Reply-To: <20110526094632.GB8252@noexit.corp.google.com>
References: <20110526094632.GB8252@noexit.corp.google.com>
Message-ID: <20110527095248.GD4966@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Mea culpa.  The online defrag code in the ocfs2 feature pull had
a naked 64-bit divide that I missed in eyeballing and we all missed in
testing.  None of us managed to build the sucker on 32bit in the past
two months.  That's on me.  Thank you to akpm for noticing.  Also
included is a bugfix in the defrag location guessing.
	I'd really like to get this in before -rc1 so that ocfs2 builds
aren't broken there.  Please pull.

Mr Egg-on-his-face (Joel)

The following changes since commit a74b81b0aff4a01e0816df5915c854fb52c5e87f:

  Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 (2011-05-26 10:55:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git linux-next

Joel Becker (1):
      Merge branch 'move_extents' of git://oss.oracle.com/git/tye/linux-2.6 into ocfs2-merge-window

Tristan Ye (2):
      Ocfs2/move_extents: Avoid doing division in extent moving.
      Ocfs2/move_extents: Validate moving goal after the adjustment.

 fs/ocfs2/move_extents.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec at evilplan.org
