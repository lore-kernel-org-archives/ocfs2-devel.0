From: tristan <tristan.ye@oracle.com>
Date: Mon, 22 Mar 2010 10:58:49 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <20100320012748.GJ15539@mail.oracle.com>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
	<20100320012748.GJ15539@mail.oracle.com>
Message-ID: <4BA6DCE9.8040309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Mar 19, 2010 at 09:21:09AM +0800, Tristan Ye wrote:
>> Currently, some callers were missing to journal the dirty inode after
>> adding it to orphan dir.
>>
>> Now we're going to journal such modifications within the ocfs2_orphan_add()
>> itself, It's safe to do so, though some existing caller may duplicate this,
>> and it makes the logic look more straightforward anyway.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>
> 	This patch has been added to the 'fixes' branch of ocfs2.git.
> Can you go over the callers of ocfs2_orphan_add() to see if there is any
> cleanup you can do?  Redundant dirty calls where nothing else is
> dirtied, etc.  That cleanup will be a separate patch that I push to the
> merge window when done.

3 callers are calling ocfs2_orphan_add() for now:

1. ocfs2_unlink()

2. ocfs2_rename()

3. ocfs2_create_inode_in_orphan()


caller #1 and #2 are also doing dirty journals, they however are not 
redundant, just for i_links_count change on-disk.

while #3 caller is doing nothing dirty journal outside the 
ocfs2_oprhan_add(), it's fine.

As in, we're not going to do any cleanup in the callers.


Regards,
Tristan.


>
> Joel
>
