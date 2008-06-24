From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 24 Jun 2008 16:16:49 +0200
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
Message-ID: <20080624141649.GH7621@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi,

I'd like an opinion on the following scenario:

process 1: 					process 2:
configfs_mkdir("A")
  attach_group("A")
    attach_item("A")
      d_instantiate("A")
    populate_groups("A")
      mutex_lock("A")
      attach_group("A/B")
        attach_item("A")
          d_instantiate("A/B")
						mkdir("A/B/C")
						  do_path_lookup("A/B/C", LOOKUP_PARENT)
						    ok
						  lookup_create("A/B/C")
						    mutex_lock("A/B")
						    ok
						  configfs_mkdir("A/B/C")
						    ok
      attach_group("A/C")
        attach_item("A/C")
          d_instantiate("A/C")
        populate_groups("A/C")
          mutex_lock("A/C")
          attach_group("A/C/D")
            attach_item("A/C/D")
              failure
          mutex_unlock("A/C")
          detach_groups("A/C")
            nothing to do
						mkdir("A/C/E")
						  do_path_lookup("A/C/E", LOOKUP_PARENT)
						    ok
						  lookup_create("A/C/E")
						    mutex_lock("A/C")
						    ok
						  configfs_mkdir("A/C/E")
						    ok
        detach_item("A/C")
        d_delete("A/C")
      mutex_unlock("A")
      detach_groups("A")
        mutex_lock("A/B")
        detach_group("A/B")
	  detach_groups("A/B")
	    nothing since no _default_ group
          detach_item("A/B")
        mutex_unlock("A/B")
        d_delete("A/B")
    detach_item("A")
    d_delete("A")

Two bugs (if the scenario is possible):

1/ "A/B/C" and "A/C/E" are created, but never removed while their parent are
removed in the end.

2/ "A" and "A/C" inodes are not locked while detach_item() is called on them,
   which may probably confuse VFS.

Is there something that prevents such scenario? I'd say that once dentries
are instantiated, the dcache does not need to lock their inode to traverse them,
so the scenario is possible.

Where am I wrong?

If I'm right, two kinds of solutions for issue 1:
i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate, and
validate the whole group+default groups hierarchy in a second pass by clearing
CONFIGFS_USET_NEW

ii/ do not call d_instantiate() immediately in configfs_create() if called from
configfs_create_dir(), and d_instantitate() the group+default groups hierarchy
in a second pass. Problem: is it correct to add children to a dentry which is
not yet instantiated?

For issue 2/, locking the inode before calling detach_item() (as is done from
configfs_rmdir()), plus a solution for 1/ should be sufficient.

Thanks for your explanations.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/2b25cb23/attachment.bin 
