From: Andreas Dilger <adilger@dilger.ca>
Date: Tue, 7 Oct 2014 13:46:20 -0600
Subject: [Ocfs2-devel] [PATCH 03/12] xfs: Set allowed quota types
In-Reply-To: <20141007192935.GF30038@quack.suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
	<20141006203028.GB2301@dastard>
	<20141007192935.GF30038@quack.suse.cz>
Message-ID: <3391F66C-E2A7-4FC8-8696-3C1600D54DA9@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel <cluster-devel@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu

On Oct 7, 2014, at 1:29 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 07-10-14 07:30:28, Dave Chinner wrote:
>> On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
>>> We support user, group, and project quotas. Tell VFS about it.
>>> 
>>> CC: xfs at oss.sgi.com
>>> CC: Dave Chinner <david@fromorbit.com>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>> fs/xfs/xfs_super.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index b194652033cd..b32e998e8cbc 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
>>> 	sb->s_export_op = &xfs_export_operations;
>>> #ifdef CONFIG_XFS_QUOTA
>>> 	sb->s_qcop = &xfs_quotactl_operations;
>>> +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
>>> +				    (1 << PRJQUOTA);
>> 
>> Would it be better to define masks for these rather than open
>> coding these shifts everywhere?
>  I can do that. Any suggestion for a name? I was thinking about it for a
> while and couldn't come up with anything satisfactory...

Better to have QUOTA at the start, and TYPE in the name, so maybe:

enum quota_types {
	QUOTA_TYPE_USR = 1 << USRQUOTA,
	QUOTA_TYPE_GRP = 1 << GRPQUOTA,
	QUOTA_TYPE_PRJ = 1 << PRJQUOTA,
};

or maybe "enum quota_type_mask" or similar.

I prefer named enums over #defines since this makes it more clear
when declaring variables like "allowed_types" what valid values are
instead of just "int" that someone might mistakenly set to USRQUOTA
directly or something.

Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 833 bytes
Desc: Message signed with OpenPGP using GPGMail
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20141007/c17bf453/attachment.bin 
