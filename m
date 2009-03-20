From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 19 Mar 2009 17:38:46 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix 2 warning during ocfs2 make.
In-Reply-To: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
References: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090320003846.GD13065@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 19, 2009 at 05:08:43AM +0800, Tao Ma wrote:
> fs/ocfs2/dir.c: In function ?ocfs2_extend_dir?:
> fs/ocfs2/dir.c:2700: warning: ?ret? may be used uninitialized in this function
> 
> fs/ocfs2/suballoc.c: In function ?ocfs2_get_suballoc_slot_bit?:
> fs/ocfs2/suballoc.c:2216: warning: comparison is always true due to limited range of data type

Does the 2nd bug still exist in merge_window? I didn't see it, so I just
merged the 1st one into merge_window.
	--Mark


--
Mark Fasheh
