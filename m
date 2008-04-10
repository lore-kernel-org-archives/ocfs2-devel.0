From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Apr 2008 15:00:19 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add cluster lock stats at the
	fs level
In-Reply-To: <1207178188-30130-1-git-send-email-sunil.mushran@oracle.com>
References: <1207178188-30130-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080410220019.GZ21261@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 02, 2008 at 04:16:28PM -0700, Sunil Mushran wrote:
> This patch adds code to track the number of times the fs takes
> various cluster locks as well as the times associated with it.

Ok, this is definitely some usefull stuff. I'm concerned about how much it
grows struct ocfs2_lock_res though - I count 52 bytes. Even if the overhead
doesn't technically push it out to another slab, that's still a lot. Can we
wrap enough of this in OCFS2_DEBUG_FS so that the overhead can be easily
compiled out?
	--Mark

--
Mark Fasheh
