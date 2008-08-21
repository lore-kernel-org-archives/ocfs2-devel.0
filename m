From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 11:45:56 +0800
Subject: [Ocfs2-devel] [PATCH 0/10] Make ocfs2_extent_tree a first-class
	object
In-Reply-To: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACE4F4.4000000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The new xattr code introduced a great abstraction, ocfs2_extent_tree.
> However, it's hidden in alloc.c.  Tao said he wanted to keep it there,
> but I think it works great as a first-class object.
>
> Callers into alloc.c can just fill in an ocfs2_extent_tree with the
> appropriate ocfs2_get_*_extent_tree() function, then pass it to all
> alloc.c functions.  Those functions no longer need individual root_bh,
> root_el, et_type, or void*private arguments.  People filling in dinode
> extent trees don't even need to pass NULL for that private.
>
> The series first adds structure prefixes to ocfs2_extent_tree and
> ocfs2_extent_tree_operations.  Next, it turns 'private' into 'object',
> calculating object as bh->b_data if it was NULL.  Third, we calculate
> the other fields (root_el, max_leaf_extents) in operations rather than
> if blocks.  Finally, we remove the et_type, the if block, and start
> using extent trees as first class objects.
>
> Check out the last patch, which is really the payoff, to see what I'm
> going for.
>   
wow, you did such a quick job. ;)
I just put my modification(which is generated from your review) in my 
local branch and wait for a final send, but you have already sent them 
out. Awesome!
Then I will just need to review them.;)

Regards,
Tao
