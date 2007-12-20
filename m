From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Dec 20 18:56:57 2007
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Local alloc window size
	changeable via mount option
In-Reply-To: <1198191491-14441-2-git-send-email-sunil.mushran@oracle.com>
References: <1198191491-14441-1-git-send-email-sunil.mushran@oracle.com>
	<1198191491-14441-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221025632.GM13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 02:58:11PM -0800, Sunil Mushran wrote:
> Local alloc is a performance optimiztion in ocfs2 in which a node
> takes a window of bits from the global bitmap and then uses that for
> all small local allocations. This window size is fixed to 8MB currently.
> This patch allows users to specify the window size in MB including
> disabling it by passing in 0. If the number specified is too large,
> the fs will use the default value of 8MB.

Ok, committed and merged. I also added a comment to
ocfs2_local_alloc_window_bits().
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
