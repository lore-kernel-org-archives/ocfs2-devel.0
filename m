From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 12 Nov 2008 13:23:02 -0800
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2/xattr: transaction merge patch
	set. v3
In-Reply-To: <491A91E3.7010408@oracle.com>
References: <491A91E3.7010408@oracle.com>
Message-ID: <20081112212302.GC8378@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 12, 2008 at 04:20:51PM +0800, Tao Ma wrote:
> Mark,
> 	Since Joel and you have already reviewed this patch set, I'd like 
> 	you to push these patches to merge_window now. So I can ask tristan to pull 
> from your branch and do some test on this ASAP(actually I have already 
> done some, but I'd like to hear the voice of the really testers :)). 
> Another side effect is that Joel may need this for his bucket work on 
> the new _set() path. And what's more, tiger's acl can base on your 
> merge_window directly now.


Yep, this all looks good. It's in the merge_window branch now, along with
Joel's bucket patches.
        --Mark

--
Mark Fasheh
