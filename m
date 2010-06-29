From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 29 Jun 2010 16:24:23 -0700
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: make mmap CoW work with
	readahead.
In-Reply-To: <1277800541-6844-4-git-send-email-tao.ma@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-4-git-send-email-tao.ma@oracle.com>
Message-ID: <20100629232423.GJ4150@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 29, 2010 at 04:35:41PM +0800, Tao Ma wrote:
> refcount_cow need file * to do the readahead.
> So we just add 'struct file *' to ocfs2_write_begin_nolock
> and __ocfs2_page_mkwrite and let them pass this parameter
> to ocfs2_refcount_cow.

	As I stated in my comment on the first patch, these functions
only need the file*.  The inode can be gotten off of that.

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
