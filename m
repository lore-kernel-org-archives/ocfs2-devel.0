From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 11 Feb 2009 13:01:28 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add journal parameter to
	jbd2_journal_begin_ordered_truncate()
In-Reply-To: <20090210151255.GE30689@mini-me.lan>
References: <1233845582-954-1-git-send-email-jack@suse.cz>
	<1233845582-954-2-git-send-email-jack@suse.cz>
	<1233845582-954-3-git-send-email-jack@suse.cz>
	<1233845582-954-4-git-send-email-jack@suse.cz>
	<20090210151255.GE30689@mini-me.lan>
Message-ID: <20090211210128.GD17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2009 at 10:12:55AM -0500, Theodore Tso wrote:
> The problem with separating out the patch into three separate commits
> is that it can potentially break a "git bisect".  To fix this, I
> believe the right thing to do is to combine the three patches into a
> single commit, and to push this via the ext4 tree; any objections?

That's fine with me. Btw, you forgot my:

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
