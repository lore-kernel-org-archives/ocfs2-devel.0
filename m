From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Jan 2009 23:06:35 +0100
Subject: [Ocfs2-devel] Bug in inode deletion code leading to stale inodes
Message-ID: <20090112220635.GD31811@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  I've hit a bug in OCFS2 delete code which results in inodes being left on
disk without any links to them. The workload triggering this creates
directories on one node and deletes them on another node in the cluster.
The inode is not deleted because both nodes bail out from
ocfs2_delete_inode() with:
Skipping delete of 100405 because it is in use on other nodes

  The scenario which I think is happening is as follows:

  node1					node2
					rmdir("d");
					  ocfs2_remote_dentry_delete()
  ocfs2_dentry_convert_worker()
					  finishes ocfs2_unlink()
					  eventually enters ocfs2_delete_inode()
					    ocfs2_inode_lock()
					    ocfs2_query_inode_wipe() -> fail
					    ocfs2_inode_unlock()
  ocfs2_dentry_post_unlock()
    ocfs2_drop_dentry_lock()
      iput()
       ocfs2_delete_inode()
         ocfs2_inode_lock()
	 ocfs2_query_inode_wipe() -> fail
	 ocfs2_inode_unlock()
         clear_inode()
					    clear_inode()

  The question is how to avoid this. It seems to me that we have to really
do open_lock() and not just trylock to avoid the race. Is there any reason
why we cannot move the open_lock() before inode_lock() in
ocfs2_delete_inode()?

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
