From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 23 Apr 2013 10:16:04 -0400
Subject: [Ocfs2-devel] [PATCH v3 06/18] ocfs2: use ->invalidatepage()
	length argument
In-Reply-To: <1365498867-27782-7-git-send-email-lczerner@redhat.com>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
	<1365498867-27782-7-git-send-email-lczerner@redhat.com>
Message-ID: <20130423141604.GE31170@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Tue, Apr 09, 2013 at 11:14:15AM +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in ocfs2_invalidatepage().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Joel Becker <jlbec@evilplan.org>

+Mark Fasheh, ocfs2-devel

To the ocfs2 development team,

Since half of this patch series modifies ext4 extensively, and changes
to the other file systems are relatively small, I plan to carry the
invalidatepage patch set in the ext4 tree for the next development
cycle (i.e., not the upcoming merge window, but the next one).  To
that end, it would be great if you take a look at this patch set and
send us an Acked-by signoff.

Thanks!!

						- Ted
