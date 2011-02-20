From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 20 Feb 2011 04:08:28 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: optimize ocfs2_check_dir_entry()
 with unlikely() annotations
In-Reply-To: <1295882610-12542-1-git-send-email-tm@tao.ma>
References: <1295882610-12542-1-git-send-email-tm@tao.ma>
Message-ID: <20110220120828.GI17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 24, 2011 at 11:23:30PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In cad3f00, ext4_check_dir_entry was modified by adding some unlikely.
> Ted described it as "This function gets called a lot for large
> directories, and the answer is almost always 'no, no, there's no problem'.
> This means using unlikely() is a good thing."
> ext3 added the similar change in commit a4ae309.
> 
> So change it accordingly in ocfs2.
> 
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

			http://www.jlbec.org/
			jlbec at evilplan.org
