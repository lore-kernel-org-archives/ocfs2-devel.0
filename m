From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 30 Mar 2014 15:44:36 -0700
Subject: [Ocfs2-devel] [patch 1/8] ocfs2: alloc_dinode counts and group
	bitmap should	be update simultaneously
In-Reply-To: <20140319210959.8E1C531C1E1@corp2gmr1-1.hot.corp.google.com>
References: <20140319210959.8E1C531C1E1@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20140330224436.GB4488@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 19, 2014 at 02:09:59PM -0700, Andrew Morton wrote:
> From: Younger Liu <younger.liucn@gmail.com>
> Subject: ocfs2: alloc_dinode counts and group bitmap should be update simultaneously
> 
> Updating alloc_dinode counts in ocfs2_alloc_dinode_update_counts() and
> setting group bitmap in ocfs2_alloc_dinode_update_bitmap() have to be done
> simultaneously.  Two cases are as follow:
> 
> (1) If ocfs2_alloc_dinode_update_counts() fails, there is no need to
>     set group bitmap.  This case has been considered.
> 
> (2) If ocfs2_alloc_dinode_update_bitmap() fails, alloc_dinode counts
>     should be rolled back.  Otherwise, some clusters would never be used. 
>     This case is not considered.
> 
> So, we combine two functions, and ensure simultaneity.

By 'ocfs2_alloc_dinode_update_bitmap' above, you mean
ocfs2_block_group_set_bits() correct? I am going under that assumption.


Anyway, I believe you're trying to fix a rare case where we might leak some
space in that our chain counts might be a bit high. Basically the call to
journal_access() in ocfs2_block_group_set_bits() has to fail. To be honest,
this has existed for a while and hasn't ever been an issue.

That said, we can fix it but I don't like that your approach changes core
bitmap handling code. Can you please do this by writing a simple fallback
function to set the correct values on the bitmap dinode? Have that called in
case of error from ocfs2_block_group_set_bits(). It doesn't need to make
journal calls because that has already been set up for it so this is
literally a couple lines of code.

If you like, you can take the pattern of:

call ocfs2_alloc_dinode_update_counts()
call ocfs2_block_group_set_bits()
if (error)
   call ocfs2_rollback_alloc_dinode_counts()
   ...

And put that into a master function.

Thanks,
	--Mark


--
Mark Fasheh
