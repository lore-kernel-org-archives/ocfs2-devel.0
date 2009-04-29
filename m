From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Apr 2009 10:30:42 -0700
Subject: [Ocfs2-devel] Inode not orphaned
Message-ID: <20090429173041.GA11607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Anyone else seen this?

(25736,1):ocfs2_query_inode_wipe:882 ERROR: Inode 129047 (on-disk 129047) not orphaned! Disk flags  0x1, inode flags 0x80
(25736,1):ocfs2_delete_inode:1010 ERROR: status = -17

Test case is my patched version of ocfs2-test/programs/dirop_file_racer
that allows long filename prefixes.  I ran it on two nodes in separate
directories.  Filesystem has a 512B blocksize, and I specified a
filename prefix of 250 characters (thus brushing up against NAME_MAX and
forcing some longer symlinks out of the inode).

# PREFIX=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc ./racer.sh


Test was on ocfs2-ALL.  All features were turned on in mkfs except
indexed-dirs.

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: dirop-file-racer.patch
Type: text/x-diff
Size: 3243 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090429/b0b98ad7/attachment.bin 
