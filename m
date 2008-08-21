From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 23:26:09 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add an insertion check
	to	ocfs2_extent_tree_operations.
In-Reply-To: <48ACEF0D.2080304@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-10-git-send-email-joel.becker@oracle.com>
	<48ACEF0D.2080304@oracle.com>
Message-ID: <20080821062609.GF17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 12:29:01PM +0800, TaoMa wrote:
> Joel Becker wrote:
>> The op eo_sanity_check() was really a check on remove_right_path().
>> Let's call it eo_remove_check().  Let's add an eo_insert_check() that
>> can be called from ocfs2_insert_extent().
>>   
> eo_sanity_check is used to check inode, and I don't see there is any  
> hint of remove_right_path in this function although it is now only used  
> in ocfs2_remove_rightmost_path. And I have said in the previous  
> e-mail,it can be used in ocfs2_num_free_extents.

	As I pointed out there, ocfs2_num_free_extents() doesn't need
the check - the inode is safe coming in.  I suspect remove_right_path is
the same, though I didn't audit it as much.

> So I'd like to reserve the name and your add for insert_check is OK or  
> it can be moved to ocfs2_*_insert_extent.

	I purposely moved the ocfs2_insert_extent() check to the
_insert_check() helper function because ocfs2_*_insert_extent() go away
in patch 10.
	Check that out, and then let's discuss where sanity/remove_check
is needed.  Maybe we can remove it, or maybe we need to expand its
scope.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
