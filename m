From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 18 Apr 2008 15:17:20 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Use GFP_NOFS in kmalloc during
	localalloc window move
In-Reply-To: <1208556239-15691-1-git-send-email-sunil.mushran@oracle.com>
References: <1208556239-15691-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080418221720.GN31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 18, 2008 at 03:03:59PM -0700, Sunil Mushran wrote:
> kmalloc() during a localalloc window move can trigger the mm to prune
> the dcache which inturn can trigger the fs to delete an inode causing
> it start a recursive transaction.
> 
> The fix also makes the change in kmalloc during localalloc shutdown
> just to be safe.
> 
> Fixes oss bugzilla#901
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=901

Ok, putting this in git now.
	--Mark

--
Mark Fasheh
