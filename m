From: Jan Kara <jack@suse.cz>
Date: Mon, 14 Sep 2009 16:56:22 +0200
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
Message-ID: <20090914145622.GK24075@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  OCFS2 mount option 'acl' is a small trap for users. When xattr feature
is not enabled and 'acl' mount option is specified, it is just silently
cleared during mount. IMHO that's not a good behavior - when admin requests
ACLs and we are not able to provide them, we should just fail the mount.
The trap is even more dangerous because the mount command is not aware that
we've cleared the 'acl' mount option and thus it records in /etc/mtab that
the filesystem is mounted with 'acl' mount option. So the output of mount
command looks as if ACLs were really in use. The only way to find out they
are not is to look into /proc/mounts or to try to get/set some ACL.
  Attached patch makes the mount fail if 'acl' mount option is specified
but xattr feature is disabled.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Fail-the-mount-when-acl-mount-option-is-spe.patch
Type: text/x-patch
Size: 2512 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090914/bef0a2a5/attachment.bin 
