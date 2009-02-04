From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 4 Feb 2009 09:50:16 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs fixes
In-Reply-To: <20090203212422.GT17410@wotan.suse.de>
References: <20090203212422.GT17410@wotan.suse.de>
Message-ID: <20090204175016.GU17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Linus,

Can you please pull again? I mistakenly included a version of the configfs
patch which is in the process of being reworked. This pull reverts it. Thank
you.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/configfs/dir.c |   59 -----------------------------------------------------
 1 files changed, 0 insertions(+), 59 deletions(-)

Mark Fasheh (1):
      Revert "configfs: Silence lockdep on mkdir(), rmdir() and configfs_depend_item()"


--
Mark Fasheh
