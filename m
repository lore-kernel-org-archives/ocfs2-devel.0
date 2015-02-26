From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 26 Feb 2015 13:33:29 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: remove unneeded variable
	'status'
In-Reply-To: <20150223103810.GA16869@devel.8.8.4.4>
References: <20150223103810.GA16869@devel.8.8.4.4>
Message-ID: <20150226133329.8a80c302d3ec014a2b0d58ff@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, 23 Feb 2015 19:38:10 +0900 Daeseok Youn <daeseok.youn@gmail.com> wrote:

> Use 'retval' instead of 'status'.
> 

The patch does a lot more than this.  It causes __ocfs2_add_entry to
propagate error codes which were previously dropped on the floor.

Please update the changelog to fully explain the functional changes and
to explain why they are desirable.

After the patch there is still one unchecked call to
ocfs2_journal_access_di() and one unchecked call to
ocfs2_journal_access_db().  Probably these are bugs.
