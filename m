From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Dec 2008 13:40:12 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Always update xattr search when
	creating bucket.
In-Reply-To: <1228439650-5101-1-git-send-email-tao.ma@oracle.com>
References: <1228439650-5101-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081216214012.GY8791@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 05, 2008 at 09:14:10AM +0800, Tao Ma wrote:
> When we create xattr bucket during the process of xattr set, we always
> need to update the ocfs2_xattr_search since even if the bucket size is
> the same as block size, the offset will change because of the removal
> of the ocfs2_xattr_block header.

Ok, this is in the fixes branch now. I will send it upstream tommorrow. By
the way - am I correct in that merge_window seems to have fixed this
already?
	--Mark

--
Mark Fasheh
